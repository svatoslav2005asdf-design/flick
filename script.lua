local t1 = {
        value1 = game:GetService("Workspace")
}

function t1.value2(p1)
    local v117 = not p1

    if not v117 then
        v117 = not p1:IsDescendantOf(t1.value1)
    end

    if v117 then
        return
    end

    for _, descendant in ipairs(p1:GetDescendants()) do
        if descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
            descendant.Transparency = 1

            if descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant:Destroy()
            end
        elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
            descendant.Enabled = false
        end
    end
end
t1.value1.ChildAdded:Connect(function(child)
    if child.Name == "deadbody" then
        t1.value2(child)
        child.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("BasePart") or (descendant:IsA("Decal") or descendant:IsA("Texture")) then
                descendant.Transparency = 1

                if descendant:IsA("Decal") or descendant:IsA("Texture") then
                    descendant:Destroy()

                    return
                end
            elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
                descendant.Enabled = false
            end
        end)
    end
end)

for _, child in ipairs(t1.value1:GetChildren()) do
    if child.Name == "deadbody" then
        t1.value2(child)
    end
end
function t1.value3(p2)
    if p2:IsA("Highlight") and (p2.OutlineColor == Color3.fromRGB(0, 0, 0) and p2.FillTransparency == 1) then
        p2:Destroy()
    end
end
local BloomEffect = Instance.new("BloomEffect")

BloomEffect.Name = "bloom"
BloomEffect.Size = 24
BloomEffect.Intensity = 1
BloomEffect.Threshold = 0.9
BloomEffect.Parent = game.Lighting
for _, descendant in ipairs(game:GetDescendants()) do
    t1.value3(descendant)
end
game.DescendantAdded:Connect(t1.value3)
task.spawn(function()
    while task.wait(10) do
        for _, descendant in ipairs(t1.value1:GetDescendants()) do
            if descendant:IsA("Highlight") then
                t1.value3(descendant)
            end
        end
    end
end)

local QualityLevel = settings().Rendering.QualityLevel
if QualityLevel == Enum.QualityLevel.Level01 or (QualityLevel == Enum.QualityLevel.Level02 or QualityLevel == Enum.QualityLevel.Level03) then
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level04
end
local v9 = loadstring(game:HttpGet("https://raw.githubusercontent.com/CludeHub/FATALITY/refs/heads/main/FATALITYSOURCE.lua"))()
local v11 = v9:CreateNotifier()
-- интро без звука
v9:Loader({
        Name = "Lesxov Tap",
        Duration = 4
})
local v12 = "Hello, " .. game.Players.LocalPlayer.DisplayName .. "! Welcome back."
v11:Notify({
        Title = "Lesxov Tap",
        Content = "made by lesxov",
        Icon = "clipboard"
})
v11:Notify({
    Title = "LESXOV TAP LOADED",
    Content = v12,
    Icon = "check"
})

local v13 = v9.new({
        Name = "Lesxov Tap",
        Expire = "never"
})
local UserInputService = game:GetService("UserInputService")

t1.value4 = game.CoreGui:WaitForChild("Lesxov Tap"):WaitForChild("FatalFtame")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.H then
        t1.value4.Visible = not t1.value4.Visible
    end
end)
v13:AddConfig():Init("Counter-Strike 2", "Lesxov-Win")

local function mkMenu(name, icon)
        local ok, m = pcall(function()
                return v13:AddMenu({ Name = name, Icon = icon })
        end)
        if ok and m then return m end
        return v13:AddMenu({ Name = name, Icon = "settings" })
end

local v15 = mkMenu("AIM", "crosshair")
t1.mVisuals = mkMenu("VISUALS", "eye")
t1.mMove = mkMenu("MOVEMENT", "move")
t1.mMisc = mkMenu("MISC", "layers")
local vSettings = mkMenu("SETTINGS", "cog")
t1.mESP = mkMenu("ESP", "eye")

local v16 = v15:AddSection({
        Position = "left",
        Name = "SILENT AIM"
})
local v17 = t1.mVisuals:AddSection({
        Position = "left",
        Name = "VIEW"
})
local v18 = t1.mVisuals:AddSection({
        Position = "center",
        Name = "PLAYER"
})
local v19 = t1.mVisuals:AddSection({
        Position = "right",
        Name = "WORLD"
})
local v20 = t1.mMove:AddSection({
        Position = "left",
        Name = "MOVEMENT"
})
local v21 = t1.mMisc:AddSection({
        Position = "left",
        Name = "MISC"
})

local v22 = v15:AddSection({
        Position = "center",
        Name = "RAGE BOT"
})

-- ============================================================
-- [CONFIG] core: JSON save/load, 3 slots, autosave
-- files: LesxovTap/<slot>.json + meta.json (workspace folder of the executor)
-- ============================================================
do
    local HttpService = game:GetService("HttpService")
    local Cfg = {
        Folder = "LesxovTap",
        Slots = { "default", "slot2", "slot3" },
        Slot = "default",
        Autosave = true,
        ready = false,
        _last = nil,
        Keys = {
            "SilentAim", "SilentAimTarget", "SilentAimFOVEnabled", "SilentAimFOV",
            "RageBotEnabled", "RageBotHitbox", "RageBotAutoFire",
            "AttackIntervalEnabled", "AttackInterval", "AttackHold", "AttackJitter",
            "PenetrationEnabled", "PenetrationMax",
            "RageMagEnabled", "WallbangEnabled", "FireRateEnabled", "FireRateMult",
            "GodModeEnabled", "CrosshairEnabled", "CrosshairSize", "CrosshairGap",
            "SkinEnabled", "SkinName", "SnowStyle",
            "SpinMode", "SpinSpeed", "SpinJitterAngle", "SpinDesyncRoll",
        },
    }

    local fsOk = type(writefile) == "function" and type(readfile) == "function"
        and type(isfile) == "function" and type(isfolder) == "function" and type(makefolder) == "function"
    local mem = {} -- fallback when the executor has no filesystem

    local function rd(name)
        if not fsOk then return mem[name] end
        local ok, data = pcall(function()
            local p = Cfg.Folder .. "/" .. name
            if isfile(p) then return readfile(p) end
            return nil
        end)
        return ok and data or nil
    end

    local function wr(name, data)
        if not fsOk then
            mem[name] = data
            return true
        end
        pcall(function()
            if not isfolder(Cfg.Folder) then makefolder(Cfg.Folder) end
        end)
        return (pcall(writefile, Cfg.Folder .. "/" .. name, data))
    end

    local function dec(s)
        if not s or s == "" then return nil end
        local ok, r = pcall(HttpService.JSONDecode, HttpService, s)
        if ok and type(r) == "table" then return r end
        return nil
    end

    function Cfg.snapshot()
        local out, env = {}, getgenv()
        for _, k in ipairs(Cfg.Keys) do
            if env[k] ~= nil then out[k] = env[k] end
        end
        return out
    end

    function Cfg.save(slot)
        local json = HttpService:JSONEncode(Cfg.snapshot())
        wr((slot or Cfg.Slot) .. ".json", json)
        Cfg._last = json
    end

    function Cfg.load(slot)
        local data = dec(rd((slot or Cfg.Slot) .. ".json"))
        if not data then return false end
        local env = getgenv()
        for _, k in ipairs(Cfg.Keys) do
            local v = data[k]
            if v ~= nil and type(v) == type(env[k]) then env[k] = v end
        end
        Cfg._last = HttpService:JSONEncode(Cfg.snapshot())
        return true
    end

    function Cfg.saveMeta()
        wr("meta.json", HttpService:JSONEncode({ slot = Cfg.Slot, autosave = Cfg.Autosave }))
    end

    function Cfg.reset()
        local env = getgenv()
        for k, v in pairs(Cfg.defaults or {}) do env[k] = v end
        Cfg.save()
    end

    function Cfg.init()
        Cfg.defaults = Cfg.snapshot()
        local meta = dec(rd("meta.json"))
        if meta then
            if table.find(Cfg.Slots, meta.slot) then Cfg.Slot = meta.slot end
            if type(meta.autosave) == "boolean" then Cfg.Autosave = meta.autosave end
        end
        Cfg.load()
        Cfg.ready = true
    end

    task.spawn(function()
        while task.wait(2) do
            if Cfg.ready and Cfg.Autosave then
                local ok, json = pcall(function() return HttpService:JSONEncode(Cfg.snapshot()) end)
                if ok and json ~= Cfg._last then pcall(Cfg.save) end
            end
        end
    end)

    t1.Cfg = Cfg
end

t1.value5 = game:GetService("Players")

local RunService = game:GetService("RunService")

t1.value6 = game:GetService("Workspace")
t1.value7 = t1.value6.CurrentCamera
t1.value8 = t1.value5.LocalPlayer

getgenv().RageBotEnabled = false
getgenv().RageTarget = "Head"
getgenv().RageAutoShoot = false
getgenv().SilentAim = getgenv().SilentAim or false
getgenv().SilentAimTarget = getgenv().SilentAimTarget or "Head"
getgenv().SilentAimFOVEnabled = getgenv().SilentAimFOVEnabled or false
getgenv().SilentAimFOV = getgenv().SilentAimFOV or 50
getgenv().TrailEnabled = getgenv().TrailEnabled or false
getgenv().TrailColor = getgenv().TrailColor or Color3.fromRGB(255, 0, 0)
getgenv().TRIGGER_Enabled = false
getgenv().TriggerRadius = 10
getgenv().ShowCircle = false
getgenv().AutoJumpEnabled = false
getgenv().AirStrafeEnabled = false
getgenv().AirStrafeStrength = 20
getgenv().QuickStopEnabled = false

-- Настройки детального Bhop
getgenv().BhopEnabled = false
getgenv().BhopMode = "Velocity"
getgenv().BhopRequireSpace = true
getgenv().BhopSpeed = 32
getgenv().BhopMaxSpeed = 65
getgenv().BhopAccel = 2.5
getgenv().BhopJumpPower = 50
getgenv().BhopGroundDelay = 0.02
getgenv().BhopAutoStrafe = true
getgenv().BhopStrafeTurnSpeed = 35
getgenv().BhopCFrameMultiplier = 0.35

-- Настройки Spin (Basic Spin, Jitler, Yitler)
getgenv().SpinEnabled = false
getgenv().SpinMode = "Basic Spin"
getgenv().SpinSpeed = 25
getgenv().SpinJitterAngle = 65
getgenv().SpinDesyncRoll = 0

getgenv().RageBotEnabled = false
getgenv().RageBotHitbox = "Head"
getgenv().RageBotAutoFire = false

-- new-feature defaults, then apply the saved config over everything above
getgenv().AttackIntervalEnabled = false
getgenv().AttackInterval = 100   -- ms between shots
getgenv().AttackHold = 50        -- ms the fire input stays down
getgenv().AttackJitter = 0       -- +/- ms random on the interval
getgenv().PenetrationEnabled = false
getgenv().PenetrationMax = 3     -- surfaces a shot may pass through
getgenv().RageMagEnabled = false
getgenv().WallbangEnabled = false
getgenv().FireRateEnabled = false
getgenv().FireRateMult = 2
getgenv().GodModeEnabled = false
getgenv().CrosshairEnabled = false
getgenv().CrosshairSize = 12
getgenv().CrosshairGap = 4
getgenv().SkinEnabled = false
getgenv().SkinName = "Random"
getgenv().SnowStyle = "Realistic"
t1.Cfg.init()

local cam = t1.value6.CurrentCamera

