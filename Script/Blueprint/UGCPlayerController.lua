---@class UGCPlayerController_C:BP_UGCPlayerController_C
--Edit Below--
local UGCPlayerController = {}

--[[
    模块定位（方案A 模块一/二/四/五）：
    1) 模块一/二：玩家输入 -> 服务端触发火焰技能
    2) 模块四：客户端UI就绪后，请求服务端开启Boss倒计时（测试开关）
    3) 模块五：点击Boss按钮后，服务端把当前玩家传送到 BossEntry（同会话）

    设计原则：
    - 所有会改动游戏状态的行为均在服务端执行
    - 客户端函数只做输入与RPC发起
    - 技能挂载（AddSkillByClass）与施法分离；进图预挂载
    - 施法默认走 PersistEffect 原生 T/HUD；fire_input_tags 非空时才绑 Lua RPC 施法
    - 进图挂载入口：Pawn BeginPlay(服务端) / PC BeginPlay(服务端) / 客户端 RPC 三条并行
    - 技能挂载在 PlayerController（AddSkillByClass 需 PC 取 Pawn Actor）；Pawn 仅作 BeginPlay 触发
]]

local pve_config = UGCGameSystem.UGCRequire("Script.Common.pve_config")

---@field private fire_skill_instance any @服务端缓存的 PersistEffect 技能实例，挂载后复用
---@field private fire_mount_requested boolean @客户端是否已发过 InitFireSkill RPC，防重复
---@field private fire_mount_retry_delegate any @服务端挂载失败时的重试定时器委托
---@field private boss_main_ui UI01_C @【仅客户端】Boss 挑战主界面 Widget
---@field private ui_retry_delegate any @【仅客户端】UI 创建失败时的重试定时器委托
---@field private dev_start_requested boolean @【仅客户端】Dev 模式是否已发过开倒计时 RPC

local function log(...)
    if pve_config.debug_log then
        ugcprint("[UGCPlayerController]", ...)
    end
end

-- =============================================================================
-- 模块一/二：火焰技能 —— 挂载（服务端）与可选 Lua 施法 RPC
-- =============================================================================

---@return UGCPlayerPawn_C|nil
local function get_player_pawn(self)
    return UGCGameSystem.GetPlayerPawnByPlayerController(self)
end

-- 服务端权威：LoadClass + AddSkillByClass 挂到 Pawn Actor，实例缓存在 PC。
---@return boolean
function UGCPlayerController:EnsureFireSkillMounted()
    if not UGCGameSystem.IsServer() then
        return false
    end

    if self.fire_skill_instance ~= nil then
        return true
    end

    local player_pawn = get_player_pawn(self)
    if player_pawn == nil then
        log("EnsureFireSkillMounted failed: player_pawn nil")
        return false
    end

    local full_class_path = UGCMapInfoLib.GetRootLongPackagePath() .. pve_config.fire_skill_class_path
    local skill_class = UGCObjectUtility.LoadClass(full_class_path)
    if skill_class == nil then
        log("EnsureFireSkillMounted LoadClass failed:", full_class_path)
        return false
    end

    local skill_slot = pve_config.fire_skill_slot
    if skill_slot ~= nil and skill_slot ~= "" then
        self.fire_skill_instance = UGCPersistEffectSystem.AddSkillByClass(
            player_pawn, skill_class, nil, skill_slot)
    else
        self.fire_skill_instance = UGCPersistEffectSystem.AddSkillByClass(player_pawn, skill_class)
    end

    if self.fire_skill_instance == nil then
        log("EnsureFireSkillMounted AddSkillByClass failed")
        return false
    end

    log("fire skill instance created")
    return true
end

function UGCPlayerController:TryMountFireSkillOnServer()
    if not UGCGameSystem.IsServer() then
        return
    end

    if self:EnsureFireSkillMounted() then
        self:StopFireSkillMountRetry()
        return
    end

    self:StartFireSkillMountRetry()
