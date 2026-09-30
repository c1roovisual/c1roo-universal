-- ============================================
-- c1roo_Universal - FULL SCRIPT v5
-- PART 1/2
-- ============================================

local c1rooUI = (function()
    local c1rooUI = {}
    c1rooUI.__index = c1rooUI

    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local StarterGui = game:GetService("StarterGui")

    local T = {
        Bg = Color3.fromRGB(15, 15, 20),
        Surface = Color3.fromRGB(22, 22, 30),
        SurfaceLight = Color3.fromRGB(30, 30, 40),
        Accent = Color3.fromRGB(0, 200, 255),
        AccentDim = Color3.fromRGB(0, 120, 160),
        Text = Color3.fromRGB(240, 240, 245),
        TextDim = Color3.fromRGB(150, 150, 165),
        ToggleOn = Color3.fromRGB(0, 200, 255),
        ToggleOff = Color3.fromRGB(50, 50, 65),
        Border = Color3.fromRGB(40, 40, 55),
    }

    local function tw(o, p, t)
        TweenService:Create(o, TweenInfo.new(t or 0.2), p):Play()
    end

    local function mk(c, p)
        local o = Instance.new(c)
        for k, v in pairs(p or {}) do o[k] = v end
        return o
    end

    local gui = nil
    local iconFrame = nil
    local mainFrame = nil
    local dragging, dragStart, startPos = false, nil, nil
    local iconDragging, iconDragStart, iconStartPos = false, nil, nil
    local iconMoved = false

    function c1rooUI:Notify(opts)
        opts = opts or {}
        local title = opts.Title or "c1roo"
        local text = opts.Text or ""
        local duration = opts.Duration or 3
        local icon = opts.Icon or ""
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = duration,
                Icon = icon ~= "" and icon or nil,
            })
        end)
    end

    function c1rooUI:CreateWindow(opts)
        opts = opts or {}
        local title = opts.Title or "c1roo_Universal"
        local w = opts.W or 600
        local h = opts.H or 420

        if gui then gui:Destroy() end

        gui = mk("ScreenGui", {
            Name = "c1rooUI",
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
        if not ok or not gui.Parent then
            gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end

        iconFrame = mk("TextButton", {
            Name = "c1rooIcon",
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0, 20, 0.5, -30),
            BackgroundColor3 = T.Bg,
            Text = "c1roo",
            TextColor3 = T.Accent,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            AutoButtonColor = false,
            Visible = false,
            Parent = gui,
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 14), Parent = iconFrame})
        mk("UIStroke", {Color = T.Accent, Thickness = 2, Parent = iconFrame})

        local pulseDot = mk("Frame", {
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(1, -8, 0, -2),
            BackgroundColor3 = T.Accent,
            BorderSizePixel = 0,
            Parent = iconFrame,
        })
        mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = pulseDot})
        mk("UIStroke", {Color = T.Bg, Thickness = 2, Parent = pulseDot})

        iconFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                iconDragging = true
                iconMoved = false
                iconDragStart = input.Position
                iconStartPos = iconFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        iconDragging = false
                    end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - iconDragStart
                if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then
                    iconMoved = true
                end
                iconFrame.Position = UDim2.new(
                    iconStartPos.X.Scale, iconStartPos.X.Offset + d.X,
                    iconStartPos.Y.Scale, iconStartPos.Y.Offset + d.Y
                )
            end
        end)

        local main = mk("Frame", {
            Size = UDim2.new(0, w, 0, h),
            Position = UDim2.new(0.5, -w/2, 0.5, -h/2),
            BackgroundColor3 = T.Bg,
            BorderSizePixel = 0,
            Active = true,
            Parent = gui,
        })
        mainFrame = main
        mk("UICorner", {CornerRadius = UDim.new(0, 10), Parent = main})
        mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = main})

        local topBar = mk("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = T.Surface,
            BorderSizePixel = 0,
            Parent = main,
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 10), Parent = topBar})
        mk("Frame", {
            Size = UDim2.new(1, 0, 0, 12),
            Position = UDim2.new(0, 0, 1, -12),
            BackgroundColor3 = T.Surface,
            BorderSizePixel = 0,
            Parent = topBar,
        })

        mk("TextLabel", {
            Size = UDim2.new(0.6, 0, 1, 0),
            Position = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = T.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = topBar,
        })

        mk("Frame", {
            Size = UDim2.new(0, 50, 0, 2),
            Position = UDim2.new(0, 14, 1, -2),
            BackgroundColor3 = T.Accent,
            BorderSizePixel = 0,
            Parent = topBar,
        })

        local minimizeBtn = mk("TextButton", {
            Size = UDim2.new(0, 32, 0, 32),
            Position = UDim2.new(1, -38, 0, 4),
            BackgroundColor3 = T.SurfaceLight,
            Text = "—",
            TextColor3 = T.TextDim,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            AutoButtonColor = false,
            Parent = topBar,
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = minimizeBtn})

        minimizeBtn.MouseEnter:Connect(function()
            tw(minimizeBtn, {BackgroundColor3 = T.AccentDim, TextColor3 = T.Text}, 0.15)
        end)
        minimizeBtn.MouseLeave:Connect(function()
            tw(minimizeBtn, {BackgroundColor3 = T.SurfaceLight, TextColor3 = T.TextDim}, 0.15)
        end)

        minimizeBtn.MouseButton1Click:Connect(function()
            main.Visible = false
            iconFrame.Visible = true
        end)

        iconFrame.MouseButton1Click:Connect(function()
            if iconMoved then return end
            iconFrame.Visible = false
            main.Visible = true
            main.Size = UDim2.new(0, 0, 0, 0)
            main.Position = UDim2.new(0.5, 0, 0.5, 0)
            tw(main, {
                Size = UDim2.new(0, w, 0, h),
                Position = UDim2.new(0.5, -w/2, 0.5, -h/2),
            }, 0.2)
        end)

        iconFrame.MouseEnter:Connect(function()
            tw(iconFrame, {BackgroundColor3 = T.SurfaceLight}, 0.15)
            tw(iconFrame:FindFirstChildOfClass("UIStroke"), {Color = T.Text}, 0.15)
        end)
        iconFrame.MouseLeave:Connect(function()
            tw(iconFrame, {BackgroundColor3 = T.Bg}, 0.15)
            tw(iconFrame:FindFirstChildOfClass("UIStroke"), {Color = T.Accent}, 0.15)
        end)

        task.spawn(function()
            while gui and gui.Parent do
                if pulseDot and pulseDot.Parent then
                    pulseDot.BackgroundTransparency = 0
                    tw(pulseDot, {BackgroundTransparency = 0.7}, 0.8)
                    task.wait(0.8)
                else
                    break
                end
            end
        end)

        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)

        local content = mk("Frame", {
            Size = UDim2.new(1, 0, 1, -40),
            Position = UDim2.new(0, 0, 0, 40),
            BackgroundTransparency = 1,
            Parent = main,
        })

        local tabBar = mk("Frame", {
            Size = UDim2.new(1, -16, 0, 36),
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1,
            Parent = content,
        })
        mk("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = tabBar,
        })

        local pageWrap = mk("Frame", {
            Size = UDim2.new(1, -16, 1, -52),
            Position = UDim2.new(0, 8, 0, 52),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Parent = content,
        })

        local windowObj = {
            _gui = gui, _main = main, _icon = iconFrame,
            _tabBar = tabBar, _pageWrap = pageWrap,
            _tabs = {}, _activeTab = nil, _tabCount = 0,
        }
        setmetatable(windowObj, c1rooUI)

        function windowObj:AddTab(opts2)
            opts2 = opts2 or {}
            local name = opts2.Name or "Tab"
            self._tabCount = self._tabCount + 1
            local tabIndex = self._tabCount

            local btn = mk("TextButton", {
                Size = UDim2.new(0, 90, 1, 0),
                BackgroundColor3 = T.Surface,
                Text = name,
                TextColor3 = T.TextDim,
                Font = Enum.Font.Gotham,
                TextSize = 11,
                AutoButtonColor = false,
                Parent = self._tabBar,
            })
            mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
            local stroke = mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = btn})

            local page = mk("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 3,
                ScrollBarImageColor3 = T.Accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Visible = false,
                Parent = self._pageWrap,
            })
            mk("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})
            mk("UIPadding", {
                PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 6),
                Parent = page,
            })

            local tabObj = {_btn = btn, _stroke = stroke, _page = page, _sectionCount = 0}

            local function selectTab()
                if self._activeTab then
                    local prev = self._activeTab
                    prev._page.Visible = false
                    tw(prev._btn, {BackgroundColor3 = T.Surface, TextColor3 = T.TextDim}, 0.15)
                    tw(prev._stroke, {Color = T.Border}, 0.15)
                end
                self._activeTab = tabObj
                page.Visible = true
                tw(btn, {BackgroundColor3 = T.SurfaceLight, TextColor3 = T.Text}, 0.15)
                tw(stroke, {Color = T.Accent}, 0.15)
            end

            btn.MouseButton1Click:Connect(selectTab)
            table.insert(self._tabs, tabObj)
            if tabIndex == 1 then task.defer(selectTab) end

            function tabObj:AddSection(opts3)
                opts3 = opts3 or {}
                local secName = opts3.Name or "Section"
                self._sectionCount = self._sectionCount + 1

                local section = mk("Frame", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = self._page,
                })
                mk("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = section})
                mk("UIPadding", {PaddingBottom = UDim.new(0, 4), Parent = section})

                mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Text = secName,
                    TextColor3 = T.Accent,
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = section,
                })

                local secObj = {_frame = section, _itemCount = 0}

                local function addItem(item)
                    secObj._itemCount = secObj._itemCount + 1
                    item.LayoutOrder = secObj._itemCount
                    item.Parent = section
                end

                function secObj:AddButton(o)
                    o = o or {}
                    local cb = o.Callback or function() end
                    local f = mk("TextButton", {
                        Size = UDim2.new(1, 0, 0, 34),
                        BackgroundColor3 = T.Surface,
                        Text = "",
                        AutoButtonColor = false,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = f})
                    local s = mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = f})
                    mk("TextLabel", {
                        Size = UDim2.new(1, -20, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        BackgroundTransparency = 1,
                        Text = o.Name or "Button",
                        TextColor3 = T.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = f,
                    })
                    f.MouseButton1Click:Connect(function() pcall(cb) end)
                    f.MouseEnter:Connect(function() tw(s, {Color = T.Accent}, 0.1) end)
                    f.MouseLeave:Connect(function() tw(s, {Color = T.Border}, 0.1) end)
                    addItem(f)
                    return f
                end

                function secObj:AddToggle(o)
                    o = o or {}
                    local state = o.Default or false
                    local cb = o.Callback or function() end

                    local f = mk("Frame", {
                        Size = UDim2.new(1, 0, 0, 34),
                        BackgroundColor3 = T.Surface,
                        BorderSizePixel = 0,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = f})
                    local s = mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = f})
                    mk("TextLabel", {
                        Size = UDim2.new(1, -80, 1, 0),
                        Position = UDim2.new(0, 12, 0, 0),
                        BackgroundTransparency = 1,
                        Text = o.Name or "Toggle",
                        TextColor3 = T.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = f,
                    })
                    local bg = mk("Frame", {
                        Size = UDim2.new(0, 42, 0, 22),
                        Position = UDim2.new(1, -54, 0.5, -11),
                        BackgroundColor3 = state and T.ToggleOn or T.ToggleOff,
                        BorderSizePixel = 0,
                        Parent = f,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = bg})
                    local knob = mk("Frame", {
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0,
                        Parent = bg,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = knob})
                    local click = mk("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = f})

                    local function set(v, fire)
                        state = v
                        tw(bg, {BackgroundColor3 = state and T.ToggleOn or T.ToggleOff}, 0.15)
                        tw(knob, {Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}, 0.15)
                        if fire then pcall(cb, state) end
                    end
                    click.MouseButton1Click:Connect(function() set(not state, true) end)
                    click.MouseEnter:Connect(function() tw(s, {Color = T.Accent}, 0.1) end)
                    click.MouseLeave:Connect(function() tw(s, {Color = T.Border}, 0.1) end)
                    addItem(f)
                    return {Set = function(_, v) set(v, true) end, Get = function() return state end}
                end

                function secObj:AddSlider(o)
                    o = o or {}
                    local min, max = o.Min or 0, o.Max or 100
                    local value = o.Default or min
                    local cb = o.Callback or function() end

                    local f = mk("Frame", {
                        Size = UDim2.new(1, 0, 0, 52),
                        BackgroundColor3 = T.Surface,
                        BorderSizePixel = 0,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = f})
                    mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = f})

                    mk("TextLabel", {
                        Size = UDim2.new(0.7, 0, 0, 22),
                        Position = UDim2.new(0, 12, 0, 4),
                        BackgroundTransparency = 1,
                        Text = o.Name or "Slider",
                        TextColor3 = T.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = f,
                    })
                    local vl = mk("TextLabel", {
                        Size = UDim2.new(0.3, -12, 0, 22),
                        Position = UDim2.new(0.7, 0, 0, 4),
                        BackgroundTransparency = 1,
                        Text = tostring(value),
                        TextColor3 = T.Accent,
                        Font = Enum.Font.GothamBold,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Parent = f,
                    })
                    local barBg = mk("Frame", {
                        Size = UDim2.new(1, -24, 0, 8),
                        Position = UDim2.new(0, 12, 0, 36),
                        BackgroundColor3 = T.ToggleOff,
                        BorderSizePixel = 0,
                        Parent = f,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = barBg})
                    local fill = mk("Frame", {
                        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                        BackgroundColor3 = T.Accent,
                        BorderSizePixel = 0,
                        Parent = barBg,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})
                    local knob = mk("Frame", {
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0,
                        ZIndex = 2,
                        Parent = barBg,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = knob})

                    local dragging2 = false
                    local function upd(input)
                        local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                        value = math.floor(min + (max - min) * rel + 0.5)
                        vl.Text = tostring(value)
                        fill.Size = UDim2.new(rel, 0, 1, 0)
                        knob.Position = UDim2.new(rel, -7, 0.5, -7)
                        pcall(cb, value)
                    end
                    barBg.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            dragging2 = true
                            upd(i)
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(i)
                        if dragging2 and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                            upd(i)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging2 = false end
                    end)

                    addItem(f)
                    return {
                        Set = function(_, v)
                            value = math.clamp(v, min, max)
                            local rel = (value - min) / (max - min)
                            vl.Text = tostring(value)
                            fill.Size = UDim2.new(rel, 0, 1, 0)
                            knob.Position = UDim2.new(rel, -7, 0.5, -7)
                            pcall(cb, value)
                        end,
                        Get = function() return value end,
                    }
                end

                function secObj:AddInput(o)
                    o = o or {}
                    local f = mk("Frame", {
                        Size = UDim2.new(1, 0, 0, 54),
                        BackgroundColor3 = T.Surface,
                        BorderSizePixel = 0,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = f})
                    mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = f})
                    mk("TextLabel", {
                        Size = UDim2.new(1, -24, 0, 20),
                        Position = UDim2.new(0, 12, 0, 4),
                        BackgroundTransparency = 1,
                        Text = o.Name or "Input",
                        TextColor3 = T.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = f,
                    })
                    local box = mk("TextBox", {
                        Size = UDim2.new(1, -24, 0, 24),
                        Position = UDim2.new(0, 12, 0, 24),
                        BackgroundColor3 = T.Bg,
                        Text = "",
                        PlaceholderText = o.Placeholder or "",
                        PlaceholderColor3 = T.TextDim,
                        TextColor3 = T.Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ClearTextOnFocus = false,
                        Parent = f,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 4), Parent = box})
                    mk("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = box})

                    box.FocusLost:Connect(function() pcall(o.Callback or function() end, box.Text) end)
                    addItem(f)
                    return box
                end

                return secObj
            end

            return tabObj
        end

        return windowObj
    end

    return c1rooUI
end)()

