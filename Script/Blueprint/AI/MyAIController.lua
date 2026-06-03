---@class MyAIController_C:BaseAIController
--Edit Below--
local MyAIController = {}

function MyAIController:GetBehaviorTreeObjectPath()
    print("[MyAIController] GetBehaviorTreeObjectPath called")
    local path = string.format('%sAsset/Blueprint/AI/MyBehaviortree.MyBehaviortree', UGCMapInfoLib.GetRootLongPackagePath())
    print("[MyAIController] Behavior tree path: " .. path)
    return path
end

function MyAIController:OnPossess()
    print("[MyAIController] OnPossess called")
    self.SuperClass.OnPossess(self)
    local btPath = self:GetBehaviorTreeObjectPath()
    local btObject = UE.LoadObject(btPath)
    if btObject then
        print("[MyAIController] Behavior tree loaded successfully, running...")
        self:RunBehaviorTree(btObject)
    else
        print("[MyAIController] ERROR: Failed to load behavior tree at path: " .. btPath)
    end
end



return MyAIController