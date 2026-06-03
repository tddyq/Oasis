---@class UGCGameState_C:BP_UGCGameState_C
UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
local UGCGameState = {}

local pve_config = UGCGameSystem.UGCRequire("Script.Common.pve_config")

--[[
    模块定位（方案A 模块四 + 循环扩展）：
    A. 管理 Boss 挑战倒计时状态（BossChallengeActive / BossCountdown）
    B. 通过复制变量驱动客户端 UI 刷新
    C. 在倒计时超时后触发“小怪循环重刷”（可配置）

    状态流（服务器）：
    OnAllMobDie -> StartBossChallenge -> TickBossCountdown -> OnBossChallengeTimeout -> RestartMobLoop
]]

---@field public BossCountdown integer
---@field public BossChallengeActive integer
---@field private countdown_delegate any
---@field private ui_retry_delegate any
---@field private main_ui UI01_C
---@field private dev_start_requested boolean
---@field private active_spawner_manager AUGCMobSpawnerManager|nil
---@field private respawn_delegate any

-- 关键修正：按官方文档，返回“多值”，不要返回table
function UGCGameState:GetReplicatedProperties()
    return
    "BossCountdown",
    "BossChallengeActive"
end

function UGCGameState:ReceiveBeginPlay()
    -- 服务器：仅处理“开发模式自动开倒计时”的入口，不创建UI
    if self:HasAuthority() then
        if pve_config.DEV_AUTO_START_COUNTDOWN then
            -- 推荐模式：等待客户端UI就绪后，通过RPC请求DS开始倒计时，避免客户端进入慢导致看不到UI
            if pve_config.DEV_AUTO_START_BY_CLIENT_READY ~= false then
                print("[UGCGameState] DEV auto start waiting client-ready RPC")
            else
                local delay_seconds = pve_config.DEV_AUTO_START_DELAY_SECONDS or 30
                if delay_seconds < 0.1 then
                    delay_seconds = 0.1
                end
                local dev_delegate = ObjectExtend.CreateDelegate(self, function()
                    print("[UGCGameState] DEV auto StartBossChallenge")
                    self:StartBossChallenge(nil)
                end)
                print("[UGCGameState] DEV auto start delay=" .. tostring(delay_seconds))
                KismetSystemLibrary.K2_SetTimerDelegateForLua(dev_delegate, self, delay_seconds, false)
            end
        end
        return
    end

    -- 客户端：负责初始化主UI并绑定GameState
    -- 客户端先尝试创建UI；若时机太早失败，启动重试
    if not self:TryInitMainUI() then
        self:StartInitUIRetry()
    end
end

function UGCGameState:TryInitMainUI()
    -- 幂等：UI已存在则直接成功
    if self.main_ui ~= nil then
        return true
    end

    local ui_class = UE.LoadClass(UGCMapInfoLib.GetRootLongPackagePath() .. "Asset/Blueprint/UI/UI01.UI01_C")
    if ui_class == nil then
        print("[UGCGameState] TryInitMainUI failed: ui_class nil")
        return false
    end

    local player_controller = UGCGameSystem.GetLocalPlayerController()
    if player_controller == nil then
        player_controller = GameplayStatics.GetPlayerController(self, 0)
    end
    if player_controller == nil then
        print("[UGCGameState] TryInitMainUI failed: player_controller nil")
        return false
    end

    self.main_ui = UserWidget.NewWidgetObjectBP(player_controller, ui_class)
    if self.main_ui == nil then
        print("[UGCGameState] TryInitMainUI failed: NewWidgetObjectBP nil")
        return false
    end

    self.main_ui:AddToViewport()
    if self.main_ui.BindGameState then
        self.main_ui:BindGameState(self)
    end

    self:StopInitUIRetry()
    self:NotifyUIRefresh()
    print("[UGCGameState] TryInitMainUI success")

    -- 独立测试模式：客户端UI初始化完成后再请求服务端开启倒计时
    if pve_config.DEV_AUTO_START_COUNTDOWN and pve_config.DEV_AUTO_START_BY_CLIENT_READY ~= false then
        self:RequestDevStartBossChallenge()
    end
    return true
end

function UGCGameState:RequestDevStartBossChallenge()
    -- 防重入：同一局仅请求一次，避免客户端重试造成多次RPC
    if self.dev_start_requested then
        return
    end
    self.dev_start_requested = true

    local player_controller = UGCGameSystem.GetLocalPlayerController()
    if player_controller == nil then
        player_controller = GameplayStatics.GetPlayerController(self, 0)
    end
    if player_controller == nil then
        print("[UGCGameState] RequestDevStartBossChallenge failed: player_controller nil")
        return
    end

    print("[UGCGameState] RequestDevStartBossChallenge rpc")
    UnrealNetwork.CallUnrealRPC(player_controller, player_controller, "ServerRPC_DevStartBossChallenge")
end

function UGCGameState:StartInitUIRetry()
    -- UI创建常见失败原因：客户端初期 LocalPlayerController 还没准备好
    -- 因此用短周期重试，直到 TryInitMainUI 成功。
    if self.ui_retry_delegate ~= nil then
        return
    end

    self.ui_retry_delegate = ObjectExtend.CreateDelegate(self, function()
        if self:TryInitMainUI() then
            self:StopInitUIRetry()
        end
    end)

    KismetSystemLibrary.K2_SetTimerDelegateForLua(self.ui_retry_delegate, self, 0.5, true)
end

function UGCGameState:StopInitUIRetry()
    -- 重试一旦成功就销毁委托，避免空转计时器
    if self.ui_retry_delegate then
        ObjectExtend.DestroyDelegate(self.ui_retry_delegate)
        self.ui_retry_delegate = nil
    end
