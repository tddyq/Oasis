---@class UGCGameState_C:BP_UGCGameState_C
--Edit Below--
UGCGameSystem.UGCRequire('Script.Common.ue_enum_custom')
local UGCGameState = {}

--[[
    模块定位（方案A 模块四）：
    - 仅持有并复制 Boss 挑战可见状态（BossChallengeActive / BossCountdown）
    - OnRep 转发至 UGCPlayerController 刷新 UI01
    - 服务端规则（倒计时、循环重刷）在 UGCGameMode
]]

---@field public BossCountdown integer @【复制】剩余秒数
---@field public BossChallengeActive integer @【复制】1=显示 Boss 按钮与倒计时，0=隐藏

function UGCGameState:GetReplicatedProperties()
    return
    "BossCountdown",
    "BossChallengeActive"
end

---@param is_active integer
---@param countdown integer
function UGCGameState:SetBossChallengeState(is_active, countdown)
    self.BossChallengeActive = is_active
    self.BossCountdown = countdown
end

local function notify_local_player_ui(game_state)
    local player_controller = UGCGameSystem.GetLocalPlayerController()
    if player_controller == nil and game_state ~= nil then
        player_controller = GameplayStatics.GetPlayerController(game_state, 0)
    end
    if player_controller and player_controller.RefreshBossUIFromGameState then
        player_controller:RefreshBossUIFromGameState()
    end
end

function UGCGameState:OnRep_BossCountdown()
    print("[UGCGameState] OnRep_BossCountdown", self.BossCountdown)
    notify_local_player_ui(self)
end

function UGCGameState:OnRep_BossChallengeActive()
    print("[UGCGameState] OnRep_BossChallengeActive", self.BossChallengeActive)
    notify_local_player_ui(self)
end

return UGCGameState
