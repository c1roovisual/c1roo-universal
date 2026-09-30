-- ============================================
-- c1roo_Universal - FULL SCRIPT v8
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
    local dragging, dragStart, startPos = false, nil, nil
    local iconDragging, iconDragStart, iconStartPos = false, nil, nil
    local iconMoved = false

    function c1rooUI:Notify(opts)
        opts = opts or {}
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = opts.Title or "c1roo",
                Text = opts.Text or "",
                Duration = opts.Duration or 3,
                Icon = opts.Icon ~= "" and opts.Icon or nil,
            })
        end)
    end

    function c1rooUI:CreateWindow(opts)
        opts = opts or {}
        local title = opts.Title or "c1roo_Universal"
        local w = opts.W or 620
        local h = opts.H or 430

        if gui then gui:Destroy() end

        gui = mk("ScreenGui", {
            Name = "c1rooUI", ResetOnSpawn = false,
            IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
        if not ok or not gui.Parent then
            gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end

        iconFrame = mk("TextButton", {
            Name = "c1rooIcon", Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0, 20, 0.5, -30),
            BackgroundColor3 = T.Bg, Text = "c1roo",
            TextColor3 = T.Accent, Font = Enum.Font.GothamBold,
            TextSize = 13, AutoButtonColor = false, Visible = false,
            Parent = gui,
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 14), Parent = iconFrame})
        mk("UIStroke", {Color = T.Accent, Thickness = 2, Parent = iconFrame})

        local pulseDot = mk("Frame", {
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(1, -8, 0, -2),
            BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = iconFrame,
        })
        mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = pulseDot})
        mk("UIStroke", {Color = T.Bg, Thickness = 2, Parent = pulseDot})

        iconFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                iconDragging = true; iconMoved = false
                iconDragStart = input.Position
                iconStartPos = iconFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then iconDragging = false end
                end)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - iconDragStart
                if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then iconMoved = true end
                iconFrame.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + d.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + d.Y)
            end
        end)

        local main = mk("Frame", {
            Size = UDim2.new(0, w, 0, h),
            Position = UDim2.new(0.5, -w/2, 0.5, -h/2),
            BackgroundColor3 = T.Bg, BorderSizePixel = 0, Active = true, Parent = gui,
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 10), Parent = main})
        mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = main})

        local topBar = mk("Frame", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = T.Surface, BorderSizePixel = 0, Parent = main,
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 10), Parent = topBar})
        mk("Frame", {
            Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
            BackgroundColor3 = T.Surface, BorderSizePixel = 0, Parent = topBar,
        })

        mk("TextLabel", {
            Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1, Text = title,
            TextColor3 = T.Text, Font = Enum.Font.GothamBold,
            TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = topBar,
        })

        mk("Frame", {
            Size = UDim2.new(0, 50, 0, 2), Position = UDim2.new(0, 14, 1, -2),
            BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = topBar,
        })

        local minimizeBtn = mk("TextButton", {
            Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(1, -38, 0, 4),
            BackgroundColor3 = T.SurfaceLight, Text = "—",
            TextColor3 = T.TextDim, Font = Enum.Font.GothamBold,
            TextSize = 16, AutoButtonColor = false, Parent = topBar,
        })
        mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = minimizeBtn})
        minimizeBtn.MouseEnter:Connect(function() tw(minimizeBtn, {BackgroundColor3 = T.AccentDim, TextColor3 = T.Text}, 0.15) end)
        minimizeBtn.MouseLeave:Connect(function() tw(minimizeBtn, {BackgroundColor3 = T.SurfaceLight, TextColor3 = T.TextDim}, 0.15) end)
        minimizeBtn.MouseButton1Click:Connect(function() main.Visible = false; iconFrame.Visible = true end)

        iconFrame.MouseButton1Click:Connect(function()
            if iconMoved then return end
            iconFrame.Visible = false
            main.Visible = true
            main.Size = UDim2.new(0, 0, 0, 0)
            main.Position = UDim2.new(0.5, 0, 0.5, 0)
            tw(main, {Size = UDim2.new(0, w, 0, h), Position = UDim2.new(0.5, -w/2, 0.5, -h/2)}, 0.2)
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
                else break end
            end
        end)

        topBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = main.Position
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
            Size = UDim2.new(1, 0, 1, -40), Position = UDim2.new(0, 0, 0, 40),
            BackgroundTransparency = 1, Parent = main,
        })

        local tabBar = mk("ScrollingFrame", {
            Size = UDim2.new(1, -16, 0, 36), Position = UDim2.new(0, 8, 0, 8),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.X, Parent = content,
        })
        mk("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center, Parent = tabBar,
        })

        local pageWrap = mk("Frame", {
            Size = UDim2.new(1, -16, 1, -52), Position = UDim2.new(0, 8, 0, 52),
            BackgroundTransparency = 1, ClipsDescendants = true, Parent = content,
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
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = T.Surface, Text = name, TextColor3 = T.TextDim,
                Font = Enum.Font.Gotham, TextSize = 11,
                AutoButtonColor = false, Parent = self._tabBar,
            })
            mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = btn})
            mk("UIPadding", {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = btn})
            local stroke = mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = btn})

            local page = mk("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = 3, ScrollBarImageColor3 = T.Accent,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                Visible = false, Parent = self._pageWrap,
            })
            mk("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})
            mk("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 6), Parent = page})

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
                    Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y, Parent = self._page,
                })
                mk("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = section})
                mk("UIPadding", {PaddingBottom = UDim.new(0, 4), Parent = section})

                mk("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1,
                    Text = secName, TextColor3 = T.Accent, Font = Enum.Font.GothamBold,
                    TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = section,
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
                        Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = T.Surface,
                        Text = "", AutoButtonColor = false,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = f})
                    local s = mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = f})
                    mk("TextLabel", {
                        Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                        BackgroundTransparency = 1, Text = o.Name or "Button",
                        TextColor3 = T.Text, Font = Enum.Font.Gotham, TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
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
                        Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = T.Surface,
                        BorderSizePixel = 0,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = f})
                    local s = mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = f})
                    mk("TextLabel", {
                        Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                        BackgroundTransparency = 1, Text = o.Name or "Toggle",
                        TextColor3 = T.Text, Font = Enum.Font.Gotham, TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                    })
                    local bg = mk("Frame", {
                        Size = UDim2.new(0, 42, 0, 22), Position = UDim2.new(1, -54, 0.5, -11),
                        BackgroundColor3 = state and T.ToggleOn or T.ToggleOff,
                        BorderSizePixel = 0, Parent = f,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = bg})
                    local knob = mk("Frame", {
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0, Parent = bg,
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
                        Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = T.Surface,
                        BorderSizePixel = 0,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = f})
                    mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = f})

                    mk("TextLabel", {
                        Size = UDim2.new(0.7, 0, 0, 22), Position = UDim2.new(0, 12, 0, 4),
                        BackgroundTransparency = 1, Text = o.Name or "Slider",
                        TextColor3 = T.Text, Font = Enum.Font.Gotham, TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                    })
                    local vl = mk("TextLabel", {
                        Size = UDim2.new(0.3, -12, 0, 22), Position = UDim2.new(0.7, 0, 0, 4),
                        BackgroundTransparency = 1, Text = tostring(value),
                        TextColor3 = T.Accent, Font = Enum.Font.GothamBold,
                        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = f,
                    })
                    local barBg = mk("Frame", {
                        Size = UDim2.new(1, -24, 0, 8), Position = UDim2.new(0, 12, 0, 36),
                        BackgroundColor3 = T.ToggleOff, BorderSizePixel = 0, Parent = f,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = barBg})
                    local fill = mk("Frame", {
                        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                        BackgroundColor3 = T.Accent, BorderSizePixel = 0, Parent = barBg,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(1, 0), Parent = fill})
                    local knob = mk("Frame", {
                        Size = UDim2.new(0, 14, 0, 14),
                        Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderSizePixel = 0, ZIndex = 2, Parent = barBg,
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
                            dragging2 = true; upd(i)
                        end
                    end)
                    UserInputService.InputChanged:Connect(function(i)
                        if dragging2 and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then upd(i) end
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
                        Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = T.Surface,
                        BorderSizePixel = 0,
                    })
                    mk("UICorner", {CornerRadius = UDim.new(0, 6), Parent = f})
                    mk("UIStroke", {Color = T.Border, Thickness = 1, Parent = f})
                    mk("TextLabel", {
                        Size = UDim2.new(1, -24, 0, 20), Position = UDim2.new(0, 12, 0, 4),
                        BackgroundTransparency = 1, Text = o.Name or "Input",
                        TextColor3 = T.Text, Font = Enum.Font.Gotham, TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                    })
                    local box = mk("TextBox", {
                        Size = UDim2.new(1, -24, 0, 24), Position = UDim2.new(0, 12, 0, 24),
                        BackgroundColor3 = T.Bg, Text = "",
                        PlaceholderText = o.Placeholder or "",
                        PlaceholderColor3 = T.TextDim, TextColor3 = T.Text,
                        Font = Enum.Font.Gotham, TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ClearTextOnFocus = false, Parent = f,
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
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function notify(title, text, dur, ntype, icon)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title, Text = text,
            Duration = dur or 3,
            Icon = icon ~= "" and icon or nil,
        })
    end)
