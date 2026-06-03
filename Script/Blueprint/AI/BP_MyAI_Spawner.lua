---@class BP_MyAI_Spawner_C:BP_CH_UGC_AncientStone_C
--Edit Below--
local BP_MyAI_Spawner = {}

-- function BP_MyAI_Spawner:ReceiveBeginPlay()
--     BP_MyAI_Spawner.SuperClass.ReceiveBeginPlay(self)
-- end

-- function BP_MyAI_Spawner:ReceiveTick(DeltaTime)
--     BP_MyAI_Spawner.SuperClass.ReceiveTick(self, DeltaTime)
-- end

-- function BP_MyAI_Spawner:ReceiveEndPlay()
--     BP_MyAI_Spawner.SuperClass.ReceiveEndPlay(self) 
-- end

-- function BP_MyAI_Spawner:GetReplicatedProperties()
--     return
-- end

-- ---受击前置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function BP_MyAI_Spawner:PreTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)
     
-- end

-- ---受击后置事件
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- function BP_MyAI_Spawner:PostTakeDamageEvent(Damage, EventInstigator, DamageCauser, DamageContext)
    
-- end

-- ---受击前置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function BP_MyAI_Spawner:PreOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

-- ---受击后置伤害修改
-- ---生效范围：服务器
-- ---@param Damage float 伤害值
-- ---@param EventInstigator AController 伤害来源的Controller
-- ---@param DamageCauser AActor 伤害来源
-- ---@param DamageContext FGameMagnitudeContext  伤害上下文
-- ---@return float 修改后的伤害值
-- function BP_MyAI_Spawner:PostOverrideDamage(Damage, EventInstigator, DamageCauser, DamageContext)
--     return Damage
-- end

---角色死亡事件
---生效范围：服务器&客户端
---@param Damage float 伤害值
---@param EventInstigator AController 伤害来源的Controller
---@param DamageCauser AActor 伤害来源
---@param FDamageEvent DamageEvent 伤害事件
---@param DamageTypeID int32 伤害类型
function BP_MyAI_Spawner:BPDie(KillingDamage, EventInstigator, DamageCauser, DamageEvent, DamageTypeID)
    if self:HasAuthority() then
        -- 只有服务端才可以掉落
        self.UGCPresetCommonDropItemComponent:StartDrop(self, EventInstigator, {})
    end
end

-- ---状态进入事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 进入的状态
-- function BP_MyAI_Spawner:OnEnterTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnEnterTagState_BP: ' .. Tag)
-- end

-- ---状态退出事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 退出的状态
-- function BP_MyAI_Spawner:OnLeaveTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnLeaveTagState_BP: ' .. Tag)
-- end

-- ---状态打断事件
-- ---生效范围：服务器&客户端
-- ---@param DynamicState FGameplayTag 打断的状态
-- function BP_MyAI_Spawner:OnInterruptTagState_BP(DynamicState)
--     local Tag = BlueprintGameplayTagLibrary.GetTagName(DynamicState)
--     ugcprint('OnInterruptTagState_BP' .. Tag)
-- end

function BP_MyAI_Spawner:OnBehaviorNotify_BP(NotifyMsg)
    local target_name = "nil"
    local dist = -1

    local bb = self.GetBlackBoardComponent and self:GetBlackBoardComponent() or nil
    if bb then
        local target = bb:GetValueAsObject("Target")
        if target then
            -- 不再调用 target:GetName()，避免 nil method
            target_name = tostring(target)

            if self.K2_GetActorLocation and target.K2_GetActorLocation then
                local self_loc = self:K2_GetActorLocation()
                local tar_loc = target:K2_GetActorLocation()
                if self_loc and tar_loc then
                    dist = Vector.Distance(self_loc, tar_loc)
                end
            end
        end
    end

    ugcprint(string.format(
        "[BT_NOTIFY] msg=%s self=%s target=%s dist=%.1f",
        tostring(NotifyMsg),
        tostring(self),
        target_name,
        dist
    ))
end

-- ---怪物的目标发生变化事件
-- ---生效范围：服务器&客户端
-- ---@param NewTarget AActor 新目标
-- ---@param OldTarget AActor 旧目标
-- function BP_MyAI_Spawner:OnTargetChange_BP(NewTarget, OldTarget)
    
-- end

return BP_MyAI_Spawner