-- ============================================
-- MAIN SCRIPT
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function notify(title, text, dur, ntype, icon)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = dur or 3,
            Icon = icon ~= "" and icon or nil,
        })
    end)
end

-- ============================================
-- DATABASE ANIMATIONS
-- ============================================
local AnimDB = {
    Full = {
        "Bubbly", "Cartoony", "Zombie", "Ghost", "Cowboy", "Ninja", "Robot", 
        "Pirate", "Knight", "Mage", "Vampire", "Werewolf", "Sneaky", "Stylish",
        "Confident", "Elder", "Toy", "Superhero", "Wicked (Popular)"
    },
    Idle = {
        ["Bubbly"] = {"910004836", "910009958"},
        ["Cartoony"] = {"742637544", "742638445"},
        ["Zombie"] = {"616158929", "616160636"},
        ["Ghost"] = {"616006778", "616008087"},
        ["Cowboy"] = {"1014390418", "1014398616"},
        ["Ninja"] = {"656117400", "656118341"},
        ["Robot"] = {"616088211", "616089559"},
        ["Pirate"] = {"750781874", "750782770"},
        ["Knight"] = {"657595757", "657568135"},
        ["Mage"] = {"707742142", "707855907"},
        ["Vampire"] = {"1083445855", "1083450166"},
        ["Werewolf"] = {"1083195517", "1083214717"},
        ["Sneaky"] = {"1132473842", "1132477671"},
        ["Stylish"] = {"616136790", "616138447"},
        ["Confident"] = {"1069977950", "1069987858"},
        ["Elder"] = {"10921101664", "10921102574"},
        ["Toy"] = {"782841498", "782845736"},
        ["Superhero"] = {"10921288909", "10921290167"},
        ["Levitation"] = {"616006778", "616008087"},
        ["Princess"] = {"941003647", "941013098"},
        ["Popstar"] = {"1212900985", "1150842221"},
        ["R6"] = {"12521158637","12521162526"},
        ["R15 Reanimated"] = {"4211217646", "4211218409"},
        ["Realistic"] = {"17172918855", "17173014241"},
        ["Soldier"] = {"3972151362", "3972151362"},
        ["Stylized Female"] = {"4708191566", "4708192150"},
        ["Udzal"] = {"3303162274", "3303162549"},
        ["Astronaut"] = {"891621366", "891633237"},
        ["MrToilet"] = {"4417977954", "4417978624"},
        ["Catwalk Glam"] = {"133806214992291","94970088341563"},
        ["Drooling Zombie"] = {"3489171152", "3489171152"},
        ["Sway"] = {"560832030", "560833564"},
        ["OldSchool"] = {"10921230744", "10921232093"},
        ["Patrol"] = {"1149612882", "1150842221"},
    },
    Walk = {
        ["Bubbly"] = "910034870", ["Zombie"] = "616168032", ["Ghost"] = "616013216",
        ["Cowboy"] = "1014421541", ["Ninja"] = "656121766", ["Robot"] = "616095330",
        ["Pirate"] = "750785693", ["Knight"] = "10921127095", ["Mage"] = "707897309",
        ["Vampire"] = "1083473930", ["Werewolf"] = "1083178339", ["Sneaky"] = "1132510133",
        ["Stylish"] = "616146177", ["Confident"] = "1070017263", ["Elder"] = "10921111375",
        ["Toy"] = "10921306285", ["Superhero"] = "10921298616", ["Levitation"] = "616013216",
        ["Princess"] = "941028902", ["Popstar"] = "1212980338", ["R6"] = "12518152696",
        ["R15 Reanimated"] = "4211223236", ["Stylized Female"] = "4708193840",
        ["Udzal"] = "3303162967", ["Astronaut"] = "891667138", ["Catwalk Glam"] = "109168724482748",
        ["Drooling Zombie"] = "3489174223", ["OldSchool"] = "10921244891",
        ["Patrol"] = "1151231493", ["Cool Boy"] = "79127340077185",
    },
    Run = {
        ["Bubbly"] = "10921057244", ["Zombie"] = "616163682", ["Ghost"] = "616013216",
        ["Cowboy"] = "1014401683", ["Ninja"] = "656118852", ["Robot"] = "10921250460",
        ["Pirate"] = "750783738", ["Knight"] = "10921121197", ["Mage"] = "10921148209",
        ["Vampire"] = "10921320299", ["Werewolf"] = "10921336997", ["Sneaky"] = "1132494274",
        ["Stylish"] = "10921276116", ["Confident"] = "1070001516", ["Elder"] = "10921104374",
        ["Toy"] = "10921306285", ["Superhero"] = "10921291831", ["Levitation"] = "616010382",
        ["Princess"] = "941015281", ["Popstar"] = "1212980348", ["R6"] = "12518152696",
        ["R15 Reanimated"] = "4211220381", ["Stylized Female"] = "4708192705",
        ["Heavy Run"] = "3236836670", ["Astronaut"] = "10921039308",
        ["Catwalk Glam"] = "81024476153754", ["Drooling Zombie"] = "3489173414",
        ["OldSchool"] = "10921240218", ["Patrol"] = "1150967949",
    },
    Jump = {
        ["Bubbly"] = "910016857", ["Zombie"] = "616161997", ["Ghost"] = "616008936",
        ["Cowboy"] = "1014394726", ["Ninja"] = "656117878", ["Robot"] = "616090535",
        ["Pirate"] = "750782230", ["Knight"] = "910016857", ["Mage"] = "10921149743",
        ["Vampire"] = "1083455352", ["Werewolf"] = "1083218792", ["Sneaky"] = "1132489853",
        ["Stylish"] = "616139451", ["Confident"] = "1069984524", ["Elder"] = "10921107367",
        ["Toy"] = "10921308158", ["Superhero"] = "10921294559", ["Levitation"] = "616008936",
        ["Princess"] = "941008832", ["Popstar"] = "1212954642", ["R6"] = "12520880485",
        ["R15 Reanimated"] = "4211219390", ["Stylized Female"] = "4708188025",
        ["Astronaut"] = "891627522", ["Catwalk Glam"] = "116936326516985",
        ["OldSchool"] = "10921242013", ["Patrol"] = "1148811837",
    },
    Fall = {
        ["Bubbly"] = "910001910", ["Zombie"] = "616157476", ["Cowboy"] = "1014384571",
        ["Ninja"] = "656115606", ["Robot"] = "616087089", ["Pirate"] = "750782230",
        ["Knight"] = "10921122579", ["Mage"] = "707829716", ["Vampire"] = "1083443587",
        ["Werewolf"] = "1083189019", ["Sneaky"] = "1132469004", ["Stylish"] = "616134815",
        ["Confident"] = "1069973677", ["Elder"] = "10921105765", ["Toy"] = "782846423",
        ["Superhero"] = "10921293373", ["Levitation"] = "616005863", ["Princess"] = "941000007",
        ["Popstar"] = "1212900995", ["R6"] = "12520972571", ["R15 Reanimated"] = "4211216152",
        ["Stylized Female"] = "4708186162", ["Astronaut"] = "891617961",
        ["Catwalk Glam"] = "92294537340807", ["OldSchool"] = "10921241244",
        ["Patrol"] = "1148863382",
    },
    Climb = {
        ["Bubbly"] = "742636889", ["Zombie"] = "616156119", ["Ghost"] = "616003713",
        ["Cowboy"] = "1014380606", ["Ninja"] = "656114359", ["Robot"] = "616086039",
        ["Knight"] = "10921125160", ["Mage"] = "707826056", ["Vampire"] = "1083439238",
        ["Sneaky"] = "1132461372", ["Stylish"] = "10921271391", ["Confident"] = "1069946257",
        ["Elder"] = "845392038", ["Toy"] = "10921300839", ["Superhero"] = "10921286911",
        ["Levitation"] = "10921132092", ["Princess"] = "940996062", ["Popstar"] = "1213044953",
        ["R6"] = "12520982150", ["R15 Reanimated"] = "4211214992",
        ["Stylized Female"] = "4708184253", ["Astronaut"] = "10921032124",
        ["Catwalk Glam"] = "119377220967554", ["OldSchool"] = "10921229866",
        ["Patrol"] = "1148811837",
    },
    Swim = {
        ["Bubbly"] = "910028158", ["Zombie"] = "616165109", ["Cowboy"] = "1014406523",
        ["Ninja"] = "656118341", ["Robot"] = "10921253142", ["Pirate"] = "750784579",
        ["Knight"] = "10921125160", ["Mage"] = "707876443", ["Vampire"] = "10921324408",
        ["Werewolf"] = "10921340419", ["Sneaky"] = "1132500520", ["Stylish"] = "10921281000",
        ["Confident"] = "1070009914", ["Elder"] = "10921108971", ["Toy"] = "10921309319",
        ["Superhero"] = "10921295495", ["Popstar"] = "1212998578", ["Princess"] = "941018893",
        ["R6"] = "12518152696", ["Astronaut"] = "891663592", ["Catwalk Glam"] = "134591743181628",
        ["OldSchool"] = "10921243048", ["Patrol"] = "1151204998", ["Levitation"] = "10921138209",
    },
    SwimIdle = {
        ["Bubbly"] = "910030921", ["Zombie"] = "616165109", ["Cowboy"] = "1014411816",
        ["Ninja"] = "656118341", ["Robot"] = "10921253767", ["Pirate"] = "750785176",
        ["Knight"] = "10921125935", ["Mage"] = "707894699", ["Vampire"] = "10921325443",
        ["Werewolf"] = "10921341319", ["Sneaky"] = "1132506407", ["Stylish"] = "10921281964",
        ["Confident"] = "1070012133", ["Elder"] = "10921110146", ["Toy"] = "10921310341",
        ["Superhero"] = "10921297391", ["Popstar"] = "1212998578", ["Princess"] = "941025398",
        ["R6"] = "12518152696", ["Astronaut"] = "891663592", ["Catwalk Glam"] = "98854111361360",
        ["OldSchool"] = "10921244018", ["Patrol"] = "1151221899", ["Levitation"] = "10921139478",
    }
}