end

-- ========== DATABASE ANIMATIONS ==========
local AnimDB = {
    Full = {"Bubbly","Cartoony","Zombie","Ghost","Cowboy","Ninja","Robot","Pirate","Knight","Mage","Vampire","Werewolf","Sneaky","Stylish","Confident","Elder","Toy","Superhero","Wicked (Popular)"},
    Idle = {
        ["Bubbly"] = {"910004836", "910009958"}, ["Cartoony"] = {"742637544", "742638445"},
        ["Zombie"] = {"616158929", "616160636"}, ["Ghost"] = {"616006778", "616008087"},
        ["Cowboy"] = {"1014390418", "1014398616"}, ["Ninja"] = {"656117400", "656118341"},
        ["Robot"] = {"616088211", "616089559"}, ["Pirate"] = {"750781874", "750782770"},
        ["Knight"] = {"657595757", "657568135"}, ["Mage"] = {"707742142", "707855907"},
        ["Vampire"] = {"1083445855", "1083450166"}, ["Werewolf"] = {"1083195517", "1083214717"},
        ["Sneaky"] = {"1132473842", "1132477671"}, ["Stylish"] = {"616136790", "616138447"},
        ["Confident"] = {"1069977950", "1069987858"}, ["Elder"] = {"10921101664", "10921102574"},
        ["Toy"] = {"782841498", "782845736"}, ["Superhero"] = {"10921288909", "10921290167"},
        ["Levitation"] = {"616006778", "616008087"}, ["Princess"] = {"941003647", "941013098"},
        ["Popstar"] = {"1212900985", "1150842221"}, ["R6"] = {"12521158637","12521162526"},
        ["R15 Reanimated"] = {"4211217646", "4211218409"}, ["Realistic"] = {"17172918855", "17173014241"},
        ["Soldier"] = {"3972151362", "3972151362"}, ["Stylized Female"] = {"4708191566", "4708192150"},
        ["Udzal"] = {"3303162274", "3303162549"}, ["Astronaut"] = {"891621366", "891633237"},
        ["MrToilet"] = {"4417977954", "4417978624"}, ["Catwalk Glam"] = {"133806214992291","94970088341563"},
        ["Drooling Zombie"] = {"3489171152", "3489171152"}, ["Sway"] = {"560832030", "560833564"},
        ["OldSchool"] = {"10921230744", "10921232093"}, ["Patrol"] = {"1149612882", "1150842221"},
    },
    Walk = {
        ["Bubbly"]="910034870",["Zombie"]="616168032",["Ghost"]="616013216",["Cowboy"]="1014421541",["Ninja"]="656121766",
        ["Robot"]="616095330",["Pirate"]="750785693",["Knight"]="10921127095",["Mage"]="707897309",["Vampire"]="1083473930",
        ["Werewolf"]="1083178339",["Sneaky"]="1132510133",["Stylish"]="616146177",["Confident"]="1070017263",["Elder"]="10921111375",
        ["Toy"]="10921306285",["Superhero"]="10921298616",["Levitation"]="616013216",["Princess"]="941028902",["Popstar"]="1212980338",
        ["R6"]="12518152696",["R15 Reanimated"]="4211223236",["Stylized Female"]="4708193840",["Udzal"]="3303162967",
        ["Astronaut"]="891667138",["Catwalk Glam"]="109168724482748",["Drooling Zombie"]="3489174223",["OldSchool"]="10921244891",
        ["Patrol"]="1151231493",["Cool Boy"]="79127340077185",
    },
    Run = {
        ["Bubbly"]="10921057244",["Zombie"]="616163682",["Ghost"]="616013216",["Cowboy"]="1014401683",["Ninja"]="656118852",
        ["Robot"]="10921250460",["Pirate"]="750783738",["Knight"]="10921121197",["Mage"]="10921148209",["Vampire"]="10921320299",
        ["Werewolf"]="10921336997",["Sneaky"]="1132494274",["Stylish"]="10921276116",["Confident"]="1070001516",["Elder"]="10921104374",
        ["Toy"]="10921306285",["Superhero"]="10921291831",["Levitation"]="616010382",["Princess"]="941015281",["Popstar"]="1212980348",
        ["R6"]="12518152696",["R15 Reanimated"]="4211220381",["Stylized Female"]="4708192705",["Heavy Run"]="3236836670",
        ["Astronaut"]="10921039308",["Catwalk Glam"]="81024476153754",["Drooling Zombie"]="3489173414",["OldSchool"]="10921240218",
        ["Patrol"]="1150967949",
    },
    Jump = {
        ["Bubbly"]="910016857",["Zombie"]="616161997",["Ghost"]="616008936",["Cowboy"]="1014394726",["Ninja"]="656117878",
        ["Robot"]="616090535",["Pirate"]="750782230",["Knight"]="910016857",["Mage"]="10921149743",["Vampire"]="1083455352",
        ["Werewolf"]="1083218792",["Sneaky"]="1132489853",["Stylish"]="616139451",["Confident"]="1069984524",["Elder"]="10921107367",
        ["Toy"]="10921308158",["Superhero"]="10921294559",["Levitation"]="616008936",["Princess"]="941008832",["Popstar"]="1212954642",
        ["R6"]="12520880485",["R15 Reanimated"]="4211219390",["Stylized Female"]="4708188025",["Astronaut"]="891627522",
        ["Catwalk Glam"]="116936326516985",["OldSchool"]="10921242013",["Patrol"]="1148811837",
    },
    Fall = {
        ["Bubbly"]="910001910",["Zombie"]="616157476",["Cowboy"]="1014384571",["Ninja"]="656115606",["Robot"]="616087089",
        ["Pirate"]="750782230",["Knight"]="10921122579",["Mage"]="707829716",["Vampire"]="1083443587",["Werewolf"]="1083189019",
        ["Sneaky"]="1132469004",["Stylish"]="616134815",["Confident"]="1069973677",["Elder"]="10921105765",["Toy"]="782846423",
        ["Superhero"]="10921293373",["Levitation"]="616005863",["Princess"]="941000007",["Popstar"]="1212900995",["R6"]="12520972571",
        ["R15 Reanimated"]="4211216152",["Stylized Female"]="4708186162",["Astronaut"]="891617961",
        ["Catwalk Glam"]="92294537340807",["OldSchool"]="10921241244",["Patrol"]="1148863382",
    },
    Climb = {
        ["Bubbly"]="742636889",["Zombie"]="616156119",["Ghost"]="616003713",["Cowboy"]="1014380606",["Ninja"]="656114359",
        ["Robot"]="616086039",["Knight"]="10921125160",["Mage"]="707826056",["Vampire"]="1083439238",["Sneaky"]="1132461372",
        ["Stylish"]="10921271391",["Confident"]="1069946257",["Elder"]="845392038",["Toy"]="10921300839",["Superhero"]="10921286911",
        ["Levitation"]="10921132092",["Princess"]="940996062",["Popstar"]="1213044953",["R6"]="12520982150",
        ["R15 Reanimated"]="4211214992",["Stylized Female"]="4708184253",["Astronaut"]="10921032124",
        ["Catwalk Glam"]="119377220967554",["OldSchool"]="10921229866",["Patrol"]="1148811837",
    },
    Swim = {
        ["Bubbly"]="910028158",["Zombie"]="616165109",["Cowboy"]="1014406523",["Ninja"]="656118341",["Robot"]="10921253142",
        ["Pirate"]="750784579",["Knight"]="10921125160",["Mage"]="707876443",["Vampire"]="10921324408",["Werewolf"]="10921340419",
        ["Sneaky"]="1132500520",["Stylish"]="10921281000",["Confident"]="1070009914",["Elder"]="10921108971",["Toy"]="10921309319",
        ["Superhero"]="10921295495",["Popstar"]="1212998578",["Princess"]="941018893",["R6"]="12518152696",
        ["Astronaut"]="891663592",["Catwalk Glam"]="134591743181628",["OldSchool"]="10921243048",
        ["Patrol"]="1151204998",["Levitation"]="10921138209",
    },
    SwimIdle = {
        ["Bubbly"]="910030921",["Zombie"]="616165109",["Cowboy"]="1014411816",["Ninja"]="656118341",["Robot"]="10921253767",
        ["Pirate"]="750785176",["Knight"]="10921125935",["Mage"]="707894699",["Vampire"]="10921325443",["Werewolf"]="10921341319",
        ["Sneaky"]="1132506407",["Stylish"]="10921281964",["Confident"]="1070012133",["Elder"]="10921110146",["Toy"]="10921310341",
        ["Superhero"]="10921297391",["Popstar"]="1212998578",["Princess"]="941025398",["R6"]="12518152696",
        ["Astronaut"]="891663592",["Catwalk Glam"]="98854111361360",["OldSchool"]="10921244018",
        ["Patrol"]="1151221899",["Levitation"]="10921139478",
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
    tpEnabled=false, antiAfkEnabled=false,
    walkspeedEnabled=false, walkspeedValue=16,
    espEnabled=false, autoHeadshotEnabled=false,
    aimPartName="Head", isAiming=false, currentTarget=nil,
    fullbrightEnabled=false, headlessEnabled=false,
    crosshairEnabled=false, crosshairStyle="dot",
    crosshairColor=Color3.fromRGB(255,255,255),
    infiniteJump=false, noclip=false,
    flyEnabled=false, flySpeed=50,
    hipHeight=2, jumpPower=50, gravity=196.2,
    fov=70, antiFling=false,
    chatSpamEnabled=false, chatSpamText="", chatSpamDelay=1,
    reachEnabled=false, reachDistance=10,
    shiftLockEnabled=false,
    autoRespawn=false, autoHeal=false,
    autoClicker=false, autoClickerCPS=10,
    bunnyHop=false, trackerHUD=false,
    dpadEnabled=false, syncEmoteActive=false,
}

-- ========== ESP ==========
local espData = {highlights={}, nameTags={}}
local espConnection, espPlayerAddedConn = nil, nil

local function addESP(player)
    if player == LocalPlayer or espData.highlights[player] then return end
    local h = Instance.new("Highlight")
    h.Name = "c1rooESP"; h.FillTransparency = 0.7; h.OutlineTransparency = 0.2
    h.OutlineColor = Color3.fromRGB(0,200,255); h.FillColor = Color3.fromRGB(0,200,255)
    local nt = Drawing.new("Text")
    nt.Size = 14; nt.Center = true; nt.Outline = true
    nt.OutlineColor = Color3.fromRGB(0,0,0); nt.Color = Color3.fromRGB(255,255,255); nt.Font = 2
    espData.highlights[player] = h
    espData.nameTags[player] = nt
    if player.Character then h.Parent = player.Character end
    player.CharacterAdded:Connect(function(c) if state.espEnabled then h.Parent = c end end)
end

local function updateESP()
    if not state.espEnabled then return end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for player, h in pairs(espData.highlights) do
        local nt = espData.nameTags[player]
        local c = player.Character
        if c and c:FindFirstChild("Head") then
            local head = c.Head
            local hp, on = Camera:WorldToViewportPoint(head.Position)
            local dT = ""
            if myRoot and c:FindFirstChild("HumanoidRootPart") then
                dT = string.format(" [%.0fm]", (myRoot.Position - c.HumanoidRootPart.Position).Magnitude)
            end
            if on then
                nt.Visible = true
                nt.Position = Vector2.new(hp.X, hp.Y - 35)
                nt.Text = player.Name .. dT
            else nt.Visible = false end
            h.Enabled = true
        else
            if nt then nt.Visible = false end
            h.Enabled = false
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
    local sc = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local cp, cd = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local tp = p.Character:FindFirstChild(state.aimPartName) or p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if tp and hum and hum.Health > 0 then
                local pos, on = Camera:WorldToViewportPoint(tp.Position)
                if on then
                    local d = (Vector2.new(pos.X, pos.Y) - sc).Magnitude
                    if d < cd and d < 200 then cp = p; cd = d end
                end
            end
        end
    end
    return cp
end

local function updateHeadshotAim()
    if not state.autoHeadshotEnabled or not state.isAiming then return end
    if state.currentTarget then
        local c = state.currentTarget.Character
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not c or not hum or hum.Health <= 0 then state.currentTarget = nil end
    end
    if not state.currentTarget then state.currentTarget = getClosestPlayerToCrosshair() end
    if state.currentTarget and state.currentTarget.Character then
        local tp = state.currentTarget.Character:FindFirstChild(state.aimPartName) or state.currentTarget.Character:FindFirstChild("HumanoidRootPart")
        if tp then Camera.CFrame = CFrame.new(Camera.CFrame.Position, tp.Position) end
    end
end

-- ========== CROSSHAIR ==========
local crosshairGui = nil
local function createCrosshair()
    if crosshairGui then crosshairGui:Destroy() end
    if not state.crosshairEnabled then return end
    crosshairGui = Instance.new("ScreenGui")
    crosshairGui.Name = "c1rooCrosshair"; crosshairGui.ResetOnSpawn = false
    pcall(function() crosshairGui.Parent = CoreGui end)
    if not crosshairGui.Parent then crosshairGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    if state.crosshairStyle == "dot" then
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0,4,0,4); dot.Position = UDim2.new(0.5,-2,0.5,-2)
        dot.BackgroundColor3 = state.crosshairColor; dot.BorderSizePixel = 0; dot.Parent = crosshairGui
    elseif state.crosshairStyle == "plus" then
        local h = Instance.new("Frame")
        h.Size = UDim2.new(0,16,0,2); h.Position = UDim2.new(0.5,-8,0.5,-1)
        h.BackgroundColor3 = state.crosshairColor; h.BorderSizePixel = 0; h.Parent = crosshairGui
        local v = Instance.new("Frame")
        v.Size = UDim2.new(0,2,0,16); v.Position = UDim2.new(0.5,-1,0.5,-8)
        v.BackgroundColor3 = state.crosshairColor; v.BorderSizePixel = 0; v.Parent = crosshairGui
    end
