local Module = {}

local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

local ReplicationInterface = shared.require("ReplicationInterface")

local Aimbot, Silent, Rage

function Module.Init()
    Aimbot = shared.Fetch("aimbot")
    Silent = shared.Fetch("silent")
    Rage = shared.Fetch("rage")

    Module.Cache = {}
    Module.Gradient = readfile("beanhac.club/assets/img/gradient.png")
    Module.Storage = Instance.new("Folder", game.CoreGui)

    Players.PlayerAdded:Connect(Module.Add)
    Players.PlayerRemoving:Connect(Module.Remove)

    for _, Player in Players:GetPlayers() do
        if Player == Players.LocalPlayer then continue end
        Module.Add(Player)
    end
end

function Module.Drawing(Class, Properties)
    local Object = Drawing.new(Class)

    for i,v in Properties do
        Object[i] = v
    end

    return Object
end

function Module.Add(Player)
    local Cache = {
        Box = Module.Drawing("Square", {ZIndex = 3}),
        BoxInner = Module.Drawing("Square", {ZIndex = 2}),
        BoxOuter = Module.Drawing("Square", {ZIndex = 2}),
        BoxFill = Module.Drawing("Image", {ZIndex = 1, Data = Module.Gradient}),

        Healthbar = Module.Drawing("Square", {ZIndex = 2, Filled = true}),
        HealthbarGradient = Module.Drawing("Image", {ZIndex = 3, Data = Module.Gradient}),
        HealthbarOuter = Module.Drawing("Square", {ZIndex = 1, Filled = true}),
        
        Name = Module.Drawing("Text", {ZIndex = 5, Center = true, Font = shared.Fonts.Tahoma, Size = 13}),
        NameOutline = Module.Drawing("Text", {ZIndex = 4, Center = true, Font = shared.Fonts.Tahoma, Size = 13}),
        
        Weapon = Module.Drawing("Text", {ZIndex = 4, Outline = true, Center = true, Font = shared.Fonts.SmallestPixel, Size = 10}),
        Distance = Module.Drawing("Text", {ZIndex = 4, Outline = true, Center = true, Font = shared.Fonts.SmallestPixel, Size = 10}),
        Health = Module.Drawing("Text", {ZIndex = 4, Outline = true, Font = shared.Fonts.SmallestPixel, Size = 10}),

        Cham = Instance.new("Highlight", Module.Storage),
    }

    Module.Cache[Player] = Cache
end

function Module.Toggle(Player, Value)
    local Cache = Module.Cache[Player]
    if not Cache then return end

    for _, DrawObject in Cache do
        if isrenderobj(DrawObject) then
            DrawObject.Visible = Value or false
        else
            DrawObject.Enabled = Value or false
        end
    end
end

function Module.Remove(Player)
    local Cache = Module.Cache[Player]
    if not Cache then return end

    for _, DrawObject in Cache do
        if isrenderobj(DrawObject) then
            DrawObject:Remove()
        else
            DrawObject:Destroy()
        end
    end
end

-- test shit idk
function Module.OnScreen(Position: Vector3): boolean
    if not Position then return false end

    local Direction = (Position - Camera.CFrame.Position).Unit
    local Depth = Direction:Dot(Camera.CFrame.LookVector)
    if Depth <= 0 then return false end

    local VFoV = math.tan(math.rad(Camera.FieldOfView / 2))
    local HFoV = VFoV * (Camera.ViewportSize.X / Camera.ViewportSize.Y)

    local VPlane = math.abs(Direction:Dot(Camera.CFrame.UpVector) / Depth)
    local HPlane = math.abs(Direction:Dot(Camera.CFrame.RightVector) / Depth)

    return VPlane < VFoV and HPlane < HFoV
end

