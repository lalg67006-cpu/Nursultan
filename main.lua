-- Roblox Luau Script: Complete Integrated GUI + HUD Watermark
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Custom Logo Asset ID
local CUSTOM_LOGO_ID = "rbxassetid://139568612294283"

-- Clean previous instances
if CoreGui:FindFirstChild("PastaCompleteUI") then
    CoreGui.PastaCompleteUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PastaCompleteUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local targetParent = (gethui and gethui()) or (run_secure and CoreGui) or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Parent = targetParent

-- Unified Theme Tokens
local THEME = {
    Background    = Color3.fromRGB(12, 9, 11),
    CardBg        = Color3.fromRGB(18, 13, 16),
    PillBg        = Color3.fromRGB(16, 12, 14),
    SidebarActive = Color3.fromRGB(27, 16, 19),
    Border        = Color3.fromRGB(36, 24, 28),
    BorderActive  = Color3.fromRGB(90, 36, 42),
    Accent        = Color3.fromRGB(246, 92, 82),
    AccentSoft    = Color3.fromRGB(255, 165, 155),
    AccentDark    = Color3.fromRGB(130, 40, 42),
    TextPrimary   = Color3.fromRGB(235, 235, 235),
    TextMuted     = Color3.fromRGB(120, 110, 115),
    TextDim       = Color3.fromRGB(72, 64, 68),
    Divider       = Color3.fromRGB(48, 36, 40),
    BadgeBg       = Color3.fromRGB(25, 18, 22),
    ToggleOff     = Color3.fromRGB(36, 28, 32),
    KnobOff       = Color3.fromRGB(78, 68, 73),
    KnobOn        = Color3.fromRGB(255, 255, 255)
}

-- Monochrome Vector Assets
local ICONS = {
    Search   = "rbxassetid://7733911828",
    Chevron  = "rbxassetid://7733717447",
    More     = "rbxassetid://7734021300",
    Menu     = "rbxassetid://7733993211",
    Combat   = "rbxassetid://7734053426",
    Movement = "rbxassetid://7733799901",
    Visuals  = "rbxassetid://7733774602",
    Player   = "rbxassetid://7733954760",
    Misc     = "rbxassetid://7734056411",
    Presets  = "rbxassetid://7733964719",
    AutoBuy  = "rbxassetid://7733942651",
    Accounts = "rbxassetid://7733765307",
    User     = "rbxassetid://7733954760",
    Chart    = "rbxassetid://7733749837",
    Clock    = "rbxassetid://7733734762",
    Compass  = "rbxassetid://7733720755",
    Signal   = "rbxassetid://7734058495",
    Radar    = "rbxassetid://7734053426",
    Speed    = "rbxassetid://7733799901"
}

local TWEEN_FAST = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SLOW = TweenInfo.new(0.35, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

-- =============================================================================
-- 1. HUD WATERMARK (Top-Left under Core UI)
-- =============================================================================
local HudContainer = Instance.new("Frame")
HudContainer.Name = "HudContainer"
HudContainer.Size = UDim2.new(0, 600, 0, 50)
HudContainer.Position = UDim2.new(0, 16, 0, 48)
HudContainer.BackgroundTransparency = 1
HudContainer.Parent = ScreenGui

local HudVerticalLayout = Instance.new("UIListLayout")
HudVerticalLayout.SortOrder = Enum.SortOrder.LayoutOrder
HudVerticalLayout.Padding = UDim.new(0, 4)
HudVerticalLayout.Parent = HudContainer

local function createHudRow(name, height, order)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(1, 0, 0, height)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = HudContainer

    local hLayout = Instance.new("UIListLayout")
    hLayout.FillDirection = Enum.FillDirection.Horizontal
    hLayout.SortOrder = Enum.SortOrder.LayoutOrder
    hLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    hLayout.Padding = UDim.new(0, 5)
    hLayout.Parent = row

    return row
end

local TopHudRow = createHudRow("TopRow", 22, 1)
local BottomHudRow = createHudRow("BottomRow", 22, 2)

local function createHudPill(parent, order)
    local pill = Instance.new("Frame")
    pill.AutomaticSize = Enum.AutomaticSize.X
    pill.Size = UDim2.new(0, 0, 1, 0)
    pill.BackgroundColor3 = THEME.PillBg
    pill.BorderSizePixel = 0
    pill.LayoutOrder = order
    pill.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = pill

    local stroke = Instance.new("UIStroke")
    stroke.Color = THEME.Border
    stroke.Thickness = 1
    stroke.Parent = pill

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 6)
    pad.PaddingRight = UDim.new(0, 6)
    pad.Parent = pill

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 5)
    layout.Parent = pill

    return pill
