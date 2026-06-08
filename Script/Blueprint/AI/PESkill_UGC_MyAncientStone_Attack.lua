---@class PESkill_UGC_MyAncientStone_Attack_C:PESkillTemplate_Base_C
--Edit Below--
local PESkill_UGC_MyAncientStone_Attack = {}
 
function PESkill_UGC_MyAncientStone_Attack:OnEnableSkill_BP()
    PESkill_UGC_MyAncientStone_Attack.SuperClass.OnEnableSkill_BP(self)
end

function PESkill_UGC_MyAncientStone_Attack:OnDisableSkill_BP()
    PESkill_UGC_MyAncientStone_Attack.SuperClass.OnDisableSkill_BP(self)
end

function PESkill_UGC_MyAncientStone_Attack:OnActivateSkill_BP()
    PESkill_UGC_MyAncientStone_Attack.SuperClass.OnActivateSkill_BP(self)
end

function PESkill_UGC_MyAncientStone_Attack:OnDeActivateSkill_BP()
    PESkill_UGC_MyAncientStone_Attack.SuperClass.OnDeActivateSkill_BP(self)
end

function PESkill_UGC_MyAncientStone_Attack:CanActivateSkill_BP()
    return PESkill_UGC_MyAncientStone_Attack.SuperClass.CanActivateSkill_BP(self)
end

return PESkill_UGC_MyAncientStone_Attack