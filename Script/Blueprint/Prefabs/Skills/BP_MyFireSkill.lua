---@class BP_MyFireSkill_C:PESkillTemplate_Base_C
--Edit Below--
local BP_MyFireSkill = {}

-- 技能“启用”回调：
-- 常见触发时机：技能实例被添加到角色并进入可用状态。
-- 当前仅记录日志，便于确认技能实例是否成功挂载。
function BP_MyFireSkill:OnEnableSkill_BP()
    BP_MyFireSkill.SuperClass.OnEnableSkill_BP(self)
    print("[BP_MyFireSkill] OnEnableSkill_BP")
end

-- 技能“禁用”回调：
-- 常见触发时机：技能被移除、角色销毁或系统关闭该技能。
-- 当前仅记录日志，便于观察技能生命周期结束节点。
function BP_MyFireSkill:OnDisableSkill_BP()
    BP_MyFireSkill.SuperClass.OnDisableSkill_BP(self)
    print("[BP_MyFireSkill] OnDisableSkill_BP")
end

-- 技能“激活开始”回调：
-- 当外部调用 ActivateSkill 后，技能开始一次完整施法流程。
-- 该节点可用于施法前准备（目前仅输出日志）。
function BP_MyFireSkill:OnActivateSkill_BP()
    BP_MyFireSkill.SuperClass.OnActivateSkill_BP(self)
    print("[BP_MyFireSkill] OnActivateSkill_BP")
end

-- 技能“激活结束”回调：
-- 一次施法流程结束时触发，可用于收尾逻辑（目前仅输出日志）。
function BP_MyFireSkill:OnDeActivateSkill_BP()
    BP_MyFireSkill.SuperClass.OnDeActivateSkill_BP(self)
    print("[BP_MyFireSkill] OnDeActivateSkill_BP")
end

-- 技能可否激活检查：
-- 返回 true 表示本次允许激活，false 表示被拒绝。
-- 当前完全沿用父类判断逻辑，不额外添加限制条件。
function BP_MyFireSkill:CanActivateSkill_BP()
    return BP_MyFireSkill.SuperClass.CanActivateSkill_BP(self)
end

-- CastSkill阶段进入回调：
-- 对应技能编辑器里 CastSkill 阶段开始时机。
-- 适合放置“开始施法”相关的脚本逻辑（当前仅日志）。
function BP_MyFireSkill:CastSkill_Entry()
    print("[BP_MyFireSkill] CastSkill_Entry")
end

-- CastSkill阶段退出回调：
-- 对应 CastSkill 阶段结束时机，用于观测阶段边界（当前仅日志）。
function BP_MyFireSkill:CastSkill_Exit()
    print("[BP_MyFireSkill] CastSkill_Exit")
end

return BP_MyFireSkill