-- ========== HELPER ANIMASI ==========
local function preloadAnimation(animId)
    if not animId then return end
    local ids = (type(animId) == "table") and animId or {animId}
    local assets = {}
    for _, id in ipairs(ids) do
        if id and tostring(id) ~= "" then
            local a = Instance.new("Animation")
            a.AnimationId = "rbxassetid://" .. tostring(id)
            table.insert(assets, a)
        end
    end
    pcall(function()
        if #assets > 0 then game:GetService("ContentProvider"):PreloadAsync(assets) end
    end)
end

local function getAnimObject(folder, possibleNames)
    for _, name in ipairs(possibleNames) do
        local obj = folder:FindFirstChild(name)
        if obj and obj:IsA("Animation") then return obj end
    end
    return folder:FindFirstChildOfClass("Animation")
end

local function reloadAnimator(humanoid)
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
            pcall(function() if track.IsPlaying then track:Stop(0.15) end end)
        end
    end
    task.wait(0.05)
    humanoid:ChangeState(Enum.HumanoidStateType.Running)
    humanoid:Move(Vector3.new(0.1,0,0), true)
    task.wait(0.05)
    humanoid:Move(Vector3.new(), true)
end

local function applyAnim(animType, animId)
    local char = LocalPlayer.Character
    if not char then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local animate = char:FindFirstChild("Animate")
    if not humanoid or not animate then return false end
    preloadAnimation(animId)

    local success = pcall(function()
        if animType == "Idle" then
            if animate:FindFirstChild("idle") and type(animId) == "table" then
                local a1 = getAnimObject(animate.idle, {"Animation1", "IdleAnim"})
                local a2 = getAnimObject(animate.idle, {"Animation2"})
                if a1 then a1.AnimationId = "rbxassetid://" .. tostring(animId[1]) end
                if a2 then a2.AnimationId = "rbxassetid://" .. tostring(animId[2]) end
            end
        elseif animType == "Walk" then
            local folder = animate:FindFirstChild("walk")
            if folder then
                local anim = getAnimObject(folder, {"WalkAnim", "Animation"})
                if anim then anim.AnimationId = "rbxassetid://" .. tostring(animId) end
            end
        elseif animType == "Run" then
            local folder = animate:FindFirstChild("run")
            if folder then
                local anim = getAnimObject(folder, {"RunAnim", "Animation"})
                if anim then anim.AnimationId = "rbxassetid://" .. tostring(animId) end
            end
        elseif animType == "Jump" then
            local folder = animate:FindFirstChild("jump")
            if folder then
                local anim = getAnimObject(folder, {"JumpAnim", "Animation"})
                if anim then anim.AnimationId = "rbxassetid://" .. tostring(animId) end
            end
        elseif animType == "Fall" then
            local folder = animate:FindFirstChild("fall")
            if folder then
                local anim = getAnimObject(folder, {"FallAnim", "Animation"})
                if anim then anim.AnimationId = "rbxassetid://" .. tostring(animId) end
            end
        elseif animType == "Climb" then
            local folder = animate:FindFirstChild("climb")
            if folder then
                local anim = getAnimObject(folder, {"ClimbAnim", "Animation"})
                if anim then anim.AnimationId = "rbxassetid://" .. tostring(animId) end
            end
        elseif animType == "Swim" then
            local folder = animate:FindFirstChild("swim")
            if folder then
                local anim = getAnimObject(folder, {"Swim", "SwimAnim", "Animation"})
                if anim then anim.AnimationId = "rbxassetid://" .. tostring(animId) end
            end
        elseif animType == "SwimIdle" then
            local folder = animate:FindFirstChild("swimidle")
            if folder then
                local anim = getAnimObject(folder, {"SwimIdle", "Animation"})
                if anim then anim.AnimationId = "rbxassetid://" .. tostring(animId) end
            end
        end
    end)

    if not success then return false end
    animate.Disabled = true
    task.wait(0.2)
    animate.Disabled = false
    reloadAnimator(humanoid)
    return true
