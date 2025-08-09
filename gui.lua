-- ESP System with Classic Sidebar Layout + Beautiful Buttons
local GuiFramework = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Framework Variables
local currentWindow = nil
local notifications = {}

-- Themes
local themes = {
    Default = {
        Primary = Color3.fromRGB(100, 150, 255),
        Secondary = Color3.fromRGB(15, 15, 25),
        Background = Color3.fromRGB(8, 8, 18),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(120, 150, 255)
    },
    Ocean = {
        Primary = Color3.fromRGB(100, 200, 255),
        Secondary = Color3.fromRGB(5, 15, 25),
        Background = Color3.fromRGB(0, 10, 20),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(150, 220, 255)
    }
}

local currentTheme = themes.Default

-- Utility Functions
local function tween(object, info, properties)
    local tweenInfo = TweenInfo.new(
        info.Time or 0.3,
        info.EasingStyle or Enum.EasingStyle.Quart,
        info.EasingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or currentTheme.Primary
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

-- Notification System
function GuiFramework:CreateNotification(config)
    local notifConfig = {
        Title = config.Title or "Notification",
        Content = config.Content or "Content",
        Duration = config.Duration or 5
    }

    local notifContainer = Instance.new("Frame")
    notifContainer.Parent = playerGui
    notifContainer.Size = UDim2.new(0, 350, 0, 100)
    notifContainer.Position = UDim2.new(1, -370, 0, 20 + (#notifications * 110))
    notifContainer.BackgroundColor3 = currentTheme.Secondary
    notifContainer.BackgroundTransparency = 0.1
    notifContainer.BorderSizePixel = 0
    notifContainer.ZIndex = 1000

    createCorner(notifContainer, 12)
    createStroke(notifContainer, currentTheme.Primary, 1, 0.3)

    -- Slide in animation
    notifContainer.Position = UDim2.new(1, 0, 0, 20 + (#notifications * 110))
    tween(notifContainer, {Time = 0.5, EasingStyle = Enum.EasingStyle.Back}, {
        Position = UDim2.new(1, -370, 0, 20 + (#notifications * 110))
    }):Play()

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notifContainer
    titleLabel.Size = UDim2.new(1, -20, 0.4, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = notifConfig.Title
    titleLabel.TextColor3 = currentTheme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Content
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Parent = notifContainer
    contentLabel.Size = UDim2.new(1, -20, 0.5, 0)
    contentLabel.Position = UDim2.new(0, 10, 0.4, 0)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = notifConfig.Content
    contentLabel.TextColor3 = currentTheme.Text
    contentLabel.TextSize = 12
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true

    -- Progress bar
    local progressBar = Instance.new("Frame")
    progressBar.Parent = notifContainer
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = currentTheme.Primary
    progressBar.BorderSizePixel = 0

    createCorner(progressBar, 2)
    tween(progressBar, {Time = notifConfig.Duration}, {Size = UDim2.new(0, 0, 0, 3)}):Play()

    table.insert(notifications, notifContainer)

    -- Auto remove
    spawn(function()
        wait(notifConfig.Duration)
        tween(notifContainer, {Time = 0.3}, {
            Position = UDim2.new(1, 0, notifContainer.Position.Y.Scale, notifContainer.Position.Y.Offset)
        }):Play()
        wait(0.3)
        notifContainer:Destroy()
        
        for i, notif in ipairs(notifications) do
            if notif == notifContainer then
                table.remove(notifications, i)
                break
            end
        end
    end)

    return notifContainer
end

-- Main Create Window Function (SIDEBAR LAYOUT)
function GuiFramework:CreateWindow(config)
    local windowConfig = {
        Name = config.Name or "Framework GUI",
        Theme = config.Theme or "Default",
        Size = config.Size or {700, 500},
        KeySystem = config.KeySystem or false
    }

    -- Set theme
    if themes[windowConfig.Theme] then
        currentTheme = themes[windowConfig.Theme]
    end

    -- Destroy existing window
    if currentWindow and currentWindow.ScreenGui then
        currentWindow.ScreenGui:Destroy()
    end

    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SidebarFrameworkGUI"
    screenGui.Parent = playerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Container
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Parent = screenGui
    mainContainer.Size = UDim2.new(0, windowConfig.Size[1], 0, windowConfig.Size[2])
    mainContainer.Position = UDim2.new(0.5, -windowConfig.Size[1]/2, 0.5, -windowConfig.Size[2]/2)
    mainContainer.BackgroundColor3 = currentTheme.Secondary
    mainContainer.BackgroundTransparency = 0.1
    mainContainer.BorderSizePixel = 0
    mainContainer.ZIndex = 2

    createCorner(mainContainer, 15)
    createStroke(mainContainer, currentTheme.Primary, 2, 0.3)

    -- Header (Top bar)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Parent = mainContainer
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = currentTheme.Background
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0

    createCorner(header, 15)

    local logoText = Instance.new("TextLabel")
    logoText.Parent = header
    logoText.Size = UDim2.new(0.7, 0, 1, 0)
    logoText.Position = UDim2.new(0, 15, 0, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = windowConfig.Name
    logoText.TextColor3 = currentTheme.Text
    logoText.TextSize = 16
    logoText.Font = Enum.Font.GothamBold
    logoText.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = header
    closeButton.Size = UDim2.new(0, 30, 0, 25)
    closeButton.Position = UDim2.new(1, -40, 0.5, -12.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.BackgroundTransparency = 0.3
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = currentTheme.Text
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold

    createCorner(closeButton, 12)

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainContainer.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainContainer.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- SIDEBAR (Sol taraf - Tabs)
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainContainer
    sidebar.Size = UDim2.new(0, 180, 1, -50)
    sidebar.Position = UDim2.new(0, 10, 0, 45)
    sidebar.BackgroundColor3 = currentTheme.Background
    sidebar.BackgroundTransparency = 0.2
    sidebar.BorderSizePixel = 0

    createCorner(sidebar, 12)
    createStroke(sidebar, currentTheme.Primary, 1, 0.5)

    -- Tab Container (Sidebar içinde)
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = sidebar
    tabContainer.Size = UDim2.new(1, -10, 1, -10)
    tabContainer.Position = UDim2.new(0, 5, 0, 5)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 4
    tabContainer.ScrollBarImageColor3 = currentTheme.Primary
    tabContainer.ScrollBarImageTransparency = 0.3

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabContainer
    tabLayout.FillDirection = Enum.FillDirection.Vertical -- VERTICAL tabs
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)

    -- Content Area (Sağ taraf - İçerik)
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Parent = mainContainer
    contentArea.Size = UDim2.new(0, 495, 1, -50)
    contentArea.Position = UDim2.new(0, 200, 0, 45)
    contentArea.BackgroundColor3 = currentTheme.Background
    contentArea.BackgroundTransparency = 0.3
    contentArea.BorderSizePixel = 0

    createCorner(contentArea, 12)

    -- Tab Content Container
    local tabContentContainer = Instance.new("Frame")
    tabContentContainer.Name = "TabContentContainer"
    tabContentContainer.Parent = contentArea
    tabContentContainer.Size = UDim2.new(1, -20, 1, -20)
    tabContentContainer.Position = UDim2.new(0, 10, 0, 10)
    tabContentContainer.BackgroundTransparency = 1

    -- Window object
    local Window = {
        ScreenGui = screenGui,
        MainContainer = mainContainer,
        Sidebar = sidebar,
        TabContainer = tabContainer,
        ContentArea = contentArea,
        TabContentContainer = tabContentContainer,
        TabLayout = tabLayout,
        Tabs = {},
        CurrentTab = nil,
        Theme = currentTheme,
        Config = windowConfig
    }

    currentWindow = Window

    -- Window Functions
    function Window:CreateTab(config)
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or "📄",
            Color = config.Color or currentTheme.Primary
        }

        -- Tab Button (SIDEBAR style - Vertical)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "Tab_" .. tabConfig.Name
        tabButton.Parent = self.TabContainer
        tabButton.Size = UDim2.new(1, 0, 0, 40) -- Fixed height for vertical tabs
        tabButton.BackgroundColor3 = currentTheme.Secondary
        tabButton.BackgroundTransparency = 0.4
        tabButton.BorderSizePixel = 0
        tabButton.Text = ""

        createCorner(tabButton, 8)

        -- Tab icon
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Parent = tabButton
        tabIcon.Size = UDim2.new(0, 25, 0, 25)
        tabIcon.Position = UDim2.new(0, 8, 0.5, -12)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = tabConfig.Icon
        tabIcon.TextColor3 = Color3.fromRGB(150, 150, 180)
        tabIcon.TextSize = 16
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.TextXAlignment = Enum.TextXAlignment.Center

        -- Tab text
        local tabText = Instance.new("TextLabel")
        tabText.Parent = tabButton
        tabText.Size = UDim2.new(1, -40, 1, 0)
        tabText.Position = UDim2.new(0, 35, 0, 0)
        tabText.BackgroundTransparency = 1
        tabText.Text = tabConfig.Name
        tabText.TextColor3 = Color3.fromRGB(150, 150, 180)
        tabText.TextSize = 13
        tabText.Font = Enum.Font.Gotham
        tabText.TextXAlignment = Enum.TextXAlignment.Left

        -- Tab Content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = "TabContent_" .. tabConfig.Name
        tabContent.Parent = self.TabContentContainer
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = currentTheme.Primary
        tabContent.ScrollBarImageTransparency = 0.3
        tabContent.Visible = false

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Parent = tabContent
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)

        -- Tab object
        local Tab = {
            Name = tabConfig.Name,
            Button = tabButton,
            Content = tabContent,
            Layout = contentLayout,
            Icon = tabIcon,
            Text = tabText,
            Config = tabConfig,
            Elements = {},
            Window = self
        }

        -- Tab hover effects
        tabButton.MouseEnter:Connect(function()
            if Tab ~= self.CurrentTab then
                tween(tabButton, {Time = 0.2}, {BackgroundTransparency = 0.2}):Play()
                tween(tabText, {Time = 0.2}, {TextColor3 = Color3.fromRGB(220, 220, 240)}):Play()
                tween(tabIcon, {Time = 0.2}, {TextColor3 = tabConfig.Color}):Play()
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if Tab ~= self.CurrentTab then
                tween(tabButton, {Time = 0.2}, {BackgroundTransparency = 0.4}):Play()
                tween(tabText, {Time = 0.2}, {TextColor3 = Color3.fromRGB(150, 150, 180)}):Play()
                tween(tabIcon, {Time = 0.2}, {TextColor3 = Color3.fromRGB(150, 150, 180)}):Play()
            end
        end)

        -- Tab click
        tabButton.MouseButton1Click:Connect(function()
            self:SelectTab(Tab)
        end)

        -- Add to tabs
        table.insert(self.Tabs, Tab)

        -- Select first tab
        if #self.Tabs == 1 then
            self:SelectTab(Tab)
        end

        -- Tab Methods - BEAUTIFUL BUTTONS
        function Tab:CreateToggle(config)
            local toggleConfig = {
                Name = config.Name or "Toggle",
                Description = config.Description or "",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, toggleConfig.Description ~= "" and 70 or 50)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.15
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, currentTheme.Accent, 1, 0.4)

            -- Hover glow effect
            local hoverGlow = Instance.new("Frame")
            hoverGlow.Parent = container
            hoverGlow.Size = UDim2.new(1, 4, 1, 4)
            hoverGlow.Position = UDim2.new(0, -2, 0, -2)
            hoverGlow.BackgroundColor3 = currentTheme.Primary
            hoverGlow.BackgroundTransparency = 1
            hoverGlow.BorderSizePixel = 0
            hoverGlow.ZIndex = container.ZIndex - 1

            createCorner(hoverGlow, 12)

            local label = Instance.new("TextLabel")
            label.Parent = container
            label.Size = UDim2.new(0.7, 0, toggleConfig.Description ~= "" and 0.5 or 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleConfig.Name
            label.TextColor3 = currentTheme.Text
            label.TextSize = 14
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left

            if toggleConfig.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = container
                descLabel.Size = UDim2.new(1, -20, 0.5, 0)
                descLabel.Position = UDim2.new(0, 15, 0.5, 0)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = toggleConfig.Description
                descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
            end

            -- BEAUTIFUL Toggle switch
            local toggleBg = Instance.new("Frame")
            toggleBg.Parent = container
            toggleBg.Size = UDim2.new(0, 50, 0, 24)
            toggleBg.Position = UDim2.new(1, -65, 0.5, -12)
            toggleBg.BackgroundColor3 = toggleConfig.Default and currentTheme.Primary or Color3.fromRGB(40, 40, 60)
            toggleBg.BorderSizePixel = 0

            createCorner(toggleBg, 12)

            -- Toggle glow
            local toggleGlow = Instance.new("Frame")
            toggleGlow.Parent = toggleBg
            toggleGlow.Size = UDim2.new(1, 4, 1, 4)
            toggleGlow.Position = UDim2.new(0, -2, 0, -2)
            toggleGlow.BackgroundColor3 = currentTheme.Primary
            toggleGlow.BackgroundTransparency = toggleConfig.Default and 0.7 or 1
            toggleGlow.BorderSizePixel = 0
            toggleGlow.ZIndex = toggleBg.ZIndex - 1

            createCorner(toggleGlow, 14)

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Parent = toggleBg
            toggleCircle.Size = UDim2.new(0, 20, 0, 20)
            toggleCircle.Position = toggleConfig.Default and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0

            createCorner(toggleCircle, 10)

            -- Circle shadow
            local circleShadow = Instance.new("Frame")
            circleShadow.Parent = toggleCircle
            circleShadow.Size = UDim2.new(1, 2, 1, 2)
            circleShadow.Position = UDim2.new(0, -1, 0, 1)
            circleShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            circleShadow.BackgroundTransparency = 0.8
            circleShadow.BorderSizePixel = 0
            circleShadow.ZIndex = toggleCircle.ZIndex - 1

            createCorner(circleShadow, 11)

            local button = Instance.new("TextButton")
            button.Parent = container
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = ""

            -- Hover effects
            button.MouseEnter:Connect(function()
                tween(container, {Time = 0.2}, {BackgroundTransparency = 0.1}):Play()
                tween(hoverGlow, {Time = 0.2}, {BackgroundTransparency = 0.8}):Play()
            end)

            button.MouseLeave:Connect(function()
                tween(container, {Time = 0.2}, {BackgroundTransparency = 0.15}):Play()
                tween(hoverGlow, {Time = 0.2}, {BackgroundTransparency = 1}):Play()
            end)

            local isEnabled = toggleConfig.Default
            button.MouseButton1Click:Connect(function()
                isEnabled = not isEnabled
                
                local bgColor = isEnabled and currentTheme.Primary or Color3.fromRGB(40, 40, 60)
                local circlePos = isEnabled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                local glowTransparency = isEnabled and 0.7 or 1
                
                tween(toggleBg, {Time = 0.3}, {BackgroundColor3 = bgColor}):Play()
                tween(toggleCircle, {Time = 0.3}, {Position = circlePos}):Play()
                tween(toggleGlow, {Time = 0.3}, {BackgroundTransparency = glowTransparency}):Play()
                
                toggleConfig.Callback(isEnabled)
            end)

            self:UpdateCanvasSize()
            return {Container = container, GetValue = function() return isEnabled end}
        end

        function Tab:CreateButton(config)
            local buttonConfig = {
                Name = config.Name or "Button",
                Description = config.Description or "",
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, buttonConfig.Description ~= "" and 65 or 45)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.15
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, currentTheme.Primary, 1, 0.4)

            -- Gradient background
            local gradient = Instance.new("UIGradient")
            gradient.Parent = container
            gradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.new(
                    currentTheme.Secondary.R + 0.05,
                    currentTheme.Secondary.G + 0.05,
                    currentTheme.Secondary.B + 0.1
                )),
                ColorSequenceKeypoint.new(1, currentTheme.Secondary)
            }
            gradient.Rotation = 45

            -- Hover glow
            local hoverGlow = Instance.new("Frame")
            hoverGlow.Parent = container
            hoverGlow.Size = UDim2.new(1, 6, 1, 6)
            hoverGlow.Position = UDim2.new(0, -3, 0, -3)
            hoverGlow.BackgroundColor3 = currentTheme.Primary
            hoverGlow.BackgroundTransparency = 1
            hoverGlow.BorderSizePixel = 0
            hoverGlow.ZIndex = container.ZIndex - 1

            createCorner(hoverGlow, 13)

            local button = Instance.new("TextButton")
            button.Parent = container
            button.Size = UDim2.new(1, 0, buttonConfig.Description ~= "" and 0.6 or 1, 0)
            button.BackgroundTransparency = 1
            button.Text = buttonConfig.Name
            button.TextColor3 = currentTheme.Text
            button.TextSize = 14
            button.Font = Enum.Font.GothamSemibold

            if buttonConfig.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = container
                descLabel.Size = UDim2.new(1, -20, 0.4, 0)
                descLabel.Position = UDim2.new(0, 10, 0.6, 0)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = buttonConfig.Description
                descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
            end

            -- Beautiful hover effects
            button.MouseEnter:Connect(function()
                tween(container, {Time = 0.2}, {BackgroundTransparency = 0.05}):Play()
                tween(hoverGlow, {Time = 0.2}, {BackgroundTransparency = 0.7}):Play()
                tween(button, {Time = 0.2}, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end)

            button.MouseLeave:Connect(function()
                tween(container, {Time = 0.2}, {BackgroundTransparency = 0.15}):Play()
                tween(hoverGlow, {Time = 0.2}, {BackgroundTransparency = 1}):Play()
                tween(button, {Time = 0.2}, {TextColor3 = currentTheme.Text}):Play()
            end)

            button.MouseButton1Click:Connect(function()
                -- Click animation
                tween(container, {Time = 0.1}, {Size = UDim2.new(1, -4, 0, (buttonConfig.Description ~= "" and 65 or 45) - 2)}):Play()
                wait(0.1)
                tween(container, {Time = 0.1}, {Size = UDim2.new(1, 0, 0, buttonConfig.Description ~= "" and 65 or 45)}):Play()
                
                buttonConfig.Callback()
            end)

            self:UpdateCanvasSize()
            return container
        end

        function Tab:UpdateCanvasSize()
            self.Content.CanvasSize = UDim2.new(0, 0, 0, self.Layout.AbsoluteContentSize.Y + 20)
        end

        return Tab
    end

    -- SelectTab function
    function Window:SelectTab(tab)
        -- Hide all tabs
        for _, otherTab in ipairs(self.Tabs) do
            otherTab.Content.Visible = false
            tween(otherTab.Button, {Time = 0.2}, {BackgroundTransparency = 0.4}):Play()
            tween(otherTab.Text, {Time = 0.2}, {TextColor3 = Color3.fromRGB(150, 150, 180)}):Play()
            tween(otherTab.Icon, {Time = 0.2}, {TextColor3 = Color3.fromRGB(150, 150, 180)}):Play()
            
            -- Remove stroke if exists
            if otherTab.Button:FindFirstChild("UIStroke") then
                otherTab.Button.UIStroke:Destroy()
            end
        end

        -- Show selected tab
        tab.Content.Visible = true
        self.CurrentTab = tab

        -- Style selected tab
        tween(tab.Button, {Time = 0.2}, {BackgroundTransparency = 0.1}):Play()
        tween(tab.Text, {Time = 0.2}, {TextColor3 = currentTheme.Text}):Play()
        tween(tab.Icon, {Time = 0.2}, {TextColor3 = tab.Config.Color}):Play()

        -- Add active stroke
        createStroke(tab.Button, tab.Config.Color, 2, 0.3)

        tab:UpdateCanvasSize()
        
        -- Update tab container canvas size
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, self.TabLayout.AbsoluteContentSize.Y + 10)
    end

    return Window
end

-- Now create the ESP System
local Framework = GuiFramework

-- ESP Variables
local espObjects = {}
local espEnabled = false
local espSettings = {
    showNames = true,
    showDistance = true,
    showHealth = true,
    showBoxes = true,
    showTracers = false,
    maxDistance = 1000
}

local camera = workspace.CurrentCamera

-- ESP Functions
local function createESPForPlayer(targetPlayer)
    if targetPlayer == player then return end
    if espObjects[targetPlayer] then return end

    local esp = {
        player = targetPlayer,
        connection = nil,
        drawings = {}
    }

    -- Create drawings
    local nameLabel = Drawing.new("Text")
    nameLabel.Text = targetPlayer.Name
    nameLabel.Color = Color3.fromRGB(255, 255, 255)
    nameLabel.Size = 14
    nameLabel.Center = true
    nameLabel.Outline = true
    nameLabel.OutlineColor = Color3.new(0, 0, 0)
    nameLabel.Font = 2
    table.insert(esp.drawings, nameLabel)

    local distanceLabel = Drawing.new("Text")
    distanceLabel.Text = "0m"
    distanceLabel.Color = Color3.fromRGB(255, 255, 255)
    distanceLabel.Size = 12
    distanceLabel.Center = true
    distanceLabel.Outline = true
    distanceLabel.OutlineColor = Color3.new(0, 0, 0)
    distanceLabel.Font = 2
    table.insert(esp.drawings, distanceLabel)

    local healthLabel = Drawing.new("Text")
    healthLabel.Text = "100%"
    healthLabel.Color = Color3.fromRGB(0, 255, 0)
    healthLabel.Size = 12
    healthLabel.Center = true
    healthLabel.Outline = true
    healthLabel.OutlineColor = Color3.new(0, 0, 0)
    healthLabel.Font = 2
    table.insert(esp.drawings, healthLabel)

    local box = Drawing.new("Square")
    box.Color = Color3.fromRGB(100, 200, 255)
    box.Thickness = 1
    box.Transparency = 1
    box.Filled = false
    table.insert(esp.drawings, box)

    local tracer = Drawing.new("Line")
    tracer.Color = Color3.fromRGB(255, 100, 100)
    tracer.Thickness = 2
    tracer.Transparency = 0.8
    table.insert(esp.drawings, tracer)

    -- Update function
    esp.connection = RunService.Heartbeat:Connect(function()
        if not espEnabled or not targetPlayer.Parent then
            for _, drawing in pairs(esp.drawings) do
                drawing.Visible = false
            end
            return
        end

        local character = targetPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            for _, drawing in pairs(esp.drawings) do
                drawing.Visible = false
            end
            return
        end

        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character.HumanoidRootPart
        local head = character:FindFirstChild("Head")

        if not rootPart or not head then
            for _, drawing in pairs(esp.drawings) do
                drawing.Visible = false
            end
            return
        end

        -- Calculate distance
        local distance = (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) 
            and (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude or math.huge

        if distance > espSettings.maxDistance then
            for _, drawing in pairs(esp.drawings) do
                drawing.Visible = false
            end
            return
        end

        -- Get screen positions
        local rootPos, rootOnScreen = camera:WorldToViewportPoint(rootPart.Position)
        local headPos, headOnScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
        local legPos, legOnScreen = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))

        if not rootOnScreen then
            for _, drawing in pairs(esp.drawings) do
                drawing.Visible = false
            end
            return
        end

        -- Calculate box dimensions
        local boxHeight = math.abs(headPos.Y - legPos.Y)
        local boxWidth = boxHeight * 0.5

        -- Update labels
        if espSettings.showNames then
            nameLabel.Text = targetPlayer.Name
            nameLabel.Position = Vector2.new(rootPos.X, headPos.Y - 30)
            nameLabel.Visible = true
        else
            nameLabel.Visible = false
        end

        if espSettings.showDistance then
            distanceLabel.Text = math.floor(distance) .. "m"
            distanceLabel.Position = Vector2.new(rootPos.X, headPos.Y - 15)
            distanceLabel.Visible = true
        else
            distanceLabel.Visible = false
        end

        if espSettings.showHealth and humanoid then
            local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
            healthLabel.Text = healthPercent .. "%"
            healthLabel.Position = Vector2.new(rootPos.X, legPos.Y + 5)
            healthLabel.Visible = true
            
            -- Health color
            if healthPercent > 75 then
                healthLabel.Color = Color3.new(0, 1, 0)
            elseif healthPercent > 50 then
                healthLabel.Color = Color3.new(1, 1, 0)
            elseif healthPercent > 25 then
                healthLabel.Color = Color3.new(1, 0.5, 0)
            else
                healthLabel.Color = Color3.new(1, 0, 0)
            end
        else
            healthLabel.Visible = false
        end

        -- Update box
        if espSettings.showBoxes then
            box.Size = Vector2.new(boxWidth, boxHeight)
            box.Position = Vector2.new(rootPos.X - boxWidth/2, headPos.Y)
            box.Visible = true
        else
            box.Visible = false
        end

        -- Update tracer
        if espSettings.showTracers then
            tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
            tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            tracer.Visible = true
        else
            tracer.Visible = false
        end
    end)

    espObjects[targetPlayer] = esp
end

local function removeESPForPlayer(targetPlayer)
    local esp = espObjects[targetPlayer]
    if not esp then return end

    if esp.connection then
        esp.connection:Disconnect()
    end

    for _, drawing in pairs(esp.drawings) do
        drawing:Remove()
    end

    espObjects[targetPlayer] = nil
end

local function updateAllESP()
    for _, targetPlayer in pairs(Players:GetPlayers()) do
        if espEnabled then
            createESPForPlayer(targetPlayer)
        else
            removeESPForPlayer(targetPlayer)
        end
    end
end

-- Player connection events
Players.PlayerAdded:Connect(function(targetPlayer)
    wait(1) -- Wait for character to load
    if espEnabled then
        createESPForPlayer(targetPlayer)
    end
end)

Players.PlayerRemoving:Connect(function(targetPlayer)
    removeESPForPlayer(targetPlayer)
end)

-- Create Beautiful Sidebar GUI
local Window = Framework:CreateWindow({
    Name = "🎯 ESP System v3.0 - Beautiful",
    Theme = "Ocean",
    Size = {700, 500}, -- Sidebar layout
    KeySystem = false
})

-- Show welcome notification
Framework:CreateNotification({
    Title = "ESP System",
    Content = "Beautiful sidebar ESP system loaded!",
    Duration = 3
})

-- Create Sidebar Tabs
local MainTab = Window:CreateTab({
    Name = "ESP Controls",
    Icon = "👁",
    Color = Color3.fromRGB(100, 200, 255)
})

local VisualsTab = Window:CreateTab({
    Name = "Visual Settings",
    Icon = "🎨",
    Color = Color3.fromRGB(255, 150, 100)
})

local UtilityTab = Window:CreateTab({
    Name = "Utility",
    Icon = "⚙",
    Color = Color3.fromRGB(150, 255, 100)
})

local InfoTab = Window:CreateTab({
    Name = "Information",
    Icon = "ℹ",
    Color = Color3.fromRGB(150, 100, 255)
})

-- Main ESP Controls Tab
MainTab:CreateToggle({
    Name = "Enable ESP",
    Description = "Master toggle for all ESP features",
    Default = false,
    Callback = function(value)
        espEnabled = value
        updateAllESP()
        
        Framework:CreateNotification({
            Title = "ESP Status",
            Content = espEnabled and "ESP Enabled!" or "ESP Disabled!",
            Duration = 2
        })
    end
})

MainTab:CreateToggle({
    Name = "Show Player Names",
    Description = "Display player usernames above their heads",
    Default = espSettings.showNames,
    Callback = function(value)
        espSettings.showNames = value
    end
})

MainTab:CreateToggle({
    Name = "Show Distance",
    Description = "Display distance to players in studs",
    Default = espSettings.showDistance,
    Callback = function(value)
        espSettings.showDistance = value
    end
})

-- Visual Settings Tab
VisualsTab:CreateToggle({
    Name = "Show Health",
    Description = "Display player health percentage with color coding",
    Default = espSettings.showHealth,
    Callback = function(value)
        espSettings.showHealth = value
    end
})

VisualsTab:CreateToggle({
    Name = "Show Boxes",
    Description = "Draw bounding boxes around players",
    Default = espSettings.showBoxes,
    Callback = function(value)
        espSettings.showBoxes = value
    end
})

VisualsTab:CreateToggle({
    Name = "Show Tracers",
    Description = "Draw lines from screen center to players",
    Default = espSettings.showTracers,
    Callback = function(value)
        espSettings.showTracers = value
    end
})

-- Utility Tab
UtilityTab:CreateButton({
    Name = "Refresh ESP",
    Description = "Reload ESP for all players in the server",
    Callback = function()
        -- Remove all existing ESP
        for targetPlayer, _ in pairs(espObjects) do
            removeESPForPlayer(targetPlayer)
        end
        
        -- Recreate ESP if enabled
        if espEnabled then
            for _, targetPlayer in pairs(Players:GetPlayers()) do
                createESPForPlayer(targetPlayer)
            end
        end
        
        Framework:CreateNotification({
            Title = "ESP Refreshed",
            Content = "All ESP objects have been reloaded!",
            Duration = 2
        })
    end
})

UtilityTab:CreateButton({
    Name = "Reset All Settings",
    Description = "Reset all ESP settings to their default values",
    Callback = function()
        espSettings = {
            showNames = true,
            showDistance = true,
            showHealth = true,
            showBoxes = true,
            showTracers = false,
            maxDistance = 1000
        }
        
        Framework:CreateNotification({
            Title = "Settings Reset",
            Content = "All settings have been reset to default!",
            Duration = 2
        })
    end
})

UtilityTab:CreateToggle({
    Name = "Enable Notifications",
    Description = "Show system notifications for ESP events",
    Default = true,
    Callback = function(value)
        print("Notifications:", value and "Enabled" or "Disabled")
    end
})

-- Information Tab
InfoTab:CreateButton({
    Name = "Player Statistics",
    Description = "View current player count and ESP status",
    Callback = function()
        local playerCount = #Players:GetPlayers() - 1 -- Exclude local player
        local espCount = 0
        for _ in pairs(espObjects) do
            espCount = espCount + 1
        end
        
        Framework:CreateNotification({
            Title = "Player Statistics",
            Content = string.format("Total Players: %d | ESP Active: %d", playerCount, espCount),
            Duration = 4
        })
    end
})

InfoTab:CreateButton({
    Name = "Performance Metrics",
    Description = "View ESP system performance information",
    Callback = function()
        local drawingCount = 0
        for _, esp in pairs(espObjects) do
            drawingCount = drawingCount + #esp.drawings
        end
        
        Framework:CreateNotification({
            Title = "Performance Metrics",
            Content = string.format("Active Drawings: %d | Status: Optimized", drawingCount),
            Duration = 4
        })
    end
})

InfoTab:CreateButton({
    Name = "About ESP System",
    Description = "Information about this ESP system",
    Callback = function()
        Framework:CreateNotification({
            Title = "ESP System v3.0",
            Content = "Beautiful sidebar layout with enhanced UI and smooth animations!",
            Duration = 5
        })
    end
})

-- Cleanup function
local function cleanup()
    for targetPlayer, _ in pairs(espObjects) do
        removeESPForPlayer(targetPlayer)
    end
end

-- Cleanup on GUI close
Window.ScreenGui.AncestryChanged:Connect(function()
    if not Window.ScreenGui.Parent then
        cleanup()
    end
end)

-- Initialize ESP for existing players
for _, targetPlayer in pairs(Players:GetPlayers()) do
    if targetPlayer ~= player then
        createESPForPlayer(targetPlayer)
    end
end

print("🎯 Beautiful Sidebar ESP System loaded successfully!")
print("📋 Layout: Left sidebar with tabs, right content area")
print("✨ Features: Beautiful buttons, smooth animations, enhanced UI")
print("🔧 Use the sidebar tabs to navigate between different sections")
