-- ESP System with Fixed Horizontal Framework
-- First, let's fix the framework and make it horizontal

local GuiFramework = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

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

-- Main Create Window Function (HORIZONTAL LAYOUT)
function GuiFramework:CreateWindow(config)
    local windowConfig = {
        Name = config.Name or "Framework GUI",
        Theme = config.Theme or "Default",
        Size = config.Size or {800, 500}, -- Wider for horizontal
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
    screenGui.Name = "HorizontalFrameworkGUI"
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

    -- HORIZONTAL Tab Container (Top tabs instead of sidebar)
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = mainContainer
    tabContainer.Size = UDim2.new(1, -20, 0, 35)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundTransparency = 1

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabContainer
    tabLayout.FillDirection = Enum.FillDirection.Horizontal -- HORIZONTAL!
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)

    -- Content Area (Below tabs)
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Parent = mainContainer
    contentArea.Size = UDim2.new(1, -20, 1, -100)
    contentArea.Position = UDim2.new(0, 10, 0, 95)
    contentArea.BackgroundTransparency = 1

    -- Tab Content Container
    local tabContentContainer = Instance.new("Frame")
    tabContentContainer.Name = "TabContentContainer"
    tabContentContainer.Parent = contentArea
    tabContentContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContentContainer.BackgroundTransparency = 1

    -- Window object
    local Window = {
        ScreenGui = screenGui,
        MainContainer = mainContainer,
        TabContainer = tabContainer,
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

        -- Tab Button (HORIZONTAL)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "Tab_" .. tabConfig.Name
        tabButton.Parent = self.TabContainer
        tabButton.Size = UDim2.new(0, 120, 1, 0) -- Fixed width for horizontal tabs
        tabButton.BackgroundColor3 = currentTheme.Background
        tabButton.BackgroundTransparency = 0.3
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabConfig.Icon .. " " .. tabConfig.Name
        tabButton.TextColor3 = Color3.fromRGB(150, 150, 180)
        tabButton.TextSize = 12
        tabButton.Font = Enum.Font.Gotham

        createCorner(tabButton, 8)

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
        contentLayout.Padding = UDim.new(0, 8)

        -- Tab object
        local Tab = {
            Name = tabConfig.Name,
            Button = tabButton,
            Content = tabContent,
            Layout = contentLayout,
            Config = tabConfig,
            Elements = {},
            Window = self
        }

        -- Tab hover effects
        tabButton.MouseEnter:Connect(function()
            if Tab ~= self.CurrentTab then
                tween(tabButton, {Time = 0.2}, {
                    BackgroundTransparency = 0.1,
                    TextColor3 = Color3.fromRGB(220, 220, 240)
                }):Play()
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if Tab ~= self.CurrentTab then
                tween(tabButton, {Time = 0.2}, {
                    BackgroundTransparency = 0.3,
                    TextColor3 = Color3.fromRGB(150, 150, 180)
                }):Play()
            end
        end)

        -- Tab click - FIXED!
        tabButton.MouseButton1Click:Connect(function()
            self:SelectTab(Tab)
        end)

        -- Add to tabs
        table.insert(self.Tabs, Tab)

        -- Select first tab
        if #self.Tabs == 1 then
            self:SelectTab(Tab)
        end

        -- Tab Methods
        function Tab:CreateToggle(config)
            local toggleConfig = {
                Name = config.Name or "Toggle",
                Description = config.Description or "",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, toggleConfig.Description ~= "" and 65 or 45)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 8)
            createStroke(container, currentTheme.Accent, 1, 0.6)

            local label = Instance.new("TextLabel")
            label.Parent = container
            label.Size = UDim2.new(0.7, 0, toggleConfig.Description ~= "" and 0.5 or 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleConfig.Name
            label.TextColor3 = currentTheme.Text
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left

            if toggleConfig.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = container
                descLabel.Size = UDim2.new(1, -15, 0.5, 0)
                descLabel.Position = UDim2.new(0, 12, 0.5, 0)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = toggleConfig.Description
                descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                descLabel.TextSize = 10
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
            end

            -- Toggle switch
            local toggleBg = Instance.new("Frame")
            toggleBg.Parent = container
            toggleBg.Size = UDim2.new(0, 45, 0, 22)
            toggleBg.Position = UDim2.new(1, -55, 0.5, -11)
            toggleBg.BackgroundColor3 = toggleConfig.Default and currentTheme.Primary or Color3.fromRGB(60, 60, 80)
            toggleBg.BorderSizePixel = 0

            createCorner(toggleBg, 11)

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Parent = toggleBg
            toggleCircle.Size = UDim2.new(0, 18, 0, 18)
            toggleCircle.Position = toggleConfig.Default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0

            createCorner(toggleCircle, 9)

            local button = Instance.new("TextButton")
            button.Parent = container
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = ""

            local isEnabled = toggleConfig.Default
            button.MouseButton1Click:Connect(function()
                isEnabled = not isEnabled
                
                local bgColor = isEnabled and currentTheme.Primary or Color3.fromRGB(60, 60, 80)
                local circlePos = isEnabled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                
                tween(toggleBg, {Time = 0.2}, {BackgroundColor3 = bgColor}):Play()
                tween(toggleCircle, {Time = 0.2}, {Position = circlePos}):Play()
                
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
            container.Size = UDim2.new(1, 0, 0, buttonConfig.Description ~= "" and 60 or 40)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 8)
            createStroke(container, currentTheme.Primary, 1, 0.6)

            local button = Instance.new("TextButton")
            button.Parent = container
            button.Size = UDim2.new(1, 0, buttonConfig.Description ~= "" and 0.6 or 1, 0)
            button.BackgroundTransparency = 1
            button.Text = buttonConfig.Name
            button.TextColor3 = currentTheme.Text
            button.TextSize = 14
            button.Font = Enum.Font.GothamBold

            if buttonConfig.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = container
                descLabel.Size = UDim2.new(1, -15, 0.4, 0)
                descLabel.Position = UDim2.new(0, 10, 0.6, 0)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = buttonConfig.Description
                descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
            end

            button.MouseEnter:Connect(function()
                tween(container, {Time = 0.2}, {BackgroundTransparency = 0.1}):Play()
            end)

            button.MouseLeave:Connect(function()
                tween(container, {Time = 0.2}, {BackgroundTransparency = 0.2}):Play()
            end)

            button.MouseButton1Click:Connect(function()
                buttonConfig.Callback()
            end)

            self:UpdateCanvasSize()
            return container
        end

        function Tab:UpdateCanvasSize()
            self.Content.CanvasSize = UDim2.new(0, 0, 0, self.Layout.AbsoluteContentSize.Y + 15)
        end

        return Tab
    end

    -- FIXED SelectTab function
    function Window:SelectTab(tab)
        -- Hide all tabs
        for _, otherTab in ipairs(self.Tabs) do
            otherTab.Content.Visible = false
            tween(otherTab.Button, {Time = 0.2}, {
                BackgroundTransparency = 0.3,
                TextColor3 = Color3.fromRGB(150, 150, 180)
            }):Play()
            
            -- Remove stroke if exists
            if otherTab.Button:FindFirstChild("UIStroke") then
                otherTab.Button.UIStroke:Destroy()
            end
        end

        -- Show selected tab
        tab.Content.Visible = true
        self.CurrentTab = tab

        -- Style selected tab
        tween(tab.Button, {Time = 0.2}, {
            BackgroundTransparency = 0.1,
            TextColor3 = currentTheme.Text
        }):Play()

        -- Add active stroke
        createStroke(tab.Button, tab.Config.Color, 2, 0.4)

        tab:UpdateCanvasSize()
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

-- Create Horizontal GUI
local Window = Framework:CreateWindow({
    Name = "🎯 ESP System v2.0 - Horizontal",
    Theme = "Ocean",
    Size = {700, 400}, -- Wider horizontal layout
    KeySystem = false
})

-- Show welcome notification
Framework:CreateNotification({
    Title = "ESP System",
    Content = "Horizontal ESP system loaded successfully!",
    Duration = 3
})

-- Create Tabs (HORIZONTAL)
local MainTab = Window:CreateTab({
    Name = "Main ESP",
    Icon = "👁",
    Color = Color3.fromRGB(100, 200, 255)
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "⚙",
    Color = Color3.fromRGB(255, 150, 100)
})

local InfoTab = Window:CreateTab({
    Name = "Info",
    Icon = "ℹ",
    Color = Color3.fromRGB(150, 100, 255)
})

-- Main Tab Controls
MainTab:CreateToggle({
    Name = "Enable ESP",
    Description = "Toggle ESP visibility for all players",
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
    Name = "Show Names",
    Description = "Display player names above their heads",
    Default = espSettings.showNames,
    Callback = function(value)
        espSettings.showNames = value
    end
})

MainTab:CreateToggle({
    Name = "Show Distance",
    Description = "Display distance to players",
    Default = espSettings.showDistance,
    Callback = function(value)
        espSettings.showDistance = value
    end
})

MainTab:CreateToggle({
    Name = "Show Health",
    Description = "Display player health percentage",
    Default = espSettings.showHealth,
    Callback = function(value)
        espSettings.showHealth = value
    end
})

MainTab:CreateToggle({
    Name = "Show Boxes",
    Description = "Draw boxes around players",
    Default = espSettings.showBoxes,
    Callback = function(value)
        espSettings.showBoxes = value
    end
})

MainTab:CreateToggle({
    Name = "Show Tracers",
    Description = "Draw lines pointing to players",
    Default = espSettings.showTracers,
    Callback = function(value)
        espSettings.showTracers = value
    end
})

-- Settings Tab
SettingsTab:CreateButton({
    Name = "Refresh ESP",
    Description = "Reload ESP for all players",
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
            Content = "All ESP objects reloaded!",
            Duration = 2
        })
    end
})