end

local function applyFull(name)
    if AnimDB.Idle[name] then applyAnim("Idle", AnimDB.Idle[name]) end
    if AnimDB.Walk[name] then applyAnim("Walk", AnimDB.Walk[name]) end
    if AnimDB.Run[name] then applyAnim("Run", AnimDB.Run[name]) end
    if AnimDB.Jump[name] then applyAnim("Jump", AnimDB.Jump[name]) end
    if AnimDB.Fall[name] then applyAnim("Fall", AnimDB.Fall[name]) end
    if AnimDB.Climb[name] then applyAnim("Climb", AnimDB.Climb[name]) end
    if AnimDB.Swim[name] then applyAnim("Swim", AnimDB.Swim[name]) end
    if AnimDB.SwimIdle[name] then applyAnim("SwimIdle", AnimDB.SwimIdle[name]) end
end

-- ========== STATE ==========
local state = {
    tpEnabled = false, antiAfkEnabled = false,
    walkspeedEnabled = false, walkspeedValue = 16,
    espEnabled = false, autoHeadshotEnabled = false,
    aimPartName = "Head", isAiming = false, currentTarget = nil,
    fullbrightEnabled = false, headlessEnabled = false,
    crosshairEnabled = false, crosshairStyle = "dot",
    crosshairColor = Color3.fromRGB(255, 255, 255),
    infiniteJump = false, noclip = false,
    flyEnabled = false, flySpeed = 50,
    hipHeight = 2, jumpPower = 50, gravity = 196.2,
    fov = 70, antiFling = false,
    chatSpamEnabled = false, chatSpamText = "", chatSpamDelay = 1,
    reachEnabled = false, reachDistance = 10,
    shiftLockEnabled = false,
}

