---@class BP_MyFireSkill_A_C:PESkillTemplate_Base_C
--Edit Below--
local BP_MyFireSkill_A = {}

local function log(...)
    ugcprint("[BP_MyFireSkill_A]", ...)
end

function BP_MyFireSkill_A:OnEnableSkill_BP()
    BP_MyFireSkill_A.SuperClass.OnEnableSkill_BP(self)
    log("OnEnableSkill_BP")
end

function BP_MyFireSkill_A:OnDisableSkill_BP()
    BP_MyFireSkill_A.SuperClass.OnDisableSkill_BP(self)
    log("OnDisableSkill_BP")
end

function BP_MyFireSkill_A:OnActivateSkill_BP()
    BP_MyFireSkill_A.SuperClass.OnActivateSkill_BP(self)
    log("OnActivateSkill_BP")
end

function BP_MyFireSkill_A:OnDeActivateSkill_BP()
    BP_MyFireSkill_A.SuperClass.OnDeActivateSkill_BP(self)
    log("OnDeActivateSkill_BP")
end

function BP_MyFireSkill_A:CanActivateSkill_BP()
    local can_activate = BP_MyFireSkill_A.SuperClass.CanActivateSkill_BP(self)
    log("CanActivateSkill_BP", tostring(can_activate))
    return can_activate
end

function BP_MyFireSkill_A:CastSkill_Entry()
    log("CastSkill_Entry")
end

function BP_MyFireSkill_A:CastSkill_Exit()
    log("CastSkill_Exit")
end

return BP_MyFireSkill_A