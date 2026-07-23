local Library = loadfile("beanhac.club/libs/linoria.luau")()
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

return Library