function getRageBotTarget()
    local closest = nil
    local closestDist = math.huge

    for _, player in ipairs(t1.value5:GetPlayers()) do
        if player ~= t1.value8 and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local char = player.Character
            local targetPart
            local hitbox = getgenv().RageBotHitbox

            if hitbox == "All" then
                for _, name in ipairs({"Head", "UpperTorso", "Torso", "HumanoidRootPart"}) do
                    local p = char:FindFirstChild(name)
                    if p then
                        targetPart = p
                        break
                    end
                end
            else
                targetPart = char:FindFirstChild(hitbox) or char:FindFirstChild("Head")
            end

            if targetPart then
                local origin = cam.CFrame.Position
                local direction = targetPart.Position - origin
                local rayParams = RaycastParams.new()
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                rayParams.FilterDescendantsInstances = {t1.value8.Character}
                local result = t1.value6:Raycast(origin, direction, rayParams)
                
                local isVisible = not result or result.Instance:IsDescendantOf(char)
                
                if isVisible or getgenv().WallbangEnabled then
                    local dist = (targetPart.Position - cam.CFrame.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = targetPart
                    end
                end
            end
        end
    end

    return closest
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BulletHandler = require(ReplicatedStorage.ModuleScripts.GunModules:WaitForChild("BulletHandler"))
local SignalManager = require(ReplicatedStorage:WaitForChild("SignalManager"))
local oldFire = BulletHandler.Fire

-- ============================================================
-- [SURFACE PENETRATION] core
-- no metamethod hooks on game internals. METHOD 1: hook legacy FindPartOnRay /
-- FindPartOnRayWithIgnoreList (the game's own hit checks) so walls are skipped.
-- METHOD 2 (fallback when hookfunction is missing): on each shot temporarily
-- detach up to PenetrationMax wall parts on the shot line, restore 500 ms later.
-- ============================================================
do
    local Players = game:GetService("Players")
    local rawRaycast = workspace.Raycast
    local Pen = {}
    t1.Pen = Pen

    local function isPlayerPart(inst)
        if not inst then return false end
        local model = inst:FindFirstAncestorWhichIsA("Model")
        while model do
            if Players:GetPlayerFromCharacter(model) then return true end
            model = model:FindFirstAncestorWhichIsA("Model")
        end
        return false
    end

    local function penEnabled()
        return getgenv().WallbangEnabled or getgenv().PenetrationEnabled
    end

    -- СПОСОБ 1: хук легаси-лучей игры. Игра проверяет попадания через
    -- FindPartOnRayWithIgnoreList / FindPartOnRay — хук пропускает стены
    -- (до PenetrationMax поверхностей), останавливаясь только на игроках.
    if hookfunction and not Pen._hooked then
        Pen._hooked = true
        pcall(function()
            local realOld
            local function newFind(self, ray, ignoreList, a, b)
                local res = realOld(self, ray, ignoreList, a, b)
                if not penEnabled() then return res end
                local hops = 0
                local limit = math.max(getgenv().PenetrationMax or 3, 1)
                while res and hops < limit and not isPlayerPart(res) do
                    local ig = {}
                    if ignoreList then
                        for i = 1, #ignoreList do ig[i] = ignoreList[i] end
                    end
                    ig[#ig + 1] = res
                    ignoreList = ig
                    res = realOld(self, ray, ignoreList, a, b)
                    hops = hops + 1
                end
                return res
            end

            realOld = hookfunction(workspace.FindPartOnRayWithIgnoreList, newFind)
        end)
        pcall(function()
            local realOld2
            local function newFind2(self, ray, ignoreDescendants, a, b)
                local res = realOld2(self, ray, ignoreDescendants, a, b)
                if not penEnabled() then return res end
                local hops = 0
                local limit = math.max(getgenv().PenetrationMax or 3, 1)
                while res and hops < limit and not isPlayerPart(res) do
                    local ig = {}
                    if ignoreDescendants then
                        for i = 1, #ignoreDescendants do ig[i] = ignoreDescendants[i] end
                    end
                    ig[#ig + 1] = res
                    res = realOld2(self, ray, ig, a, b)
                    hops = hops + 1
                end
                return res
            end

            realOld2 = hookfunction(workspace.FindPartOnRay, newFind2)
        end)
    end

    -- СПОСОБ 2 (фолбэк, если хуков нет): на каждый выстрел временно убираем
    -- стены с линии выстрела (parent = nil) и возвращаем их через 0.5 с.
    local function restore(list)
        for _, e in ipairs(list) do
            pcall(function()
                if e.parent then e.part.Parent = e.parent end
                e.part.CanQuery = e.was
            end)
        end
    end

    function Pen.arm(data)
        if Pen._hooked then return end -- хук уже всё делает
        if not penEnabled() then return end
        if not data or not data.Origin or not data.Direction then return end

        local limit = getgenv().PenetrationMax or 3
        local origin = data.Origin
        local dir = data.Direction.Unit * 2048
        local ignore = {}
        local lp = Players.LocalPlayer
        if lp and lp.Character then ignore[1] = lp.Character end

        local touched, reached = {}, false
        for i = 1, limit + 1 do
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = ignore
            local res = rawRaycast(workspace, origin, dir, params)
            if not res then break end
            if isPlayerPart(res.Instance) then reached = true break end
            if i > limit then break end
            touched[#touched + 1] = { part = res.Instance, was = res.Instance.CanQuery, parent = res.Instance.Parent }
            ignore[#ignore + 1] = res.Instance
        end

        if not reached or #touched == 0 then return end
        for _, e in ipairs(touched) do
            pcall(function()
                e.part.CanQuery = false
                e.part.Parent = nil
            end)
        end
        task.delay(0.5, function() restore(touched) end)
    end
end

local function isInFOV(targetPart)
    if not getgenv().SilentAimFOVEnabled then return true end
    
    local cam = t1.value6.CurrentCamera
    local fovRadius = getgenv().SilentAimFOV or 50
    local dir = (targetPart.Position - cam.CFrame.Position).Unit
    local angle = math.acos(math.clamp(cam.CFrame.LookVector:Dot(dir), -1, 1))
    local deg = math.deg(angle)
    return deg <= fovRadius
end

local function getSilentAimTarget()
    if not getgenv().SilentAim then return nil end
    
    local closest = nil
    local closestDist = math.huge
    local cam = t1.value6.CurrentCamera
    local targetPartName = getgenv().SilentAimTarget or "Head"
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    if t1.value8.Character then
        rayParams.FilterDescendantsInstances = {t1.value8.Character}
    end
    
    for _, player in ipairs(t1.value5:GetPlayers()) do
        if player ~= t1.value8 and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPart = player.Character:FindFirstChild(targetPartName)
            if targetPart then
                if not isInFOV(targetPart) then
                    continue
                end
                
                local d = (targetPart.Position - cam.CFrame.Position).Magnitude
                if d < closestDist then
                    local dir = (targetPart.Position - cam.CFrame.Position).Unit * d
                    local hit = t1.value6:Raycast(cam.CFrame.Position, dir, rayParams)
                    if not hit or hit.Instance:IsDescendantOf(player.Character) or getgenv().WallbangEnabled then
                        closestDist = d
                        closest = targetPart
                    end
                end
            end
        end
    end
    return closest
end

BulletHandler.Fire = function(data)
    local shouldChange = false
    local target = nil
    
    if getgenv().SilentAim then
        target = getSilentAimTarget()
        if target then
            shouldChange = true
        end
    end
    
    if not shouldChange and getgenv().RageBotEnabled then
        target = getRageBotTarget()
        if target then
            shouldChange = true
        end
    end
    
    if shouldChange and target and data and data.Origin and data.Misc then
        data.Direction = (target.Position - data.Origin).Unit
        data.Misc.CamCFrame = CFrame.new(data.Misc.CamCFrame.Position, target.Position)
    end
    
    t1.Pen.arm(data)

    return oldFire(data)
end

-- ============================================================
-- [ATTACK INTERVAL] auto-shoot cadence (rage bot auto shoot)
-- off = legacy 100 ms cycle (50 hold + 50 wait)
-- ============================================================
do
    local sec = v15:AddSection({ Position = "right", Name = "ATTACK INTERVAL" })

    sec:AddToggle({
        Name = "Custom Interval",
        Flag = "AttackIntervalEnabled",
        Default = getgenv().AttackIntervalEnabled,
        Callback = function(p) getgenv().AttackIntervalEnabled = p end
    })
    sec:AddSlider({
        Name = "Interval (ms)",
        Flag = "AttackInterval",
        Min = 20, Max = 1000,
        Default = math.clamp(getgenv().AttackInterval, 20, 1000),
        Callback = function(p) getgenv().AttackInterval = p end
    })
    sec:AddSlider({
        Name = "Hold (ms)",
        Flag = "AttackHold",
        Min = 10, Max = 500,
        Default = math.clamp(getgenv().AttackHold, 10, 500),
        Callback = function(p) getgenv().AttackHold = p end
    })
    sec:AddSlider({
        Name = "Jitter (ms)",
        Flag = "AttackJitter",
        Min = 0, Max = 200,
        Default = math.clamp(getgenv().AttackJitter, 0, 200),
        Callback = function(p) getgenv().AttackJitter = p end
    })

    task.spawn(function()
        while true do
            local g = getgenv()
            if g.RageBotEnabled and g.RageBotAutoFire and getRageBotTarget() then
                local interval, hold = 0.1, 0.05
                if g.RageMagEnabled then
                    -- rage mag: стреляет сразу, как только цель появилась
                    interval, hold = 0.03, 0.015
                end
                if g.AttackIntervalEnabled then
                    interval = g.AttackInterval / 1000
                    if g.AttackJitter > 0 then
                        interval += (math.random() * 2 - 1) * g.AttackJitter / 1000
                    end
                    hold = g.AttackHold / 1000
                end
                interval = math.max(interval, 0.02)
                hold = math.min(hold, interval)

                SignalManager.Fire("FireWeapon", Enum.UserInputState.Begin)
                task.wait(hold)
                SignalManager.Fire("FireWeapon", Enum.UserInputState.End)
                task.wait(math.max(interval - hold, 0.01))
            else
                task.wait(g.RageMagEnabled and 0.01 or 0.05)
            end
        end
    end)
end

-- ============================================================
-- [SURFACE PENETRATION] toggle + depth
-- ============================================================
do
    local sec = v15:AddSection({ Position = "left", Name = "SURFACE PENETRATION" })

    sec:AddToggle({
        Name = "Penetrate Surfaces",
        Flag = "PenetrationEnabled",
        Default = getgenv().PenetrationEnabled,
        Callback = function(p) getgenv().PenetrationEnabled = p end
    })
    sec:AddSlider({
        Name = "Max Surfaces",
        Flag = "PenetrationMax",
        Min = 1, Max = 8,
        Default = math.clamp(getgenv().PenetrationMax, 1, 8),
        Callback = function(p) getgenv().PenetrationMax = p end
    })
end

v22:AddToggle({
    Name = "Enable",
    Flag = "RageBot_Enable",
    Default = getgenv().RageBotEnabled,
    Callback = function(p)
        getgenv().RageBotEnabled = p
    end
})

v22:AddToggle({
    Name = "Auto Shoot",
    Flag = "RageBot_AutoShoot",
    Default = getgenv().RageBotAutoFire,
    Callback = function(p)
        getgenv().RageBotAutoFire = p
    end
})

v22:AddToggle({
    Name = "Rage Mag (instant fire)",
    Flag = "RageMagEnabled",
    Default = getgenv().RageMagEnabled,
    Callback = function(p)
        getgenv().RageMagEnabled = p
    end
})

v22:AddToggle({
    Name = "Wallbang (shoot through walls)",
    Flag = "WallbangEnabled",
    Default = getgenv().WallbangEnabled,
    Callback = function(p)
        getgenv().WallbangEnabled = p
    end
})

v22:AddDropdown({
    Name = "Target",
    Flag = "RageBot_Target",
    Values = {
        "Head",
        "UpperTorso",
        "Torso",
        "HumanoidRootPart",
        "All"
    },
    Default = getgenv().RageBotHitbox,
    Callback = function(p)
        getgenv().RageBotHitbox = p
    end
})

v16:AddToggle({
        Name = "Enable",
        Flag = "SilentAimEnabled",
        Default = getgenv().SilentAim,
        Callback = function(p)
    getgenv().SilentAim = p
end
})

v16:AddDropdown({
    Name = "Target",
    Flag = "SilentAimTarget",
    Values = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"},
    Default = getgenv().SilentAimTarget,
    Callback = function(p)
        getgenv().SilentAimTarget = p
    end
})

v16:AddToggle({
    Name = "FOV",
    Flag = "SilentAimFOV",
    Default = getgenv().SilentAimFOVEnabled,
    Callback = function(p)
        getgenv().SilentAimFOVEnabled = p
    end
})

v16:AddSlider({
    Name = "FOV Radius",
    Flag = "SilentAimFOVRadius",
    Min = 1,
    Max = 200,
    Default = getgenv().SilentAimFOV,
    Callback = function(p)
        getgenv().SilentAimFOV = p
    end
})

local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local fovScreenGui = Instance.new("ScreenGui")
fovScreenGui.Name = "SmoothFOVCircle"
fovScreenGui.IgnoreGuiInset = true
fovScreenGui.ResetOnSpawn = false
fovScreenGui.Parent = PlayerGui

local fovCircleFrame = Instance.new("Frame")
fovCircleFrame.Name = "Circle"
local currentFOV = getgenv().SilentAimFOV or 50
fovCircleFrame.Size = UDim2.new(0, currentFOV * 2, 0, currentFOV * 2)
fovCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircleFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircleFrame.BackgroundTransparency = 1
fovCircleFrame.Parent = fovScreenGui
fovCircleFrame.Visible = getgenv().SilentAimFOVEnabled and getgenv().SilentAim

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = fovCircleFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Parent = fovCircleFrame
uiStroke.Thickness = 1.5
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiStroke.Color = Color3.new(1, 1, 1)

local uiGradient = Instance.new("UIGradient")
uiGradient.Parent = uiStroke

uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0.0, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(1.0, Color3.new(0, 0, 0))
}

local rotationSpeed = 0.3

local function updateFOVCircle()
    local radius = getgenv().SilentAimFOV or 50
    fovCircleFrame.Size = UDim2.new(0, radius * 2, 0, radius * 2)
    fovCircleFrame.Visible = getgenv().SilentAimFOVEnabled and getgenv().SilentAim
end

RunService.RenderStepped:Connect(function()
    uiGradient.Rotation = uiGradient.Rotation + rotationSpeed
end)

-- FOV circle через Drawing: радиус в пикселях считается из градусов,
-- поэтому круг совпадает с реальным углом захвата аима
local fovDrawing = Drawing.new("Circle")
fovDrawing.Visible = false
fovDrawing.Thickness = 1.5
fovDrawing.NumSides = 64
fovDrawing.Filled = false
fovDrawing.Color = Color3.fromRGB(255, 255, 255)

RunService.RenderStepped:Connect(function()
    local cam = workspace.CurrentCamera
    if not (getgenv().SilentAimFOVEnabled and getgenv().SilentAim and cam and cam.Parent) then
        fovDrawing.Visible = false
        fovCircleFrame.Visible = false
        return
    end

    local deg = getgenv().SilentAimFOV or 50
    local vp = cam.ViewportSize
    local px = math.tan(math.rad(deg)) / math.tan(math.rad(cam.FieldOfView / 2)) * (vp.Y / 2)

    fovDrawing.Radius = math.clamp(px, 2, 4000)
    fovDrawing.Position = Vector2.new(vp.X / 2, vp.Y / 2)
    fovDrawing.Visible = true
    fovCircleFrame.Visible = false
end)

t1.value14 = game:GetService("Players")
t1.value15 = game:GetService("RunService")
t1.value16 = t1.value1.CurrentCamera
t1.value17 = game:GetService("Debris")
t1.value18 = game:GetService("UserInputService")
t1.value19 = t1.value14.LocalPlayer
t1.value20 = false
t1.value21 = 1.3
t1.value22 = 1.4
t1.value23 = true
t1.value24 = true
t1.value25 = 600
function t1.value26(p13)
    if not p13 or not p13.Parent then
        return false
    end

    local CFramePosition = t1.value16.CFrame.Position
    local v163 = p13.Position - CFramePosition
    local ray = Ray.new(CFramePosition, v163.Unit * v163.Magnitude)
    local t2 = {
                t1.value19.Character,
                t1.value16
        }
    local PartOnRayWithIgnoreList = t1.value1:FindPartOnRayWithIgnoreList(ray, t2)

    return not PartOnRayWithIgnoreList or (PartOnRayWithIgnoreList == p13 or PartOnRayWithIgnoreList:IsDescendantOf(p13.Parent))
end
t1.value27 = nil
function t1.value27(p14)
    if not t1.value20 then
        return true
    end

    if t1.value19.Team and p14.Team then
        return t1.value19.Team ~= p14.Team
    end

    return true
end

t1.value30 = nil
function t1.value30(p17)
    for _, child in ipairs(p17:GetChildren()) do
        if not (child:IsA("BasePart") and child.Name == "Muz") then
            local v188 = t1.value30(child)

            if not v188 then
                continue
            end

            return v188
        end

        if child:IsDescendantOf(t1.value1) then
            return child
        end
    end

    return nil
end
function t1.value31(p18)
    local v190
    if v190 then
        v190:IsDescendantOf(t1.value1)
    end
    local v191
    repeat
        v191 = t1.value30(p18)
        task.wait(0.3)
    until v191 and v191:IsDescendantOf(t1.value1)

    return v191
end
local function v33(p19)
    task.spawn(function()
        local v479 = t1.value31(p19)
        local u480
        pcall(function()
            u480 = t1.value19:WaitForChild("PlayerGui"):WaitForChild("MobileControls"):WaitForChild("Frame"):WaitForChild("FireButton")
        end)
        if u480 then
            u480.MouseButton1Click:Connect(function()
            end)
        end
        t1.value18.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if t1.value29 then
                    t1.value29(v479)
                end
            end
        end)
    end)
end
if t1.value19.Character then
    v33(t1.value19.Character)
end
t1.value19.CharacterAdded:Connect(v33)

t1.value32 = nil
t1.value33 = {}
v21:AddToggle({
        Name = "Custom gun sound",
        Flag = "CustomGunSound",
        Default = false,
        Callback = function(p23)
    local s1 = "rbxassetid://2476571739"
    local function v198(p24)
        if p24:IsA("Sound") and p24.Name == "GunShot" then
            if not t1.value33[p24] then
                t1.value33[p24] = p24.SoundId
            end

            local Model = p24:FindFirstAncestorWhichIsA("Model")

            if p23 then
                if Model and Model.Name == "Revolver" then
                    p24.SoundId = "rbxassetid://18302097184"

                    return
                end

                p24.SoundId = s1

                return
            end

            if t1.value33[p24] then
                p24.SoundId = t1.value33[p24]
            end
        end
    end
    for v201, v202 in pairs(game:GetDescendants()) do

        v198(v202)
    end
    if p23 then
        t1.value32 = game.DescendantAdded:Connect(function(descendant)
            v198(descendant)
        end)

        return
    end
    if t1.value32 then
        t1.value32:Disconnect()
    end
end
})
t1.value34 = game:GetService("Players").LocalPlayer
t1.value35 = {
        Crit = "rbxassetid://138705939667182",
        Bang = "rbxassetid://138705939667182"
}
t1.value36 = {
        Bell = "rbxassetid://123827281575056",
        Metal = "rbxassetid://9125672731",
        Growl = "rbxassetid://136705296952779",
        Brutal = "rbxassetid://82176913611683",
        Money = "rbxassetid://9117067586",
        Sparkle = "rbxassetid://78601008552434",
        ["Aray ko"] = "rbxassetid://122864243311961",
        Hehe = "rbxassetid://18381322350"
}
t1.value37 = false
t1.value38 = nil
t1.value39 = "Bell"
t1.value38 = 100
function t1.value40()
    local PlayerGui = t1.value34:FindFirstChild("PlayerGui")

    if not PlayerGui then
        return
    end

    local Effect = PlayerGui:FindFirstChild("Effect")

    if not Effect then
        return
    end

    local Crit = Effect:FindFirstChild("Crit")
    local Bang = Effect:FindFirstChild("Bang")

    if Crit then
        local value37 = t1.value37

        if value37 then
            value37 = t1.value36[t1.value39]
        end

        Crit.SoundId = value37 or t1.value35.Crit
        Crit.Volume = t1.value38
    end

    if Bang then
        Bang.SoundId = t1.value37 and t1.value36[t1.value39] or t1.value35.Bang
        Bang.Volume = t1.value38
    end
end
v21:AddToggle({
        Name = "Custom hit sound",
        Flag = "HitSoundEnabled",
        Default = false,
        Callback = function(p25)
    t1.value37 = p25
    t1.value40()
end
})
v21:AddDropdown({
        Name = "Hit sound",
        Flag = "HitSoundType",
        Values = {
                "Bell",
                "Metal",
                "Brutal",
                "Growl",
                "Money",
                "Sparkle",
                "Aray ko",
                "Hehe"
        },
        Default = "Bell",
        Callback = function(p26)
    t1.value39 = p26
    t1.value40()
end
})
v21:AddSlider({
        Name = "Volume",
        Flag = "HitSoundVolume",
        Min = 1,
        Max = 100,
        Default = 100,
        Callback = function(p27)
    t1.value38 = p27 / 100
    t1.value40()
end
})
t1.value34.CharacterAdded:Connect(function()
    task.wait(1)
    t1.value40()
end)

t1.value41 = game:GetService("Players").LocalPlayer
t1.value42 = false
t1.value43 = false
t1.value44 = "None"
t1.value45 = "None"
t1.value46 = Color3.fromRGB(140, 140, 245)
t1.value47 = Color3.fromRGB(140, 140, 245)
t1.value48 = nil
function t1.value48(p28, p29)
    local v213 = p29 and t1.value43 or t1.value42
    local v214 = p29

    if p29 then
        v214 = t1.value45
    end

    local v215 = v214 or t1.value44
    local v216 = p29 and t1.value47 or t1.value46

    if not v213 then
        return
    end

    if not p28:IsA("BasePart") and (not p28:IsA("MeshPart") and not p28:IsA("UnionOperation")) then
        return
    end

    if p28.Transparency >= 1 then
        return
    end

    if p28.Name == "LeftArm" or p28.Name == "RightArm" then
        return
    end

    if not p29 then
        local v217 = t1.value41.Character and t1.value41.Character:FindFirstChildOfClass("Tool")

        if v217 then
            local Charm = v217:FindFirstChild("Charm", true)

            if Charm and p28 == Charm or Charm:IsAncestorOf(p28) then
                return
            end
        end
    elseif p28.Name ~= "Charm" and (not p28.Parent and p28.Parent.Name == "Charm") then
        return
    end

    if v215 == "Latex" then
        p28.Transparency = 0.55
        p28.Color = v216
        p28.Material = Enum.Material.Neon
        p28.Reflectance = 0
    elseif v215 == "Metal" then
        p28.Transparency = 0
        p28.Color = v216
        p28.Material = Enum.Material.Glass
        p28.Reflectance = 1
    elseif v215 == "Lava" then
        p28.Transparency = 0
        p28.Color = v216
        p28.Material = Enum.Material.CrackedLava
        p28.Reflectance = 0
    elseif v215 == "Glow" then
        p28.Transparency = 0
        p28.Color = v216
        p28.Material = Enum.Material.Neon
        p28.Reflectance = 0
    elseif v215 == "None" then
        p28.Material = Enum.Material.Plastic
        p28.Reflectance = 0
    end

    if p28:IsA("UnionOperation") then
        p28.UsePartColor = true
    end
end
function t1.value49(p30)
    for _, descendant in ipairs(p30:GetDescendants()) do
        t1.value48(descendant, false)
        t1.value48(descendant, true)
    end

    p30.DescendantAdded:Connect(function(descendant)
        task.wait(0.05)
        t1.value48(descendant, false)
        t1.value48(descendant, true)
    end)
end
local function v42(p31)
    local GetChildren = p31.GetChildren

    for _, v in ipairs(GetChildren(p31)) do
        if v:IsA("Tool") then
            t1.value49(v)
        end
    end

    p31.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            t1.value49(child)
        end
    end)
end
if t1.value41.Character then
    v42(t1.value41.Character)
end
t1.value41.CharacterAdded:Connect(v42)

local v43 = v18:AddToggle({
        Name = "Weapon",
        Flag = "WeaponLatex",
        Option = true,
        Default = false,
        Callback = function(p32)
    t1.value42 = p32

    if t1.value41.Character then
        v42(t1.value41.Character)
    end
end
})
v43.Option:AddDropdown({
        Name = "Style",
        Flag = "WeaponStyle",
        Values = {
                "None",
                "Latex",
                "Lava",
                "Metal",
                "Glow"
        },
        Default = "Latex",
        Callback = function(p33)
    t1.value44 = p33

    if t1.value42 and t1.value41.Character then
        v42(t1.value41.Character)
    end
end
})
local Option = v43.Option
local color3 = Color3.fromRGB(140, 140, 245)

Option:AddColorPicker({
        Name = "Color",
        Flag = "WeaponColor",
        Default = color3,
        Callback = function(p34)
    t1.value46 = p34

    if t1.value42 and t1.value41.Character then
        v42(t1.value41.Character)
    end
end
})
local v46 = v18:AddToggle({
        Name = "Charm",
        Flag = "CharmLatex",
        Option = true,
        Default = false,
        Callback = function(p35)
    t1.value43 = p35

    if t1.value41.Character then
        v42(t1.value41.Character)
    end
end
})
v46.Option:AddDropdown({
        Name = "Style",
        Flag = "CharmStyle",
        Values = {
                "None",
                "Latex",
                "Metal",
                "Lava",
                "Glow"
        },
        Default = "Latex",
        Callback = function(p36)
    t1.value45 = p36

    if t1.value43 and t1.value41.Character then
        v42(t1.value41.Character)
    end
end
})
local Option2 = v46.Option
local color3_2 = Color3.fromRGB(140, 140, 245)

Option2:AddColorPicker({
        Name = "Color",
        Flag = "CharmColor",
        Default = color3_2,
        Callback = function(p37)
    t1.value47 = p37

    if t1.value43 and t1.value41.Character then
        v42(t1.value41.Character)
    end
end
})
local Lighting = game:GetService("Lighting")

t1.value50 = nil
t1.value50 = Lighting
function t1.value51(p38, p39)
    t1.value50.ClockTime = 13
    t1.value50.Brightness = 0

    local NightBloom = t1.value50:FindFirstChild("NightBloom")

    if NightBloom then
        NightBloom:Destroy()
    end

    local BloomEffect2 = Instance.new("BloomEffect")

    BloomEffect2.Name = "NightBloom"
    BloomEffect2.Size = p38 or 24
    BloomEffect2.Intensity = p39 or 1
    BloomEffect2.Threshold = 0.9
    BloomEffect2.Parent = t1.value50
end
t1.value52 = v19:AddToggle({
        Name = "Night mode",
        Option = true,
        Flag = "NightModee",
        Default = false,
        Callback = function(p40)
    if p40 then
        t1.value51(10, 1)

        return
    end

    t1.value50.ClockTime = 12
    t1.value50.Brightness = 2

    local NightBloom = t1.value50:FindFirstChild("NightBloom")

    if NightBloom then
        NightBloom:Destroy()
    end
end
})
t1.value52.Option:AddSlider({
        Name = "Bloom Size",
        Flag = "NightBloomSize",
        Min = 1,
        Max = 100,
        Default = 20,
        Callback = function(p41)
    if t1.value52.Value then
        local v239 = t1.value50:FindFirstChild("NightBloom") and t1.value50.NightBloom.Intensity or 1

        t1.value51(p41, v239)
    end
end
})
t1.value52.Option:AddSlider({
        Name = "Bloom Intensity",
        Flag = "NightBloomIntensity",
        Min = 0,
        Max = 5,
        Default = 1,
        Callback = function(p42)
    if t1.value52.Value then
        local v241 = t1.value50:FindFirstChild("NightBloom") and t1.value50.NightBloom.Size or 24

        t1.value51(v241, p42)
    end
end
})
local Players = game:GetService("Players")

game:GetService("Lighting")
t1.value53 = game:GetService("RunService")

local _ = Players.LocalPlayer
t1.value54 = t1.value1.CurrentCamera
t1.value55 = {}
t1.value56 = {}
local color3_3 = Color3.fromRGB(180, 180, 255)

t1.value57 = {
        Density = 250,
        Speed = 100,
        Color = color3_3
}
local color3_4 = Color3.fromRGB(255, 255, 255)

t1.value58 = {
        Density = 150,
        Speed = 10,
        Size = 0.2,
        Color = color3_4
}
t1.value59 = {
        Type = "None"
}
t1.value60 = Instance.new("Sound")
t1.value60.Looped = true
t1.value60.Volume = 0.8
t1.value60.Parent = t1.value1
local v54 = v19:AddDropdown({
        Name = "Weather",
        Flag = "WeatherDropdown",
        Option = true,
        Default = "None",
        Values = {
                "None",
                "Rain",
                "Snow"
        },
        Callback = function(p43)
    t1.value59.Type = p43
    for v245, v246 in pairs(t1.value55) do

        v246:Destroy()
    end
    for v249, v250 in pairs(t1.value56) do

        v250:Destroy()
    end
    t1.value55 = {}
    t1.value56 = {}
    if p43 == "Rain" then
        t1.value60.SoundId = "rbxassetid://9064263922"
        t1.value60:Play()

        return
    end
    if p43 == "Snow" then
        t1.value60.SoundId = "rbxassetid://238895410"
        t1.value60:Play()

        return
    end
    t1.value60:Stop()
end
})
v54.Option:AddSlider({
        Name = "Rain Density",
        Flag = "RainDensity",
        Min = 50,
        Max = 2000,
        Default = 600,
        Callback = function(p44)
    t1.value57.Density = p44
end
})
v54.Option:AddSlider({
        Name = "Rain Speed",
        Flag = "RainSpeed",
        Min = 50,
        Max = 300,
        Default = 150,
        Callback = function(p45)
    t1.value57.Speed = p45
end
})
local Option3 = v54.Option
local AddColorPicker2 = Option3.AddColorPicker
local color3_5 = Color3.fromRGB(255, 255, 255)

AddColorPicker2(Option3, {
        Name = "Rain Color",
        Flag = "RainColor",
        Default = color3_5,
        Callback = function(p46)
    t1.value57.Color = p46
end
})
v54.Option:AddSlider({
        Name = "Snow Density",
        Flag = "SnowDensity",
        Min = 50,
        Max = 400,
        Default = 250,
        Callback = function(p47)
    t1.value58.Density = p47
end
})
v54.Option:AddSlider({
        Name = "Snow Speed",
        Flag = "SnowSpeed",
        Min = 10,
        Max = 100,
        Default = 30,
        Callback = function(p48)
    t1.value58.Speed = p48
end
})
local Option4 = v54.Option
local color3_6 = Color3.fromRGB(255, 255, 255)

Option4:AddColorPicker({
        Name = "Snow Color",
        Flag = "SnowColor",
        Default = color3_6,
        Callback = function(p49)
    t1.value58.Color = p49
end
})
Option4:AddDropdown({
        Name = "Snow Style",
        Flag = "SnowStyle",
        Values = {
                "Line",
                "Realistic"
        },
        Default = getgenv().SnowStyle or "Realistic",
        Callback = function(val)
    getgenv().SnowStyle = val
    for _, v in pairs(t1.value56) do
        pcall(function() v:Destroy() end)
    end
    table.clear(t1.value56)
end
})
t1.value53.RenderStepped:Connect(function()
    if t1.value59.Type == "Rain" then
        if #t1.value55 < t1.value57.Density then
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.Color = t1.value57.Color
            Part.Material = Enum.Material.Glass
            Part.Size = Vector3.new(0.05, 1, 0.05)
            Part.Transparency = 0.1
            Part.Parent = t1.value1
            table.insert(t1.value55, Part)
        end

        for _, v in pairs(t1.value55) do
            if v and v.Parent then
                if v.Position.Y < t1.value54.CFrame.Position.Y - 50 then
                    v.Position = t1.value54.CFrame.Position + Vector3.new(math.random(-50, 50), 50, math.random(-50, 50))
                else
                    local s2 = "Position"
                    local vector3 = Vector3.new(0, t1.value57.Speed * t1.value53.RenderStepped:Wait(), 0)

                    v[s2] = v[s2] - vector3
                end
            end
        end
    end

    if t1.value59.Type == "Snow" then
        local style = getgenv().SnowStyle or "Realistic"
        local snowDt = t1.value53.RenderStepped:Wait()
        if #t1.value56 < t1.value58.Density then
            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.CanCollide = false
            Part.CanQuery = false
            Part.Color = t1.value58.Color
            Part.Material = Enum.Material.Neon
            if style == "Line" then
                -- падают строчкой
                Part.Size = Vector3.new(0.06, 2.2, 0.06)
                Part.Transparency = 0.3
            else
                -- как в реальной жизни: хлопья с дрейфом
                Part.Shape = Enum.PartType.Ball
                Part.Size = Vector3.new(t1.value58.Size, t1.value58.Size, t1.value58.Size)
                Part.Transparency = 0.2
            end
            Part.Parent = t1.value1
            Part:SetAttribute("SnowSeed", math.random() * math.pi * 2)
            table.insert(t1.value56, Part)
        end

        for _, v in pairs(t1.value56) do
            if v and v.Parent then
                if v.Position.Y < t1.value54.CFrame.Position.Y - 30 then
                    v.Position = t1.value54.CFrame.Position + Vector3.new(math.random(-60, 60), 60, math.random(-60, 60))
                else
                    local fall = Vector3.new(0, t1.value58.Speed * snowDt, 0)
                    if style == "Realistic" then
                        local seed = v:GetAttribute("SnowSeed") or 0
                        fall += Vector3.new(math.sin(tick() * 1.5 + seed) * snowDt * 6, 0, math.cos(tick() * 1.1 + seed) * snowDt * 4)
                    end
                    v.Position -= fall
                end
            end
        end
    end
end)
t1.value61 = game:GetService("Lighting")

local t3 = {
        SkyboxLf = "rbxassetid://12173273102",
        SkyboxUp = "rbxassetid://12173274627",
        SkyboxDn = "rbxassetid://12173271252",
        SkyboxBk = "rbxassetid://12173268397",
        SkyboxRt = "rbxassetid://12173273903",
        SkyboxFt = "rbxassetid://12173272214"
}
local t4 = {
        SkyboxLf = "rbxassetid://17124365127",
        SkyboxUp = "rbxassetid://17124369657",
        SkyboxDn = "rbxassetid://17124359797",
        SkyboxBk = "rbxassetid://17124357467",
        SkyboxRt = "rbxassetid://17124367200",
        SkyboxFt = "rbxassetid://17124362093"
}
local t5 = {
        SkyboxLf = "rbxassetid://154184943",
        SkyboxUp = "rbxassetid://154185031",
        SkyboxDn = "rbxassetid://154184960",
        SkyboxBk = "rbxassetid://154185004",
        SkyboxRt = "rbxassetid://154184972",
        SkyboxFt = "rbxassetid://154185021"
}
local function skyset(id)
        return {
                SkyboxLf = "rbxassetid://" .. id,
                SkyboxUp = "rbxassetid://" .. id,
                SkyboxDn = "rbxassetid://" .. id,
                SkyboxBk = "rbxassetid://" .. id,
                SkyboxRt = "rbxassetid://" .. id,
                SkyboxFt = "rbxassetid://" .. id
        }
end
-- Nebula: заглушка. Вставь свой decal id вместо "0" (toolbox -> skybox -> copy asset id)
local t6 = {
        ["Two moon"] = t3,
        Aurora = t4,
        Night = t5,
        Galaxy = skyset("159454299"),
        ["Deep Space"] = skyset("77384233173949"),
        Skeleton = skyset("16000894791"),
        ["Classic Blue"] = skyset("144933338"),
        Nebula = skyset("0"),
        Default = nil
}
t1.value62 = nil
t1.value62 = t6
function t1.value63(p50)
    local CustomSky = t1.value61:FindFirstChild("CustomSky")

    if CustomSky then
        CustomSky:Destroy()
    end

    local v269 = t1.value62[p50]

    if v269 then
        local Sky = Instance.new("Sky")

        Sky.Name = "CustomSky"

        for k, v in pairs(v269) do
            Sky[k] = v
        end

        Sky.Parent = t1.value61
    end
end
v19:AddDropdown({
        Name = "Skybox",
        Flag = "Skybox",
        Values = {
                "Default",
                "Two moon",
                "Aurora",
                "Night",
                "Galaxy",
                "Deep Space",
                "Skeleton",
                "Classic Blue",
                "Nebula"
        },
        Default = "Default",
        Callback = function(p51)
    t1.value63(p51)
end
})
game:GetService("RunService").RenderStepped:Connect(function()
    local CustomSky = t1.value61:FindFirstChild("CustomSky")

    if CustomSky then
        CustomSky.Parent = t1.value61
    end
end)
t1.value64 = game:GetService("Lighting")

local RunService2 = game:GetService("RunService")

t1.value65 = 3000
t1.value66 = 3000
v19:AddSlider({
        Name = "FogStart",
        Flag = "FogStart",
        Min = 1,
        Max = 3000,
        Default = 3000,
        Callback = function(p52)
    t1.value65 = p52
    t1.value64.FogStart = p52
end
})
v19:AddSlider({
        Name = "FogEnd",
        Flag = "FogEnd",
        Min = 1,
        Max = 3000,
        Default = 3000,
        Callback = function(p53)
    t1.value66 = p53
    t1.value64.FogEnd = p53
end
})
RunService2.RenderStepped:Connect(function()
    if t1.value64.FogStart ~= t1.value65 then
        t1.value64.FogStart = t1.value65
    end

    if t1.value64.FogEnd ~= t1.value66 then
        t1.value64.FogEnd = t1.value66
    end
end)
t1.value67 = game:GetService("Lighting")
t1.value68 = false
t1.value69 = Color3.fromRGB(170, 170, 255)

local Option5 = v19:AddToggle({
        Name = "World",
        Flag = "World",
        Option = true,
        Default = false,
        Callback = function(p54)
    t1.value68 = p54

    if p54 then
        t1.value67.Ambient = t1.value69
        t1.value67.OutdoorAmbient = t1.value69

        return
    end

    t1.value67.Ambient = Color3.fromRGB(127, 127, 127)
    t1.value67.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
end
}).Option
local color3_7 = Color3.fromRGB(170, 170, 255)

Option5:AddColorPicker({
        Name = "World color",
        Flag = "WorldColors",
        Default = color3_7,
        Callback = function(p55)
    if t1.value68 then
        t1.value67.Ambient = p55
        t1.value67.OutdoorAmbient = p55
    end
end
})
local Players2 = game:GetService("Players")
local RunService3 = game:GetService("RunService")

t1.value71 = t1.value1.CurrentCamera
t1.value72 = Players2.LocalPlayer
t1.value73 = {}
t1.value74 = {}
t1.value75 = {}
t1.value75b = {}
t1.value75c = {}
local function v69(p57)
    if p57 == t1.value72 then
        return
    end

    if t1.value73[p57] then
        return
    end

    local drawing = Drawing.new("Square")

    drawing.Visible = false
    drawing.Color = Color3.new(1, 1, 1)
    drawing.Thickness = 1
    drawing.Filled = false
    t1.value73[p57] = drawing

    local drawing2 = Drawing.new("Square")

    drawing2.Visible = false
    drawing2.Filled = true
    drawing2.Thickness = 1
    t1.value74[p57] = drawing2

    local drawing3 = Drawing.new("Text")

    drawing3.Visible = false
    drawing3.Color = Color3.new(1, 1, 1)
    drawing3.Size = 8
    drawing3.Center = true
    drawing3.Outline = true
    drawing3.OutlineColor = Color3.new(0, 0, 0)
    t1.value75[p57] = drawing3

    local drawing4 = Drawing.new("Text")

    drawing4.Visible = false
    drawing4.Color = Color3.new(1, 1, 1)
    drawing4.Size = 8
    drawing4.Center = true
    drawing4.Outline = true
    drawing4.OutlineColor = Color3.new(0, 0, 0)
    t1.value75b[p57] = drawing4

    local drawingF = Drawing.new("Square")

    drawingF.Visible = false
    drawingF.Filled = true
    drawingF.Thickness = 1
    t1.value75c[p57] = drawingF
end
local GetPlayers = Players2.GetPlayers
Players2.PlayerRemoving:Connect(function(player)
    if t1.value73[player] then
        t1.value73[player]:Remove()
        t1.value73[player] = nil
    end

    if t1.value74[player] then
        t1.value74[player]:Remove()
        t1.value74[player] = nil
    end

    if t1.value75[player] then
        t1.value75[player]:Remove()
        t1.value75[player] = nil
    end
    if t1.value75b[player] then
        t1.value75b[player]:Remove()
        t1.value75b[player] = nil
    end

    if t1.value75c[player] then
        t1.value75c[player]:Remove()
        t1.value75c[player] = nil
    end
end)

for _, v in ipairs(GetPlayers(Players2)) do
    v69(v)
end
Players2.PlayerAdded:Connect(v69)
RunService3.RenderStepped:Connect(function()
    for k, v in pairs(t1.value73) do
        local v323 = k
        local Character = v323.Character
        local v325 = Character and Character:FindFirstChild("HumanoidRootPart")
        local v326 = Character and Character:FindFirstChild("Humanoid")
        local v327 = v325
        local v328 = t1.value74[v323]
        local v329 = t1.value75[v323]

        local v329b = t1.value75b[v323]
        if v325 then
            v327 = v326 and v326.Health > 0
        end

        if v327 then
            if _G.ESP_TeamCheck and (v323.Team ~= nil and t1.value72.Team ~= nil) and v323.Team == t1.value72.Team then
                if v then
                    v.Visible = false
                end

                if v328 then
                    v328.Visible = false
                end

                if v329 then
                    v329.Visible = false; if v329b then v329b.Visible = false end
                end
            else
                local v330, v331 = t1.value71:WorldToViewportPoint(v325.Position)

                if v331 then
                    -- bbox по модели: box сидит ровно на игроке, без смещения на большое расстояние
                    local v333
                    local okBB, bbCf, bbSz = pcall(Character.GetBoundingBox, Character)

                    if okBB and bbCf and bbSz and bbSz.Y > 0 then
                        local topS = t1.value71:WorldToViewportPoint((bbCf * CFrame.new(0, bbSz.Y / 2, 0)).Position)
                        local botS = t1.value71:WorldToViewportPoint((bbCf * CFrame.new(0, -bbSz.Y / 2, 0)).Position)

                        v333 = math.abs(topS.Y - botS.Y)
                        v330 = Vector3.new((topS.X + botS.X) / 2, (topS.Y + botS.Y) / 2, topS.Z)
                    else
                        local v332 = t1.value71:WorldToViewportPoint(v325.Position + Vector3.new(0, v326.HipHeight * 2 + 3, 0))

                        v333 = math.abs(t1.value71:WorldToViewportPoint(v325.Position - Vector3.new(0, v326.HipHeight * 2 + 3, 0)).Y - v332.Y)
                    end

                    if v333 < 6 then
                        v333 = 6
                    end

                    local v334 = v333 / 2.3

                    if _G.ESP_Box_Enabled then
                        v.Size = Vector2.new(v334, v333)
                        v.Position = Vector2.new(v330.X - v334 / 2, v330.Y - v333 / 2)
                        v.Color = _G.ESP_Box_Color or Color3.new(1, 1, 1)
                        v.Visible = true
                    else
                        v.Visible = false
                    end

                    local vF = t1.value75c[v323]

                    if _G.ESP_Fill_Enabled and vF then
                        vF.Size = Vector2.new(v334, v333)
                        vF.Position = Vector2.new(v330.X - v334 / 2, v330.Y - v333 / 2)
                        vF.Color = _G.ESP_Fill_Color or Color3.fromRGB(255, 255, 255)
                        vF.Visible = true
                    elseif vF then
                        vF.Visible = false
                    end

                    if _G.ESP_Health_Enabled then
                        local v335 = math.clamp(v326.Health / v326.MaxHealth, 0, 1)
                        local v336 = 1 - v335

                        if _G.ESP_Health_Color then
                            v328.Color = Color3.new(1, 0, 0):Lerp(_G.ESP_Health_Color, v335)
                        else
                            v328.Color = Color3.new(v336, v335, 0)
                        end

                        local v337 = v333 * v335

                        if v337 < 2 then
                            v337 = 2
                        end

                        local v338 = v330.X - v334 / 2 - 3
                        local v339 = v330.Y - v333 / 2 + (v333 - v337)

                        v328.Size = Vector2.new(2, v337)
                        v328.Position = Vector2.new(v338, v339)
                        v328.Visible = true
                    else
                        v328.Visible = false
                    end

                    if _G.ESP_Name_Enabled then
                        v329.Text = v323.Name
                        v329.Position = Vector2.new(v330.X, v330.Y - v333 / 2 - 15)
                        v329.Visible = true
                    else
                        v329.Visible = false; if v329b then v329b.Visible = false end
                    end

                    if _G.ESP_Dist_Enabled and v329b then
                        v329b.Text = math.floor((v325.Position - t1.value71.CFrame.Position).Magnitude + 0.5) .. "m"
                        v329b.Position = Vector2.new(v330.X, v330.Y + v333 / 2 + 2)
                        v329b.Visible = true
                    elseif v329b then
                        v329b.Visible = false
                    end
                else
                    v.Visible = false
                    v328.Visible = false
                    v329.Visible = false; if v329b then v329b.Visible = false end
                end
            end
        else
            v.Visible = false

            if v328 then
                v328.Visible = false
            end

            if v329 then
                v329.Visible = false; if v329b then v329b.Visible = false end
            end
        end
    end
end)
v18:AddDropdown({
        Name = "ESP",
        Flag = "Esp",
        Multi = true,
        Values = {
                "Box",
                "Name",
                "Health",
                "Distance"
        },
        Callback = function(p58)
    _G.ESP_Box_Enabled = p58.Box or false
    _G.ESP_Name_Enabled = p58.Name or false
    _G.ESP_Health_Enabled = p58.Health or false
    _G.ESP_Dist_Enabled = p58.Distance or false
end
})
t1.value76 = game:GetService("Players")

-- ============================================================
-- [ESP TAB] отдельная вкладка ESP: box, health bar, fill, цвета, team check
-- ============================================================
do
    -- значения по умолчанию для цветов
    _G.ESP_Box_Color = _G.ESP_Box_Color or Color3.fromRGB(255, 255, 255)
    _G.ESP_Health_Color = _G.ESP_Health_Color or Color3.fromRGB(0, 255, 120)
    _G.ESP_Fill_Color = _G.ESP_Fill_Color or Color3.fromRGB(255, 255, 255)
    _G.ESP_TeamCheck = _G.ESP_TeamCheck or false

    local secE = t1.mESP:AddSection({ Position = "left", Name = "ESP" })
    secE:AddToggle({
        Name = "Box",
        Flag = "ESP_BoxTab",
        Default = false,
        Callback = function(p) _G.ESP_Box_Enabled = p end
    })
    secE:AddToggle({
        Name = "Health Bar",
        Flag = "ESP_HealthTab",
        Default = false,
        Callback = function(p) _G.ESP_Health_Enabled = p end
    })
    secE:AddToggle({
        Name = "Fill Box",
        Flag = "ESP_Fill",
        Default = false,
        Callback = function(p) _G.ESP_Fill_Enabled = p end
    })
    secE:AddToggle({
        Name = "Name",
        Flag = "ESP_NameTab",
        Default = false,
        Callback = function(p) _G.ESP_Name_Enabled = p end
    })
    secE:AddToggle({
        Name = "Distance",
        Flag = "ESP_DistTab",
        Default = false,
        Callback = function(p) _G.ESP_Dist_Enabled = p end
    })
    secE:AddToggle({
        Name = "Team Check",
        Flag = "ESP_TeamCheck",
        Default = false,
        Callback = function(p) _G.ESP_TeamCheck = p end
    })

    local secC = t1.mESP:AddSection({ Position = "center", Name = "COLORS" })
    secC:AddColorPicker({
        Name = "Box Color",
        Flag = "ESP_BoxColor",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(c) _G.ESP_Box_Color = c end
    })
    secC:AddColorPicker({
        Name = "Health Bar Color",
        Flag = "ESP_HealthColor",
        Default = Color3.fromRGB(0, 255, 120),
        Callback = function(c) _G.ESP_Health_Color = c end
    })
    secC:AddColorPicker({
        Name = "Fill Color",
        Flag = "ESP_FillColor",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(c) _G.ESP_Fill_Color = c end
    })
end
t1.value77 = t1.value76.LocalPlayer
t1.value78 = t1.value1.CurrentCamera
local RunService4 = game:GetService("RunService")

t1.value79 = false
t1.value80 = Color3.fromRGB(170, 170, 255)

local color3_34 = Color3.fromRGB(170, 100, 255)

t1.value81 = nil
t1.value82 = nil
t1.value81 = color3_34
t1.value82 = {}
function t1.value83(p59)
    if not p59 then
        return false
    end

    local CFramePosition = t1.value78.CFrame.Position
    local v359 = (p59.Position - CFramePosition).Unit * (p59.Position - CFramePosition).Magnitude
    local ray = Ray.new(CFramePosition, v359)
    local PartOnRayWithIgnoreList = t1.value1:FindPartOnRayWithIgnoreList(ray, { t1.value77.Character })
    local v362 = not PartOnRayWithIgnoreList

    if not v362 then
        v362 = PartOnRayWithIgnoreList:IsDescendantOf(p59.Parent)
    end

    return v362
end
function t1.value84(p60)
    if not p60 or not p60:FindFirstChild("HumanoidRootPart") then
        return
    end
    if not t1.value82[p60] then
        t1.value82[p60] = {}

        local GetDescendants = p60.GetDescendants

        for _, v in pairs(GetDescendants(p60)) do
            if v:IsA("BasePart") or v:IsA("MeshPart") then
                local v345 = t1.value82[p60]
                local vColor = v.Color
                local vMaterial = v.Material
                local vTransparency = v.Transparency

                v345[v] = {
                                        Color = vColor,
                                        Material = vMaterial,
                                        Transparency = vTransparency
                                }
            elseif v:IsA("Decal") or v:IsA("Texture") then
                t1.value82[p60][v] = {
                                        Transparency = v.Transparency
                                }
            elseif v:IsA("Shirt") or (v:IsA("Pants") or v:IsA("BodyColors")) then
                t1.value82[p60][v] = {
                                        Parent = v.Parent
                                }
            elseif v:IsA("Accessory") then
                t1.value82[p60][v] = {
                                        Parent = v.Parent
                                }
            end
        end
    end
    for v351, v352 in pairs(p60:GetDescendants()) do

        if v352:IsA("Decal") or v352:IsA("Texture") then
            v352.Transparency = 1
        elseif v352:IsA("Shirt") or (v352:IsA("Pants") or (v352:IsA("BodyColors") or v352:IsA("Accessory"))) then
            v352.Parent = nil
        end
    end
    local GetDescendants = p60.GetDescendants
    for _, v in pairs(GetDescendants(p60)) do
        if v:IsA("BasePart") or v:IsA("MeshPart") and v.Transparency < 1 then
            v.Material = Enum.Material.Neon
            v.Color = t1.value80
            v.Transparency = 0.3
        end
    end
    if not p60:FindFirstChild("ChamsHighlight") then
        local Highlight = Instance.new("Highlight")

        Highlight.Name = "ChamsHighlight"
        Highlight.FillTransparency = 0
        Highlight.OutlineTransparency = 1
        Highlight.Enabled = false
        Highlight.FillColor = t1.value81
        Highlight.Adornee = p60
        Highlight.Parent = p60
    end
end
function t1.value85(p61)
    if not p61 or not t1.value82[p61] then
        return
    end

    for k, v in pairs(t1.value82[p61]) do
        local v370 = k

        if v370:IsA("BasePart") or v370:IsA("MeshPart") and v.Transparency < 1 then
            v370.Color = v.Color
            v370.Material = v.Material
            v370.Transparency = v.Transparency
        elseif v370:IsA("Decal") or v370:IsA("Texture") then
            v370.Transparency = v.Transparency
        else
            v370.Parent = v.Parent
        end
    end

    local ChamsHighlight = p61:FindFirstChild("ChamsHighlight")

    if ChamsHighlight then
        ChamsHighlight:Destroy()
    end

    t1.value82[p61] = nil
end
function t1.value86()
    for _, player in pairs(t1.value76:GetPlayers()) do
        if player ~= t1.value77 and (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
            local v365 = t1.value83(player.Character.HumanoidRootPart)
            local ChamsHighlight = player.Character:FindFirstChild("ChamsHighlight")

            if ChamsHighlight then
                ChamsHighlight.Enabled = not v365
            end
        end
    end
end
local function v75(p62)
    p62.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        task.wait(0.1)

        if t1.value79 then
            t1.value84(character)
        end
    end)

    if p62.Character and t1.value79 then
        t1.value84(p62.Character)
    end
end
for _, player in pairs(t1.value76:GetPlayers()) do
    if player ~= t1.value77 then
        v75(player)
    end
end
t1.value76.PlayerAdded:Connect(v75)
t1.value76.PlayerRemoving:Connect(function(player)
    if player.Character then
        t1.value85(player.Character)
    end
end)
RunService4.RenderStepped:Connect(function()
    if t1.value79 then
        t1.value86()
    end
end)

local v78 = v18:AddToggle({
        Name = "Chams",
        Flag = "Chams",
        Default = false,
        Option = true,
        Callback = function(p63)
    t1.value79 = p63

    if p63 then
        for _, player in pairs(t1.value76:GetPlayers()) do
            if player ~= t1.value77 and player.Character then
                t1.value84(player.Character)
            end
        end

        return
    end

    for _, player in pairs(t1.value76:GetPlayers()) do
        if player ~= t1.value77 and player.Character then
            t1.value85(player.Character)
        end
    end
end
})
local Option6 = v78.Option
local AddColorPicker3 = Option6.AddColorPicker
local color3_35 = Color3.fromRGB(170, 170, 255)

AddColorPicker3(Option6, {
        Name = "Visible",
        Flag = "ChamsColor",
        Default = color3_35,
        Callback = function(p64)
    t1.value80 = p64
end
})
local Option7 = v78.Option
local AddColorPicker4 = Option7.AddColorPicker
local color3_36 = Color3.fromRGB(170, 100, 255)

AddColorPicker4(Option7, {
        Name = "Invisible",
        Flag = "ThroughwallChamsColor",
        Default = color3_36,
        Callback = function(p65)
    t1.value81 = p65
end
})
local Players3 = game:GetService("Players")

t1.value87 = t1.value1.CurrentCamera
t1.value88 = Players3.LocalPlayer
t1.value89 = false
t1.value90 = 6
t1.value91 = t1.value88.CameraMaxZoomDistance
t1.value92 = t1.value88.CameraMinZoomDistance
t1.value93 = false
t1.value94 = 170
t1.value95 = t1.value87.FieldOfView
function t1.value96()
    if not t1.value88.Character then
        return
    end

    if not t1.value88.Character:FindFirstChildOfClass("Humanoid") then
        return
    end

    if t1.value89 then
        t1.value88.CameraMode = Enum.CameraMode.Classic
        t1.value88.CameraMaxZoomDistance = t1.value90
        t1.value88.CameraMinZoomDistance = t1.value90

        return
    end

    t1.value88.CameraMode = Enum.CameraMode.LockFirstPerson
    t1.value88.CameraMaxZoomDistance = t1.value91
    t1.value88.CameraMinZoomDistance = t1.value92
end
function t1.value97()
    if t1.value93 then
        t1.value87.FieldOfView = t1.value94

        return
    end

    t1.value87.FieldOfView = t1.value95
end
t1.value88.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    character:WaitForChild("HumanoidRootPart")
    task.wait(0.25)
    t1.value96()
    t1.value97()
end)
v17:AddToggle({
        Name = "Thirdperson",
        Flag = "Thirdperson",
        Default = false,
        Option = true,
        Callback = function(p66)
    t1.value89 = p66
    t1.value96()
end
}).Option:AddDropdown({
        Name = "Activation",
        Flag = "ThirdpersonActivation",
        Values = {
                "Always on",
                "K",
                "O",
                "P"
        },
        Default = "Always on",
        Callback = function(p67)
    if t1.value89 then
        if p67 == "Always on" then
            t1.value96()

            return
        end

        t1.value89 = false
        t1.value96()
    end
end
})
v17:AddSlider({
        Name = "Distance",
        Flag = "ThirdpersonDistance",
        Min = 1,
        Max = 6,
        Default = 6,
        Callback = function(p68)
    t1.value90 = p68

    if t1.value89 then
        t1.value96()
    end
end
})
local Players4 = game:GetService("Players")
local RunService5 = game:GetService("RunService")

t1.value98 = game:GetService("Workspace")
t1.value99 = Players4.LocalPlayer
t1.value100 = t1.value98.CurrentCamera
t1.value101 = false
t1.value102 = nil
local function v88()
    t1.value102 = (t1.value99.Character or t1.value99.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
end
v88()
t1.value99.CharacterAdded:Connect(v88)
v17:AddToggle({
        Name = "Yaw",
        Flag = "Spinbot",
        Default = false,
        Callback = function(p69)
    t1.value101 = p69
end
})

-- ============================================================================
-- SPIN MODULE (Basic Spin, Jitler, Yitler)
-- ============================================================================
local OriginalJointsCache = {}

local function SaveOriginalJoint(motor)
    if motor and motor:IsA("Motor6D") and not OriginalJointsCache[motor] then
        OriginalJointsCache[motor] = motor.C0
    end
end

local function RestoreCharacterJoints(char)
    if not char then return end
    for motor, origC0 in pairs(OriginalJointsCache) do
        if motor and motor.Parent then
            motor.C0 = origC0
        end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = true
    end
end

local function ApplyPoseMode(char, mode, tickVal)
    if not char then return end
    local torso = char:FindFirstChild("Torso")
    local upperTorso = char:FindFirstChild("UpperTorso")

    if mode ~= "Jitler" and mode ~= "Yitler" then
        for motor, origC0 in pairs(OriginalJointsCache) do
            if motor and motor.Parent then
                motor.C0 = origC0
            end
        end
        return
    end

    -- ноги сгибаются только в воздухе (прыжок/падение)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local airborne = hum and (hum.FloorMaterial == Enum.Material.Air
        or hum:GetState() == Enum.HumanoidStateType.Freefall
        or hum:GetState() == Enum.HumanoidStateType.Jumping)

    if torso then
        -- R6 персонаж
        local neck = torso:FindFirstChild("Neck")
        local rShoulder = torso:FindFirstChild("Right Shoulder")
        local lShoulder = torso:FindFirstChild("Left Shoulder")
        local rHip = torso:FindFirstChild("Right Hip")
        local lHip = torso:FindFirstChild("Left Hip")

        for _, m in ipairs({neck, rShoulder, lShoulder, rHip, lHip}) do
            SaveOriginalJoint(m)
        end

        if mode == "Jitler" then
            -- статичная поза: руки просто вверх, без тряски
            if neck and OriginalJointsCache[neck] then
                neck.C0 = OriginalJointsCache[neck]
            end
            if rShoulder and OriginalJointsCache[rShoulder] then
                rShoulder.C0 = OriginalJointsCache[rShoulder] * CFrame.Angles(0, 0, math.rad(165))
            end
            if lShoulder and OriginalJointsCache[lShoulder] then
                lShoulder.C0 = OriginalJointsCache[lShoulder] * CFrame.Angles(0, 0, -math.rad(165))
            end
            if rHip and OriginalJointsCache[rHip] then rHip.C0 = OriginalJointsCache[rHip] end
            if lHip and OriginalJointsCache[lHip] then lHip.C0 = OriginalJointsCache[lHip] end
        elseif mode == "Yitler" then
            -- руки вверх статично, ноги сгибаются в коленях только когда прыгаешь
            if neck and OriginalJointsCache[neck] then
                neck.C0 = OriginalJointsCache[neck]
            end
            if rShoulder and OriginalJointsCache[rShoulder] then
                rShoulder.C0 = OriginalJointsCache[rShoulder] * CFrame.Angles(0, 0, math.rad(160))
            end
            if lShoulder and OriginalJointsCache[lShoulder] then
                lShoulder.C0 = OriginalJointsCache[lShoulder] * CFrame.Angles(0, 0, -math.rad(160))
            end
            if airborne then
                if rHip and OriginalJointsCache[rHip] then
                    rHip.C0 = OriginalJointsCache[rHip] * CFrame.new(0, 0.45, -0.35) * CFrame.Angles(-math.rad(70), 0, -math.rad(30))
                end
                if lHip and OriginalJointsCache[lHip] then
                    lHip.C0 = OriginalJointsCache[lHip] * CFrame.new(0, 0.45, -0.35) * CFrame.Angles(-math.rad(70), 0, math.rad(30))
                end
            else
                if rHip and OriginalJointsCache[rHip] then rHip.C0 = OriginalJointsCache[rHip] end
                if lHip and OriginalJointsCache[lHip] then lHip.C0 = OriginalJointsCache[lHip] end
            end
        end
    elseif upperTorso then
        -- R15 персонаж
        local neck = char:FindFirstChild("Head") and char.Head:FindFirstChild("Neck") or upperTorso:FindFirstChild("Neck")
        local rShoulder = char:FindFirstChild("RightUpperArm") and char.RightUpperArm:FindFirstChild("RightShoulder")
        local lShoulder = char:FindFirstChild("LeftUpperArm") and char.LeftUpperArm:FindFirstChild("LeftShoulder")
        local rHip = char:FindFirstChild("RightUpperLeg") and char.RightUpperLeg:FindFirstChild("RightHip")
        local lHip = char:FindFirstChild("LeftUpperLeg") and char.LeftUpperLeg:FindFirstChild("LeftHip")
        local rKnee = char:FindFirstChild("RightLowerLeg") and char.RightLowerLeg:FindFirstChild("RightKnee")
        local lKnee = char:FindFirstChild("LeftLowerLeg") and char.LeftLowerLeg:FindFirstChild("LeftKnee")

        for _, m in ipairs({neck, rShoulder, lShoulder, rHip, lHip, rKnee, lKnee}) do
            SaveOriginalJoint(m)
        end

        if mode == "Jitler" then
            if neck and OriginalJointsCache[neck] then
                neck.C0 = OriginalJointsCache[neck]
            end
            if rShoulder and OriginalJointsCache[rShoulder] then
                rShoulder.C0 = OriginalJointsCache[rShoulder] * CFrame.Angles(math.rad(170), 0, math.rad(15))
            end
            if lShoulder and OriginalJointsCache[lShoulder] then
                lShoulder.C0 = OriginalJointsCache[lShoulder] * CFrame.Angles(math.rad(170), 0, -math.rad(15))
            end
            if rHip and OriginalJointsCache[rHip] then rHip.C0 = OriginalJointsCache[rHip] end
            if lHip and OriginalJointsCache[lHip] then lHip.C0 = OriginalJointsCache[lHip] end
            if rKnee and OriginalJointsCache[rKnee] then rKnee.C0 = OriginalJointsCache[rKnee] end
            if lKnee and OriginalJointsCache[lKnee] then lKnee.C0 = OriginalJointsCache[lKnee] end
        elseif mode == "Yitler" then
            if neck and OriginalJointsCache[neck] then
                neck.C0 = OriginalJointsCache[neck]
            end
            if rShoulder and OriginalJointsCache[rShoulder] then
                rShoulder.C0 = OriginalJointsCache[rShoulder] * CFrame.Angles(math.rad(165), 0, math.rad(20))
            end
            if lShoulder and OriginalJointsCache[lShoulder] then
                lShoulder.C0 = OriginalJointsCache[lShoulder] * CFrame.Angles(math.rad(165), 0, -math.rad(20))
            end
            if airborne then
                -- сгиб ног в бедрах и коленях в воздухе
                if rHip and OriginalJointsCache[rHip] then
                    rHip.C0 = OriginalJointsCache[rHip] * CFrame.Angles(math.rad(65), 0, math.rad(10))
                end
                if lHip and OriginalJointsCache[lHip] then
                    lHip.C0 = OriginalJointsCache[lHip] * CFrame.Angles(math.rad(65), 0, -math.rad(10))
                end
                if rKnee and OriginalJointsCache[rKnee] then
                    rKnee.C0 = OriginalJointsCache[rKnee] * CFrame.Angles(-math.rad(110), 0, 0)
                end
                if lKnee and OriginalJointsCache[lKnee] then
                    lKnee.C0 = OriginalJointsCache[lKnee] * CFrame.Angles(-math.rad(110), 0, 0)
                end
            else
                if rHip and OriginalJointsCache[rHip] then rHip.C0 = OriginalJointsCache[rHip] end
                if lHip and OriginalJointsCache[lHip] then lHip.C0 = OriginalJointsCache[lHip] end
                if rKnee and OriginalJointsCache[rKnee] then rKnee.C0 = OriginalJointsCache[rKnee] end
                if lKnee and OriginalJointsCache[lKnee] then lKnee.C0 = OriginalJointsCache[lKnee] end
            end
        end
    end
end

-- прогиб спины для Undo Back: применяется только на время разворота (~1.2 с)
local function ApplyBendPose(char, bend)
    if not char then return end
    local torso = char:FindFirstChild("Torso")

    if torso then
        local neck = torso:FindFirstChild("Neck")
        local rShoulder = torso:FindFirstChild("Right Shoulder")
        local lShoulder = torso:FindFirstChild("Left Shoulder")
        local rHip = torso:FindFirstChild("Right Hip")
        local lHip = torso:FindFirstChild("Left Hip")

        for _, m in ipairs({neck, rShoulder, lShoulder, rHip, lHip}) do
            SaveOriginalJoint(m)
        end

        if neck and OriginalJointsCache[neck] then
            neck.C0 = OriginalJointsCache[neck] * CFrame.Angles(-math.rad(bend * 0.4), 0, 0)
        end
        if rShoulder and OriginalJointsCache[rShoulder] then
            rShoulder.C0 = OriginalJointsCache[rShoulder] * CFrame.Angles(-math.rad(bend), 0, math.rad(10))
        end
        if lShoulder and OriginalJointsCache[lShoulder] then
            lShoulder.C0 = OriginalJointsCache[lShoulder] * CFrame.Angles(-math.rad(bend), 0, -math.rad(10))
        end
        if rHip and OriginalJointsCache[rHip] then
            rHip.C0 = OriginalJointsCache[rHip] * CFrame.Angles(math.rad(bend * 0.5), 0, math.rad(5))
        end
        if lHip and OriginalJointsCache[lHip] then
            lHip.C0 = OriginalJointsCache[lHip] * CFrame.Angles(math.rad(bend * 0.5), 0, -math.rad(5))
        end
    else
        local upperTorso = char:FindFirstChild("UpperTorso")
        if not upperTorso then return end
        local neck = char:FindFirstChild("Head") and char.Head:FindFirstChild("Neck") or upperTorso:FindFirstChild("Neck")
        local rShoulder = char:FindFirstChild("RightUpperArm") and char.RightUpperArm:FindFirstChild("RightShoulder")
        local lShoulder = char:FindFirstChild("LeftUpperArm") and char.LeftUpperArm:FindFirstChild("LeftShoulder")
        local rHip = char:FindFirstChild("RightUpperLeg") and char.RightUpperLeg:FindFirstChild("RightHip")
        local lHip = char:FindFirstChild("LeftUpperLeg") and char.LeftUpperLeg:FindFirstChild("LeftHip")
        local rKnee = char:FindFirstChild("RightLowerLeg") and char.RightLowerLeg:FindFirstChild("RightKnee")
        local lKnee = char:FindFirstChild("LeftLowerLeg") and char.LeftLowerLeg:FindFirstChild("LeftKnee")

        for _, m in ipairs({neck, rShoulder, lShoulder, rHip, lHip, rKnee, lKnee}) do
            SaveOriginalJoint(m)
        end

        if neck and OriginalJointsCache[neck] then
            neck.C0 = OriginalJointsCache[neck] * CFrame.Angles(-math.rad(bend * 0.4), 0, 0)
        end
        if rShoulder and OriginalJointsCache[rShoulder] then
            rShoulder.C0 = OriginalJointsCache[rShoulder] * CFrame.Angles(-math.rad(bend), 0, math.rad(10))
        end
        if lShoulder and OriginalJointsCache[lShoulder] then
            lShoulder.C0 = OriginalJointsCache[lShoulder] * CFrame.Angles(-math.rad(bend), 0, -math.rad(10))
        end
        if rHip and OriginalJointsCache[rHip] then
            rHip.C0 = OriginalJointsCache[rHip] * CFrame.Angles(math.rad(bend * 0.5), 0, math.rad(5))
        end
        if lHip and OriginalJointsCache[lHip] then
            lHip.C0 = OriginalJointsCache[lHip] * CFrame.Angles(math.rad(bend * 0.5), 0, -math.rad(5))
        end
        if rKnee and OriginalJointsCache[rKnee] then
            rKnee.C0 = OriginalJointsCache[rKnee] * CFrame.Angles(math.rad(bend * 0.4), 0, 0)
        end
        if lKnee and OriginalJointsCache[lKnee] then
            lKnee.C0 = OriginalJointsCache[lKnee] * CFrame.Angles(math.rad(bend * 0.4), 0, 0)
        end
    end
end

-- ============================================================
-- [SPIN] section (MOVEMENT tab): mode picker is always visible
-- modes: Basic Spin, Jitler, Yitler, Sway, Static Jitter
-- ============================================================
local LastDeathPos = nil
local UndoUntil = 0 -- one-shot: разворот к убитому держится ~1.2 с, потом снимается
do
    local sec = t1.mMove:AddSection({ Position = "center", Name = "SPIN" })
    local modes = { "Basic Spin", "Jitler", "Yitler", "Sway", "Static Jitter", "Undo", "Back", "Undo Back" }
    if not table.find(modes, getgenv().SpinMode) then getgenv().SpinMode = "Basic Spin" end

    local function restore()
        if t1.value99.Character then RestoreCharacterJoints(t1.value99.Character) end
    end

    sec:AddToggle({
        Name = "Enable",
        Flag = "CustomSpinEnabled",
        Default = false,
        Callback = function(state)
            getgenv().SpinEnabled = state
            if not state then restore() end
        end
    })
    sec:AddDropdown({
        Name = "Mode",
        Flag = "CustomSpinMode",
        Values = modes,
        Default = getgenv().SpinMode,
        Callback = function(val)
            getgenv().SpinMode = val
            restore()
            -- при выборе Undo-режима сразу показываем разворот, если есть последняя смерть
            if (val == "Undo" or val == "Back" or val == "Undo Back") and LastDeathPos then
                UndoUntil = tick() + 1.2
            end
        end
    })
    sec:AddSlider({
        Name = "Speed",
        Flag = "CustomSpinSpeed",
        Min = 1, Max = 100,
        Default = math.clamp(getgenv().SpinSpeed, 1, 100),
        Callback = function(val) getgenv().SpinSpeed = val end
    })
    sec:AddSlider({
        Name = "Jitter Angle",
        Flag = "CustomSpinJitterAngle",
        Min = 0, Max = 180,
        Default = math.clamp(getgenv().SpinJitterAngle, 0, 180),
        Callback = function(val) getgenv().SpinJitterAngle = val end
    })
    sec:AddSlider({
        Name = "Body Lean (Roll)",
        Flag = "CustomSpinRoll",
        Min = 0, Max = 45,
        Default = math.clamp(getgenv().SpinDesyncRoll, 0, 45),
        Callback = function(val) getgenv().SpinDesyncRoll = val end
    })
end

-- kill tracker для Undo / Back / Undo Back: запоминаем, где умер последний убитый
-- LastDeathPos / UndoUntil объявлены выше, перед SPIN-секцией
do
    local PlayersT = game:GetService("Players")
    local function hookPlayer(pl)
        local function onChar(char)
            local hum = char:WaitForChild("Humanoid", 10)
            if hum then
                hum.Died:Connect(function()
                    local c = pl.Character
                    local root = c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
                    if root then
                        LastDeathPos = root.Position
                        UndoUntil = tick() + 1.2
                    end
                end)
            end
        end
        pl.CharacterAdded:Connect(onChar)
        if pl.Character then
            task.spawn(onChar, pl.Character)
        end
    end
    for _, pl in ipairs(PlayersT:GetPlayers()) do
        if pl ~= t1.value99 then hookPlayer(pl) end
    end
    PlayersT.PlayerAdded:Connect(hookPlayer)
    t1.value1.ChildAdded:Connect(function(child)
        if child.Name == "deadbody" then
            LastDeathPos = child:GetPivot().Position
            UndoUntil = tick() + 1.2
        end
    end)
end

local currentSpinYaw = 0
local jitterFlip = false

RunService5.RenderStepped:Connect(function(dt)
    if not getgenv().SpinEnabled then return end
    local char = t1.value99.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    hum.AutoRotate = false
    local spinMode0 = getgenv().SpinMode
    if spinMode0 == "Undo" or spinMode0 == "Back" or spinMode0 == "Undo Back" then
        -- one-shot: спин идёт как обычно; после килла (или выбора режима)
        -- разворачивается к убитому на ~1.2 секунды, потом снимается сам
        local speed = getgenv().SpinSpeed or 25
        currentSpinYaw = (currentSpinYaw + speed * dt * 25) % 360

        if UndoUntil and tick() < UndoUntil and LastDeathPos then
            local flat = Vector3.new(LastDeathPos.X - hrp.Position.X, 0, LastDeathPos.Z - hrp.Position.Z)
            if flat.Magnitude > 0.5 then
                local look = CFrame.lookAt(hrp.Position, hrp.Position + flat)
                if spinMode0 == "Undo" then
                    hrp.CFrame = look * CFrame.Angles(math.rad(30), 0, 0)
                else
                    hrp.CFrame = look
                end
            end
            if spinMode0 == "Undo Back" then
                ApplyBendPose(char, 95)
            else
                RestoreCharacterJoints(char)
            end
        else
            hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(currentSpinYaw), math.rad(getgenv().SpinDesyncRoll or 0))
            RestoreCharacterJoints(char)
        end
        return
    end
    local mode = getgenv().SpinMode or "Basic Spin"
    local speed = getgenv().SpinSpeed or 25
    local jitterDeg = getgenv().SpinJitterAngle or 65
    local rollDeg = getgenv().SpinDesyncRoll or 0

    currentSpinYaw = (currentSpinYaw + speed * dt * 25) % 360
    jitterFlip = not jitterFlip

    local finalYaw = math.rad(currentSpinYaw)
    -- Jitler / Yitler: чистый спин, jitter остаётся только в позе — без размазанного yaw
    if mode == "Sway" or mode == "Static Jitter" then
        -- relative to where the camera looks
        local _, camYaw = workspace.CurrentCamera.CFrame:ToOrientation()
        if mode == "Sway" then
            finalYaw = camYaw + math.sin(tick() * speed / 8) * math.rad(jitterDeg)
        else
            finalYaw = camYaw + (jitterFlip and math.rad(jitterDeg) or -math.rad(jitterDeg))
        end
    end

    local pos = hrp.Position
    hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, finalYaw, math.rad(rollDeg))

    ApplyPoseMode(char, mode, tick())
end)

function t1.value103()
    if not t1.value102 then
        return nil
    end

    local value102Position = t1.value102.Position
    local raycastParams = RaycastParams.new()

    raycastParams.FilterDescendantsInstances = { t1.value99.Character }
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = t1.value98:Raycast(value102Position, t1.value102.CFrame.RightVector * 7, raycastParams)
    local raycastResult2 = t1.value98:Raycast(value102Position, -t1.value102.CFrame.RightVector * 7, raycastParams)
    local raycastResult3 = t1.value98:Raycast(value102Position, -t1.value102.CFrame.LookVector * 7, raycastParams)

    if raycastResult and not raycastResult2 then
        return "Right"
    end

    if raycastResult2 and not raycastResult then
        return "Left"
    end

    if raycastResult3 then
        return "Back"
    end

    return "None"
end
RunService5.RenderStepped:Connect(function()
    if not t1.value102 or not t1.value101 or getgenv().SpinEnabled then
        return
    end

    local LookVector = t1.value100.CFrame.LookVector
    local cFrame = CFrame.new(t1.value102.Position, t1.value102.Position + Vector3.new(LookVector.X, 0, LookVector.Z))
    local v393 = t1.value103()

    if v393 == "Right" then
        t1.value102.CFrame = cFrame * CFrame.Angles(0, 1.5707963267948966, 0)

        return
    end

    if v393 == "Left" then
        t1.value102.CFrame = cFrame * CFrame.Angles(0, -1.5707963267948966, 0)

        return
    end

    if v393 == "Back" then
        t1.value102.CFrame = cFrame * CFrame.Angles(0, 3.141592653589793, 0)

        return
    end

    t1.value102.CFrame = cFrame
end)
t1.value104 = game:GetService("Players").LocalPlayer
t1.value105 = false
v17:AddToggle({
        Name = "Hide head",
        Flag = "Hide head",
        Default = false,
        Callback = function(p70)
    t1.value105 = p70

    local Character = t1.value104.Character

    if Character then
        local Torso = Character:FindFirstChild("Torso")
        local v397 = Torso and Torso:FindFirstChild("Neck")

        if v397 then
            if t1.value105 then
                if not v397:FindFirstChild("OriginalC0") then
                    local CFrameValue = Instance.new("CFrameValue")

                    CFrameValue.Name = "OriginalC0"
                    CFrameValue.Value = v397.C0
                    CFrameValue.Parent = v397
                end

                v397.C0 = v397.C0 * CFrame.Angles(1.5707963267948966, 0, 0)

                return
            end

            local OriginalC0 = v397:FindFirstChild("OriginalC0")

            if OriginalC0 then
                v397.C0 = OriginalC0.Value
                OriginalC0:Destroy()
            end
        end
    end
end
})
t1.value104.CharacterAdded:Connect(function(character)
    if t1.value105 then
        local Neck = character:WaitForChild("Torso"):WaitForChild("Neck")

        if not Neck:FindFirstChild("OriginalC0") then
            local CFrameValue = Instance.new("CFrameValue")

            CFrameValue.Name = "OriginalC0"
            CFrameValue.Value = Neck.C0
            CFrameValue.Parent = Neck
        end

        Neck.C0 = Neck.C0 * CFrame.Angles(1.5707963267948966, 0, 0)
    end
end)

local Players5 = game:GetService("Players")
local RunService6 = game:GetService("RunService")

t1.value106 = Players5.LocalPlayer
t1.value107 = t1.value1.CurrentCamera
t1.value108 = t1.value107.FieldOfView
t1.value109 = t1.value106.CameraMinZoomDistance
t1.value110 = t1.value106.CameraMaxZoomDistance
t1.value111 = false
v17:AddToggle({
        Name = "No scope zoom",
        Flag = "Noscopezoom",
        Default = false,
        Callback = function(p71)
    t1.value111 = p71

    if not p71 then
        t1.value107.FieldOfView = t1.value108
        t1.value106.CameraMinZoomDistance = t1.value109
        t1.value106.CameraMaxZoomDistance = t1.value110
    end
end
})
RunService6.RenderStepped:Connect(function()
    if t1.value111 then
        t1.value106.CameraMinZoomDistance = t1.value109
        t1.value106.CameraMaxZoomDistance = t1.value110

        if t1.value107.FieldOfView ~= t1.value108 then
            t1.value107.FieldOfView = t1.value108
        end
    end
end)

-- ============================================================================
-- BHOP MODULE (С НАСТРОЙКОЙ ДО МЕЛОЧЕЙ)
-- ============================================================================
local bhopToggleUI = v20:AddToggle({
    Name = "Bhop (Detailed)",
    Flag = "BhopDetailedEnabled",
    Option = true,
    Default = false,
    Callback = function(val)
        getgenv().BhopEnabled = val
    end
})

bhopToggleUI.Option:AddDropdown({
    Name = "Bhop Mode",
    Flag = "BhopModeSelect",
    Values = {
        "Velocity",
        "CFrame",
        "Legit"
    },
    Default = "Velocity",
    Callback = function(val)
        getgenv().BhopMode = val
    end
})

bhopToggleUI.Option:AddToggle({
    Name = "Hold Space Only",
    Flag = "BhopHoldSpace",
    Default = true,
    Callback = function(val)
        getgenv().BhopRequireSpace = val
    end
})

bhopToggleUI.Option:AddToggle({
    Name = "Directional Air-Strafe",
    Flag = "BhopAirStrafeToggle",
    Default = true,
    Callback = function(val)
        getgenv().BhopAutoStrafe = val
    end
})

bhopToggleUI.Option:AddSlider({
    Name = "Base Speed",
    Flag = "BhopBaseSpeed",
    Min = 14,
    Max = 100,
    Default = 32,
    Callback = function(val)
        getgenv().BhopSpeed = val
    end
})

bhopToggleUI.Option:AddSlider({
    Name = "Max Speed Cap",
    Flag = "BhopMaxSpeed",
    Min = 20,
    Max = 180,
    Default = 65,
    Callback = function(val)
        getgenv().BhopMaxSpeed = val
    end
})

bhopToggleUI.Option:AddSlider({
    Name = "Air Acceleration",
    Flag = "BhopAccel",
    Min = 1,
    Max = 30,
    Default = 5,
    Callback = function(val)
        getgenv().BhopAccel = val
    end
})

bhopToggleUI.Option:AddSlider({
    Name = "Strafe Smoothness",
    Flag = "BhopStrafeTurnSpeed",
    Min = 1,
    Max = 100,
    Default = 35,
    Callback = function(val)
        getgenv().BhopStrafeTurnSpeed = val
    end
})

bhopToggleUI.Option:AddSlider({
    Name = "Jump Power",
    Flag = "BhopJumpPower",
    Min = 25,
    Max = 100,
    Default = 50,
    Callback = function(val)
        getgenv().BhopJumpPower = val
    end
})

bhopToggleUI.Option:AddSlider({
    Name = "Hop Delay (ms)",
    Flag = "BhopHopDelay",
    Min = 0,
    Max = 300,
    Default = 20,
    Callback = function(val)
        getgenv().BhopGroundDelay = val / 1000
    end
})

v20:AddToggle({
        Name = "Automatic jump",
        Flag = "AutoJump",
        Default = false,
        Callback = function(p72)
    getgenv().AutoJumpEnabled = p72
end
})
v20:AddToggle({
        Name = "Auto Strafe",
        Flag = "AirStrafe",
        Default = false,
        Callback = function(p73)
    getgenv().AirStrafeEnabled = p73
end
})
v20:AddSlider({
        Name = "Smoothing",
        Flag = "SmoothingStrafe",
        Min = 1,
        Max = 100,
        Default = 20,
        Callback = function(p74)
    getgenv().AirStrafeStrength = p74
end
})
v20:AddToggle({
        Name = "Quick Stop",
        Flag = "QuickStop",
        Default = false,
        Callback = function(p75)
    getgenv().QuickStopEnabled = p75
end
})
local Players6 = game:GetService("Players")

t1.value112 = game:GetService("RunService")

local LocalPlayer = Players6.LocalPlayer
local UIS_Bhop = game:GetService("UserInputService")
local currentBhopSpeed = 32
local lastBhopJump = 0

local function v93(p76)
    local Humanoid = p76:WaitForChild("Humanoid")
    local HumanoidRootPart = p76:WaitForChild("HumanoidRootPart")

    t1.value112.RenderStepped:Connect(function(dt)
        if not p76 or (not Humanoid or not HumanoidRootPart) or Humanoid.Health <= 0 then
            return
        end

        -- Детальный Bhop
        if getgenv().BhopEnabled then
            local canHop = not getgenv().BhopRequireSpace or UIS_Bhop:IsKeyDown(Enum.KeyCode.Space)
            local onGround = Humanoid.FloorMaterial ~= Enum.Material.Air
            local base = getgenv().BhopSpeed or 32
            local cap = math.max(getgenv().BhopMaxSpeed or 65, base)
            local bhopMode = getgenv().BhopMode or "Velocity"

            if not onGround then
                local accel = (getgenv().BhopAccel or 5) * dt * 6
                currentBhopSpeed = math.clamp(currentBhopSpeed + accel, base, cap)
            end

            if canHop then
                if onGround and (tick() - lastBhopJump >= (getgenv().BhopGroundDelay or 0.02)) then
                    lastBhopJump = tick()
                    Humanoid.UseJumpPower = true
                    Humanoid.JumpPower = getgenv().BhopJumpPower or 50
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    -- сохраняем горизонтальный разгон, минимум = базовая скорость
                    local vel = HumanoidRootPart.Velocity
                    local flat = Vector3.new(vel.X, 0, vel.Z)
                    local dir = flat.Magnitude > 0.5 and flat.Unit
                        or (Humanoid.MoveDirection.Magnitude > 0.05 and Humanoid.MoveDirection.Unit)
                        or HumanoidRootPart.CFrame.LookVector
                    currentBhopSpeed = math.min(math.max(flat.Magnitude, base), cap)
                    if bhopMode ~= "Legit" then
                        HumanoidRootPart.Velocity = Vector3.new(dir.X * currentBhopSpeed, vel.Y, dir.Z * currentBhopSpeed)
                    end
                elseif not onGround then
                    local moveDir = Humanoid.MoveDirection
                    local camLook = workspace.CurrentCamera and workspace.CurrentCamera.CFrame.LookVector or Vector3.new()
                    local flatCam = Vector3.new(camLook.X, 0, camLook.Z)

                    -- авто-страф: крутим воздушную скорость к направлению камеры без потери скорости
                    if getgenv().BhopAutoStrafe and flatCam.Magnitude > 0.01 then
                        local vel = HumanoidRootPart.Velocity
                        local flatVel = Vector3.new(vel.X, 0, vel.Z)
                        if flatVel.Magnitude > 1 then
                            local steer = math.clamp(dt * (getgenv().BhopStrafeTurnSpeed or 35) / 10, 0, 1)
                            local turned = flatVel:Lerp(flatCam.Unit * flatVel.Magnitude, steer)
                            HumanoidRootPart.Velocity = Vector3.new(turned.X, vel.Y, turned.Z)
                        elseif moveDir.Magnitude > 0.05 and bhopMode == "Velocity" then
                            HumanoidRootPart.Velocity = Vector3.new(moveDir.X * currentBhopSpeed, vel.Y, moveDir.Z * currentBhopSpeed)
                        end
                    elseif moveDir.Magnitude > 0.05 then
                        local dir = moveDir.Unit
                        if bhopMode == "Velocity" then
                            HumanoidRootPart.Velocity = Vector3.new(dir.X * currentBhopSpeed, HumanoidRootPart.Velocity.Y, dir.Z * currentBhopSpeed)
                        elseif bhopMode == "CFrame" then
                            HumanoidRootPart.CFrame += dir * (currentBhopSpeed * dt)
                        end
                    end

                    if bhopMode == "Legit" then
                        Humanoid.WalkSpeed = math.clamp(currentBhopSpeed, 16, 36)
                    end
                end
            else
                if bhopMode == "Legit" and Humanoid.WalkSpeed ~= 16 then
                    Humanoid.WalkSpeed = 16
                end
                currentBhopSpeed = base
            end
        end

        if getgenv().AutoJumpEnabled and Humanoid.FloorMaterial ~= Enum.Material.Air and tick() - 0 >= 0.15 then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end

        if getgenv().AirStrafeEnabled and Humanoid.FloorMaterial == Enum.Material.Air then
            local MoveDirection = Humanoid.MoveDirection

            if MoveDirection.Magnitude > 0.856 then
                HumanoidRootPart.Velocity = Vector3.new(MoveDirection.X * getgenv().AirStrafeStrength, HumanoidRootPart.Velocity.Y, MoveDirection.Z * getgenv().AirStrafeStrength)
            end
        end

        if getgenv().QuickStopEnabled then
            local HumanoidRootPartVelocity = HumanoidRootPart.Velocity

            if Vector3.new(HumanoidRootPartVelocity.X, 0, HumanoidRootPartVelocity.Z).Magnitude < 0 and Humanoid.MoveDirection.Magnitude == 0.1 then
                HumanoidRootPart.Velocity = Vector3.new(0, HumanoidRootPartVelocity.Y, 0)
            end
        end
    end)
end
v93(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

local CharacterAdded = LocalPlayer.CharacterAdded
local AddToggle4 = v17.AddToggle
CharacterAdded:Connect(v93)
AddToggle4(v17, {
        Name = "Dynamic camera",
        Flag = "CameraSway",
        Default = false,
        Callback = function(p77)
    local Players7 = game:GetService("Players")
    local RunService7 = game:GetService("RunService")
    local UserInputService2 = game:GetService("UserInputService")
    local LocalPlayer2 = Players7.LocalPlayer
    local Humanoid = (LocalPlayer2.Character or LocalPlayer2.CharacterAdded:Wait()):WaitForChild("Humanoid")
    local CurrentCamera = t1.value1.CurrentCamera
    local n3 = 0

    local function v419(p78, p79, p80)
        return p78 + (p79 - p78) * p80
    end

    local swayConn
    swayConn = RunService7.RenderStepped:Connect(function(dt)
        if not p77 then
            Humanoid.CameraOffset = Vector3.new(0, 0, 0)
            if swayConn then
                swayConn:Disconnect()
            end
            return
        end

        local timestamp = tick()

        if Humanoid.MoveDirection.Magnitude > 0 then
            local v494 = math.cos(timestamp * 5) * 0.25
            local v495 = math.abs((math.sin(timestamp * 5))) * 0.25
            local vector3 = Vector3.new(v494, v495, 0)

            Humanoid.CameraOffset = Humanoid.CameraOffset:Lerp(vector3, 0.25)
        else
            Humanoid.CameraOffset = Humanoid.CameraOffset * 0.75
        end

        local MouseDelta = UserInputService2:GetMouseDelta()

        n3 = v419(n3, math.clamp(MouseDelta.X, -6, 6), 6 * dt)
        CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.Angles(0, 0, (math.rad(n3)))
    end)
end
})
local Option8 = v18:AddToggle({
        Name = "Soul particles",
        Flag = "SoulParticles",
        Option = true,
        Default = false,
        Callback = function(p81)
    local Workspace = game:GetService("Workspace")
    local t8 = {}
    local t9 = {}

    _G.SoulParticleColor = _G.SoulParticleColor or Color3.fromRGB(150, 0, 255)

    local function v424(p82)
        if not p82 or not p82.Parent then
            return
        end
        for v501, v502 in ipairs(p82:GetDescendants()) do

            if v502:IsA("BasePart") then
                v502.Anchored = true
                v502.CanCollide = false
            end
        end
        for _, descendant in ipairs(p82:GetDescendants()) do
            if descendant:IsA("BasePart") then
                local ParticleEmitter = Instance.new("ParticleEmitter")

                ParticleEmitter.Texture = "rbxassetid://833874434"
                ParticleEmitter.LightEmission = 1
                ParticleEmitter.Rate = 350
                ParticleEmitter.Speed = NumberRange.new(1, 3)
                ParticleEmitter.Lifetime = NumberRange.new(2, 3)
                ParticleEmitter.Size = NumberSequence.new({
                                                NumberSequenceKeypoint.new(0, 0.2),
                                                NumberSequenceKeypoint.new(0.5, 0.3),
                                                NumberSequenceKeypoint.new(1, 0.2)
                                        })
                ParticleEmitter.Color = ColorSequence.new({
                                                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
                                                ColorSequenceKeypoint.new(0.8, _G.SoulParticleColor),
                                                ColorSequenceKeypoint.new(1, _G.SoulParticleColor)
                                        })
                ParticleEmitter.EmissionDirection = Enum.NormalId.Top
                ParticleEmitter.SpreadAngle = Vector2.new(360, 360)
                ParticleEmitter.Parent = descendant
                table.insert(t9, ParticleEmitter)
                task.spawn(function()
                    ParticleEmitter:Emit(350)
                    task.wait(3)
                    ParticleEmitter.Enabled = false
                    task.wait(0.5)
                    ParticleEmitter:Destroy()

                    if p82 and p82.Parent then
                        p82:Destroy()
                    end
                end)
            end
        end
    end

    if p81 then
        table.insert(t8, (Workspace.ChildAdded:Connect(function(child)
            if child.Name:lower() == "deadbody" then
                v424(child)
            end
        end)))
    else

        for v427, v428 in ipairs(t8) do

            if v428.Connected then
                v428:Disconnect()
            end
        end
        for _, v in ipairs(t9) do
            if v and v.Parent then
                v:Destroy()
            end
        end
        t9 = {}
    end

    _G.SoulParticleEmitters = t9
end
}).Option
local color3_37 = Color3.fromRGB(150, 0, 255)

Option8:AddColorPicker({
        Name = "Color",
        Flag = "ColorSoul",
        Default = color3_37,
        Callback = function(p83)
    _G.SoulParticleColor = p83

    if _G.SoulParticleEmitters then
        for _, v in ipairs(_G.SoulParticleEmitters) do
            if v and v.Parent then
                v.Color = ColorSequence.new({
                                                ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 100, 255)),
                                                ColorSequenceKeypoint.new(0.8, p83),
                                                ColorSequenceKeypoint.new(1, p83)
                                        })
            end
        end
    end
end
})
t1.value113 = game:GetService("Players")

