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
-- ============================================================
-- [WINDUI] библиотека интерфейса: WindUI (Footagesus).
-- ниже тонкий адаптер: отдаёт коду старый API (v13:AddMenu -> :AddSection -> :AddToggle/AddSlider/...,
-- у пункта с Option = true под-настройки уходят в сворачиваемую подсекцию), а рисует всё через WindUI.
-- все фичи ниже по файлу работают без изменений.
-- ============================================================
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
t1.WindUI = WindUI
local UserInputService = game:GetService("UserInputService")

local Window = WindUI:CreateWindow({
	Title = "Lesxov Tap",
	Icon = "crosshair",
	Folder = "LesxovTapUI",
	Theme = "Dark",
	NewElements = true,
	OpenButton = { Title = "Lesxov Tap", Enabled = true, Draggable = true, OnlyMobile = false },
})
t1.Window = Window
pcall(function() Window:SetToggleKey(Enum.KeyCode.H) end) -- H скрывает/показывает окно, на телефоне есть круглая кнопка

-- уведомления
local v11 = {}
function v11:Notify(o)
	o = o or {}
	local title, content = tostring(o.Title or ""), tostring(o.Content or "")
	local ok = pcall(function()
		WindUI:Notify({ Title = title, Content = content, Icon = o.Icon, Duration = o.Duration or 4 })
	end)
	if not ok then
		pcall(function() WindUI:Notify({ Title = title, Content = content, Duration = o.Duration or 4 }) end)
	end
end

local function wuTry(container, method, params)
	local ok, res = pcall(function() return container[method](container, params) end)
	if ok then return res end
	return nil
end

local makeSection
makeSection = function(container, fallback, title)
	local sec = { _c = container, _fb = fallback }

	local function create(method, params)
		local el = wuTry(sec._c, method, params)
		if el == nil and sec._fb then el = wuTry(sec._fb, method, params) end
		return el
	end

	-- Option = true: под-настройки в сворачиваемой подсекции сразу под пунктом
	local function withOption(el, o)
		if o.Option then
			local sub = wuTry(sec._c, "Section", {
				Title = tostring(o.Name or title or "") .. " settings", Box = true, BoxBorder = true, Opened = false,
			})
			if sub then
				el.Option = makeSection(sub, sec._c, title)
			else
				el.Option = makeSection(sec._c, sec._fb, title)
			end
		end
		return el
	end

	function sec:AddToggle(o)
		o = o or {}
		local el = { Value = o.Default == true }
		local native = create("Toggle", {
			Title = tostring(o.Name or "Toggle"), Desc = o.Desc, Value = el.Value,
			Callback = function(v)
				el.Value = v and true or false
				if o.Callback then o.Callback(el.Value) end
			end,
		})
		function el:Set(v)
			v = v and true or false
			if not (native and pcall(function() native:Set(v) end)) then el.Value = v end
		end
		return withOption(el, o)
	end

	function sec:AddSlider(o)
		o = o or {}
		local mn, mx = o.Min or 0, o.Max or 100
		local el = { Value = math.clamp(o.Default or mn, mn, mx) }
		local native = create("Slider", {
			Title = tostring(o.Name or "Slider"), Step = o.Step or 1,
			Value = { Min = mn, Max = mx, Default = el.Value },
			Callback = function(v)
				el.Value = v
				if o.Callback then o.Callback(v) end
			end,
		})
		function el:Set(v)
			if not (native and pcall(function() native:Set(v) end)) then el.Value = v end
		end
		return withOption(el, o)
	end

	function sec:AddDropdown(o)
		o = o or {}
		local vals = o.Values or {}
		local def = o.Default
		if type(def) == "table" and not o.Multi then def = def[1] end
		if o.Multi ~= true and (def == nil or not table.find(vals, def)) then def = vals[1] end
		local el = { Value = def }
		local native = create("Dropdown", {
			Title = tostring(o.Name or "Dropdown"), Values = vals, Value = def, Multi = o.Multi,
			Callback = function(v)
				if not o.Multi then
                    if type(v) == "table" then v = v[1] end
                    if type(v) == "number" and not table.find(vals, v) then v = vals[v] end
                    if not table.find(vals, v) then return end
                end
                el.Value = v
				if o.Callback then o.Callback(v) end
			end,
		})
		function el:Set(v)
			local ok = native and (pcall(function() native:Select(v) end) or pcall(function() native:Set(v) end))
			if ok or o.Multi or table.find(vals, v) then el.Value = v end
		end
		function el:Refresh(list)
			if native then pcall(function() native:Refresh(list) end) end
		end
		return withOption(el, o)
	end

	function sec:AddColorPicker(o)
		o = o or {}
		local def = o.Default or Color3.new(1, 1, 1)
		local el = { Value = def }
		local native = create("Colorpicker", {
			Title = tostring(o.Name or "Color"), Default = def, Transparency = 0,
			Callback = function(c)
				el.Value = c
				if o.Callback then o.Callback(c) end
			end,
		})
		function el:Set(c)
			if not (native and pcall(function() native:Set(c) end)) then el.Value = c end
		end
		return el
	end

	function sec:AddButton(o)
		o = o or {}
		create("Button", { Title = tostring(o.Name or o.Title or o.Text or "Button"), Callback = o.Callback })
		return {}
	end

	return sec
end

local v13 = {}
function v13:AddConfig() return { Init = function() end } end
function v13:AddMenu(o)
	o = o or {}
	local icon = o.Icon
	if icon == "cog" then icon = "settings" end
	local tab = wuTry(Window, "Tab", { Title = tostring(o.Name or "Menu"), Icon = icon })
	if not tab then tab = wuTry(Window, "Tab", { Title = tostring(o.Name or "Menu") }) end
	if not tab then error("WindUI: Window:Tab failed for " .. tostring(o.Name)) end
	local menu = {}
	function menu:AddSection(so)
		so = so or {}
		local c = wuTry(tab, "Section", { Title = tostring(so.Name or "Section"), Box = true, BoxBorder = true, Opened = true })
		return makeSection(c or tab, tab, so.Name)
	end
	return menu
end

v11:Notify({ Title = "Lesxov Tap", Content = "made by lesxov", Icon = "clipboard" })
v11:Notify({ Title = "LESXOV TAP LOADED", Content = "Hello, " .. game.Players.LocalPlayer.DisplayName .. "! Welcome back.", Icon = "check" })

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
t1.mFx = mkMenu("EFFECTS", "eye")
local vSettings = mkMenu("SETTINGS", "cog")