end

function UGCPlayerController:StartFireSkillMountRetry()
    if self.fire_mount_retry_delegate ~= nil then
        return
    end

    self.fire_mount_retry_delegate = ObjectExtend.CreateDelegate(self, function()
        if self:EnsureFireSkillMounted() then
            self:StopFireSkillMountRetry()
        end
    end)

    local retry_seconds = pve_config.fire_skill_mount_retry_seconds or 0.1
    if retry_seconds < 0.1 then
        retry_seconds = 0.1
    end
    KismetSystemLibrary.K2_SetTimerDelegateForLua(self.fire_mount_retry_delegate, self, retry_seconds, true)
end

function UGCPlayerController:StopFireSkillMountRetry()
    if self.fire_mount_retry_delegate then
        ObjectExtend.DestroyDelegate(self.fire_mount_retry_delegate)
        self.fire_mount_retry_delegate = nil
    end
end

function UGCPlayerController:GetAvailableServerRPCs()
    -- ServerRPC_InitFireSkill：客户端请求进图预挂载（仅 AddSkillByClass，不施法）
    return
    "RequestTravelToBossMap",
    "ServerRPC_InitFireSkill",
    "ServerRPC_TriggerFireSkill",
    "ServerRPC_DevStartBossChallenge"
end

-- BeginPlay 按端分叉：服务端尝试挂载；客户端绑可选输入 Tag + 发 Init RPC 兜底
function UGCPlayerController:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self)
    log("ReceiveBeginPlay")

    if UGCGameSystem.IsServer() then
        if pve_config.auto_mount_fire_skill_on_beginplay then
            self:TryMountFireSkillOnServer()
        end
        return
    end

    -- BindInputMapping：客户端把 fire_input_tags 绑到 OnFireInputTriggered；空表则走原生 T/HUD
    for _, tag_name in ipairs(pve_config.fire_input_tags) do
        local input_tag = UGCGameplayTagSystem.RequestGameplayTag(tag_name)
        if input_tag ~= nil then
            UGCInputSystem.BindInputMapping(self, input_tag, ETriggerEvent.Triggered, self.OnFireInputTriggered)
            log("BindInputMapping success:", tag_name)
        else
            log("RequestGameplayTag failed:", tag_name)
        end
    end
    -- fire_input_tags 为空时：不绑左键/攻击，一技能由引擎映射 TriggerActiveSkill(T) 触发预设槽位技能

    -- 客户端 RPC 兜底：晚于 Pawn/服务端 PC BeginPlay 时仍可触发挂载
    if pve_config.auto_mount_fire_skill_on_beginplay then
        self:RequestInitFireSkill()
    end

    if pve_config.debug_auto_fire_once then
        log("debug_auto_fire_once=true, trigger once")
        self:OnFireInputTriggered(nil, 0, 0, "debug_auto_fire_once")
    end

    if not self:TryInitBossUI() then
        self:StartInitUIRetry()
    end
end

-- 可选 Lua 输入回调（客户端）：fire_input_tags 非空时由 BindInputMapping 触发
function UGCPlayerController:OnFireInputTriggered(InputValue, ElapsedTime, TriggeredTime, InputTag)
    log("OnFireInputTriggered", tostring(InputTag))
    -- CallUnrealRPC：客户端 -> 服务端 ServerRPC_TriggerFireSkill（仅施法，不负责首次挂载）
    UnrealNetwork.CallUnrealRPC(self, self, "ServerRPC_TriggerFireSkill")
end

-- 客户端：进图预挂载请求，同一局只发一次 RPC
function UGCPlayerController:RequestInitFireSkill()
    if self.fire_mount_requested then
        return
    end
    self.fire_mount_requested = true

    log("RequestInitFireSkill rpc")
    UnrealNetwork.CallUnrealRPC(self, self, "ServerRPC_InitFireSkill")
