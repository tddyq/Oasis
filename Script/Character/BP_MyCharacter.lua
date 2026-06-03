---@class BP_MyCharacter_C:Character
---@field Camera UCameraComponent
---@field SpringArm USpringArmComponent
--Edit Below--
local BP_MyCharacter = {}
 
--[[
function BP_MyCharacter:ReceiveBeginPlay()
    BP_MyCharacter.SuperClass.ReceiveBeginPlay(self)
end
--]]

--[[
function BP_MyCharacter:ReceiveTick(DeltaTime)
    BP_MyCharacter.SuperClass.ReceiveTick(self, DeltaTime)
end
--]]

--[[
function BP_MyCharacter:ReceiveEndPlay()
    BP_MyCharacter.SuperClass.ReceiveEndPlay(self) 
end
--]]

--[[
function BP_MyCharacter:GetReplicatedProperties()
    return
end
--]]

--[[
function BP_MyCharacter:GetAvailableServerRPCs()
    return
end
--]]

return BP_MyCharacter