-- ========== ESP ==========
local espData = {highlights = {}, nameTags = {}}
local espConnection, espPlayerAddedConn = nil, nil

local function addESP(player)
    if player == LocalPlayer or espData.highlights[player] then return end
    local highlight = Instance.new("Highlight")
    highlight.Name = "c1rooESP"
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.2
    highlight.OutlineColor = Color3.fromRGB(0, 200, 255)
    highlight.FillColor = Color3.fromRGB(0, 200, 255)
    local nameTag = Drawing.new("Text")
    nameTag.Size = 14; nameTag.Center = true; nameTag.Outline = true
    nameTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameTag.Color = Color3.fromRGB(255, 255, 255); nameTag.Font = 2
    espData.highlights[player] = highlight
    espData.nameTags[player] = nameTag
    if player.Character then highlight.Parent = player.Character end
    player.CharacterAdded:Connect(function(c) if state.espEnabled then highlight.Parent = c end end)
end

local function updateESP()
    if not state.espEnabled then return end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for player, highlight in pairs(espData.highlights) do
        local nameTag = espData.nameTags[player]
        local character = player.Character
        if character and character:FindFirstChild("Head") then
            local head = character.Head
            local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            local distanceText = ""
            if myRoot and character:FindFirstChild("HumanoidRootPart") then
                distanceText = string.format(" [%.0fm]", (myRoot.Position - character.HumanoidRootPart.Position).Magnitude)
            end
            if onScreen then
                nameTag.Visible = true
                nameTag.Position = Vector2.new(headPos.X, headPos.Y - 35)
                nameTag.Text = player.Name .. distanceText
            else nameTag.Visible = false end
            highlight.Enabled = true
        else
            if nameTag then nameTag.Visible = false end
            highlight.Enabled = false
        end
    end
end

local function clearESP()
    for _, h in pairs(espData.highlights) do pcall(function() h:Destroy() end) end
    for _, n in pairs(espData.nameTags) do pcall(function() n:Remove() end) end
    espData.highlights = {}; espData.nameTags = {}
end

-- ========== AUTO AIM ==========
local function getClosestPlayerToCrosshair()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local closestPlayer, closestDistance = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPart = player.Character:FindFirstChild(state.aimPartName) or player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetPart and humanoid and humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if distance < closestDistance and distance < 200 then
                        closestPlayer = player; closestDistance = distance
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function updateHeadshotAim()
    if not state.autoHeadshotEnabled or not state.isAiming then return end
    if state.currentTarget then
        local char = state.currentTarget.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum or hum.Health <= 0 then state.currentTarget = nil end
    end
    if not state.currentTarget then state.currentTarget = getClosestPlayerToCrosshair() end
    if state.currentTarget and state.currentTarget.Character then
        local targetPart = state.currentTarget.Character:FindFirstChild(state.aimPartName) or state.currentTarget.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position) end
    end
end