end

-- RPC 处理端（服务端）：客户端 RequestInitFireSkill 的落地，只挂载不施法
function UGCPlayerController:ServerRPC_InitFireSkill()
    if not UGCGameSystem.IsServer() then
        return
    end

    self:TryMountFireSkillOnServer()
end

-- RPC 处理端（服务端）：Lua 输入路径施法；正常玩法下 T/HUD 走 PersistEffect 原生链路
function UGCPlayerController:ServerRPC_TriggerFireSkill()
    if not UGCGameSystem.IsServer() then
        return
    end

    if not self:EnsureFireSkillMounted() then
        log("ServerRPC_TriggerFireSkill failed: skill not mounted")
        return
    end

    self.fire_skill_instance:ActivateSkill()
    log("fire skill activated")
end

-- =============================================================================
-- 模块四：Boss 挑战 UI（客户端）
-- =============================================================================

---@return boolean
function UGCPlayerController:TryInitBossUI()
    if self.boss_main_ui ~= nil then
        return true
    end

    local ui_class = UE.LoadClass(UGCMapInfoLib.GetRootLongPackagePath() .. "Asset/Blueprint/UI/UI01.UI01_C")
    if ui_class == nil then
        log("TryInitBossUI failed: ui_class nil")
        return false
    end

    self.boss_main_ui = UserWidget.NewWidgetObjectBP(self, ui_class)
    if self.boss_main_ui == nil then
        log("TryInitBossUI failed: NewWidgetObjectBP nil")
        return false
    end

    self.boss_main_ui:AddToViewport()
    local game_state = UGCGameSystem.GameState
    if game_state and self.boss_main_ui.BindGameState then
        self.boss_main_ui:BindGameState(game_state)
    end

    self:StopInitUIRetry()
    self:RefreshBossUIFromGameState()
    log("TryInitBossUI success")

    if pve_config.DEV_AUTO_START_COUNTDOWN and pve_config.DEV_AUTO_START_BY_CLIENT_READY ~= false then
        self:RequestDevStartBossChallenge()
    end
    return true
end

function UGCPlayerController:RequestDevStartBossChallenge()
    if self.dev_start_requested then
        return
    end
    self.dev_start_requested = true

    log("RequestDevStartBossChallenge rpc")
    UnrealNetwork.CallUnrealRPC(self, self, "ServerRPC_DevStartBossChallenge")
end

function UGCPlayerController:StartInitUIRetry()
    if self.ui_retry_delegate ~= nil then
        return
    end

    self.ui_retry_delegate = ObjectExtend.CreateDelegate(self, function()
        if self:TryInitBossUI() then
            self:StopInitUIRetry()
        end
    end)

    KismetSystemLibrary.K2_SetTimerDelegateForLua(self.ui_retry_delegate, self, 0.5, true)
end

function UGCPlayerController:StopInitUIRetry()
    if self.ui_retry_delegate then
        ObjectExtend.DestroyDelegate(self.ui_retry_delegate)
        self.ui_retry_delegate = nil
    end
end

function UGCPlayerController:RefreshBossUIFromGameState()
    if self.boss_main_ui == nil then
        self:TryInitBossUI()
    end

    local game_state = UGCGameSystem.GameState
    if game_state == nil or self.boss_main_ui == nil or not self.boss_main_ui.RefreshBossChallengeUI then
        return
    end

    local is_active = game_state.BossChallengeActive
    local countdown = game_state.BossCountdown or 0
    if is_active == nil then
        is_active = countdown > 0 and 1 or 0
    end

    self.boss_main_ui:RefreshBossChallengeUI(is_active, countdown)
end