function Module.CalculateBounds(ThirdPersonObject)
    local MinX, MinY = math.huge, math.huge
    local MaxX, MaxY = -math.huge, -math.huge

    for Part: BasePart, Size: Vector3 in ThirdPersonObject._partSizes do
        if not Module.OnScreen(Part.Position) then MinX = math.huge break end

        for X = -1, 1, 2 do
            for Y = -1, 1, 2 do
                for Z = -1, 1, 2 do
                    local Offset = Vector3.new(X, Y, Z)
                    local ScreenPosition = Camera:WorldToViewportPoint(Part.CFrame:PointToWorldSpace(Offset * Size / 2))
                    
                    if ScreenPosition.X < MinX then MinX = ScreenPosition.X end
                    if ScreenPosition.Y < MinY then MinY = ScreenPosition.Y end
                    if ScreenPosition.X > MaxX then MaxX = ScreenPosition.X end
                    if ScreenPosition.Y > MaxY then MaxY = ScreenPosition.Y end
                end
            end
        end
    end

    if MinX == math.huge then
        return
    end

    return {
        Position = Vector2.new(MinX, MinY):Abs(),
        Size = Vector2.new(MaxX - MinX, MaxY - MinY):Abs()
    }
end

function Module.GetTarget()
    local TargetPriority = Options["Visuals/Player/Priority"].Value
    if TargetPriority == "Silent" then
        return Silent.Target or Aimbot.Target or Rage.Target
    elseif TargetPriority == "Ragebot" then
        return Rage.Target or Silent.Target or Aimbot.Target
    end

    return Aimbot.Target or Silent.Target or Rage.Target
end

function Module.RotateVector(Vector, Radians)
    local Cosine, Sine = math.cos(Radians), math.cos(Radians)
    return Vector2.new(Vector.X * Cosine - Vector.Y * Sine, Vector.X * Sine + Vector.Y * Cosine)
end