local RunService8 = game:GetService("RunService")

t1.value114 = game:GetService("Workspace")
t1.value115 = t1.value114.CurrentCamera
t1.value116 = t1.value113.LocalPlayer
t1.value117 = Drawing.new("Circle")
t1.value117.Visible = false
t1.value117.Color = Color3.fromRGB(255, 255, 255)
t1.value117.Thickness = 1.5
t1.value117.Transparency = 0.6
t1.value117.Filled = false
t1.value117.NumSides = 48
t1.value117.Radius = getgenv().TriggerRadius

function t1.value118(p84)
    local Character = p84.Character

    if not Character then
        return false
    end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    return Humanoid and (Character:FindFirstChild("Head") and Humanoid.Health > 0)
end
t1.value119 = nil
function t1.value119(p85)
    local CFramePosition = t1.value115.CFrame.Position
    local v440 = p85.Position - CFramePosition
    local raycastParams = RaycastParams.new()

    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {
                t1.value116.Character,
                t1.value115
        }

    local raycastResult = t1.value114:Raycast(CFramePosition, v440, raycastParams)

    if not raycastResult then
        return true
    end

    return raycastResult.Instance:IsDescendantOf(p85.Parent)
end
function t1.value120(p86)
    if not t1.value115 then
        return false
    end

    local vector2 = Vector2.new(t1.value115.ViewportSize.X / 2, t1.value115.ViewportSize.Y / 2)

    for _, v in ipairs({
                "Head",
                "UpperTorso",
                "Torso",
                "HumanoidRootPart"
        }) do
        local v3 = p86:FindFirstChild(v)

        if not v3 then
            continue
        end

        local v448, v449 = t1.value115:WorldToViewportPoint(v3.Position)

        if v449 and v448.Z > 0 and ((Vector2.new(v448.X, v448.Y) - vector2).Magnitude <= getgenv().TriggerRadius and t1.value119(v3)) then
            return true
        end
    end

    return false
