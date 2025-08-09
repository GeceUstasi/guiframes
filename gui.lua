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

        -- 2. TOGGLE
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

        -- 3. SLIDER
        function Tab:CreateSlider(config)
            local sliderConfig = {
                Name = config.Name or "Slider",
                Description = config.Description or "",
                Range = config.Range or {0, 100},
                Increment = config.Increment or 1,
                Default = config.Default or 50,
                Suffix = config.Suffix or "",
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, sliderConfig.Description ~= "" and 80 or 60)
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

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.6, 0, 0.4, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 5)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = sliderConfig.Name
            nameLabel.TextColor3 = currentTheme.Text
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamSemibold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = container
            valueLabel.Size = UDim2.new(0.3, 0, 0.4, 0)
            valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(sliderConfig.Default) .. sliderConfig.Suffix
            valueLabel.TextColor3 = currentTheme.Primary
            valueLabel.TextSize = 14
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right

            if sliderConfig.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = container
                descLabel.Size = UDim2.new(1, -20, 0.3, 0)
                descLabel.Position = UDim2.new(0, 15, 0.4, 0)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = sliderConfig.Description
                descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
            end

            -- Slider track
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Parent = container
            sliderTrack.Size = UDim2.new(1, -30, 0, 6)
            sliderTrack.Position = UDim2.new(0, 15, sliderConfig.Description ~= "" and 0.75 or 0.7, 0)
            sliderTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            sliderTrack.BorderSizePixel = 0

            createCorner(sliderTrack, 3)

            -- Slider fill
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderTrack
            sliderFill.Size = UDim2.new((sliderConfig.Default - sliderConfig.Range[1]) / (sliderConfig.Range[2] - sliderConfig.Range[1]), 0, 1, 0)
            sliderFill.Position = UDim2.new(0, 0, 0, 0)
            sliderFill.BorderSizePixel = 0

            createCorner(sliderFill, 3)

            -- Beautiful gradient for fill
            local fillGradient = Instance.new("UIGradient")
            fillGradient.Parent = sliderFill
            fillGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, currentTheme.Primary),
                ColorSequenceKeypoint.new(1, currentTheme.Accent)
            }

            -- Slider interaction
            local dragging = false
            local currentValue = sliderConfig.Default

            local function updateSlider(input)
                local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(sliderConfig.Range[1] + (relativeX * (sliderConfig.Range[2] - sliderConfig.Range[1])) / sliderConfig.Increment + 0.5) * sliderConfig.Increment
                currentValue = math.clamp(currentValue, sliderConfig.Range[1], sliderConfig.Range[2])
                
                valueLabel.Text = tostring(currentValue) .. sliderConfig.Suffix
                tween(sliderFill, {Time = 0.1}, {Size = UDim2.new(relativeX, 0, 1, 0)}):Play()
                
                sliderConfig.Callback(currentValue)
            end

            -- Hover effects
            container.MouseEnter:Connect(function()
                tween(container, {Time = 0.2}, {BackgroundTransparency = 0.1}):Play()
                tween(hoverGlow, {Time = 0.2}, {BackgroundTransparency = 0.8}):Play()
            end)

            container.MouseLeave:Connect(function()
                tween(container, {Time = 0.2}, {BackgroundTransparency = 0.15}):Play()
                tween(hoverGlow, {Time = 0.2}, {BackgroundTransparency = 1}):Play()
            end)

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

        -- 4. DROPDOWN
        function Tab:CreateDropdown(config)
            local dropdownConfig = {
                Name = config.Name or "Dropdown",
                Description = config.Description or "",
                Options = config.Options or {"Option 1", "Option 2"},
                Default = config.Default or config.Options[1],
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, dropdownConfig.Description ~= "" and 70 or 50)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.15
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, currentTheme.Accent, 1, 0.4)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.4, 0, dropdownConfig.Description ~= "" and 0.5 or 1, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = dropdownConfig.Name
            nameLabel.TextColor3 = currentTheme.Text
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamSemibold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            if dropdownConfig.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = container
                descLabel.Size = UDim2.new(1, -20, 0.5, 0)
                descLabel.Position = UDim2.new(0, 15, 0.5, 0)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = dropdownConfig.Description
                descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
            end

            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Parent = container
            dropdownButton.Size = UDim2.new(0.5, -20, 0, 35)
            dropdownButton.Position = UDim2.new(0.5, 5, dropdownConfig.Description ~= "" and 0.25 or 0.5, -17.5)
            dropdownButton.BackgroundColor3 = currentTheme.Background
            dropdownButton.BorderSizePixel = 0
            dropdownButton.Text = dropdownConfig.Default .. " ▼"
            dropdownButton.TextColor3 = currentTheme.Text
            dropdownButton.TextSize = 12
            dropdownButton.Font = Enum.Font.Gotham

            createCorner(dropdownButton, 8)

            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Parent = container
            dropdownFrame.Size = UDim2.new(0.5, -20, 0, #dropdownConfig.Options * 30)
            dropdownFrame.Position = UDim2.new(0.5, 5, 1, 5)
            dropdownFrame.BackgroundColor3 = currentTheme.Background
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Visible = false
            dropdownFrame.ZIndex = 10

            createCorner(dropdownFrame, 8)
            createStroke(dropdownFrame, currentTheme.Accent, 1, 0.6)

            local optionLayout = Instance.new("UIListLayout")
            optionLayout.Parent = dropdownFrame
            optionLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local currentOption = dropdownConfig.Default
            local isOpen = false

            for _, option in ipairs(dropdownConfig.Options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Parent = dropdownFrame
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.BackgroundColor3 = currentTheme.Background
                optionButton.BackgroundTransparency = 0.5
                optionButton.BorderSizePixel = 0
                optionButton.Text = option
                optionButton.TextColor3 = currentTheme.Text
                optionButton.TextSize = 12
                optionButton.Font = Enum.Font.Gotham

                optionButton.MouseEnter:Connect(function()
                    tween(optionButton, {}, {BackgroundTransparency = 0.2}):Play()
                end)

                optionButton.MouseLeave:Connect(function()
                    tween(optionButton, {}, {BackgroundTransparency = 0.5}):Play()
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

        -- 5. INPUT
        function Tab:CreateInput(config)
            local inputConfig = {
                Name = config.Name or "Input",
                Description = config.Description or "",
                Default = config.Default or "",
                Placeholder = config.Placeholder or "Enter text...",
                RemoveTextAfterFocusLost = config.RemoveTextAfterFocusLost or false,
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, inputConfig.Description ~= "" and 70 or 50)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.15
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, currentTheme.Accent, 1, 0.4)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.3, 0, inputConfig.Description ~= "" and 0.5 or 1, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = inputConfig.Name
            nameLabel.TextColor3 = currentTheme.Text
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamSemibold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            if inputConfig.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = container
                descLabel.Size = UDim2.new(1, -20, 0.5, 0)
                descLabel.Position = UDim2.new(0, 15, 0.5, 0)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = inputConfig.Description
                descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
            end

            local inputBox = Instance.new("TextBox")
            inputBox.Parent = container
            inputBox.Size = UDim2.new(0.65, -20, 0, 30)
            inputBox.Position = UDim2.new(0.35, 5, inputConfig.Description ~= "" and 0.25 or 0.5, -15)
            inputBox.BackgroundColor3 = currentTheme.Background
            inputBox.BorderSizePixel = 0
            inputBox.Text = inputConfig.Default
            inputBox.PlaceholderText = inputConfig.Placeholder
            inputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
            inputBox.TextColor3 = currentTheme.Text
            inputBox.TextSize = 12
            inputBox.Font = Enum.Font.Gotham
            inputBox.ClearTextOnFocus = false

            createCorner(inputBox, 8)

            local inputStroke = createStroke(inputBox, currentTheme.Accent, 1, 0.6)

            inputBox.Focused:Connect(function()
                tween(inputStroke, {}, {Color = currentTheme.Primary, Transparency = 0.3}):Play()
            end)

            inputBox.FocusLost:Connect(function()
                tween(inputStroke, {}, {Color = currentTheme.Accent, Transparency = 0.6}):Play()
                if inputConfig.RemoveTextAfterFocusLost then
                    inputBox.Text = ""
                end
                inputConfig.Callback(inputBox.Text)
            end)

            self:UpdateCanvasSize()
            return {Container = container, GetValue = function() return inputBox.Text end}
        end

        -- 6. COLORPICKER
        function Tab:CreateColorPicker(config)
            local colorConfig = {
                Name = config.Name or "Color Picker",
                Description = config.Description or "",
                Default = config.Default or Color3.fromRGB(255, 255, 255),
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, colorConfig.Description ~= "" and 70 or 50)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.15
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, currentTheme.Accent, 1, 0.4)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.7, 0, colorConfig.Description ~= "" and 0.5 or 1, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = colorConfig.Name
            nameLabel.TextColor3 = currentTheme.Text
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamSemibold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            if colorConfig.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = container
                descLabel.Size = UDim2.new(1, -20, 0.5, 0)
                descLabel.Position = UDim2.new(0, 15, 0.5, 0)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = colorConfig.Description
                descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
            end

            local colorDisplay = Instance.new("Frame")
            colorDisplay.Parent = container
            colorDisplay.Size = UDim2.new(0, 40, 0, 25)
            colorDisplay.Position = UDim2.new(1, -55, colorConfig.Description ~= "" and 0.25 or 0.5, -12.5)
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
                -- Color picker with preset colors
                local colors = {
                    Color3.fromRGB(255, 100, 100), Color3.fromRGB(100, 255, 100), Color3.fromRGB(100, 100, 255),
                    Color3.fromRGB(255, 255, 100), Color3.fromRGB(255, 100, 255), Color3.fromRGB(100, 255, 255),
                    Color3.fromRGB(255, 150, 100), Color3.fromRGB(150, 255, 100), Color3.fromRGB(100, 150, 255),
                    Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 200, 200), Color3.fromRGB(100, 100, 100)
                }
                
                local currentIndex = 1
                for i, color in ipairs(colors) do
                    if math.abs(color.R - currentColor.R) < 0.1 and 
                       math.abs(color.G - currentColor.G) < 0.1 and 
                       math.abs(color.B - currentColor.B) < 0.1 then
                        currentIndex = i
                        break
                    end
                end
                
                currentIndex = (currentIndex % #colors) + 1
                currentColor = colors[currentIndex]
                
                tween(colorDisplay, {}, {BackgroundColor3 = currentColor}):Play()
                colorConfig.Callback(currentColor)
            end)

            self:UpdateCanvasSize()
            return {Container = container, GetValue = function() return currentColor end}
        end

        -- 7. KEYBIND
        function Tab:CreateKeybind(config)
            local keybindConfig = {
                Name = config.Name or "Keybind",
                Description = config.Description or "",
                Default = config.Default or Enum.KeyCode.F,
                Callback = config.Callback or function() end
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, keybindConfig.Description ~= "" and 70 or 50)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.15
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, currentTheme.Accent, 1, 0.4)

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Parent = container
            nameLabel.Size = UDim2.new(0.6, 0, keybindConfig.Description ~= "" and 0.5 or 1, 0)
            nameLabel.Position = UDim2.new(0, 15, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = keybindConfig.Name
            nameLabel.TextColor3 = currentTheme.Text
            nameLabel.TextSize = 14
            nameLabel.Font = Enum.Font.GothamSemibold
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left

            if keybindConfig.Description ~= "" then
                local descLabel = Instance.new("TextLabel")
                descLabel.Parent = container
                descLabel.Size = UDim2.new(1, -20, 0.5, 0)
                descLabel.Position = UDim2.new(0, 15, 0.5, 0)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = keybindConfig.Description
                descLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
            end

            local keybindButton = Instance.new("TextButton")
            keybindButton.Parent = container
            keybindButton.Size = UDim2.new(0, 80, 0, 30)
            keybindButton.Position = UDim2.new(1, -95, keybindConfig.Description ~= "" and 0.25 or 0.5, -15)
            keybindButton.BackgroundColor3 = currentTheme.Background
            keybindButton.BorderSizePixel = 0
            keybindButton.Text = keybindConfig.Default.Name
            keybindButton.TextColor3 = currentTheme.Text
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

        -- 8. LABEL
        function Tab:CreateLabel(config)
            local labelConfig = {
                Text = config.Text or "Label",
                Size = config.Size or 14,
                Color = config.Color or currentTheme.Text
            }

            local label = Instance.new("TextLabel")
            label.Parent = self.Content
            label.Size = UDim2.new(1, 0, 0, 35)
            label.BackgroundTransparency = 1
            label.Text = labelConfig.Text
            label.TextColor3 = labelConfig.Color
            label.TextSize = labelConfig.Size
            label.Font = Enum.Font.GothamSemibold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextWrapped = true

            self:UpdateCanvasSize()
            return label
        end

        -- 9. PARAGRAPH
        function Tab:CreateParagraph(config)
            local paragraphConfig = {
                Title = config.Title or "Paragraph",
                Content = config.Content or "Content"
            }

            local container = Instance.new("Frame")
            container.Parent = self.Content
            container.Size = UDim2.new(1, 0, 0, 80)
            container.BackgroundColor3 = currentTheme.Secondary
            container.BackgroundTransparency = 0.15
            container.BorderSizePixel = 0

            createCorner(container, 10)
            createStroke(container, currentTheme.Accent, 1, 0.4)

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Parent = container
            titleLabel.Size = UDim2.new(1, -20, 0.3, 0)
            titleLabel.Position = UDim2.new(0, 10, 0, 5)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = paragraphConfig.Title
            titleLabel.TextColor3 = currentTheme.Text
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

        function Tab:UpdateCanvasSize()
            self.Content.CanvasSize = UDim2.new(0, 0, 0, self.Layout.AbsoluteContentSize.Y + 20)
        end

        return Tab
    end

    -- FIXED SelectTab function
    function Window:SelectTab(tab)
        print("SelectTab called for:", tab.Name) -- Debug
        
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
        print("Tab content set visible:", tab.Content.Visible) -- Debug

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

-- Example Usage with Complete Framework
print("🚀 Complete GUI Framework v3.0 loaded!")
print("📋 All Features: Button, Toggle, Slider, Dropdown, Input, ColorPicker, Keybind, Label, Paragraph")
print("⚙ Settings Menu: Optional settings menu with keybind customization")
print("🎨 Beautiful UI: Sidebar layout with all modern effects")

-- Example implementation
local Framework = GuiFramework

local Window = Framework:CreateWindow({
    Name = "🎯 Complete Framework Demo",
    Theme = "Ocean",
    Size = {700, 500},
    KeySystem = false,
    SettingsMenu = true, -- Enable settings menu
    ToggleKey = Enum.KeyCode.RightShift -- Custom toggle key
})

-- Show welcome notification
Framework:CreateNotification({
    Title = "Complete Framework",
    Content = "All features loaded! Check the settings menu.",
    Duration = 3
})

-- Create demo tabs
local MainTab = Window:CreateTab({
    Name = "Main Controls",
    Icon = "🎮",
    Color = Color3.fromRGB(100, 200, 255)
})

local UITab = Window:CreateTab({
    Name = "UI Elements",
    Icon = "🎨",
    Color = Color3.fromRGB(255, 150, 100)
})

-- Main Tab Content
MainTab:CreateParagraph({
    Title = "🚀 Complete GUI Framework v3.0",
    Content = "This framework includes ALL UI components with beautiful animations, settings menu, and keybind customization!"
})

MainTab:CreateToggle({
    Name = "Enable Features",
    Description = "Master toggle for all framework features",
    Default = true,
    Callback = function(value)
        print("Features enabled:", value)
    end
})

MainTab:CreateSlider({
    Name = "Test Slider",
    Description = "Beautiful slider with gradient fill",
    Range = {1, 100},
    Increment = 1,
    Default = 50,
    Suffix = "%",
    Callback = function(value)
        print("Slider value:", value)
    end
})

-- UI Elements Tab
UITab:CreateButton({
    Name = "Test Button",
    Description = "Beautiful button with hover effects",
    Callback = function()
        Framework:CreateNotification({
            Title = "Button Clicked",
            Content = "Beautiful button system working!",
            Duration = 2
        })
    end
})

UITab:CreateDropdown({
    Name = "Theme Selector",
    Description = "Choose your preferred theme",
    Options = {"Default", "Ocean", "Dark", "Neon"},
    Default = "Ocean",
    Callback = function(value)
        print("Theme selected:", value)
    end
})

UITab:CreateInput({
    Name = "Text Input",
    Description = "Enter some text here",
    Placeholder = "Type something...",
    Callback = function(text)
        print("Input text:", text)
    end
})

UITab:CreateColorPicker({
    Name = "Color Picker",
    Description = "Pick your favorite color",
    Default = Color3.fromRGB(100, 200, 255),
    Callback = function(color)
        print("Color selected:", color)
    end
})

UITab:CreateKeybind({
    Name = "Test Keybind",
    Description = "Press a key to bind",
    Default = Enum.KeyCode.F,
    Callback = function()
        Framework:CreateNotification({
            Title = "Keybind Pressed",
            Content = "Your custom keybind works!",
            Duration = 2
        })
    end
})

UITab:CreateLabel({
    Text = "✨ This is a beautiful label with custom styling!",
    Size = 16,
    Color = Color3.fromRGB(100, 200, 255)
})

return GuiFramework-- Complete GUI Framework v3.0 - All Features + Settings Menu
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
    Dark = {
        Primary = Color3.fromRGB(80, 80, 100),
        Secondary = Color3.fromRGB(10, 10, 15),
        Background = Color3.fromRGB(5, 5, 10),
        Text = Color3.fromRGB(220, 220, 220),
        Accent = Color3.fromRGB(100, 100, 120)
    },
    Ocean = {
        Primary = Color3.fromRGB(100, 200, 255),
        Secondary = Color3.fromRGB(5, 15, 25),
        Background = Color3.fromRGB(0, 10, 20),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(150, 220, 255)
    },
    Neon = {
        Primary = Color3.fromRGB(255, 100, 255),
        Secondary = Color3.fromRGB(20, 5, 20),
        Background = Color3.fromRGB(10, 0, 10),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 150, 255)
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

-- Main Create Window Function (COMPLETE FRAMEWORK)
function GuiFramework:CreateWindow(config)
    local windowConfig = {
        Name = config.Name or "Framework GUI",
        Theme = config.Theme or "Default",
        Size = config.Size or {700, 500},
        KeySystem = config.KeySystem or false,
        SettingsMenu = config.SettingsMenu ~= false, -- Default true (opsiyonel)
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift
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
    screenGui.Name = "CompleteFrameworkGUI"
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

    -- Settings button (if enabled)
    local settingsButton
    if windowConfig.SettingsMenu then
        settingsButton = Instance.new("TextButton")
        settingsButton.Parent = header
        settingsButton.Size = UDim2.new(0, 30, 0, 25)
        settingsButton.Position = UDim2.new(1, -80, 0.5, -12.5)
        settingsButton.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
        settingsButton.BackgroundTransparency = 0.3
        settingsButton.BorderSizePixel = 0
        settingsButton.Text = "⚙"
        settingsButton.TextColor3 = currentTheme.Text
        settingsButton.TextScaled = true
        settingsButton.Font = Enum.Font.GothamBold

        createCorner(settingsButton, 12)
    end

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

    -- Toggle GUI with keybind
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == windowConfig.ToggleKey then
            mainContainer.Visible = not mainContainer.Visible
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
    tabLayout.FillDirection = Enum.FillDirection.Vertical
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
        Config = windowConfig,
        SettingsTab = nil
    }

    currentWindow = Window

    -- Settings Menu Creation (if enabled)
    if windowConfig.SettingsMenu then
        local function createSettingsMenu()
            local settingsFrame = Instance.new("Frame")
            settingsFrame.Name = "SettingsMenu"
            settingsFrame.Parent = screenGui
            settingsFrame.Size = UDim2.new(0, 400, 0, 300)
            settingsFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
            settingsFrame.BackgroundColor3 = currentTheme.Secondary
            settingsFrame.BackgroundTransparency = 0.1
            settingsFrame.BorderSizePixel = 0
            settingsFrame.ZIndex = 100
            settingsFrame.Visible = false

            createCorner(settingsFrame, 15)
            createStroke(settingsFrame, currentTheme.Primary, 2, 0.3)

            -- Settings header
            local settingsHeader = Instance.new("Frame")
            settingsHeader.Parent = settingsFrame
            settingsHeader.Size = UDim2.new(1, 0, 0, 40)
            settingsHeader.BackgroundColor3 = currentTheme.Background
            settingsHeader.BackgroundTransparency = 0.2
            settingsHeader.BorderSizePixel = 0

            createCorner(settingsHeader, 15)

            local settingsTitle = Instance.new("TextLabel")
            settingsTitle.Parent = settingsHeader
            settingsTitle.Size = UDim2.new(0.8, 0, 1, 0)
            settingsTitle.Position = UDim2.new(0, 15, 0, 0)
            settingsTitle.BackgroundTransparency = 1
            settingsTitle.Text = "⚙ Settings Menu"
            settingsTitle.TextColor3 = currentTheme.Text
            settingsTitle.TextSize = 16
            settingsTitle.Font = Enum.Font.GothamBold
            settingsTitle.TextXAlignment = Enum.TextXAlignment.Left

            local settingsClose = Instance.new("TextButton")
            settingsClose.Parent = settingsHeader
            settingsClose.Size = UDim2.new(0, 25, 0, 25)
            settingsClose.Position = UDim2.new(1, -35, 0.5, -12.5)
            settingsClose.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            settingsClose.BackgroundTransparency = 0.3
            settingsClose.BorderSizePixel = 0
            settingsClose.Text = "✕"
            settingsClose.TextColor3 = currentTheme.Text
            settingsClose.TextScaled = true
            settingsClose.Font = Enum.Font.GothamBold

            createCorner(settingsClose, 12)

            -- Settings content
            local settingsContent = Instance.new("ScrollingFrame")
            settingsContent.Parent = settingsFrame
            settingsContent.Size = UDim2.new(1, -20, 1, -60)
            settingsContent.Position = UDim2.new(0, 10, 0, 50)
            settingsContent.BackgroundTransparency = 1
            settingsContent.BorderSizePixel = 0
            settingsContent.ScrollBarThickness = 6
            settingsContent.ScrollBarImageColor3 = currentTheme.Primary
            settingsContent.ScrollBarImageTransparency = 0.3

            local settingsLayout = Instance.new("UIListLayout")
            settingsLayout.Parent = settingsContent
            settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            settingsLayout.Padding = UDim.new(0, 10)

            -- Theme selector
            local themeContainer = Instance.new("Frame")
            themeContainer.Parent = settingsContent
            themeContainer.Size = UDim2.new(1, 0, 0, 50)
            themeContainer.BackgroundColor3 = currentTheme.Secondary
            themeContainer.BackgroundTransparency = 0.15
            themeContainer.BorderSizePixel = 0

            createCorner(themeContainer, 10)
            createStroke(themeContainer, currentTheme.Accent, 1, 0.4)

            local themeLabel = Instance.new("TextLabel")
            themeLabel.Parent = themeContainer
            themeLabel.Size = UDim2.new(0.5, 0, 1, 0)
            themeLabel.Position = UDim2.new(0, 15, 0, 0)
            themeLabel.BackgroundTransparency = 1
            themeLabel.Text = "Theme"
            themeLabel.TextColor3 = currentTheme.Text
            themeLabel.TextSize = 14
            themeLabel.Font = Enum.Font.GothamSemibold
            themeLabel.TextXAlignment = Enum.TextXAlignment.Left

            local themeDropdown = Instance.new("TextButton")
            themeDropdown.Parent = themeContainer
            themeDropdown.Size = UDim2.new(0.4, 0, 0, 30)
            themeDropdown.Position = UDim2.new(0.55, 0, 0.5, -15)
            themeDropdown.BackgroundColor3 = currentTheme.Background
            themeDropdown.BorderSizePixel = 0
            themeDropdown.Text = windowConfig.Theme .. " ▼"
            themeDropdown.TextColor3 = currentTheme.Text
            themeDropdown.TextSize = 12
            themeDropdown.Font = Enum.Font.Gotham

            createCorner(themeDropdown, 8)

            -- Toggle keybind setting
            local keybindContainer = Instance.new("Frame")
            keybindContainer.Parent = settingsContent
            keybindContainer.Size = UDim2.new(1, 0, 0, 50)
            keybindContainer.BackgroundColor3 = currentTheme.Secondary
            keybindContainer.BackgroundTransparency = 0.15
            keybindContainer.BorderSizePixel = 0

            createCorner(keybindContainer, 10)
            createStroke(keybindContainer, currentTheme.Accent, 1, 0.4)

            local keybindLabel = Instance.new("TextLabel")
            keybindLabel.Parent = keybindContainer
            keybindLabel.Size = UDim2.new(0.5, 0, 1, 0)
            keybindLabel.Position = UDim2.new(0, 15, 0, 0)
            keybindLabel.BackgroundTransparency = 1
            keybindLabel.Text = "Toggle Key"
            keybindLabel.TextColor3 = currentTheme.Text
            keybindLabel.TextSize = 14
            keybindLabel.Font = Enum.Font.GothamSemibold
            keybindLabel.TextXAlignment = Enum.TextXAlignment.Left

            local keybindButton = Instance.new("TextButton")
            keybindButton.Parent = keybindContainer
            keybindButton.Size = UDim2.new(0.4, 0, 0, 30)
            keybindButton.Position = UDim2.new(0.55, 0, 0.5, -15)
            keybindButton.BackgroundColor3 = currentTheme.Background
            keybindButton.BorderSizePixel = 0
            keybindButton.Text = windowConfig.ToggleKey.Name
            keybindButton.TextColor3 = currentTheme.Text
            keybindButton.TextSize = 12
            keybindButton.Font = Enum.Font.Gotham

            createCorner(keybindButton, 8)

            -- Keybind setting functionality
            local settingKeybind = false
            keybindButton.MouseButton1Click:Connect(function()
                if not settingKeybind then
                    settingKeybind = true
                    keybindButton.Text = "Press a key..."
                    
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                            windowConfig.ToggleKey = input.KeyCode
                            keybindButton.Text = input.KeyCode.Name
                            settingKeybind = false
                            connection:Disconnect()
                        end
                    end)
                end
            end)

            -- Close settings
            settingsClose.MouseButton1Click:Connect(function()
                settingsFrame.Visible = false
            end)

            -- Settings button click
            settingsButton.MouseButton1Click:Connect(function()
                settingsFrame.Visible = not settingsFrame.Visible
            end)

            settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsLayout.AbsoluteContentSize.Y + 20)
        end

        createSettingsMenu()
    end

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
        tabButton.Size = UDim2.new(1, 0, 0, 40)
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

        -- Tab click - FIXED!
        tabButton.MouseButton1Click:Connect(function()
            print("Tab clicked:", tabConfig.Name) -- Debug
            self:SelectTab(Tab)
        end)

        -- Add to tabs
        table.insert(self.Tabs, Tab)

        -- Select first tab automatically
        if #self.Tabs == 1 then
            print("Selecting first tab:", tabConfig.Name) -- Debug
            self:SelectTab(Tab)
        end

        -- ALL UI COMPONENTS - COMPLETE IMPLEMENTATION

        -- 1. BUTTON
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
            hoverGlow.Position = UDim2.new(0, -3, 0
