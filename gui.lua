-- RayField Pro Framework v2.1.0
-- Modern Professional GUI Library for Roblox
-- Created with advanced features and smooth animations
-- 🚀 StarterPlayerScripts Uyumlu LocalScript

local RayFieldPro = {}
RayFieldPro.__index = RayFieldPro

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Wait for character to load
Player.CharacterAdded:Wait()

-- Framework Configuration
local Config = {
    WindowSize = {800, 500},
    AnimationSpeed = 0.3,
    BlurAmount = 25,
    ThemeColors = {
        Dark = {
            Primary = Color3.fromRGB(59, 130, 246),
            Secondary = Color3.fromRGB(139, 92, 246),
            Background = Color3.fromRGB(15, 15, 35),
            Surface = Color3.fromRGB(20, 20, 40),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(161, 161, 170),
            Border = Color3.fromRGB(255, 255, 255),
            Success = Color3.fromRGB(16, 185, 129),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(239, 68, 68)
        },
        Light = {
            Primary = Color3.fromRGB(37, 99, 235),
            Secondary = Color3.fromRGB(124, 58, 237),
            Background = Color3.fromRGB(248, 250, 252),
            Surface = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(15, 23, 42),
            TextSecondary = Color3.fromRGB(100, 116, 139),
            Border = Color3.fromRGB(226, 232, 240),
            Success = Color3.fromRGB(5, 150, 105),
            Warning = Color3.fromRGB(217, 119, 6),
            Error = Color3.fromRGB(220, 38, 38)
        }
    }
}

-- Utility Functions
local function CreateTween(object, info, properties)
    return TweenService:Create(object, info, properties)
end

local function CreateGradient(colorSequence)
    local gradient = Instance.new("UIGradient")
    gradient.Color = colorSequence
    return gradient
end

local function CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    return corner
end