end
function t1.value121()
    pcall(function()
        if mouse1click then
            mouse1click()
        end
    end)
    pcall(function()
        if mousebuttonclick then
            mousebuttonclick(1)
        end
    end)
    pcall(function()
        if click then
            click()
        end
    end)
end
task.spawn(function()
    while task.wait(0.016) do
        if getgenv().TRIGGER_Enabled then
            for _, player in ipairs(t1.value113:GetPlayers()) do
                if player ~= t1.value116 and (player.Character and t1.value118(player)) and t1.value120(player.Character) then
                    t1.value121()
                end
            end
        end
    end
end)
t1.value116.CharacterAdded:Connect(function()
    local _ = t1.value116.Character

    repeat
        task.wait()
    until t1.value116.Character
end)

local Players8 = game:GetService("Players")

t1.value122 = game:GetService("RunService")

local LocalPlayer3 = Players8.LocalPlayer
t1.value123 = false
if LocalPlayer3.Character then
    local Character = LocalPlayer3.Character
    local Humanoid = Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local connection
    connection = t1.value122.RenderStepped:Connect(function()
        if not t1.value123 then
            return
        end

        if Humanoid and HumanoidRootPart then
            local CurrentCamera = t1.value1.CurrentCamera

            if CurrentCamera then
                local vector3 = Vector3.new(CurrentCamera.CFrame.LookVector.X, 0, CurrentCamera.CFrame.LookVector.Z)

                if vector3.Magnitude > 0 then
                    Humanoid:Move(vector3.Unit, false)

                    return
                end
            end
        else
            connection:Disconnect()
        end
    end)