end

local function addHudDivider(parent, order)
    local div = Instance.new("Frame")
    div.Size = UDim2.new(0, 1, 0, 10)
    div.BackgroundColor3 = THEME.Divider
    div.BorderSizePixel = 0
    div.LayoutOrder = order
    div.Parent = parent
end

local function addHudText(parent, text, isMuted, order)
    local lbl = Instance.new("TextLabel")
    lbl.AutomaticSize = Enum.AutomaticSize.X
    lbl.Size = UDim2.new(0, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10.5
    lbl.TextColor3 = isMuted and THEME.TextMuted or THEME.TextPrimary
    lbl.LayoutOrder = order
    lbl.Parent = parent
    return lbl
end

local function addHudSmallIcon(parent, iconId, order)
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 11, 0, 11)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ScaleType = Enum.ScaleType.Fit
    icon.ImageColor3 = THEME.Accent
    icon.LayoutOrder = order
    icon.Parent = parent
    return icon
end

-- Top Row Assemble
local BrandPill = createHudPill(TopHudRow, 1)

local HudLogoWrap = Instance.new("Frame")
HudLogoWrap.Size = UDim2.new(0, 20, 0, 20)
HudLogoWrap.BackgroundTransparency = 1
HudLogoWrap.LayoutOrder = 1
HudLogoWrap.Parent = BrandPill

local HudLogoGlow = Instance.new("ImageLabel")
HudLogoGlow.Size = UDim2.new(2, 0, 2, 0)
HudLogoGlow.Position = UDim2.new(-0.5, 0, -0.5, 0)
HudLogoGlow.BackgroundTransparency = 1
HudLogoGlow.Image = "rbxassetid://5028857084"
HudLogoGlow.ImageColor3 = THEME.Accent
HudLogoGlow.ImageTransparency = 0.65
HudLogoGlow.ZIndex = 1
HudLogoGlow.Parent = HudLogoWrap

local HudBrandLogo = Instance.new("ImageLabel")
HudBrandLogo.Size = UDim2.new(1.35, 0, 1.35, 0)
HudBrandLogo.Position = UDim2.new(-0.175, 0, -0.175, 0)
HudBrandLogo.BackgroundTransparency = 1
HudBrandLogo.Image = CUSTOM_LOGO_ID
HudBrandLogo.ScaleType = Enum.ScaleType.Fit
HudBrandLogo.ImageColor3 = Color3.fromRGB(255, 255, 255)
HudBrandLogo.ZIndex = 2
HudBrandLogo.Parent = HudLogoWrap

local HudLogoGrad = Instance.new("UIGradient")
HudLogoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, THEME.AccentSoft),
    ColorSequenceKeypoint.new(0.45, THEME.Accent),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(165, 32, 42))
})
HudLogoGrad.Rotation = -35
HudLogoGrad.Parent = HudBrandLogo

addHudDivider(BrandPill, 2)
local HudBrandText = addHudText(BrandPill, "pasta", false, 3)

local HudBrandGrad = Instance.new("UIGradient")
HudBrandGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, THEME.AccentSoft),
    ColorSequenceKeypoint.new(1.0, THEME.Accent)
})
HudBrandGrad.Parent = HudBrandText

local StatsPill = createHudPill(TopHudRow, 2)
addHudSmallIcon(StatsPill, ICONS.User, 1)
addHudText(StatsPill, string.lower(LocalPlayer.Name), false, 2)
addHudDivider(StatsPill, 3)

addHudSmallIcon(StatsPill, ICONS.Chart, 4)
local FpsLabel = addHudText(StatsPill, "0 Fps", false, 5)
addHudDivider(StatsPill, 6)