local function CreateStroke(thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = transparency or 0.7
    return stroke
end

local function CreateBlur()
    local blur = Instance.new("BlurEffect")
    blur.Size = Config.BlurAmount
    blur.Parent = game.Lighting
    return blur
end

-- Main Framework Class
function RayFieldPro:CreateWindow(windowConfig)
    local self = setmetatable({}, RayFieldPro)
    
    -- Window Configuration
    self.Config = windowConfig or {}
    self.Title = self.Config.Title or "RayField Pro Framework"
    self.Size = self.Config.Size or Config.WindowSize
    self.Theme = self.Config.Theme or "Dark"
    self.Colors = Config.ThemeColors[self.Theme]
    self.Minimized = false
    self.Components = {}
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RayFieldPro_" .. tick()
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to PlayerGui (StarterPlayerScripts uyumlu)
    self.ScreenGui.Parent = PlayerGui
    
    -- Create Blur Effect
    self.BlurEffect = CreateBlur()
    
    -- Main Container
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainContainer"
    self.MainFrame.Size = UDim2.new(0, self.Size[1], 0, self.Size[2])
    self.MainFrame.Position = UDim2.new(0.5, -self.Size[1]/2, 0.5, -self.Size[2]/2)
    self.MainFrame.BackgroundColor3 = self.Colors.Surface
    self.MainFrame.BackgroundTransparency = 0.1
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Main Frame Effects
    CreateCorner(20).Parent = self.MainFrame
    CreateStroke(2, self.Colors.Primary, 0.7).Parent = self.MainFrame
    
    -- Background Gradient
    local bgGradient = CreateGradient(ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, self.Colors.Background),
        ColorSequenceKeypoint.new(0.5, self.Colors.Surface),
        ColorSequenceKeypoint.new(1.0, self.Colors.Background)
    })
    bgGradient.Rotation = 135
    bgGradient.Parent = self.MainFrame
    
    -- Drop Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.Size = UDim2.new(1, 50, 1, 50)
    shadow.Position = UDim2.new(0, -25, 0, -25)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ZIndex = -1
    shadow.Parent = self.MainFrame
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 60)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundTransparency = 0.9
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Title Bar Gradient
    local titleGradient = CreateGradient(ColorSequence.new{
        ColorSequenceKeypoint.new(0.0, self.Colors.Primary),
        ColorSequenceKeypoint.new(1.0, self.Colors.Secondary)
    })
    titleGradient.Rotation = 90
    titleGradient.Parent = self.TitleBar
    
    -- Title Bar Border
    local titleBorder = Instance.new("Frame")
    titleBorder.Name = "Border"
    titleBorder.Size = UDim2.new(1, 0, 0, 1)
    titleBorder.Position = UDim2.new(0, 0, 1, 0)
    titleBorder.BackgroundColor3 = self.Colors.Border
    titleBorder.BackgroundTransparency = 0.9
    titleBorder.BorderSizePixel = 0
    titleBorder.Parent = self.TitleBar
    
    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "Title"
    self.TitleText.Size = UDim2.new(1, -120, 1, 0)
    self.TitleText.Position = UDim2.new(0, 30, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = self.Title
    self.TitleText.TextColor3 = self.Colors.Text
    self.TitleText.TextSize = 18
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Font = Enum.Font.GothamBold
    self.TitleText.Parent = self.TitleBar
    
    -- Window Controls
    self:CreateWindowControls()
    
    -- Content Area
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentArea"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, -60)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 60)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.MainFrame
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.new(0, 250, 1, 0)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 0)
    self.Sidebar.BackgroundColor3 = self.Colors.Background
    self.Sidebar.BackgroundTransparency = 0.2
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.ContentFrame
    
    -- Sidebar Border
    local sidebarBorder = Instance.new("Frame")
    sidebarBorder.Name = "Border"
    sidebarBorder.Size = UDim2.new(0, 1, 1, 0)
    sidebarBorder.Position = UDim2.new(1, 0, 0, 0)
    sidebarBorder.BackgroundColor3 = self.Colors.Border
    sidebarBorder.BackgroundTransparency = 0.9
    sidebarBorder.BorderSizePixel = 0
    sidebarBorder.Parent = self.Sidebar
    
    -- Navigation Container
    self.NavContainer = Instance.new("ScrollingFrame")
    self.NavContainer.Name = "Navigation"
    self.NavContainer.Size = UDim2.new(1, 0, 1, 0)
    self.NavContainer.Position = UDim2.new(0, 0, 0, 0)
    self.NavContainer.BackgroundTransparency = 1
    self.NavContainer.BorderSizePixel = 0
    self.NavContainer.ScrollBarThickness = 4
    self.NavContainer.ScrollBarImageColor3 = self.Colors.Primary
    self.NavContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.NavContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.NavContainer.Parent = self.Sidebar
    
    -- Navigation List Layout
    local navLayout = Instance.new("UIListLayout")
    navLayout.SortOrder = Enum.SortOrder.LayoutOrder
    navLayout.Padding = UDim.new(0, 2)
    navLayout.Parent = self.NavContainer
    
    -- Main Content Area
    self.MainContent = Instance.new("Frame")
    self.MainContent.Name = "MainContent"
    self.MainContent.Size = UDim2.new(1, -250, 1, 0)
    self.MainContent.Position = UDim2.new(0, 250, 0, 0)
    self.MainContent.BackgroundTransparency = 1
    self.MainContent.BorderSizePixel = 0
    self.MainContent.Parent = self.ContentFrame
    
    -- Animate window entrance
    self:AnimateEntrance()
    
    -- Make draggable
    self:MakeDraggable()
    
    return self
end

-- Window Controls (Minimize, Maximize, Close)
function RayFieldPro:CreateWindowControls()
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "WindowControls"
    controlsFrame.Size = UDim2.new(0, 80, 0, 30)
    controlsFrame.Position = UDim2.new(1, -110, 0.5, -15)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = self.TitleBar
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.Padding = UDim.new(0, 8)
    controlsLayout.Parent = controlsFrame
    
    -- Close Button
    local closeBtn = self:CreateControlButton(controlsFrame, self.Colors.Error, function()
        self:CloseWindow()
    end)
    
    -- Maximize Button
    local maxBtn = self:CreateControlButton(controlsFrame, self.Colors.Success, function()
        self:ToggleMaximize()
    end)
    
    -- Minimize Button
    local minBtn = self:CreateControlButton(controlsFrame, self.Colors.Warning, function()
        self:ToggleMinimize()
    end)
end

function RayFieldPro:CreateControlButton(parent, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 16, 0, 16)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = parent
    
    CreateCorner(8).Parent = button
    
    -- Hover animation
    button.MouseEnter:Connect(function()
        CreateTween(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 18, 0, 18)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 16, 0, 16)}):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Create Tab System
