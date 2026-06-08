---@class UGCGameMode_C:BP_UGCGameBase_C
--Edit Below--
local UGCGameMode = {}

local pve_config = UGCGameSystem.UGCRequire("Script.Common.pve_config")

---@field private active_spawner_manager AUGCMobSpawnerManager|nil @【仅服务端】最近一次清关的刷怪管理器
---@field private countdown_delegate any @【仅服务端】Boss 倒计时 1 秒周期定时器委托
---@field private respawn_delegate any @【仅服务端】倒计时结束后延迟重刷的定时器委托

local function log(...)
    print("[UGCGameMode]", ...)
end

local function get_game_state()
    return UGCGameSystem.GameState
end

function UGCGameMode:ReceiveBeginPlay()
    if not self:HasAuthority() then
        return
    end

    if pve_config.DEV_AUTO_START_COUNTDOWN then
        if pve_config.DEV_AUTO_START_BY_CLIENT_READY ~= false then
            log("DEV auto start waiting client-ready RPC")
        else
            local delay_seconds = pve_config.DEV_AUTO_START_DELAY_SECONDS or 30
            if delay_seconds < 0.1 then
                delay_seconds = 0.1
            end
            local dev_delegate = ObjectExtend.CreateDelegate(self, function()
                log("DEV auto StartBossChallenge")
                self:StartBossChallenge(nil)
            end)
            log("DEV auto start delay=" .. tostring(delay_seconds))
            KismetSystemLibrary.K2_SetTimerDelegateForLua(dev_delegate, self, delay_seconds, false)
        end
    end
end

---@param spawner_manager AUGCMobSpawnerManager|nil
function UGCGameMode:StartBossChallenge(spawner_manager)
    if not UGCGameSystem.IsServer() then
        return
    end

    local game_state = get_game_state()
    if game_state == nil then
        log("StartBossChallenge failed: game_state nil")
        return
    end

    if spawner_manager ~= nil then
        self.active_spawner_manager = spawner_manager
    end

    if game_state.BossChallengeActive == 1 then
        return
    end

    game_state:SetBossChallengeState(1, pve_config.BOSS_COUNTDOWN_SECONDS)
    log("StartBossChallenge countdown=", pve_config.BOSS_COUNTDOWN_SECONDS)
    self:StartCountdownTimer()
end

function UGCGameMode:StartCountdownTimer()
    self:StopCountdownTimer()
    self.countdown_delegate = ObjectExtend.CreateDelegate(self, function()
        self:TickBossCountdown()
    end)
    KismetSystemLibrary.K2_SetTimerDelegateForLua(self.countdown_delegate, self, 1.0, true)
end

function UGCGameMode:TickBossCountdown()
    local game_state = get_game_state()
    if game_state == nil or game_state.BossCountdown <= 0 then
        return
    end

    local new_countdown = game_state.BossCountdown - 1
    game_state:SetBossChallengeState(game_state.BossChallengeActive, new_countdown)
    log("BossCountdown=", new_countdown)

    if new_countdown <= 0 then
        self:OnBossChallengeTimeout()
    end
end

function UGCGameMode:OnBossChallengeTimeout()
    log("OnBossChallengeTimeout")
    self:StopCountdownTimer()

    local game_state = get_game_state()
    if game_state then
        game_state:SetBossChallengeState(0, 0)
    end

    if UGCGameSystem.IsServer() and pve_config.LOOP_ENABLE then
        self:RestartMobLoop()
    end
end

function UGCGameMode:CancelBossChallenge()
    if not UGCGameSystem.IsServer() then
        return
    end

    self:StopCountdownTimer()
    local game_state = get_game_state()
    if game_state then
        game_state:SetBossChallengeState(0, 0)
    end
end

function UGCGameMode:StopCountdownTimer()
    if self.countdown_delegate then
        ObjectExtend.DestroyDelegate(self.countdown_delegate)
        self.countdown_delegate = nil
    end
end

function UGCGameMode:RestartMobLoop()
    if not UGCGameSystem.IsServer() then
        return
    end

    local spawner_manager = self.active_spawner_manager
    if spawner_manager == nil then
        log("RestartMobLoop skipped: active_spawner_manager nil")
        return
    end

    local delay_seconds = pve_config.LOOP_RESPAWN_DELAY_SECONDS or 0
    if delay_seconds < 0 then
        delay_seconds = 0
    end

    local do_restart = function()
        local delete_mobs = pve_config.LOOP_RESET_DELETE_MOBS
        if delete_mobs == nil then
            delete_mobs = true
        end

        if spawner_manager.ResetSpawnerManager then
            spawner_manager:ResetSpawnerManager(delete_mobs)
        end

        if spawner_manager.StartSpawnerManager then
            spawner_manager:StartSpawnerManager()
            log("RestartMobLoop success")
        else
            log("RestartMobLoop failed: StartSpawnerManager missing")
        end
    end

    if delay_seconds <= 0 then
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

return UGCGameMode