end

-- ========== FULLBRIGHT ==========
local origL = {Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime, FogEnd=Lighting.FogEnd, GlobalShadows=Lighting.GlobalShadows, Ambient=Lighting.Ambient}
local function toggleFullbright(on)
    if on then
        Lighting.Brightness = 2; Lighting.ClockTime = 14
        Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255,255,255)
    else
        Lighting.Brightness = origL.Brightness; Lighting.ClockTime = origL.ClockTime
        Lighting.FogEnd = origL.FogEnd; Lighting.GlobalShadows = origL.GlobalShadows
        Lighting.Ambient = origL.Ambient
    end
end

-- ========== HEADLESS ==========
local function setHeadless(on)
    local c = LocalPlayer.Character
    if not c then return end
    local head = c:FindFirstChild("Head")
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

-- ========== INFINITE JUMP ==========
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

-- ========== NOCLIP ==========
local noclipConn = nil
local function enableNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        if not state.noclip then return end
        local c = LocalPlayer.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end)
end
local function disableNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
end

-- ========== FLY ==========
local flyConn, flyBodyVel, flyBodyGyro = nil, nil, nil
local function enableFly()
    if flyConn then return end
    local c = LocalPlayer.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1e5,1e5,1e5); flyBodyVel.Velocity = Vector3.zero; flyBodyVel.Parent = hrp
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5); flyBodyGyro.P = 1e4; flyBodyGyro.Parent = hrp
    flyConn = RunService.RenderStepped:Connect(function()
        if not state.flyEnabled or not hrp or not hrp.Parent then return end
        local cam = workspace.CurrentCamera
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
        flyBodyVel.Velocity = move * state.flySpeed
        flyBodyGyro.CFrame = cam.CFrame
    end)