addHudSmallIcon(StatsPill, ICONS.Clock, 7)
local TimeLabel = addHudText(StatsPill, "00:00:00", false, 8)

-- Bottom Row Assemble
local PosPill = createHudPill(BottomHudRow, 1)
addHudSmallIcon(PosPill, ICONS.Compass, 1)
addHudDivider(PosPill, 2)
local PosLabel = addHudText(PosPill, "0, 0, 0", false, 3)

local PingPill = createHudPill(BottomHudRow, 2)
addHudSmallIcon(PingPill, ICONS.Signal, 1)
addHudDivider(PingPill, 2)
local PingLabel = addHudText(PingPill, "0 Ping", false, 3)

local TickPill = createHudPill(BottomHudRow, 3)
addHudSmallIcon(TickPill, ICONS.Radar, 1)
addHudDivider(TickPill, 2)
local TickLabel = addHudText(TickPill, "20.0 Ticks", false, 3)

local SpeedPill = createHudPill(BottomHudRow, 4)
addHudSmallIcon(SpeedPill, ICONS.Speed, 1)
addHudDivider(SpeedPill, 2)
local SpeedLabel = addHudText(SpeedPill, "0.0 Bps", false, 3)

-- Live Runtime Updates
local fpsCounter, lastFpsCheck = 0, os.clock()
local lastPosition = Vector3.zero
local lastPosTime = os.clock()

RunService.RenderStepped:Connect(function()
    fpsCounter = fpsCounter + 1
    local now = os.clock()

    if now - lastFpsCheck >= 1 then
        FpsLabel.Text = string.format("%d Fps", fpsCounter)
        fpsCounter = 0
        lastFpsCheck = now
    end

    TimeLabel.Text = os.date("%H:%M:%S")

    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    PingLabel.Text = string.format("%d Ping", ping)

    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local hrp = character.HumanoidRootPart
        local currentPos = hrp.Position
        PosLabel.Text = string.format("%d, %d, %d", math.floor(currentPos.X), math.floor(currentPos.Y), math.floor(currentPos.Z))

        local deltaTime = now - lastPosTime
        if deltaTime >= 0.1 then
            local dist = (Vector3.new(currentPos.X, 0, currentPos.Z) - Vector3.new(lastPosition.X, 0, lastPosition.Z)).Magnitude
            local bps = dist / deltaTime
            SpeedLabel.Text = string.format("%.1f Bps", bps)

            lastPosition = currentPos
            lastPosTime = now
        end
    else
        PosLabel.Text = "0, 0, 0"
        SpeedLabel.Text = "0.0 Bps"
    end
end)

-- =============================================================================
-- 2. MAIN GUI (790x490 Window)
-- =============================================================================
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 790, 0, 490)
Main.Position = UDim2.new(0.5, -395, 0.5, -245)
Main.BackgroundColor3 = THEME.Background
Main.BorderSizePixel = 0
Main.ClipsDescendants = false
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = THEME.Border
MainStroke.Thickness = 1.2
MainStroke.Parent = Main

-- Red Ambient Backlight Glow
local GlowBackdrop = Instance.new("ImageLabel")
GlowBackdrop.Name = "GlowBackdrop"
GlowBackdrop.BackgroundTransparency = 1
GlowBackdrop.Position = UDim2.new(0, -45, 0, -45)
GlowBackdrop.Size = UDim2.new(1, 90, 1, 90)
GlowBackdrop.ZIndex = 0
GlowBackdrop.Image = "rbxassetid://5028857084"
GlowBackdrop.ImageColor3 = THEME.AccentDark
GlowBackdrop.ImageTransparency = 0.83
GlowBackdrop.ScaleType = Enum.ScaleType.Slice
GlowBackdrop.SliceCenter = Rect.new(24, 24, 276, 276)
GlowBackdrop.Parent = Main

-- Dragging System
do
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(Main, TweenInfo.new(0.04), {
                Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            }):Play()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 56)
TopBar.BackgroundTransparency = 1
TopBar.Parent = Main

