---@class UI01_C:UUserWidget
---@field BossButton UNewButton
---@field Bosstext UTextBlock
---@field TimeUI TimeUI_C
---@field private bound_game_state UGCGameState_C
local UI01 = { bInitDoOnce = false }

local pve_config = UGCGameSystem.UGCRequire("Script.Common.pve_config")

--[[
    模块定位（方案A 模块四/五）：
    - 模块四：显示 Boss 挑战按钮 + 倒计时数字
    - 模块五：点击按钮后向服务端发送“进入Boss阶段”请求
    说明：
    - UI 只负责表现与事件上报，不直接做服务器逻辑
    - 真实状态以 GameState 复制变量为准
]]

function UI01:Construct()
    if self.bInitDoOnce then
        return
    end

    if self.BossButton then
        -- 点击事件只绑定一次，避免重复绑定导致 RPC 触发多次
        self.BossButton.OnClicked:Add(self.OnBossButtonClicked, self)
        self.BossButton:SetVisibility(ESlateVisibility.Collapsed)
    end

    if self.TimeUI then
        self.TimeUI:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 模块四独立调试开关：不依赖清怪事件直接显示
    if pve_config.DEV_SHOW_BOSS_BUTTON then
        self:RefreshBossChallengeUI(1, pve_config.BOSS_COUNTDOWN_SECONDS)
    end

    self.bInitDoOnce = true
end

---@param game_state UGCGameState_C
function UI01:BindGameState(game_state)
    -- 客户端在 UI 初始化后绑定一次 GameState，
    -- 后续通过 GameState OnRep -> PlayerController:RefreshBossUIFromGameState 驱动实时刷新。
    self.bound_game_state = game_state
    self:RefreshBossChallengeUI(game_state.BossChallengeActive or 0, game_state.BossCountdown or 0)
end

---@param is_active integer
---@param countdown integer
function UI01:RefreshBossChallengeUI(is_active, countdown)
    -- 约定：is_active == 1 显示；其余隐藏
    -- 这样即使倒计时为 0，也能通过状态位强制控制显隐。
    local is_show = is_active == 1
    local visibility = is_show and ESlateVisibility.Visible or ESlateVisibility.Collapsed

    if self.BossButton then
        self.BossButton:SetVisibility(visibility)
    end

    if self.TimeUI then
        self.TimeUI:SetVisibility(visibility)
        if is_show and self.TimeUI.UpdateCountdown then
            -- 倒计时文本由子控件 TimeUI 负责，主UI只传数据
            self.TimeUI:UpdateCountdown(countdown)
        end
    end

    if self.Bosstext and is_show then
        self.Bosstext:SetText("挑战 Boss")
    end
end

function UI01:OnBossButtonClicked()
    print("[UI01] OnBossButtonClicked")
    local player_controller = UGCGameSystem.GetLocalPlayerController()
    if player_controller == nil then
        print("[UI01] OnBossButtonClicked failed: player_controller nil")
        return
    end

    -- 客户端 -> 服务端：请求进入Boss阶段。
    -- 具体行为（切图/传送/子关卡切换）统一在 PlayerController 服务器RPC中实现。
    UnrealNetwork.CallUnrealRPC(player_controller, player_controller, "RequestTravelToBossMap")
end

return UI01