end
local function disableFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBodyVel then flyBodyVel:Destroy(); flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
end

-- ========== PHYSICS ==========
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

-- ========== ANTI FLING ==========
local antiFlingConn = nil
local function enableAntiFling()
    if antiFlingConn then return end
    antiFlingConn = RunService.Heartbeat:Connect(function()
        if not state.antiFling then return end
        local c = LocalPlayer.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.AssemblyLinearVelocity.Magnitude > 500 then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)
end
local function disableAntiFling()
    if antiFlingConn then antiFlingConn:Disconnect(); antiFlingConn = nil end
end

-- ========== CHAT SPAM ==========
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
    state.chatSpamEnabled = false; chatSpamConn = nil
end

-- ========== REACH ==========
local reachConn = nil
local function enableReach()
    if reachConn then return end
    reachConn = RunService.Heartbeat:Connect(function()
        if not state.reachEnabled then return end
        local c = LocalPlayer.Character
        if not c then return end
        for _, tool in ipairs(c:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                tool.Handle.Size = Vector3.new(state.reachDistance, state.reachDistance, state.reachDistance)
            end
        end
    end)
end
local function disableReach()
    if reachConn then reachConn:Disconnect(); reachConn = nil end
    local c = LocalPlayer.Character
    if c then
        for _, tool in ipairs(c:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                tool.Handle.Size = Vector3.new(1,1,1)
            end
        end
    end
end

-- ========== AUTO RESPAWN ==========
local autoRespawnConn = nil
local function enableAutoRespawn()
    if autoRespawnConn then return end
    autoRespawnConn = RunService.Heartbeat:Connect(function()
        if not state.autoRespawn then return end
        local c = LocalPlayer.Character
        if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then
            task.wait(0.5); LocalPlayer:LoadCharacter()
        end
    end)
end
local function disableAutoRespawn()
    if autoRespawnConn then autoRespawnConn:Disconnect(); autoRespawnConn = nil end
end

-- ========== AUTO HEAL ==========
local autoHealConn = nil
local function enableAutoHeal()
    if autoHealConn then return end
    autoHealConn = RunService.Heartbeat:Connect(function()
        if not state.autoHeal then return end
        local c = LocalPlayer.Character
        if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and hum.Health < hum.MaxHealth * 0.5 then
            task.wait(0.3); hum.Health = hum.MaxHealth
        end
    end)
end
local function disableAutoHeal()
    if autoHealConn then autoHealConn:Disconnect(); autoHealConn = nil end
end

-- ========== AUTO CLICKER ==========
local autoClickConn = nil
local function enableAutoClicker()
    if autoClickConn then return end
    autoClickConn = task.spawn(function()
        while state.autoClicker do
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
            task.wait(1 / (state.autoClickerCPS or 10))
        end
    end)
end
local function disableAutoClicker()
    state.autoClicker = false; autoClickConn = nil
end

-- ========== BUNNY HOP ==========
local bunnyHopConn = nil
local function enableBunnyHop()
    if bunnyHopConn then return end
    bunnyHopConn = RunService.Heartbeat:Connect(function()
        if not state.bunnyHop then return end
        local c = LocalPlayer.Character
        if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 and hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
        end
    end)
end
local function disableBunnyHop()
    if bunnyHopConn then bunnyHopConn:Disconnect(); bunnyHopConn = nil end
end

-- ========== SAVE / LOAD POSITION ==========
local savedPosition = nil
local function savePosition()
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        local p = c.HumanoidRootPart.CFrame
        savedPosition = {X=p.X, Y=p.Y, Z=p.Z}; return true
    end
    return false
end
local function loadPosition()
    if not savedPosition then return false end
    local c = LocalPlayer.Character
    if c and c:FindFirstChild("HumanoidRootPart") then
        c.HumanoidRootPart.CFrame = CFrame.new(savedPosition.X, savedPosition.Y, savedPosition.Z)
        return true
    end
    return false
end

-- ========== GET ALL TOOLS ==========
local function getAllTools()
    local c = LocalPlayer.Character
    if not c then return 0 end
    local n = 0
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Tool") and o.Parent ~= c then
            pcall(function() o.Parent = c; n = n + 1 end)
        end
    end
    return n
end

-- ========== PLAYER TRACKER HUD ==========
local trackerFrame, trackerList = nil, nil
local function createTrackerHUD()
    if trackerFrame then trackerFrame:Destroy() end
    local g = Instance.new("ScreenGui")
    g.Name = "c1rooTracker"; g.ResetOnSpawn = false
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,180,0,200); frame.Position = UDim2.new(0,10,0,10)
    frame.BackgroundColor3 = Color3.fromRGB(15,15,20); frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0; frame.Parent = g
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = frame
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0,200,255); s.Thickness = 1; s.Parent = frame
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,-16,0,22); title.Position = UDim2.new(0,8,0,4)
    title.BackgroundTransparency = 1; title.Text = "PLAYERS"
    title.TextColor3 = Color3.fromRGB(0,200,255); title.Font = Enum.Font.GothamBold
    title.TextSize = 11; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = frame
    local list = Instance.new("Frame")
    list.Size = UDim2.new(1,-16,1,-32); list.Position = UDim2.new(0,8,0,26)
    list.BackgroundTransparency = 1; list.Parent = frame
    trackerFrame = frame; trackerList = list
