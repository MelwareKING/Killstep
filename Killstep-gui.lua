local Players    = game:GetService("Players")
local Lighting   = game:GetService("Lighting")
local Workspace  = game:GetService("Workspace")
local UIS        = game:GetService("UserInputService")
local TS         = game:GetService("TweenService")
local RepStorage = game:GetService("ReplicatedStorage")
local RepFirst   = game:GetService("ReplicatedFirst")
local Teleport   = game:GetService("TeleportService")
local Debris     = game:GetService("Debris")
local CoreGui    = game:GetService("CoreGui")
local lp         = Players.LocalPlayer

local SKYBOX_1_TEX        = "rbxassetid://94659307806326"
local SKYBOX_2_TEX        = "rbxassetid://110498650257572"
local FACE_AND_PART_TEX   = "rbxassetid://117473920390660"
local DECAL_SPAM_1_TEX    = "rbxassetid://94659307806326"
local DECAL_SPAM_2_TEX    = "rbxassetid://91410920198348"
local JUMPSCARE_IMG       = "rbxassetid://117473920390660"
local JUMPSCARE_SOUND     = "rbxassetid://103215672097028"
local SOUND_JUMPSTYLE     = "rbxassetid://1839246711"
local SOUND_KILLSTEP      = "rbxassetid://117499298661785"

local TP_PLACE_1 = 16113975381
local TP_PLACE_2 = 15663690620
local DECAL_LIMIT = 160

local BG        = Color3.fromRGB(10, 2, 2)
local BG2       = Color3.fromRGB(22, 6, 6)
local CARD      = Color3.fromRGB(38, 10, 10)
local CARD_H    = Color3.fromRGB(90, 18, 18)
local RED       = Color3.fromRGB(255, 40, 40)
local RED_HOT   = Color3.fromRGB(255, 80, 80)
local RED_DARK  = Color3.fromRGB(120, 15, 15)
local WHITE     = Color3.fromRGB(250, 230, 230)

local parentGui = (gethui and gethui()) or CoreGui
for _, n in ipairs({"KillstepHub", "KillstepHubToggle"}) do
    local old = parentGui:FindFirstChild(n)
    if old then old:Destroy() end
end

local function corner(o, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = o
    return c
end

local function redStroke(o, t)
    local s = Instance.new("UIStroke")
    s.Thickness = t or 2
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = o
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, RED), ColorSequenceKeypoint.new(1, RED_DARK)})
    g.Rotation = 45
    g.Parent = s
    return s
end

local function makeUniformSky(texture)
    for _, s in ipairs(Lighting:GetChildren()) do
        if s:IsA("Sky") then s:Destroy() end
    end
    local sky = Instance.new("Sky")
    sky.SkyboxBk = texture
    sky.SkyboxDn = texture
    sky.SkyboxFt = texture
    sky.SkyboxLf = texture
    sky.SkyboxRt = texture
    sky.SkyboxUp = texture
    sky.Parent = Lighting
    Lighting.TimeOfDay = 12
    Lighting.Ambient = Color3.fromRGB(130, 0, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(70, 0, 0)
end

local function makeSound(id, vol, pitch)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 3
    s.PlaybackSpeed = pitch or 1
    s.Looped = true
    s.Parent = Workspace
    s:Play()
    return s
end

local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "KillstepHubToggle"
toggleGui.ResetOnSpawn = false
toggleGui.IgnoreGuiInset = true
toggleGui.DisplayOrder = 999
if syn and syn.protect_gui then pcall(function() syn.protect_gui(toggleGui) end) end
toggleGui.Parent = parentGui

local halo = Instance.new("Frame")
halo.Size = UDim2.new(0, 90, 0, 90)
halo.Position = UDim2.new(0, 12, 0.5, -45)
halo.BackgroundColor3 = RED
halo.BackgroundTransparency = 0.6
halo.BorderSizePixel = 0
halo.Parent = toggleGui
corner(halo, 45)

local circle = Instance.new("TextButton")
circle.Size = UDim2.new(0, 54, 0, 54)
circle.Position = UDim2.new(0, 30, 0.5, -27)
circle.BackgroundColor3 = BG2
circle.Text = "K"
circle.TextColor3 = RED_HOT
circle.Font = Enum.Font.GothamBlack
circle.TextSize = 28
circle.AutoButtonColor = false
circle.Parent = toggleGui
corner(circle, 27)
redStroke(circle, 2)

circle.MouseEnter:Connect(function() circle.BackgroundColor3 = CARD_H end)
circle.MouseLeave:Connect(function() circle.BackgroundColor3 = BG2 end)

task.spawn(function()
    while toggleGui.Parent do
        TS:Create(halo, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0,110,0,110), Position = UDim2.new(0,2,0.5,-55), BackgroundTransparency = 0.85,
        }):Play()
        task.wait(1.2)
        TS:Create(halo, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0,90,0,90), Position = UDim2.new(0,12,0.5,-45), BackgroundTransparency = 0.6,
        }):Play()
        task.wait(1.2)
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "KillstepHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 10
if syn and syn.protect_gui then pcall(function() syn.protect_gui(gui) end) end
gui.Parent = parentGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 760, 0, 500)
main.Position = UDim2.new(0.5, -380, 0.5, -250)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui
corner(main, 14)
local mainStroke = redStroke(main, 2)

