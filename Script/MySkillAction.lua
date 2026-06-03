---@class MySkillAction_C:UAESkillAction
--Edit Below--
local MySkillAction = {};

-- 技能执行完毕后调用
function MySkillAction:OnReset()
    print("Log:MySkillAction:OnReset")
end

-- Action(技能行为)每帧调用
function MySkillAction:OnUpdateAction()
    print("Log:MySkillAction Update")
end

-- 开始执行时调用
function MySkillAction:OnRealDoAction()
    -- 获取技能的释放者
    local OPawn = self:GetOwnerPawn()
    print("Log:MySkillAction OnRealDoAction " .. U.E.GetName(OPawn))
end

return MySkillAction;