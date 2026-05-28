---@class UGCPlayerPawn_C:BP_UGCPlayerPawn_C
--Edit Below--
local UGCPlayerPawn = {}

-- 声明Lua侧需要网络复制的属性名列表。
-- 该函数返回的字段会参与服务端到客户端的同步流程。
-- 当前仅保留项目已使用字段：
-- - __SubObjectRepList：子对象复制列表（引擎/框架侧常用）
-- - Lazy：现有脚本保留字段，避免破坏既有复制行为
function UGCPlayerPawn:GetReplicatedProperties()
    return {"__SubObjectRepList", "Lazy"}
end

return UGCPlayerPawn