for i = 1, 4 do
    local blob = Instance.new("Frame")
    blob.BackgroundColor3 = RED_DARK
    blob.BackgroundTransparency = 0.85
    blob.BorderSizePixel = 0
    blob.Size = UDim2.new(0, math.random(180, 280), 0, math.random(180, 280))
    blob.Position = UDim2.new(math.random(0,80)/100, 0, math.random(0,80)/100, 0)
    blob.Parent = main
    corner(blob, 200)
    task.spawn(function()
        while blob.Parent do
            TS:Create(blob, TweenInfo.new(math.random(8,14), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(math.random(0,80)/100, 0, math.random(0,80)/100, 0),
                BackgroundTransparency = math.random(75,92)/100,
            }):Play()
            task.wait(math.random(8,14))
        end
    end)
end

local scanlines = Instance.new("Frame")
scanlines.Size = UDim2.new(1, 0, 1, 0)
scanlines.BackgroundTransparency = 1
scanlines.BorderSizePixel = 0
scanlines.ZIndex = 5
scanlines.Parent = main
for i = 0, 50 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, i * 10)
    line.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    line.BackgroundTransparency = 0.9
    line.BorderSizePixel = 0
    line.ZIndex = 5
    line.Parent = scanlines
end

local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 48)
topbar.BackgroundColor3 = BG2
topbar.BorderSizePixel = 0
topbar.Active = true
topbar.ZIndex = 6
topbar.Parent = main
corner(topbar, 14)

local cover = Instance.new("Frame")
cover.Size = UDim2.new(1, 0, 0, 14)
cover.Position = UDim2.new(0,0,1,-14)
cover.BackgroundColor3 = BG2
cover.BorderSizePixel = 0
cover.ZIndex = 6
cover.Parent = topbar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -220, 1, 0)
title.Position = UDim2.new(0, 18, 0, 0)
title.BackgroundTransparency = 1
title.Text = "KILLSTEP HUB"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = WHITE
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 7
title.Parent = topbar

local tGrad = Instance.new("UIGradient", title)
tGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, RED), ColorSequenceKeypoint.new(0.5, RED_HOT), ColorSequenceKeypoint.new(1, RED)})

local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 90, 0, 20)
status.Position = UDim2.new(1, -190, 0.5, -10)
status.BackgroundTransparency = 1
status.Text = "● ONLINE"
status.TextColor3 = RED_HOT
status.Font = Enum.Font.GothamBold
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Right
status.ZIndex = 7
status.Parent = topbar
task.spawn(function()
    while status.Parent do
        status.TextTransparency = 0
        task.wait(0.8)
        status.TextTransparency = 0.6
        task.wait(0.8)
    end
end)

local function topBtn(txt, x)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 32, 0, 28)
    b.Position = UDim2.new(1, x, 0, 10)
    b.BackgroundColor3 = CARD
    b.Text = txt
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.ZIndex = 7
    b.Parent = topbar
    corner(b, 6)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = CARD_H end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = CARD end)
    return b
end

local minBtn = topBtn("—", -78)
local closeBtn = topBtn("X", -42)

local dTog, dIn, dSt, sPos
topbar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dTog = true
        dSt = i.Position
        sPos = main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dTog = false end
        end)
    end
end)
topbar.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement then dIn = i end
end)
UIS.InputChanged:Connect(function(i)
    if i == dIn and dTog then
        local d = i.Position - dSt
        main.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
    end
end)

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 36)
tabBar.Position = UDim2.new(0, 10, 0, 56)
tabBar.BackgroundTransparency = 1
tabBar.ZIndex = 6
tabBar.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabBar

