local BP_CustomLevelDirector = {} 

function BP_CustomLevelDirector:BeginPlay()
    -- 初始化全局计数器
    self.AIDeathCount = 0
    -- 监听玩家死亡事件
    UGCEventSystem:AddListener(UGCGameEventType.PlayerDeath, self.OnPlayerDeath, self)
end 

function BP_CustomLevelDirector:OnPlayerDeath(EventParam)
    -- 判断死亡玩家是否为AI
    if EventParam.IsAI then
        self.AIDeathCount = self.AIDeathCount + 1
        -- 达到3个死亡AI时触发UI
        if self.AIDeathCount >= 3 then
            self.AIDeathCount = 0  -- 重置计数器
            self:ShowBossChallengeUI()
        end
    end
end

function BP_CustomLevelDirector:ShowBossChallengeUI()
    -- 显示10秒倒计时（系统预制接口）
    UGCTemplateGameplayStatics:CreateTimer("BossCountdown", 10)
    -- 显示【挑战boss】按钮
    UIManager:SetWidgetVisibility("ChallengeBossButton", true)
end  

return BP_CustomLevelDirector