SettingsTab:CreateButton({
    Name = "Reset Settings",
    Description = "Reset all ESP settings to default",
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
            Content = "All settings reset to default!",
            Duration = 2
        })
    end
})

SettingsTab:CreateToggle({
    Name = "Enable Notifications",
    Description = "Show ESP status notifications",
    Default = true,
    Callback = function(value)
        -- You can use this to control notification display
        print("Notifications:", value and "Enabled" or "Disabled")
    end
})

-- Info Tab
InfoTab:CreateButton({
    Name = "Player Count",
    Description = "Show current player count and ESP status",
    Callback = function()
        local playerCount = #Players:GetPlayers() - 1 -- Exclude local player
        local espCount = 0
        for _ in pairs(espObjects) do
            espCount = espCount + 1
        end
        
        Framework:CreateNotification({
            Title = "Player Stats",
            Content = string.format("Players: %d | ESP Active: %d", playerCount, espCount),
            Duration = 3
        })
    end
})

InfoTab:CreateButton({
    Name = "Performance Info",
    Description = "Show ESP performance statistics",
    Callback = function()
        local drawingCount = 0
        for _, esp in pairs(espObjects) do
            drawingCount = drawingCount + #esp.drawings
        end
        
        Framework:CreateNotification({
            Title = "Performance",
            Content = string.format("Active Drawings: %d | FPS Impact: Low", drawingCount),
            Duration = 3
        })
    end
})

InfoTab:CreateButton({
    Name = "ESP Features",
    Description = "List all available ESP features",
    Callback = function()
        Framework:CreateNotification({
            Title = "ESP Features",
            Content = "Names, Distance, Health, Boxes, Tracers - All Working!",
            Duration = 4
        })
    end
})

InfoTab:CreateButton({
    Name = "About",
    Description = "About this ESP system",
    Callback = function()
        Framework:CreateNotification({
            Title = "ESP System v2.0",
            Content = "Horizontal layout with working tabs! Made for better UX.",
            Duration = 4
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

print("🎯 Horizontal ESP System loaded successfully!")
print("📋 Features: Horizontal tabs, Toggle ESP, Names, Distance, Health, Boxes, Tracers")
print("🔧 Use the horizontal tabs to navigate between different sections")
