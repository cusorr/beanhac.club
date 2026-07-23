local ReplicatedStorage: ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Players: Players = cloneref(game:GetService("Players"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local RunService: RunService = cloneref(game:GetService("RunService"))

local Camera = workspace.CurrentCamera
local Client = Players.LocalPlayer
local Remotes = require(ReplicatedStorage.Database.Security.Remotes)

local Library = loadfile("beanhac.club/libs/linoria.luau")()
local HookManager = loadfile("beanhac.club/libs/hookmanager.luau")()
local Storage = Instance.new("Folder", game.CoreGui)

local ESPCache = {}
local Utility = {} do
	Utility.GetClosest = function(FOV, Hitboxes)
		local Max, Target = FOV, nil

        for _, Player in Players:GetPlayers() do
            if Player == Client then
                continue
            end

            if Player:GetAttribute("Team") == Client:GetAttribute("Team") then
                continue
            end

            local Character = Player.Character
            if not Character or Character.Parent == nil then
                continue
            end

            for Hitbox in Utility.FormatHitboxes(Hitboxes) do
                local Bodypart = Character:FindFirstChild(Hitbox)
                if not Bodypart then
                    continue
                end

                local ScreenPosition = Camera:WorldToViewportPoint(Bodypart.Position)
                local Magnitude = (UserInputService:GetMouseLocation() - Vector2.new(ScreenPosition.X, ScreenPosition.Y)).Magnitude
                
                if Magnitude > Max then
                    continue
                end

                Max, Target = Magnitude, {
                    Position = Bodypart.Position,
                    ScreenPosition = Vector2.new(ScreenPosition.X, ScreenPosition.Y),
                    Bodypart = Bodypart,
                    Player = Player
                }
            end
        end

		return Target
	end

    Utility.FormatHitboxes = function(Hitboxes)
        return {
            Head = Hitboxes.Head,
            UpperTorso = Hitboxes.Chest,
            LowerTorso = Hitboxes.Stomach,
            LeftUpperArm = Hitboxes.Arms,
            LeftLowerArm = Hitboxes.Arms,
            RightUpperArm = Hitboxes.Arms,
            RightLowerArm = Hitboxes.Arms,
            LeftUpperLeg = Hitboxes.Legs,
            LeftLowerLeg = Hitboxes.Legs,
            RightUpperLeg = Hitboxes.Legs,
            RightLowerLeg = Hitboxes.Legs,
        }
    end

    Utility.CreateESP = function(Player)
        ESPCache[Player] = Instance.new("Highlight", Storage)
    end

    Utility.RemoveESP = function(Player)
        ESPCache[Player]:Destroy()
    end

    Utility.CalculateFOV = function(Degree)
        return math.tan(math.rad(Degree / 2)) * (Camera.ViewportSize.X / 2) / math.tan(math.rad(Camera.FieldOfView / 2))
    end
end

Players.PlayerAdded:Connect(Utility.CreateESP)
Players.PlayerRemoving:Connect(Utility.RemoveESP)
for _, Player in Players:GetPlayers() do
    if Player == Client then continue end
    Utility.CreateESP(Player)
end

--[[local NewWeapon
NewWeapon = HookManager:Create(WeaponComponent.new, function(...)
    return NewWeapon(... )
end)]]

local ShootWeapon
ShootWeapon = HookManager:CreateHook(Remotes.Inventory.ShootWeapon.Send, function(Data)
	local Target = Toggles["Ragebot"].Value and Options["Ragebot/Keybind"]:GetState() and Utility.GetClosest(
        math.huge,
        {Head = true}
    )
	if Target then
		for _, Bullet in Data.Bullets do
			Bullet.Direction = (Bullet.Origin - Target.Position).Unit
			
			for _, Hit in Bullet.Hits do
				Hit.Instance = Target.Bodypart
				Hit.Position = Target.Position
			end
        end
	end

	return ShootWeapon(Data)
end)

do
    local Window = Library:CreateWindow({
        Title = "beanhac.club | BloxStrike",
        Center = true,
		AutoShow = true,
        TabPadding = 8,
        MenuFadeTime = 0.2
    })

	local Legit = Window:AddTab("Legit") do
        local Legitbot = Legit:AddLeftGroupbox("Legitbot") do
            Legitbot:AddToggle("Legitbot/Enabled", {Text = "Enabled"})
                :AddKeyPicker("Legitbot/Keybind", {Text = "Legitbot", Default = "MB2", Mode = "Hold"})
            
            Legitbot:AddToggle("Legitbot/Silent", {Text = "Silent"})
            Legitbot:AddDropdown("Legitbot/Conditions", {Text = "Conditions", Values = {"Through Walls", "Through Smokes", "While Blind", "While In Air", "Only While Scoped"}, Multi = true, AllowNull = true})
            Legitbot:AddDropdown("Legitbot/Hitbox", {Text = "Hitboxes", Values = {"Head", "Chest", "Stomach", "Arms", "Legs"}, Multi = true, Default = 1})
            
            Legitbot:AddToggle("Legit/Visualize", {Text = "Visualize Field Of View"})
                :AddColorPicker("Legit/Visualize/Color", {Text = "Field Of View", Default = Color3.new(1, 1, 1)})
            Legitbot:AddSlider("Legitbot/FOV", {Text = "Field Of View", Max = 30, Min = 0, Default = 5, Rounding = 1, Suffix = "°"})
            
            Legitbot:AddSlider("Legitbot/Smoothing", {Text = "Smoothing", Max = 100, Min = 0, Default = 50, Rounding = 0, Suffix = "%"})
            Legitbot:AddSlider("Legitbot/Reaction", {Text = "Reaction Time", Max = 500, Min = 0, Default = 200, Rounding = 0, Suffix = "ms"})
            Legitbot:AddSlider("Legitbot/Switch", {Text = "Target Switch Delay", Max = 500, Min = 0, Default = 200, Rounding = 0, Suffix = "ms"})
            Legitbot:AddToggle("Legitbot/Delay", {Text = "First Bullet Delay"})

            Legitbot:AddToggle("Legitbot/Recoil", {Text = "Recoil Control"})
            Legitbot:AddSlider("Legitbot/Recoil/Start", {Text = "Start Bullet", Max = 30, Min = 0, Default = 1, Rounding = 0})
            Legitbot:AddSlider("Legitbot/Recoil/Horizontal", {Text = "Horizontal", Max = 100, Min = 0, Default = 50, Rounding = 0, Suffix = "%"})
            Legitbot:AddSlider("Legitbot/Recoil/Vertical", {Text = "Vertical", Max = 100, Min = 0, Default = 50, Rounding = 0, Suffix = "%"})
            
            Legitbot:AddToggle("Legitbot/AutoScope", {Text = "Auto Scope"})
        end

        local Triggerbot = Legit:AddRightGroupbox("Triggerbot") do
            Triggerbot:AddToggle("Triggerbot/Enabled", {Text = "Enabled"})
                :AddKeyPicker("Triggerbot/Keybind", {Text = "Triggerbot", Default = "LeftAlt", Mode = "Toggle"})
            Triggerbot:AddDropdown("Triggerbot/Conditions", {Text = "Conditions", Values = {"Through Walls", "Through Smokes", "While Blind", "While In Air", "Only While Scoped"}, Multi = true, AllowNull = true})
            Triggerbot:AddDropdown("Triggerbot/Hitbox", {Text = "Hitboxes", Values = {"Head", "Chest", "Stomach", "Arms", "Legs"}, Multi = true, Default = 1})
            Triggerbot:AddSlider("Triggerbot/Hitchance", {Text = "Hitchance", Max = 100, Min = 0, Default = 50, Rounding = 0, Suffix = "%"})
            Triggerbot:AddSlider("Triggerbot/MinDamage", {Text = "Min Damage", Max = 100, Min = 1, Default = 0, Rounding = 0, Suffix = "hp"})
            Triggerbot:AddSlider("Triggerbot/Reaction", {Text = "Reaction Time", Max = 500, Min = 0, Default = 200, Rounding = 0, Suffix = "ms"})
            Triggerbot:AddSlider("Triggerbot/Burst", {Text = "Burst Time", Max = 500, Min = 50, Default = 50, Rounding = 0, Suffix = "ms"})
            Triggerbot:AddToggle("Triggerbot/AutoScope", {Text = "Auto Scope"})
        end

        local Other = Legit:AddRightGroupbox("Other") do
            Other:AddToggle("Other/AutoPistol", {Text = "Auto Pistol"})
            Other:AddSlider("Other/AutoPistol/Interval", {Text = "Interval", Max = 350, Min = 0, Default = 0, Rounding = 0, Suffix = "ms"})
            Other:AddToggle("Other/Recoil", {Text = "Standalone Recoil Control"})
            Other:AddSlider("Other/Recoil/Start", {Text = "Start Bullet", Max = 30, Min = 0, Default = 1, Rounding = 0})
            Other:AddSlider("Other/Recoil/Horizontal", {Text = "Horizontal", Max = 100, Min = 0, Default = 50, Rounding = 0, Suffix = "%"})
            Other:AddSlider("Other/Recoil/Vertical", {Text = "Vertical", Max = 100, Min = 0, Default = 50, Rounding = 0, Suffix = "%"})
        end
	end

	local Rage = Window:AddTab("Rage") do
        local Ragebot = Rage:AddLeftGroupbox("Ragebot") do
            Ragebot:AddToggle("Ragebot", {Text = "Enabled"})
                :AddKeyPicker("Ragebot/Keybind", {Text = "Ragebot", Default = "X", Mode = "Toggle"})
        end
	end

	local Visuals = Window:AddTab("Visuals") do
		local Player = Visuals:AddLeftGroupbox("Player") do
            Player:AddToggle("Player/Enabled", {Text = "Enabled"})
        end
	end

	local Misc = Window:AddTab("Miscellaneous") do

	end

	local Settings = Window:AddTab("Settings") do
        --local ThemeManager = loadfile("beanhac.club/libs/thememgr.luau")()
        --local SaveManager = loadfile("beanhac.club/libs/savemgr.luau")()

		local Menu = Settings:AddLeftGroupbox("Menu") do
            Menu:AddToggle("KeybindList", {Text = "Keybinds", Callback = function(Value)
                Library.KeybindFrame.Visible = Value
            end})
            
            Menu:AddToggle("Watermark", {Text = "Watermark"})
            Menu:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {Default = "Insert", Mode = "Toggle", NoUI = true})
            Library.ToggleKeybind = Options.MenuKeybind

            Menu:AddButton("Unload", function()
                Library:Unload()
            end)
        end
	end
end

local Circle = Drawing.new("Circle")
Circle.Position = Camera.ViewportSize / 2

Library:Connect(RunService.RenderStepped:Connect(function()
    Circle.Radius = Utility.CalculateFOV(Options["Legitbot/FOV"].Value)
    Circle.Color = Options["Legit/Visualize/Color"].Value
    Circle.Visible = Toggles["Legit/Visualize"].Value

    for _, Player in Players:GetPlayers() do
        if Player == Client then
            continue
        end

        local Highlight = ESPCache[Player]
        if Player:GetAttribute("Team") == Client:GetAttribute("Team") then
            Highlight.Enabled = false
            continue
        end

        local Character = Player.Character
        if not Character or Character.Parent == nil then
            Highlight.Enabled = false
            continue
        end

        
        Highlight.Enabled = Toggles["Player/Enabled"].Value
        Highlight.Adornee = Character
    end

    if Toggles["Legitbot/Enabled"].Value and Options["Legitbot/Keybind"]:GetState() and not Toggles["Legitbot/Silent"].Value then
        local Target = Utility.GetClosest(
            Utility.CalculateFOV(Options["Legitbot/FOV"].Value),
            Options["Legitbot/Hitbox"].Value
        )

        if Target then
            local Delta = Target.ScreenPosition - UserInputService:GetMouseLocation()
            local Smoothing = 1 - Options["Legitbot/Smoothing"].Value / 100

            mousemoverel(Delta.X * Smoothing, Delta.Y * Smoothing)
        end
    end
end))

Library.OnUnload = function()
    Storage:Destroy()
    HookManager:RestoreHooks()
    cleardrawcache()
end