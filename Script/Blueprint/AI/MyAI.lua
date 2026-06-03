---@class MyAI_C:STExtraSimpleCharacter
---@field ActorMark UActorMarkComponent
---@field TakeDamageLogic UTakeDamageLogicComponent
---@field UAESkillManager UUAESkillManagerComponent
---@field UAEMonsterAnimList UUAEMonsterAnimListComponent
--Edit Below--
local MyAI = {
    -- 初始化标记
    bComponentsInitialized = false
}

-- 组件初始化（确保只执行一次）
function MyAI:InitializeComponents()
    print("[MyAI] InitializeComponents called")
    if self.bComponentsInitialized then
        print("[MyAI] Components already initialized, skipping")
        return
    end

    -- 获取关键组件引用
    self.TakeDamageLogic = self:GetComponentByClass("UTakeDamageLogicComponent")
    print("[MyAI] TakeDamageLogic component:", self.TakeDamageLogic and "found" or "nil")

    self.UAESkillManager = self:GetComponentByClass("UUAESkillManagerComponent")
    print("[MyAI] UAESkillManager component:", self.UAESkillManager and "found" or "nil")

    self.UAEMonsterAnimList = self:GetComponentByClass("UUAEMonsterAnimListComponent")
    print("[MyAI] UAEMonsterAnimList component:", self.UAEMonsterAnimList and "found" or "nil")

    -- 标记初始化完成
    self.bComponentsInitialized = true
    print("[MyAI] InitializeComponents completed")
end

-- 游戏开始时调用
function MyAI:ReceiveBeginPlay()
    print("[MyAI] ReceiveBeginPlay called")
    self.SuperClass.ReceiveBeginPlay(self)
    self:InitializeComponents()

    -- 初始状态设为待机
    self:SetAIState("PawnState.Movement.Idle")
    print("[MyAI] ReceiveBeginPlay completed")
end



-- 死亡事件处理
function MyAI:BPDie(KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)  
    -- 仅服务端且对象有效时执行  
    print("[MyAI] BPDie")  
    local eventData = { AIEntityID = UE.GetUniqueObjectID(self) } 
    LuaQuickFireEvent("OnAIDeath", self, eventData)  
    print("[MyAI] Sent OnAIDeath event")   
end  

-- 设置AI状态
---@param stateName string 状态名称（如"PawnState.Movement.Walking"）
function MyAI:SetAIState(stateName)
    print("[MyAI] SetAIState called with stateName:", stateName)

    local blackboard = self:GetBlackBoardComponent()
    if blackboard then
        local enumValue = UE.Enum.GetValueByName("EPawnState", stateName)
        print("[MyAI] Got enum value for", stateName, ":", enumValue)
        blackboard:SetValueAsEnum("CurrentState", enumValue)
        print("[MyAI] Blackboard CurrentState set to:", stateName)
    else
        print("[MyAI] ERROR: Blackboard component is nil, cannot set state")
    end
end

return MyAI