end
LocalPlayer3.CharacterAdded:Connect(function(character)
    local Humanoid = character:WaitForChild("Humanoid")
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local connection
    connection = t1.value122.RenderStepped:Connect(function()
        if not t1.value123 then
            return
        end

        if Humanoid and HumanoidRootPart then
            local CurrentCamera = t1.value1.CurrentCamera

            if CurrentCamera then
                local vector3 = Vector3.new(CurrentCamera.CFrame.LookVector.X, 0, CurrentCamera.CFrame.LookVector.Z)

                if vector3.Magnitude > 0 then
                    Humanoid:Move(vector3.Unit, false)

                    return
                end
            end
        else
            connection:Disconnect()
        end
    end)
end)
v20:AddToggle({
        Name = "Auto move",
        Flag = "AutoMove",
        Default = false,
        Callback = function(p90)
    t1.value123 = p90
end
})

getgenv().FastSpawnEnabled = false

task.spawn(function()
    while task.wait(0.5) do
        if getgenv().FastSpawnEnabled then
            local char = t1.value19.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            
            if (not char or not humanoid or humanoid.Health <= 0) then
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.Command:FireServer("Play")
                end)
            end
        end
    end
end)

v21:AddToggle({
    Name = "Fast Spawn",
    Flag = "FastSpawn",
    Default = false,
    Callback = function(p)
        getgenv().FastSpawnEnabled = p
    end
})