end

local function updateTrackerHUD()
    if not state.trackerHUD then return end
    if not trackerList then createTrackerHUD() end
    if not trackerList then return end
    trackerList:ClearAllChildren()
    local y = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1,0,0,16); lbl.Position = UDim2.new(0,0,0,y)
            lbl.BackgroundTransparency = 1; lbl.Text = p.Name
            lbl.TextColor3 = Color3.fromRGB(240,240,245); lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 10; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Parent = trackerList
            y = y + 16
        end
    end
end

-- ========== SERVER HOP ==========
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

-- ========== PLAYER PICKER (search by name) ==========
local function openPlayerPicker(titleText, onSelect)
    local ex = CoreGui:FindFirstChild("c1rooPicker")
    if ex then ex:Destroy() end
    local pGui = LocalPlayer:WaitForChild("PlayerGui")
    local exP = pGui:FindFirstChild("c1rooPicker")
    if exP then exP:Destroy() end

    local g = Instance.new("ScreenGui")
    g.Name = "c1rooPicker"; g.ResetOnSpawn = false; g.IgnoreGuiInset = true
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = pGui end

    local dim = Instance.new("Frame")
    dim.Size = UDim2.new(1,0,1,0); dim.BackgroundColor3 = Color3.new(0,0,0)
    dim.BackgroundTransparency = 0.5; dim.BorderSizePixel = 0; dim.Parent = g

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,320,0,420); main.Position = UDim2.new(0.5,-160,0.5,-210)
    main.BackgroundColor3 = Color3.fromRGB(15,15,20); main.BorderSizePixel = 0; main.Parent = g
    local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0,10); mc.Parent = main
    local ms = Instance.new("UIStroke"); ms.Color = Color3.fromRGB(0,200,255); ms.Thickness = 1; ms.Parent = main

    local tL = Instance.new("TextLabel")
    tL.Size = UDim2.new(1,-60,0,26); tL.Position = UDim2.new(0,12,0,8)
    tL.BackgroundTransparency = 1; tL.Text = titleText
    tL.TextColor3 = Color3.fromRGB(0,200,255); tL.Font = Enum.Font.GothamBold
    tL.TextSize = 14; tL.TextXAlignment = Enum.TextXAlignment.Left; tL.Parent = main

    local xB = Instance.new("TextButton")
    xB.Size = UDim2.new(0,28,0,28); xB.Position = UDim2.new(1,-36,0,6)
    xB.BackgroundColor3 = Color3.fromRGB(30,30,40); xB.Text = "✕"
    xB.TextColor3 = Color3.fromRGB(150,150,165); xB.Font = Enum.Font.GothamBold
    xB.TextSize = 14; xB.AutoButtonColor = false; xB.Parent = main
    local xc = Instance.new("UICorner"); xc.CornerRadius = UDim.new(0,6); xc.Parent = xB
    xB.MouseButton1Click:Connect(function() g:Destroy() end)

    local sbg = Instance.new("Frame")
    sbg.Size = UDim2.new(1,-24,0,38); sbg.Position = UDim2.new(0,12,0,42)
    sbg.BackgroundColor3 = Color3.fromRGB(22,22,30); sbg.BorderSizePixel = 0; sbg.Parent = main
    local sbc = Instance.new("UICorner"); sbc.CornerRadius = UDim.new(0,6); sbc.Parent = sbg
    local sbs = Instance.new("UIStroke"); sbs.Color = Color3.fromRGB(40,40,55); sbs.Thickness = 1; sbs.Parent = sbg

    local search = Instance.new("TextBox")
    search.Size = UDim2.new(1,-20,1,0); search.Position = UDim2.new(0,10,0,0)
    search.BackgroundTransparency = 1; search.Text = ""
    search.PlaceholderText = "cari nama player..."
    search.PlaceholderColor3 = Color3.fromRGB(100,100,115); search.TextColor3 = Color3.fromRGB(240,240,245)
    search.Font = Enum.Font.Gotham; search.TextSize = 13
    search.TextXAlignment = Enum.TextXAlignment.Left; search.ClearTextOnFocus = false; search.Parent = sbg

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1,-24,1,-100); list.Position = UDim2.new(0,12,0,90)
    list.BackgroundTransparency = 1; list.BorderSizePixel = 0
    list.ScrollBarThickness = 3; list.ScrollBarImageColor3 = Color3.fromRGB(0,200,255)
    list.CanvasSize = UDim2.new(0,0,0,0); list.AutomaticCanvasSize = Enum.AutomaticSize.Y
    list.Parent = main
    local ll = Instance.new("UIListLayout"); ll.Padding = UDim.new(0,4); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Parent = list

    local function refresh(filter)
        for _, c in ipairs(list:GetChildren()) do
            if c:IsA("TextButton") or (c:IsA("TextLabel") and c.Name == "emptyLabel") then c:Destroy() end
        end
        filter = (filter or ""):lower()
        local n = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local un = p.Name:lower()
                local dn = p.DisplayName:lower()
                if filter == "" or un:sub(1,#filter) == filter or dn:sub(1,#filter) == filter or un:find(filter,1,true) then
                    n = n + 1
                    local item = Instance.new("TextButton")
                    item.Size = UDim2.new(1,0,0,36); item.BackgroundColor3 = Color3.fromRGB(22,22,30)
                    item.Text = ""; item.AutoButtonColor = false; item.LayoutOrder = n; item.Parent = list
                    local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0,6); ic.Parent = item
                    local is_ = Instance.new("UIStroke"); is_.Color = Color3.fromRGB(40,40,55); is_.Thickness = 1; is_.Parent = item
                    local nL = Instance.new("TextLabel")
                    nL.Size = UDim2.new(0.6,0,1,0); nL.Position = UDim2.new(0,12,0,0)
                    nL.BackgroundTransparency = 1; nL.Text = p.Name
                    nL.TextColor3 = Color3.fromRGB(240,240,245); nL.Font = Enum.Font.Gotham
                    nL.TextSize = 12; nL.TextXAlignment = Enum.TextXAlignment.Left; nL.Parent = item
                    local dL = Instance.new("TextLabel")
                    dL.Size = UDim2.new(0.4,-12,1,0); dL.Position = UDim2.new(0.6,0,0,0)
                    dL.BackgroundTransparency = 1; dL.Text = p.DisplayName
                    dL.TextColor3 = Color3.fromRGB(150,150,165); dL.Font = Enum.Font.Gotham
                    dL.TextSize = 10; dL.TextXAlignment = Enum.TextXAlignment.Right; dL.Parent = item
                    item.MouseEnter:Connect(function()
                        TweenService:Create(item, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30,30,45)}):Play()
                        TweenService:Create(is_, TweenInfo.new(0.1), {Color = Color3.fromRGB(0,200,255)}):Play()
                    end)
                    item.MouseLeave:Connect(function()
                        TweenService:Create(item, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(22,22,30)}):Play()
                        TweenService:Create(is_, TweenInfo.new(0.1), {Color = Color3.fromRGB(40,40,55)}):Play()
                    end)
                    item.MouseButton1Click:Connect(function()
                        g:Destroy()
                        pcall(onSelect, p)
                    end)
                end
            end
        end
        if n == 0 then
            local e = Instance.new("TextLabel")
            e.Name = "emptyLabel"
            e.Size = UDim2.new(1,0,0,30); e.BackgroundTransparency = 1
            e.Text = "Tidak ada player."; e.TextColor3 = Color3.fromRGB(100,100,115)
            e.Font = Enum.Font.Gotham; e.TextSize = 11; e.LayoutOrder = 999; e.Parent = list
        end
    end

    refresh("")
    search:GetPropertyChangedSignal("Text"):Connect(function() refresh(search.Text) end)
