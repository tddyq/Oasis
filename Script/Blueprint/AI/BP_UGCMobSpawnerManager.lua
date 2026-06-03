---@class BP_UGCMobSpawnerManager_C:AUGCMobSpawnerManager
local BP_UGCMobSpawnerManager = {}

--[[
    模块定位（方案A 模块三）：
    1) 监听刷怪器管理器生命周期事件（波次开始、结束、全灭）
    2) 当所有怪物死亡时，向 GameState 发送“进入Boss挑战倒计时”的信号
    3) 本脚本只跑在服务器，客户端直接 return，避免重复触发
]]

function BP_UGCMobSpawnerManager:ReceiveBeginPlay()
    BP_UGCMobSpawnerManager.SuperClass.ReceiveBeginPlay(self)
    if UGCGameSystem.IsServer() then
        print("[BP_UGCMobSpawnerManager] ReceiveBeginPlay")
    end
end

---@param MobPawn AActor
function BP_UGCMobSpawnerManager:OnMobSpawn(MobPawn)
    -- 只有服务端维护怪物权威状态；客户端不参与刷怪统计
    if not UGCGameSystem.IsServer() then
        return
    end

    local mob_name = "nil"
    if MobPawn then
        mob_name = MobPawn.GetName and MobPawn:GetName() or tostring(MobPawn)
    end
    print(string.format("[BP_UGCMobSpawnerManager] OnMobSpawn mob=%s", tostring(mob_name)))
end

---@param WaveIndex int32
function BP_UGCMobSpawnerManager:OnWaveStart(WaveIndex)
    -- 波次日志用于排查“为什么没刷怪/刷怪顺序不对”
    if not UGCGameSystem.IsServer() then
        return
    end
    print(string.format("[BP_UGCMobSpawnerManager] OnWaveStart wave=%s", tostring(WaveIndex)))
end

---@param WaveIndex int32
function BP_UGCMobSpawnerManager:OnWaveEnd(WaveIndex)
    if not UGCGameSystem.IsServer() then
        return
    end
    print(string.format("[BP_UGCMobSpawnerManager] OnWaveEnd wave=%s", tostring(WaveIndex)))
end

function BP_UGCMobSpawnerManager:OnAllWaveEnd()
    -- 仅表示“波次配置执行完”，不一定代表场上怪都死亡
    if not UGCGameSystem.IsServer() then
        return
    end
    print("[BP_UGCMobSpawnerManager] OnAllWaveEnd")
end

function BP_UGCMobSpawnerManager:OnAllMobDie()
    -- 注意：这是“所有已刷出怪物都死亡”的关键事件，
    -- 作为模块三 -> 模块四的衔接入口。
    if not UGCGameSystem.IsServer() then
        return
    end

    print("[BP_UGCMobSpawnerManager] OnAllMobDie - 清关事件触发")

    local game_state = UGCGameSystem.GameState
    if game_state and game_state.StartBossChallenge then
        -- 把当前 spawner_manager 传给 GameState，便于后续循环重刷时直接复用
        game_state:StartBossChallenge(self)
    else
        print("[BP_UGCMobSpawnerManager] StartBossChallenge missing on GameState")
    end
end

return BP_UGCMobSpawnerManager