local categories = {"ALL", "CHAOS", "SKY", "SOUND", "FX", "MISC"}
local tabButtons = {}
local buttonsTable = {}
local activeCategory = "ALL"

local function makeTab(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1/#categories, -6, 1, 0)
    b.BackgroundColor3 = CARD
    b.Text = name
    b.TextColor3 = WHITE
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 13
    b.ZIndex = 7
    b.Parent = tabBar
    corner(b, 6)
    local st = Instance.new("UIStroke")
    st.Thickness = 1
    st.Color = RED_DARK
    st.Parent = b
    tabButtons[name] = {btn = b, stroke = st}
end

for _, c in ipairs(categories) do makeTab(c) end

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -108)
scroll.Position = UDim2.new(0, 10, 0, 98)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = RED
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ZIndex = 6
scroll.Parent = main

local grid = Instance.new("UIGridLayout")
grid.CellSize = UDim2.new(0, 232, 0, 50)
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = scroll

local function updateCanvas(visibleCount)
    scroll.CanvasSize = UDim2.new(0, 0, 0, (math.ceil(visibleCount / 3) * 60) + 10)
end

local function selectCategory(name)
    activeCategory = name
    for cn, t in pairs(tabButtons) do
        local active = cn == name
        t.btn.BackgroundColor3 = active and CARD_H or CARD
        t.btn.TextColor3 = active and RED_HOT or WHITE
        t.stroke.Color = active and RED or RED_DARK
        t.stroke.Thickness = active and 2 or 1
    end
    local visibleCount = 0
    for _, info in ipairs(buttonsTable) do
        local visible = (name == "ALL") or (info.cat == name)
        info.btn.Visible = visible
        if visible then visibleCount += 1 end
    end
    updateCanvas(visibleCount)
end

local function fDecalSpam(texture)
    local count = 0
    local function exPro(root)
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("Decal") and v.Texture ~= texture then
                v.Parent = nil
            elseif v:IsA("BasePart") and count < DECAL_LIMIT then
                count += 1
                v.Material = Enum.Material.Plastic
                v.Transparency = 0
                for _, face in ipairs({"Front","Back","Right","Left","Top","Bottom"}) do
                    local d = Instance.new("Decal", v)
                    d.Texture = texture
                    d.Face = Enum.NormalId[face]
                end
            end
            exPro(v)
        end
    end
    exPro(Workspace)
end

local function f666()
    for _, v in ipairs(Workspace:GetChildren()) do
        if v:IsA("BasePart") then
            local bbg = Instance.new("BillboardGui", v)
            bbg.Name = "KillstepMark"
            bbg.Adornee = v
            bbg.Size = UDim2.new(2.5,0,2.5,0)
            local tlb = Instance.new("TextLabel", bbg)
            tlb.Text = "KILLSTEP KILLSTEP KILLSTEP"
            tlb.Font = Enum.Font.SourceSansBold
            tlb.TextSize = 42
            tlb.TextColor3 = Color3.new(1,0,0)
            tlb.Size = UDim2.new(1.25,0,1.25,0)
            tlb.Position = UDim2.new(-0.125,-22,-1.1,0)
            tlb.BackgroundTransparency = 1
            v.BrickColor = BrickColor.new("Really black")
            local pl = Instance.new("PointLight", v)
            pl.Color = Color3.new(1,0,0)
            pl.Range = 15
            pl.Brightness = 5
            local f = Instance.new("Fire", v)
            f.Size = 19
            f.Heat = 22
        end
    end
end

local function fHint()
    local h = Workspace:FindFirstChild("KillstepPermanentHint")
    if not h then
        h = Instance.new("Hint")
        h.Name = "KillstepPermanentHint"
        h.Parent = Workspace
    end
    h.Text = "KILLSTEP IS HERE"
end

local function fUnachor()
    for _, root in ipairs({Workspace, RepStorage, RepFirst}) do
        for _, v in ipairs(root:GetDescendants()) do
            if v:IsA("BasePart") then v.Anchored = false end
        end
    end
end

local function fRandomColors()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.BrickColor = BrickColor.random() end
    end
end

local function fRainFire()
    task.spawn(function()
        while true do
            task.wait(1)
            local p = Instance.new("Part", Workspace)
            p.Position = Vector3.new(math.random(-500,500), math.random(200,500), math.random(-500,500))
            p.BrickColor = BrickColor.new("Dark stone grey")
            p.Anchored = false
            local f = Instance.new("Fire", p)
            f.Size = 99
            Debris:AddItem(p, 10)
        end
    end)
