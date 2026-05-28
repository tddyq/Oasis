---@class BP_MyFireRegion_C:BP_MagicFieldActorBase_C
-- 法术场蓝图中可能存在的关键组件声明（用于Lua智能提示）：
-- - 声音组件
-- - 碰撞体组件
-- - 粒子特效组件
---@field Play_UGC_PasssiveSkill_SoulBurn UAkComponent
---@field Box UBoxComponent
---@field ParticleSystem UParticleSystemComponent
--Edit Below--
local BP_MyFireRegion = {}
 
-- 说明：
-- 当前法术场行为主要由蓝图Task与编辑器配置驱动，
-- 因此以下生命周期函数保留为注释模板，不主动介入逻辑。
-- 若后续需要Lua扩展法术场行为，可取消注释并补充实现。

--[[
-- Actor生命周期：生成后调用一次。
-- 常用于初始化临时状态、绑定事件、打印生成日志。
function BP_MyFireRegion:ReceiveBeginPlay()
    BP_MyFireRegion.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
-- Actor生命周期：每帧调用。
-- DeltaTime为两帧间隔秒数，可用于持续检测/计时逻辑。
function BP_MyFireRegion:ReceiveTick(DeltaTime)
    BP_MyFireRegion.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
-- Actor生命周期：销毁/结束播放时调用。
-- 常用于清理引用、停止特效、取消定时器。
function BP_MyFireRegion:ReceiveEndPlay()
    BP_MyFireRegion.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
-- 网络复制声明函数：
-- 在此返回需要在服务端与客户端同步的Lua字段名数组。
function BP_MyFireRegion:GetReplicatedProperties()
    return
end
--]]

--[[
-- RPC白名单声明函数：
-- 在此返回允许客户端调用到服务端的RPC函数名。
function BP_MyFireRegion:GetAvailableServerRPCs()
    return
end
--]]

return BP_MyFireRegion