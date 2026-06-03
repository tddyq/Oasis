local updateUI = {
    -- 可配置参数定义，参数将显示在Action配置面板
    -- 例：
    -- MyIntParameter = 0
}

-- 触发器激活时，将执行Action的Execute
function updateUI:Execute(...)
    print("[updateUI] Execute started")

    -- 仅在客户端执行UI创建
    if UGCGameSystem.IsServer() then
        print("[updateUI] Running on server, skipping UI creation")
        return true
    end
    print("[updateUI] Running on client, proceeding to create UI")

    -- 构建UI蓝图路径
    local rootPath = UGCMapInfoLib.GetRootLongPackagePath()
    print("[updateUI] Root package path: " .. tostring(rootPath))

    local uiPath = string.format("%sAsset/Blueprint/UI/UI01.UI01_C", rootPath)
    print("[updateUI] Full UI class path: " .. uiPath)

    local MainUIClass = UE.LoadClass(uiPath)
    if MainUIClass == nil then
        print("[updateUI] Error: Failed to load UI class at path: " .. uiPath)
        return false
    end
    print("[updateUI] UI class loaded successfully")

    -- 获取本地玩家控制器
    local PlayerController = UGCGameSystem.GetLocalPlayerController()
    if PlayerController == nil then
        print("[updateUI] Error: Failed to get local player controller")
        return false
    end
    print("[updateUI] Local player controller obtained")

    -- 创建UI并添加到视口
    local MainUI = UserWidget.NewWidgetObjectBP(PlayerController, MainUIClass)
    if MainUI ~= nil then
        MainUI:AddToViewport()
        print("[updateUI] UI created and added to viewport successfully")
    else
        print("[updateUI] Error: Failed to create UI widget")
        return false
    end

    print("[updateUI] Execute completed successfully")
    return true
end

--[[
-- 需要勾选Action的EnableTick，才会执行Update
-- 触发器激活后，将在每个tick执行Action的Update，直到self.bEnableActionTick为false
function updateUI:Update(DeltaSeconds)
    print("[updateUI] Update called, DeltaSeconds: " .. tostring(DeltaSeconds))
end
]]

return updateUI