end

local function fRainingBalls()
    task.spawn(function()
        while true do
            task.wait(0.1)
            for _ = 1, 3 do
                local p = Instance.new("Part", Workspace)
                p.Shape = Enum.PartType.Ball
                p.Material = Enum.Material.Neon
                local s = math.random(3,20)
                p.Size = Vector3.new(s,s,s)
                p.Position = Vector3.new(math.random(-500,500), math.random(100,600), math.random(-500,500))
                p.Color = Color3.new(math.random(), math.random(), math.random())
                p.Velocity = Vector3.new(math.random(0,3), math.random(-200,-50), math.random(0,3))
                Debris:AddItem(p, 10)
            end
        end
    end)
end

local function fParticles()
    for _, v in ipairs(Players:GetPlayers()) do
        local head = v.Character and v.Character:FindFirstChild("Head")
        if head then
            local e = Instance.new("ParticleEmitter", head)
            e.Texture = FACE_AND_PART_TEX
            e.VelocitySpread = 360
            e.Rate = 500
            e.Lifetime = NumberRange.new(2,3)
        end
    end
end

local function fRotate()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CFrame = v.CFrame * CFrame.Angles(math.rad(75), 0, 0)
        end
    end
end

local function fDecalMap()
    local count = 0
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and count < 200 then
            count += 1
            local e = Instance.new("ParticleEmitter", v)
            e.Texture = FACE_AND_PART_TEX
            e.Rate = 30
            e.Lifetime = NumberRange.new(1.5, 2.5)
            e.Speed = NumberRange.new(2, 5)
            e.SpreadAngle = Vector2.new(360, 360)
            Debris:AddItem(e, 4)
        end
    end
end