end

-- ========== TP TO PLAYER ==========
local function tpToPlayerObj(player)
    if not player or not player.Character then return false end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not LocalPlayer.Character then return false end
    LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
    return true
end

-- ========== SYNC EMOTE (NO DELAY) ==========
local syncTarget = nil
local syncConn = nil
local currentSyncTrack = nil

local function stopSyncEmote()
    if syncConn then syncConn:Disconnect(); syncConn = nil end
    if currentSyncTrack then
        pcall(function() currentSyncTrack:Stop(0); currentSyncTrack:Destroy() end)
        currentSyncTrack = nil
    end
    local c = LocalPlayer.Character
    if c then
        local animate = c:FindFirstChild("Animate")
        if animate then animate.Disabled = false end
    end
    syncTarget = nil
    state.syncEmoteActive = false
end

local function startSyncEmote(player)
    stopSyncEmote()
    if not player or not player.Character then
        notify("Sync", "Player tidak valid.")
        return
    end

    local myChar = LocalPlayer.Character
    if not myChar then return end
    local myHum = myChar:FindFirstChildOfClass("Humanoid")
    local myAnim = myHum and myHum:FindFirstChildOfClass("Animator")
    local tgtHum = player.Character:FindFirstChildOfClass("Humanoid")
    local tgtAnim = tgtHum and tgtHum:FindFirstChildOfClass("Animator")
    if not myAnim or not tgtAnim then
        notify("Sync", "Animator tidak ditemukan.")
        return
    end

    local animate = myChar:FindFirstChild("Animate")
    if animate then animate.Disabled = true end

    for _, t in ipairs(myAnim:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end

    local function applyTrack(track)
        if not track or not track.Animation then return end
        local animId = track.Animation.AnimationId
        if animId == "" then return end

        if currentSyncTrack then
            pcall(function() currentSyncTrack:Stop(0); currentSyncTrack:Destroy() end)
            currentSyncTrack = nil
        end

        local animObj = Instance.new("Animation")
        animObj.AnimationId = animId

        currentSyncTrack = myAnim:LoadAnimation(animObj)
        currentSyncTrack.Priority = Enum.AnimationPriority.Action4
        currentSyncTrack.Looped = true
        currentSyncTrack:Play(0, 1, track.Speed)
        currentSyncTrack.TimePosition = track.TimePosition
    end

    for _, track in ipairs(tgtAnim:GetPlayingAnimationTracks()) do
        if track.Animation and track.Animation.AnimationId ~= "" then
            applyTrack(track)
            break
        end
    end

    syncConn = tgtAnim.AnimationPlayed:Connect(function(newTrack)
        applyTrack(newTrack)
    end)

    syncTarget = player
    state.syncEmoteActive = true
    notify("Sync", "Sync dengan " .. player.Name)
end
-- ========== SHIFT LOCK (REAL) ==========
local shiftLockConn = nil
local shiftLockGui = nil
local shiftLockActive = false

local function enableShiftLock()
    if shiftLockConn then return end
    shiftLockActive = true
    shiftLockConn = RunService.RenderStepped:Connect(function()
        if not shiftLockActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        hum.CameraOffset = Vector3.new(1.75, 0.5, 0)
        hum.AutoRotate = false
        local cam = workspace.CurrentCamera
        local look = cam.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0.01 then
            flatLook = flatLook.Unit
            local pos = hrp.Position
            hrp.CFrame = CFrame.new(pos, pos + flatLook)
        end
        pcall(function()
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end)
    end)
end

local function disableShiftLock()
    shiftLockActive = false
    if shiftLockConn then shiftLockConn:Disconnect(); shiftLockConn = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.CameraOffset = Vector3.zero
            hum.AutoRotate = true
        end
    end
    pcall(function()
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end)
end

local function createShiftLockIcon()
    if shiftLockGui then shiftLockGui:Destroy() end
    shiftLockGui = Instance.new("ScreenGui")
    shiftLockGui.Name = "c1rooShiftLock"
    shiftLockGui.ResetOnSpawn = false
    pcall(function() shiftLockGui.Parent = CoreGui end)
    if not shiftLockGui.Parent then shiftLockGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    local btn = Instance.new("TextButton")
    btn.Name = "ShiftLockBtn"
    btn.Size = UDim2.new(0, 52, 0, 52)
    btn.Position = UDim2.new(1, -72, 1, -72)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    btn.Text = "🔓"
    btn.TextColor3 = Color3.fromRGB(150, 150, 165)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 24
    btn.AutoButtonColor = false
    btn.Parent = shiftLockGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 75)
    stroke.Thickness = 2
    stroke.Parent = btn

    btn.MouseEnter:Connect(function()
        if not shiftLockActive then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 48)}):Play()
        end
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
            notify("Shift Lock", "Aktif. Avatar ngikutin kamera.")
        end
    end)