getgenv().BulletTrailsEnabled = false
getgenv().BulletTrailColor = Color3.fromRGB(205, 50, 255)

local TrailsList = {}

local function CreateBulletTrail(startPos, endPos, color)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Size = Vector3.new(0.06, 0.06, (startPos - endPos).Magnitude)
    part.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, -part.Size.Z / 2)
    part.Transparency = 0
    part.Parent = t1.value1
    
    table.insert(TrailsList, {Part = part, Life = 1.5})
end

RunService.RenderStepped:Connect(function()
    for i = #TrailsList, 1, -1 do
        local t = TrailsList[i]
        t.Life = t.Life - 0.016
        
        if t.Life <= 0 then
            pcall(function()
                t.Part:Destroy()
            end)
            table.remove(TrailsList, i)
        else
            t.Part.Transparency = 1 - (t.Life / 1.5)
        end
    end
end)

local bulletStorage = t1.value1:FindFirstChild("bulletStorage") or Instance.new("Folder", t1.value1)
bulletStorage.Name = "bulletStorage"

bulletStorage.ChildAdded:Connect(function(child)
    if not getgenv().BulletTrailsEnabled then return end
    if not child:IsA("BasePart") then return end
    
    local startPos = child.Position
    local connection
    
    connection = RunService.RenderStepped:Connect(function()
        if child and child.Parent then
            local endPos = child.Position
            CreateBulletTrail(startPos, endPos, getgenv().BulletTrailColor)
            startPos = endPos
        else
            connection:Disconnect()
        end
    end)
end)