-- ========== CROSSHAIR ==========
local crosshairGui = nil
local function createCrosshair()
    if crosshairGui then crosshairGui:Destroy() end
    if not state.crosshairEnabled then return end
    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "c1rooCrosshair"
    crosshairGui.ResetOnSpawn = false
    pcall(function() crosshairGui.Parent = game:GetService("CoreGui") end)
    if not crosshairGui.Parent then crosshairGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    if state.crosshairStyle == "dot" then
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 4, 0, 4)
        dot.Position = UDim2.new(0.5, -2, 0.5, -2)
        dot.BackgroundColor3 = state.crosshairColor
        dot.BorderSizePixel = 0
        dot.Parent = crosshairGui
    elseif state.crosshairStyle == "plus" then
        local h = Instance.new("Frame")
        h.Size = UDim2.new(0, 16, 0, 2)
        h.Position = UDim2.new(0.5, -8, 0.5, -1)
        h.BackgroundColor3 = state.crosshairColor
        h.BorderSizePixel = 0
        h.Parent = crosshairGui
        local v = Instance.new("Frame")
        v.Size = UDim2.new(0, 2, 0, 16)
        v.Position = UDim2.new(0.5, -1, 0.5, -8)
        v.BackgroundColor3 = state.crosshairColor
        v.BorderSizePixel = 0
        v.Parent = crosshairGui
    end
end

-- ========== FULLBRIGHT ==========
local origL = {Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient}
local function toggleFullbright(on)
    if on then
        Lighting.Brightness = 2; Lighting.ClockTime = 14
        Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = origL.Brightness; Lighting.ClockTime = origL.ClockTime
        Lighting.FogEnd = origL.FogEnd; Lighting.GlobalShadows = origL.GlobalShadows
        Lighting.Ambient = origL.Ambient
    end
end

-- ========== HEADLESS ==========
local function setHeadless(on)
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = on and 1 or 0
        local face = head:FindFirstChildOfClass("Decal")
        if face then face.Transparent = on end
    end
end

-- ========== ANTIAFK ==========
local antiAfkConn = nil
local function startAntiAfk()
    if antiAfkConn then return end
    antiAfkConn = RunService.Heartbeat:Connect(function()
        if not state.antiAfkEnabled then return end
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
    end)
end
local function stopAntiAfk()
    if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn = nil end
end

-- ========== WALKSPEED ==========
local function applyWalkspeed()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = state.walkspeedEnabled and state.walkspeedValue or 16 end
end

-- ========== FITUR BARU ==========
-- INFINITE JUMP
local infJumpConn = nil
local function enableInfiniteJump()
    if infJumpConn then return end
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        if not state.infiniteJump then return end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
local function disableInfiniteJump()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
end

-- NOCLIP
local noclipConn = nil
local function enableNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        if not state.noclip then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end)
end
local function disableNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
end

-- FLY
local flyConn, flyBodyVel, flyBodyGyro = nil, nil, nil
local function enableFly()
    if flyConn then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVel.Velocity = Vector3.zero
    flyBodyVel.Parent = hrp
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.P = 1e4
    flyBodyGyro.Parent = hrp
    flyConn = RunService.RenderStepped:Connect(function()
        if not state.flyEnabled or not hrp or not hrp.Parent then return end
        local cam = workspace.CurrentCamera
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0, 1, 0) end
        flyBodyVel.Velocity = move * state.flySpeed
        flyBodyGyro.CFrame = cam.CFrame
    end)
end
local function disableFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
end

-- HIP HEIGHT, JUMP, GRAVITY, FOV
local function applyHipHeight(v)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.HipHeight = v end
end
local function applyJumpPower(v)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.UseJumpPower = true; hum.JumpPower = v end
end
local function applyGravity(v) workspace.Gravity = v end
local function applyFOV(v) Camera.FieldOfView = v end

-- ANTI FLING
local antiFlingConn = nil
local function enableAntiFling()
    if antiFlingConn then return end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        if not state.antiFling then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.AssemblyLinearVelocity.Magnitude > 500 then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end
local function disableAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect(); antiFlingConn = nil end
end

-- CHAT SPAM
local chatSpamConn = nil
local function enableChatSpam()
    if chatSpamConn then return end
    chatSpamConn = task.spawn(function()
        while state.chatSpamEnabled do
            pcall(function()
                local ev = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                if ev and ev:FindFirstChild("SayMessageRequest") then
                    ev.SayMessageRequest:FireServer(state.chatSpamText, "All")
                end
            end)
            task.wait(state.chatSpamDelay)
        end
    end)
end
local function disableChatSpam()
    state.chatSpamEnabled = false
    chatSpamConn = nil
end

-- REACH
local reachConn = nil
local function enableReach()
    if reachConn then return end
    reachConn = RunService.Heartbeat:Connect(function()
        if not state.reachEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                tool.Handle.Size = Vector3.new(state.reachDistance, state.reachDistance, state.reachDistance)
            end
        end
    end)
end
local function disableReach()
    if reachConn then reachConn:Disconnect(); reachConn = nil end
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                tool.Handle.Size = Vector3.new(1, 1, 1)
            end
        end
    end
end

-- TELEPORT
local function tpToPlayer(name)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and string.find(string.lower(p.Name), string.lower(name)) then
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                return true
            end
        end
    end
    return false
end

-- SERVER HOP
local function serverHop()
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local req = HttpService:JSONDecode(game:HttpGet(url))
        for _, srv in pairs(req.data) do
            if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                return
            end
        end
    end)
end

-- ========== SHIFT LOCK ==========
local shiftLockConn = nil
local shiftLockGui = nil
local shiftLockActive = false

local function applyShiftLock()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if shiftLockActive then
        hum.CameraOffset = Vector3.new(1.75, 0.5, 0)
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        hum.CameraOffset = Vector3.zero
    end
end

local function enableShiftLock()
    if shiftLockConn then return end
    shiftLockActive = true
    shiftLockConn = RunService.RenderStepped:Connect(function()
        if not shiftLockActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.CameraOffset = Vector3.new(1.75, 0.5, 0)
        end
    end)
    applyShiftLock()
end

local function disableShiftLock()
    shiftLockActive = false
    if shiftLockConn then shiftLockConn:Disconnect(); shiftLockConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = Vector3.zero end
    end
end

local function createShiftLockIcon()
    if shiftLockGui then shiftLockGui:Destroy() end
    shiftLockGui = Instance.new("ScreenGui")
    shiftLockGui.Name = "c1rooShiftLock"
    shiftLockGui.ResetOnSpawn = false
    pcall(function() shiftLockGui.Parent = game:GetService("CoreGui") end)
    if not shiftLockGui.Parent then shiftLockGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local btn = Instance.new("TextButton")
    btn.Name = "ShiftLockBtn"
    btn.Size = UDim2.new(0, 48, 0, 48)
    btn.Position = UDim2.new(1, -68, 1, -68)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    btn.Text = "🔒"
    btn.TextColor3 = Color3.fromRGB(150, 150, 165)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.AutoButtonColor = false
    btn.Parent = shiftLockGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 75)
    stroke.Thickness = 2
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 48)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if not shiftLockActive then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 28)}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function()
        if shiftLockActive then
            disableShiftLock()
            btn.Text = "🔓"
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20, 20, 28), TextColor3 = Color3.fromRGB(150, 150, 165)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 75)}):Play()
            notify("Shift Lock", "Dimatikan.")
        else
            enableShiftLock()
            btn.Text = "🔒"
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 160), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(0, 200, 255)}):Play()
            notify("Shift Lock", "Aktif.")
        end
    end)
