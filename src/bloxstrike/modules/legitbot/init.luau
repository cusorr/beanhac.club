local Module = {}

local Workspace: Workspace = cloneref(game:GetService("Workspace"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local Players: Players = cloneref(game:GetService("Players"))

local Client = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

function Module.Init()
    local Circle = Drawing.new("Circle")
    Circle.ZIndex = 21
    
    local Outline = Drawing.new("Circle")
    Outline.ZIndex = 20
    Outline.Thickness = 3

    Module.Visuals = {Circle=Circle, Outline=Outline}
end

function Module.GetClosest(FOV, Hitboxes)
    local Max, Target = FOV, nil

    for _, Player in Players:GetPlayers() do
        if Player == Client then
            continue
        end

        if Player:GetAttribute("Team") == Client:GetAttribute("Team") then
            continue
        end

        local Character = Player.Character
        if not Character then
            continue
        end

        for Hitbox in Module.GetBodyparts(Hitboxes) do
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

function Module.CalculateFOV(Degree)
    return math.tan(math.rad(Degree / 2)) * (Camera.ViewportSize.X / 2) / math.tan(math.rad(Camera.FieldOfView / 2))
end

function Module.GetBodyparts(Hitboxes)
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

function Module.UpdateVisuals()
    local Circle, Outline = Module.Visuals.Circle, Module.Visuals.Outline

    Circle.Position = UserInputService:GetMouseLocation()
    Circle.Radius = Module.CalculateFOV(Options["Legitbot/FOV"].Value)
    Circle.Color = Options["Legit/Visualize/Color"].Value
    Circle.Visible = Toggles["Legit/Visualize"].Value

    Outline.Position = Circle.Position
    Outline.Radius = Circle.Radius
    Outline.Visible = Circle.Visible
end

function Module.Update()
    if
        Toggles["Legitbot/Enabled"].Value and
        Options["Legitbot/Keybind"]:GetState() and
        not Toggles["Legitbot/Silent"].Value
    then
        local Target = Module.GetClosest(
            Module.CalculateFOV(Options["Legitbot/FOV"].Value),
            Options["Legitbot/Hitbox"].Value
        )

        if Target then
            local Delta = Target.ScreenPosition - UserInputService:GetMouseLocation()
            local Smoothing = 1 - Options["Legitbot/Smoothing"].Value / 100

            mousemoverel(Delta.X * Smoothing, Delta.Y * Smoothing)
        end
    end

    Module.UpdateVisuals()
end

return Module