function RayFieldPro:CreateTab(tabConfig)
    local tab = {}
    tab.Name = tabConfig.Name or "Tab"
    tab.Icon = tabConfig.Icon or ""
    tab.Parent = self
    tab.Active = false
    tab.Components = {}
    
    -- Tab Button in Sidebar
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = tab.Name .. "Button"
    tab.Button.Size = UDim2.new(1, 0, 0, 45)
    tab.Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    tab.Button.BackgroundTransparency = 1
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = ""
    tab.Button.AutoButtonColor = false
    tab.Button.Parent = self.NavContainer
    
    -- Tab Button Content
    local buttonContent = Instance.new("Frame")
    buttonContent.Size = UDim2.new(1, -20, 1, 0)
    buttonContent.Position = UDim2.new(0, 20, 0, 0)
    buttonContent.BackgroundTransparency = 1
    buttonContent.Parent = tab.Button
    
    -- Tab Icon
    if tab.Icon ~= "" then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 0, 0.5, -10)
        icon.BackgroundTransparency = 1
        icon.Image = tab.Icon
        icon.ImageColor3 = self.Colors.TextSecondary
        icon.Parent = buttonContent
    end
    
    -- Tab Label
    tab.Label = Instance.new("TextLabel")
    tab.Label.Size = UDim2.new(1, tab.Icon ~= "" and -30 or 0, 1, 0)
    tab.Label.Position = UDim2.new(0, tab.Icon ~= "" and 30 or 10, 0, 0)
    tab.Label.BackgroundTransparency = 1
    tab.Label.Text = tab.Name
    tab.Label.TextColor3 = self.Colors.TextSecondary
    tab.Label.TextSize = 14
    tab.Label.TextXAlignment = Enum.TextXAlignment.Left
    tab.Label.Font = Enum.Font.Gotham
    tab.Label.Parent = buttonContent
    
    -- Tab Border Indicator
    tab.BorderIndicator = Instance.new("Frame")
    tab.BorderIndicator.Size = UDim2.new(0, 3, 0, 0)
    tab.BorderIndicator.Position = UDim2.new(0, 0, 0.5, 0)
    tab.BorderIndicator.BackgroundColor3 = self.Colors.Primary
    tab.BorderIndicator.BorderSizePixel = 0
    tab.BorderIndicator.Parent = tab.Button
    
    CreateCorner(2).Parent = tab.BorderIndicator
    
    -- Tab Content Frame
    tab.ContentFrame = Instance.new("ScrollingFrame")
    tab.ContentFrame.Name = tab.Name .. "Content"
    tab.ContentFrame.Size = UDim2.new(1, -40, 1, -40)
    tab.ContentFrame.Position = UDim2.new(0, 20, 0, 20)
    tab.ContentFrame.BackgroundTransparency = 1
    tab.ContentFrame.BorderSizePixel = 0
    tab.ContentFrame.ScrollBarThickness = 4
    tab.ContentFrame.ScrollBarImageColor3 = self.Colors.Primary
    tab.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tab.ContentFrame.Visible = false
    tab.ContentFrame.Parent = self.MainContent
    
    -- Content Layout
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 15)
    contentLayout.Parent = tab.ContentFrame
    
    -- Tab Button Click Event
    tab.Button.MouseButton1Click:Connect(function()
        self:SwitchToTab(tab)
    end)
    
    -- Hover Effects
    tab.Button.MouseEnter:Connect(function()
        if not tab.Active then
            CreateTween(tab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
            CreateTween(tab.Label, TweenInfo.new(0.2), {TextColor3 = self.Colors.Text}):Play()
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if not tab.Active then
            CreateTween(tab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            CreateTween(tab.Label, TweenInfo.new(0.2), {TextColor3 = self.Colors.TextSecondary}):Play()
        end
    end)
    
    -- Add tab to components list
    table.insert(self.Components, tab)
    
    -- If this is the first tab, make it active
    if #self.Components == 1 then
        self:SwitchToTab(tab)
    end
    
    return tab
end

-- Switch Tab Function
function RayFieldPro:SwitchToTab(selectedTab)
    for _, tab in pairs(self.Components) do
        if tab.ContentFrame then
            tab.Active = false
            tab.ContentFrame.Visible = false
            
            -- Reset button appearance
            CreateTween(tab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            CreateTween(tab.Label, TweenInfo.new(0.2), {TextColor3 = self.Colors.TextSecondary}):Play()
            CreateTween(tab.BorderIndicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
        end
    end
    
    -- Activate selected tab
    selectedTab.Active = true
    selectedTab.ContentFrame.Visible = true
    
    -- Animate active tab
    CreateTween(selectedTab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
    CreateTween(selectedTab.Label, TweenInfo.new(0.2), {TextColor3 = self.Colors.Primary}):Play()
    CreateTween(selectedTab.BorderIndicator, TweenInfo.new(0.3), {Size = UDim2.new(0, 3, 0, 35)}):Play()
end

-- Animation Functions
function RayFieldPro:AnimateEntrance()
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.BackgroundTransparency = 1
    
    local sizeTween = CreateTween(self.MainFrame, 
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = UDim2.new(0, self.Size[1], 0, self.Size[2])}
    )
    
    local alphaTween = CreateTween(self.MainFrame,
        TweenInfo.new(0.3),
        {BackgroundTransparency = 0.1}
    )
    
    sizeTween:Play()
    alphaTween:Play()
end

-- Make Window Draggable
function RayFieldPro:MakeDraggable()
    local dragToggle = nil
    local dragSpeed = 0
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        CreateTween(self.MainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
    end
    
    self.TitleBar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragToggle then
                updateInput(input)
            end
        end
    end)
end

-- Window Control Functions
function RayFieldPro:ToggleMinimize()
    self.Minimized = not self.Minimized
    local targetSize = self.Minimized and UDim2.new(0, self.Size[1], 0, 60) or UDim2.new(0, self.Size[1], 0, self.Size[2])
    
    CreateTween(self.MainFrame, 
        TweenInfo.new(0.3, Enum.EasingStyle.Quart),
        {Size = targetSize}
    ):Play()
end

function RayFieldPro:ToggleMaximize()
    -- Maximize functionality can be implemented here
    print("Maximize toggled")
end

function RayFieldPro:CloseWindow()
    local closeTween = CreateTween(self.MainFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}
    )
    
    closeTween:Play()
    closeTween.Completed:Connect(function()
        if self.BlurEffect then
            self.BlurEffect:Destroy()
        end
        self.ScreenGui:Destroy()
    end)
end

-- Notification System
function RayFieldPro:CreateNotification(config)
    local notification = {}
    notification.Title = config.Title or "Notification"
    notification.Content = config.Content or ""
    notification.Duration = config.Duration or 3
    notification.Type = config.Type or "Info" -- Info, Success, Warning, Error
    
    -- Notification Frame
    notification.Frame = Instance.new("Frame")
    notification.Frame.Size = UDim2.new(0, 350, 0, 80)
    notification.Frame.Position = UDim2.new(1, 20, 0, 20)
    notification.Frame.BackgroundColor3 = self.Colors.Surface
    notification.Frame.BorderSizePixel = 0
    notification.Frame.Parent = self.ScreenGui
    
    CreateCorner(10).Parent = notification.Frame
    CreateStroke(1, self.Colors[notification.Type] or self.Colors.Primary, 0.5).Parent = notification.Frame
    
    -- Slide in animation
    CreateTween(notification.Frame,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -370, 0, 20)}
    ):Play()
    
    -- Auto remove after duration
    wait(notification.Duration)
    CreateTween(notification.Frame,
        TweenInfo.new(0.3),
        {Position = UDim2.new(1, 20, 0, 20), BackgroundTransparency = 1}
    ):Play()
    
    delay(0.3, function()
        notification.Frame:Destroy()
    end)
end

-- StarterPlayerScripts Örnek Kullanım (LocalScript)
function RayFieldPro:AutoStart()
    -- Oyuncu spawn olduğunda otomatik başlat
    spawn(function()
        wait(2) -- 2 saniye bekle (karakterin yüklenmesi için)
        
        local Window = RayFieldPro:CreateWindow({
            Title = "RayField Pro Framework",
            Size = {800, 500},
            Theme = "Dark"
        })
        
        local MainTab = Window:CreateTab({
            Name = "Dashboard",
            Icon = "rbxassetid://4483345998" -- Home icon
        })
        
        local SettingsTab = Window:CreateTab({
            Name = "Settings", 
            Icon = "rbxassetid://4483345998" -- Settings icon
        })
        
        -- Hoşgeldin mesajı
        Window:CreateNotification({
            Title = "Welcome " .. Player.Name .. "!",
            Content = "RayField Pro Framework loaded! 🚀",
            Type = "Success",
            Duration = 5
        })
        
        return Window
    end)
end

-- 🚀 Otomatik Başlatma (StarterPlayerScripts için)
RayFieldPro:AutoStart()

return RayFieldPro