end

---@param spawner_manager AUGCMobSpawnerManager|nil
function UGCGameState:StartBossChallenge(spawner_manager)
    if not UGCGameSystem.IsServer() then
        return
    end

    -- 记录当前触发倒计时的刷怪管理器，供倒计时结束后自动重开使用
    if spawner_manager ~= nil then
        self.active_spawner_manager = spawner_manager
    end

    if self.BossChallengeActive == 1 then
        -- 已处于倒计时中，忽略重复触发
        return
    end

    self.BossChallengeActive = 1
    self.BossCountdown = pve_config.BOSS_COUNTDOWN_SECONDS
    print("[UGCGameState] StartBossChallenge countdown=", self.BossCountdown)
    self:StartCountdownTimer()
end

function UGCGameState:StartCountdownTimer()
    -- 每次启动前先停旧Timer，防止并发计时器导致秒数跳变
    self:StopCountdownTimer()
    self.countdown_delegate = ObjectExtend.CreateDelegate(self, function()
        self:TickBossCountdown()
    end)
    KismetSystemLibrary.K2_SetTimerDelegateForLua(self.countdown_delegate, self, 1.0, true)
end

function UGCGameState:TickBossCountdown()
    if self.BossCountdown <= 0 then
        return
    end

    self.BossCountdown = self.BossCountdown - 1
    print("[UGCGameState] BossCountdown=", self.BossCountdown)

    if self.BossCountdown <= 0 then
        self:OnBossChallengeTimeout()
    end
end

function UGCGameState:OnBossChallengeTimeout()
    -- 倒计时结束后：
    -- 1) 隐藏Boss按钮/数字
    -- 2) 如启用循环，重置刷怪管理器并开新一轮
    print("[UGCGameState] OnBossChallengeTimeout")
    self:StopCountdownTimer()
    self.BossChallengeActive = 0
    self.BossCountdown = 0

    if UGCGameSystem.IsServer() and pve_config.LOOP_ENABLE then
        self:RestartMobLoop()
    end
end

function UGCGameState:CancelBossChallenge()
    -- 外部（如按钮点击进入Boss阶段）可主动取消倒计时UI
    if not UGCGameSystem.IsServer() then
        return
    end
    self:StopCountdownTimer()
    self.BossChallengeActive = 0
    self.BossCountdown = 0
end

function UGCGameState:StopCountdownTimer()
    -- 统一的计时器回收入口，避免悬空委托继续触发
    if self.countdown_delegate then
        ObjectExtend.DestroyDelegate(self.countdown_delegate)
        self.countdown_delegate = nil
    end
end

function UGCGameState:RestartMobLoop()
    -- 循环逻辑只在服务端执行，客户端只收复制结果
    if not UGCGameSystem.IsServer() then
        return
    end

    local spawner_manager = self.active_spawner_manager
    if spawner_manager == nil then
        print("[UGCGameState] RestartMobLoop skipped: active_spawner_manager nil")
        return
    end

    local delay_seconds = pve_config.LOOP_RESPAWN_DELAY_SECONDS or 0
    if delay_seconds < 0 then
        delay_seconds = 0
    end

    local do_restart = function()
        -- 先重置再启动，确保波次索引/存活怪引用被清理到初始态
        local delete_mobs = pve_config.LOOP_RESET_DELETE_MOBS
        if delete_mobs == nil then
            delete_mobs = true
        end

        if spawner_manager.ResetSpawnerManager then
            spawner_manager:ResetSpawnerManager(delete_mobs)
        end

        if spawner_manager.StartSpawnerManager then
            spawner_manager:StartSpawnerManager()
            print("[UGCGameState] RestartMobLoop success")
        else
            print("[UGCGameState] RestartMobLoop failed: StartSpawnerManager missing")
        end
    end

    if delay_seconds <= 0 then
        -- 支持“立即重刷”模式
        do_restart()
        return
    end

    if self.respawn_delegate then
        ObjectExtend.DestroyDelegate(self.respawn_delegate)
        self.respawn_delegate = nil
    end

    self.respawn_delegate = ObjectExtend.CreateDelegate(self, function()
        do_restart()
        if self.respawn_delegate then
            ObjectExtend.DestroyDelegate(self.respawn_delegate)
            self.respawn_delegate = nil
        end
    end)

    KismetSystemLibrary.K2_SetTimerDelegateForLua(self.respawn_delegate, self, delay_seconds, false)
end

function UGCGameState:OnRep_BossCountdown()
    -- 客户端复制回调：秒数变化 -> 刷新UI数字
    print("[UGCGameState] OnRep_BossCountdown", self.BossCountdown)
    self:NotifyUIRefresh()
end

function UGCGameState:OnRep_BossChallengeActive()
    -- 客户端复制回调：显隐状态变化 -> 刷新UI可见性
    print("[UGCGameState] OnRep_BossChallengeActive", self.BossChallengeActive)
    self:NotifyUIRefresh()
end

function UGCGameState:NotifyUIRefresh()
    -- 防御式逻辑：若OnRep早于UI创建，先尝试补建UI再刷新
    if self.main_ui == nil then
        self:TryInitMainUI()
    end
    if self.main_ui and self.main_ui.RefreshBossChallengeUI then
        local is_active = self.BossChallengeActive
        local countdown = self.BossCountdown or 0

        -- 防止OnRep到达顺序不同导致一帧隐藏
        if is_active == nil then
            is_active = countdown > 0 and 1 or 0
        end

        self.main_ui:RefreshBossChallengeUI(is_active, countdown)
    end
end

return UGCGameState