function UGCPlayerController:RequestTravelToBossMap()
    if not UGCGameSystem.IsServer() then
        return
    end

    local map_boss = pve_config.MAP_BOSS or "/demo1/Map02"
    log("RequestTravelToBossMap RPC received on server ->", map_boss)

    local game_mode = UGCGameSystem.GameMode
    if game_mode and game_mode.CancelBossChallenge then
        game_mode:CancelBossChallenge()
    end

    local player_pawn = UGCGameSystem.GetPlayerPawnByPlayerController(self)
    if player_pawn == nil then
        log("RequestTravelToBossMap failed: player_pawn nil")
        return
    end

    local boss_entry_tag = pve_config.BOSS_ENTRY_TAG or "BossEntry"
    local tagged_actors = {}
    local gameplay_statics = UGameplayStatics or GameplayStatics
    if gameplay_statics == nil then
        log("RequestTravelToBossMap failed: UGameplayStatics/GameplayStatics both nil")
        return
    end

    local query_ok, query_err = pcall(function()
        gameplay_statics.GetAllActorsWithTag(self, boss_entry_tag, tagged_actors)
    end)

    if not query_ok then
        log("RequestTravelToBossMap failed: GetAllActorsWithTag error", tostring(query_err))
        return
    end

    local actor_count = #tagged_actors
    log("RequestTravelToBossMap BossEntry candidates=", tostring(actor_count))
    if actor_count <= 0 then
        log("RequestTravelToBossMap failed: no actor with tag", tostring(boss_entry_tag))
        return
    end

    local boss_level_name = tostring(map_boss)
    if type(map_boss) == "string" then
        local parsed_name = string.match(map_boss, ".*/([^/]+)$")
        if parsed_name and parsed_name ~= "" then
            boss_level_name = parsed_name
        end
    end

    local target_actor = nil
    for _, actor in ipairs(tagged_actors) do
        local level_name = ""
        local level_ok = pcall(function()
            level_name = actor:GetLevelName() or ""
        end)
        if level_ok then
            log("RequestTravelToBossMap candidate level=", tostring(level_name))
            if boss_level_name ~= "" and string.find(level_name, boss_level_name, 1, true) then
                target_actor = actor
                break
            end
        end
    end

    if target_actor == nil then
        target_actor = tagged_actors[1]
        log("RequestTravelToBossMap fallback first BossEntry actor")
    end

    if target_actor == nil then
        log("RequestTravelToBossMap failed: target_actor nil after selection")
        return
    end

    local dest_location = target_actor:K2_GetActorLocation()
    local dest_rotation = target_actor:K2_GetActorRotation()

    local teleported = false
    local tele_ok, tele_err = pcall(function()
        teleported = player_pawn:K2_TeleportTo(dest_location, dest_rotation)
    end)

    if not tele_ok then
        log("RequestTravelToBossMap failed: K2_TeleportTo error", tostring(tele_err))
        return
    end

    if not teleported then
        local sweep_hit = nil
        local set_ok, set_err = pcall(function()
            teleported = player_pawn:K2_SetActorLocationAndRotation(dest_location, dest_rotation, false, sweep_hit, true)
        end)
        if not set_ok then
            log("RequestTravelToBossMap failed: SetActorLocationAndRotation error", tostring(set_err))
            return
        end
    end

    if teleported then
        log("RequestTravelToBossMap success: teleported to BossEntry tag=", tostring(boss_entry_tag))
    else
        log("RequestTravelToBossMap failed: teleport returned false")
    end
end

function UGCPlayerController:ServerRPC_DevStartBossChallenge()
    if not UGCGameSystem.IsServer() then
        return
    end

    if not pve_config.DEV_AUTO_START_COUNTDOWN then
        return
    end

    local game_mode = UGCGameSystem.GameMode
    if game_mode and game_mode.StartBossChallenge then
        game_mode:StartBossChallenge(nil)
        log("ServerRPC_DevStartBossChallenge -> StartBossChallenge")
    else
        log("ServerRPC_DevStartBossChallenge failed: game_mode or StartBossChallenge missing")
    end
end

return UGCPlayerController
