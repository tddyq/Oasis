---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
--Edit Below--
local UGCPlayerPawn = {}

local pve_config = UGCGameSystem.UGCRequire("Script.Common.pve_config")

local function log(...)
    if pve_config.debug_log then
        ugcprint("[UGCPlayerPawn]", ...)
    end
end

--[[
    模块一/二（挂载触发点）：
    Pawn 服务端 BeginPlay 时委托 PlayerController 执行 AddSkillByClass。
    挂载实现与实例缓存均在 PC（GetPlayerPawnByPlayerController 返回的 Pawn 无 Lua 方法表）。
]]

function UGCPlayerPawn:ReceiveBeginPlay()
    UGCPlayerPawn.SuperClass.ReceiveBeginPlay(self)

    if not UGCGameSystem.IsServer() then
        return
    end

    if not pve_config.auto_mount_fire_skill_on_beginplay then
        return
    end

    local player_controller = UGCGameSystem.GetPlayerControllerByPlayerPawn(self)
    if player_controller == nil then
        log("ReceiveBeginPlay mount skipped: player_controller nil")
        return
    end

    if player_controller.TryMountFireSkillOnServer then
        log("ReceiveBeginPlay -> TryMountFireSkillOnServer")
        player_controller:TryMountFireSkillOnServer()
    else
        log("ReceiveBeginPlay mount skipped: TryMountFireSkillOnServer missing on PC")
    end
end

function UGCPlayerPawn:GetReplicatedProperties()
    return {"__SubObjectRepList", "Lazy"}
end

return UGCPlayerPawn