function Module.Update()
    ReplicationInterface.operateOnAllEntries(function(Player, Entry)
        local Cache = Module.Cache[Player]
        if
            not Toggles["Visuals/Player/Enabled"].Value or
            not Options["Visuals/Player/Keybind"]:GetState() or
            not Entry:isAlive() or
            not Entry:isEnemy()
        then
            return Module.Toggle(Player, false)
        end

        local ThirdPersonObject = Entry:getThirdPersonObject()
        local CharacterModel = ThirdPersonObject and ThirdPersonObject:getCharacterModel()
        if
            not CharacterModel or
            CharacterModel.Parent == nil
        then
            return Module.Toggle(Player, false)
        end

        local Bounds = Module.CalculateBounds(ThirdPersonObject)
        if not Bounds then
            return Module.Toggle(Player, false)
        end

        local Target = Module.GetTarget()
        local IsTarget = Toggles["Visuals/Player/Highlight"].Value and Target and Target.Player == Player
        local TargetColour = Options["Visuals/Player/Highlight/Colour"].Value
        local Elements = Options["Visuals/Player/Elements"].Value

        local Box, BoxInner, BoxOuter, BoxFill = Cache.Box, Cache.BoxInner, Cache.BoxOuter, Cache.BoxFill do
            Box.Visible = Toggles["Visuals/Player/Box"].Value
            Box.Size = Bounds.Size
            Box.Color = Options["Visuals/Player/Box/Colour"].Value
            Box.Position = Bounds.Position

            BoxInner.Visible = Box.Visible
            BoxInner.Size = Box.Size - Vector2.new(2, 2)
            BoxInner.Position = Box.Position + Vector2.new(1, 1)

            BoxOuter.Visible = Box.Visible
            BoxOuter.Size = Box.Size + Vector2.new(2, 2)
            BoxOuter.Position = Box.Position - Vector2.new(1, 1)

            BoxFill.Visible = Box.Visible
            BoxFill.Color = Box.Color
            BoxFill.Transparency = 1 - Options["Visuals/Player/Box/Colour"].Transparency
            BoxFill.Size = Bounds.Size
            BoxFill.Position = Bounds.Position

            if IsTarget and Elements["Bounding Box"] then
                Box.Color = TargetColour
                BoxFill.Color = TargetColour
            end
        end

        local PlayerHealth, PlayerMaxHealth = Entry:getHealth()
        local Ratio = PlayerHealth / PlayerMaxHealth
        local InverseRatio = 1 - Ratio

        local Healthbar, HealthbarGradient, HealthbarOuter = Cache.Healthbar, Cache.HealthbarGradient, Cache.HealthbarOuter do
            Healthbar.Visible = Toggles["Visuals/Player/Healthbar"].Value
            Healthbar.Color = Options["Visuals/Player/Healthbar/Healthy"].Value:Lerp(Options["Visuals/Player/Healthbar/Critical"].Value, InverseRatio)
            Healthbar.Size = Vector2.new(1, Box.Size.Y * Ratio)
            Healthbar.Position = Box.Position + Vector2.new(-2, Box.Size.Y * InverseRatio)

            HealthbarGradient.Visible = Healthbar.Visible
            HealthbarGradient.Color = Options["Visuals/Player/Healthbar/Critical"].Value
            HealthbarGradient.Size = Healthbar.Size
            HealthbarGradient.Position = Healthbar.Position

            HealthbarOuter.Visible = Healthbar.Visible
            HealthbarOuter.Size = Vector2.new(3, Box.Size.Y + 2)
            HealthbarOuter.Position = Box.Position - Vector2.new(3, 1)
        end

        local WeaponObject = Entry:getWeaponObject()
        local Name, NameOutline, Weapon = Cache.Name, Cache.NameOutline,Cache.Weapon do
            Name.Visible = Toggles["Visuals/Player/Name"].Value
            Name.Color = Options["Visuals/Player/Name/Colour"].Value
            Name.Text = Player.Name
            Name.Position = Box.Position + Vector2.new(Box.Size.X / 2, -Name.TextBounds.Y - 1)

            NameOutline.Visible = Name.Visible
            NameOutline.Text = Player.Name
            NameOutline.Position = Name.Position + Vector2.one

            Weapon.Visible = Toggles["Visuals/Player/Weapon"].Value
            Weapon.Color = Options["Visuals/Player/Weapon/Colour"].Value
            Weapon.Text = WeaponObject.weaponName
            Weapon.Position = Box.Position + Vector2.new(Box.Size.X / 2, Box.Size.Y + 1)

            if IsTarget and Elements.Name then
                Name.Color = TargetColour
            end
            if IsTarget and Elements.Weapon then
                Weapon.Color = TargetColour
            end
        end

        local Cham = Cache.Cham do
            Cham.Enabled = Toggles["Visuals/Player/Chams"].Value
            Cham.Adornee = CharacterModel
            Cham.DepthMode = Toggles["Visuals/Player/Occluded"].Value and 1 or 0

            Cham.FillColor = Options["Visuals/Player/Chams/Fill"].Value
            Cham.FillTransparency = Options["Visuals/Player/Chams/Fill"].Transparency

            Cham.OutlineColor = Options["Visuals/Player/Chams/Outline"].Value
            Cham.OutlineTransparency = Options["Visuals/Player/Chams/Outline"].Transparency

            if IsTarget and Elements.Chams then
                Cham.FillColor = TargetColour
                Cham.OutlineColor = TargetColour
            end
        end

        local Health, Distance = Cache.Health, Cache.Distance do
            Health.Visible = Toggles["Visuals/Player/Health"].Value
            Health.Color = Options["Visuals/Player/Health/Colour"].Value
            Health.Text = math.floor(PlayerHealth).."HP"
            Health.Position = Box.Position - Vector2.new(Health.TextBounds.X + (Healthbar.Visible and 3 or 0), 2)

            Distance.Visible = Toggles["Visuals/Player/Distance"].Value
            Distance.Color = Options["Visuals/Player/Distance/Colour"].Value
            Distance.Text = string.format("%.1fst", (Camera.CFrame.Position - Entry:getPosition()).Magnitude)
            Distance.Position = Vector2.new(Weapon.Position.X, Weapon.Position.Y + (Weapon.Visible and 10 or 0))

            if IsTarget and Elements.Health then
                Health.Color = TargetColour
            end
            if IsTarget and Elements.Distance then
                Distance.Color = TargetColour
            end
        end
    end)
end

function Module.Cleanup()
    for _, Player in Players:GetPlayers() do
        Module.Remove(Player)
    end

    Module.Storage:Destroy()
end

return Module