-- Advanced GUI Framework - Rayfield Style
-- Professional Roblox GUI Library with all features

local GuiFramework = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Framework Variables
local currentWindow = nil
local currentTab = nil

-- Utility Functions
local function tween(object, info, properties)
    local tweenInfo = TweenInfo.new(
        info.Time or 0.3,
        info.EasingStyle or Enum.EasingStyle.Quart,
        info.EasingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(100, 150, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

-- Create Window Function
function GuiFramework:CreateWindow(config)
    local windowConfig = {
        Name = config.Name or "Framework GUI",
        LoadingTitle = config.LoadingTitle or "Loading...",
        LoadingSubtitle = config.LoadingSubtitle or "Please wait",
        ConfigurationSaving = config.ConfigurationSaving or {
            Enabled = false,
            FolderName = "FrameworkConfigs",
            FileName = "config"
        },
        Discord = config.Discord or {
            Enabled = false,
            Invite = "",
            RememberJoins = false
        },
        KeySystem = config.KeySystem or false
    }

    -- Destroy existing window
    if currentWindow and currentWindow.ScreenGui then
        currentWindow.ScreenGui:Destroy()
    end

    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FrameworkGUI"
    screenGui.Parent = playerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Floating particles background
    for i = 1, 15 do
        local particle = Instance.new("Frame")
        particle.Name = "Particle" .. i
        particle.Parent = screenGui
        particle.Size = UDim2.new(0, math.random(1, 2), 0, math.random(1, 2))
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.BackgroundColor3 = Color3.fromRGB(100 + math.random(155), 150 + math.random(105), 255)
        particle.BackgroundTransparency = math.random(80, 95) / 100
        particle.BorderSizePixel = 0
        particle.ZIndex = 1
        
        createCorner(particle, 50)
        
        -- Floating animation
        spawn(function()
            while particle.Parent do
                tween(particle, {Time = math.random(8, 15), EasingStyle = Enum.EasingStyle.Sine}, {
                    Position = UDim2.new(math.random(), 0, math.random(), 0),
                    BackgroundTransparency = math.random(80, 98) / 100
                })
                wait(math.random(8, 15))
            end
        end)
    end

    -- Main Container
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Parent = screenGui
    mainContainer.Size = UDim2.new(0, 600, 0, 600)
    mainContainer.Position = UDim2.new(0.5, -300, 0.5, -300)
    mainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    mainContainer.BackgroundTransparency = 0.1
    mainContainer.BorderSizePixel = 0
    mainContainer.ZIndex = 2

    createCorner(mainContainer, 20)

    -- Animated neon border
    local neonStroke = createStroke(mainContainer, Color3.fromRGB(100, 150, 255), 2, 0.2)
    
    -- Border animation
    spawn(function()
        while neonStroke.Parent do
            local colors = {
                Color3.fromRGB(100, 150, 255),
                Color3.fromRGB(150, 100, 255),
                Color3.fromRGB(255, 100, 150),
                Color3.fromRGB(100, 255, 150)
            }
            
            for _, color in ipairs(colors) do
                tween(neonStroke, {Time = 2}, {Color = color})
                wait(2)
            end
        end
    end)

    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Parent = mainContainer
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundTransparency = 1

    local logoText = Instance.new("TextLabel")
    logoText.Parent = header
    logoText.Size = UDim2.new(0.6, 0, 1, 0)
    logoText.Position = UDim2.new(0, 20, 0, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = windowConfig.Name
    logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logoText.TextSize = 18
    logoText.Font = Enum.Font.GothamBold
    logoText.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = header
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.BackgroundTransparency = 0.3
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold

    createCorner(closeButton, 15)

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainContainer
    sidebar.Size = UDim2.new(0, 200, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
    sidebar.BackgroundTransparency = 0.05
    sidebar.BorderSizePixel = 0

    createCorner(sidebar, 20)

    -- Sidebar gradient
    local sidebarGradient = Instance.new("UIGradient")
    sidebarGradient.Parent = sidebar
    sidebarGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 10, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 15, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 25))
    }
    sidebarGradient.Rotation = 135

    -- Animated sidebar gradient
    spawn(function()
        while sidebarGradient.Parent do
            tween(sidebarGradient, {Time = 4, EasingStyle = Enum.EasingStyle.Sine}, {Rotation = 315})
            wait(4)
            tween(sidebarGradient, {Time = 4, EasingStyle = Enum.EasingStyle.Sine}, {Rotation = 135})
            wait(4)
        end
    end)

    createStroke(sidebar, Color3.fromRGB(120, 80, 255), 1.5, 0.4)

    -- Tab Container
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = sidebar
    tabContainer.Size = UDim2.new(1, -10, 1, -20)
    tabContainer.Position = UDim2.new(0, 5, 0, 10)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 2
    tabContainer.ScrollBarImageColor3 = Color3.fromRGB(150, 100, 255)
    tabContainer.ScrollBarImageTransparency = 0.3

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabContainer
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 5)

    -- Content Area
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Parent = mainContainer
    contentArea.Size = UDim2.new(0, 385, 1, -60)
    contentArea.Position = UDim2.new(0, 210, 0, 50)
    contentArea.BackgroundTransparency = 1

    -- Content Header
    local contentHeader = Instance.new("Frame")
    contentHeader.Name = "ContentHeader"
    contentHeader.Parent = contentArea
    contentHeader.Size = UDim2.new(1, 0, 0, 40)
    contentHeader.BackgroundTransparency = 1

    local tabTitle = Instance.new("TextLabel")
    tabTitle.Name = "TabTitle"
    tabTitle.Parent = contentHeader
    tabTitle.Size = UDim2.new(1, 0, 1, 0)
    tabTitle.BackgroundTransparency = 1
    tabTitle.Text = "• Home"
    tabTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabTitle.TextSize = 20
    tabTitle.Font = Enum.Font.GothamBold
    tabTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Tab Content Container
    local tabContentContainer = Instance.new("Frame")
    tabContentContainer.Name = "TabContentContainer"
    tabContentContainer.Parent = contentArea
    tabContentContainer.Size = UDim2.new(1, 0, 1, -50)
    tabContentContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContentContainer.BackgroundTransparency = 1

    -- Window object
    local Window = {
        ScreenGui = screenGui,
        MainContainer = mainContainer,
        Sidebar = sidebar,
        TabContainer = tabContainer,
        ContentArea = contentArea,
        TabTitle = tabTitle,
        TabContentContainer = tabContentContainer,
        TabLayout = tabLayout,
        Tabs = {},
        CurrentTab = nil
    }

    currentWindow = Window

    -- Create Tab Function
    function Window:CreateTab(config)
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or "T",
            Color = config.Color or Color3.fromRGB(120, 150, 255)
        }

        -- Tab Button
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "Tab_" .. tabConfig.Name
        tabButton.Parent = self.TabContainer
        tabButton.Size = UDim2.new(1, -10, 0, 35)
        tabButton.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
        tabButton.BackgroundTransparency = 0.3
        tabButton.BorderSizePixel = 0
        tabButton.Text = ""

        createCorner(tabButton, 10)

        -- Tab glow
        local tabGlow = Instance.new("Frame")
        tabGlow.Parent = tabButton
        tabGlow.Size = UDim2.new(1, 4, 1, 4)
        tabGlow.Position = UDim2.new(0, -2, 0, -2)
        tabGlow.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        tabGlow.BackgroundTransparency = 0.9
        tabGlow.BorderSizePixel = 0
        tabGlow.ZIndex = tabButton.ZIndex - 1

        createCorner(tabGlow, 12)

        -- Tab icon
        local tabIcon = Instance.new("TextLabel")
        tabIcon.Parent = tabButton
        tabIcon.Size = UDim2.new(0, 30, 0, 30)
        tabIcon.Position = UDim2.new(0, 8, 0.5, -15)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Text = tabConfig.Icon
        tabIcon.TextColor3 = Color3.fromRGB(150, 150, 180)
        tabIcon.TextSize = 16
        tabIcon.Font = Enum.Font.GothamBold
        tabIcon.TextXAlignment = Enum.TextXAlignment.Center

        -- Tab text
        local tabText = Instance.new("TextLabel")
        tabText.Parent = tabButton
        tabText.Size = UDim2.new(1, -45, 1, 0)
        tabText.Position = UDim2.new(0, 45, 0, 0)
        tabText.BackgroundTransparency = 1
        tabText.Text = tabConfig.Name
        tabText.TextColor3 = Color3.fromRGB(150, 150, 180)
        tabText.TextSize = 14
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
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 150, 255)
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
            Glow = tabGlow,
            Config = tabConfig,
            Elements = {}
        }

        -- Tab hover effects
        tabButton.MouseEnter:Connect(function()
            if Tab ~= self.CurrentTab then
                tween(tabButton, {}, {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(30, 25, 45)})
                tween(tabGlow, {}, {BackgroundTransparency = 0.6, BackgroundColor3 = tabConfig.Color})
                tween(tabText, {}, {TextColor3 = Color3.fromRGB(220, 220, 240)})
                tween(tabIcon, {}, {TextColor3 = tabConfig.Color})
            end
        end)

        tabButton.MouseLeave:Connect(function()
            if Tab ~= self.CurrentTab then
                tween(tabButton, {}, {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(18, 15, 30)})
                tween(tabGlow, {}, {BackgroundTransparency = 0.9, BackgroundColor3 = Color3.fromRGB(30, 30, 50)})
                tween(tabText, {}, {TextColor3 = Color3.fromRGB(150, 150, 180)})
                tween(tabIcon, {}, {TextColor3 = Color3.fromRGB(150, 150, 180)})
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

        -- Tab Functions
        function Tab:CreateButton(config)
            local buttonConfig = {
                Name = config.Name or "Button",
                Callback = config.Callback or function() end
            }

            local button = Instance.new("TextButton")
            button.Parent = self.Content
            button.Size = UDim2.new(1, 0, 0, 45)
            button.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            button.BackgroundTransparency = 0.2
            button.BorderSizePixel = 0
            button.Text = buttonConfig.Name
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.TextSize = 14
            button.Font = Enum.Font.GothamBold

            createCorner(button, 10)
            createStroke(button, Color3.fromRGB(100, 150, 255), 1, 0.6)

            -- Button hover
            button.MouseEnter:Connect(function()
                tween(button, {}, {BackgroundTransparency = 0.1})
            end)

            button.MouseLeave:Connect(function()
                tween(button, {}, {BackgroundTransparency = 0.2})
            end)

            button.MouseButton1Click:Connect(function()
                buttonConfig.Callback()
            end)

            self:UpdateCanvasSize()
            return button
        end

        function Tab:CreateToggle(config)
            local toggleConfig = {
                Name = config.Name or "Toggle",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, 50)
            container.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, Color3.fromRGB(80, 120, 200), 1, 0.6)

            local label = Instance.new("TextLabel")
            label.Parent = container
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleConfig.Name
            label.TextColor3 = Color3.fromRGB(255, 255, 255)
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left

            -- Toggle switch
            local toggleBg = Instance.new("Frame")
            toggleBg.Parent = container
            toggleBg.Size = UDim2.new(0, 50, 0, 25)
            toggleBg.Position = UDim2.new(1, -65, 0.5, -12.5)
            toggleBg.BackgroundColor3 = toggleConfig.Default and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 80)
            toggleBg.BorderSizePixel = 0

            createCorner(toggleBg, 12)

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Parent = toggleBg
            toggleCircle.Size = UDim2.new(0, 19, 0, 19)
            toggleCircle.Position = toggleConfig.Default and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
            toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleCircle.BorderSizePixel = 0

            createCorner(toggleCircle, 10)

            local button = Instance.new("TextButton")
            button.Parent = container
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundTransparency = 1
            button.Text = ""

            local isEnabled = toggleConfig.Default
            button.MouseButton1Click:Connect(function()
                isEnabled = not isEnabled
                
                local bgColor = isEnabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(60, 60, 80)
                local circlePos = isEnabled and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
                
                tween(toggleBg, {}, {BackgroundColor3 = bgColor})
                tween(toggleCircle, {}, {Position = circlePos})
                
                toggleConfig.Callback(isEnabled)
            end)

            self:UpdateCanvasSize()
            return {Container = container, GetValue = function() return isEnabled end}
        end

        function Tab:CreateSlider(config)
            local sliderConfig = {
                Name = config.Name or "Slider",
                Range = config.Range or {0, 100},
                Increment = config.Increment or 1,
                Default = config.Default or 50,
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, 70)
            container.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, Color3.fromRGB(80, 120, 200), 1, 0.6)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.6, 0, 0.4, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 5)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = sliderConfig.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = container
            valueLabel.Size = UDim2.new(0.3, 0, 0.4, 0)
            valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(sliderConfig.Default)
            valueLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
            valueLabel.TextSize = 14
            valueLabel.Font = Enum.Font.GothamMedium
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right

            -- Slider track
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Parent = container
            sliderTrack.Size = UDim2.new(1, -30, 0, 8)
            sliderTrack.Position = UDim2.new(0, 15, 0.7, 0)
            sliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            sliderTrack.BorderSizePixel = 0

            createCorner(sliderTrack, 4)

            -- Slider fill
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderTrack
            sliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Range[1]) / (sliderConfig.Range[2] - sliderConfig.Range[1]), 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BorderSizePixel = 0

            createCorner(sliderFill, 4)

            -- Gradient fill
            local fillGradient = Instance.new("UIGradient")
            fillGradient.Parent = sliderFill
            fillGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 100, 255))
            }

            -- Slider interaction
            local dragging = false
            local currentValue = sliderConfig.Default

            local function updateSlider(input)
                local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(sliderConfig.Range[1] + (relativeX * (sliderConfig.Range[2] - sliderConfig.Range[1])) / sliderConfig.Increment + 0.5) * sliderConfig.Increment
                currentValue = math.clamp(currentValue, sliderConfig.Range[1], sliderConfig.Range[2])
                
                valueLabel.Text = tostring(currentValue)
                tween(sliderFill, {Time = 0.1}, {Size = UDim2.new(relativeX, 0, 1, 0)})
                
                sliderConfig.Callback(currentValue)
            end

            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            self:UpdateCanvasSize()
            return {Container = container, GetValue = function() return currentValue end}
        end

        function Tab:CreateDropdown(config)
            local dropdownConfig = {
                Name = config.Name or "Dropdown",
                Options = config.Options or {"Option 1", "Option 2"},
                Default = config.Default or config.Options[1],
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, 50)
            container.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, Color3.fromRGB(80, 120, 200), 1, 0.6)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = dropdownConfig.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Parent = container
            dropdownButton.Size = UDim2.new(0.5, -20, 0, 35)
            dropdownButton.Position = UDim2.new(0.5, 5, 0.5, -17.5)
            dropdownButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            dropdownButton.BorderSizePixel = 0
            dropdownButton.Text = dropdownConfig.Default .. " ▼"
            dropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            dropdownButton.TextSize = 12
            dropdownButton.Font = Enum.Font.Gotham

            createCorner(dropdownButton, 8)

            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Parent = container
            dropdownFrame.Size = UDim2.new(0.5, -20, 0, #dropdownConfig.Options * 30)
            dropdownFrame.Position = UDim2.new(0.5, 5, 1, 5)
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Visible = false
            dropdownFrame.ZIndex = 10

            createCorner(dropdownFrame, 8)
            createStroke(dropdownFrame, Color3.fromRGB(80, 120, 200), 1, 0.6)

            local optionLayout = Instance.new("UIListLayout")
            optionLayout.Parent = dropdownFrame
            optionLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local currentOption = dropdownConfig.Default
            local isOpen = false

            for _, option in ipairs(dropdownConfig.Options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Parent = dropdownFrame
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                optionButton.BackgroundTransparency = 0.5
                optionButton.BorderSizePixel = 0
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                optionButton.TextSize = 12
                optionButton.Font = Enum.Font.Gotham

                optionButton.MouseEnter:Connect(function()
                    tween(optionButton, {}, {BackgroundTransparency = 0.2})
                end)

                optionButton.MouseLeave:Connect(function()
                    tween(optionButton, {}, {BackgroundTransparency = 0.5})
                end)

                optionButton.MouseButton1Click:Connect(function()
                    currentOption = option
                    dropdownButton.Text = option .. " ▼"
                    dropdownFrame.Visible = false
                    isOpen = false
                    dropdownConfig.Callback(option)
                end)
            end

            dropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                dropdownFrame.Visible = isOpen
                dropdownButton.Text = currentOption .. (isOpen and " ▲" or " ▼")
            end)

            self:UpdateCanvasSize()
            return {Container = container, GetValue = function() return currentOption end}
        end

        function Tab:CreateInput(config)
            local inputConfig = {
                Name = config.Name or "Input",
                Default = config.Default or "",
                Placeholder = config.Placeholder or "Enter text...",
                RemoveTextAfterFocusLost = config.RemoveTextAfterFocusLost or false,
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, 50)
            container.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, Color3.fromRGB(80, 120, 200), 1, 0.6)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.3, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = inputConfig.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local inputBox = Instance.new("TextBox")
            inputBox.Parent = container
            inputBox.Size = UDim2.new(0.65, -20, 0, 30)
            inputBox.Position = UDim2.new(0.35, 5, 0.5, -15)
            inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            inputBox.BorderSizePixel = 0
            inputBox.Text = inputConfig.Default
            inputBox.PlaceholderText = inputConfig.Placeholder
            inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
            inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            inputBox.TextSize = 12
            inputBox.Font = Enum.Font.Gotham
            inputBox.ClearTextOnFocus = false

            createCorner(inputBox, 8)

            local inputStroke = createStroke(inputBox, Color3.fromRGB(80, 120, 200), 1, 0.6)

            inputBox.Focused:Connect(function()
                tween(inputStroke, {}, {Color = Color3.fromRGB(150, 200, 255), Transparency = 0.3})
            end)

            inputBox.FocusLost:Connect(function()
                tween(inputStroke, {}, {Color = Color3.fromRGB(80, 120, 200), Transparency = 0.6})
                if inputConfig.RemoveTextAfterFocusLost then
                    inputBox.Text = ""
                end
                inputConfig.Callback(inputBox.Text)
            end)

            self:UpdateCanvasSize()
            return {Container = container, GetValue = function() return inputBox.Text end}
        end

        function Tab:CreateLabel(config)
            local labelConfig = {
                Text = config.Text or "Label",
                Size = config.Size or 14
            }

            local label = Instance.new("TextLabel")
            label.Parent = self.Content
            label.Size = UDim2.new(1, 0, 0, 35)
            label.BackgroundTransparency = 1
            label.Text = labelConfig.Text
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = labelConfig.Size
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextWrapped = true

            self:UpdateCanvasSize()
            return label
        end

        function Tab:CreateParagraph(config)
            local paragraphConfig = {
                Title = config.Title or "Paragraph",
                Content = config.Content or "Content"
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, 80)
            container.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, Color3.fromRGB(80, 120, 200), 1, 0.6)

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Parent = container
            titleLabel.Size = UDim2.new(1, -20, 0.3, 0)
            titleLabel.Position = UDim2.new(0, 10, 0, 5)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = paragraphConfig.Title
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextSize = 16
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local contentLabel = Instance.new("TextLabel")
            contentLabel.Parent = container
            contentLabel.Size = UDim2.new(1, -20, 0.65, 0)
            contentLabel.Position = UDim2.new(0, 10, 0.35, 0)
            contentLabel.BackgroundTransparency = 1
            contentLabel.Text = paragraphConfig.Content
            contentLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
            contentLabel.TextSize = 12
            contentLabel.Font = Enum.Font.Gotham
            contentLabel.TextXAlignment = Enum.TextXAlignment.Left
            contentLabel.TextYAlignment = Enum.TextYAlignment.Top
            contentLabel.TextWrapped = true

            self:UpdateCanvasSize()
            return container
        end

        function Tab:CreateKeybind(config)
            local keybindConfig = {
                Name = config.Name or "Keybind",
                Default = config.Default or Enum.KeyCode.F,
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, 50)
            container.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, Color3.fromRGB(80, 120, 200), 1, 0.6)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = keybindConfig.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local keybindButton = Instance.new("TextButton")
            keybindButton.Parent = container
            keybindButton.Size = UDim2.new(0, 80, 0, 30)
            keybindButton.Position = UDim2.new(1, -95, 0.5, -15)
            keybindButton.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            keybindButton.BorderSizePixel = 0
            keybindButton.Text = keybindConfig.Default.Name
            keybindButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            keybindButton.TextSize = 12
            keybindButton.Font = Enum.Font.Gotham

            createCorner(keybindButton, 8)

            local currentKey = keybindConfig.Default
            local isBinding = false

            keybindButton.MouseButton1Click:Connect(function()
                if not isBinding then
                    isBinding = true
                    keybindButton.Text = "..."
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            keybindButton.Text = currentKey.Name
                            isBinding = false
                            connection:Disconnect()
                        end
                    end)
                end
            end)

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == currentKey then
                    keybindConfig.Callback()
                end
            end)

            self:UpdateCanvasSize()
            return {Container = container, GetValue = function() return currentKey end}
        end

        function Tab:CreateColorPicker(config)
            local colorConfig = {
                Name = config.Name or "Color Picker",
                Default = config.Default or Color3.fromRGB(255, 255, 255),
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, 50)
            container.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, Color3.fromRGB(80, 120, 200), 1, 0.6)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = colorConfig.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local colorDisplay = Instance.new("Frame")
            colorDisplay.Parent = container
            colorDisplay.Size = UDim2.new(0, 40, 0, 25)
            colorDisplay.Position = UDim2.new(1, -55, 0.5, -12.5)
            colorDisplay.BackgroundColor3 = colorConfig.Default
            colorDisplay.BorderSizePixel = 0

            createCorner(colorDisplay, 8)
            createStroke(colorDisplay, Color3.fromRGB(255, 255, 255), 1, 0.3)

            local colorButton = Instance.new("TextButton")
            colorButton.Parent = colorDisplay
            colorButton.Size = UDim2.new(1, 0, 1, 0)
            colorButton.BackgroundTransparency = 1
            colorButton.Text = ""

            local currentColor = colorConfig.Default

            colorButton.MouseButton1Click:Connect(function()
                -- Simple color cycling for demo
                local colors = {
                    Color3.fromRGB(255, 100, 100),
                    Color3.fromRGB(100, 255, 100),
                    Color3.fromRGB(100, 100, 255),
                    Color3.fromRGB(255, 255, 100),
                    Color3.fromRGB(255, 100, 255),
                    Color3.fromRGB(100, 255, 255),
                    Color3.fromRGB(255, 255, 255)
                }
                
                local currentIndex = 1
                for i, color in ipairs(colors) do
                    if color == currentColor then
                        currentIndex = i
                        break
                    end
                end
                
                currentIndex = (currentIndex % #colors) + 1
                currentColor = colors[currentIndex]
                
                tween(colorDisplay, {}, {BackgroundColor3 = currentColor})
                colorConfig.Callback(currentColor)
            end)

            self:UpdateCanvasSize()
            return {Container = container, GetValue = function() return currentColor end}
        end

        function Tab:UpdateCanvasSize()
            self.Content.CanvasSize = UDim2.new(0, 0, 0, self.Layout.AbsoluteContentSize.Y + 20)
        end

        return Tab
    end

    function Window:SelectTab(tab)
        -- Hide all tabs
        for _, otherTab in ipairs(self.Tabs) do
            otherTab.Content.Visible = false
            tween(otherTab.Button, {}, {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(18, 15, 30)})
            tween(otherTab.Glow, {}, {BackgroundTransparency = 0.9, BackgroundColor3 = Color3.fromRGB(30, 30, 50)})
            tween(otherTab.Text, {}, {TextColor3 = Color3.fromRGB(150, 150, 180)})
            tween(otherTab.Icon, {}, {TextColor3 = Color3.fromRGB(150, 150, 180)})
            
            if otherTab.Button:FindFirstChild("UIStroke") then
                otherTab.Button.UIStroke:Destroy()
            end
        end

        -- Show selected tab
        tab.Content.Visible = true
        self.CurrentTab = tab
        self.TabTitle.Text = "• " .. tab.Name

        -- Style selected tab
        tween(tab.Button, {}, {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(35, 30, 50)})
        tween(tab.Glow, {}, {BackgroundTransparency = 0.5, BackgroundColor3 = tab.Config.Color})
        tween(tab.Text, {}, {TextColor3 = Color3.fromRGB(255, 255, 255)})
        tween(tab.Icon, {}, {TextColor3 = tab.Config.Color})

        -- Add active stroke
        local activeStroke = createStroke(tab.Button, tab.Config.Color, 1.5, 0.3)

        -- Update scroll sizes
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, self.TabLayout.AbsoluteContentSize.Y + 10)
        tab:UpdateCanvasSize()
    end

    return Window