-- Clean 64x64 Logo
local MainLogoHolder = Instance.new("Frame")
MainLogoHolder.Name = "LogoHolder"
MainLogoHolder.Size = UDim2.new(0, 64, 0, 64)
MainLogoHolder.Position = UDim2.new(0, 52, 0, -4)
MainLogoHolder.BackgroundTransparency = 1
MainLogoHolder.Parent = TopBar

local MainLogoHalo = Instance.new("ImageLabel")
MainLogoHalo.Name = "Halo"
MainLogoHalo.Size = UDim2.new(2.1, 0, 2.1, 0)
MainLogoHalo.Position = UDim2.new(-0.55, 0, -0.55, 0)
MainLogoHalo.BackgroundTransparency = 1
MainLogoHalo.Image = "rbxassetid://5028857084"
MainLogoHalo.ImageColor3 = THEME.Accent
MainLogoHalo.ImageTransparency = 0.58
MainLogoHalo.ZIndex = 1
MainLogoHalo.Parent = MainLogoHolder

local MainLogoShadow = Instance.new("ImageLabel")
MainLogoShadow.Name = "LogoShadow"
MainLogoShadow.Size = UDim2.new(1, 0, 1, 0)
MainLogoShadow.Position = UDim2.new(0, 2, 0, 2)
MainLogoShadow.BackgroundTransparency = 1
MainLogoShadow.Image = CUSTOM_LOGO_ID
MainLogoShadow.ScaleType = Enum.ScaleType.Fit
MainLogoShadow.ImageColor3 = Color3.fromRGB(50, 10, 14)
MainLogoShadow.ImageTransparency = 0.2
MainLogoShadow.ZIndex = 2
MainLogoShadow.Parent = MainLogoHolder

local MainLogoImg = Instance.new("ImageLabel")
MainLogoImg.Name = "LogoMain"
MainLogoImg.Size = UDim2.new(1, 0, 1, 0)
MainLogoImg.Position = UDim2.new(0, 0, 0, 0)
MainLogoImg.BackgroundTransparency = 1
MainLogoImg.Image = CUSTOM_LOGO_ID
MainLogoImg.ScaleType = Enum.ScaleType.Fit
MainLogoImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
MainLogoImg.ZIndex = 3
MainLogoImg.Parent = MainLogoHolder

local MainLogoGrad = Instance.new("UIGradient")
MainLogoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 175, 165)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(246, 92, 82)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(165, 32, 42))
})
MainLogoGrad.Rotation = -35
MainLogoGrad.Parent = MainLogoImg

-- Search Bar
local SearchBox = Instance.new("Frame")
SearchBox.Size = UDim2.new(0, 250, 0, 26)
SearchBox.Position = UDim2.new(0, 185, 0, 15)
SearchBox.BackgroundColor3 = THEME.CardBg
SearchBox.BorderSizePixel = 0
SearchBox.Parent = TopBar

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBox

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Color = THEME.Border
SearchStroke.Thickness = 0.8
SearchStroke.Parent = SearchBox

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.Size = UDim2.new(0, 13, 0, 13)
SearchIcon.Position = UDim2.new(0, 9, 0.5, -6.5)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = ICONS.Search
SearchIcon.ImageColor3 = THEME.TextMuted
SearchIcon.Parent = SearchBox

local SearchInput = Instance.new("TextBox")
SearchInput.PlaceholderText = "Search something"
SearchInput.PlaceholderColor3 = THEME.TextMuted
SearchInput.TextColor3 = THEME.TextPrimary
SearchInput.Font = Enum.Font.Gotham
SearchInput.TextSize = 11
SearchInput.Position = UDim2.new(0, 30, 0, 0)
SearchInput.Size = UDim2.new(1, -36, 1, 0)
SearchInput.BackgroundTransparency = 1
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.Parent = SearchBox

-- Top Right Menu Button
local MenuBtn = Instance.new("ImageButton")
MenuBtn.Size = UDim2.new(0, 17, 0, 17)
MenuBtn.Position = UDim2.new(1, -32, 0.5, -8.5)
MenuBtn.BackgroundTransparency = 1
MenuBtn.Image = ICONS.Menu
MenuBtn.ImageColor3 = THEME.TextMuted
MenuBtn.Parent = TopBar