-- ============================================================
-- [REG] реестр виджетов. ловит каждый AddToggle/AddSlider/AddDropdown/AddColorPicker
-- (и под-настройки через .Option), чтобы конфиги сохраняли и применяли ВСЕ флаги вживую.
-- ставится до создания секций; если хук не сработал, конфиги работают по старым env-ключам.
-- ============================================================
do
    local Reg = { byFlag = {}, order = {}, hooked = 0, setter = nil }
    local METHODS = { AddToggle = "toggle", AddSlider = "slider", AddDropdown = "dropdown", AddColorPicker = "color" }
    local SETTERS = { "Set", "SetValue", "SetState", "SetToggle", "SetColor", "SetSelected", "SetOption", "SetCurrent" }
    local seen = setmetatable({}, { __mode = "k" })

    local function toHex(c)
        return string.format("%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
    end
    local function fromHex(h)
        if type(h) ~= "string" or #h ~= 6 then return nil end
        local r, g, b = tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)
        if not (r and g and b) then return nil end
        return Color3.fromRGB(r, g, b)
    end

    local function skip(flag)
        return flag:match("^Cfg") ~= nil or flag:match("^Btn_") ~= nil
    end

    local hookSection
    hookSection = function(sec)
        if type(sec) ~= "table" or seen[sec] then return end
        seen[sec] = true
        for method, kind in pairs(METHODS) do
            local orig = sec[method]
            if type(orig) == "function" then
                local ok = pcall(function()
                    sec[method] = function(self, o, ...)
                        if type(o) ~= "table" then return orig(self, o, ...) end
                        local flag = o.Flag
                        local r
                        if type(flag) == "string" and not skip(flag) then
                            r = { flag = flag, kind = kind, cb = o.Callback, default = o.Default, last = o.Default }
                            o.Callback = function(...)
                                local v = ...
                                r.hit = true
                                r.last = v
                                if r.cb then return r.cb(...) end
                            end
                        end
                        local el = orig(self, o, ...)
                        if r then
                            r.el = el
                            if not Reg.byFlag[flag] then Reg.order[#Reg.order + 1] = flag end
                            Reg.byFlag[flag] = r
                        end
                        if type(el) == "table" then
                            local okOpt, opt = pcall(function() return el.Option end)
                            if okOpt and type(opt) == "table" then hookSection(opt) end
                        end
                        return el
                    end
                end)
                if ok then Reg.hooked = Reg.hooked + 1 end
            end
        end
    end

    function Reg.hookMenu(menu)
        if type(menu) ~= "table" then return end
        local orig = menu.AddSection
        if type(orig) ~= "function" then return end
        pcall(function()
            menu.AddSection = function(self, o, ...)
                local sec = orig(self, o, ...)
                hookSection(sec)
                return sec
            end
        end)
    end

    -- текущее значение виджета: .Value если он есть и тип сходится, иначе последнее из callback
    function Reg.get(r)
        local v = r.last
        local el = r.el
        if type(el) == "table" then
            local ok, cur = pcall(function() return el.Value end)
            if ok and cur ~= nil then
                if r.kind == "toggle" and type(cur) == "boolean" then v = cur
                elseif r.kind == "slider" and type(cur) == "number" then v = cur
                elseif r.kind == "dropdown" and (type(cur) == "string" or type(cur) == "table") then v = cur
                elseif r.kind == "color" and typeof(cur) == "Color3" then v = cur end
            end
        end
        return v
    end

    function Reg.encode(v)
        if typeof(v) == "Color3" then return { __c = toHex(v) } end
        return v
    end

    function Reg.decode(r, raw)
        if r.kind == "color" then
            if type(raw) == "table" and type(raw.__c) == "string" then return fromHex(raw.__c) end
            return nil
        elseif r.kind == "toggle" then
            if type(raw) == "boolean" then return raw end
        elseif r.kind == "slider" then
            if type(raw) == "number" then return raw end
        elseif r.kind == "dropdown" then
            if type(raw) == "table" and r.el and type(r.el.Value) ~= "table" then raw = raw[1] end
            if type(raw) == "string" or type(raw) == "table" then return raw end
        end
        return nil
    end

    local function same(a, b)
        if typeof(a) == "Color3" and typeof(b) == "Color3" then return toHex(a) == toHex(b) end
        if type(a) == "table" or type(b) == "table" then return false end
        return a == b
    end

    -- применить значение: визуально через сеттер виджета, эффект через callback (если либа сама его не дёрнула)
    function Reg.apply(r, v)
        if same(Reg.get(r), v) then return false end
        r.hit = false
        local el = r.el
        if type(el) == "table" then
            for _, m in ipairs(SETTERS) do
                local okf, f = pcall(function() return el[m] end)
                if okf and type(f) == "function" then
                    if pcall(f, el, v) then
                        Reg.setter = Reg.setter or m
                        break
                    end
                end
            end
        end
        if not r.hit and r.cb then pcall(r.cb, v) end
        r.last = v
        return true
    end

    -- какой сеттер есть у виджетов (для диагностики в уведомлении)
    function Reg.probe()
        for _, flag in ipairs(Reg.order) do
            local el = Reg.byFlag[flag].el
            if type(el) == "table" then
                for _, m in ipairs(SETTERS) do
                    local okf, f = pcall(function() return el[m] end)
                    if okf and type(f) == "function" then return m end
                end
            end
        end
        return nil
    end

    function Reg.reset()
        local i = 0
        for _, flag in ipairs(Reg.order) do
            local r = Reg.byFlag[flag]
            if r and r.default ~= nil then
                Reg.apply(r, r.default)
                i = i + 1
                if i % 12 == 0 then task.wait() end
            end
        end
    end

    Reg.toHex, Reg.fromHex = toHex, fromHex
    t1.Reg = Reg

    Reg.hookMenu(v15)
    Reg.hookMenu(t1.mVisuals)
    Reg.hookMenu(t1.mMove)
    Reg.hookMenu(t1.mMisc)
    Reg.hookMenu(t1.mFx)
    Reg.hookMenu(vSettings)
end

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
-- [CONFIG] core v2. именованные конфиги: LesxovTap/configs/<name>.json
-- формат: { version = 2, flags = { <Flag> = value }, env = { <key> = value } }
--   flags: все виджеты меню через реестр [REG] (применяются вживую, с обновлением ползунков)
--   env:   служебные ключи getgenv (как в старых конфигах; старый плоский формат тоже читается)
-- meta.json: { slot, startup, autosave }. startup = конфиг, который грузится при запуске
-- ============================================================
do
    local HttpService = game:GetService("HttpService")
    local Reg = t1.Reg
    local Cfg = {
        Folder = "LesxovTap",
        Slot = nil,
        Startup = nil,
        Autosave = false,
        ready = false,
        _sig = nil,
        Keys = {
            "SilentAim", "SilentAimTarget", "SilentAimFOVEnabled", "SilentAimFOV",
            "AutoKnifeEnabled", "AutoRefreshEnabled", "RageBotEnabled", "RageBotHitbox", "RageBotAutoFire",
            "AttackIntervalEnabled", "AttackInterval", "AttackHold", "AttackJitter",
            "PenetrationEnabled", "PenetrationMax",
            "RageMagEnabled", "WallbangEnabled", "WallbangAutoFire", "WallbangFOV",
            "FeatureMode", "PulseAim", "PulseMin", "PulseMax", "PulseSmooth", "PulseSpeed",
            "MotionTrail", "TrailDetail", "TrailShape", "TrailTint", "TrailWidth", "TrailTip", "TrailTime", "SnowStyle",
            "SpinMode", "SpinSpeed", "SpinJitterAngle", "SpinDesyncRoll", "UndoDuration",
            "BulletTrailsEnabled", "BulletTrailModel", "BulletTrailLife",
            "Theme", "ThemeHue", "ThemeSat",
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
    local mem = {} -- если у экзекутора нет файловой системы (живёт до выхода из игры)

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
        name = Cfg.clean(name)
        if name == "" then return false end
        local s = rd(file(name))
        return s ~= nil and s ~= ""
    end

    function Cfg.list()
        local out, seen = {}, {}
        if fsOk and type(listfiles) == "function" then
            pcall(function()
                for _, f in ipairs(listfiles(Cfg.Folder .. "/configs")) do
                    local n = tostring(f):match("([^/\\]+)%.json$")
                    if n and not seen[n] and Cfg.exists(n) then seen[n] = true; out[#out + 1] = n end
                end
            end)
        else
            for k, v in pairs(mem) do
                local n = k:match("^configs/(.+)%.json$")
                if n and v ~= "" and not seen[n] then seen[n] = true; out[#out + 1] = n end
            end
        end
        table.sort(out, function(a, b) return a:lower() < b:lower() end)
        return out
    end

    local function simple(v)
        local t = type(v)
        return t == "boolean" or t == "number" or t == "string"
    end

    function Cfg.snapshot()
        local data = { version = 2, flags = {}, env = {} }
        for _, flag in ipairs(Reg.order) do
            local r = Reg.byFlag[flag]
            local v = r and Reg.get(r)
            if v ~= nil then data.flags[flag] = Reg.encode(v) end
        end
        local env = getgenv()
        for _, k in ipairs(Cfg.Keys) do
            if simple(env[k]) then data.env[k] = env[k] end
        end
        return data
    end

    -- детерминированная подпись состояния (JSONEncode не гарантирует порядок ключей)
    local function sig(data)
        local parts = {}
        for k, v in pairs(data.flags) do
            parts[#parts + 1] = k .. "=" .. (type(v) == "table" and (v.__c or HttpService:JSONEncode(v)) or tostring(v))
        end
        for k, v in pairs(data.env) do parts[#parts + 1] = "e:" .. k .. "=" .. tostring(v) end
        table.sort(parts)
        return table.concat(parts, "|")
    end

    function Cfg.saveMeta()
        wr("meta.json", HttpService:JSONEncode({ slot = Cfg.Slot or "", startup = Cfg.Startup or "", autosave = Cfg.Autosave }))
    end

    function Cfg.save(name)
        name = Cfg.clean(name)
        if name == "" then return false, "empty name" end
        local data = Cfg.snapshot()
        local okEnc, json = pcall(HttpService.JSONEncode, HttpService, data)
        if not okEnc then return false, "encode failed" end
        if not wr(file(name), json) then return false, "write failed" end
        Cfg.Slot = name
        Cfg._sig = sig(data)
        Cfg.saveMeta()
        return true, name, #Reg.order
    end

    local function applyEnv(data)
        local env = getgenv()
        local map = data.env or (data.version == nil and data or nil)
        if type(map) ~= "table" then return end
        for _, k in ipairs(Cfg.Keys) do
            local v = map[k]
            if v ~= nil and type(v) == type(env[k]) then env[k] = v end
        end
    end

    -- yield-safe (task.wait внутри), вызывать из task.spawn
    function Cfg.load(name)
        name = Cfg.clean(name)
        local data = dec(rd(file(name)))
        if not data then return false, 0 end
        applyEnv(data)
        local n, i = 0, 0
        if type(data.flags) == "table" then
            for flag, raw in pairs(data.flags) do
                local r = Reg.byFlag[flag]
                if r then
                    local v = Reg.decode(r, raw)
                    if v ~= nil and Reg.apply(r, v) then n = n + 1 end
                    i = i + 1
                    if i % 12 == 0 then task.wait() end
                end
            end
        end
        Cfg.Slot = name
        Cfg._sig = sig(Cfg.snapshot())
        Cfg.saveMeta()
        return true, n
    end

    function Cfg.delete(name)
        name = Cfg.clean(name)
        if not Cfg.exists(name) then return false end
        if not fsOk then
            mem[file(name)] = nil
        else
            local ok = pcall(function()
                local p = Cfg.Folder .. "/" .. file(name)
                if type(delfile) == "function" then
                    delfile(p)
                else
                    writefile(p, "") -- нет delfile: файл обнуляем, exists() его уже не видит
                end
            end)
            if not ok then return false end
        end
        if Cfg.Slot == name then Cfg.Slot = nil end
        if Cfg.Startup == name then Cfg.Startup = nil end
        Cfg.saveMeta()
        return true
    end

    function Cfg.resetValues()
        local env = getgenv()
        for k, v in pairs(Cfg.defaults or {}) do env[k] = v end
        if Reg and Reg.reset then Reg.reset() end
    end

    -- ранняя загрузка (до построения меню): только env, чтобы виджеты родились с нужными Default
    function Cfg.init()
        Cfg.defaults = Cfg.snapshot().env
        ensureDirs()
        -- миграция со старого формата LesxovTap/<slot>.json
        pcall(function()
            if fsOk and not Cfg.exists("default") and isfile(Cfg.Folder .. "/default.json") then
                wr(file("default"), readfile(Cfg.Folder .. "/default.json"))
            end
        end)
        local meta = dec(rd("meta.json"))
        if meta then
            if type(meta.autosave) == "boolean" then Cfg.Autosave = meta.autosave end
            -- старый meta хранил только slot (его грузили всегда), новый хранит startup
            local s = meta.startup
            if s == nil then s = meta.slot end
            if type(s) == "string" and s ~= "" and Cfg.exists(s) then Cfg.Startup = Cfg.clean(s) end
            if type(meta.slot) == "string" and meta.slot ~= "" and Cfg.exists(meta.slot) then Cfg.Slot = Cfg.clean(meta.slot) end
        end
        if Cfg.Startup then
            local data = dec(rd(file(Cfg.Startup)))
            if data then applyEnv(data) end
        end
    end

    -- поздняя загрузка (после построения меню): flags применяются вживую
    function Cfg.finish()
        if Cfg.Startup then pcall(Cfg.load, Cfg.Startup) end
        Cfg._sig = sig(Cfg.snapshot())
        Cfg.ready = true
    end

    task.spawn(function()
        while task.wait(2) do
            if Cfg.ready and getgenv().AutoRefreshEnabled and t1.refreshFeatures and os.clock() >= t1.refreshAt then
                t1.refreshAt = os.clock() + 60
                t1.refreshFeatures()
            end
            if Cfg.ready and Cfg.Autosave and Cfg.Slot and Cfg.exists(Cfg.Slot) then
                local ok, data = pcall(Cfg.snapshot)
                if ok and sig(data) ~= Cfg._sig then pcall(Cfg.save, Cfg.Slot) end
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

getgenv().AutoKnifeEnabled = false
getgenv().AutoRefreshEnabled = false
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
do
    local env = getgenv()
    for key, value in pairs({FeatureMode = "New", PulseAim = false, PulseMin = 4, PulseMax = 22,
        PulseSmooth = 16, PulseSpeed = 16, MotionTrail = false, TrailDetail = "Simple",
        TrailShape = "Ribbon", TrailTint = "73D8FF", TrailWidth = 12, TrailTip = 15, TrailTime = 5}) do
        env[key] = value
    end
end
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
getgenv().ThemeHue = getgenv().ThemeHue or 330
getgenv().ThemeSat = getgenv().ThemeSat or 70
t1.Cfg.init()

-- Acquisition stays anchored to the character even in third person.
function t1.aimOrigin()
    local char = t1.value8.Character
    local part = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
    return part and part.Position
end

function t1.weaponOrigin(data)
    local incoming = data and data.Origin
    local camera = workspace.CurrentCamera
    -- Some weapons send a camera ray. Keep a real weapon origin when the game supplies one.
    if typeof(incoming) == "Vector3" and (not camera or (incoming - camera.CFrame.Position).Magnitude > 0.1) then
        return incoming
    end
    local char = t1.value8.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    local muzzle = tool and (tool:FindFirstChild("Muz", true) or tool:FindFirstChild("Muzzle", true))
    if muzzle and muzzle:IsA("Attachment") then return muzzle.WorldPosition end
    if muzzle and muzzle:IsA("BasePart") then return muzzle.Position end
    return t1.aimOrigin() or incoming
end

function getRageBotTarget(origin)
    origin = origin or t1.weaponOrigin()
    if not origin then return nil end
    local env = getgenv()
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {t1.value8.Character, workspace.CurrentCamera}
    local closest, distance = nil, math.huge
    local all = env.RageBotHitbox == "All"
    local names = all and {"Head", "UpperTorso", "Torso", "HumanoidRootPart"} or {env.RageBotHitbox or "Head"}
    for _, player in ipairs(t1.value5:GetPlayers()) do
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if player ~= t1.value8 and hum and hum.Health > 0 then
            for _, name in ipairs(names) do
                local part = char:FindFirstChild(name) or (not all and char:FindFirstChild("Head"))
                if part and part:IsA("BasePart") then
                    local delta = part.Position - origin
                    local dist = delta.Magnitude
                    if dist > 0 and dist < distance then
                        local hit = workspace:Raycast(origin, delta, params)
                        if env.WallbangEnabled or not hit or hit.Instance:IsDescendantOf(char) then
                            closest, distance = part, dist
                            break
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- wallbang FOV target: closest-to-crosshair player inside WallbangFOV (deg), walls ignored
function getWallbangTarget()
    local origin = t1.aimOrigin()
    if not origin then return nil end
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
                if not c then return nil end
                local dir = (part.Position - origin).Unit
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
t1.shotAt = setmetatable({}, {__mode = "k"})
local oldFire = BulletHandler.Fire

do
    local lp = t1.value8
    local knife, previous, nextSwing, elapsed = nil, nil, 0, 0
    local function release()
        local char, pack = lp.Character, lp:FindFirstChildOfClass("Backpack")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if knife and char and knife.Parent == char and hum and hum.Health > 0 then
            knife:Deactivate()
            if previous and pack and previous.Parent == pack then hum:EquipTool(previous)
            elseif previous ~= knife and pack then knife.Parent = pack end
        end
        knife, previous, t1.knifeBusy = nil, nil, false
    end
    local function isKnife(tool)
        if not tool or not tool:IsA("Tool") then return false end
        return tool:GetAttribute("WeaponType") == "Knife" or tool.Name:lower():find("knife", 1, true) ~= nil
    end
    v22:AddToggle({Name = "Auto Knife", Flag = "AutoKnifeEnabled", Default = getgenv().AutoKnifeEnabled,
        Callback = function(on)
            getgenv().AutoKnifeEnabled = on
            if not on then release() end
        end})
    game:GetService("RunService").Heartbeat:Connect(function(dt)
        if not getgenv().AutoKnifeEnabled then return end
        elapsed = elapsed + dt
        if elapsed < 0.035 then return end
        elapsed = 0
        local char = lp.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then release() return end
        local equipped = char:FindFirstChildOfClass("Tool")
        if knife and equipped ~= knife then release() return end
        local tool = equipped
        if not isKnife(tool) then
            tool = nil
            local pack = lp:FindFirstChildOfClass("Backpack")
            if pack then
                for _, item in ipairs(pack:GetChildren()) do
                    if isKnife(item) then tool = item break end
                end
            end
        end
        if not tool then release() return end
        local reach = tonumber(tool:GetAttribute("MeleeRange") or tool:GetAttribute("Range")) or 6
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = {char}
        for _, player in ipairs(t1.value5:GetPlayers()) do
            local other = player.Character
            local part = other and other:FindFirstChild("HumanoidRootPart")
            if player ~= lp and part and (part.Position - root.Position).Magnitude <= reach then
                local health = other:FindFirstChildOfClass("Humanoid")
                local hit = workspace:Raycast(root.Position, part.Position - root.Position, params)
                if health and health.Health > 0 and (not hit or hit.Instance:IsDescendantOf(other)) then
                    t1.knifeBusy = true
                    if t1.gunHeld then return end
                    if not knife then knife, previous = tool, equipped end
                    if equipped ~= tool then hum:EquipTool(tool) end
                    if tool.Parent == char and tool.Enabled and os.clock() >= nextSwing then
                        nextSwing = os.clock() + math.max(0.05, tonumber(tool:GetAttribute("AttackCooldown")) or 0.25)
                        t1.shotAt[other] = os.clock()
                        tool:Activate()
                        tool:Deactivate()
                    end
                    return
                end
            end
        end
        if t1.knifeBusy then release() end
    end)
end

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

function t1.pulseActive()
    return getgenv().FeatureMode == "New" and getgenv().PulseAim
end

local function isInFOV(targetPart, origin)
    if not getgenv().SilentAimFOVEnabled and not t1.pulseActive() then return true end
    
    local cam = t1.value6.CurrentCamera
    local fovRadius = t1.pulseActive() and (t1.pulseAngle or getgenv().PulseMin) or getgenv().SilentAimFOV or 50
    if not cam then return false end
    local dir = (targetPart.Position - origin).Unit
    local angle = math.acos(math.clamp(cam.CFrame.LookVector:Dot(dir), -1, 1))
    local deg = math.deg(angle)
    return deg <= fovRadius
end

local function getSilentAimTarget()
    local origin = t1.aimOrigin()
    if not origin then return nil end
    if not getgenv().SilentAim then return nil end
    
    local closest = nil
    local closestDist = math.huge
    local targetPartName = getgenv().SilentAimTarget or "Head"
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    if t1.value8.Character then
        rayParams.FilterDescendantsInstances = {t1.value8.Character}
    end
    
    for _, player in ipairs(t1.value5:GetPlayers()) do
        if player ~= t1.value8 and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPart = player.Character:FindFirstChild(targetPartName)
            if targetPart and isInFOV(targetPart, origin) then
                
                local dir = targetPart.Position - origin
                local d = dir.Magnitude
                if d < closestDist then
                    local hit = t1.value6:Raycast(origin, dir, rayParams)
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
    
    local rageOrigin = t1.weaponOrigin(data)
    if getgenv().RageBotEnabled then
        target = getRageBotTarget(rageOrigin)
        shouldChange = target ~= nil
        if target and data then data.Origin = rageOrigin end
    end
    if not shouldChange and getgenv().SilentAim then
        target = getSilentAimTarget()
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

    if shouldChange and target and data and data.Origin and (target.Position - data.Origin).Magnitude > 0 then
        data.Direction = (target.Position - data.Origin).Unit
        if data.Misc then data.Misc.CamCFrame = CFrame.lookAt(data.Origin, target.Position) end
    end
    
    if target then
        t1.shotAt[target.Parent] = os.clock()
    elseif data and typeof(data.Origin) == "Vector3" and typeof(data.Direction) == "Vector3" and data.Direction.Magnitude > 0 then
        if getgenv().KillFxEnabled then
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {t1.value8.Character, workspace.CurrentCamera}
            local hit = workspace:Raycast(data.Origin, data.Direction.Unit * 1500, params)
            local model = hit and hit.Instance:FindFirstAncestorOfClass("Model")
            if model then t1.shotAt[model] = os.clock() end
        end
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
            if not t1.knifeBusy and g.RageBotEnabled and g.RageBotAutoFire and getRageBotTarget() then
                local interval, hold = 0.1, 0.05
                if g.RageMagEnabled then
                    -- rage mag: стреляет сразу, как только цель появилась
                    interval, hold = 0.03, 0.015
                end
                if g.AttackIntervalEnabled then
                    interval = g.AttackInterval / 1000
                    if g.AttackJitter > 0 then
                        interval = interval + (math.random() * 2 - 1) * g.AttackJitter / 1000
                    end
                    hold = g.AttackHold / 1000
                end
                interval = math.max(interval, 0.02)
                hold = math.min(hold, interval)

                t1.gunHeld = true
                SignalManager.Fire("FireWeapon", Enum.UserInputState.Begin)
                task.wait(hold)
                SignalManager.Fire("FireWeapon", Enum.UserInputState.End)
                t1.gunHeld = false
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
        if not t1.knifeBusy and g.WallbangEnabled and g.WallbangAutoFire
            and not (g.RageBotEnabled and g.RageBotAutoFire) and getWallbangTarget() then
            local interval, hold = 0.1, 0.05
            if g.AttackIntervalEnabled then
                interval = g.AttackInterval / 1000
                hold = math.min(g.AttackHold / 1000, interval)
            end
            t1.gunHeld = true
            SignalManager.Fire("FireWeapon", Enum.UserInputState.Begin)
            task.wait(hold)
            SignalManager.Fire("FireWeapon", Enum.UserInputState.End)
            t1.gunHeld = false
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

do
    local classic = uiGradient.Color
    local accent = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(101, 214, 255)),
        ColorSequenceKeypoint.new(0.48, Color3.fromRGB(229, 222, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(167, 122, 255))
    })
    local lastMode
    RunService.RenderStepped:Connect(function(dt)
        local env, camera = getgenv(), workspace.CurrentCamera
        local advanced = env.FeatureMode == "New"
        if advanced ~= lastMode then
            uiGradient.Color = advanced and accent or classic
            uiStroke.Thickness = advanced and 1.8 or 2
            lastMode = advanced
        end
        local pulse = t1.pulseActive()
        if pulse then
            local char = t1.value8.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local v = root and root.AssemblyLinearVelocity or Vector3.zero
            local blend = math.clamp(Vector3.new(v.X, 0, v.Z).Magnitude / math.max(1, env.PulseSpeed), 0, 1)
            local low, high = math.min(env.PulseMin, env.PulseMax), math.max(env.PulseMin, env.PulseMax)
            local angle = low + (high - low) * blend
            local prev = t1.pulseAngle or low
            t1.pulseAngle = prev + (angle - prev) * (1 - math.exp(-dt * 100 / math.max(1, env.PulseSmooth)))
        else
            t1.pulseAngle = nil
        end
        local silent = env.SilentAim and env.SilentAimFOVEnabled
        fovCircleFrame.Visible = camera ~= nil and (pulse or silent or env.WallbangEnabled)
        if not fovCircleFrame.Visible then return end
        local angle = t1.pulseAngle or (silent and env.SilentAimFOV or env.WallbangFOV)
        local radius = camera.ViewportSize.Y * 0.5 * math.tan(math.rad(math.clamp(angle, 0.1, 89))) / math.tan(math.rad(camera.FieldOfView / 2))
        fovCircleFrame.Size = UDim2.fromOffset(2 * radius, 2 * radius)
        uiGradient.Rotation = (uiGradient.Rotation + dt * 18) % 360
    end)
end

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

            if v188 then return v188 end
        elseif child:IsDescendantOf(t1.value1) then
            return child
        end
    end

    return nil
end
function t1.value31(character)
    while character == t1.value19.Character and character.Parent do
        local muzzle = t1.value30(character)
        if muzzle then return muzzle end
        task.wait(0.3)
    end
end
local function v33(character)
    t1.currentMuzzle = nil
    task.spawn(function()
        local muzzle = t1.value31(character)
        if character == t1.value19.Character then t1.currentMuzzle = muzzle end
    end)
end
t1.value18.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and t1.value29 and t1.currentMuzzle then
        t1.value29(t1.currentMuzzle)
    end
end)
t1.value19.CharacterAdded:Connect(v33)
if t1.value19.Character then v33(t1.value19.Character) end

t1.value32 = nil
t1.value33 = {}
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

            if Charm and (p28 == Charm or Charm:IsAncestorOf(p28)) then
                return
            end
        end
    elseif p28.Name ~= "Charm" and (not p28.Parent or p28.Parent.Name ~= "Charm") then
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
t1.materialWatched = setmetatable({}, {__mode = "k"})
function t1.value49(p30)
    for _, descendant in ipairs(p30:GetDescendants()) do
        t1.value48(descendant, false)
        t1.value48(descendant, true)
    end

    if t1.materialWatched[p30] then return end
    t1.materialWatched[p30] = true
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

    if t1.materialWatched[p31] then return end
    t1.materialWatched[p31] = true
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
t1.value53.RenderStepped:Connect(function(dt)
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
                    local vector3 = Vector3.new(0, t1.value57.Speed * dt, 0)

                    v[s2] = v[s2] - vector3
                end
            end
        end
    end

    if t1.value59.Type == "Snow" then
        local style = getgenv().SnowStyle or "Realistic"
        local snowDt = dt
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
                        fall = fall + Vector3.new(math.sin(tick() * 1.5 + seed) * snowDt * 6, 0, math.cos(tick() * 1.1 + seed) * snowDt * 4)
                    end
                    v.Position = v.Position - fall
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
-- [LIGHTING] в секцию WORLD: Ambient, Fog color, Time of day, Brightness,
-- Color correction, Sun rays, Atmosphere, Depth of field, No shadows.
-- клиентские эффекты Lighting; включённые пункты держатся каждый кадр (игра может их сбрасывать),
-- выключенные возвращают исходные значения. под-настройки в шестерёнке у каждого пункта.
-- ============================================================
do
    local ok, err = pcall(function()
        local Lighting = game:GetService("Lighting")
        local RunService = game:GetService("RunService")

        local orig = {
            Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient, FogColor = Lighting.FogColor,
            Brightness = Lighting.Brightness, GlobalShadows = Lighting.GlobalShadows,
        }
        local S = {
            ambient = { on = false, a = Color3.fromRGB(110, 110, 160), o = Color3.fromRGB(110, 110, 160) },
            fog = { on = false, c = Color3.fromRGB(180, 180, 255) },
            time = { on = false, v = 12 },
            bright = { on = false, v = 20 },                       -- x0.1
            cc = { on = false, sat = 130, con = 110, tint = Color3.fromRGB(255, 255, 255) }, -- 100 = без изменений
            sun = { on = false, int = 25, spread = 100 },
            atmo = { on = false, dens = 30, haze = 10, col = Color3.fromRGB(199, 170, 107) },
            dof = { on = false, far = 50, focus = 40, radius = 30 },
            shadows = { on = false },
        }

        local function ensure(class, name)
            local o = Lighting:FindFirstChild(name)
            if not o or not o:IsA(class) then
                if o then o:Destroy() end
                o = Instance.new(class)
                o.Name = name
                o.Parent = Lighting
            end
            return o
        end
        local function drop(name)
            local o = Lighting:FindFirstChild(name)
            if o then o:Destroy() end
        end

        -- Atmosphere: если у игры уже есть своя, правим её (и запоминаем оригинал), иначе делаем свою
        local atmoSaved
        local function atmoTarget()
            for _, c in ipairs(Lighting:GetChildren()) do
                if c:IsA("Atmosphere") and c.Name ~= "LT_Atmo" then return c, false end
            end
            return ensure("Atmosphere", "LT_Atmo"), true
        end

        local function refreshEffects()
            if S.cc.on then
                local e = ensure("ColorCorrectionEffect", "LT_CC")
                e.Saturation = (S.cc.sat - 100) / 100
                e.Contrast = (S.cc.con - 100) / 100
                e.TintColor = S.cc.tint
            else
                drop("LT_CC")
            end

            if S.sun.on then
                local e = ensure("SunRaysEffect", "LT_Sun")
                e.Intensity = S.sun.int / 100
                e.Spread = S.sun.spread / 100
            else
                drop("LT_Sun")
            end

            if S.atmo.on then
                local e, own = atmoTarget()
                if not own and not atmoSaved then
                    atmoSaved = { inst = e, Density = e.Density, Haze = e.Haze, Color = e.Color }
                end
                e.Density = S.atmo.dens / 100
                e.Haze = S.atmo.haze / 10
                e.Color = S.atmo.col
            else
                drop("LT_Atmo")
                if atmoSaved then
                    local a = atmoSaved
                    if a.inst and a.inst.Parent then
                        a.inst.Density, a.inst.Haze, a.inst.Color = a.Density, a.Haze, a.Color
                    end
                    atmoSaved = nil
                end
            end

            if S.dof.on then
                local e = ensure("DepthOfFieldEffect", "LT_DoF")
                e.NearIntensity = 0
                e.FarIntensity = S.dof.far / 100
                e.FocusDistance = S.dof.focus
                e.InFocusRadius = S.dof.radius
            else
                drop("LT_DoF")
            end
        end

        -- World (ambient-тинт выше по файлу) остаётся главным, когда наш Ambient выключен
        local function restoreAmbient()
            if t1.value68 then
                Lighting.Ambient = t1.value69
                Lighting.OutdoorAmbient = t1.value69
            else
                Lighting.Ambient = orig.Ambient
                Lighting.OutdoorAmbient = orig.OutdoorAmbient
            end
        end

        RunService.RenderStepped:Connect(function()
            if S.ambient.on then
                if Lighting.Ambient ~= S.ambient.a then Lighting.Ambient = S.ambient.a end
                if Lighting.OutdoorAmbient ~= S.ambient.o then Lighting.OutdoorAmbient = S.ambient.o end
            end
            if S.fog.on and Lighting.FogColor ~= S.fog.c then Lighting.FogColor = S.fog.c end
            if S.time.on and Lighting.ClockTime ~= S.time.v then Lighting.ClockTime = S.time.v end
            if S.bright.on then
                local b = S.bright.v / 10
                if Lighting.Brightness ~= b then Lighting.Brightness = b end
            end
            if S.shadows.on and Lighting.GlobalShadows then Lighting.GlobalShadows = false end
        end)
        task.spawn(function()
            while task.wait(0.5) do pcall(refreshEffects) end -- игра может удалить эффекты
        end)

        local sec = v19

        -- Ambient
        local oAmb = sec:AddToggle({ Name = "Ambient", Flag = "LtAmbient", Option = true, Default = false,
            Callback = function(p)
                S.ambient.on = p
                if not p then restoreAmbient() end
            end }).Option
        oAmb:AddColorPicker({ Name = "Indoor ambient", Flag = "LtAmbientIn", Default = S.ambient.a,
            Callback = function(c) S.ambient.a = c end })
        oAmb:AddColorPicker({ Name = "Outdoor ambient", Flag = "LtAmbientOut", Default = S.ambient.o,
            Callback = function(c) S.ambient.o = c end })

        -- Fog color (FogStart / FogEnd уже есть выше)
        local oFog = sec:AddToggle({ Name = "Fog", Flag = "LtFog", Option = true, Default = false,
            Callback = function(p)
                S.fog.on = p
                if not p then Lighting.FogColor = orig.FogColor end
            end }).Option
        oFog:AddColorPicker({ Name = "Fog color", Flag = "LtFogColor", Default = S.fog.c,
            Callback = function(c) S.fog.c = c end })

        -- Time of day
        local oTime = sec:AddToggle({ Name = "Time of day", Flag = "LtTime", Option = true, Default = false,
            Callback = function(p) S.time.on = p end }).Option
        oTime:AddSlider({ Name = "Clock time (hours)", Flag = "LtTimeV", Min = 0, Max = 24, Default = S.time.v,
            Callback = function(v) S.time.v = v end })

        -- Brightness
        local oBr = sec:AddToggle({ Name = "Brightness", Flag = "LtBright", Option = true, Default = false,
            Callback = function(p)
                S.bright.on = p
                if not p then Lighting.Brightness = orig.Brightness end
            end }).Option
        oBr:AddSlider({ Name = "Level (x0.1)", Flag = "LtBrightV", Min = 0, Max = 100, Default = S.bright.v,
            Callback = function(v) S.bright.v = v end })

        -- Color correction
        local oCc = sec:AddToggle({ Name = "Color correction", Flag = "LtCc", Option = true, Default = false,
            Callback = function(p) S.cc.on = p; pcall(refreshEffects) end }).Option
        oCc:AddSlider({ Name = "Saturation (100 = normal)", Flag = "LtCcSat", Min = 0, Max = 200, Default = S.cc.sat,
            Callback = function(v) S.cc.sat = v; pcall(refreshEffects) end })
        oCc:AddSlider({ Name = "Contrast (100 = normal)", Flag = "LtCcCon", Min = 0, Max = 200, Default = S.cc.con,
            Callback = function(v) S.cc.con = v; pcall(refreshEffects) end })
        oCc:AddColorPicker({ Name = "Tint", Flag = "LtCcTint", Default = S.cc.tint,
            Callback = function(c) S.cc.tint = c; pcall(refreshEffects) end })

        -- Sun rays
        local oSun = sec:AddToggle({ Name = "Sun rays", Flag = "LtSun", Option = true, Default = false,
            Callback = function(p) S.sun.on = p; pcall(refreshEffects) end }).Option
        oSun:AddSlider({ Name = "Intensity", Flag = "LtSunInt", Min = 0, Max = 100, Default = S.sun.int,
            Callback = function(v) S.sun.int = v; pcall(refreshEffects) end })
        oSun:AddSlider({ Name = "Spread", Flag = "LtSunSpr", Min = 0, Max = 100, Default = S.sun.spread,
            Callback = function(v) S.sun.spread = v; pcall(refreshEffects) end })

        -- Atmosphere
        local oAt = sec:AddToggle({ Name = "Atmosphere", Flag = "LtAtmo", Option = true, Default = false,
            Callback = function(p) S.atmo.on = p; pcall(refreshEffects) end }).Option
        oAt:AddSlider({ Name = "Density", Flag = "LtAtmoDens", Min = 0, Max = 100, Default = S.atmo.dens,
            Callback = function(v) S.atmo.dens = v; pcall(refreshEffects) end })
        oAt:AddSlider({ Name = "Haze", Flag = "LtAtmoHaze", Min = 0, Max = 100, Default = S.atmo.haze,
            Callback = function(v) S.atmo.haze = v; pcall(refreshEffects) end })
        oAt:AddColorPicker({ Name = "Atmosphere color", Flag = "LtAtmoCol", Default = S.atmo.col,
            Callback = function(c) S.atmo.col = c; pcall(refreshEffects) end })

        -- Depth of field
        local oDof = sec:AddToggle({ Name = "Depth of field", Flag = "LtDof", Option = true, Default = false,
            Callback = function(p) S.dof.on = p; pcall(refreshEffects) end }).Option
        oDof:AddSlider({ Name = "Far blur", Flag = "LtDofFar", Min = 0, Max = 100, Default = S.dof.far,
            Callback = function(v) S.dof.far = v; pcall(refreshEffects) end })
        oDof:AddSlider({ Name = "Focus distance", Flag = "LtDofFocus", Min = 0, Max = 500, Default = S.dof.focus,
            Callback = function(v) S.dof.focus = v; pcall(refreshEffects) end })
        oDof:AddSlider({ Name = "In-focus radius", Flag = "LtDofRad", Min = 0, Max = 500, Default = S.dof.radius,
            Callback = function(v) S.dof.radius = v; pcall(refreshEffects) end })

        -- No shadows
        sec:AddToggle({ Name = "No shadows", Flag = "LtShadows", Default = false,
            Callback = function(p)
                S.shadows.on = p
                if not p then Lighting.GlobalShadows = orig.GlobalShadows end
            end })
    end)
    if not ok then
        warn("[LIGHTING] " .. tostring(err))
        pcall(function() v11:Notify({ Title = "LIGHTING", Content = "failed: " .. tostring(err), Icon = "x" }) end)
    end
end
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
            cap = new("Line", {Thickness = 2, Visible = false}),
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
        local dist = ((t1.aimOrigin() or cam.CFrame.Position) - hrp.Position).Magnitude
        if dist > (env.EspMaxDist or 1500) then return hide(o) end

        local top = cam:WorldToViewportPoint(head.Position + Vector3.new(0, head.Size.Y / 2 + 0.15, 0))
        local bot = cam:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.1, 0))
        local h = math.abs(bot.Y - top.Y)
        if h < 2 then return hide(o) end
        local w = h * 0.55
        local cx = c3.X
        local x, y = cx - w / 2, top.Y

        if env.FeatureMode == "New" then
            x, y = math.floor(x + 0.5), math.floor(y + 0.5)
            w, h = math.max(2, math.floor(w + 0.5)), math.max(2, math.floor(h + 0.5))
        end
        local boxType = env.EspBoxType or "2D"
        local outline = env.EspOutline ~= false
        local thick = env.EspThickness or 1

        -- 2D box
        local show2d = boxType == "2D"
        o.boxOut.Visible = show2d and outline
        o.cap.Visible = show2d and env.FeatureMode == "New"
        if o.cap.Visible then
            o.cap.From, o.cap.To = Vector2.new(x, y), Vector2.new(x + w, y)
            o.cap.Color, o.cap.Thickness = col.box:Lerp(Color3.new(1, 1, 1), 0.45), thick + 1
        end
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
                        idx = idx + 1
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

                v397.C0 = v397.OriginalC0.Value * CFrame.Angles(1.5707963267948966, 0, 0)

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

    if p76 ~= LocalPlayer.Character then return end
    if t1.moveConnection then t1.moveConnection:Disconnect() end
    t1.moveConnection = t1.value112.RenderStepped:Connect(function(dt)
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
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + dir * (currentBhopSpeed * dt)
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
    if t1.sway then t1.sway:Disconnect() t1.sway = nil end
    if not p77 then
        local hum = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.CameraOffset = Vector3.zero end
        return
    end
    local n3 = 0

    local function v419(p78, p79, p80)
        return p78 + (p79 - p78) * p80
    end

    t1.sway = RunService7.RenderStepped:Connect(function(dt)
        local Humanoid = LocalPlayer2.Character and LocalPlayer2.Character:FindFirstChildOfClass("Humanoid")
        local CurrentCamera = workspace.CurrentCamera
        if not Humanoid or not CurrentCamera then return end
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
    if t1.soulConnection then t1.soulConnection:Disconnect() t1.soulConnection = nil end
    local t9 = _G.SoulParticleEmitters or {}

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
                    local idx = table.find(t9, ParticleEmitter)
                    if idx then table.remove(t9, idx) end

                    if p82 and p82.Parent then
                        p82:Destroy()
                    end
                end)
            end
        end
    end

    if p81 then
        t1.soulConnection = Workspace.ChildAdded:Connect(function(child)
            if child.Name:lower() == "deadbody" then
                v424(child)
            end
        end)
    else
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
    local CFramePosition = t1.aimOrigin()
    if not CFramePosition then return false end
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
    local camera, origin = workspace.CurrentCamera, t1.aimOrigin()
    if not camera or not origin then return false end
    -- Convert the existing pixel radius into a cone around the world-space aim axis.
    local slope = 2 * getgenv().TriggerRadius * math.tan(math.rad(camera.FieldOfView / 2))
        / math.max(camera.ViewportSize.Y, 1)
    local threshold = 1 / math.sqrt(1 + slope * slope)
    for _, name in ipairs({"Head", "UpperTorso", "Torso", "HumanoidRootPart"}) do
        local part = p86:FindFirstChild(name)
        if part then
            local delta = part.Position - origin
            if delta.Magnitude > 0 and camera.CFrame.LookVector:Dot(delta.Unit) >= threshold and t1.value119(part) then
                return true
            end
        end
    end
    return false
end
function t1.value121()
    if mouse1click and pcall(mouse1click) then return end
    if mousebuttonclick and pcall(mousebuttonclick, 1) then return end
    if click then pcall(click) end
end
task.spawn(function()
    while task.wait(0.016) do
        if not t1.knifeBusy and getgenv().TRIGGER_Enabled then
            for _, player in ipairs(t1.value113:GetPlayers()) do
                if player ~= t1.value116 and (player.Character and t1.value118(player)) and t1.value120(player.Character) then
                    t1.value121()
                    break
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
t1.value122.RenderStepped:Connect(function()
    if not t1.value123 then return end
    local char, camera = LocalPlayer3.Character, workspace.CurrentCamera
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and camera then
        local look = camera.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0 then hum:Move(flat.Unit, false) end
    end
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

-- видимость: минимальная толщина в пикселях экрана. раньше линии были 0.04-0.12 stud, на дистанции
-- это меньше пикселя и модели пропадали (видно было только Thunder с широким ореолом)
local kMinPx = 2.4      -- ядро линии, px
local kGlowPx = 5.5     -- ореол, px
local kBallPx = 4.5     -- точки / шарики, px
local kNearCam = 6      -- пуля родилась ближе этого к камере = выстрел от первого лица
local kConverge = 30    -- через сколько stud след сходится с реальной траекторией
local kMuzzle = Vector3.new(1.1, -0.9, -1.8) -- откуда рисуется начало вблизи (в координатах камеры)

local function pxToWorld(pos, px)
    local cam = workspace.CurrentCamera
    local dist = (pos - cam.CFrame.Position).Magnitude
    return dist * px * 2 * math.tan(math.rad(cam.FieldOfView) / 2) / math.max(cam.ViewportSize.Y, 1)
end

local function trailSeg(a, b, w, color, life, base, px)
    local len = (a - b).Magnitude
    if len < 0.01 then return end
    w = math.max(w, pxToWorld((a + b) / 2, px or kMinPx))
    return trailPart(Vector3.new(w, w, len), CFrame.new(a, b) * CFrame.new(0, 0, -len / 2), color, life, base)
end

local function trailBall(pos, size, color, life, base)
    size = math.max(size, pxToWorld(pos, kBallPx))
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
    local white = Color3.new(1, 1, 1)
    trailFrame = trailFrame + 1

    if model == "Thunder" then
        local n = math.max(2, math.floor(len / 1.5))
        local prev = startPos
        for i = 1, n do
            local p = startPos:Lerp(endPos, i / n)
            if i < n then
                p = p + right * (rnd() - 0.5) * 1.4 + up * (rnd() - 0.5) * 1.4
            end
            trailSeg(prev, p, 0.28, color, 0.35, 0.6, kGlowPx)
            trailSeg(prev, p, 0.08, white, 0.35)
            prev = p
        end
    elseif model == "Arrow" then
        trailSeg(startPos, endPos, 0.1, color, 0.9)
        if len > 0.3 then
            local back = -dir * 0.9
            for _, side in ipairs({ right, -right, up, -up }) do
                trailSeg(endPos, endPos + back + side * 0.4, 0.08, color, 0.9)
            end
        end
    elseif model == "Thick Beam" then
        trailSeg(startPos, endPos, 0.35, color, 1.0, 0.45, kGlowPx)
        trailSeg(startPos, endPos, 0.12, white, 1.0)
    elseif model == "Dotted" then
        trailBall(endPos, 0.4, color, 1.4)
    elseif model == "Helix" then
        local a = os.clock() * 25
        local off = right * math.cos(a) * 0.7 + up * math.sin(a) * 0.7
        trailBall(endPos + off, 0.28, color, 1.2)
        trailSeg(startPos, endPos, 0.05, color, 0.8, 0.5)
    elseif model == "DNA" then
        local a = os.clock() * 22
        local off = right * math.cos(a) * 0.7 + up * math.sin(a) * 0.7
        local inv = Color3.new(1 - color.R, 1 - color.G, 1 - color.B)
        trailBall(endPos + off, 0.28, color, 1.2)
        trailBall(endPos - off, 0.28, inv, 1.2)
        if trailFrame % 2 == 0 then
            trailSeg(endPos + off, endPos - off, 0.05, white, 1.0, 0.3)
        end
    elseif model == "Sparks" then
        for _ = 1, 4 do
            local v = Vector3.new(rnd() - 0.5, rnd() - 0.5, rnd() - 0.5) * 1.2
            trailBall(endPos + v, 0.16, rnd() > 0.5 and color or white, 0.5)
        end
        trailSeg(startPos, endPos, 0.06, color, 0.5)
    elseif model == "Rainbow" then
        trailSeg(startPos, endPos, 0.2, Color3.fromHSV((os.clock() * 0.8) % 1, 1, 1), 1.5)
    elseif model == "Fire" then
        local j = Vector3.new(rnd() - 0.5, rnd() - 0.5, rnd() - 0.5) * 0.3
        trailSeg(startPos + j, endPos + j, 0.25, Color3.fromRGB(255, 90, 0), 0.7, 0.35, kGlowPx)
        trailSeg(startPos, endPos, 0.09, Color3.fromRGB(255, 220, 80), 0.7)
        trailBall(endPos + Vector3.new(0, rnd() * 0.6, 0) + j, 0.18, Color3.fromRGB(255, 150, 20), 0.6)
    elseif model == "Rings" then
        if trailFrame % 2 == 0 then
            local ring = trailPart(Vector3.new(0.12, 1.4, 1.4), CFrame.new(endPos, endPos + dir) * CFrame.Angles(0, math.rad(90), 0),
                color, 0.8, 0.3)
            ring.Shape = Enum.PartType.Cylinder
        end
        trailSeg(startPos, endPos, 0.06, color, 0.8)
    elseif model == "Glitch" then
        for _ = 1, 3 do
            local v = Vector3.new(rnd() - 0.5, rnd() - 0.5, rnd() - 0.5) * 1.0
            local sz = math.max(0.15 + rnd() * 0.3, pxToWorld(endPos + v, kBallPx))
            trailPart(Vector3.new(sz, sz, sz * (1 + rnd() * 3)), CFrame.new(endPos + v, endPos + v + dir),
                rnd() > 0.5 and color or Color3.fromHSV(rnd(), 1, 1), 0.4)
        end
        trailSeg(startPos, endPos, 0.06, color, 0.4)
    else
        trailSeg(startPos, endPos, 0.12, color, 1.5)
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

        local origin = child.Position
        local cam = workspace.CurrentCamera
        -- выстрел от первого лица: пуля рождается у самой камеры и линия видна строго с торца (точкой).
        -- смещаем начало следа к "дулу" и плавно сводим на реальную траекторию за kConverge stud
        local off = Vector3.zero
        if cam and (origin - cam.CFrame.Position).Magnitude < kNearCam then
            off = cam.CFrame:PointToWorldSpace(kMuzzle) - origin
        end
        local lastVis = origin + off
        local connection

        connection = RunService.RenderStepped:Connect(function()
            if child and child.Parent then
                local cur = child.Position
                local k = math.max(0, 1 - (cur - origin).Magnitude / kConverge)
                local vis = cur + off * k
                CreateBulletTrail(lastVis, vis, getgenv().BulletTrailColor)
                lastVis = vis
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
        fpsFrames = fpsFrames + 1
        fpsAcc = fpsAcc + dt
        if fpsAcc >= 0.5 then
            fpsText.Text = ("FPS: %d"):format(math.floor(fpsFrames / fpsAcc + 0.5))
            fpsAcc, fpsFrames = 0, 0
        end
    end)
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
            t = t + dt
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
                    it.age = it.age + dt
                    if it.age >= it.life or not it.p.Parent then
                        pcall(function() it.p:Destroy() end)
                        table.remove(plist, i)
                    else
                        it.v = it.v + Vector3.new(0, -it.g * dt, 0)
                        it.p.Position = it.p.Position + it.v * dt
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
                pnt = pnt + cf.RightVector * (math.random() - 0.5) * jag + cf.UpVector * (math.random() - 0.5) * jag
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
        local archivable = char.Archivable
        char.Archivable = true
        local ok, clone = pcall(function() return char:Clone() end)
        char.Archivable = archivable
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
                s.v = s.v + Vector3.new(0, -grav * dt, 0)
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
        if type(name) == "table" then name = name[1] end
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
                    local shot = t1.shotAt[char]
                    mine = shot ~= nil and os.clock() - shot < 1.5
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
        local woven = env.FeatureMode == "New" and env.HatDetail == "Woven"
        local detailed = env.HatDetail == "Detailed" or woven
        local n = detailed and 22 or 6
        local H = R * 0.55
        for i = 1, n do
            local r = R * (1 - (i - 0.5) / n)
            local p = mk(Vector3.new(H / n * 1.15, r * 2, r * 2), CFrame.new(), hatCol, NEON, 0.4)
            p.Shape = Enum.PartType.Cylinder
            hat.discs[#hat.discs + 1] = { p = p, y = (i - 0.5) * H / n, hue = i / n }
        end
        if woven then
            for k = 1, 16 do
                local a = 2 * PI * k / 16
                local edge = Vector3.new(R * math.cos(a), 0, R * math.sin(a))
                local tip = Vector3.new(0, H, 0)
                local axis = CFrame.lookAt((edge + tip) / 2, tip)
                local rib = mk(Vector3.new(0.045, 0.045, (tip - edge).Magnitude), CFrame.new(), hatCol, SMOOTH, 0)
                hat.discs[#hat.discs + 1] = {p = rib, axis = axis, hue = k / 16}
            end
        end
        if detailed then
            for k = 0, 23 do
                local p = mk(Vector3.one * 0.25, CFrame.new(), hatCol, NEON, 0.2, true)
                hat.balls[#hat.balls + 1] = { p = p, ang = k / 24 * 2 * PI, r = R, y = 0.05 }
            end
            local tip = mk(Vector3.one * 0.35, CFrame.new(), Color3.new(1, 1, 1), NEON, 0, true)
            hat.balls[#hat.balls + 1] = { p = tip, ang = 0, r = 0, y = H + 0.1 }
        end
        hat.key = tostring(env.FeatureMode) .. "|" .. tostring(env.HatDetail) .. "|" .. tostring(env.HatSize)
    end

    RunService.RenderStepped:Connect(function(dt)
        if not env.HatEnabled then
            if hat.key then clearHat() end
            return
        end
        local char = lp.Character
        local head = char and char:FindFirstChild("Head")
        if not head then return end
        if hat.key ~= tostring(env.FeatureMode) .. "|" .. tostring(env.HatDetail) .. "|" .. tostring(env.HatSize) then buildHat() end
        if env.HatRotate then hat.rot = hat.rot + dt * 1.5 end
        local base = head.Position + Vector3.new(0, head.Size.Y / 2 + 0.1 + (env.HatHeight or 0) / 10, 0)
        local transp = 1 - (env.HatAlpha or 60) / 100
        for _, d in ipairs(hat.discs) do
            if d.axis then
                d.p.CFrame = CFrame.new(base) * CFrame.Angles(0, hat.rot, 0) * d.axis
            else
                d.p.CFrame = CFrame.new(base + Vector3.new(0, d.y, 0)) * CFrame.Angles(0, hat.rot, PI / 2)
            end
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
            s.t = s.t + dt
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

    do
        local mode = vSettings:AddSection({Position = "left", Name = "FEATURE MODE"})
        mode:AddDropdown({Name = "Mode", Flag = "FeatureMode", Values = {"Old", "New"}, Default = env.FeatureMode,
            Callback = function(v) env.FeatureMode = v end})
        local pulse
        local function slider(sec, key, title, lo, hi)
            sec:AddSlider({Name = title, Flag = key, Min = lo, Max = hi, Default = env[key],
                Callback = function(v) env[key] = math.clamp(v, lo, hi) end})
        end
        pulse = v15:AddSection({Position = "left", Name = "PULSE AIM"})
        pulse:AddToggle({Name = "Pulse aim (New)", Flag = "PulseAim", Default = env.PulseAim,
            Callback = function(v) env.PulseAim = v end})
        slider(pulse, "PulseMin", "Rest angle (degrees)", 1, 85)
        slider(pulse, "PulseMax", "Moving angle (degrees)", 1, 85)
        slider(pulse, "PulseSmooth", "Smoothing (10 ms)", 1, 100)
        slider(pulse, "PulseSpeed", "Full expansion speed (studs/s)", 1, 80)

        local sec = t1.mFx:AddSection({Position = "right", Name = "MOVEMENT TRAILS"})
        sec:AddToggle({Name = "Player trail (New)", Flag = "MotionTrail", Default = env.MotionTrail,
            Callback = function(v) env.MotionTrail = v end})
        sec:AddDropdown({Name = "Detail", Flag = "TrailDetail", Values = {"Simple", "Detailed"}, Default = env.TrailDetail,
            Callback = function(v) env.TrailDetail = v end})
        sec:AddDropdown({Name = "Model", Flag = "TrailShape", Values = {"Ribbon", "Twin", "Cross"}, Default = env.TrailShape,
            Callback = function(v) env.TrailShape = v end})
        sec:AddColorPicker({Name = "Trail color", Flag = "TrailTintPicker", Default = fromHex(env.TrailTint, Color3.new(1,1,1)),
            Callback = function(v) env.TrailTint = toHex(v) end})
        slider(sec, "TrailWidth", "Start width (0.1 studs)", 1, 50)
        slider(sec, "TrailTip", "End width (%)", 0, 100)
        slider(sec, "TrailTime", "Lifetime (0.1 s)", 1, 40)

        local active, owner, signature = {}, nil, nil
        local function strip(root, center, axis, width, tint, detailed)
            local a, b = Instance.new("Attachment"), Instance.new("Attachment")
            a.Position, b.Position = center - axis * width / 2, center + axis * width / 2
            a.Parent, b.Parent = root, root
            local trail = Instance.new("Trail")
            trail.Attachment0, trail.Attachment1 = a, b
            trail.Lifetime = env.TrailTime / 10
            trail.MinLength = 0.025
            trail.WidthScale = NumberSequence.new(1, env.TrailTip / 100)
            trail.Color = ColorSequence.new(detailed and tint:Lerp(Color3.new(1,1,1), 0.65) or tint, tint)
            trail.Transparency = NumberSequence.new(0.12, 1)
            trail.LightEmission = detailed and 1 or 0.4
            trail.Parent = root
            table.insert(active, trail)
            table.insert(active, a)
            table.insert(active, b)
        end
        RunService.Heartbeat:Connect(function()
            local char = lp.Character
            local root = env.FeatureMode == "New" and env.MotionTrail and char and char:FindFirstChild("HumanoidRootPart") or nil
            if not root and not owner then return end
            local key = root and table.concat({env.TrailDetail, env.TrailShape, env.TrailTint, env.TrailWidth, env.TrailTip, env.TrailTime}, "|")
            if root == owner and key == signature then return end
            for _, obj in ipairs(active) do obj:Destroy() end
            table.clear(active)
            owner, signature = root, key
            if not root then return end
            local width = env.TrailWidth / 10
            local color = fromHex(env.TrailTint, Color3.new(1,1,1))
            local detail = env.TrailDetail == "Detailed"
            local origin = Vector3.new(0,-0.5,0.45)
            if env.TrailShape == "Twin" then
                for _, side in ipairs({-1,1}) do
                    strip(root, origin + Vector3.xAxis * side * width / 2, Vector3.yAxis, width / 2, color, detail)
                end
            else
                strip(root, origin, Vector3.xAxis, width, color, detail)
                if env.TrailShape == "Cross" then strip(root, origin, Vector3.yAxis, width, color, detail) end
            end
            if detail then strip(root, origin + Vector3.yAxis * 0.08, Vector3.xAxis, width * 0.12, color:Lerp(Color3.new(1,1,1),0.7), true) end
        end)
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
    sh:AddDropdown({ Name = "Detail", Flag = "HatDetailD", Values = { "Simple", "Detailed", "Woven" }, Default = env.HatDetail,
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
-- CONFIG: кнопка открывает менеджер конфигов (имя, список, Save/Load/Delete, autoload/autosave)
-- THEME: пресеты акцентного цвета + Custom (hue/sat)
-- ============================================================
do
    local Cfg = t1.Cfg
    local Reg = t1.Reg
    local UIS = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local kManagerKey = Enum.KeyCode.K -- открыть/закрыть менеджер конфигов (на телефоне кнопка в SETTINGS)
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

    -- ---------------- окно менеджера (своё, независимое от либы) ----------------
    local C = {
        bg = Color3.fromRGB(20, 20, 22), panel = Color3.fromRGB(32, 32, 36), line = Color3.fromRGB(62, 62, 68),
        text = Color3.fromRGB(235, 235, 240), dim = Color3.fromRGB(140, 140, 150), acc = Color3.fromRGB(255, 77, 109),
        bad = Color3.fromRGB(255, 120, 120), selBg = Color3.fromRGB(52, 34, 40),
    }
    local gui, win, box, statusLbl, list, btnSave, btnLoad, btnDel, btnAuto, btnAsave, btnReset
    local sel, armKey, armT = nil, nil, 0

    local function mk(class, props, parent)
        local o = Instance.new(class)
        for k, v in pairs(props) do o[k] = v end
        if parent then o.Parent = parent end
        return o
    end
    local function round(o, r) mk("UICorner", { CornerRadius = UDim.new(0, r or 6) }, o) end
    local function stroke(o, col) mk("UIStroke", { Color = col or C.line, Thickness = 1 }, o) end

    local function button(text, parent)
        local b = mk("TextButton", {
            Text = text, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text,
            BackgroundColor3 = C.panel, BorderSizePixel = 0, AutoButtonColor = true,
            Size = UDim2.new(1 / 3, -4, 1, 0),
        }, parent)
        round(b, 6)
        stroke(b)
        return b
    end

    local function row(parent, y, h)
        local f = mk("Frame", { BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, y), Size = UDim2.new(1, -24, 0, h) }, parent)
        mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, f)
        return f
    end

    local function say(text, bad)
        if not statusLbl then return end
        statusLbl.Text = text
        statusLbl.TextColor3 = bad and C.bad or C.dim
    end

    local function target()
        local typed = Cfg.clean(box.Text)
        if typed ~= "" then return typed end
        return sel
    end

    -- двойное нажатие: первое взводит кнопку на 4 секунды, второе выполняет
    local function confirm(key, name, btn, base, label)
        local k = key .. ":" .. name
        if armKey == k and os.clock() - armT < 4 then
            armKey = nil
            btn.Text = base
            return true
        end
        armKey, armT = k, os.clock()
        btn.Text = label
        task.delay(4, function()
            if btn.Parent and armKey == k then
                armKey = nil
                btn.Text = base
            end
        end)
        return false
    end

    local rows = {}
    local refresh
    refresh = function()
        table.clear(rows)
        if not list then return end
        for _, ch in ipairs(list:GetChildren()) do
            if ch:IsA("GuiObject") then ch:Destroy() end
        end
        local names = Cfg.list()
        if #names == 0 then
            mk("TextLabel", {
                Text = "no configs yet. type a name and press Save", Font = Enum.Font.Gotham, TextSize = 12,
                TextColor3 = C.dim, BackgroundTransparency = 1, TextWrapped = true, Size = UDim2.new(1, -6, 0, 40),
            }, list)
        end
        for i, n in ipairs(names) do
            local b = mk("TextButton", {
                LayoutOrder = i, Text = "", AutoButtonColor = true, BorderSizePixel = 0,
                BackgroundColor3 = (n == sel) and C.selBg or C.panel, Size = UDim2.new(1, -6, 0, 32),
            }, list)
            round(b, 6)
            local outline = mk("UIStroke", { Color = C.acc, Enabled = n == sel }, b)
            rows[n] = {button = b, outline = outline}
            mk("TextLabel", {
                Text = n, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text, BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -96, 1, 0),
            }, b)
            local tag = ""
            if n == Cfg.Startup then tag = "startup" elseif n == Cfg.Slot then tag = "active" end
            mk("TextLabel", {
                Text = tag, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = C.acc, BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right, Position = UDim2.new(1, -86, 0, 0), Size = UDim2.new(0, 78, 1, 0),
            }, b)
            b.MouseButton1Click:Connect(function()
                local old = rows[sel]
                if old then
                    old.outline.Enabled = false
                    game:GetService("TweenService"):Create(old.button, TweenInfo.new(0.12), {BackgroundColor3 = C.panel}):Play()
                end
                sel, box.Text = n, n
                outline.Enabled = true
                game:GetService("TweenService"):Create(b, TweenInfo.new(0.12), {BackgroundColor3 = C.selBg}):Play()
                btnAuto.Text = "Autoload: " .. (Cfg.Startup == n and "on" or "off")
            end)
        end
        if btnAuto then btnAuto.Text = "Autoload: " .. ((sel and Cfg.Startup == sel) and "on" or "off") end
        if btnAsave then btnAsave.Text = "Autosave: " .. (Cfg.Autosave and "on" or "off") end
    end

    local function build()
        gui = Instance.new("ScreenGui")
        gui.Name = "LT_ConfigManager"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 1000
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local function tryParent(p)
            if not p then return false end
            local ok = pcall(function() gui.Parent = p end)
            return ok and gui.Parent == p
        end
        local placed = false
        pcall(function() if gethui then placed = tryParent(gethui()) end end)
        if not placed then placed = tryParent(game:GetService("CoreGui")) end
        if not placed then placed = tryParent(Players.LocalPlayer:WaitForChild("PlayerGui")) end

        win = mk("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 360, 0.9, 0),
            BackgroundColor3 = C.bg, BorderSizePixel = 0, Active = true,
        }, gui)
        mk("UISizeConstraint", { MinSize = Vector2.new(280, 320), MaxSize = Vector2.new(360, 480) }, win)
        mk("UIScale", {Name = "OpenScale", Scale = 1}, win)
        round(win, 12)
        stroke(win)

        -- шапка + перетаскивание
        mk("TextLabel", {
            Text = "Configuration manager", Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = C.text, BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0, 14, 0, 0), Size = UDim2.new(1, -60, 0, 38),
        }, win)
        local drag = mk("Frame", { BackgroundTransparency = 1, Active = true, Size = UDim2.new(1, -50, 0, 38) }, win)
        local close = mk("TextButton", {
            Text = "x", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.text, BackgroundColor3 = C.panel,
            BorderSizePixel = 0, Position = UDim2.new(1, -40, 0, 5), Size = UDim2.new(0, 30, 0, 28),
        }, win)
        round(close, 6)
        close.MouseButton1Click:Connect(function() gui.Enabled = false end)

        local dragging, dStart, wStart = false, nil, nil
        drag.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging, dStart, wStart = true, i.Position, win.Position
                t1.configDragInput = i
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i == t1.configDragInput then dragging = false t1.configDragInput = nil end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - dStart
                win.Position = UDim2.new(wStart.X.Scale, wStart.X.Offset + d.X, wStart.Y.Scale, wStart.Y.Offset + d.Y)
            end
        end)

        -- имя конфига
        box = mk("TextBox", {
            Text = "", PlaceholderText = "config name", PlaceholderColor3 = C.dim, ClearTextOnFocus = false,
            Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = C.text, BackgroundColor3 = C.panel, BorderSizePixel = 0,
            TextXAlignment = Enum.TextXAlignment.Left, Position = UDim2.new(0, 12, 0, 44), Size = UDim2.new(1, -24, 0, 34),
        }, win)
        round(box, 6)
        stroke(box)
        mk("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, box)

        local r1 = row(win, 84, 34)
        local create = button("Create", r1)
        create.BackgroundColor3 = C.selBg
        create.MouseButton1Click:Connect(function()
            local name = Cfg.clean(box.Text)
            if name == "" then box:CaptureFocus() say("Enter a config name", true) return end
            if Cfg.exists(name) then say("This name already exists", true) return end
            local ok, saved = Cfg.save(name)
            if not ok then say(tostring(saved), true) return end
            sel, box.Text = saved, saved
            say("Created «" .. saved .. "»")
            refresh()
        end)
        btnSave = button("Save", r1)
        btnLoad = button("Load", r1)
        btnDel = button("Delete", r1)
        for i, b in ipairs({create, btnSave, btnLoad, btnDel}) do
            b.LayoutOrder = i
            b.Size = UDim2.new(0.25, -5, 1, 0)
        end

        statusLbl = mk("TextLabel", {
            Text = "pick a config or type a new name", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = C.dim,
            BackgroundTransparency = 1, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top, Position = UDim2.new(0, 14, 0, 124), Size = UDim2.new(1, -28, 0, 30),
        }, win)

        list = mk("ScrollingFrame", {
            BackgroundColor3 = C.bg, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = C.line,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ElasticBehavior = Enum.ElasticBehavior.Never,
            Position = UDim2.new(0, 12, 0, 158), Size = UDim2.new(1, -24, 1, -158 - 52),
        }, win)
        mk("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, list)

        local r2 = row(win, 0, 32)
        r2.Position = UDim2.new(0, 12, 1, -42)
        btnAuto = button("Autoload: off", r2)
        btnAsave = button("Autosave: off", r2)
        btnReset = button("Reset values", r2)
        btnAuto.TextSize, btnAsave.TextSize, btnReset.TextSize = 11, 11, 11

        -- Save: новое имя создаёт, существующее перезаписывает после второго нажатия
        btnSave.MouseButton1Click:Connect(function()
            local name = target()
            if not name or name == "" then say("type a name (or tap a config) first", true) return end
            if Cfg.exists(name) and not confirm("save", name, btnSave, "Save", "Overwrite?") then
                say("«" .. name .. "» already exists. tap Save again to overwrite it", true)
                return
            end
            local ok, saved, count = Cfg.save(name)
            if ok then
                sel = saved
                box.Text = saved
                say("saved «" .. saved .. "» (" .. tostring(count) .. " settings)")
                refresh()
            else
                say("save failed: " .. tostring(saved) .. " (executor without writefile?)", true)
            end
        end)

        btnLoad.MouseButton1Click:Connect(function()
            local name = target()
            if not name or name == "" then say("pick or type a config first", true) return end
            if not Cfg.exists(name) then say("no config named «" .. name .. "»", true) return end
            say("loading «" .. name .. "»...")
            task.spawn(function()
                local ok, n = Cfg.load(name)
                if ok then
                    sel = name
                    box.Text = name
                    if t1.applyTheme then pcall(t1.applyTheme) end
                    say("loaded «" .. name .. "»: " .. tostring(n) .. " settings changed")
                    refresh()
                else
                    say("«" .. name .. "» is unreadable", true)
                end
            end)
        end)

        btnDel.MouseButton1Click:Connect(function()
            local name = target()
            if not name or name == "" or not Cfg.exists(name) then say("pick a saved config first", true) return end
            if not confirm("del", name, btnDel, "Delete", "Sure?") then
                say("tap Delete again to remove «" .. name .. "»", true)
                return
            end
            if Cfg.delete(name) then
                if sel == name then sel = nil end
                box.Text = ""
                say("deleted «" .. name .. "»")
                refresh()
            else
                say("could not delete «" .. name .. "»", true)
            end
        end)

        btnAuto.MouseButton1Click:Connect(function()
            local name = sel or target()
            if not name or not Cfg.exists(name) then say("pick a saved config first", true) return end
            Cfg.Startup = (Cfg.Startup ~= name) and name or nil
            Cfg.saveMeta()
            say(Cfg.Startup and ("«" .. name .. "» loads on every start") or "autoload off")
            refresh()
        end)

        btnAsave.MouseButton1Click:Connect(function()
            if not Cfg.Autosave and not (Cfg.Slot and Cfg.exists(Cfg.Slot)) then
                say("save or load a config first. autosave rewrites the active one", true)
                return
            end
            Cfg.Autosave = not Cfg.Autosave
            Cfg.saveMeta()
            say(Cfg.Autosave and ("autosave on: «" .. tostring(Cfg.Slot) .. "» rewrites every 2s when something changes") or "autosave off")
            refresh()
        end)

        btnReset.MouseButton1Click:Connect(function()
            if not confirm("reset", "all", btnReset, "Reset values", "Sure?") then
                say("tap again to reset every value to default (nothing is saved)", true)
                return
            end
            task.spawn(function()
                Cfg.resetValues()
                if t1.applyTheme then pcall(t1.applyTheme) end
                say("values reset. press Save to keep them")
            end)
        end)
    end

    function t1.toggleCfgManager()
        local first = gui == nil
        if first then
            local ok, err = pcall(build)
            if not ok then
                gui = nil
                note("manager failed: " .. tostring(err), "x")
                return
            end
            sel = Cfg.Slot
            if sel then box.Text = sel end
        else
            gui.Enabled = not gui.Enabled
        end
        if gui.Enabled then
            refresh()
            win.OpenScale.Scale = 0.96
            game:GetService("TweenService"):Create(win.OpenScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end
    end

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == kManagerKey then t1.toggleCfgManager() end
    end)

    -- ---------------- CONFIG (SETTINGS tab) ----------------
    local left = vSettings:AddSection({ Position = "left", Name = "CONFIG" })
    left:AddToggle({Name = "Auto Refresh (60s)", Flag = "AutoRefreshEnabled", Default = getgenv().AutoRefreshEnabled,
        Callback = function(on)
            getgenv().AutoRefreshEnabled = on
            t1.refreshAt = os.clock() + 60
        end})
    t1.refreshAt = os.clock() + 60
    function t1.refreshFeatures()
        local reg = t1.Reg
        for i, flag in ipairs(reg.order) do
            if not getgenv().AutoRefreshEnabled then break end
            local r = reg.byFlag[flag]
            if r.kind == "toggle" and r.cb and flag ~= "AutoRefreshEnabled" and reg.get(r) == true then
                if flag == "NightModee" then
                    local bloom = t1.value50:FindFirstChild("NightBloom")
                    t1.value51(bloom and bloom.Size or reg.get(reg.byFlag.NightBloomSize),
                        bloom and bloom.Intensity or reg.get(reg.byFlag.NightBloomIntensity))
                else
                    local ok, err = pcall(r.cb, true)
                    if not ok then warn("Refresh " .. flag .. ": " .. tostring(err)) end
                end
            end
            if i % 12 == 0 then task.wait() end
        end
    end
    addButton(left, "Open config manager (K)", function() t1.toggleCfgManager() end)

    -- ---------------- THEME (WindUI) ----------------
    local right = vSettings:AddSection({ Position = "right", Name = "THEME" })
    local WindUI = t1.WindUI
    local themes = {}
    pcall(function()
        for name in pairs(WindUI:GetThemes()) do themes[#themes + 1] = name end
    end)
    table.sort(themes)
    if #themes == 0 then themes = { "Dark", "Light" } end
    local curTheme
    pcall(function() curTheme = WindUI:GetCurrentTheme() end)
    if getgenv().Theme and table.find(themes, getgenv().Theme) then curTheme = getgenv().Theme end
    if not (curTheme and table.find(themes, curTheme)) then curTheme = themes[1] end

    function t1.applyTheme()
        local th = getgenv().Theme
        if th and table.find(themes, th) then pcall(function() WindUI:SetTheme(th) end) end
    end
    right:AddDropdown({
        Name = "Theme",
        Flag = "ThemeName",
        Values = themes,
        Default = curTheme,
        Callback = function(p)
            getgenv().Theme = p
            t1.applyTheme()
        end
    })
end

-- ============================================================
-- [CONFIG] финал: когда меню построено, применяем startup-конфиг вживую (flags через реестр)
-- ============================================================
task.spawn(function()
    task.wait(1.5)
    local Reg, Cfg = t1.Reg, t1.Cfg
    pcall(Cfg.finish)
    local setter = Reg.probe()
    local msg
    if Reg.hooked == 0 then
        msg = "widget hook failed: configs only restore legacy keys"
    elseif setter then
        msg = #Reg.order .. " settings tracked, live apply via :" .. setter .. "()"
    else
        msg = #Reg.order .. " settings tracked, no setter found: effects apply, widgets refresh after re-execute"
    end
    pcall(function() v11:Notify({ Title = "CONFIG", Content = msg, Icon = setter and "check" or "x" }) end)
end)