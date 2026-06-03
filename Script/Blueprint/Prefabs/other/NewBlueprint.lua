---@class NewBlueprint_C:AActor
---@field Cube UStaticMeshComponent
---@field Box UBoxComponent
---@field DefaultSceneRoot USceneComponent
--Edit Below--
local NewBlueprint = {}

function NewBlueprint:ReceiveBeginPlay()
    self.SuperClass.ReceiveBeginPlay(self);
    if self:HasAuthority() == true then
        self.Box.OnComponentBeginOverlap:Add(self.Box_OnComponentBeginOverlap,self)
    end
end

function NewBlueprint:Box_OnComponentBeginOverlap(OverlappedComponent, OtherActor, OtherComp, OtherBodyIndex, bFromSweep, SweepResult)
    if OtherActor then
        local SkillManager = OtherActor:GetSkillManagerComponent()
        if SkillManager then
            SkillManager:TriggerEvent(120, UTSkillEventType.SET_KEY_DOWN)
        end
    end
end

return NewBlueprint;