end

-- ========== INPUT ==========
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and state.tpEnabled and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouseLoc = UserInputService:GetMouseLocation()
        local ray = Camera:ScreenPointToRay(mouseLoc.X, mouseLoc.Y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {LocalPlayer.Character}
        local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
        if hit and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
        end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then state.isAiming = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        state.isAiming = false; state.currentTarget = nil
    end
end)

RunService.RenderStepped:Connect(function()
    updateHeadshotAim()
    updateESP()
end)

RunService.Heartbeat:Connect(function()
    if state.walkspeedEnabled then applyWalkspeed() end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyWalkspeed()
    if state.headlessEnabled then setHeadless(true) end
    if state.hipHeight ~= 2 then applyHipHeight(state.hipHeight) end
    if state.jumpPower ~= 50 then applyJumpPower(state.jumpPower) end
    if state.infiniteJump then enableInfiniteJump() end
    if state.noclip then enableNoclip() end
    if state.shiftLockEnabled then enableShiftLock() end
end)

-- ========== BUILD UI ==========
local UI = c1rooUI
local window = UI:CreateWindow({ Title = "c1roo_Universal", W = 600, H = 420 })

-- ===== MAIN =====
local tabMain = window:AddTab({ Name = "Main" })
local secMain = tabMain:AddSection({ Name = "Player" })

secMain:AddToggle({ Name = "ESP", Default = false, Callback = function(v)
    state.espEnabled = v
    if v then
        for _, p in pairs(Players:GetPlayers()) do addESP(p) end
        espPlayerAddedConn = Players.PlayerAdded:Connect(function(p) if state.espEnabled then addESP(p) end end)
        espConnection = RunService.RenderStepped:Connect(updateESP)
        notify("ESP", "Aktif.")
    else
        if espConnection then espConnection:Disconnect(); espConnection = nil end
        if espPlayerAddedConn then espPlayerAddedConn:Disconnect(); espPlayerAddedConn = nil end
        clearESP()
        notify("ESP", "Dimatikan.")
    end
end})

secMain:AddToggle({ Name = "Teleport (Ctrl + Klik)", Default = false, Callback = function(v)
    state.tpEnabled = v
    notify("Teleport", v and "Aktif." or "Dimatikan.")
end})

secMain:AddToggle({ Name = "Anti AFK", Default = false, Callback = function(v)
    state.antiAfkEnabled = v
    if v then startAntiAfk() else stopAntiAfk() end
    notify("Anti AFK", v and "Aktif." or "Dimatikan.")
end})

secMain:AddButton({ Name = "Rejoin Server", Callback = function()
    notify("Rejoin", "Menghubungkan ulang...")
    task.wait(0.5)
    TeleportService:Teleport(game.PlaceId)
end})

-- ===== COMBAT =====
local tabCombat = window:AddTab({ Name = "Combat" })
local secAim = tabCombat:AddSection({ Name = "Auto Aim" })

secAim:AddToggle({ Name = "Enable Auto Aim", Default = false, Callback = function(v)
    state.autoHeadshotEnabled = v
    if not v then state.currentTarget = nil end
    notify("Auto Aim", v and "Aktif." or "Dimatikan.")
end})

secAim:AddButton({ Name = "Target: Head", Callback = function() state.aimPartName = "Head"; notify("Aim", "Target: Kepala.") end })
secAim:AddButton({ Name = "Target: Body", Callback = function() state.aimPartName = "HumanoidRootPart"; notify("Aim", "Target: Badan.") end })

local secSpeed = tabCombat:AddSection({ Name = "Speed" })
secSpeed:AddToggle({ Name = "Walkspeed Hack", Default = false, Callback = function(v)
    state.walkspeedEnabled = v
    applyWalkspeed()
    notify("Walkspeed", v and ("Aktif. Speed: " .. state.walkspeedValue) or "Dimatikan.")
end})
secSpeed:AddSlider({ Name = "Walkspeed Value", Min = 1, Max = 500, Default = 16, Callback = function(v)
    state.walkspeedValue = v
    if state.walkspeedEnabled then applyWalkspeed() end
end})

local secReach = tabCombat:AddSection({ Name = "Reach" })
secReach:AddToggle({ Name = "Enable Reach", Default = false, Callback = function(v)
    state.reachEnabled = v
    if v then enableReach() else disableReach() end
    notify("Reach", v and "Aktif." or "Dimatikan.")
end})
secReach:AddSlider({ Name = "Reach Distance", Min = 1, Max = 50, Default = 10, Callback = function(v) state.reachDistance = v end })

-- ===== VISUAL =====
local tabVisual = window:AddTab({ Name = "Visual" })
local secLight = tabVisual:AddSection({ Name = "Lighting" })

secLight:AddToggle({ Name = "Fullbright", Default = false, Callback = function(v)
    state.fullbrightEnabled = v
    toggleFullbright(v)
    notify("Fullbright", v and "Aktif." or "Dimatikan.")
end})

secLight:AddToggle({ Name = "Headless Visual", Default = false, Callback = function(v)
    state.headlessEnabled = v
    setHeadless(v)
    notify("Headless", v and "Aktif." or "Dimatikan.")
end})

local secCross = tabVisual:AddSection({ Name = "Crosshair" })
secCross:AddToggle({ Name = "Enable Crosshair", Default = false, Callback = function(v)
    state.crosshairEnabled = v
    createCrosshair()
    notify("Crosshair", v and "Aktif." or "Dimatikan.")
end})
secCross:AddButton({ Name = "Style: Dot", Callback = function() state.crosshairStyle = "dot"; if state.crosshairEnabled then createCrosshair() end end })
secCross:AddButton({ Name = "Style: Plus", Callback = function() state.crosshairStyle = "plus"; if state.crosshairEnabled then createCrosshair() end end })
secCross:AddButton({ Name = "Color: White", Callback = function() state.crosshairColor = Color3.fromRGB(255,255,255); if state.crosshairEnabled then createCrosshair() end end })
secCross:AddButton({ Name = "Color: Red", Callback = function() state.crosshairColor = Color3.fromRGB(255,0,0); if state.crosshairEnabled then createCrosshair() end end })
secCross:AddButton({ Name = "Color: Green", Callback = function() state.crosshairColor = Color3.fromRGB(0,255,0); if state.crosshairEnabled then createCrosshair() end end })

local secShift = tabVisual:AddSection({ Name = "Shift Lock" })
secShift:AddToggle({ Name = "Enable Shift Lock Icon", Default = false, Callback = function(v)
    state.shiftLockEnabled = v
    if v then createShiftLockIcon() else
        if shiftLockGui then shiftLockGui:Destroy(); shiftLockGui = nil end
        disableShiftLock()
    end
    notify("Shift Lock", v and "Icon muncul di kanan bawah." or "Dimatikan.")
end})

