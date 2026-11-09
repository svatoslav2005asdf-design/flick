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

-- non-blocking: lib may parent its gui to gethui()/CoreGui/PlayerGui under a different name
function t1.findFrame()
    local roots = {}
    pcall(function() if gethui then roots[#roots + 1] = gethui() end end)
    roots[#roots + 1] = game:GetService("CoreGui")
    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if pg then roots[#roots + 1] = pg end
    for _, root in ipairs(roots) do
        local ok, f = pcall(function() return root:FindFirstChild("FatalFtame", true) or root:FindFirstChild("FatalFrame", true) end)
        if ok and f then return f end
    end
end

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        t1.value4 = t1.value4 or t1.findFrame()
        if t1.value4 then t1.value4.Visible = not t1.value4.Visible end
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
t1.mFx = mkMenu("EFFECTS", "sparkles")
local vSettings = mkMenu("SETTINGS", "cog")

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
-- [CONFIG] core: именованные конфиги через writefile/readfile/delfile
-- LesxovTap/configs/<name>.json, LesxovTap/meta.json (последний выбранный)
-- ============================================================
do
    local HttpService = game:GetService("HttpService")
    local Cfg = {
        Folder = "LesxovTap",
        Slot = "default",
        Autosave = false,
        ready = false,
        _last = nil,
        Keys = {
            "SilentAim", "SilentAimTarget", "SilentAimFOVEnabled", "SilentAimFOV",
            "RageBotEnabled", "RageBotHitbox", "RageBotAutoFire",
            "AttackIntervalEnabled", "AttackInterval", "AttackHold", "AttackJitter",
            "PenetrationEnabled", "PenetrationMax",
            "RageMagEnabled", "WallbangEnabled", "WallbangAutoFire", "WallbangFOV", "NoReloadEnabled",
            "GodModeEnabled",
            "SkinEnabled", "SkinName", "SnowStyle",
            "SpinMode", "SpinSpeed", "SpinJitterAngle", "SpinDesyncRoll", "UndoDuration",
            "BulletTrailsEnabled", "BulletTrailModel", "BulletTrailLife",
            "Theme", "ThemeHue", "ThemeSat",
            "GunSoundEnabled", "GunSoundType", "GunSoundVolume",
            "EspEnabled", "EspBoxType", "EspFill", "EspFillAlpha", "EspOutline", "EspThickness", "EspHealth",
            "EspHealthGradient", "EspName", "EspDist", "EspTracers", "EspTracerFrom", "EspSkeleton", "EspTeamCheck",
            "KillFxEnabled", "KillFxName", "KillFxColorHex", "HatEnabled", "HatDetail", "HatSize", "HatHeight",
            "HatAlpha", "HatRotate", "HatRainbow", "HatColorHex", "JumpFxEnabled", "JumpShape", "JumpOnJump",
            "JumpOnLand", "JumpSize", "JumpDur", "JumpColorHex",
            "EspMaxDist", "EspBoxColorHex", "EspFillColorHex", "EspHealthColorHex", "EspNameColorHex",
            "EspDistColorHex", "EspSkelColorHex", "EspTracerColorHex",
        },
    }

    local fsOk = type(writefile) == "function" and type(readfile) == "function"
        and type(isfile) == "function" and type(isfolder) == "function" and type(makefolder) == "function"
    local mem = {} -- если у экзекутора нет файловой системы

    local function ensureDirs()
        if not fsOk then return end
        pcall(function()
            if not isfolder(Cfg.Folder) then makefolder(Cfg.Folder) end
            if not isfolder(Cfg.Folder .. "/configs") then makefolder(Cfg.Folder .. "/configs") end
        end)
    end

    local function rd(rel)
        if not fsOk then return mem[rel] end
        local ok, data = pcall(function()
            local p = Cfg.Folder .. "/" .. rel
            if isfile(p) then return readfile(p) end
            return nil
        end)
        return ok and data or nil
    end

    local function wr(rel, data)
        if not fsOk then
            mem[rel] = data
            return true
        end
        ensureDirs()
        return (pcall(writefile, Cfg.Folder .. "/" .. rel, data))
    end

    local function dec(str)
        if not str or str == "" then return nil end
        local ok, r = pcall(HttpService.JSONDecode, HttpService, str)
        if ok and type(r) == "table" then return r end
        return nil
    end

    function Cfg.clean(name)
        name = tostring(name or ""):gsub("[^%w_%- ]", "_")
        name = name:gsub("^%s+", ""):gsub("%s+$", "")
        return name:sub(1, 32)
    end

    local function file(name) return "configs/" .. name .. ".json" end

    function Cfg.exists(name)
        return rd(file(name)) ~= nil
    end

    function Cfg.list()
        local out, seen = {}, {}
        if fsOk and type(listfiles) == "function" then
            pcall(function()
                for _, f in ipairs(listfiles(Cfg.Folder .. "/configs")) do
                    local n = tostring(f):match("([^/\\]+)%.json$")
                    if n and not seen[n] then seen[n] = true; out[#out + 1] = n end
                end
            end)
        else
            for k in pairs(mem) do
                local n = k:match("^configs/(.+)%.json$")
                if n and not seen[n] then seen[n] = true; out[#out + 1] = n end
            end
        end
        if not seen["default"] then out[#out + 1] = "default" end
        table.sort(out)
        return out
    end

    function Cfg.snapshot()
        local out, env = {}, getgenv()
        for _, k in ipairs(Cfg.Keys) do
            if env[k] ~= nil then out[k] = env[k] end
        end
        return out
    end

    function Cfg.save(name)
        name = Cfg.clean(name or Cfg.Slot)
        if name == "" then name = "default" end
        local json = HttpService:JSONEncode(Cfg.snapshot())
        local ok = wr(file(name), json)
        if ok then Cfg._last = json end
        return ok, name
    end

    function Cfg.load(name)
        name = Cfg.clean(name or Cfg.Slot)
        local data = dec(rd(file(name)))
        if not data then return false end
        local env = getgenv()
        for _, k in ipairs(Cfg.Keys) do
            local v = data[k]
            if v ~= nil and type(v) == type(env[k]) then env[k] = v end
        end
        Cfg._last = HttpService:JSONEncode(Cfg.snapshot())
        return true
    end

    function Cfg.delete(name)
        name = Cfg.clean(name or Cfg.Slot)
        if not Cfg.exists(name) then return false end
        if not fsOk then
            mem[file(name)] = nil
            return true
        end
        local ok = pcall(function()
            local p = Cfg.Folder .. "/" .. file(name)
            if type(delfile) == "function" then
                delfile(p)
            else
                writefile(p, "") -- нет delfile: файл обнуляем, dec() его проигнорирует
            end
        end)
        return ok
    end

    function Cfg.saveMeta()
        wr("meta.json", HttpService:JSONEncode({ slot = Cfg.Slot, autosave = Cfg.Autosave }))
    end

    function Cfg.resetValues()
        local env = getgenv()
        for k, v in pairs(Cfg.defaults or {}) do env[k] = v end
    end

    function Cfg.init()
        Cfg.defaults = Cfg.snapshot()
        ensureDirs()
        -- миграция со старого формата LesxovTap/<slot>.json
        pcall(function()
            if fsOk and not Cfg.exists("default") and isfile(Cfg.Folder .. "/default.json") then
                wr(file("default"), readfile(Cfg.Folder .. "/default.json"))
            end
        end)
        local meta = dec(rd("meta.json"))
        if meta then
            if type(meta.slot) == "string" and Cfg.exists(Cfg.clean(meta.slot)) then Cfg.Slot = Cfg.clean(meta.slot) end
            if type(meta.autosave) == "boolean" then Cfg.Autosave = meta.autosave end
        end
        Cfg.load()
        Cfg.ready = true
    end

    task.spawn(function()
        while task.wait(2) do
            if Cfg.ready and Cfg.Autosave and Cfg.exists(Cfg.Slot) then
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
getgenv().UndoDuration = 2

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
getgenv().WallbangAutoFire = false
getgenv().WallbangFOV = 30
getgenv().NoReloadEnabled = false
getgenv().GodModeEnabled = false
getgenv().SkinEnabled = false
getgenv().SkinName = "Random"
getgenv().SnowStyle = "Realistic"
getgenv().BulletTrailsEnabled = getgenv().BulletTrailsEnabled or false
getgenv().BulletTrailModel = getgenv().BulletTrailModel or "Default"
getgenv().BulletTrailLife = getgenv().BulletTrailLife or 15
getgenv().Theme = getgenv().Theme or "Default"
do
    local e, d = getgenv(), {
        KillFxEnabled = false, KillFxName = "Lightning", KillFxColorHex = "78BEFF",
        HatEnabled = false, HatDetail = "Simple", HatSize = 3, HatHeight = 0, HatAlpha = 60, HatRotate = false,
        HatRainbow = false, HatColorHex = "FF4D6D",
        JumpFxEnabled = false, JumpShape = "Circle", JumpOnJump = true, JumpOnLand = true, JumpSize = 6, JumpDur = 8,
        JumpColorHex = "FF4D6D",
    }
    for k, v in pairs(d) do if e[k] == nil then e[k] = v end end
end
do
    local e, d = getgenv(), {
        EspEnabled = false, EspBoxType = "2D", EspFill = false, EspFillAlpha = 25, EspOutline = true,
        EspThickness = 1, EspHealth = false, EspHealthGradient = true, EspName = false, EspDist = false,
        EspTracers = false, EspTracerFrom = "Bottom", EspSkeleton = false, EspTeamCheck = false, EspMaxDist = 1500,
        EspBoxColorHex = "FFFFFF", EspFillColorHex = "FF4D6D", EspHealthColorHex = "00FF78",
        EspNameColorHex = "FFFFFF", EspDistColorHex = "C8C8FF", EspSkelColorHex = "FFFFFF", EspTracerColorHex = "FF4D6D",
    }
    for k, v in pairs(d) do if e[k] == nil then e[k] = v end end
end
if getgenv().GunSoundEnabled == nil then getgenv().GunSoundEnabled = false end
getgenv().GunSoundType = getgenv().GunSoundType or "Default"
getgenv().GunSoundVolume = getgenv().GunSoundVolume or 50
getgenv().ThemeHue = getgenv().ThemeHue or 330
getgenv().ThemeSat = getgenv().ThemeSat or 70
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

-- wallbang FOV target: closest-to-crosshair player inside WallbangFOV (deg), walls ignored
function getWallbangTarget()
    if not getgenv().WallbangEnabled then return nil end
    local c = t1.value6.CurrentCamera
    local fov = getgenv().WallbangFOV or 30
    local hitbox = getgenv().RageBotHitbox or "Head"
    local best, bestAng = nil, math.huge
    for _, player in ipairs(t1.value5:GetPlayers()) do
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if player ~= t1.value8 and hum and hum.Health > 0 then
            local part
            if hitbox == "All" then
                for _, n in ipairs({"Head", "UpperTorso", "Torso", "HumanoidRootPart"}) do
                    part = char:FindFirstChild(n)
                    if part then break end
                end
            else
                part = char:FindFirstChild(hitbox) or char:FindFirstChild("Head")
            end
            if part then
                local dir = (part.Position - c.CFrame.Position).Unit
                local ang = math.deg(math.acos(math.clamp(c.CFrame.LookVector:Dot(dir), -1, 1)))
                if ang <= fov and ang < bestAng then
                    bestAng, best = ang, part
                end
            end
        end
    end
    return best
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BulletHandler = require(ReplicatedStorage.ModuleScripts.GunModules:WaitForChild("BulletHandler"))
local SignalManager = require(ReplicatedStorage:WaitForChild("SignalManager"))
local oldFire = BulletHandler.Fire

-- ============================================================
-- [SURFACE PENETRATION] core
-- no metamethod hooks. on each shot: walk the shot line with workspace:Raycast,
-- set CanQuery=false on up to PenetrationMax non-player parts in front of a player,
-- restore them 350 ms later. nothing is applied when no player is reachable.
-- ============================================================
do
    local Players = game:GetService("Players")
    local rawRaycast = workspace.Raycast
    local Pen = {}
    t1.Pen = Pen

    local function isPlayerPart(inst)
        local model = inst:FindFirstAncestorWhichIsA("Model")
        while model do
            if Players:GetPlayerFromCharacter(model) then return true end
            model = model:FindFirstAncestorWhichIsA("Model")
        end
        return false
    end

    local function restore(list)
        for _, e in ipairs(list) do
            pcall(function() e.part.CanQuery = e.was end)
        end
    end

    function Pen.arm(data)
        if not (getgenv().PenetrationEnabled or getgenv().WallbangEnabled) then return end
        if not data or not data.Origin or not data.Direction then return end

        local limit = getgenv().PenetrationMax or 3
        local origin = data.Origin
        local dir = data.Direction.Unit * 1000
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
            touched[#touched + 1] = { part = res.Instance, was = res.Instance.CanQuery }
            ignore[#ignore + 1] = res.Instance
        end

        if not reached or #touched == 0 then return end
        for _, e in ipairs(touched) do
            pcall(function() e.part.CanQuery = false end)
        end
        task.delay(0.35, function() restore(touched) end)
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
    t1.lastFire = os.clock()
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
    
    if not shouldChange and getgenv().WallbangEnabled then
        target = getWallbangTarget()
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

-- ============================================================
-- [WALLBANG AUTO FIRE] цель зашла в WallbangFOV -> стреляет сам
-- ============================================================
task.spawn(function()
    while true do
        local g = getgenv()
        if g.WallbangEnabled and g.WallbangAutoFire
            and not (g.RageBotEnabled and g.RageBotAutoFire) and getWallbangTarget() then
            local interval, hold = 0.1, 0.05
            if g.AttackIntervalEnabled then
                interval = g.AttackInterval / 1000
                hold = math.min(g.AttackHold / 1000, interval)
            end
            SignalManager.Fire("FireWeapon", Enum.UserInputState.Begin)
            task.wait(hold)
            SignalManager.Fire("FireWeapon", Enum.UserInputState.End)
            task.wait(math.max(interval - hold, 0.01))
        else
            task.wait(0.05)
        end
    end
end)

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

v22:AddToggle({
    Name = "Wallbang Auto Fire (in FOV)",
    Flag = "WallbangAutoFire",
    Default = getgenv().WallbangAutoFire,
    Callback = function(p)
        getgenv().WallbangAutoFire = p
    end
})

v22:AddSlider({
    Name = "Wallbang FOV",
    Flag = "WallbangFOV",
    Min = 1,
    Max = 180,
    Default = math.clamp(getgenv().WallbangFOV, 1, 180),
    Callback = function(p)
        getgenv().WallbangFOV = p
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
    -- показывает круг либо silent aim FOV, либо wallbang FOV (что сейчас активно)
    local silentOn = getgenv().SilentAimFOVEnabled and getgenv().SilentAim
    local wallbangOn = getgenv().WallbangEnabled
    local radius = getgenv().SilentAimFOV or 50
    if not silentOn and wallbangOn then
        -- wallbang FOV в градусах -> пиксели экрана
        local c = workspace.CurrentCamera
        local deg = math.clamp(getgenv().WallbangFOV or 30, 1, 89)
        radius = math.tan(math.rad(deg)) / math.tan(math.rad(c.FieldOfView / 2)) * (c.ViewportSize.Y / 2)
        radius = math.clamp(radius, 5, 2000)
    end
    fovCircleFrame.Size = UDim2.new(0, radius * 2, 0, radius * 2)
    fovCircleFrame.Visible = silentOn or wallbangOn
end

RunService.RenderStepped:Connect(function()
    uiGradient.Rotation = uiGradient.Rotation + rotationSpeed
    updateFOVCircle()
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
-- ============================================================
-- [CUSTOM GUN SOUND]
-- раньше менялся SoundId у всех GunShot в игре: звук перезагружался в момент
-- выстрела (отсюда задержка и промахи рейдж бота), а при выключении все
-- звуки возвращались разом (оглушительный шум). теперь SoundId НЕ трогаем:
-- оригинал глушится через SoundGroup (громкость 0), а наш звук играется
-- отдельным Sound в момент выстрела. выключение просто возвращает SoundGroup.
-- ID взяты из открытых списков и не проверены: мёртвый ID = тишина, тогда
-- включение откатывается и оригинал остаётся (см. уведомление).
-- ============================================================
do
    local SoundService = game:GetService("SoundService")
    local ContentProvider = game:GetService("ContentProvider")
    local Debris = game:GetService("Debris")

    local GUN_SOUNDS = {
        ["Default"] = "rbxassetid://2476571739",
        ["Sniper"] = "rbxassetid://138854039966754",
        ["Gunshot"] = "rbxassetid://127646504338729",
        ["Shotgun"] = "rbxassetid://9077115754",
        ["Boom Headshot"] = "rbxassetid://7361085557",
        ["Realistic Rifle"] = "rbxassetid://92011177452282",
        ["Rifle 2021"] = "rbxassetid://6862108495",
        ["Colt Commando"] = "rbxassetid://6523957098",
        ["Gunshot SFX"] = "rbxassetid://6656835390",
        ["Gun Shot"] = "rbxassetid://1905367471",
        ["AWP"] = "rbxassetid://1868836",
    }
    local GUN_ORDER = { "Default", "Sniper", "Gunshot", "Shotgun", "Boom Headshot", "Realistic Rifle",
        "Rifle 2021", "Colt Commando", "Gunshot SFX", "Gun Shot", "AWP" }

    local muteGroup = Instance.new("SoundGroup")
    muteGroup.Name = "\0g"
    muteGroup.Volume = 0
    muteGroup.Parent = SoundService

    local tracked = {} -- [sound] = { group, conns }
    local active = false
    local addConn

    local function soundId(sound)
        local choice = getgenv().GunSoundType or "Default"
        if choice == "Default" then
            local model = sound:FindFirstAncestorWhichIsA("Model")
            if model and model.Name == "Revolver" then return "rbxassetid://18302097184" end
        end
        return GUN_SOUNDS[choice] or GUN_SOUNDS.Default
    end

    local function playCustom(sound)
        if not active then return end
        local s = Instance.new("Sound")
        s.SoundId = soundId(sound)
        s.Volume = (getgenv().GunSoundVolume or 50) / 100 * 2
        s.RollOffMaxDistance = 600
        local par = sound.Parent
        if par and (par:IsA("BasePart") or par:IsA("Attachment")) then
            s.Parent = par
        else
            s.Parent = SoundService
        end
        s:Play()
        Debris:AddItem(s, 5)
    end

    local function attach(sound)
        if tracked[sound] or not sound:IsA("Sound") or sound.Name ~= "GunShot" then return end
        local rec = { group = sound.SoundGroup, conns = {} }
        tracked[sound] = rec
        sound.SoundGroup = muteGroup
        rec.conns[#rec.conns + 1] = sound.Played:Connect(function() playCustom(sound) end)
        if sound.PlayOnRemove then
            rec.conns[#rec.conns + 1] = sound.Destroying:Connect(function() playCustom(sound) end)
        end
        if sound.IsPlaying then playCustom(sound) end
    end

    local function detachAll()
        for sound, rec in pairs(tracked) do
            for _, c in ipairs(rec.conns) do c:Disconnect() end
            if sound.Parent then pcall(function() sound.SoundGroup = rec.group end) end
        end
        table.clear(tracked)
        if addConn then addConn:Disconnect() addConn = nil end
    end

    local function enable()
        active = true
        for _, d in ipairs(workspace:GetDescendants()) do
            if d:IsA("Sound") then attach(d) end
        end
        local bp = t1.value8:FindFirstChildOfClass("Backpack")
        if bp then
            for _, d in ipairs(bp:GetDescendants()) do
                if d:IsA("Sound") then attach(d) end
            end
        end
        addConn = workspace.DescendantAdded:Connect(function(d)
            if d:IsA("Sound") then attach(d) end
        end)
    end

    local function disable()
        active = false
        detachAll()
    end

    -- проверка, что ID вообще грузится; иначе не глушим оригинал
    local function verify(cb)
        task.spawn(function()
            local id = GUN_SOUNDS[getgenv().GunSoundType or "Default"] or GUN_SOUNDS.Default
            local t = Instance.new("Sound")
            t.SoundId = id
            pcall(function() ContentProvider:PreloadAsync({ t }) end)
            local ok = t.TimeLength > 0
            t:Destroy()
            cb(ok)
        end)
    end

    local function apply()
        disable()
        if not getgenv().GunSoundEnabled then return end
        verify(function(ok)
            if not getgenv().GunSoundEnabled then return end
            if ok then
                enable()
            else
                v11:Notify({ Title = "GUN SOUND", Content = "sound failed to load, original kept (pick another)", Icon = "x" })
            end
        end)
    end

    v21:AddToggle({
        Name = "Custom gun sound",
        Flag = "CustomGunSound",
        Default = getgenv().GunSoundEnabled,
        Callback = function(p)
            getgenv().GunSoundEnabled = p
            apply()
        end
    })
    v21:AddDropdown({
        Name = "Gun sound",
        Flag = "GunSoundType",
        Values = GUN_ORDER,
        Default = getgenv().GunSoundType,
        Callback = function(p)
            getgenv().GunSoundType = p
            if getgenv().GunSoundEnabled then apply() end
        end
    })
    v21:AddSlider({
        Name = "Gun volume",
        Flag = "GunSoundVolume",
        Min = 0, Max = 100,
        Default = math.clamp(getgenv().GunSoundVolume, 0, 100),
        Callback = function(p) getgenv().GunSoundVolume = p end
    })
end
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
-- ============================================================
-- [ESP] Drawing API: 2D box / corners / 3D box, fill, health bar, name,
-- distance, skeleton, tracers. у каждого элемента свой цвет.
-- ============================================================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lp = Players.LocalPlayer
    local env = getgenv()
    local BLACK = Color3.new(0, 0, 0)

    local function toHex(c)
        return string.format("%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
    end
    local function fromHex(h, fallback)
        if type(h) ~= "string" or #h ~= 6 then return fallback end
        local r, g, b = tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)
        if not (r and g and b) then return fallback end
        return Color3.fromRGB(r, g, b)
    end

    local col = {
        box = fromHex(env.EspBoxColorHex, Color3.fromRGB(255, 255, 255)),
        fill = fromHex(env.EspFillColorHex, Color3.fromRGB(255, 77, 109)),
        health = fromHex(env.EspHealthColorHex, Color3.fromRGB(0, 255, 120)),
        name = fromHex(env.EspNameColorHex, Color3.fromRGB(255, 255, 255)),
        dist = fromHex(env.EspDistColorHex, Color3.fromRGB(200, 200, 255)),
        skel = fromHex(env.EspSkelColorHex, Color3.fromRGB(255, 255, 255)),
        tracer = fromHex(env.EspTracerColorHex, Color3.fromRGB(255, 77, 109)),
    }

    local function new(class, props)
        local d = Drawing.new(class)
        for k, v in pairs(props) do d[k] = v end
        return d
    end

    local objs = {}
    local function make()
        local o = {
            boxOut = new("Square", { Thickness = 3, Filled = false, Color = BLACK, Visible = false }),
            box = new("Square", { Thickness = 1, Filled = false, Visible = false }),
            fill = new("Square", { Filled = true, Visible = false }),
            hpBg = new("Square", { Filled = true, Color = BLACK, Transparency = 0.7, Visible = false }),
            hp = new("Square", { Filled = true, Visible = false }),
            name = new("Text", { Size = 13, Center = true, Outline = true, Visible = false }),
            dist = new("Text", { Size = 12, Center = true, Outline = true, Visible = false }),
            tracer = new("Line", { Thickness = 1, Visible = false }),
            corners = {}, cornersOut = {}, cube = {}, bones = {},
        }
        pcall(function() o.name.Font = 2; o.dist.Font = 2 end)
        for i = 1, 8 do
            o.cornersOut[i] = new("Line", { Thickness = 3, Color = BLACK, Visible = false })
            o.corners[i] = new("Line", { Thickness = 1, Visible = false })
        end
        for i = 1, 12 do o.cube[i] = new("Line", { Thickness = 1, Visible = false }) end
        for i = 1, 14 do o.bones[i] = new("Line", { Thickness = 1, Visible = false }) end
        return o
    end

    local function eachDrawing(o, fn)
        for k, v in pairs(o) do
            if type(v) == "table" and v.Remove == nil then
                for _, d in ipairs(v) do fn(d) end
            else
                fn(v)
            end
        end
    end
    local function hide(o) eachDrawing(o, function(d) d.Visible = false end) end

    Players.PlayerRemoving:Connect(function(pl)
        local o = objs[pl]
        if o then
            eachDrawing(o, function(d) pcall(function() d:Remove() end) end)
            objs[pl] = nil
        end
    end)

    local R15 = {
        { "Head", "UpperTorso" }, { "UpperTorso", "LowerTorso" },
        { "UpperTorso", "LeftUpperArm" }, { "LeftUpperArm", "LeftLowerArm" }, { "LeftLowerArm", "LeftHand" },
        { "UpperTorso", "RightUpperArm" }, { "RightUpperArm", "RightLowerArm" }, { "RightLowerArm", "RightHand" },
        { "LowerTorso", "LeftUpperLeg" }, { "LeftUpperLeg", "LeftLowerLeg" }, { "LeftLowerLeg", "LeftFoot" },
        { "LowerTorso", "RightUpperLeg" }, { "RightUpperLeg", "RightLowerLeg" }, { "RightLowerLeg", "RightFoot" },
    }
    local R6 = {
        { "Head", "Torso" }, { "Torso", "Left Arm" }, { "Torso", "Right Arm" },
        { "Torso", "Left Leg" }, { "Torso", "Right Leg" },
    }
    local CUBE_EDGES = {
        { 1, 2 }, { 2, 4 }, { 4, 3 }, { 3, 1 }, { 5, 6 }, { 6, 8 }, { 8, 7 }, { 7, 5 },
        { 1, 5 }, { 2, 6 }, { 3, 7 }, { 4, 8 },
    }

    local function render(cam, vp, player, o)
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        if not (hum and hrp and head) or hum.Health <= 0 then return hide(o) end
        if env.EspTeamCheck and player.Team ~= nil and lp.Team ~= nil and player.Team == lp.Team then return hide(o) end

        local c3, onScreen = cam:WorldToViewportPoint(hrp.Position)
        if c3.Z <= 0 then return hide(o) end
        local dist = (cam.CFrame.Position - hrp.Position).Magnitude
        if dist > (env.EspMaxDist or 1500) then return hide(o) end

        local top = cam:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y / 2 + 0.15, 0))
        local bot = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.1, 0))
        local h = math.abs(bot.Y - top.Y)
        if h < 2 then return hide(o) end
        local w = h * 0.55
        local cx = c3.X
        local x, y = cx - w / 2, top.Y

        local boxType = env.EspBoxType or "2D"
        local outline = env.EspOutline ~= false
        local thick = env.EspThickness or 1

        -- 2D box
        local show2d = boxType == "2D"
        o.boxOut.Visible = show2d and outline
        o.box.Visible = show2d
        if show2d then
            o.boxOut.Position, o.boxOut.Size = Vector2.new(x, y), Vector2.new(w, h)
            o.boxOut.Thickness = thick + 2
            o.box.Position, o.box.Size = Vector2.new(x, y), Vector2.new(w, h)
            o.box.Thickness = thick
            o.box.Color = col.box
        end

        -- corner box
        local showCorners = boxType == "Corners"
        local lx, ly = w * 0.3, h * 0.22
        local cs = {
            { Vector2.new(x, y), Vector2.new(x + lx, y) }, { Vector2.new(x, y), Vector2.new(x, y + ly) },
            { Vector2.new(x + w, y), Vector2.new(x + w - lx, y) }, { Vector2.new(x + w, y), Vector2.new(x + w, y + ly) },
            { Vector2.new(x, y + h), Vector2.new(x + lx, y + h) }, { Vector2.new(x, y + h), Vector2.new(x, y + h - ly) },
            { Vector2.new(x + w, y + h), Vector2.new(x + w - lx, y + h) }, { Vector2.new(x + w, y + h), Vector2.new(x + w, y + h - ly) },
        }
        for i = 1, 8 do
            local l, lo = o.corners[i], o.cornersOut[i]
            l.Visible = showCorners
            lo.Visible = showCorners and outline
            if showCorners then
                l.From, l.To, l.Color, l.Thickness = cs[i][1], cs[i][2], col.box, thick
                lo.From, lo.To, lo.Thickness = cs[i][1], cs[i][2], thick + 2
            end
        end

        -- 3D box
        local show3d = false
        if boxType == "3D" then
            local cf = hrp.CFrame
            local pts, ok = {}, true
            local idx = 0
            for _, sx in ipairs({ -1, 1 }) do
                for _, sy in ipairs({ -1, 1 }) do
                    for _, sz in ipairs({ -1, 1 }) do
                        idx += 1
                        local p = cam:WorldToViewportPoint((cf * CFrame.new(sx * 2, sy * 3 - 0.1, sz * 1.1)).Position)
                        if p.Z <= 0 then ok = false end
                        pts[idx] = Vector2.new(p.X, p.Y)
                    end
                end
            end
            show3d = ok
            if ok then
                for i, e in ipairs(CUBE_EDGES) do
                    local l = o.cube[i]
                    l.From, l.To, l.Color, l.Thickness = pts[e[1]], pts[e[2]], col.box, thick
                end
            end
        end
        for i = 1, 12 do o.cube[i].Visible = show3d end

        -- fill
        o.fill.Visible = env.EspFill == true and boxType ~= "Off"
        if o.fill.Visible then
            o.fill.Position, o.fill.Size = Vector2.new(x, y), Vector2.new(w, h)
            o.fill.Color = col.fill
            o.fill.Transparency = (env.EspFillAlpha or 25) / 100
        end

        -- health bar
        local showHp = env.EspHealth == true
        o.hpBg.Visible, o.hp.Visible = showHp, showHp
        if showHp then
            local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
            o.hpBg.Position, o.hpBg.Size = Vector2.new(x - 7, y - 1), Vector2.new(4, h + 2)
            o.hp.Position, o.hp.Size = Vector2.new(x - 6, y + h * (1 - ratio)), Vector2.new(2, h * ratio)
            o.hp.Color = (env.EspHealthGradient ~= false) and Color3.fromHSV(ratio * 0.33, 0.9, 1) or col.health
        end

        -- name / distance
        o.name.Visible = env.EspName == true
        if o.name.Visible then
            o.name.Text = player.DisplayName
            o.name.Position = Vector2.new(cx, y - 16)
            o.name.Color = col.name
        end
        o.dist.Visible = env.EspDist == true
        if o.dist.Visible then
            o.dist.Text = "[" .. math.floor(dist) .. "m]"
            o.dist.Position = Vector2.new(cx, y + h + 2)
            o.dist.Color = col.dist
        end

        -- tracer
        o.tracer.Visible = env.EspTracers == true
        if o.tracer.Visible then
            local from = env.EspTracerFrom or "Bottom"
            local fy = from == "Top" and 0 or (from == "Center" and vp.Y / 2 or vp.Y)
            o.tracer.From = Vector2.new(vp.X / 2, fy)
            o.tracer.To = Vector2.new(cx, y + h)
            o.tracer.Color = col.tracer
        end

        -- skeleton
        local showSk = env.EspSkeleton == true
        if showSk then
            local pairsList = char:FindFirstChild("UpperTorso") and R15 or R6
            for i = 1, 14 do
                local l, pr = o.bones[i], pairsList[i]
                local a = pr and char:FindFirstChild(pr[1])
                local b = pr and char:FindFirstChild(pr[2])
                if a and b then
                    local pa, pb = cam:WorldToViewportPoint(a.Position), cam:WorldToViewportPoint(b.Position)
                    if pa.Z > 0 and pb.Z > 0 then
                        l.From, l.To = Vector2.new(pa.X, pa.Y), Vector2.new(pb.X, pb.Y)
                        l.Color = col.skel
                        l.Visible = true
                    else
                        l.Visible = false
                    end
                else
                    l.Visible = false
                end
            end
        else
            for i = 1, 14 do o.bones[i].Visible = false end
        end
    end

    local wasOn = false
    RunService.RenderStepped:Connect(function()
        if not env.EspEnabled then
            if wasOn then
                for _, o in pairs(objs) do hide(o) end
                wasOn = false
            end
            return
        end
        wasOn = true
        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= lp then
                local o = objs[pl]
                if not o then o = make(); objs[pl] = o end
                local ok = pcall(render, cam, vp, pl, o)
                if not ok then hide(o) end
            end
        end
    end)

    -- ---------------- UI (VISUALS) ----------------
    local secE = t1.mVisuals:AddSection({ Position = "left", Name = "ESP" })
    secE:AddToggle({ Name = "Enable ESP", Flag = "EspEnabled", Default = env.EspEnabled,
        Callback = function(p) env.EspEnabled = p end })
    secE:AddDropdown({ Name = "Box type", Flag = "EspBoxType", Values = { "2D", "Corners", "3D", "Off" },
        Default = env.EspBoxType, Callback = function(p) env.EspBoxType = p end })
    secE:AddColorPicker({ Name = "Box color", Flag = "EspBoxColor", Default = col.box,
        Callback = function(c) col.box = c; env.EspBoxColorHex = toHex(c) end })
    secE:AddSlider({ Name = "Box thickness", Flag = "EspThicknessS", Min = 1, Max = 4,
        Default = math.clamp(env.EspThickness, 1, 4), Callback = function(p) env.EspThickness = p end })
    secE:AddToggle({ Name = "Outline", Flag = "EspOutlineT", Default = env.EspOutline,
        Callback = function(p) env.EspOutline = p end })
    secE:AddToggle({ Name = "Fill box", Flag = "EspFillT", Default = env.EspFill,
        Callback = function(p) env.EspFill = p end })
    secE:AddColorPicker({ Name = "Fill color", Flag = "EspFillColor", Default = col.fill,
        Callback = function(c) col.fill = c; env.EspFillColorHex = toHex(c) end })
    secE:AddSlider({ Name = "Fill opacity", Flag = "EspFillAlphaS", Min = 0, Max = 100,
        Default = math.clamp(env.EspFillAlpha, 0, 100), Callback = function(p) env.EspFillAlpha = p end })
    secE:AddToggle({ Name = "Team check (hide mates)", Flag = "EspTeamT", Default = env.EspTeamCheck,
        Callback = function(p) env.EspTeamCheck = p end })
    secE:AddSlider({ Name = "Max distance", Flag = "EspMaxDistS", Min = 50, Max = 3000,
        Default = math.clamp(env.EspMaxDist, 50, 3000), Callback = function(p) env.EspMaxDist = p end })

    local secI = t1.mVisuals:AddSection({ Position = "center", Name = "ESP INFO" })
    secI:AddToggle({ Name = "Health bar", Flag = "EspHealthT", Default = env.EspHealth,
        Callback = function(p) env.EspHealth = p end })
    secI:AddToggle({ Name = "Health gradient", Flag = "EspHealthGradT", Default = env.EspHealthGradient,
        Callback = function(p) env.EspHealthGradient = p end })
    secI:AddColorPicker({ Name = "Health color (no gradient)", Flag = "EspHealthColor", Default = col.health,
        Callback = function(c) col.health = c; env.EspHealthColorHex = toHex(c) end })
    secI:AddToggle({ Name = "Name", Flag = "EspNameT", Default = env.EspName,
        Callback = function(p) env.EspName = p end })
    secI:AddColorPicker({ Name = "Name color", Flag = "EspNameColor", Default = col.name,
        Callback = function(c) col.name = c; env.EspNameColorHex = toHex(c) end })
    secI:AddToggle({ Name = "Distance", Flag = "EspDistT", Default = env.EspDist,
        Callback = function(p) env.EspDist = p end })
    secI:AddColorPicker({ Name = "Distance color", Flag = "EspDistColor", Default = col.dist,
        Callback = function(c) col.dist = c; env.EspDistColorHex = toHex(c) end })
    secI:AddToggle({ Name = "Skeleton", Flag = "EspSkelT", Default = env.EspSkeleton,
        Callback = function(p) env.EspSkeleton = p end })
    secI:AddColorPicker({ Name = "Skeleton color", Flag = "EspSkelColor", Default = col.skel,
        Callback = function(c) col.skel = c; env.EspSkelColorHex = toHex(c) end })
    secI:AddToggle({ Name = "Tracers", Flag = "EspTracersT", Default = env.EspTracers,
        Callback = function(p) env.EspTracers = p end })
    secI:AddDropdown({ Name = "Tracer from", Flag = "EspTracerFromD", Values = { "Bottom", "Center", "Top" },
        Default = env.EspTracerFrom, Callback = function(p) env.EspTracerFrom = p end })
    secI:AddColorPicker({ Name = "Tracer color", Flag = "EspTracerColor", Default = col.tracer,
        Callback = function(c) col.tracer = c; env.EspTracerColorHex = toHex(c) end })
end
t1.value76 = game:GetService("Players")
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
    local lowerTorso = char:FindFirstChild("LowerTorso")

    if mode ~= "Jitler" and mode ~= "Yitler" and mode ~= "Back" and mode ~= "Undo Back" then
        for motor, origC0 in pairs(OriginalJointsCache) do
            if motor and motor.Parent then
                motor.C0 = origC0
            end
        end
        return
    end

    local jitterOsc = 0 -- Jitler/Yitler больше не трясутся, поза статична
    local hum0 = char:FindFirstChildOfClass("Humanoid")
    local airborne = hum0 and (hum0:GetState() == Enum.HumanoidStateType.Jumping or hum0:GetState() == Enum.HumanoidStateType.Freefall)

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
            -- руки просто вверх, без тряски
            if neck and OriginalJointsCache[neck] then
                neck.C0 = OriginalJointsCache[neck] * CFrame.Angles(-math.rad(75), 0, 0)
            end
            if rShoulder and OriginalJointsCache[rShoulder] then
                rShoulder.C0 = OriginalJointsCache[rShoulder] * CFrame.Angles(0, 0, math.rad(165))
            end
            if lShoulder and OriginalJointsCache[lShoulder] then
                lShoulder.C0 = OriginalJointsCache[lShoulder] * CFrame.Angles(0, 0, -math.rad(165))
            end
            if rHip and OriginalJointsCache[rHip] then
                rHip.C0 = OriginalJointsCache[rHip]
            end
            if lHip and OriginalJointsCache[lHip] then
                lHip.C0 = OriginalJointsCache[lHip]
            end
        elseif mode == "Yitler" then
            -- руки вверх как в Jitler, ноги сгибаются в коленях только в прыжке
            if neck and OriginalJointsCache[neck] then
                neck.C0 = OriginalJointsCache[neck] * CFrame.Angles(-math.rad(70), 0, 0)
            end
            if rShoulder and OriginalJointsCache[rShoulder] then
                rShoulder.C0 = OriginalJointsCache[rShoulder] * CFrame.Angles(0, 0, math.rad(160))
            end
            if lShoulder and OriginalJointsCache[lShoulder] then
                lShoulder.C0 = OriginalJointsCache[lShoulder] * CFrame.Angles(0, 0, -math.rad(160))
            end
            if airborne then
                if rHip and OriginalJointsCache[rHip] then
                    rHip.C0 = OriginalJointsCache[rHip] * CFrame.new(0, 0.45, -0.35) * CFrame.Angles(-math.rad(55), 0, -math.rad(85))
                end
                if lHip and OriginalJointsCache[lHip] then
                    lHip.C0 = OriginalJointsCache[lHip] * CFrame.new(0, 0.45, -0.35) * CFrame.Angles(-math.rad(55), 0, math.rad(85))
                end
            else
                if rHip and OriginalJointsCache[rHip] then rHip.C0 = OriginalJointsCache[rHip] end
                if lHip and OriginalJointsCache[lHip] then lHip.C0 = OriginalJointsCache[lHip] end
            end

            if mode == "Back" or mode == "Undo Back" then
                local bend = (mode == "Undo Back") and 95 or 50
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
            end
        end
    elseif upperTorso and lowerTorso then
        -- R15 персонаж
        local neck = char:FindFirstChild("Head") and char.Head:FindFirstChild("Neck") or upperTorso:FindFirstChild("Neck")
        local rShoulder = char:FindFirstChild("RightUpperArm") and char.RightUpperArm:FindFirstChild("RightShoulder")
        local lShoulder = char:FindFirstChild("LeftUpperArm") and char.LeftUpperArm:FindFirstChild("LeftShoulder")
        local rElbow = char:FindFirstChild("RightLowerArm") and char.RightLowerArm:FindFirstChild("RightElbow")
        local lElbow = char:FindFirstChild("LeftLowerArm") and char.LeftLowerArm:FindFirstChild("LeftElbow")
        local rHip = char:FindFirstChild("RightUpperLeg") and char.RightUpperLeg:FindFirstChild("RightHip")
        local lHip = char:FindFirstChild("LeftUpperLeg") and char.LeftUpperLeg:FindFirstChild("LeftHip")
        local rKnee = char:FindFirstChild("RightLowerLeg") and char.RightLowerLeg:FindFirstChild("RightKnee")
        local lKnee = char:FindFirstChild("LeftLowerLeg") and char.LeftLowerLeg:FindFirstChild("LeftKnee")

        for _, m in ipairs({neck, rShoulder, lShoulder, rElbow, lElbow, rHip, lHip, rKnee, lKnee}) do
            SaveOriginalJoint(m)
        end

        if mode == "Jitler" then
            -- руки просто вверх, без тряски
            if neck and OriginalJointsCache[neck] then
                neck.C0 = OriginalJointsCache[neck] * CFrame.Angles(math.rad(75), 0, 0)
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
            -- руки вверх как в Jitler, ноги гнутся в коленях только пока игрок в воздухе
            if neck and OriginalJointsCache[neck] then
                neck.C0 = OriginalJointsCache[neck] * CFrame.Angles(math.rad(75), 0, 0)
            end
            if rShoulder and OriginalJointsCache[rShoulder] then
                rShoulder.C0 = OriginalJointsCache[rShoulder] * CFrame.Angles(math.rad(165), 0, math.rad(20))
            end
            if lShoulder and OriginalJointsCache[lShoulder] then
                lShoulder.C0 = OriginalJointsCache[lShoulder] * CFrame.Angles(math.rad(165), 0, -math.rad(20))
            end
            if airborne then
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

            if mode == "Back" or mode == "Undo Back" then
                local bend = (mode == "Undo Back") and 95 or 50
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
    end
end

-- ============================================================
-- [SPIN] section (MOVEMENT tab): mode picker is always visible
-- modes: Basic Spin, Jitler, Yitler, Sway, Static Jitter
-- ============================================================
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
            if val == "Undo" or val == "Back" or val == "Undo Back" then
                t1.UndoStart = tick()
            else
                t1.UndoStart = nil
            end
        end
    })
    sec:AddSlider({
        Name = "Undo/Back Duration (s)",
        Flag = "UndoDuration",
        Min = 1, Max = 10,
        Default = math.clamp(getgenv().UndoDuration, 1, 10),
        Callback = function(val) getgenv().UndoDuration = val end
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

-- kill tracker для Back / Undo Back: запоминаем, где умер последний убитый
local LastDeathPos = nil
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

    -- Undo / Back / Undo Back: держатся UndoDuration секунд, затем сами отключаются
    if t1.UndoStart and (getgenv().SpinMode == "Undo" or getgenv().SpinMode == "Back" or getgenv().SpinMode == "Undo Back")
        and tick() - t1.UndoStart >= (getgenv().UndoDuration or 2) then
        getgenv().SpinMode = "Basic Spin"
        getgenv().SpinEnabled = false
        t1.UndoStart = nil
        for motor, origC0 in pairs(OriginalJointsCache) do
            if motor and motor.Parent then motor.C0 = origC0 end
        end
        hum.AutoRotate = true
        return
    end

    hum.AutoRotate = false
    local spinMode0 = getgenv().SpinMode
    if spinMode0 == "Back" or spinMode0 == "Undo Back" then
        -- разворот тела в сторону последнего убитого
        if LastDeathPos then
            local flat = Vector3.new(LastDeathPos.X - hrp.Position.X, 0, LastDeathPos.Z - hrp.Position.Z)
            if flat.Magnitude > 0.5 then
                hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat)
            end
        end
        if spinMode0 == "Undo Back" then
            ApplyPoseMode(char, "Undo Back", tick())
        else
            for motor, origC0 in pairs(OriginalJointsCache) do
                if motor and motor.Parent then
                    motor.C0 = origC0
                end
            end
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
    if mode == "Undo" then
        hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, finalYaw, 0) * CFrame.Angles(math.rad(30), 0, 0)
    else
        hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, finalYaw, math.rad(rollDeg))
    end

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

getgenv().BulletTrailColor = Color3.fromRGB(205, 50, 255)

local TrailsList = {}
local TRAIL_MODELS = {
    "Default", "Thunder", "Arrow", "Thick Beam", "Dotted", "Helix",
    "DNA", "Sparks", "Rainbow", "Fire", "Rings", "Glitch"
}
getgenv().BulletTrailModel = getgenv().BulletTrailModel or "Default"
getgenv().BulletTrailLife = getgenv().BulletTrailLife or 15 -- в долях секунды (15 = 1.5 с)

-- трейлы лежат в папке внутри камеры (не в workspace), чтобы raycast/touch игры их не видел
local trailFolder
local function getTrailFolder()
    local cam = workspace.CurrentCamera
    if not trailFolder or not trailFolder.Parent or trailFolder.Parent ~= cam then
        if not trailFolder then
            trailFolder = Instance.new("Folder")
            trailFolder.Name = "\0fx"
        end
        trailFolder.Parent = cam
    end
    return trailFolder
end

local function trailPart(size, cf, color, life, base, ball)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Size = size
    part.CFrame = cf
    if ball then part.Shape = Enum.PartType.Ball end
    part.Transparency = base or 0
    part.Massless = true
    part.Parent = getTrailFolder()
    life = life * (getgenv().BulletTrailLife or 15) / 15
    TrailsList[#TrailsList + 1] = { Part = part, Life = life, Max = life, Base = base or 0 }
    while #TrailsList > 700 do
        pcall(function() TrailsList[1].Part:Destroy() end)
        table.remove(TrailsList, 1)
    end
    return part
end

local function trailSeg(a, b, w, color, life, base)
    local len = (a - b).Magnitude
    if len < 0.01 then return end
    return trailPart(Vector3.new(w, w, len), CFrame.new(a, b) * CFrame.new(0, 0, -len / 2), color, life, base)
end

local function trailBall(pos, size, color, life, base)
    return trailPart(Vector3.new(size, size, size), CFrame.new(pos), color, life, base, true)
end

local trailFrame = 0
local function CreateBulletTrail(startPos, endPos, color)
    local len = (endPos - startPos).Magnitude
    if len < 0.01 then return end
    local model = getgenv().BulletTrailModel
    local cf = CFrame.new(startPos, endPos)
    local dir, right, up = cf.LookVector, cf.RightVector, cf.UpVector
    local rnd = math.random
    trailFrame += 1

    if model == "Thunder" then
        local n = math.max(2, math.floor(len / 1.5))
        local prev = startPos
        for i = 1, n do
            local p = startPos:Lerp(endPos, i / n)
            if i < n then
                p = p + right * (rnd() - 0.5) * 1.4 + up * (rnd() - 0.5) * 1.4
            end
            trailSeg(prev, p, 0.28, color, 0.35, 0.6)
            trailSeg(prev, p, 0.08, Color3.new(1, 1, 1), 0.35)
            prev = p
        end
    elseif model == "Arrow" then
        trailSeg(startPos, endPos, 0.05, color, 0.9)
        if len > 0.3 then
            local back = -dir * 0.8
            for _, side in ipairs({ right, -right, up, -up }) do
                trailSeg(endPos, endPos + back + side * 0.35, 0.06, color, 0.9)
            end
        end
    elseif model == "Thick Beam" then
        trailSeg(startPos, endPos, 0.35, color, 1.0, 0.45)
        trailSeg(startPos, endPos, 0.12, Color3.new(1, 1, 1), 1.0)
    elseif model == "Dotted" then
        trailBall(endPos, 0.32, color, 1.4)
    elseif model == "Helix" then
        local a = os.clock() * 25
        local off = right * math.cos(a) * 0.7 + up * math.sin(a) * 0.7
        trailBall(endPos + off, 0.2, color, 1.2)
    elseif model == "DNA" then
        local a = os.clock() * 22
        local off = right * math.cos(a) * 0.7 + up * math.sin(a) * 0.7
        local inv = Color3.new(1 - color.R, 1 - color.G, 1 - color.B)
        trailBall(endPos + off, 0.22, color, 1.2)
        trailBall(endPos - off, 0.22, inv, 1.2)
        if trailFrame % 2 == 0 then
            trailSeg(endPos + off, endPos - off, 0.04, Color3.new(1, 1, 1), 1.0, 0.3)
        end
    elseif model == "Sparks" then
        for _ = 1, 4 do
            local v = Vector3.new(rnd() - 0.5, rnd() - 0.5, rnd() - 0.5) * 1.2
            trailBall(endPos + v, 0.12, rnd() > 0.5 and color or Color3.new(1, 1, 1), 0.5)
        end
        trailSeg(startPos, endPos, 0.04, color, 0.5)
    elseif model == "Rainbow" then
        trailSeg(startPos, endPos, 0.12, Color3.fromHSV((os.clock() * 0.8) % 1, 1, 1), 1.5)
    elseif model == "Fire" then
        local j = Vector3.new(rnd() - 0.5, rnd() - 0.5, rnd() - 0.5) * 0.3
        trailSeg(startPos + j, endPos + j, 0.2, Color3.fromRGB(255, 90, 0), 0.7, 0.35)
        trailSeg(startPos, endPos, 0.07, Color3.fromRGB(255, 220, 80), 0.7)
        trailBall(endPos + Vector3.new(0, rnd() * 0.6, 0) + j, 0.14, Color3.fromRGB(255, 150, 20), 0.6)
    elseif model == "Rings" then
        if trailFrame % 2 == 0 then
            trailPart(Vector3.new(0.05, 1.3, 1.3), CFrame.new(endPos, endPos + dir) * CFrame.Angles(0, math.rad(90), 0),
                color, 0.8, 0.3).Shape = Enum.PartType.Cylinder
        end
        trailSeg(startPos, endPos, 0.04, color, 0.8)
    elseif model == "Glitch" then
        for _ = 1, 3 do
            local v = Vector3.new(rnd() - 0.5, rnd() - 0.5, rnd() - 0.5) * 1.0
            local sz = 0.1 + rnd() * 0.3
            trailPart(Vector3.new(sz, sz, sz * (1 + rnd() * 3)), CFrame.new(endPos + v, endPos + v + dir),
                rnd() > 0.5 and color or Color3.fromHSV(rnd(), 1, 1), 0.4)
        end
        trailSeg(startPos, endPos, 0.05, color, 0.4)
    else
        trailSeg(startPos, endPos, 0.06, color, 1.5)
    end
end

RunService.RenderStepped:Connect(function(dt)
    for i = #TrailsList, 1, -1 do
        local t = TrailsList[i]
        t.Life = t.Life - dt

        if t.Life <= 0 or not t.Part.Parent then
            pcall(function()
                t.Part:Destroy()
            end)
            table.remove(TrailsList, i)
        else
            t.Part.Transparency = t.Base + (1 - t.Base) * (1 - t.Life / t.Max)
        end
    end
end)

-- не создаём bulletStorage сами: пустая папка с этим именем могла ломать код игры.
-- ждём, пока игра создаст её, и только слушаем.
task.spawn(function()
    local bulletStorage
    while not bulletStorage do
        bulletStorage = t1.value1:FindFirstChild("bulletStorage")
        if not bulletStorage then task.wait(1) end
    end

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
end)

v18:AddToggle({
    Name = "Bullet Trails",
    Flag = "BulletTrails",
    Default = getgenv().BulletTrailsEnabled,
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

v18:AddSlider({
    Name = "Trail Lifetime (x0.1s)",
    Flag = "BulletTrailLife",
    Min = 2, Max = 100,
    Default = math.clamp(getgenv().BulletTrailLife, 2, 100),
    Callback = function(p)
        getgenv().BulletTrailLife = p
    end
})

v18:AddDropdown({
    Name = "Trail Model",
    Flag = "BulletTrailModel",
    Values = TRAIL_MODELS,
    Default = getgenv().BulletTrailModel,
    Callback = function(p)
        getgenv().BulletTrailModel = p
    end
})


-- ============================================================
-- [NO RELOAD] держит патроны на максимуме (best effort)
-- ищет Int/NumberValue и атрибуты с ammo/mag/clip/bullet/round в оружии,
-- на персонаже, в Backpack и на игроке. если счётчик патронов лежит в
-- памяти модуля, а не в инстансах — в консоли будет [NoReload] 0 tracked
-- ============================================================
do
    local pats = { "ammo", "magazine", "clip", "bullets", "rounds" }
    local exact = { mag = true, mags = true, bullet = true, round = true }
    local skip = { "damage", "speed", "spread", "recoil", "size", "range", "time", "delay",
        "rate", "drop", "penetr", "velocity", "life", "gravity", "max", "pellet", "multi" }
    local function isAmmo(n)
        n = n:lower()
        for _, w in ipairs(skip) do
            if n:find(w, 1, true) then return false end
        end
        if exact[n] then return true end
        for _, w in ipairs(pats) do
            if n:find(w, 1, true) then return true end
        end
        return false
    end

    local maxVal = setmetatable({}, { __mode = "k" })
    local maxAttr = setmetatable({}, { __mode = "k" })
    local tracked = 0

    local function keep(inst)
        if (inst:IsA("IntValue") or inst:IsA("NumberValue")) and isAmmo(inst.Name) then
            local m = maxVal[inst]
            if not m then tracked += 1 end
            if not m or inst.Value > m then m = inst.Value end
            maxVal[inst] = m
            if inst.Value < m then inst.Value = m end
        end
        local am = maxAttr[inst]
        for name, v in pairs(inst:GetAttributes()) do
            if type(v) == "number" and isAmmo(name) then
                if not am then am = {}; maxAttr[inst] = am end
                if not am[name] then tracked += 1 end
                if not am[name] or v > am[name] then am[name] = v end
                if v < am[name] then inst:SetAttribute(name, am[name]) end
            end
        end
    end

    local function sweep(root)
        if not root then return end
        keep(root)
        for _, d in ipairs(root:GetDescendants()) do keep(d) end
    end

    local secNR = t1.mMisc:AddSection({ Position = "center", Name = "NO RELOAD" })
    secNR:AddToggle({
        Name = "No Reload (infinite ammo)",
        Flag = "NoReloadEnabled",
        Default = getgenv().NoReloadEnabled,
        Callback = function(p)
            getgenv().NoReloadEnabled = p
            if p then
                task.delay(1, function()
                    print("[NoReload] " .. tracked .. " tracked")
                end)
            end
        end
    })

    task.spawn(function()
        while task.wait(0.05) do
            if getgenv().NoReloadEnabled then
                local lp = t1.value8
                pcall(function()
                    sweep(lp.Character)
                    sweep(lp:FindFirstChildOfClass("Backpack"))
                    keep(lp)
                end)
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

    local fpsText = Drawing.new("Text")
    fpsText.Visible = false
    fpsText.Size = 14
    fpsText.Color = Color3.fromRGB(180, 180, 255)
    fpsText.Outline = true
    fpsText.Position = Vector2.new(8, 8)
    fpsText.Text = "FPS: ..."
    v17:AddToggle({
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
-- [EFFECTS] вкладка EFFECTS: China hat, фигуры при прыжке/приземлении,
-- эффекты убийств (22 шт, цвет настраивается).
-- эффекты рисуются на клоне персонажа (оригинал прячется локально),
-- всё только на твоей стороне, сервер ничего не видит.
-- ============================================================
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local lp = Players.LocalPlayer
    local env = getgenv()
    local PI = math.pi
    local NEON, SMOOTH = Enum.Material.Neon, Enum.Material.SmoothPlastic

    local function toHex(c)
        return string.format("%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
    end
    local function fromHex(h, fallback)
        if type(h) ~= "string" or #h ~= 6 then return fallback end
        local r, g, b = tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)
        if not (r and g and b) then return fallback end
        return Color3.fromRGB(r, g, b)
    end

    -- ---------------- общие хелперы ----------------
    local folder
    local function fx()
        local cam = workspace.CurrentCamera
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "\0e"
        end
        if folder.Parent ~= cam then folder.Parent = cam end
        return folder
    end

    local function mk(size, cf, color, material, transp, ball)
        local p = Instance.new("Part")
        p.Anchored = true
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.CastShadow = false
        p.Massless = true
        p.Material = material or NEON
        p.Color = color
        p.Size = size
        p.CFrame = cf
        p.Transparency = transp or 0
        if ball then p.Shape = Enum.PartType.Ball end
        p.Parent = fx()
        return p
    end

    local function run(dur, step, done)
        local t = 0
        local conn
        conn = RunService.RenderStepped:Connect(function(dt)
            t += dt
            local a = math.min(t / dur, 1)
            local ok = pcall(step, t, a, dt)
            if a >= 1 or not ok then
                conn:Disconnect()
                if done then pcall(done) end
            end
        end)
    end

    local function rv()
        return Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5)
    end

    local plist, pconn = {}, nil
    local function emit(pos, color, size, vel, life, grav)
        local p = mk(Vector3.new(size, size, size), CFrame.new(pos), color, NEON, 0, true)
        plist[#plist + 1] = { p = p, v = vel, life = life, age = 0, g = grav or 0 }
        if not pconn then
            pconn = RunService.RenderStepped:Connect(function(dt)
                for i = #plist, 1, -1 do
                    local it = plist[i]
                    it.age += dt
                    if it.age >= it.life or not it.p.Parent then
                        pcall(function() it.p:Destroy() end)
                        table.remove(plist, i)
                    else
                        it.v += Vector3.new(0, -it.g * dt, 0)
                        it.p.Position += it.v * dt
                        it.p.Transparency = it.age / it.life
                    end
                end
                if #plist == 0 then
                    pconn:Disconnect()
                    pconn = nil
                end
            end)
        end
    end

    local function burst(pos, color, n, speed, size, life, grav, up)
        for _ = 1, n do
            local d = rv()
            d = Vector3.new(d.X, d.Y + (up or 0), d.Z)
            if d.Magnitude < 0.01 then d = Vector3.yAxis end
            emit(pos, color, size, d.Unit * speed * (0.4 + math.random() * 0.6), life, grav)
        end
    end

    local function flash(pos, color, r, dur)
        local p = mk(Vector3.one, CFrame.new(pos), color, NEON, 0, true)
        run(dur, function(_, a)
            p.Size = Vector3.one * math.max(r * (1 - (1 - a) ^ 3), 0.1)
            p.Transparency = a
        end, function() p:Destroy() end)
    end

    local function ring(pos, color, r, dur)
        local p = mk(Vector3.new(0.3, 1, 1), CFrame.new(pos) * CFrame.Angles(0, 0, PI / 2), color)
        p.Shape = Enum.PartType.Cylinder
        run(dur, function(_, a)
            local d = math.max(r * 2 * (1 - (1 - a) ^ 3), 0.1)
            p.Size = Vector3.new(0.3, d, d)
            p.Transparency = a
        end, function() p:Destroy() end)
    end

    local function bolt(a, b, color, life, jag)
        local segs, prev, n = {}, a, 10
        local cf = CFrame.new(a, b)
        for i = 1, n do
            local pnt = a:Lerp(b, i / n)
            if i < n then
                pnt += cf.RightVector * (math.random() - 0.5) * jag + cf.UpVector * (math.random() - 0.5) * jag
            end
            local len = (prev - pnt).Magnitude
            if len > 0.01 then
                for _, sp in ipairs({ { 1.3, color, 0.55 }, { 0.35, Color3.new(1, 1, 1), 0 } }) do
                    local p = mk(Vector3.new(sp[1], sp[1], len), CFrame.new(prev, pnt) * CFrame.new(0, 0, -len / 2), sp[2], NEON, sp[3])
                    segs[#segs + 1] = { p = p, b = sp[3] }
                end
            end
            prev = pnt
        end
        run(life, function(_, aa)
            for _, s in ipairs(segs) do s.p.Transparency = s.b + (1 - s.b) * aa end
        end, function()
            for _, s in ipairs(segs) do s.p:Destroy() end
        end)
    end

    -- ---------------- клон персонажа ----------------
    local function ghost(char)
        char.Archivable = true
        local ok, clone = pcall(function() return char:Clone() end)
        if not ok or not clone then return nil end
        local hrp = clone:FindFirstChild("HumanoidRootPart")
        if not hrp then
            clone:Destroy()
            return nil
        end
        local g = { model = clone, parts = {}, rel = {}, base = {}, size = {}, hrp = hrp }
        local root = hrp.CFrame
        local kill = {}
        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("BasePart") then
                d.Anchored = true
                d.CanCollide = false
                d.CanQuery = false
                d.CanTouch = false
                g.parts[#g.parts + 1] = d
                g.rel[d] = root:ToObjectSpace(d.CFrame)
                g.base[d] = d.Transparency
                g.size[d] = d.Size
            elseif d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Humanoid") or d:IsA("BillboardGui")
                or d:IsA("Highlight") or d:IsA("Sound") or d:IsA("ForceField")
                or d:IsA("JointInstance") or d:IsA("WeldConstraint") then
                kill[#kill + 1] = d
            end
        end
        -- без суставов: иначе CFrame одной детали двигает всю сборку
        for _, d in ipairs(kill) do pcall(function() d:Destroy() end) end
        clone.Parent = fx()
        return g
    end

    local function pose(g, cf)
        for _, p in ipairs(g.parts) do p.CFrame = cf * g.rel[p] end
    end
    local function alpha(g, a)
        for _, p in ipairs(g.parts) do p.Transparency = g.base[p] + (1 - g.base[p]) * a end
    end
    local function tint(g, color, material)
        for _, p in ipairs(g.parts) do
            if p.Name ~= "HumanoidRootPart" then
                p.Color = color
                if material then p.Material = material end
                if p:IsA("MeshPart") then pcall(function() p.TextureID = "" end) end
            end
        end
        for _, d in ipairs(g.model:GetDescendants()) do
            if d:IsA("Decal") or d:IsA("Texture") or d:IsA("SurfaceAppearance") or d:IsA("Shirt")
                or d:IsA("Pants") or d:IsA("ShirtGraphic") then
                pcall(function() d:Destroy() end)
            end
        end
    end
    local function scaleAbout(g, cf, s)
        s = math.max(s, 0.01)
        for _, p in ipairs(g.parts) do
            local rel = g.rel[p]
            p.Size = g.size[p] * s
            p.CFrame = cf * (CFrame.new(rel.Position * s) * (rel - rel.Position))
        end
    end
    local function flop(g, t, amp)
        for i, p in ipairs(g.parts) do
            local n = p.Name
            if n:find("Arm") or n:find("Leg") or n:find("Hand") or n:find("Foot") or n:find("Head") then
                p.CFrame = p.CFrame * CFrame.Angles(math.sin(t * 9 + i) * amp, 0, math.cos(t * 7 + i) * amp)
            end
        end
    end
    local function finish(g)
        if g then pcall(function() g.model:Destroy() end) end
    end
    local function scatter(g, speed, life, grav)
        local center = g.hrp.Position
        local st = {}
        for _, p in ipairs(g.parts) do
            local d = p.Position - center
            if d.Magnitude < 0.1 then d = rv() end
            st[p] = { v = d.Unit * speed * (0.5 + math.random()) + Vector3.new(0, speed * 0.5, 0), w = rv() * 12 }
        end
        run(life, function(_, a, dt)
            for p, s in pairs(st) do
                s.v += Vector3.new(0, -grav * dt, 0)
                local cf = p.CFrame
                p.CFrame = CFrame.new(cf.Position + s.v * dt) * (cf - cf.Position) * CFrame.Angles(s.w.X * dt, s.w.Y * dt, s.w.Z * dt)
                p.Transparency = g.base[p] + (1 - g.base[p]) * math.clamp((a - 0.5) / 0.5, 0, 1)
            end
        end, function() finish(g) end)
    end

    -- ---------------- 22 эффекта убийства ----------------
    -- c = { g = клон|nil, pos, cf, color }
    local E = {}
    local ORDER = { "Lightning", "Fly Away", "Explosion", "Disintegrate", "Freeze", "Burn", "Gold Statue",
        "Black Hole", "Rainbow", "Confetti", "Meteor", "Tornado", "Shrink", "Pop", "Angel", "Ghost", "Slam",
        "Glitch", "Balloon", "Fireworks", "Shatter", "Orbit" }
    local DOWN = Vector3.new(0, 2.8, 0)

    E["Lightning"] = function(c)
        local top = c.pos + Vector3.new(math.random(-8, 8), 140, math.random(-8, 8))
        task.spawn(function()
            for _ = 1, 3 do
                bolt(top, c.pos, c.color, 0.3, 8)
                flash(c.pos, c.color, 14, 0.3)
                if c.g then tint(c.g, Color3.fromRGB(30, 30, 30), SMOOTH) end
                burst(c.pos, Color3.new(1, 1, 1), 8, 35, 0.35, 0.6, 40, 0.5)
                task.wait(0.2)
            end
        end)
        if c.g then
            run(1.6, function(_, a)
                local k = 1 - a
                pose(c.g, c.cf * CFrame.new((math.random() - 0.5) * 0.5 * k, 0, (math.random() - 0.5) * 0.5 * k))
                alpha(c.g, math.clamp((a - 0.6) / 0.4, 0, 1))
            end, function() finish(c.g) end)
        end
    end

    E["Fly Away"] = function(c)
        if not c.g then return end
        local h, grav = math.random(40, 50), 110
        local v0 = math.sqrt(2 * grav * h)
        local total = 2 * v0 / grav
        local w = rv() * 16
        local p0 = c.cf.Position
        local rot0 = c.cf - p0
        burst(p0, c.color, 12, 30, 0.4, 0.7, 50, 0.5)
        run(total + 0.7, function(t)
            local tt = math.min(t, total)
            local y = v0 * tt - 0.5 * grav * tt * tt
            pose(c.g, CFrame.new(p0 + Vector3.new(0, y, 0)) * CFrame.Angles(w.X * tt * 0.4, w.Y * tt * 0.4, w.Z * tt * 0.4) * rot0)
            flop(c.g, t, 0.7)
            if t < total then emit(p0 + Vector3.new(0, y, 0), c.color, 0.5, Vector3.zero, 0.4, 0) end
            if t > total then alpha(c.g, (t - total) / 0.7) end
        end, function()
            ring(p0 - DOWN, c.color, 10, 0.5)
            finish(c.g)
        end)
    end

    E["Explosion"] = function(c)
        flash(c.pos, c.color, 16, 0.5)
        ring(c.pos - DOWN, c.color, 22, 0.6)
        burst(c.pos, c.color, 40, 55, 0.6, 1.0, 60, 0.4)
        burst(c.pos, Color3.fromRGB(255, 170, 40), 25, 40, 0.5, 0.8, 50, 0.4)
        if c.g then scatter(c.g, 45, 2.0, 90) end
    end

    E["Disintegrate"] = function(c)
        if not c.g then
            burst(c.pos, c.color, 40, 6, 0.3, 1.5, -8, 1)
            return
        end
        local offs = {}
        for _, p in ipairs(c.g.parts) do offs[p] = rv() * 2 end
        run(1.8, function(_, a, dt)
            for _, p in ipairs(c.g.parts) do
                local cf = p.CFrame
                p.CFrame = CFrame.new(cf.Position + (Vector3.new(0, 3, 0) + offs[p]) * dt) * (cf - cf.Position)
                p.Transparency = c.g.base[p] + (1 - c.g.base[p]) * a
            end
            for _ = 1, 3 do
                local p = c.g.parts[math.random(#c.g.parts)]
                emit(p.Position, c.color, 0.25, Vector3.new(0, 4, 0) + rv() * 3, 1.0, -2)
            end
        end, function() finish(c.g) end)
    end

    E["Freeze"] = function(c)
        if not c.g then return end
        tint(c.g, c.color, Enum.Material.Ice)
        ring(c.pos - DOWN, c.color, 8, 0.5)
        run(1.0, function() pose(c.g, c.cf) end, function()
            flash(c.pos, Color3.new(1, 1, 1), 8, 0.3)
            burst(c.pos, c.color, 30, 35, 0.35, 1.0, 60, 0.6)
            scatter(c.g, 18, 1.6, 90)
        end)
    end

    E["Burn"] = function(c)
        if not c.g then return end
        local fire = { c.color, Color3.fromRGB(255, 140, 20), Color3.fromRGB(255, 220, 80) }
        run(1.8, function(_, a)
            for _, p in ipairs(c.g.parts) do
                if p.Name ~= "HumanoidRootPart" then p.Color = p.Color:Lerp(Color3.fromRGB(20, 10, 5), 0.08) end
            end
            for _ = 1, 3 do
                local p = c.g.parts[math.random(#c.g.parts)]
                emit(p.Position, fire[math.random(#fire)], 0.5, Vector3.new((math.random() - 0.5) * 3, 6 + math.random() * 4, (math.random() - 0.5) * 3), 0.8, -4)
            end
            alpha(c.g, math.clamp((a - 0.7) / 0.3, 0, 1))
        end, function() finish(c.g) end)
    end

    E["Gold Statue"] = function(c)
        if not c.g then return end
        tint(c.g, c.color, Enum.Material.Metal)
        for _, p in ipairs(c.g.parts) do p.Reflectance = 0.5 end
        local p0 = c.cf.Position
        local rot0 = c.cf - p0
        run(2.0, function(_, a)
            pose(c.g, CFrame.new(p0 + Vector3.new(0, 5 * a, 0)) * CFrame.Angles(0, a * 8, 0) * rot0)
            emit(p0 + rv() * 4 + Vector3.new(0, 2 * a, 0), Color3.fromRGB(255, 230, 120), 0.25, Vector3.new(0, 3, 0), 0.7, 0)
            alpha(c.g, math.clamp((a - 0.7) / 0.3, 0, 1))
        end, function() finish(c.g) end)
    end

    E["Black Hole"] = function(c)
        if not c.g then return end
        local center = c.pos + Vector3.new(0, 3, 0)
        local orig = {}
        for _, p in ipairs(c.g.parts) do orig[p] = c.cf * c.g.rel[p] end
        local core = mk(Vector3.one, CFrame.new(center), Color3.new(0, 0, 0), SMOOTH, 0, true)
        local halo = mk(Vector3.one, CFrame.new(center), c.color, NEON, 0.5, true)
        ring(c.pos - DOWN, c.color, 14, 1.2)
        run(1.6, function(_, a)
            local s = 5 * math.sin(a * PI) + 0.5
            core.Size = Vector3.one * s
            halo.Size = Vector3.one * s * 1.5
            local rot = CFrame.Angles(0, a * 8, 0)
            local k = 1 - a ^ 1.5
            for _, p in ipairs(c.g.parts) do
                local o = orig[p]
                p.Size = c.g.size[p] * math.max(k, 0.02)
                p.CFrame = CFrame.new(center + rot:VectorToWorldSpace(o.Position - center) * k) * rot * (o - o.Position)
            end
            local pp = center + rv() * 28
            emit(pp, c.color, 0.25, (center - pp) * 2.5, 0.4, 0)
        end, function()
            core:Destroy()
            halo:Destroy()
            finish(c.g)
        end)
    end

    E["Rainbow"] = function(c)
        if not c.g then
            burst(c.pos, Color3.fromHSV(math.random(), 1, 1), 40, 30, 0.35, 1.2, 40, 0.5)
            return
        end
        local p0 = c.cf.Position
        local rot0 = c.cf - p0
        run(2.0, function(t, a)
            for i, p in ipairs(c.g.parts) do
                if p.Name ~= "HumanoidRootPart" then
                    p.Material = NEON
                    p.Color = Color3.fromHSV((t * 1.5 + i * 0.07) % 1, 1, 1)
                end
            end
            pose(c.g, CFrame.new(p0 + Vector3.new(0, 6 * a, 0)) * CFrame.Angles(0, a * 6, 0) * rot0)
            alpha(c.g, math.clamp((a - 0.6) / 0.4, 0, 1))
        end, function() finish(c.g) end)
    end

    E["Confetti"] = function(c)
        for _ = 1, 70 do
            emit(c.pos, Color3.fromHSV(math.random(), 0.9, 1), 0.35,
                Vector3.new((math.random() - 0.5) * 40, 30 + math.random() * 30, (math.random() - 0.5) * 40), 1.6, 55)
        end
        if c.g then
            run(0.5, function(_, a) scaleAbout(c.g, c.cf, 1 - a) end, function() finish(c.g) end)
        end
    end

    E["Meteor"] = function(c)
        local start = c.pos + Vector3.new(35, 130, 20)
        local m = mk(Vector3.one * 6, CFrame.new(start), c.color, NEON, 0, true)
        local core = mk(Vector3.one * 3.5, CFrame.new(start), Color3.new(1, 1, 1), NEON, 0, true)
        run(0.6, function(_, a)
            local pos = start:Lerp(c.pos, a * a)
            m.Position, core.Position = pos, pos
            emit(pos, c.color, 2, Vector3.new(0, 4, 0), 0.5, 0)
        end, function()
            m:Destroy()
            core:Destroy()
            flash(c.pos, c.color, 20, 0.5)
            ring(c.pos - DOWN, c.color, 26, 0.7)
            burst(c.pos, c.color, 45, 60, 0.6, 1.0, 70, 0.5)
            if c.g then scatter(c.g, 50, 2.0, 90) end
        end)
    end

    E["Tornado"] = function(c)
        local p0 = c.cf.Position
        local rot0 = c.cf - p0
        run(2.2, function(t, a)
            if c.g then
                pose(c.g, CFrame.new(p0 + Vector3.new(0, 25 * a, 0)) * CFrame.Angles(0, t * 14, 0) * rot0)
                alpha(c.g, math.clamp((a - 0.75) / 0.25, 0, 1))
            end
            for k = 0, 2 do
                local ang = t * 10 + k * 2.1
                local y = (t * 18 + k * 9) % 28
                local r = 2 + y * 0.12
                emit(p0 + Vector3.new(math.cos(ang) * r, y, math.sin(ang) * r), c.color, 0.5, Vector3.zero, 0.4, 0)
            end
        end, function() finish(c.g) end)
    end

    E["Shrink"] = function(c)
        ring(c.pos - DOWN, c.color, 7, 0.6)
        if c.g then
            run(0.9, function(_, a) scaleAbout(c.g, c.cf, 1 - a) end, function()
                burst(c.pos, c.color, 12, 10, 0.3, 0.6, 20, 0.3)
                finish(c.g)
            end)
        end
    end

    E["Pop"] = function(c)
        if not c.g then
            flash(c.pos, c.color, 10, 0.4)
            return
        end
        run(0.6, function(_, a)
            scaleAbout(c.g, c.cf, 1 + 0.9 * a)
            for _, p in ipairs(c.g.parts) do
                if p.Name ~= "HumanoidRootPart" then p.Color = p.Color:Lerp(c.color, 0.1) end
            end
        end, function()
            flash(c.pos, c.color, 14, 0.4)
            burst(c.pos, c.color, 50, 50, 0.5, 0.9, 50, 0.3)
            finish(c.g)
        end)
    end

    E["Angel"] = function(c)
        local p0 = c.cf.Position
        local rot0 = c.cf - p0
        local beam = mk(Vector3.new(220, 5, 5), CFrame.new(p0 + Vector3.new(0, 100, 0)) * CFrame.Angles(0, 0, PI / 2), c.color, NEON, 0.55)
        beam.Shape = Enum.PartType.Cylinder
        local halo = mk(Vector3.new(0.25, 3, 3), CFrame.new(p0 + Vector3.new(0, 4, 0)) * CFrame.Angles(0, 0, PI / 2), Color3.new(1, 1, 1), NEON, 0)
        halo.Shape = Enum.PartType.Cylinder
        run(2.6, function(_, a)
            local y = 35 * a * a
            local fade = math.clamp((a - 0.8) / 0.2, 0, 1)
            beam.Transparency = 0.55 + 0.45 * fade
            halo.CFrame = CFrame.new(p0 + Vector3.new(0, 4 + y, 0)) * CFrame.Angles(0, 0, PI / 2)
            halo.Transparency = fade
            if c.g then
                pose(c.g, CFrame.new(p0 + Vector3.new(0, y, 0)) * rot0)
                alpha(c.g, math.clamp((a - 0.6) / 0.4, 0, 1))
            end
            emit(p0 + rv() * 5 + Vector3.new(0, y, 0), Color3.new(1, 1, 1), 0.25, Vector3.new(0, 6, 0), 0.8, 0)
        end, function()
            beam:Destroy()
            halo:Destroy()
            finish(c.g)
        end)
    end

    E["Ghost"] = function(c)
        if not c.g then return end
        tint(c.g, Color3.new(1, 1, 1), NEON)
        local p0 = c.cf.Position
        local rot0 = c.cf - p0
        run(2.0, function(t, a)
            pose(c.g, CFrame.new(p0 + Vector3.new(math.sin(t * 5) * 1.2, 10 * a, 0)) * rot0)
            alpha(c.g, 0.45 + 0.55 * a)
            if math.random() < 0.5 then
                emit(p0 + Vector3.new(0, 10 * a, 0) + rv() * 2, c.color, 0.25, Vector3.new(0, -2, 0), 0.6, 0)
            end
        end, function() finish(c.g) end)
    end

    E["Slam"] = function(c)
        local p0 = c.cf.Position
        local rot0 = c.cf - p0
        ring(p0 - DOWN, c.color, 18, 0.6)
        burst(p0 - Vector3.new(0, 2.5, 0), Color3.fromRGB(150, 130, 110), 25, 25, 0.5, 0.8, 40, 1)
        if c.g then
            run(0.7, function(_, a)
                pose(c.g, CFrame.new(p0 - Vector3.new(0, 7 * a, 0)) * rot0)
            end, function() finish(c.g) end)
        end
    end

    E["Glitch"] = function(c)
        if not c.g then return end
        local cols = { c.color, Color3.new(1, 1, 1), Color3.new(0, 0, 0) }
        run(1.0, function()
            pose(c.g, c.cf * CFrame.new((math.random() - 0.5) * 0.6, 0, 0))
            for _, p in ipairs(c.g.parts) do
                if p.Name ~= "HumanoidRootPart" then
                    p.CFrame = p.CFrame * CFrame.new((math.random() - 0.5) * 1.5, (math.random() - 0.5), 0)
                    p.Color = cols[math.random(#cols)]
                    p.Material = NEON
                end
            end
            alpha(c.g, math.random() < 0.25 and 0.7 or 0)
        end, function()
            burst(c.pos, c.color, 30, 35, 0.35, 0.6, 30, 0.3)
            finish(c.g)
        end)
    end

    E["Balloon"] = function(c)
        local p0 = c.cf.Position
        local rot0 = c.cf - p0
        local balloon = mk(Vector3.one * 6, CFrame.new(p0 + Vector3.new(0, 8, 0)), c.color, SMOOTH, 0, true)
        local str = mk(Vector3.new(0.08, 0.08, 1), CFrame.new(p0), Color3.new(1, 1, 1), SMOOTH, 0)
        run(3.2, function(t, a)
            local y = 100 * a * a
            local gpos = p0 + Vector3.new(math.sin(t * 2) * 2, y, math.cos(t * 1.6) * 2)
            local bpos = gpos + Vector3.new(0, 8, 0)
            balloon.Position = bpos
            local len = (bpos - gpos).Magnitude
            str.Size = Vector3.new(0.08, 0.08, len)
            str.CFrame = CFrame.new(gpos, bpos) * CFrame.new(0, 0, -len / 2)
            local fade = math.clamp((a - 0.8) / 0.2, 0, 1)
            balloon.Transparency, str.Transparency = fade, fade
            if c.g then
                pose(c.g, CFrame.new(gpos) * rot0)
                flop(c.g, t, 0.5)
                alpha(c.g, fade)
            end
        end, function()
            balloon:Destroy()
            str:Destroy()
            finish(c.g)
        end)
    end

    E["Fireworks"] = function(c)
        local p0 = c.cf.Position
        local rot0 = c.cf - p0
        local top = p0 + Vector3.new(0, 70, 0)
        local function pop()
            flash(top, Color3.new(1, 1, 1), 16, 0.4)
            for i = 1, 90 do
                local d = rv()
                if d.Magnitude < 0.01 then d = Vector3.yAxis end
                local col = (i % 3 == 0) and c.color or Color3.fromHSV(math.random(), 0.9, 1)
                emit(top, col, 0.5, d.Unit * 45, 1.6, 25)
            end
        end
        if not c.g then
            pop()
            return
        end
        run(0.9, function(t, a)
            local y = 70 * a * a
            pose(c.g, CFrame.new(p0 + Vector3.new(0, y, 0)) * CFrame.Angles(0, t * 12, 0) * rot0)
            emit(p0 + Vector3.new(0, y, 0), c.color, 0.5, Vector3.new(0, -8, 0), 0.5, 0)
        end, function()
            pop()
            finish(c.g)
        end)
    end

    E["Shatter"] = function(c)
        burst(c.pos, c.color, 20, 25, 0.3, 0.8, 70, 0.4)
        if c.g then scatter(c.g, 14, 2.2, 80) end
    end

    E["Orbit"] = function(c)
        if not c.g then return end
        local center = c.pos + Vector3.new(0, 4, 0)
        local rot0 = c.cf - c.cf.Position
        ring(c.pos - DOWN, c.color, 9, 0.8)
        run(1.8, function(t, a)
            local ang = t * 7
            local r = 7 * (1 - a * 0.6)
            local pos = center + Vector3.new(math.cos(ang) * r, a * 12, math.sin(ang) * r)
            scaleAbout(c.g, CFrame.new(pos) * CFrame.Angles(0, -ang, 0) * rot0, 1 - a * 0.85)
            emit(pos, c.color, 0.3, Vector3.zero, 0.5, 0)
        end, function()
            burst(center + Vector3.new(0, 12, 0), c.color, 25, 25, 0.35, 0.7, 30, 0.2)
            finish(c.g)
        end)
    end

    -- ---------------- запуск / детекция убийств ----------------
    local kcol = fromHex(env.KillFxColorHex, Color3.fromRGB(120, 190, 255))

    local function hideOrig(char)
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then d.LocalTransparencyModifier = 1 end
        end
    end

    local function trigger(char, name, color, previewCF)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local fn = E[name]
        if not hrp or not fn then return end
        local g = ghost(char)
        local cf = previewCF or hrp.CFrame
        if g then
            if previewCF then pose(g, cf) else hideOrig(char) end
        end
        local ok = pcall(fn, { g = g, pos = cf.Position, cf = cf, color = color })
        if not ok then finish(g) end
    end

    local function watch(pl)
        if pl == lp then return end
        local function onChar(char)
            local hum = char:WaitForChild("Humanoid", 10)
            if not hum then return end
            hum.Died:Connect(function()
                if not env.KillFxEnabled then return end
                local tag = hum:FindFirstChild("creator")
                local mine
                if tag and tag:IsA("ObjectValue") and tag.Value ~= nil then
                    mine = tag.Value == lp -- игра ставит creator: точно знаем убийцу
                else
                    mine = os.clock() - (t1.lastFire or 0) < 1.5 -- иначе: стрелял в последние 1.5 с
                end
                if mine then
                    local name = env.KillFxName
                    if name == "Random" then name = ORDER[math.random(#ORDER)] end
                    trigger(char, name, kcol)
                end
            end)
        end
        pl.CharacterAdded:Connect(onChar)
        if pl.Character then task.spawn(onChar, pl.Character) end
    end
    for _, pl in ipairs(Players:GetPlayers()) do watch(pl) end
    Players.PlayerAdded:Connect(watch)

    local function preview()
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local cam = workspace.CurrentCamera
        local flat = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
        if flat.Magnitude < 0.01 then flat = Vector3.new(0, 0, -1) end
        local pos = hrp.Position + flat.Unit * 14
        local name = env.KillFxName
        if name == "Random" then name = ORDER[math.random(#ORDER)] end
        trigger(char, name, kcol, CFrame.new(pos, pos - flat.Unit))
    end

    -- ---------------- China hat ----------------
    local hatCol = fromHex(env.HatColorHex, Color3.fromRGB(255, 77, 109))
    local hat = { discs = {}, balls = {}, key = nil, rot = 0 }

    local function clearHat()
        for _, d in ipairs(hat.discs) do d.p:Destroy() end
        for _, b in ipairs(hat.balls) do b.p:Destroy() end
        hat.discs, hat.balls, hat.key = {}, {}, nil
    end

    local function buildHat()
        clearHat()
        local R = env.HatSize or 3
        local detailed = env.HatDetail == "Detailed"
        local n = detailed and 22 or 6
        local H = R * 0.55
        for i = 1, n do
            local r = R * (1 - (i - 0.5) / n)
            local p = mk(Vector3.new(H / n * 1.15, r * 2, r * 2), CFrame.new(), hatCol, NEON, 0.4)
            p.Shape = Enum.PartType.Cylinder
            hat.discs[#hat.discs + 1] = { p = p, y = (i - 0.5) * H / n, hue = i / n }
        end
        if detailed then
            for k = 0, 23 do
                local p = mk(Vector3.one * 0.25, CFrame.new(), hatCol, NEON, 0.2, true)
                hat.balls[#hat.balls + 1] = { p = p, ang = k / 24 * 2 * PI, r = R, y = 0.05 }
            end
            local tip = mk(Vector3.one * 0.35, CFrame.new(), Color3.new(1, 1, 1), NEON, 0, true)
            hat.balls[#hat.balls + 1] = { p = tip, ang = 0, r = 0, y = H + 0.1 }
        end
        hat.key = tostring(env.HatDetail) .. "|" .. tostring(env.HatSize)
    end

    RunService.RenderStepped:Connect(function(dt)
        if not env.HatEnabled then
            if hat.key then clearHat() end
            return
        end
        local char = lp.Character
        local head = char and char:FindFirstChild("Head")
        if not head then return end
        if hat.key ~= tostring(env.HatDetail) .. "|" .. tostring(env.HatSize) then buildHat() end
        if env.HatRotate then hat.rot += dt * 1.5 end
        local base = head.Position + Vector3.new(0, head.Size.Y / 2 + 0.1 + (env.HatHeight or 0) / 10, 0)
        local transp = 1 - (env.HatAlpha or 60) / 100
        for _, d in ipairs(hat.discs) do
            d.p.CFrame = CFrame.new(base + Vector3.new(0, d.y, 0)) * CFrame.Angles(0, hat.rot, PI / 2)
            d.p.Transparency = transp
            d.p.Color = env.HatRainbow and Color3.fromHSV((d.hue + os.clock() * 0.4) % 1, 1, 1) or hatCol
        end
        for _, b in ipairs(hat.balls) do
            local ang = b.ang + hat.rot
            b.p.Position = base + Vector3.new(math.cos(ang) * b.r, b.y, math.sin(ang) * b.r)
            if b.r > 0 then
                b.p.Color = env.HatRainbow and Color3.fromHSV((b.ang / (2 * PI) + os.clock() * 0.4) % 1, 1, 1) or hatCol
            end
        end
    end)

    -- ---------------- фигуры при прыжке / приземлении ----------------
    local jcol = fromHex(env.JumpColorHex, Color3.fromRGB(255, 77, 109))
    local shapes = {}

    local function spawnShape(center)
        local sides = ({ Circle = 28, Square = 4, Triangle = 3 })[env.JumpShape or "Circle"] or 28
        local segs = {}
        for i = 1, sides do segs[i] = mk(Vector3.new(0.25, 0.12, 1), CFrame.new(center), jcol, NEON, 0) end
        shapes[#shapes + 1] = {
            segs = segs, sides = sides, c = center, t = 0, spin = math.random() * PI,
            dur = math.max((env.JumpDur or 8) / 10, 0.2), max = env.JumpSize or 6,
        }
    end

    RunService.RenderStepped:Connect(function(dt)
        for i = #shapes, 1, -1 do
            local s = shapes[i]
            s.t += dt
            local a = s.t / s.dur
            if a >= 1 then
                for _, p in ipairs(s.segs) do p:Destroy() end
                table.remove(shapes, i)
            else
                local r = s.max * (1 - (1 - a) ^ 3)
                local off = (s.sides == 3 and -PI / 2) or (s.sides == 4 and PI / 4) or 0
                local verts = {}
                for k = 0, s.sides - 1 do
                    local ang = off + s.spin * 0 + a * 1.2 + k / s.sides * 2 * PI
                    verts[k + 1] = s.c + Vector3.new(math.cos(ang) * r, 0, math.sin(ang) * r)
                end
                for k = 1, s.sides do
                    local v1, v2 = verts[k], verts[k % s.sides + 1]
                    local len = (v2 - v1).Magnitude
                    local seg = s.segs[k]
                    if len > 0.01 then
                        seg.Size = Vector3.new(0.25, 0.12, len + 0.06)
                        seg.CFrame = CFrame.new(v1, v2) * CFrame.new(0, 0, -len / 2)
                    end
                    seg.Transparency = a * a
                end
            end
        end
    end)

    local function feet(char)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not (hrp and hum) then return nil end
        local off = hum.HipHeight > 0 and (hum.HipHeight + hrp.Size.Y / 2) or 3
        return hrp.Position - Vector3.new(0, off - 0.05, 0)
    end

    local function watchSelf(char)
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then return end
        hum.StateChanged:Connect(function(_, new)
            if not env.JumpFxEnabled then return end
            if new == Enum.HumanoidStateType.Jumping and env.JumpOnJump then
                local f = feet(char)
                if f then spawnShape(f) end
            elseif new == Enum.HumanoidStateType.Landed and env.JumpOnLand then
                local f = feet(char)
                if f then spawnShape(f) end
            end
        end)
    end
    if lp.Character then task.spawn(watchSelf, lp.Character) end
    lp.CharacterAdded:Connect(watchSelf)

    -- ---------------- UI ----------------
    local t0 = os.clock()
    local function addButton(sec, name, fn)
        local ok = pcall(function()
            sec:AddButton({ Name = name, Title = name, Text = name, Callback = fn })
        end)
        if ok then return end
        sec:AddToggle({
            Name = name, Flag = "Btn_" .. name, Default = false,
            Callback = function()
                if os.clock() - t0 < 3 then return end
                fn()
            end
        })
    end

    local names = { "Random" }
    for _, n in ipairs(ORDER) do names[#names + 1] = n end

    local sk = t1.mFx:AddSection({ Position = "left", Name = "KILL EFFECT" })
    sk:AddToggle({ Name = "Enable kill effect", Flag = "KillFxEnabledT", Default = env.KillFxEnabled,
        Callback = function(p) env.KillFxEnabled = p end })
    sk:AddDropdown({ Name = "Effect", Flag = "KillFxNameD", Values = names, Default = env.KillFxName,
        Callback = function(p) env.KillFxName = p end })
    sk:AddColorPicker({ Name = "Effect color", Flag = "KillFxColor", Default = kcol,
        Callback = function(cc) kcol = cc; env.KillFxColorHex = toHex(cc) end })
    addButton(sk, "Preview effect", preview)

    local sh = t1.mFx:AddSection({ Position = "center", Name = "CHINA HAT" })
    sh:AddToggle({ Name = "China hat", Flag = "HatEnabledT", Default = env.HatEnabled,
        Callback = function(p) env.HatEnabled = p end })
    sh:AddDropdown({ Name = "Detail", Flag = "HatDetailD", Values = { "Simple", "Detailed" }, Default = env.HatDetail,
        Callback = function(p) env.HatDetail = p end })
    sh:AddSlider({ Name = "Size", Flag = "HatSizeS", Min = 1, Max = 8, Default = math.clamp(env.HatSize, 1, 8),
        Callback = function(p) env.HatSize = p end })
    sh:AddSlider({ Name = "Height offset", Flag = "HatHeightS", Min = -10, Max = 30, Default = math.clamp(env.HatHeight, -10, 30),
        Callback = function(p) env.HatHeight = p end })
    sh:AddSlider({ Name = "Opacity", Flag = "HatAlphaS", Min = 5, Max = 100, Default = math.clamp(env.HatAlpha, 5, 100),
        Callback = function(p) env.HatAlpha = p end })
    sh:AddToggle({ Name = "Rotate", Flag = "HatRotateT", Default = env.HatRotate,
        Callback = function(p) env.HatRotate = p end })
    sh:AddToggle({ Name = "Rainbow", Flag = "HatRainbowT", Default = env.HatRainbow,
        Callback = function(p) env.HatRainbow = p end })
    sh:AddColorPicker({ Name = "Hat color", Flag = "HatColor", Default = hatCol,
        Callback = function(cc) hatCol = cc; env.HatColorHex = toHex(cc) end })

    local sj = t1.mFx:AddSection({ Position = "right", Name = "JUMP / LAND SHAPE" })
    sj:AddToggle({ Name = "Enable", Flag = "JumpFxEnabledT", Default = env.JumpFxEnabled,
        Callback = function(p) env.JumpFxEnabled = p end })
    sj:AddDropdown({ Name = "Shape", Flag = "JumpShapeD", Values = { "Circle", "Square", "Triangle" }, Default = env.JumpShape,
        Callback = function(p) env.JumpShape = p end })
    sj:AddToggle({ Name = "On jump", Flag = "JumpOnJumpT", Default = env.JumpOnJump,
        Callback = function(p) env.JumpOnJump = p end })
    sj:AddToggle({ Name = "On landing", Flag = "JumpOnLandT", Default = env.JumpOnLand,
        Callback = function(p) env.JumpOnLand = p end })
    sj:AddSlider({ Name = "Size", Flag = "JumpSizeS", Min = 2, Max = 25, Default = math.clamp(env.JumpSize, 2, 25),
        Callback = function(p) env.JumpSize = p end })
    sj:AddSlider({ Name = "Duration (x0.1s)", Flag = "JumpDurS", Min = 3, Max = 30, Default = math.clamp(env.JumpDur, 3, 30),
        Callback = function(p) env.JumpDur = p end })
    sj:AddColorPicker({ Name = "Shape color", Flag = "JumpColor", Default = jcol,
        Callback = function(cc) jcol = cc; env.JumpColorHex = toHex(cc) end })
end

-- ============================================================
-- [CONFIG + THEME] SETTINGS tab
-- CONFIG: выбор из списка, имя для нового, кнопки Save / Load / Delete / Reset
-- THEME: пресеты акцентного цвета + Custom (hue/sat)
-- ============================================================
do
    local Cfg = t1.Cfg
    local t0 = os.clock() -- виджеты могут дёрнуть callback при создании

    local function note(text, icon)
        v11:Notify({ Title = "CONFIG", Content = text, Icon = icon or "check" })
    end

    -- настоящая кнопка; если у либы нет AddButton, откатываемся на нажимаемый переключатель
    local function addButton(sec, name, fn)
        local ok = pcall(function()
            sec:AddButton({ Name = name, Title = name, Text = name, Callback = fn })
        end)
        if ok then return end
        sec:AddToggle({
            Name = name,
            Flag = "Btn_" .. name,
            Default = false,
            Callback = function()
                if os.clock() - t0 < 3 then return end
                fn()
            end
        })
    end

    local left = vSettings:AddSection({ Position = "left", Name = "CONFIG" })

    local slotDd = left:AddDropdown({
        Name = "Config",
        Flag = "CfgSlot",
        Values = Cfg.list(),
        Default = Cfg.Slot,
        Callback = function(p)
            if type(p) == "string" then
                Cfg.Slot = p
                Cfg.saveMeta()
            end
        end
    })

    -- поле имени (если у либы есть текстбокс); пусто = сохраняем в выбранный конфиг
    for _, method in ipairs({ "AddTextBox", "AddTextbox", "AddInput" }) do
        local ok = pcall(function()
            left[method](left, {
                Name = "New config name",
                Flag = "CfgNewName",
                Placeholder = "name (empty = selected config)",
                Default = "",
                Callback = function(v) Cfg.NewName = tostring(v or "") end
            })
        end)
        if ok then break end
    end

    left:AddToggle({
        Name = "Autosave selected config (every 2s)",
        Flag = "CfgAutosave",
        Default = Cfg.Autosave,
        Callback = function(p)
            Cfg.Autosave = p
            Cfg.saveMeta()
        end
    })

    local function refreshList()
        local list = Cfg.list()
        for _, m in ipairs({ "SetValues", "Refresh", "UpdateValues", "SetOptions", "SetList" }) do
            if pcall(function() slotDd[m](slotDd, list) end) then return true end
        end
        return false
    end

    local acts = vSettings:AddSection({ Position = "center", Name = "ACTIONS" })

    -- Save: перезапись выбранного (или введённого имени) с подтверждением
    local saveArmed, saveArmedName = 0, nil
    addButton(acts, "Save (overwrite)", function()
        local target = Cfg.Slot
        if Cfg.NewName and Cfg.clean(Cfg.NewName) ~= "" then target = Cfg.clean(Cfg.NewName) end
        if Cfg.exists(target) and not (saveArmedName == target and os.clock() - saveArmed < 4) then
            saveArmed, saveArmedName = os.clock(), target
            note("вы уверены, что хотите переписать кфг «" .. target .. "»? нажмите Save ещё раз (4 с)", "x")
            return
        end
        saveArmedName = nil
        local ok, name = Cfg.save(target)
        if ok then
            Cfg.Slot = name
            Cfg.saveMeta()
            local shown = refreshList()
            note("saved: " .. name .. (shown and "" or " (new name appears in the list after re-execute)"))
        else
            note("save failed (no writefile?)", "x")
        end
    end)

    -- Save as new: новое имя из поля, либо cfg_1, cfg_2, ...
    addButton(acts, "Save as new", function()
        local name = Cfg.NewName and Cfg.clean(Cfg.NewName) or ""
        if name == "" then
            local n = 1
            while Cfg.exists("cfg_" .. n) do n += 1 end
            name = "cfg_" .. n
        elseif Cfg.exists(name) then
            note("«" .. name .. "» уже есть, для перезаписи жми Save (overwrite)", "x")
            return
        end
        local ok, saved = Cfg.save(name)
        if ok then
            Cfg.Slot = saved
            Cfg.saveMeta()
            local shown = refreshList()
            note("created: " .. saved .. (shown and "" or " (new name appears in the list after re-execute)"))
        else
            note("save failed (no writefile?)", "x")
        end
    end)

    -- листание списка (работает, даже если дропдаун не обновляется на лету)
    local function step(dir)
        local list = Cfg.list()
        local idx = table.find(list, Cfg.Slot) or 1
        idx = ((idx - 1 + dir) % #list) + 1
        Cfg.Slot = list[idx]
        Cfg.saveMeta()
        note("selected: " .. Cfg.Slot .. " (" .. idx .. "/" .. #list .. ")", "check")
    end
    addButton(acts, "Prev config", function() step(-1) end)
    addButton(acts, "Next config", function() step(1) end)

    addButton(acts, "Load", function()
        if Cfg.load(Cfg.Slot) then
            if t1.applyTheme then t1.applyTheme() end
            note("loaded: " .. Cfg.Slot .. " (values apply now, menu switches refresh after re-execute)")
        else
            note("no config: " .. Cfg.Slot, "x")
        end
    end)

    local delArmed = 0
    addButton(acts, "Delete", function()
        if os.clock() - delArmed > 4 then
            delArmed = os.clock()
            note("press Delete again within 4s to remove: " .. Cfg.Slot, "x")
            return
        end
        delArmed = 0
        local name = Cfg.Slot
        if Cfg.delete(name) then
            if name ~= "default" then Cfg.Slot = "default" end
            Cfg.saveMeta()
            Cfg._last = game:GetService("HttpService"):JSONEncode(Cfg.snapshot())
            refreshList()
            note("deleted: " .. name)
        else
            note("nothing to delete: " .. name, "x")
        end
    end)

    addButton(acts, "Reset values to defaults", function()
        Cfg.resetValues()
        if t1.applyTheme then t1.applyTheme() end
        note("values reset (not saved until you press Save)")
    end)

    -- ---------------- THEME ----------------
    local right = vSettings:AddSection({ Position = "right", Name = "THEME" })
    right:AddDropdown({
        Name = "Theme",
        Flag = "ThemeName",
        Values = { "Default", "Blue", "Purple", "Green", "Red", "Orange", "Yellow", "Cyan", "Mono", "Custom" },
        Default = getgenv().Theme,
        Callback = function(p)
            getgenv().Theme = p
            if t1.applyTheme then t1.applyTheme() end
        end
    })
    right:AddSlider({
        Name = "Custom hue",
        Flag = "ThemeHueSlider",
        Min = 0, Max = 360,
        Default = math.clamp(getgenv().ThemeHue, 0, 360),
        Callback = function(p)
            getgenv().ThemeHue = p
            if getgenv().Theme == "Custom" and t1.applyTheme then t1.applyTheme() end
        end
    })
    right:AddSlider({
        Name = "Custom saturation",
        Flag = "ThemeSatSlider",
        Min = 0, Max = 100,
        Default = math.clamp(getgenv().ThemeSat, 0, 100),
        Callback = function(p)
            getgenv().ThemeSat = p
            if getgenv().Theme == "Custom" and t1.applyTheme then t1.applyTheme() end
        end
    })
end

-- ============================================================
-- [THEME ENGINE] перекрашивает акцентный цвет окна либы.
-- акцент определяется автоматически (самый частый насыщенный оттенок в окне),
-- поэтому не зависит от имён внутренних объектов. тёмный фон не трогаем.
-- ============================================================
do
    local Players = game:GetService("Players")
    local PRESETS = { -- h = оттенок 0..1, s = множитель насыщенности
        Blue = { h = 0.60, s = 1 }, Purple = { h = 0.75, s = 1 }, Green = { h = 0.37, s = 1 },
        Red = { h = 0.99, s = 1 }, Orange = { h = 0.07, s = 1 }, Yellow = { h = 0.14, s = 1 },
        Cyan = { h = 0.5, s = 1 }, Mono = { h = 0, s = 0 },
    }

    local root, accentH, accentS
    local ver = 0
    local records = setmetatable({}, { __mode = "k" }) -- [inst][prop] = {orig, last, ver}
    local sweeping, sweepUntil = false, 0

    local function hueNear(h, h0)
        local d = math.abs(h - h0)
        return math.min(d, 1 - d) < 0.05
    end

    local function isAccent(c)
        local h, s, v = c:ToHSV()
        return s > 0.35 and v > 0.35 and accentH ~= nil and hueNear(h, accentH)
    end

    local function currentTheme()
        local name = getgenv().Theme
        if name == "Default" or not name then return nil end
        if name == "Custom" then
            local s0 = math.max(accentS or 0.6, 0.1)
            return { h = (getgenv().ThemeHue or 330) / 360, s = ((getgenv().ThemeSat or 70) / 100) / s0 }
        end
        return PRESETS[name]
    end

    local function remap(c, th)
        if not th then return c end
        local _, s, v = c:ToHSV()
        return Color3.fromHSV(th.h, math.clamp(s * th.s, 0, 1), v)
    end

    local function findRoot()
        local roots = {}
        pcall(function() if gethui then roots[#roots + 1] = gethui() end end)
        roots[#roots + 1] = game:GetService("CoreGui")
        local pg = Players.LocalPlayer:FindFirstChild("PlayerGui")
        if pg then roots[#roots + 1] = pg end
        for _, r in ipairs(roots) do
            local ok, gui = pcall(function()
                for _, d in ipairs(r:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Text == "Lesxov Tap" then
                        return d:FindFirstAncestorWhichIsA("ScreenGui")
                    end
                end
            end)
            if ok and gui then return gui end
        end
    end

    local function propsOf(d)
        if d:IsA("UIStroke") then return { "Color" } end
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then return { "BackgroundColor3", "TextColor3" } end
        if d:IsA("ImageLabel") or d:IsA("ImageButton") then return { "BackgroundColor3", "ImageColor3" } end
        if d:IsA("ScrollingFrame") then return { "BackgroundColor3", "ScrollBarImageColor3" } end
        if d:IsA("GuiObject") then return { "BackgroundColor3" } end
        return nil
    end

    local function detect()
        local bins, sampleS = {}, {}
        for _, d in ipairs(root:GetDescendants()) do
            local props = propsOf(d)
            if props then
                for _, prop in ipairs(props) do
                    local c = d[prop]
                    local h, s, v = c:ToHSV()
                    if s > 0.45 and v > 0.5 then
                        local k = math.floor(h * 50)
                        bins[k] = (bins[k] or 0) + 1
                        sampleS[k] = (sampleS[k] or 0) + s
                    end
                end
            end
        end
        local bestK, bestN = nil, 0
        for k, n in pairs(bins) do
            if n > bestN then bestK, bestN = k, n end
        end
        if not bestK then return false end
        accentH = (bestK + 0.5) / 50
        accentS = sampleS[bestK] / bestN
        return true
    end

    local function applyProp(d, prop, th)
        local rec = records[d] and records[d][prop]
        if not rec then return end
        d[prop] = remap(rec.orig, th)
        rec.last = d[prop]
        rec.ver = ver
    end

    local function processInst(d, th)
        if d:IsA("UIGradient") then
            local rec = records[d] and records[d].Color
            if not rec or rec.ver ~= ver then
                local origSeq = rec and rec.orig or d.Color
                local pts, any = {}, false
                for _, kp in ipairs(origSeq.Keypoints) do
                    if isAccent(kp.Value) then any = true end
                    pts[#pts + 1] = ColorSequenceKeypoint.new(kp.Time, remap(kp.Value, th))
                end
                if any then
                    records[d] = records[d] or {}
                    records[d].Color = { orig = origSeq, ver = ver }
                    d.Color = ColorSequence.new(pts)
                end
            end
            return
        end
        local props = propsOf(d)
        if not props then return end
        for _, prop in ipairs(props) do
            local c = d[prop]
            local byInst = records[d]
            local rec = byInst and byInst[prop]
            if rec and c == rec.last then
                if rec.ver ~= ver then applyProp(d, prop, th) end
            elseif isAccent(c) then
                if not byInst then byInst = {}; records[d] = byInst end
                byInst[prop] = { orig = c, last = c, ver = -1 }
                applyProp(d, prop, th)
            elseif rec then
                byInst[prop] = nil
            end
        end
    end

    function t1.applyTheme()
        ver += 1
        sweeping = true
        -- на Default дочищаем ещё 4 секунды, для остальных тем свип идёт постоянно (ловит твины либы)
        sweepUntil = currentTheme() and math.huge or (os.clock() + 4)
    end

    task.spawn(function()
        while not root do
            root = findRoot()
            if not root then task.wait(1) end
        end
        task.wait(0.5)
        if not detect() then return end
        if currentTheme() then t1.applyTheme() end

        -- нарезка по кадрам: ~300 объектов за кадр, без фризов
        local list, idx = root:GetDescendants(), 1
        game:GetService("RunService").RenderStepped:Connect(function()
            if not sweeping then return end
            if os.clock() > sweepUntil then sweeping = false return end
            local th = currentTheme()
            for _ = 1, 300 do
                local d = list[idx]
                if not d then
                    list, idx = root:GetDescendants(), 1
                    break
                end
                idx += 1
                if d.Parent then pcall(processInst, d, th) end
            end
        end)
    end)
end
-- ============================================================
-- [SECTION SCROLL] Вертикальная прокрутка панелей настроек
-- Не меняет callbacks, flags и значения существующих элементов.
-- ============================================================
do
    local sectionNames = {
        ["SILENT AIM"] = true, ["VIEW"] = true, ["PLAYER"] = true,
        ["WORLD"] = true, ["MOVEMENT"] = true, ["MISC"] = true,
        ["RAGE BOT"] = true, ["ATTACK INTERVAL"] = true,
        ["SURFACE PENETRATION"] = true, ["ESP"] = true,
        ["ESP INFO"] = true, ["SPIN"] = true, ["NO RELOAD"] = true,
        ["GOD MODE"] = true, ["SKIN CHANGER"] = true,
        ["KILL EFFECT"] = true, ["CHINA HAT"] = true,
        ["JUMP / LAND SHAPE"] = true, ["CONFIG"] = true,
        ["ACTIONS"] = true, ["THEME"] = true,
    }

    local done = setmetatable({}, {__mode = "k"})
    local function setupSection(title)
        if not title:IsA("TextLabel") or not sectionNames[title.Text] then return end
        local panel = title.Parent
        if not panel or not panel:IsA("Frame") or done[panel] then return end
        -- Обрабатываем только секции, где заголовок и элементы лежат рядом.
        local widgets = {}
        local layouts = {}
        for _, child in ipairs(panel:GetChildren()) do
            if child ~= title then
                if child:IsA("GuiObject") then
                    widgets[#widgets + 1] = child
                elseif child:IsA("UIListLayout") or child:IsA("UIGridLayout") or child:IsA("UIPadding") then
                    layouts[#layouts + 1] = child
                end
            end
        end
        if #widgets < 2 then return end
        -- Если контейнер уже прокручивается, ничего не меняем.
        for _, widget in ipairs(widgets) do
            if widget:IsA("ScrollingFrame") then
                widget.ScrollingDirection = Enum.ScrollingDirection.Y
                widget.AutomaticCanvasSize = Enum.AutomaticSize.Y
                return
            end
        end
        -- Не переносим элементы, если секция использует общий layout:
        -- в таком случае он может управлять и заголовком.
        if #layouts > 0 then return end

        done[panel] = true
        local top = math.max(0, title.Position.Y.Offset + title.Size.Y.Offset + 6)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Name = "LesxovSectionScroll"
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.Position = UDim2.new(0, 0, 0, top)
        scroll.Size = UDim2.new(1, 0, 1, -top)
        scroll.ScrollingDirection = Enum.ScrollingDirection.Y
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = Color3.fromRGB(160, 160, 160)
        scroll.ScrollingEnabled = true
        scroll.Active = true
        scroll.ClipsDescendants = true
        scroll.ZIndex = panel.ZIndex + 1
        scroll.Parent = panel

        local function updateCanvas()
            local bottom = 0
            for _, item in ipairs(widgets) do
                if item.Parent == scroll then
                    bottom = math.max(bottom, item.Position.Y.Offset + item.AbsoluteSize.Y + 10)
                end
            end
            scroll.CanvasSize = UDim2.fromOffset(0, math.max(0, bottom))
        end
        for _, item in ipairs(widgets) do
            local p = item.Position
            item.Parent = scroll
            item.Position = UDim2.new(p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset - top)
            item:GetPropertyChangedSignal("Size"):Connect(updateCanvas)
            item:GetPropertyChangedSignal("Visible"):Connect(updateCanvas)
        end
        task.defer(updateCanvas)
        scroll.ChildAdded:Connect(function() task.defer(updateCanvas) end)
    end

    task.spawn(function()
        for _ = 1, 30 do
            local root = t1.findFrame()
            if root then
                for _, d in ipairs(root:GetDescendants()) do
                    pcall(setupSection, d)
                end
            end
            task.wait(1)
        end
    end)
end