v18:AddToggle({
    Name = "Bullet Trails",
    Flag = "BulletTrails",
    Default = false,
    Callback = function(p)
        getgenv().BulletTrailsEnabled = p
    end
})

v18:AddColorPicker({
    Name = "Trail Color",
    Flag = "BulletTrailColor",
    Default = Color3.fromRGB(205, 50, 255),
    Callback = function(p)
        getgenv().BulletTrailColor = p
    end
})


-- ============================================================
-- [FIRE RATE] зажал ЛКМ — стреляет с кастомным темпом через тот же
-- FireWeapon-сигнал, что и авто-стрельба раги
-- ============================================================
do
    local UIS_FR = game:GetService("UserInputService")

    local secFR = t1.mMisc:AddSection({ Position = "center", Name = "FIRE RATE" })
    secFR:AddToggle({
        Name = "Fire Rate Changer",
        Flag = "FireRateEnabled",
        Default = getgenv().FireRateEnabled,
        Callback = function(p) getgenv().FireRateEnabled = p end
    })
    secFR:AddSlider({
        Name = "Rate Multiplier",
        Flag = "FireRateMult",
        Min = 1, Max = 10,
        Default = math.clamp(getgenv().FireRateMult, 1, 10),
        Callback = function(p) getgenv().FireRateMult = p end
    })

    task.spawn(function()
        while true do
            local g = getgenv()
            if g.FireRateEnabled and UIS_FR:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                and not (g.RageBotEnabled and g.RageBotAutoFire) then
                local interval = math.clamp(0.1 / math.max(g.FireRateMult or 2, 0.1), 0.02, 1)
                SignalManager.Fire("FireWeapon", Enum.UserInputState.Begin)
                task.wait(interval * 0.4)
                SignalManager.Fire("FireWeapon", Enum.UserInputState.End)
                task.wait(interval * 0.6)
            else
                task.wait(0.05)
            end
        end
    end)
