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
]]

-- 运行时配置模块：
-- - fire_skill_class_path：主火焰技能蓝图类路径
-- - fire_input_tags：触发技能的输入Tag数组
-- - debug_auto_fire_once / debug_log：调试开关
local pve_config = UGCGameSystem.UGCRequire("Script.Common.pve_config")

-- 统一日志函数，便于在日志中过滤 [UGCPlayerController] 前缀。
-- 当 pve_config.debug_log 为 false 时，此函数不输出日志。
local function log(...)
    if pve_config.debug_log then
        ugcprint("[UGCPlayerController]", ...)
    end
end

-- 声明“允许客户端调用到服务端”的RPC函数白名单。
-- 注意：这里要返回多个字符串值，不能写成一个逗号拼接的大字符串。
function UGCPlayerController:GetAvailableServerRPCs()
    -- 关键修复：必须返回“多值”，不是一个逗号拼接字符串
    -- 若白名单缺失，对应 RPC 即使函数存在也不会被远端调用。
    return
    "RequestTravelToBossMap",
    "ServerRPC_TriggerFireSkill",
    "ServerRPC_DevStartBossChallenge"
end

-- PlayerController初始化回调（BeginPlay）：
-- 1) 先调用父类，保证蓝图基础初始化流程正常
-- 2) 仅客户端执行输入绑定，服务端直接返回
-- 3) 读取配置中的输入Tag并绑定到 OnFireInputTriggered
-- 4) 可选执行“自动触发一次技能”用于调试链路
function UGCPlayerController:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self)
    log("ReceiveBeginPlay")

    if UGCGameSystem.IsServer() then
        return
    end

    -- 遍历配置中的输入Tag：
    -- 每个Tag都会绑定同一个回调函数，方便统一处理技能触发。
    for _, tag_name in ipairs(pve_config.fire_input_tags) do
        local input_tag = UGCGameplayTagSystem.RequestGameplayTag(tag_name)
        if input_tag ~= nil then
            -- ETriggerEvent.Triggered 表示输入动作达到触发态时回调。
            UGCInputSystem.BindInputMapping(self, input_tag, ETriggerEvent.Triggered, self.OnFireInputTriggered)
            log("BindInputMapping success:", tag_name)
        else
            -- 如果Tag请求失败，通常是Tag名称写错或项目中未注册。
            log("RequestGameplayTag failed:", tag_name)
        end
    end

    -- 调试开关：用于验证输入/网络/技能链路是否连通。
    -- 生产配置建议保持 false，避免进图自动施法。
    if pve_config.debug_auto_fire_once then
        log("debug_auto_fire_once=true, trigger once")
        self:OnFireInputTriggered(nil, 0, 0, "debug_auto_fire_once")
    end
end

-- 输入触发回调（客户端执行）。
-- 参数由输入系统传入：
-- - InputValue：输入值（按键/轴等）
-- - ElapsedTime：输入持续时间
-- - TriggeredTime：触发时间
-- - InputTag：触发本次回调的GameplayTag
-- 本函数只负责“发起RPC请求”，真正的技能创建与激活在服务端执行。
function UGCPlayerController:OnFireInputTriggered(InputValue, ElapsedTime, TriggeredTime, InputTag)
    log("OnFireInputTriggered", tostring(InputTag))
    UnrealNetwork.CallUnrealRPC(self, self, "ServerRPC_TriggerFireSkill")
end

-- 示例RPC：客户端请求服务端切换关卡。
-- 保留该函数便于验证RPC白名单机制是否工作正常。
function UGCPlayerController:RequestTravelToBossMap()
    -- 只允许服务端执行，避免客户端直接改位置导致状态不一致
    if not UGCGameSystem.IsServer() then
        return
    end

    local map_boss = pve_config.MAP_BOSS or "/demo1/Map02"
    log("RequestTravelToBossMap RPC received on server ->", map_boss)

    -- 点击挑战后先取消倒计时UI，防止按钮/数字残留在新阶段
    local game_state = UGCGameSystem.GameState
    if game_state and game_state.CancelBossChallenge then
        game_state:CancelBossChallenge()
    end

    -- 子关卡方案：
    -- 保持在 UGCMap 同一会话，不做 Travel；
    -- 通过 Tag 查找 Boss 入口点并传送当前玩家 Pawn。
    -- 这样能避免“子关卡切换导致重生流程不完整”的黑屏/观战态问题。
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

    -- 使用 pcall 包裹引擎调用，防止运行时绑定差异导致脚本中断。
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

    -- 优先挑选位于 Boss 子关卡中的入口点；找不到再兜底第一个Tag点。
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
        -- 兜底：某些运行时下 K2_TeleportTo 返回 false，但 SetActorLocationAndRotation 仍可成功
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

-- 核心技能RPC（服务端权威逻辑）：
-- 1) 根据Controller获取对应PlayerPawn
-- 2) 若技能实例不存在，则按配置路径加载技能类并添加到Pawn
-- 3) 调用 ActivateSkill 触发本次技能释放
-- 采用“首次创建、后续复用”的方式，减少重复创建开销。
function UGCPlayerController:ServerRPC_TriggerFireSkill()
    -- 服务端权威：只在服务端创建/激活技能实例，避免客户端伪造技能状态
    local player_pawn = UGCGameSystem.GetPlayerPawnByPlayerController(self)
    if player_pawn == nil then
        log("ServerRPC_TriggerFireSkill failed: player_pawn is nil")
        return
    end

    if self.fire_skill_instance == nil then
        -- 拼接项目根包路径 + 配置相对路径，得到可加载的完整类路径。
        local full_class_path = UGCMapInfoLib.GetRootLongPackagePath() .. pve_config.fire_skill_class_path
        local skill_class = UGCObjectUtility.LoadClass(full_class_path)
        if skill_class == nil then
            log("LoadClass failed:", full_class_path)
            return
        end

        -- 将PersistEffect技能类动态挂载到玩家Pawn上，返回技能实例。
        self.fire_skill_instance = UGCPersistEffectSystem.AddSkillByClass(player_pawn, skill_class)
        if self.fire_skill_instance == nil then
            log("AddSkillByClass failed")
            return
        end
        log("fire skill instance created")
    end

    -- 触发技能执行（进入技能蓝图时间线/阶段）。
    self.fire_skill_instance:ActivateSkill()
    log("fire skill activated")
end

-- 模块四独立测试：客户端UI就绪后请求DS开启Boss倒计时
function UGCPlayerController:ServerRPC_DevStartBossChallenge()
    -- 仅用于开发联调：
    -- 客户端UI确认可见后，再通知服务端启动倒计时，避免“倒计时先跑完，UI还没建好”的问题。
    if not UGCGameSystem.IsServer() then
        return
    end

    if not pve_config.DEV_AUTO_START_COUNTDOWN then
        return
    end

    local game_state = UGCGameSystem.GameState
    if game_state and game_state.StartBossChallenge then
        game_state:StartBossChallenge(nil)
        log("ServerRPC_DevStartBossChallenge -> StartBossChallenge")
    else
        log("ServerRPC_DevStartBossChallenge failed: game_state or StartBossChallenge missing")
    end
end

return UGCPlayerController