-- ===== ANIM =====
local tabAnim = window:AddTab({ Name = "Anim" })
local secAnimFull = tabAnim:AddSection({ Name = "Full Set" })
for _, name in ipairs(AnimDB.Full) do
    secAnimFull:AddButton({ Name = name, Callback = function() applyFull(name); notify("Animasi", name .. " diterapkan.") end })
end

local secAnimIdle = tabAnim:AddSection({ Name = "Idle" })
for name, id in pairs(AnimDB.Idle) do secAnimIdle:AddButton({ Name = name, Callback = function() applyAnim("Idle", id); notify("Idle", name) end }) end
local secAnimWalk = tabAnim:AddSection({ Name = "Walk" })
for name, id in pairs(AnimDB.Walk) do secAnimWalk:AddButton({ Name = name, Callback = function() applyAnim("Walk", id); notify("Walk", name) end }) end
local secAnimRun = tabAnim:AddSection({ Name = "Run" })
for name, id in pairs(AnimDB.Run) do secAnimRun:AddButton({ Name = name, Callback = function() applyAnim("Run", id); notify("Run", name) end }) end
local secAnimJump = tabAnim:AddSection({ Name = "Jump" })
for name, id in pairs(AnimDB.Jump) do secAnimJump:AddButton({ Name = name, Callback = function() applyAnim("Jump", id); notify("Jump", name) end }) end
local secAnimFall = tabAnim:AddSection({ Name = "Fall" })
for name, id in pairs(AnimDB.Fall) do secAnimFall:AddButton({ Name = name, Callback = function() applyAnim("Fall", id); notify("Fall", name) end }) end
local secAnimClimb = tabAnim:AddSection({ Name = "Climb" })
for name, id in pairs(AnimDB.Climb) do secAnimClimb:AddButton({ Name = name, Callback = function() applyAnim("Climb", id); notify("Climb", name) end }) end
local secAnimSwim = tabAnim:AddSection({ Name = "Swim" })
for name, id in pairs(AnimDB.Swim) do secAnimSwim:AddButton({ Name = name, Callback = function() applyAnim("Swim", id); notify("Swim", name) end }) end
local secAnimSwimIdle = tabAnim:AddSection({ Name = "Swim Idle" })
for name, id in pairs(AnimDB.SwimIdle) do secAnimSwimIdle:AddButton({ Name = name, Callback = function() applyAnim("SwimIdle", id); notify("Swim Idle", name) end }) end

-- ===== PLAYER =====
local tabPlayer = window:AddTab({ Name = "Player" })
local secPhys = tabPlayer:AddSection({ Name = "Physics" })

secPhys:AddSlider({ Name = "Jump Power", Min = 1, Max = 500, Default = 50, Callback = function(v) state.jumpPower = v; applyJumpPower(v) end })
secPhys:AddSlider({ Name = "Hip Height", Min = -10, Max = 50, Default = 2, Callback = function(v) state.hipHeight = v; applyHipHeight(v) end })
secPhys:AddSlider({ Name = "Gravity", Min = 0, Max = 500, Default = 196, Callback = function(v) state.gravity = v; applyGravity(v) end })
secPhys:AddButton({ Name = "Reset Physics", Callback = function()
    applyHipHeight(2); applyJumpPower(50); applyGravity(196.2)
    state.walkspeedValue = 16; applyWalkspeed()
    notify("Player", "Physics direset.")
end})

local secMove = tabPlayer:AddSection({ Name = "Movement" })
secMove:AddToggle({ Name = "Infinite Jump", Default = false, Callback = function(v)
    state.infiniteJump = v
    if v then enableInfiniteJump() else disableInfiniteJump() end
    notify("Infinite Jump", v and "Aktif." or "Dimatikan.")
end})
secMove:AddToggle({ Name = "Noclip", Default = false, Callback = function(v)
    state.noclip = v
    if v then enableNoclip() else disableNoclip() end
    notify("Noclip", v and "Aktif." or "Dimatikan.")
end})
secMove:AddToggle({ Name = "Fly (WASD + Space/Ctrl)", Default = false, Callback = function(v)
    state.flyEnabled = v
    if v then enableFly() else disableFly() end
    notify("Fly", v and "Aktif." or "Dimatikan.")
end})
secMove:AddSlider({ Name = "Fly Speed", Min = 10, Max = 500, Default = 50, Callback = function(v) state.flySpeed = v end })

local secMiscP = tabPlayer:AddSection({ Name = "Misc" })
secMiscP:AddToggle({ Name = "Anti Fling", Default = false, Callback = function(v)
    state.antiFling = v
    if v then enableAntiFling() else disableAntiFling() end
    notify("Anti Fling", v and "Aktif." or "Dimatikan.")
end})
secMiscP:AddButton({ Name = "Reset Character", Callback = function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    end
end})

-- ===== TP =====
local tabTP = window:AddTab({ Name = "TP" })
local secTPPlayer = tabTP:AddSection({ Name = "Teleport to Player" })
local tpInput = ""
secTPPlayer:AddInput({ Name = "Player Name", Placeholder = "Ketik username...", Callback = function(t) tpInput = t end })
secTPPlayer:AddButton({ Name = "Teleport", Callback = function()
    if tpToPlayer(tpInput) then notify("TP", "Ke " .. tpInput) else notify("TP", "Player tidak ditemukan.") end
end})

local secTPSrv = tabTP:AddSection({ Name = "Server" })
secTPSrv:AddButton({ Name = "Server Hop", Callback = function() notify("Server Hop", "Mencari server..."); task.wait(0.5); serverHop() end })
secTPSrv:AddButton({ Name = "Copy Job ID", Callback = function()
    pcall(function() if setclipboard then setclipboard(game.JobId) end end)
    notify("Job ID", "Disalin.")
end})

-- ===== MISC =====
local tabMisc = window:AddTab({ Name = "Misc" })
local secChat = tabMisc:AddSection({ Name = "Chat Spam" })
local chatText = "c1roo on top"
secChat:AddInput({ Name = "Chat Text", Placeholder = "Pesan...", Callback = function(t) chatText = t end })
secChat:AddToggle({ Name = "Chat Spam", Default = false, Callback = function(v)
    state.chatSpamEnabled = v
    state.chatSpamText = chatText
    if v then enableChatSpam() else disableChatSpam() end
    notify("Chat Spam", v and "Aktif." or "Dimatikan.")
end})
secChat:AddSlider({ Name = "Delay", Min = 0.5, Max = 10, Default = 1, Callback = function(v) state.chatSpamDelay = v end })

local secFov = tabMisc:AddSection({ Name = "Camera" })
secFov:AddSlider({ Name = "FOV", Min = 30, Max = 120, Default = 70, Callback = function(v) state.fov = v; applyFOV(v) end })
secFov:AddButton({ Name = "Reset FOV", Callback = function() applyFOV(70); notify("FOV", "Reset ke 70.") end })

-- ========== WELCOME ==========
task.wait(0.5)
notify("c1roo_Universal", "Script berhasil dimuat!")
task.wait(1)
notify("Info", "Klik — untuk minimize. Icon c1roo di kiri.")

print("[c1roo_Universal] Loaded successfully!")