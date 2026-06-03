---@class TimeUI_C:UUserWidget
---@field LastTime UTextBlock
---@field TextBlock_1 UTextBlock
local TimeUI = { bInitDoOnce = false }

function TimeUI:Construct()
    if self.bInitDoOnce then
        return
    end

    -- LastTime 作为固定标签文本，不参与数字倒计时
    if self.LastTime then
        self.LastTime:SetVisibility(ESlateVisibility.Visible)
        self.LastTime:SetText("LastTime:")
    end

    -- TextBlock_1 作为实际倒计时数字显示
    if self.TextBlock_1 then
        self.TextBlock_1:SetVisibility(ESlateVisibility.Visible)
    end

    self.bInitDoOnce = true
end

---@param seconds integer
function TimeUI:UpdateCountdown(seconds)
    if self.TextBlock_1 then
        self.TextBlock_1:SetVisibility(ESlateVisibility.Visible)
        self.TextBlock_1:SetText(tostring(seconds))
    elseif self.LastTime then
        -- 兜底：若未配置 TextBlock_1，则退化为在 LastTime 上显示数字
        self.LastTime:SetVisibility(ESlateVisibility.Visible)
        self.LastTime:SetText(tostring(seconds))
    elseif not self._warned_no_countdown_text then
        self._warned_no_countdown_text = true
        print("[TimeUI] UpdateCountdown failed: TextBlock_1/LastTime both nil")
    end
end

return TimeUI