end

-- Example Usage
--[[
local Framework = GuiFramework

local Window = Framework:CreateWindow({
    Name = "My Awesome Script",
    LoadingTitle = "Loading Framework",
    LoadingSubtitle = "Please wait...",
})

local Tab1 = Window:CreateTab({
    Name = "Main",
    Icon = "M",
    Color = Color3.fromRGB(100, 200, 255)
})

Tab1:CreateButton({
    Name = "Test Button",
    Callback = function()
        print("Button clicked!")
    end
})

Tab1:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

Tab1:CreateSlider({
    Name = "Walkspeed",
    Range = {16, 100},
    Increment = 1,
    Default = 16,
    Callback = function(value)
        print("Slider:", value)
    end
})

Tab1:CreateDropdown({
    Name = "Game Mode",
    Options = {"Normal", "Hard", "Expert"},
    Default = "Normal",
    Callback = function(value)
        print("Dropdown:", value)
    end
})

Tab1:CreateInput({
    Name = "Player Name",
    Placeholder = "Enter player name...",
    Callback = function(text)
        print("Input:", text)
    end
})

Tab1:CreateKeybind({
    Name = "Toggle GUI",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Keybind pressed!")
    end
})

Tab1:CreateColorPicker({
    Name = "UI Color",
    Default = Color3.fromRGB(100, 200, 255),
    Callback = function(color)
        print("Color:", color)
    end
})

Tab1:CreateLabel({
    Text = "This is a label!"
})

Tab1:CreateParagraph({
    Title = "Information",
    Content = "This is a paragraph with multiple lines of text. You can use this to display important information to users."
})

local Tab2 = Window:CreateTab({
    Name = "Settings",
    Icon = "S",
    Color = Color3.fromRGB(255, 150, 100)
})

Tab2:CreateLabel({
    Text = "Settings tab is ready!"
})
--]]

print("🚀 Advanced GUI Framework loaded!")
print("Usage: local Window = GuiFramework:CreateWindow({Name = 'My Script'})")

return GuiFramework