MenuBtn.MouseEnter:Connect(function()
    TweenService:Create(MenuBtn, TWEEN_FAST, {ImageColor3 = THEME.TextPrimary}):Play()
end)
MenuBtn.MouseLeave:Connect(function()
    TweenService:Create(MenuBtn, TWEEN_FAST, {ImageColor3 = THEME.TextMuted}):Play()
end)

-- Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 155, 1, -58)
Sidebar.Position = UDim2.new(0, 14, 0, 54)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = Main

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 2)
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.Parent = Sidebar

local activeSidebarTab = nil

local function addCategory(name, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.LayoutOrder = order
    lbl.BackgroundTransparency = 1
    lbl.Text = "   " .. name:upper()
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 9
    lbl.TextColor3 = THEME.TextDim
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = Sidebar
end

local function addSidebarItem(name, iconId, isDefaultActive, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -4, 0, 29)
    btn.LayoutOrder = order
    btn.BackgroundColor3 = isDefaultActive and THEME.SidebarActive or THEME.Background
    btn.BackgroundTransparency = isDefaultActive and 0 or 1
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = Sidebar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = isDefaultActive and THEME.BorderActive or Color3.fromRGB(0, 0, 0)
    stroke.Transparency = isDefaultActive and 0 or 1
    stroke.Thickness = 1
    stroke.Parent = btn

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 14, 0, 14)
    icon.Position = UDim2.new(0, 9, 0.5, -7)
    icon.BackgroundTransparency = 1
    icon.Image = iconId
    icon.ImageColor3 = isDefaultActive and THEME.Accent or THEME.TextMuted
    icon.Parent = btn

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -32, 1, 0)
    title.Position = UDim2.new(0, 30, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = name
    title.Font = Enum.Font.GothamMedium
    title.TextSize = 11
    title.TextColor3 = isDefaultActive and THEME.TextPrimary or THEME.TextMuted
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = btn

    if isDefaultActive then
        activeSidebarTab = {Btn = btn, Icon = icon, Title = title, Stroke = stroke}
    end

    btn.MouseEnter:Connect(function()
        if activeSidebarTab.Btn ~= btn then
            TweenService:Create(title, TWEEN_FAST, {TextColor3 = THEME.TextPrimary}):Play()
            TweenService:Create(icon, TWEEN_FAST, {ImageColor3 = THEME.TextPrimary}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeSidebarTab.Btn ~= btn then
            TweenService:Create(title, TWEEN_FAST, {TextColor3 = THEME.TextMuted}):Play()
            TweenService:Create(icon, TWEEN_FAST, {ImageColor3 = THEME.TextMuted}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if activeSidebarTab.Btn == btn then return end

        TweenService:Create(activeSidebarTab.Btn, TWEEN_FAST, {BackgroundTransparency = 1}):Play()
        TweenService:Create(activeSidebarTab.Stroke, TWEEN_FAST, {Transparency = 1}):Play()
        TweenService:Create(activeSidebarTab.Icon, TWEEN_FAST, {ImageColor3 = THEME.TextMuted}):Play()
        TweenService:Create(activeSidebarTab.Title, TWEEN_FAST, {TextColor3 = THEME.TextMuted}):Play()

        TweenService:Create(btn, TWEEN_FAST, {BackgroundTransparency = 0, BackgroundColor3 = THEME.SidebarActive}):Play()
        TweenService:Create(stroke, TWEEN_FAST, {Transparency = 0, Color = THEME.BorderActive}):Play()
        TweenService:Create(icon, TWEEN_FAST, {ImageColor3 = THEME.Accent}):Play()
        TweenService:Create(title, TWEEN_FAST, {TextColor3 = THEME.TextPrimary}):Play()

        activeSidebarTab = {Btn = btn, Icon = icon, Title = title, Stroke = stroke}
    end)
end

addCategory("Features", 1)
addSidebarItem("Combat", ICONS.Combat, true, 2)
addSidebarItem("Movement", ICONS.Movement, false, 3)
addSidebarItem("Visuals", ICONS.Visuals, false, 4)
addSidebarItem("Player", ICONS.Player, false, 5)
addSidebarItem("Misc", ICONS.Misc, false, 6)

addCategory("Manager", 7)
addSidebarItem("Presets", ICONS.Presets, false, 8)
addSidebarItem("Auto Buy", ICONS.AutoBuy, false, 9)
addSidebarItem("Accounts", ICONS.Accounts, false, 10)

-- Bottom Watermark in Sidebar
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(0, 160, 0, 28)
Footer.Position = UDim2.new(0, 18, 1, -38)
Footer.BackgroundTransparency = 1
Footer.Parent = Main

local UserLabel = Instance.new("TextLabel")
UserLabel.Size = UDim2.new(1, 0, 0, 13)
UserLabel.BackgroundTransparency = 1
UserLabel.Text = string.lower(LocalPlayer.Name)
UserLabel.Font = Enum.Font.GothamBold
UserLabel.TextSize = 10
UserLabel.TextColor3 = THEME.TextMuted
UserLabel.TextXAlignment = Enum.TextXAlignment.Left
UserLabel.Parent = Footer

local SubLabel = Instance.new("TextLabel")
SubLabel.Size = UDim2.new(1, 0, 0, 11)
SubLabel.Position = UDim2.new(0, 0, 0, 13)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "pasta pastaland pashyu nurik kak ded"
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextSize = 7.5
SubLabel.TextColor3 = THEME.TextDim
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = Footer

-- Columns Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -195, 1, -62)
ContentArea.Position = UDim2.new(0, 182, 0, 54)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Main

local Col1 = Instance.new("ScrollingFrame")
Col1.Size = UDim2.new(0.485, 0, 1, 0)
Col1.BackgroundTransparency = 1
Col1.ScrollBarThickness = 0
Col1.Parent = ContentArea

local Col2 = Instance.new("ScrollingFrame")
Col2.Size = UDim2.new(0.485, 0, 1, 0)
Col2.Position = UDim2.new(0.515, 0, 0, 0)
Col2.BackgroundTransparency = 1
Col2.ScrollBarThickness = 0
Col2.Parent = ContentArea

for _, col in ipairs({Col1, Col2}) do
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 12)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = col
end

local function createCard(parent, titleText, order)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = THEME.CardBg
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = card

    local s = Instance.new("UIStroke")
    s.Color = THEME.Border
    s.Thickness = 0.8
    s.Parent = card

    local p = Instance.new("UIPadding")
    p.PaddingTop = UDim.new(0, 11)
    p.PaddingBottom = UDim.new(0, 13)
    p.PaddingLeft = UDim.new(0, 12)
    p.PaddingRight = UDim.new(0, 12)
    p.Parent = card

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 10)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = card

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 18)
    header.BackgroundTransparency = 1
    header.LayoutOrder = 0
    header.Parent = card

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextColor3 = THEME.TextPrimary
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 12, 0, 12)
    icon.Position = UDim2.new(1, -12, 0.5, -6)
    icon.BackgroundTransparency = 1
    icon.Image = ICONS.Chevron
    icon.ImageColor3 = THEME.Accent
    icon.Parent = header

    return card