local function fFireAll()
    for _, v in ipairs(Players:GetPlayers()) do
        local char = v.Character
        if char then
            for _, part in ipairs({"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}) do
                local p = char:FindFirstChild(part)
                if p and p:IsA("BasePart") then
                    local f = Instance.new("Fire", p)
                    f.Size = math.random(5, 10)
                    f.Heat = math.random(15, 25)
                    Debris:AddItem(f, 6)
                end
            end
        end
    end
end

local function fKillstepFaceAll()
    for _, v in ipairs(Players:GetPlayers()) do
        local head = v.Character and v.Character:FindFirstChild("Head")
        if head then
            for _, d in ipairs(head:GetChildren()) do
                if d:IsA("BillboardGui") or d:IsA("Decal") then d:Destroy() end
            end
            local g = Instance.new("BillboardGui", head)
            g.Adornee = head
            g.Size = UDim2.new(2.5,0,2.5,0)
            g.StudsOffset = Vector3.new(0,0.2,0)
            g.AlwaysOnTop = true
            local img = Instance.new("ImageLabel", g)
            img.Image = FACE_AND_PART_TEX
            img.Size = UDim2.new(1,0,1,0)
            img.BackgroundTransparency = 1
            head.Transparency = 1
        end
    end
end

local function fJumpscare()
    local playerGui = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui")
    local old = playerGui:FindFirstChild("KillstepJumpscare")
    if old then old:Destroy() end

    local g = Instance.new("ScreenGui")
    g.Name = "KillstepJumpscare"
    g.IgnoreGuiInset = true
    g.ResetOnSpawn = false
    g.DisplayOrder = 100000
    g.Parent = playerGui

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1,0,1,0)
    img.Position = UDim2.new(0,0,0,0)
    img.BackgroundColor3 = Color3.new(0,0,0)
    img.Image = JUMPSCARE_IMG
    img.ScaleType = Enum.ScaleType.Crop
    img.Parent = g

    local s = Instance.new("Sound")
    s.SoundId = JUMPSCARE_SOUND
    s.Volume = 10
    s.Looped = false
    s.Parent = g
    s:Play()
    Debris:AddItem(g, 6)
end

local function fDisco()
    local cc = Instance.new("ColorCorrectionEffect", Lighting)
    task.spawn(function()
        local c = 0
        while cc.Parent do
            task.wait(0.1)
            cc.TintColor = Color3.fromHSV(c % 1, 1, 1)
            Lighting.Ambient = Color3.fromHSV(c % 1, 1, 1)
            c += 0.02
        end
    end)
end

local function fStopMusic()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Sound") then v:Destroy() end
    end
end

local function fClearSky()
    for _, s in ipairs(Lighting:GetChildren()) do
        if s:IsA("Sky") or s:IsA("ColorCorrectionEffect") then s:Destroy() end
    end
end

local function fGameTP(id) Teleport:Teleport(id, lp) end

local function fLeaderStats()
    local function add(p)
        if p:FindFirstChild("leaderstats") then return end
        local ls = Instance.new("Folder", p)
        ls.Name = "leaderstats"
        local m = Instance.new("IntValue", ls)
        m.Name = "KILLSTEP"
        m.Value = 666
    end
    for _, p in ipairs(Players:GetPlayers()) do add(p) end
end

local buttonsDef = {
    {"DecalSpam 1",      "CHAOS", function() fDecalSpam(DECAL_SPAM_1_TEX) end},
    {"DecalSpam 2",      "CHAOS", function() fDecalSpam(DECAL_SPAM_2_TEX) end},
    {"666",              "CHAOS", f666},
    {"RainFire",         "CHAOS", fRainFire},
    {"Raining Balls",    "CHAOS", fRainingBalls},
    {"Unachor",          "CHAOS", fUnachor},
    {"RandomColors",     "CHAOS", fRandomColors},
    {"Rotate",           "CHAOS", fRotate},
    {"Decal Map",        "CHAOS", fDecalMap},
    {"Skybox 1",         "SKY",   function() makeUniformSky(SKYBOX_1_TEX) end},
    {"Skybox 2",         "SKY",   function() makeUniformSky(SKYBOX_2_TEX) end},
    {"ClearSky",         "SKY",   fClearSky},
    {"Jumpstyle",        "SOUND", function() makeSound(SOUND_JUMPSTYLE, 5, 0.7) end},
    {"KILLSTEP Music",   "SOUND", function() makeSound(SOUND_KILLSTEP, 4, 1) end},
    {"StopMusic",        "SOUND", fStopMusic},
    {"Disco",            "FX",    fDisco},
    {"Jumpscare",        "FX",    fJumpscare},
    {"Particles",        "FX",    fParticles},
    {"KILLSTEP face all", "FX",    fKillstepFaceAll},
    {"Fire All",         "FX",    fFireAll},
    {"Hint",             "MISC",  fHint},
    {"Game TP",          "MISC",  function() fGameTP(TP_PLACE_1) end},
    {"Game TP 2",        "MISC",  function() fGameTP(TP_PLACE_2) end},
    {"LeaderStats",      "MISC",  fLeaderStats},
}

for i, b in ipairs(buttonsDef) do
    local name, cat, fn = b[1], b[2], b[3]
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.LayoutOrder = i
    btn.BackgroundColor3 = CARD
    btn.Text = name
    btn.TextColor3 = WHITE
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.ZIndex = 7
    btn.Parent = scroll
    corner(btn, 8)

    local st = Instance.new("UIStroke")
    st.Thickness = 1
    st.Color = RED_DARK
    st.Parent = btn

    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = CARD_H, Size = UDim2.new(0, 236, 0, 54)}):Play()
        st.Color = RED
        st.Thickness = 2
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = CARD, Size = UDim2.new(0, 232, 0, 50)}):Play()
        st.Color = RED_DARK
        st.Thickness = 1
    end)
    btn.MouseButton1Click:Connect(function()
        st.Color = RED_HOT
        st.Thickness = 3
        task.delay(0.12, function()
            if st.Parent then
                st.Thickness = 2
                st.Color = RED
            end
        end)
        task.spawn(function() pcall(fn) end)
    end)

    table.insert(buttonsTable, {btn = btn, cat = cat})
end

for cn, t in pairs(tabButtons) do
    t.btn.MouseButton1Click:Connect(function() selectCategory(cn) end)
end
selectCategory("ALL")

task.spawn(function()
    while main.Parent do
        TS:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Thickness = 3}):Play()
        task.wait(1.5)
        TS:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Thickness = 2}):Play()
        task.wait(1.5)
    end
end)

local minimized = false
local normalSize = main.Size
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tabBar.Visible = not minimized
    scroll.Visible = not minimized
    scanlines.Visible = not minimized
    main.Size = minimized and UDim2.new(0, 760, 0, 48) or normalSize
end)

closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)
circle.MouseButton1Click:Connect(function() gui.Enabled = not gui.Enabled end)