end

-- ============================================================
-- [GOD MODE] клиентский: мгновенный отхил при уроне.
-- если урон считает сервер — может убить, это best effort
-- ============================================================
do
    local secGod = t1.mMisc:AddSection({ Position = "center", Name = "GOD MODE" })
    secGod:AddToggle({
        Name = "God Mode (client)",
        Flag = "GodModeEnabled",
        Default = getgenv().GodModeEnabled,
        Callback = function(p) getgenv().GodModeEnabled = p end
    })
    local function trackGod(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then return end
        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if getgenv().GodModeEnabled and hum.Health > 0 and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)
    end
    if t1.value8.Character then task.spawn(trackGod, t1.value8.Character) end
    t1.value8.CharacterAdded:Connect(trackGod)
end

-- ============================================================
-- [EXTRA VISUALS] fullbright + кастомный прицел + fps счётчик
-- ============================================================
do
    local LightingX = game:GetService("Lighting")
    local savedLight = {
        Brightness = LightingX.Brightness,
        ClockTime = LightingX.ClockTime,
        Ambient = LightingX.Ambient,
        OutdoorAmbient = LightingX.OutdoorAmbient,
        GlobalShadows = LightingX.GlobalShadows
    }
    v17:AddToggle({
        Name = "Fullbright",
        Flag = "Fullbright",
        Default = false,
        Callback = function(p)
            if p then
                LightingX.Brightness = 3
                LightingX.ClockTime = 14
                LightingX.Ambient = Color3.fromRGB(255, 255, 255)
                LightingX.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                LightingX.GlobalShadows = false
                LightingX.FogEnd = 100000
            else
                LightingX.Brightness = savedLight.Brightness
                LightingX.ClockTime = savedLight.ClockTime
                LightingX.Ambient = savedLight.Ambient
                LightingX.OutdoorAmbient = savedLight.OutdoorAmbient
                LightingX.GlobalShadows = savedLight.GlobalShadows
            end
        end
    })

    local lines = {}
    for _ = 1, 4 do
        local ln = Drawing.new("Line")
        ln.Visible = false
        ln.Thickness = 1.5
        ln.Color = Color3.fromRGB(0, 255, 120)
        table.insert(lines, ln)
    end
    local chDot = Drawing.new("Circle")
    chDot.Visible = false
    chDot.Radius = 1
    chDot.Filled = true
    chDot.NumSides = 8
    chDot.Color = Color3.fromRGB(0, 255, 120)

    local secCH = t1.mVisuals:AddSection({ Position = "right", Name = "CROSSHAIR" })
    secCH:AddToggle({
        Name = "Custom Crosshair",
        Flag = "CrosshairEnabled",
        Default = getgenv().CrosshairEnabled,
        Callback = function(p)
            getgenv().CrosshairEnabled = p
            if not p then
                for _, ln in ipairs(lines) do ln.Visible = false end
                chDot.Visible = false
            end
        end
    })
    secCH:AddSlider({
        Name = "Length",
        Flag = "CrosshairSize",
        Min = 2, Max = 40,
        Default = getgenv().CrosshairSize,
        Callback = function(p) getgenv().CrosshairSize = p end
    })
    secCH:AddSlider({
        Name = "Gap",
        Flag = "CrosshairGap",
        Min = 0, Max = 20,
        Default = getgenv().CrosshairGap,
        Callback = function(p) getgenv().CrosshairGap = p end
    })
    secCH:AddColorPicker({
        Name = "Crosshair Color",
        Flag = "CrosshairColor",
        Default = Color3.fromRGB(0, 255, 120),
        Callback = function(c)
            for _, ln in ipairs(lines) do ln.Color = c end
            chDot.Color = c
        end
    })

    local chCam = workspace.CurrentCamera
    RunService.RenderStepped:Connect(function()
        if not (getgenv().CrosshairEnabled and chCam and chCam.Parent) then return end
        local vp = chCam.ViewportSize
        local cx, cy = vp.X / 2, vp.Y / 2
        local len = getgenv().CrosshairSize or 12
        local gap = getgenv().CrosshairGap or 4
        local segs = {
            { cx - gap - len, cy, cx - gap, cy },
            { cx + gap, cy, cx + gap + len, cy },
            { cx, cy - gap - len, cx, cy - gap },
            { cx, cy + gap, cx, cy + gap + len }
        }
        for i, s in ipairs(segs) do
            lines[i].From = Vector2.new(s[1], s[2])
            lines[i].To = Vector2.new(s[3], s[4])
            lines[i].Visible = true
        end
        chDot.Position = Vector2.new(cx, cy)
        chDot.Visible = true
    end)

    local fpsText = Drawing.new("Text")
    fpsText.Visible = false
    fpsText.Size = 14
    fpsText.Color = Color3.fromRGB(180, 180, 255)
    fpsText.Outline = true
    fpsText.Position = Vector2.new(8, 8)
    fpsText.Text = "FPS: ..."
    local secFps = t1.mVisuals:AddSection({ Position = "right", Name = "INFO" })
    secFps:AddToggle({
        Name = "FPS Counter",
        Flag = "FpsCounter",
        Default = false,
        Callback = function(p) fpsText.Visible = p end
    })
    local fpsAcc, fpsFrames = 0, 0
    RunService.RenderStepped:Connect(function(dt)
        fpsFrames += 1
        fpsAcc += dt
        if fpsAcc >= 0.5 then
            fpsText.Text = ("FPS: %d"):format(math.floor(fpsFrames / fpsAcc + 0.5))
            fpsAcc, fpsFrames = 0, 0
        end
    end)
end

-- ============================================================
-- [SKIN CHANGER] визуальные скины на оружии + Random
-- ============================================================
do
    local skins = {
        ["Redline"] = { Color = Color3.fromRGB(40, 40, 40), Material = Enum.Material.Metal, Reflectance = 0.1 },
        ["Asiimov"] = { Color = Color3.fromRGB(245, 245, 240), Material = Enum.Material.SmoothPlastic, Reflectance = 0 },
        ["Fade"] = { Color = Color3.fromRGB(255, 105, 180), Material = Enum.Material.Neon, Reflectance = 0 },
        ["Case Hardened"] = { Color = Color3.fromRGB(90, 130, 255), Material = Enum.Material.Metal, Reflectance = 0.35 },
        ["Gold"] = { Color = Color3.fromRGB(255, 200, 40), Material = Enum.Material.Metal, Reflectance = 0.6 },
        ["Neon"] = { Color = Color3.fromRGB(0, 255, 140), Material = Enum.Material.Neon, Reflectance = 0 }
    }
    local skinKeys = { "Redline", "Asiimov", "Fade", "Case Hardened", "Gold", "Neon" }
    local appliedSkins = {}

    local function applySkin(tool)
        if not getgenv().SkinEnabled then return end
        local name = getgenv().SkinName or "Random"
        if name == "Random" then
            name = skinKeys[math.random(1, #skinKeys)]
        end
        local preset = skins[name]
        if not preset then return end
        for _, part in ipairs(tool:GetDescendants()) do
            if (part:IsA("BasePart") or part:IsA("MeshPart")) and part.Name ~= "Charm"
                and not part:FindFirstAncestor("Charm") then
                if not appliedSkins[part] then
                    appliedSkins[part] = {
                        Color = part.Color,
                        Material = part.Material,
                        Reflectance = part.Reflectance,
                        Transparency = part.Transparency
                    }
                end
                part.Color = preset.Color
                part.Material = preset.Material
                part.Reflectance = preset.Reflectance or 0
            end
        end
    end

    local function restoreSkins()
        for part, orig in pairs(appliedSkins) do
            if part and part.Parent then
                part.Color = orig.Color
                part.Material = orig.Material
                part.Reflectance = orig.Reflectance
                part.Transparency = orig.Transparency
            end
        end
        table.clear(appliedSkins)
    end

    local function watchTool(char)
        char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                task.wait(0.1)
                applySkin(child)
            end
        end)
        char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then restoreSkins() end
        end)
        local cur = char:FindFirstChildOfClass("Tool")
        if cur then applySkin(cur) end
    end
    if t1.value8.Character then watchTool(t1.value8.Character) end
    t1.value8.CharacterAdded:Connect(watchTool)

    local secSkin = t1.mVisuals:AddSection({ Position = "right", Name = "SKIN CHANGER" })
    secSkin:AddToggle({
        Name = "Enable",
        Flag = "SkinEnabled",
        Default = getgenv().SkinEnabled,
        Callback = function(p)
            getgenv().SkinEnabled = p
            if p then
                local t = t1.value8.Character and t1.value8.Character:FindFirstChildOfClass("Tool")
                if t then applySkin(t) end
            else
                restoreSkins()
            end
        end
    })
    secSkin:AddDropdown({
        Name = "Skin",
        Flag = "SkinName",
        Values = { "Random", "Redline", "Asiimov", "Fade", "Case Hardened", "Gold", "Neon" },
        Default = getgenv().SkinName,
        Callback = function(v)
            getgenv().SkinName = v
            restoreSkins()
            local t = t1.value8.Character and t1.value8.Character:FindFirstChildOfClass("Tool")
            if t then applySkin(t) end
        end
    })
end

-- ============================================================
-- [CONFIG] SETTINGS tab
-- PROFILE: which slot + autosave. ACTIONS: save / load / reset (tap = run).
-- slot switch, load and reset change values immediately; the menu widgets
-- show the new values after the next execute.
-- ============================================================
do
    local Cfg = t1.Cfg
    local t0 = os.clock() -- widgets may fire their callback once on creation; stay quiet then
    local function note(text)
        if os.clock() - t0 < 3 then return end
        v11:Notify({ Title = "CONFIG", Content = text, Icon = "check" })
    end

    local profile = vSettings:AddSection({ Position = "left", Name = "CONFIG PROFILE" })
    profile:AddDropdown({
        Name = "Slot",
        Flag = "CfgSlot",
        Values = Cfg.Slots,
        Default = Cfg.Slot,
        Callback = function(p)
            if p == Cfg.Slot then return end
            Cfg.save()
            Cfg.Slot = p
            Cfg.saveMeta()
            if Cfg.load(p) then
                note("slot " .. p .. " loaded")
            else
                Cfg.save()
                note("slot " .. p .. " is empty, current values saved into it")
            end
        end
    })
    profile:AddToggle({
        Name = "Autosave (every 2s on change)",
        Flag = "CfgAutosave",
        Default = Cfg.Autosave,
        Callback = function(p)
            Cfg.Autosave = p
            Cfg.saveMeta()
        end
    })

    local actions = vSettings:AddSection({ Position = "center", Name = "CONFIG ACTIONS" })
    actions:AddToggle({
        Name = "Save slot (tap)",
        Flag = "CfgSaveNow",
        Default = false,
        Callback = function()
            Cfg.save()
            note("saved to " .. Cfg.Slot)
        end
    })
    actions:AddToggle({
        Name = "Load slot (tap)",
        Flag = "CfgLoadNow",
        Default = false,
        Callback = function()
            local ok = Cfg.load()
            note(ok and ("loaded " .. Cfg.Slot) or ("no file for " .. Cfg.Slot))
        end
    })
    actions:AddToggle({
        Name = "Reset slot to defaults (tap)",
        Flag = "CfgResetNow",
        Default = false,
        Callback = function()
            if os.clock() - t0 < 3 then return end
            Cfg.reset()
            note("slot " .. Cfg.Slot .. " reset")
        end
    })
end