end

-- Keybind Modal & Dropdown
local ActiveDropdown = nil
local KeybindListening = nil

local function openKeybindModal(targetBadge, featureName)
    if KeybindListening then KeybindListening:Disconnect() end

    targetBadge.Text = "..."
    targetBadge.TextColor3 = THEME.Accent

    KeybindListening = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local keyName = input.KeyCode.Name
            if keyName == "Escape" then
                targetBadge.Text = "-"
            else
                targetBadge.Text = keyName
            end
            targetBadge.TextColor3 = THEME.TextMuted
            KeybindListening:Disconnect()
            KeybindListening = nil
        end
    end)
end

local function toggleDropdown(parentRow, badgeLabel, featureName)
    if ActiveDropdown then
        ActiveDropdown:Destroy()
        ActiveDropdown = nil
        return
    end

    local drop = Instance.new("Frame")
    drop.Name = "Dropdown"
    drop.Size = UDim2.new(0, 115, 0, 58)
    drop.Position = UDim2.new(1, -120, 1, 3)
    drop.BackgroundColor3 = Color3.fromRGB(24, 18, 20)
    drop.ZIndex = 30
    drop.Parent = parentRow

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = drop

    local s = Instance.new("UIStroke")
    s.Color = THEME.Border
    s.Thickness = 1
    s.Parent = drop

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 1)
    list.Parent = drop

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 3)
    pad.PaddingBottom = UDim.new(0, 3)
    pad.PaddingLeft = UDim.new(0, 5)
    pad.PaddingRight = UDim.new(0, 5)
    pad.Parent = drop

    local function addOption(name, onClick)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 24)
        btn.BackgroundTransparency = 1
        btn.Text = " " .. name
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 10.5
        btn.TextColor3 = THEME.TextPrimary
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.ZIndex = 31
        btn.Parent = drop

        btn.MouseEnter:Connect(function() btn.TextColor3 = THEME.Accent end)
        btn.MouseLeave:Connect(function() btn.TextColor3 = THEME.TextPrimary end)
        btn.MouseButton1Click:Connect(function()
            drop:Destroy()
            ActiveDropdown = nil
            if onClick then onClick() end
        end)
    end

    addOption("Bind Key", function()
        openKeybindModal(badgeLabel, featureName)
    end)
    addOption("Reset Value", function()
        badgeLabel.Text = "-"
    end)

    ActiveDropdown = drop