end

-- ========== MOBILE D-PAD + JUMP (Minecraft Style) ==========
local dpadGui = nil
local dpadActive = false
local dpadDirX, dpadDirZ = 0, 0
local dpadJumpHeld = false
local dpadLoopConn = nil

local function createDpad()
    if dpadGui then dpadGui:Destroy() end
    dpadDirX, dpadDirZ = 0, 0
    dpadJumpHeld = false

    dpadGui = Instance.new("ScreenGui")
    dpadGui.Name = "c1rooDpad"
    dpadGui.ResetOnSpawn = false
    dpadGui.IgnoreGuiInset = true
    pcall(function() dpadGui.Parent = CoreGui end)
    if not dpadGui.Parent then dpadGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    -- ===== D-PAD (kiri bawah) =====
    local size = 150
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, size, 0, size)
    container.Position = UDim2.new(0, 20, 1, -size - 30)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    container.BackgroundTransparency = 0.5
    container.BorderSizePixel = 0
    container.Parent = dpadGui
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(1, 0)
    cc.Parent = container
    local cs = Instance.new("UIStroke")
    cs.Color = Color3.fromRGB(0, 200, 255)
    cs.Thickness = 1
    cs.Transparency = 0.5
    cs.Parent = container

    local btnSize = 44
    local function makeBtn(name, pos, arrow)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(0, btnSize, 0, btnSize)
        btn.Position = pos
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        btn.BackgroundTransparency = 0.15
        btn.Text = arrow
        btn.TextColor3 = Color3.fromRGB(200, 200, 215)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 22
        btn.AutoButtonColor = false
        btn.Parent = container
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = btn
        return btn
    end

    local btnUp    = makeBtn("Up",    UDim2.new(0.5, -btnSize/2, 0, 6), "▲")
    local btnDown  = makeBtn("Down",  UDim2.new(0.5, -btnSize/2, 1, -btnSize-6), "▼")
    local btnLeft  = makeBtn("Left",  UDim2.new(0, 6, 0.5, -btnSize/2), "◀")
    local btnRight = makeBtn("Right", UDim2.new(1, -btnSize-6, 0.5, -btnSize/2), "▶")

    local center = Instance.new("Frame")
    center.Size = UDim2.new(0, 20, 0, 20)
    center.Position = UDim2.new(0.5, -10, 0.5, -10)
    center.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    center.BackgroundTransparency = 0.5
    center.BorderSizePixel = 0
    center.Parent = container
    local ccc = Instance.new("UICorner")
    ccc.CornerRadius = UDim.new(1, 0)
    ccc.Parent = center

    local function highlight(btn, on)
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = on and Color3.fromRGB(0, 120, 160) or Color3.fromRGB(30, 30, 45)
        }):Play()
    end

    local function bind(btn, axis, val)
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if axis == "X" then dpadDirX = val else dpadDirZ = val end
                highlight(btn, true)
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if axis == "X" then dpadDirX = 0 else dpadDirZ = 0 end
                highlight(btn, false)
            end
        end)
        btn.MouseLeave:Connect(function()
            if axis == "X" then dpadDirX = 0 else dpadDirZ = 0 end
            highlight(btn, false)
        end)
    end

    bind(btnUp, "Z", 1)
    bind(btnDown, "Z", -1)
    bind(btnLeft, "X", -1)
    bind(btnRight, "X", 1)

    -- ===== TOMBOL LONCAT (kanan bawah) =====
    local jumpBtn = Instance.new("TextButton")
    jumpBtn.Name = "JumpButton"
    jumpBtn.Size = UDim2.new(0, 72, 0, 72)
    jumpBtn.Position = UDim2.new(1, -92, 1, -102)
    jumpBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    jumpBtn.BackgroundTransparency = 0.1
    jumpBtn.Text = "⬆"
    jumpBtn.TextColor3 = Color3.fromRGB(200, 200, 215)
    jumpBtn.Font = Enum.Font.GothamBold
    jumpBtn.TextSize = 32
    jumpBtn.AutoButtonColor = false
    jumpBtn.Parent = dpadGui
    local jc = Instance.new("UICorner")
    jc.CornerRadius = UDim.new(1, 0)
    jc.Parent = jumpBtn
    local js = Instance.new("UIStroke")
    js.Color = Color3.fromRGB(0, 200, 255)
    js.Thickness = 2
    js.Transparency = 0.3
    js.Parent = jumpBtn

    jumpBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dpadJumpHeld = true
            TweenService:Create(jumpBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 120, 160)}):Play()
        end
    end)
    jumpBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dpadJumpHeld = false
            TweenService:Create(jumpBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}):Play()
        end
    end)
    jumpBtn.MouseLeave:Connect(function()
        dpadJumpHeld = false
        TweenService:Create(jumpBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}):Play()
    end)

    -- ===== LOOP =====
    if dpadLoopConn then dpadLoopConn:Disconnect() end
    dpadLoopConn = RunService.RenderStepped:Connect(function()
        if not dpadActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local cam = workspace.CurrentCamera

        local fwd = cam.CFrame.LookVector
        local right = cam.CFrame.RightVector
        local flatFwd = Vector3.new(fwd.X, 0, fwd.Z)
        local flatRight = Vector3.new(right.X, 0, right.Z)
        if flatFwd.Magnitude > 0.01 then flatFwd = flatFwd.Unit end
        if flatRight.Magnitude > 0.01 then flatRight = flatRight.Unit end

        local moveDir = (flatFwd * dpadDirZ) + (flatRight * dpadDirX)
        if moveDir.Magnitude > 0 then
            hum:Move(moveDir.Unit, false)
        else
            hum:Move(Vector3.zero, false)
        end

        if dpadJumpHeld and hum.FloorMaterial ~= Enum.Material.Air then
            hum.Jump = true
        end
    end)
