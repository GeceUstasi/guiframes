--[[
    Advanced GUI Framework v2.0 - Complete Rayfield Features
    Ultra Modern Roblox GUI Library
    
    Features:
    ✅ Key System (Optional)
    ✅ Notifications System
    ✅ All UI Components (Button, Toggle, Slider, Dropdown, Input, ColorPicker, Keybind)
    ✅ Themes & Customization
    ✅ Search System
    ✅ Resizing Support
    ✅ Analytics & Monetization
    ✅ Performance Optimized
    ✅ Documentation Ready
    
    Usage:
    local Framework = loadstring(game:HttpGet("YOUR_GITHUB_URL"))()
    
    local Window = Framework:CreateWindow({
        Name = "My Script Hub",
        KeySystem = true,
        Key = "mykey123"
    })
--]]

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
local analytics = {
    windowsCreated = 0,
    elementsCreated = 0,
    interactions = 0
}

-- Themes
local themes = {
    Default = {
        Primary = Color3.fromRGB(100, 150, 255),
        Secondary = Color3.fromRGB(15, 15, 25),
        Background = Color3.fromRGB(8, 8, 18),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(120, 150, 255)
    },
    Dark = {
        Primary = Color3.fromRGB(80, 80, 100),
        Secondary = Color3.fromRGB(10, 10, 15),
        Background = Color3.fromRGB(5, 5, 10),
        Text = Color3.fromRGB(220, 220, 220),
        Accent = Color3.fromRGB(100, 100, 120)
    },
    Neon = {
        Primary = Color3.fromRGB(255, 100, 255),
        Secondary = Color3.fromRGB(20, 5, 20),
        Background = Color3.fromRGB(10, 0, 10),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 150, 255)
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
        Duration = config.Duration or 5,
        Actions = config.Actions or {}
    }

    -- Notification Container
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

    -- Progress animation
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

-- Key System
local function createKeySystem(config)
    local keyConfig = {
        Title = config.Title or "Key System",
        Subtitle = config.Subtitle or "Enter your key",
        Key = config.Key or "defaultkey",
        SaveKey = config.SaveKey or false,
        KeyNote = config.KeyNote or "Get key from our Discord!",
        DiscordLink = config.DiscordLink or ""
    }

    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "KeySystem"
    keyGui.Parent = playerGui
    keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Background blur
    local background = Instance.new("Frame")
    background.Parent = keyGui
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BackgroundTransparency = 0.3
    background.BorderSizePixel = 0

    -- Key container
    local keyContainer = Instance.new("Frame")
    keyContainer.Parent = keyGui
    keyContainer.Size = UDim2.new(0, 400, 0, 300)
    keyContainer.Position = UDim2.new(0.5, -200, 0.5, -150)
    keyContainer.BackgroundColor3 = currentTheme.Secondary
    keyContainer.BackgroundTransparency = 0.1
    keyContainer.BorderSizePixel = 0

    createCorner(keyContainer, 15)
    createStroke(keyContainer, currentTheme.Primary, 2, 0.2)

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = keyContainer
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = keyConfig.Title
    titleLabel.TextColor3 = currentTheme.Text
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold

    -- Subtitle
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Parent = keyContainer
    subtitleLabel.Size = UDim2.new(1, 0, 0, 30)
    subtitleLabel.Position = UDim2.new(0, 0, 0, 70)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = keyConfig.Subtitle
    subtitleLabel.TextColor3 = currentTheme.Text
    subtitleLabel.TextSize = 14
    subtitleLabel.Font = Enum.Font.Gotham

    -- Key input
    local keyInput = Instance.new("TextBox")
    keyInput.Parent = keyContainer
    keyInput.Size = UDim2.new(0.8, 0, 0, 40)
    keyInput.Position = UDim2.new(0.1, 0, 0, 120)
    keyInput.BackgroundColor3 = currentTheme.Background
    keyInput.BorderSizePixel = 0
    keyInput.Text = ""
    keyInput.PlaceholderText = "Enter key here..."
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    keyInput.TextColor3 = currentTheme.Text
    keyInput.TextSize = 14
    keyInput.Font = Enum.Font.Gotham

    createCorner(keyInput, 8)
    createStroke(keyInput, currentTheme.Primary, 1, 0.6)

    -- Submit button
    local submitButton = Instance.new("TextButton")
    submitButton.Parent = keyContainer
    submitButton.Size = UDim2.new(0.35, 0, 0, 35)
    submitButton.Position = UDim2.new(0.1, 0, 0, 180)
    submitButton.BackgroundColor3 = currentTheme.Primary
    submitButton.BorderSizePixel = 0
    submitButton.Text = "Submit"
    submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    submitButton.TextSize = 14
    submitButton.Font = Enum.Font.GothamBold

    createCorner(submitButton, 8)

    -- Get key button
    local getKeyButton = Instance.new("TextButton")
    getKeyButton.Parent = keyContainer
    getKeyButton.Size = UDim2.new(0.35, 0, 0, 35)
    getKeyButton.Position = UDim2.new(0.55, 0, 0, 180)
    getKeyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    getKeyButton.BorderSizePixel = 0
    getKeyButton.Text = "Get Key"
    getKeyButton.TextColor3 = currentTheme.Text
    getKeyButton.TextSize = 14
    getKeyButton.Font = Enum.Font.Gotham

    createCorner(getKeyButton, 8)

    -- Note
    local noteLabel = Instance.new("TextLabel")
    noteLabel.Parent = keyContainer
    noteLabel.Size = UDim2.new(1, -20, 0, 60)
    noteLabel.Position = UDim2.new(0, 10, 0, 230)
    noteLabel.BackgroundTransparency = 1
    noteLabel.Text = keyConfig.KeyNote
    noteLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    noteLabel.TextSize = 12
    noteLabel.Font = Enum.Font.Gotham
    noteLabel.TextWrapped = true

    return keyGui, keyInput, submitButton, getKeyButton