end

-- Toggle Switch Component with Search Indexing
local registeredRows = {}

local function addToggle(card, name, description, defaultState, keybindDefault, callback)
    local row = Instance.new("Frame")
    row.Name = name
    row.Size = UDim2.new(1, 0, 0, description and 30 or 21)
    row.BackgroundTransparency = 1
    row.Parent = card

    table.insert(registeredRows, {Frame = row, Name = name:lower()})

    local textContainer = Instance.new("Frame")
    textContainer.Size = UDim2.new(1, -80, 1, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = row

    local rowTitle = Instance.new("TextLabel")
    rowTitle.Size = UDim2.new(1, 0, 0, 14)
    rowTitle.BackgroundTransparency = 1
    rowTitle.Text = name
    rowTitle.Font = Enum.Font.GothamMedium
    rowTitle.TextSize = 11
    rowTitle.TextColor3 = THEME.TextPrimary
    rowTitle.TextXAlignment = Enum.TextXAlignment.Left
    rowTitle.Parent = textContainer

    if description then
        local rowDesc = Instance.new("TextLabel")
        rowDesc.Size = UDim2.new(1, 0, 0, 12)
        rowDesc.Position = UDim2.new(0, 0, 0, 14)
        rowDesc.BackgroundTransparency = 1
        rowDesc.Text = description
        rowDesc.Font = Enum.Font.Gotham
        rowDesc.TextSize = 9
        rowDesc.TextColor3 = THEME.TextMuted
        rowDesc.TextXAlignment = Enum.TextXAlignment.Left
        rowDesc.Parent = textContainer
    end

    -- Keybind Badge
    local badge = Instance.new("TextLabel")
    badge.Size = UDim2.new(0, 18, 0, 14)
    badge.Position = UDim2.new(1, -76, 0.5, -7)
    badge.BackgroundColor3 = THEME.BadgeBg
    badge.Text = keybindDefault or ""
    badge.Visible = (keybindDefault ~= nil)
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 8.5
    badge.TextColor3 = THEME.TextMuted
    badge.Parent = row

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 3)
    bc.Parent = badge

    local bs = Instance.new("UIStroke")
    bs.Color = THEME.Border
    bs.Thickness = 0.8
    bs.Parent = badge

    -- Options (...) Button
    local optBtn = Instance.new("ImageButton")
    optBtn.Size = UDim2.new(0, 13, 0, 13)
    optBtn.Position = UDim2.new(1, -52, 0.5, -6.5)
    optBtn.BackgroundTransparency = 1
    optBtn.Image = ICONS.More
    optBtn.ImageColor3 = THEME.TextDim
    optBtn.Parent = row

    optBtn.MouseEnter:Connect(function()
        TweenService:Create(optBtn, TWEEN_FAST, {ImageColor3 = THEME.TextPrimary}):Play()
    end)
    optBtn.MouseLeave:Connect(function()
        TweenService:Create(optBtn, TWEEN_FAST, {ImageColor3 = THEME.TextDim}):Play()
    end)
    optBtn.MouseButton1Click:Connect(function()
        badge.Visible = true
        toggleDropdown(row, badge, name)
    end)

    -- Switch Track
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 32, 0, 16)
    switch.Position = UDim2.new(1, -32, 0.5, -8)
    switch.BackgroundColor3 = defaultState and THEME.Accent or THEME.ToggleOff
    switch.Text = ""
    switch.AutoButtonColor = false
    switch.Parent = row

    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(1, 0)
    sCorner.Parent = switch

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = defaultState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = defaultState and THEME.KnobOn or THEME.KnobOff
    knob.BorderSizePixel = 0
    knob.Parent = switch

    local kCorner = Instance.new("UICorner")
    kCorner.CornerRadius = UDim.new(1, 0)
    kCorner.Parent = knob

    local isToggled = defaultState
    switch.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        local targetColor = isToggled and THEME.Accent or THEME.ToggleOff
        local targetKnobColor = isToggled and THEME.KnobOn or THEME.KnobOff
        local targetPos = isToggled and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)

        TweenService:Create(switch, TWEEN_FAST, {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(knob, TWEEN_FAST, {BackgroundColor3 = targetKnobColor, Position = targetPos}):Play()

        if callback then
            callback(isToggled)
        end
    end)
end

-- Live Search Filtering
SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local query = SearchInput.Text:lower()
    for _, item in ipairs(registeredRows) do
        if query == "" or string.find(item.Name, query, 1, true) then
            item.Frame.Visible = true
        else
            item.Frame.Visible = false
        end
    end
end)