end

local function destroyDpad()
    dpadActive = false
    dpadDirX, dpadDirZ = 0, 0
    dpadJumpHeld = false
    if dpadLoopConn then dpadLoopConn:Disconnect(); dpadLoopConn = nil end
    if dpadGui then dpadGui:Destroy(); dpadGui = nil end
end

local function setDefaultControlsVisible(on)
    pcall(function()
        local plrGui = LocalPlayer:WaitForChild("PlayerGui", 5)
        if not plrGui then return end
        local touchGui = plrGui:FindFirstChild("TouchGui")
        if touchGui then
            local controlFrame = touchGui:FindFirstChild("TouchControlFrame")
            if controlFrame then
                controlFrame.Visible = on
            end
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
    updateTrackerHUD()
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
    if dpadActive then
        task.wait(0.3)
        createDpad()
        setDefaultControlsVisible(false)
    end
end)

-- ========== BUILD UI ==========
local UI = c1rooUI
local window = UI:CreateWindow({ Title = "c1roo_Universal", W = 620, H = 430 })

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

secMain:AddToggle({ Name = "Auto Respawn", Default = false, Callback = function(v)
    state.autoRespawn = v
    if v then enableAutoRespawn() else disableAutoRespawn() end
    notify("Auto Respawn", v and "Aktif." or "Dimatikan.")
end})

secMain:AddToggle({ Name = "Auto Heal (50%)", Default = false, Callback = function(v)
    state.autoHeal = v
    if v then enableAutoHeal() else disableAutoHeal() end
    notify("Auto Heal", v and "Aktif." or "Dimatikan.")
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

local secClick = tabCombat:AddSection({ Name = "Auto Clicker & Bhop" })
secClick:AddToggle({ Name = "Auto Clicker", Default = false, Callback = function(v)
    state.autoClicker = v
    if v then enableAutoClicker() else disableAutoClicker() end
    notify("Auto Clicker", v and "Aktif." or "Dimatikan.")
end})
secClick:AddSlider({ Name = "CPS", Min = 1, Max = 50, Default = 10, Callback = function(v)
    state.autoClickerCPS = v
end})
secClick:AddToggle({ Name = "Bunny Hop", Default = false, Callback = function(v)
    state.bunnyHop = v
    if v then enableBunnyHop() else disableBunnyHop() end
    notify("Bunny Hop", v and "Aktif." or "Dimatikan.")
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

local secDpad = tabVisual:AddSection({ Name = "Mobile D-Pad + Jump" })
secDpad:AddToggle({ Name = "Enable D-Pad (Minecraft)", Default = false, Callback = function(v)
    state.dpadEnabled = v
    dpadActive = v
    if v then
        createDpad()
        setDefaultControlsVisible(false)
        notify("D-Pad", "Aktif. Joystick default disembunyikan.")
    else
        destroyDpad()
        setDefaultControlsVisible(true)
        notify("D-Pad", "Dimatikan.")
    end
end})

-- ===== SYNC EMOTE =====
local tabSync = window:AddTab({ Name = "Sync" })
local secSync = tabSync:AddSection({ Name = "Sync Emote" })

secSync:AddButton({ Name = "Pilih Player (Search)", Callback = function()
    openPlayerPicker("Sync Emote", function(p)
        startSyncEmote(p)
    end)
end})

secSync:AddButton({ Name = "Stop Sync", Callback = function()
    stopSyncEmote()
    notify("Sync", "Sync dihentikan.")
end})

Players.PlayerRemoving:Connect(function(p)
    if syncTarget == p then
        stopSyncEmote()
        notify("Sync", "Target keluar. Sync dihentikan.")
    end
end)

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
secMiscP:AddButton({ Name = "Save Position", Callback = function()
    if savePosition() then notify("Position", "Posisi disimpan.") else notify("Position", "Gagal save.") end
end})
secMiscP:AddButton({ Name = "Load Position", Callback = function()
    if loadPosition() then notify("Position", "Ke posisi tersimpan.") else notify("Position", "Belum ada posisi.") end
end})
secMiscP:AddButton({ Name = "Get All Tools", Callback = function()
    local n = getAllTools()
    notify("Tools", n .. " tool diambil.")
end})
secMiscP:AddButton({ Name = "Reset Character", Callback = function()
    local c = LocalPlayer.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    end
end})

-- ===== TP =====
local tabTP = window:AddTab({ Name = "TP" })

local secTPPlayer = tabTP:AddSection({ Name = "Teleport to Player" })
secTPPlayer:AddButton({ Name = "Pilih Player (Search)", Callback = function()
    openPlayerPicker("Teleport", function(p)
        if tpToPlayerObj(p) then
            notify("TP", "Ke " .. p.Name)
        else
            notify("TP", "Gagal TP ke " .. p.Name)
        end
    end)
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

local secHUD = tabMisc:AddSection({ Name = "Player Tracker HUD" })
secHUD:AddToggle({ Name = "Show Tracker HUD", Default = false, Callback = function(v)
    state.trackerHUD = v
    if v then
        if not trackerFrame then createTrackerHUD() end
        if trackerFrame then trackerFrame.Visible = true end
    else
        if trackerFrame then trackerFrame.Visible = false end
    end
    notify("Tracker HUD", v and "Aktif." or "Dimatikan.")
end})

-- ========== WELCOME ==========
task.wait(0.5)
notify("c1roo_Universal", "Script berhasil dimuat!")
task.wait(1)
notify("Info", "Klik — untuk minimize.")

print("[c1roo_Universal] Loaded successfully!")