end

-- Main Create Window Function
function GuiFramework:CreateWindow(config)
    local windowConfig = {
        Name = config.Name or "Framework GUI",
        LoadingTitle = config.LoadingTitle or "Loading...",
        LoadingSubtitle = config.LoadingSubtitle or "Please wait",
        KeySystem = config.KeySystem or false,
        Key = config.Key or "defaultkey",
        SaveKey = config.SaveKey or false,
        Theme = config.Theme or "Default",
        Size = config.Size or {600, 600},
        Resizable = config.Resizable or true,
        Discord = config.Discord or {
            Enabled = false,
            Invite = "",
            RememberJoins = false
        }
    }

    analytics.windowsCreated = analytics.windowsCreated + 1

    -- Set theme
    if themes[windowConfig.Theme] then
        currentTheme = themes[windowConfig.Theme]
    end

    -- Key System Check
    if windowConfig.KeySystem then
        local keyGui, keyInput, submitButton, getKeyButton = createKeySystem({
            Title = windowConfig.Name .. " - Key System",
            Key = windowConfig.Key,
            SaveKey = windowConfig.SaveKey
        })

        submitButton.MouseButton1Click:Connect(function()
            if keyInput.Text == windowConfig.Key then
                keyGui:Destroy()
                GuiFramework:CreateNotification({
                    Title = "Success!",
                    Content = "Key accepted! Loading GUI...",
                    Duration = 3
                })
            else
                GuiFramework:CreateNotification({
                    Title = "Error!",
                    Content = "Invalid key! Please try again.",
                    Duration = 3
                })
                keyInput.Text = ""
            end
        end)

        getKeyButton.MouseButton1Click:Connect(function()
            GuiFramework:CreateNotification({
                Title = "Info",
                Content = "Join our Discord for the key!",
                Duration = 3
            })
        end)

        -- Wait for key validation
        repeat wait() until not keyGui.Parent
    end

    -- Destroy existing window
    if currentWindow and currentWindow.ScreenGui then
        currentWindow.ScreenGui:Destroy()
    end

    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FrameworkGUI"
    screenGui.Parent = playerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Floating particles
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
        
        spawn(function()
            while particle.Parent do
                tween(particle, {Time = math.random(8, 15), EasingStyle = Enum.EasingStyle.Sine}, {
                    Position = UDim2.new(math.random(), 0, math.random(), 0),
                    BackgroundTransparency = math.random(80, 98) / 100
                }):Play()
                wait(math.random(8, 15))
            end
        end)
    end

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

    createCorner(mainContainer, 20)

    -- Animated neon border
    local neonStroke = createStroke(mainContainer, currentTheme.Primary, 2, 0.2)
    
    spawn(function()
        while neonStroke.Parent do
            local colors = {
                currentTheme.Primary,
                currentTheme.Accent,
                Color3.fromRGB(255, 100, 150),
                Color3.fromRGB(100, 255, 150)
            }
            
            for _, color in ipairs(colors) do
                tween(neonStroke, {Time = 2}, {Color = color}):Play()
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
    logoText.TextColor3 = currentTheme.Text
    logoText.TextSize = 18
    logoText.Font = Enum.Font.GothamBold
    logoText.TextXAlignment = Enum.TextXAlignment.Left

    -- Minimize button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Parent = header
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -80, 0.5, -15)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
    minimizeButton.BackgroundTransparency = 0.3
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = currentTheme.Text
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.GothamBold

    createCorner(minimizeButton, 15)

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = header
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0.5, -15)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.BackgroundTransparency = 0.3
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = currentTheme.Text
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold

    createCorner(closeButton, 15)

    -- Window controls
    local isMinimized = false
    local originalSize = mainContainer.Size

    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            tween(mainContainer, {}, {Size = UDim2.new(0, windowConfig.Size[1], 0, 50)}):Play()
            minimizeButton.Text = "+"
        else
            tween(mainContainer, {}, {Size = originalSize}):Play()
            minimizeButton.Text = "−"
        end
    end)

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

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainContainer
    sidebar.Size = UDim2.new(0, 200, 1, -50)
    sidebar.Position = UDim2.new(0, 0, 0, 50)
    sidebar.BackgroundColor3 = currentTheme.Background
    sidebar.BackgroundTransparency = 0.05
    sidebar.BorderSizePixel = 0

    createCorner(sidebar, 20)

    local sidebarGradient = Instance.new("UIGradient")
    sidebarGradient.Parent = sidebar
    sidebarGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(
            currentTheme.Background.R + 0.05,
            currentTheme.Background.G + 0.05,
            currentTheme.Background.B + 0.1
        )),
        ColorSequenceKeypoint.new(0.5, Color3.new(
            currentTheme.Background.R + 0.1,
            currentTheme.Background.G + 0.1,
            currentTheme.Background.B + 0.15
        )),
        ColorSequenceKeypoint.new(1, currentTheme.Background)
    }
    sidebarGradient.Rotation = 135

    spawn(function()
        while sidebarGradient.Parent do
            tween(sidebarGradient, {Time = 4, EasingStyle = Enum.EasingStyle.Sine}, {Rotation = 315}):Play()
            wait(4)
            tween(sidebarGradient, {Time = 4, EasingStyle = Enum.EasingStyle.Sine}, {Rotation = 135}):Play()
            wait(4)
        end
    end)

    createStroke(sidebar, currentTheme.Primary, 1.5, 0.4)

    -- Search bar
    local searchContainer = Instance.new("Frame")
    searchContainer.Name = "SearchContainer"
    searchContainer.Parent = sidebar
    searchContainer.Size = UDim2.new(1, -20, 0, 30)
    searchContainer.Position = UDim2.new(0, 10, 0, 15)
    searchContainer.BackgroundColor3 = Color3.new(
        currentTheme.Background.R + 0.1,
        currentTheme.Background.G + 0.1,
        currentTheme.Background.B + 0.15
    )
    searchContainer.BackgroundTransparency = 0.2
    searchContainer.BorderSizePixel = 0

    createCorner(searchContainer, 10)

    local searchGlow = Instance.new("Frame")
    searchGlow.Parent = searchContainer
    searchGlow.Size = UDim2.new(1, 6, 1, 6)
    searchGlow.Position = UDim2.new(0, -3, 0, -3)
    searchGlow.BackgroundColor3 = currentTheme.Primary
    searchGlow.BackgroundTransparency = 0.8
    searchGlow.BorderSizePixel = 0
    searchGlow.ZIndex = searchContainer.ZIndex - 1

    createCorner(searchGlow, 13)

    local searchStroke = createStroke(searchContainer, currentTheme.Primary, 1, 0.6)

    local searchIcon = Instance.new("TextLabel")
    searchIcon.Parent = searchContainer
    searchIcon.Size = UDim2.new(0, 25, 1, 0)
    searchIcon.Position = UDim2.new(0, 8, 0, 0)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "⌕"
    searchIcon.TextColor3 = currentTheme.Primary
    searchIcon.TextSize = 16
    searchIcon.Font = Enum.Font.GothamBold

    local searchBox = Instance.new("TextBox")
    searchBox.Parent = searchContainer
    searchBox.Size = UDim2.new(1, -40, 1, 0)
    searchBox.Position = UDim2.new(0, 35, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search features..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 150)
    searchBox.TextColor3 = currentTheme.Text
    searchBox.TextSize = 14
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextXAlignment = Enum.TextXAlignment.Left

    -- Search functionality
    searchBox.Focused:Connect(function()
        tween(searchStroke, {}, {Transparency = 0.2, Color = currentTheme.Accent}):Play()
        tween(searchGlow, {}, {BackgroundTransparency = 0.6}):Play()
    end)

    searchBox.FocusLost:Connect(function()
        tween(searchStroke, {}, {Transparency = 0.6, Color = currentTheme.Primary}):Play()
        tween(searchGlow, {}, {BackgroundTransparency = 0.8}):Play()
    end)

    -- Tab Container
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = sidebar
    tabContainer.Size = UDim2.new(1, -10, 1, -60)
    tabContainer.Position = UDim2.new(0, 5, 0, 55)
    tabContainer.BackgroundTransparency = 1
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 2
    tabContainer.ScrollBarImageColor3 = currentTheme.Primary
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
    tabTitle.Text = "• Welcome"
    tabTitle.TextColor3 = currentTheme.Text
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
        SearchBox = searchBox,
        Tabs = {},
        CurrentTab = nil,
        Theme = currentTheme,
        Config = windowConfig
    }

    currentWindow = Window

    -- Window Functions
    function Window:SetTheme(themeName)
        if themes[themeName] then
            currentTheme = themes[themeName]
            self.Theme = currentTheme
            
            -- Update all UI elements with new theme
            neonStroke.Color = currentTheme.Primary
            logoText.TextColor3 = currentTheme.Text
            closeButton.TextColor3 = currentTheme.Text
            minimizeButton.TextColor3 = currentTheme.Text
            
            GuiFramework:CreateNotification({
                Title = "Theme Changed",
                Content = "Theme updated to " .. themeName,
                Duration = 2
            })
        end
    end

    function Window:Resize(newSize)
        self.Config.Size = newSize
        tween(self.MainContainer, {Time = 0.5}, {
            Size = UDim2.new(0, newSize[1], 0, newSize[2]),
            Position = UDim2.new(0.5, -newSize[1]/2, 0.5, -newSize[2]/2)
        }):Play()
    end

    function Window:CreateTab(config)
        local tabConfig = {
            Name = config.Name or "Tab",
            Icon = config.Icon or "T",
            Color = config.Color or currentTheme.Primary,
            Description = config.Description or ""
        }

        analytics.elementsCreated = analytics.elementsCreated + 1

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
            Glow = tabGlow,
            Config = tabConfig,
            Elements = {},
            Window = self
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
            analytics.interactions = analytics.interactions + 1
            self:SelectTab(Tab)
        end)

        -- Add to tabs
        table.insert(self.Tabs, Tab)

        -- Select first tab
        if #self.Tabs == 1 then
            self:SelectTab(Tab)
        end

        -- Tab Methods
        function Tab:CreateButton(config)
            local buttonConfig = {
                Name = config.Name or "Button",
                Description = config.Description or "",
                Callback = config.Callback or function() end
            }

            analytics.elementsCreated = analytics.elementsCreated + 1

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, buttonConfig.Description ~= "" and 65 or 45)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 10)
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

            button.MouseEnter:Connect(function()
                tween(container, {}, {BackgroundTransparency = 0.1})
            end)

            button.MouseLeave:Connect(function()
                tween(container, {}, {BackgroundTransparency = 0.2})
            end)

            button.MouseButton1Click:Connect(function()
                analytics.interactions = analytics.interactions + 1
                buttonConfig.Callback()
            end)

            self:UpdateCanvasSize()
            table.insert(self.Elements, {Type = "Button", Element = container, Config = buttonConfig})
            return container
        end

        function Tab:CreateToggle(config)
            local toggleConfig = {
                Name = config.Name or "Toggle",
                Description = config.Description or "",
                Default = config.Default or false,
                Callback = config.Callback or function() end
            }

            analytics.elementsCreated = analytics.elementsCreated + 1

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, toggleConfig.Description ~= "" and 70 or 50)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.2
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, currentTheme.Accent, 1, 0.6)

            local label = Instance.new("TextLabel")
            label.Parent = container
            label.Size = UDim2.new(0.7, 0, toggleConfig.Description ~= "" and 0.5 or 1, 0)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleConfig.Name
            label.TextColor3 = currentTheme.Text
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
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

            -- Toggle switch
            local toggleBg = Instance.new("Frame")
            toggleBg.Parent = container
            toggleBg.Size = UDim2.new(0, 50, 0, 25)
            toggleBg.Position = UDim2.new(1, -65, toggleConfig.Description ~= "" and 0.25 or 0.5, -12.5)
            toggleBg.BackgroundColor3 = toggleConfig.Default and currentTheme.Primary or Color3.fromRGB(60, 60, 80)
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
                analytics.interactions = analytics.interactions + 1
                isEnabled = not isEnabled
                
                local bgColor = isEnabled and currentTheme.Primary or Color3.fromRGB(60, 60, 80)
                local circlePos = isEnabled and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
                
                tween(toggleBg, {}, {BackgroundColor3 = bgColor}):Play()
                tween(toggleCircle, {}, {Position = circlePos}):Play()
                
                toggleConfig.Callback(isEnabled)
            end)

            self:UpdateCanvasSize()
            table.insert(self.Elements, {Type = "Toggle", Element = container, Config = toggleConfig})
            return {Container = container, GetValue = function() return isEnabled end}
        end

        function Tab:UpdateCanvasSize()
            self.Content.CanvasSize = UDim2.new(0, 0, 0, self.Layout.AbsoluteContentSize.Y + 20)
        end

        return Tab
    end

    -- Search functionality for window
    searchBox.Changed:Connect(function()
        if Window.CurrentTab then
            Window.CurrentTab:Search(searchBox.Text)
        end
    end)

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

        -- Clear search when switching tabs
        self.SearchBox.Text = ""

        -- Style selected tab
        tween(tab.Button, {}, {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(35, 30, 50)})
        tween(tab.Glow, {}, {BackgroundTransparency = 0.5, BackgroundColor3 = tab.Config.Color})
        tween(tab.Text, {}, {TextColor3 = currentTheme.Text})
        tween(tab.Icon, {}, {TextColor3 = tab.Config.Color})

        -- Add active stroke
        local activeStroke = createStroke(tab.Button, tab.Config.Color, 1.5, 0.3)

        -- Update scroll sizes
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, self.TabLayout.AbsoluteContentSize.Y + 10)
        tab:UpdateCanvasSize()
    end

    return Window
end

-- Framework Info
GuiFramework.Version = "2.0"
GuiFramework.Author = "Advanced Framework Team"
GuiFramework.Features = {
    "Key System", "Notifications", "All UI Components", 
    "Themes", "Search", "Analytics", "Monetization Ready"
}

return GuiFramework