-- Construct Content Cards
local cardFighting = createCard(Col1, "Fighting", 1)
addToggle(cardFighting, "Attack Aura", nil, false, nil)
addToggle(cardFighting, "No Velocity", nil, false, nil)
addToggle(cardFighting, "Trigger Bot", nil, false, nil)
addToggle(cardFighting, "Aim Assist", nil, false, "F1")
addToggle(cardFighting, "Auto Explosion", nil, false, nil)

local cardBase = createCard(Col1, "Base", 2)
addToggle(cardBase, "Auto Swap", nil, true, nil)
addToggle(cardBase, "Item Release", nil, false, nil)

local cardTools = createCard(Col2, "Tools", 1)
addToggle(cardTools, "Sprint Reset", nil, false, nil)
addToggle(cardTools, "Tape Mouse", nil, false, nil)
addToggle(cardTools, "Aim Assist", "Helps to Focus on Entities", false, nil)
addToggle(cardTools, "Web Trap", nil, false, nil)

local cardOther = createCard(Col2, "Other", 2)
addToggle(cardOther, "No Slot Change", nil, false, nil)
addToggle(cardOther, "Anti Bot", nil, false, nil)
addToggle(cardOther, "No Friend Damage", nil, true, nil)

-- Toggle Visibility via RightShift (GUI Only, HUD stays persistent)
local isUIVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        isUIVisible = not isUIVisible
        if isUIVisible then
            Main.Visible = true
            TweenService:Create(Main, TWEEN_SLOW, {
                Position = UDim2.new(0.5, -395, 0.5, -245),
                BackgroundTransparency = 0
            }):Play()
            TweenService:Create(GlowBackdrop, TWEEN_SLOW, {ImageTransparency = 0.83}):Play()
        else
            local hideTween = TweenService:Create(Main, TWEEN_SLOW, {
                Position = UDim2.new(0.5, -395, 0.5, -215),
                BackgroundTransparency = 1
            })
            TweenService:Create(GlowBackdrop, TWEEN_SLOW, {ImageTransparency = 1}):Play()
            hideTween:Play()
            hideTween.Completed:Connect(function()
                if not isUIVisible then
                    Main.Visible = false
                end
            end)
        end
    end
end)
