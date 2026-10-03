local Library = loadfile("beanhac.club/libs/linoria.luau")()

local Window = Library:CreateWindow({
    Title = "beanhac.club | Phantom Forces",
    Center = true, AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Legit = Window:AddTab("Legit") do
    local AimBox = Legit:AddLeftTabbox() do
        local Aimbot = AimBox:AddTab("Aimbot") do
            Aimbot:AddToggle("Legit/Aimbot/Enabled", {Text = "Enabled"})
                :AddKeyPicker("Legit/Aimbot/Keybind", {Default = "MB2", Mode = "Hold", Text = "Aimbot"})
    
            Aimbot:AddSlider("Legit/Aimbot/Smoothness", {Text = "Smoothness", Min = 0, Max = 100, Default = 50, Rounding = 0, Suffix = "%"})
            Aimbot:AddDropdown("Legit/Aimbot/Hitbox", {Text = "Hitbox", Values = {"Head", "Torso", "Arms", "Legs"}, Default = 1, Multi = true})
            Aimbot:AddDropdown("Legit/Aimbot/Scan", {Text = "Scan Mode", Values = {"Autowall", "Visible", "None"}, Default = 1})
            
            Aimbot:AddToggle("Legit/Aimbot/FOV/Enabled", {Text = "Use FOV", Default = true})
            Aimbot:AddToggle("Legit/Aimbot/FOV/Draw", {Text = "Draw FOV", Default = true})
                :AddColorPicker("Legit/Aimbot/FOV/Colour", {Default = Color3.new(1, 0.3, 0.3), Title = "Aimbot FOV Colour", Transparency = 0.5})
            Aimbot:AddSlider("Legit/Aimbot/FOV/Size", {Text = "FOV Size", Min = 0, Max = 100, Default = 10, Rounding = 1, Suffix = "°"})
        end

        local Silent = AimBox:AddTab("Silent Aim") do
            Silent:AddToggle("Legit/Silent/Enabled", {Text = "Enabled"})
                :AddKeyPicker("Legit/Silent/Keybind", {Default = "MB3", Mode = "Toggle", Text = "Silent Aim"})
            Silent:AddToggle("Legit/Silent/Auto", {Text = "Autoshoot"})

            Silent:AddToggle("Legit/Silent/Hitchance/Enabled", {Text = "Use Hitchance", Default = true})
            Silent:AddSlider("Legit/Silent/Hitchance/Value", {Text = "Hitchance", Min = 0, Max = 100, Default = 50, Rounding = 0, Suffix = "%"})

            Silent:AddDropdown("Legit/Silent/Hitbox", {Text = "Hitbox", Values = {"Head", "Torso", "Arms", "Legs"}, Default = 1, Multi = true})
            Silent:AddDropdown("Legit/Silent/Scan", {Text = "Scan Mode", Values = {"Autowall", "Visible", "None"}, Default = 1})
            
            Silent:AddToggle("Legit/Silent/FOV/Enabled", {Text = "Use FOV", Default = true})
            Silent:AddToggle("Legit/Silent/FOV/Draw", {Text = "Draw FOV", Default = true})
                :AddColorPicker("Legit/Silent/FOV/Colour", {Default = Color3.new(0.3, 0.3, 1), Title = "Silent FOV Colour", Transparency = 0.5})
            Silent:AddSlider("Legit/Silent/FOV/Size", {Text = "FOV Size", Min = 0, Max = 100, Default = 5, Rounding = 1, Suffix = "°"})    
        end
    end

    local Mods = Legit:AddLeftGroupbox("Weapon Mods") do
        Mods:AddToggle("Legit/Mods/Recoil/Enabled", {Text = "Recoil Modifier"})
        Mods:AddSlider("Legit/Mods/Recoil/Value", {Text = "Recoil Multiplier", Min = 0, Max = 100, Default = 100, Rounding = 0, Suffix = "%"})

        Mods:AddToggle("Legit/Mods/Spread/Enabled", {Text = "Spread Modifier"})
        Mods:AddSlider("Legit/Mods/Spread/Value", {Text = "Spread Multiplier", Min = 0, Max = 100, Default = 100, Rounding = 0, Suffix = "%"})

        Mods:AddToggle("Legit/Mods/Firerate/Enabled", {Text = "Firerate Modifier"})
        Mods:AddSlider("Legit/Mods/Firerate/Value", {Text = "Firerate Multiplier", Min = 100, Max = 200, Default = 100, Rounding = 0, Suffix = "%"})

        Mods:AddToggle("Legit/Mods/Reload", {Text = "Instant Reload"})
        Mods:AddToggle("Legit/Mods/GunSway", {Text = "No Gun Sway"})
        Mods:AddToggle("Legit/Mods/WalkSway", {Text = "No Walk Sway"})
    end

    local Settings = Legit:AddRightGroupbox("Settings") do
        Settings:AddToggle("Legit/Settings/Movement", {Text = "Movement Prediction", Default = true})
        Settings:AddToggle("Legit/Settings/Bullet", {Text = "Bullet Drop Compensation", Default = true})
        
        Settings:AddToggle("Legit/Settings/Barrel", {Text = "Attach FOV to Barrel"})
        Settings:AddSlider("Legit/Settings/Offset", {Text = "FOV Barrel Offset", Min = 0, Max = 20, Default = 0, Rounding = 1, Suffix = "st"})
    
        Settings:AddToggle("Legit/Settings/Prediction", {Text = "Use Prediction for Scanning"})
        Settings:AddDropdown("Legit/Settings/Origin", {Text = "Scan Origin", Values = {"Mouse", "Barrel"}, Default = 1})
        Settings:AddDropdown("Legit/Settings/Priority", {Text = "Target Priority", Values = {"Closest to Mouse", "Closest to Player"}, Default = 1})

        Settings:AddDivider()

        Settings:AddToggle("Legit/Settings/Aimbot/Deadzone", {Text = "Aimbot Deadzone"})
        Settings:AddToggle("Legit/Settings/Aimbot/Deadzone/Draw", {Text = "Draw Deadzone"})
            :AddColorPicker("Legit/Settings/Aimbot/Deadzone/Colour", {Default = Color3.new(0.5, 0.3, 0.3), Title = "Aimbot Deadzone Colour", Transparency = 0.5})
        Settings:AddSlider("Legit/Settings/Aimbot/Deadzone/Size", {Text = "Deadzone Size", Min = 0, Max = 20, Default = 3, Rounding = 0, Suffix = "°"})
        
        Settings:AddToggle("Legit/Settings/Silent/Deadzone", {Text = "Silent Deadzone"})
        Settings:AddToggle("Legit/Settings/Silent/Deadzone/Draw", {Text = "Draw Deadzone"})
            :AddColorPicker("Legit/Settings/Silent/Deadzone/Colour", {Default = Color3.new(0.3, 0.3, 0.5), Title = "Silent Deadzone Colour", Transparency = 0.5})
        Settings:AddSlider("Legit/Settings/Silent/Deadzone/Size", {Text = "Deadzone Size", Min = 0, Max = 20, Default = 1.5, Rounding = 0, Suffix = "°"})
    end
end

local Rage = Window:AddTab("Rage") do
    local Ragebox = Rage:AddLeftTabbox() do
        local Ragebot = Ragebox:AddTab("Ragebot") do
            Ragebot:AddToggle("Rage/Ragebot/Enabled", {Text = "Enabled"})
                :AddKeyPicker("Rage/Ragebot/Keybind", {Default = "X", Mode = "Toggle", Text = "Ragebot"})
            Ragebot:AddToggle("Rage/Ragebot/Force", {Text = "Force Head"})
            Ragebot:AddDropdown("Rage/Ragebot/Hitbox", {Text = "Hitbox", Values = {"Head", "Torso", "Arms", "Legs"}, Default = {"Head", "Torso"}, Multi = true})
            Ragebot:AddSlider("Rage/Ragebot/Scanning/Origin", {Text = "Origin Scan", Min = 1, Max = 10, Default = 5, Rounding = 1, Suffix = "st"})
            Ragebot:AddSlider("Rage/Ragebot/Scanning/Target", {Text = "Target Scan", Min = 1, Max = 10, Default = 5, Rounding = 1, Suffix = "st"})
        end

        local Hitlogs = Ragebox:AddTab("Hitlogs") do end
    end
    
    local AntiAim = Rage:AddRightGroupbox("Anti-Aim") do end
    local Knifebot = Rage:AddLeftGroupbox("Knifebot") do end
    local Logs = Rage:AddRightGroupbox("Logs") do end
end

local Visuals = Window:AddTab("Visuals") do
    local PlayerBox = Visuals:AddLeftTabbox() do
        local Player = PlayerBox:AddTab("Player") do
            Player:AddToggle("Visuals/Player/Enabled", {Text = "Enabled"})
                :AddKeyPicker("Visuals/Player/Keybind", {Default = "None", Mode = "Always", NoUI = true})
                
            Player:AddToggle("Visuals/Player/Box", {Text = "Bounding Box"})
                :AddColorPicker("Visuals/Player/Box/Colour", {Default = Color3.new(1, 1, 1), Title = "Bounding Box Colour", Transparency = 0.5})

            Player:AddToggle("Visuals/Player/Healthbar", {Text = "Healthbar"})
                :AddColorPicker("Visuals/Player/Healthbar/Healthy", {Default = Color3.new(0.3, 1, 0.3), Title = "Healthbar Healthy Colour"})
                :AddColorPicker("Visuals/Player/Healthbar/Critical", {Default = Color3.new(1, 0.3, 0.3), Title = "Healthbar Critical Colour"})

            Player:AddToggle("Visuals/Player/Chams", {Text = "Chams"})
                :AddColorPicker("Visuals/Player/Chams/Fill", {Default = Color3.new(1, 1, 1), Title = "Chams Fill Colour", Transparency = 0.5})
                :AddColorPicker("Visuals/Player/Chams/Outline", {Default = Color3.new(1, 1, 1), Title = "Chams Outline Colour", Transparency = 0})

            Player:AddToggle("Visuals/Player/Name", {Text = "Name"})
                :AddColorPicker("Visuals/Player/Name/Colour", {Default = Color3.new(1, 1, 1), Title = "Name Colour"})

            Player:AddToggle("Visuals/Player/Weapon", {Text = "Weapon"})
                :AddColorPicker("Visuals/Player/Weapon/Colour", {Default = Color3.new(1, 1, 1), Title = "Weapon Colour"})

            Player:AddToggle("Visuals/Player/Health", {Text = "Health"})
                :AddColorPicker("Visuals/Player/Health/Colour", {Default = Color3.new(1, 1, 1), Title = "Health Colour"})

            Player:AddToggle("Visuals/Player/Distance", {Text = "Distance"})
                :AddColorPicker("Visuals/Player/Distance/Colour", {Default = Color3.new(1, 1, 1), Title = "Distance Colour"})
        end

        local Options = PlayerBox:AddTab("Options") do
            Options:AddToggle("Visuals/Player/Occluded", {Text = "Chams Occluded Only"})
            Options:AddToggle("Visuals/Player/Highlight", {Text = "Target Highlight"})
            :AddColorPicker("Visuals/Player/Highlight/Colour", {Default = Color3.new(1, 0.6, 0.3), Title = "Highlight Colour"})
            
            Options:AddDropdown("Visuals/Player/Elements", {Text = "Highlight Elements", Values = {"Bounding Box", "Chams", "Name", "Weapon", "Health", "Distance"}, Default = 1, Multi = true})
            Options:AddDropdown("Visuals/Player/Priority", {Text = "Highlight Priority", Values = {"Aimbot", "Silent", "Ragebot"}, Default = 1})
        end
    end

    local Materials = {} do
        for _, Material in Enum.Material:GetEnumItems() do table.insert(Materials, Material.Name) end
        table.sort(Materials, function(a,b) return a < b end)
    end

    local LocalBox = Visuals:AddRightTabbox() do
        local Local = LocalBox:AddTab("Local") do
            Local:AddToggle("Visuals/Local/Weapon/Enabled", {Text = "Weapon Chams"})
                :AddColorPicker("Visuals/Local/Weapon/Colour", {Default = Color3.new(1, 1, 1), Title = "Weapon Colour", Transparency = 0.5})
            Local:AddDropdown("Visuals/Local/Weapon/Material", {Text = "Weapon Material", Values = Materials, Default = "Neon"})
            
            Local:AddToggle("Visuals/Local/Arms/Enabled", {Text = "Arm Chams"})
                :AddColorPicker("Visuals/Local/Arms/Colour", {Default = Color3.new(1, 1, 1), Title = "Arm Colour", Transparency = 0})
            Local:AddDropdown("Visuals/Local/Arms/Material", {Text = "Arm Material", Values = Materials, Default = "ForceField"})

            Local:AddToggle("Visuals/Local/Player/Enabled", {Text = "LocalPlayer Chams"})
                :AddColorPicker("Visuals/Local/Player/Colour", {Default = Color3.new(1, 1, 1), Title = "LocalPlayer Colour", Transparency = 0})
            Local:AddDropdown("Visuals/Local/Player/Material", {Text = "LocalPlayer Material", Values = Materials, Default = "ForceField"})

            Local:AddDivider()

            Local:AddToggle("Visuals/Local/Viewmodel/Enabled", {Text = "Viewmodel Offset"})
            Local:AddSlider("Visuals/Local/Viewmodel/X", {Text = "X", Min = -10, Max = 10, Default = 0, Rounding = 1, Suffix = "st"})
            Local:AddSlider("Visuals/Local/Viewmodel/Y", {Text = "Y", Min = -10, Max = 10, Default = 0, Rounding = 1, Suffix = "st"})
            Local:AddSlider("Visuals/Local/Viewmodel/Z", {Text = "Z", Min = -10, Max = 10, Default = 0, Rounding = 1, Suffix = "st"})
        
            Local:AddSlider("Visuals/Local/Viewmodel/Pitch", {Text = "Pitch", Min = -90, Max = 90, Default = 0, Rounding = 0, Suffix = "°"})
            Local:AddSlider("Visuals/Local/Viewmodel/Yaw", {Text = "Yaw", Min = -90, Max = 90, Default = 0, Rounding = 0, Suffix = "°"})
            Local:AddSlider("Visuals/Local/Viewmodel/Roll", {Text = "Roll", Min = -90, Max = 90, Default = 0, Rounding = 0, Suffix = "°"})
        end

        local Camera = LocalBox:AddTab("Camera") do
            Camera:AddToggle("Visuals/Camera/Thirdperson/Enabled", {Text = "Thirdperson"})
                :AddKeyPicker("Visuals/Camera/Thirdperson/Keybind", {Default = "B", Mode = "Toggle", Text = "Thirdperson"})
            Camera:AddToggle("Visuals/Camera/Thirdperson/Hide", {Text = "Hide Viewmodel"})

            Camera:AddLabel("Thirdperson Offset")
            Camera:AddSlider("Visuals/Camera/Thirdperson/X", {Text = "X", Min = -10, Max = 10, Default = 0, Rounding = 1, Suffix = "st"})
            Camera:AddSlider("Visuals/Camera/Thirdperson/Y", {Text = "Y", Min = -10, Max = 10, Default = 0, Rounding = 1, Suffix = "st"})
            Camera:AddSlider("Visuals/Camera/Thirdperson/Z", {Text = "Z", Min = -10, Max = 10, Default = 0, Rounding = 1, Suffix = "st"})

            Camera:AddDivider()
            
            Camera:AddToggle("Visuals/Camera/FOV/Enabled", {Text = "Force FOV"})
            Camera:AddToggle("Visuals/Camera/FOV/Ignore", {Text = "Ignore on Blackscopes"})
            Camera:AddSlider("Visuals/Camera/FOV/Value", {Text = "FOV", Min = 1, Max = 120, Default = 100, Rounding = 0, Suffix = "°"})
            Camera:AddSlider("Visuals/Camera/FOV/ADS", {Text = "ADS FOV", Min = 1, Max = 120, Default = 60, Rounding = 0, Suffix = "°"})
        end
    end

    local World = Visuals:AddLeftGroupbox("World") do
        World:AddToggle("Visuals/World/Ambient/Enabled", {Text = "Ambient"})
            :AddColorPicker("Visuals/World/Ambient/Colour", {Default = Color3.new(1, 1, 1), Title = "Ambient Colour"})
        World:AddToggle("Visuals/World/Color/Enabled", {Text = "ColorShift"})
            :AddColorPicker("Visuals/World/Color/Colour", {Default = Color3.new(1, 1, 1), Title = "ColorShift Colour"})
        World:AddToggle("Visuals/World/Clocktime/Enabled", {Text = "Clocktime"})
        World:AddSlider("Visuals/World/Clocktime/Value", {Text = "Time", Min = 0, Max = 24, Default = 0, Rounding = 0, Suffix = "hr"})

        World:AddToggle("Visuals/World/Tracer/Enabled", {Text = "Bullet Tracers"})
            :AddColorPicker("Visuals/World/Tracer/Colour", {Default = Color3.new(1, 1, 1), Title = "Tracer Colour", Transparency = 0.5})
        World:AddSlider("Visuals/World/Tracer/Lifetime", {Text = "Tracer Lifetime", Min = 0.1, Max = 5, Default = 1.5, Rounding = 1, Suffix = "s"})

        World:AddToggle("Visuals/World/Grenade/Enabled", {Text = "Grenade Indicator"})
            :AddColorPicker("Visuals/World/Grenade/Colour", {Default = Color3.new(1, 1, 1), Title = "Grenade Indicator Colour", Transparency = 0})
        World:AddToggle("Visuals/World/Grenade/Damage", {Text = "Grenade Damage"})
            :AddColorPicker("Visuals/World/Grenade/Damage/Lethal", {Default = Color3.new(1, 0.3, 0.3), Title = "Grenade Lethal Colour"})
            :AddColorPicker("Visuals/World/Grenade/Damage/NonLethal", {Default = Color3.new(1, 1, 0.3), Title = "Grenade Non-Lethal Colour"})
        World:AddToggle("Visuals/World/Grenade/Trail/Enabled", {Text = "Grenade Trail"})
            :AddColorPicker("Visuals/World/Grenade/Trail/Colour", {Default = Color3.new(1, 1, 1), Title = "Grenade Trail Colour", Transparency = 0.5})
    end

    local Removals = Visuals:AddLeftGroupbox("Removals") do
        Removals:AddToggle("Visuals/Removal/Sleeves", {Text = "No Sleeves"})
        Removals:AddToggle("Visuals/Removal/Accessory", {Text = "No Accessories"})
        Removals:AddToggle("Visuals/Removal/Scope", {Text = "Scope Overlay"})
        Removals:AddToggle("Visuals/Removal/Suppression", {Text = "Suppression"})
        Removals:AddToggle("Visuals/Removal/Bob", {Text = "Viewbob"})
        Removals:AddToggle("Visuals/Removal/Textures", {Text = "Map Textures", Tooltip = "Will reset when new map loads"})
    end

    local Crosshair = Visuals:AddRightGroupbox("Crosshair") do
        Crosshair:AddToggle("Visuals/Crosshair/Enabled", {Text = "Enabled"})
            :AddColorPicker("Visuals/Crosshair/Colour", {Default = Color3.new(1, 1, 1), Title = "Crosshair Colour", Transparency = 0})
            :AddColorPicker("Visuals/Crosshair/Outline", {Default = Color3.new(), Title = "Crosshair Outline Colour", Transparency = 0.5})
        Crosshair:AddToggle("Visuals/Crosshair/Game", {Text = "Hide In-game Crosshair"})
        Crosshair:AddToggle("Visuals/Crosshair/Barrel", {Text = "Attach to Barrel", Tooltip = "Uses FOV barrel offset"})
        Crosshair:AddToggle("Visuals/Crosshair/Target", {Text = "On Target"})

        Crosshair:AddSlider("Visuals/Crosshair/Size", {Text = "Size", Min = 1, Max = 20, Default = 5, Rounding = 0, Suffix = "px"})
        Crosshair:AddSlider("Visuals/Crosshair/Gap", {Text = "Gap", Min = 1, Max = 10, Default = 5, Rounding = 0, Suffix = "px"})
        Crosshair:AddSlider("Visuals/Crosshair/Thickness", {Text = "Thickness", Min = 1, Max = 4, Default = 2, Rounding = 0, Suffix = "px"})
        Crosshair:AddSlider("Visuals/Crosshair/Rotation", {Text = "Rotation", Min = -90, Max = 90, Default = 0, Rounding = 0, Suffix = "°"})
    end
end

local Misc = Window:AddTab("Miscellaneous") do
    local Movement = Misc:AddLeftGroupbox("Movement") do
        --Movement:AddToggle("Misc/Movement/Bypass", {Text = "Speed Bypass"})
        Movement:AddToggle("Misc/Movement/Walkspeed", {Text = "Walkspeed"})
            :AddKeyPicker("Misc/Movement/Walkspeed/Keybind", {Default = "LeftAlt", Mode = "Toggle", Text = "Walkspeed"})
        Movement:AddSlider("Misc/Movement/Walkspeed/Value", {Text = "Walkspeed", Min = 16, Max = 100, Default = 16, Rounding = 0})
        
        Movement:AddToggle("Misc/Movement/Bunnyhop", {Text = "Bunnyhop"})
            :AddKeyPicker("Misc/Movement/Bunnyhop/Keybind", {Default = "Z", Mode = "Toggle", Text = "Bunnyhop"})
        Movement:AddToggle("Misc/Movement/Stamina", {Text = "Infinite Stamina"})
        Movement:AddToggle("Misc/Movement/Cooldown", {Text = "No Slide/Dive Cooldown"})
    end
end

local Settings = Window:AddTab("Settings") do
    local Menu = Settings:AddLeftGroupbox("Menu") do
        Menu:AddToggle("KeybindList", {Text = "Keybinds List", Callback = function(Value)
            Library.KeybindFrame.Visible = Value
        end})
        
        Menu:AddToggle("Watermark", {Text = "Watermark"})
        Menu:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {Default = "Insert", Mode = "Toggle", NoUI = true})
        Library.ToggleKeybind = Options.MenuKeybind

        Menu:AddButton("Unload", function()
            Library:Unload()
        end)
    end

    local Config = Settings:AddRightGroupbox("Config") do
        makefolder("beanhac.club/configs/pf")

        local function RefreshList()
            local Names = {}

            for _, Path in listfiles("beanhac.club/configs/pf") do
                table.insert(Names, Path:match("([^\\]+)%.lua$"))
            end

            return Names
        end

        local ConfigList = Config:AddDropdown("ConfigList", {Text = "Config List", Values = RefreshList(), AllowNull = true})
        local ConfigName = Config:AddInput("ConfigName", {Text = "Config Name"})

        function Create(Name)
            local Result = ""
            for Flag, Data in Toggles do
                Result ..= ('["%s"]={Value=%s},'):format(Flag, tostring(Data.Value))
            end

            for Flag, Data in Options do
                if Flag == "ConfigList" or Flag == "ConfigName" then continue end

                if Data.Type == "ColorPicker" then
                    Result ..= ('["%s"]={Value=%s,Transparency=%s},'):format(Flag, `Color3.new({Data.Value.R},{Data.Value.G},{Data.Value.B})`, Data.Transparency)
                elseif Data.Type == "KeyPicker" then
                    Result ..= ('["%s"]={Value="%s",Mode="%s"},'):format(Flag, Data.Value, Data.Mode)
                elseif Data.Type == "Slider" then
                    Result ..= ('["%s"]={Value=%s},'):format(Flag, Data.Value)
                elseif Data.Type == "Dropdown" then
                    if Data.Multi then
                        local Values = ""
                        for Value in Data.Value do
                            Values ..= '["'..Value..'"]=true,'
                        end
                        Result ..= ('["%s"]={Value=%s},'):format(Flag, `\{{Values}}`)
                    else
                        Result ..= ('["%s"]={Value=%s},'):format(Flag, '"'..tostring(Data.Value)..'"')
                    end
                    
                elseif Data.Type == "Input" then
                    Result ..= ('["%s"]={Value=%s},'):format(Flag, Data.Value)
                end
            end

            writefile("beanhac.club/configs/pf/"..Name..".lua", "return {"..Result.."}")
        end

        Config:AddButton("Create", function()
            local Name = Options["ConfigName"].Value:gsub(" ", "")
            if Name == "" then
                return Library:Notify("Config name cannot be empty!", 2)
            end

            local Success, Error = pcall(Create, Name)
            if not Success then
                return Library:Notify("Failed to save config: "..Error)
            end

            Library:Notify("Created config "..Name)

            ConfigList:SetValues(RefreshList())
            ConfigList:SetValue(nil)
            ConfigName:SetValue("")
        end):AddButton("Delete", function()
            local Path = "beanhac.club/configs/pf/"..Options["ConfigList"].Value..".lua"
            if not isfile(Path) then
                return Library:Notify("Config doesn't exist!", 2)
            end

            local Success, Error = pcall(function()
                delfile(Path)
            end)

            if not Success then
                return Library:Notify("Failed to delete config: "..Error)
            end

            Library:Notify("Deleted config "..Options["ConfigList"].Value)
            ConfigList:SetValues(RefreshList())
            ConfigList:SetValue(nil)
        end)

        Config:AddButton("Load", function()
            local Path = "beanhac.club/configs/pf/"..Options["ConfigList"].Value..".lua"
            if not isfile(Path) then
                return Library:Notify("Config doesn't exist!", 2)
            end

            local Values = loadfile(Path)()

            local Success, Error = pcall(function()
                for Flag, Data in Values do
                    local Toggle = Toggles[Flag]
                    if Toggle then
                        Toggle:SetValue(Data.Value)
                    end

                    local Option = Options[Flag]
                    if Option then
                        if Data.Value == nil then continue end

                        if Option.Type == "ColorPicker" then
                            Option:SetValueRGB(Data.Value, Data.Transparency)
                        elseif Option.Type == "KeyPicker" then
                            Option:SetValue({Data.Value, Data.Mode})
                        else
                            Option:SetValue(Data.Value)
                        end
                    end
                end
            end)
            
            if not Success then
                return Library:Notify("Failed to load config: "..Error)
            end

            Library:Notify("Loaded config "..Options["ConfigList"].Value)
            ConfigList:SetValue(nil)
        end):AddButton("Overwrite", function()
            local Success, Error = pcall(Create, Options["ConfigList"].Value)
            if not Success then
                return Library:Notify("Failed to overwrite config: "..Error)
            end

            Library:Notify("Overwrote config "..Options["ConfigList"].Value)

            ConfigList:SetValues(RefreshList())
            ConfigList:SetValue(nil)
        end)

        Config:AddButton("Refresh List", function()
            ConfigList:SetValues(RefreshList())
        end)
    end
end


local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60
local Name = game:GetService("Players").LocalPlayer.Name

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end

    if Toggles["Watermark"].Value then
        Library:SetWatermark(('beanhac.club private | %s | %sfps | %sms | %s'):format(
            Name,
            math.floor(FPS),
            math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()),
            os.date("%H:%M:%S")
        ))
    else
        Library:SetWatermarkVisibility(false)
    end
end)

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
end)

Library:Notify("Loaded beanhac.club for Phantom Forces")

return Library