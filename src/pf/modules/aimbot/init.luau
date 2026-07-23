local Module = {}

local ReplicationInterface = shared.require("ReplicationInterface")
local CharacterInterface = shared.require("CharacterInterface")
local WeaponControllerInterface = shared.require("WeaponControllerInterface")
local PublicSettings = shared.require("PublicSettings")
local BulletCheck = shared.require("BulletCheck")
local Raycast = shared.require("Raycast")

local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local BulletAcceleration = PublicSettings.bulletAcceleration
local IgnoreList = {workspace.Terrain, workspace.Ignore, workspace.CurrentCamera, workspace.Players}
local IgnoreFunction = function(i) return not i.CanCollide or i.Transparency == 1 end
local Target

function Module.Init()
    local Circle = Drawing.new("Circle")
    Circle.ZIndex = 102

    local Outline = Drawing.new("Circle")
    Outline.ZIndex = 101
    Outline.Thickness = 3

    local Fill = Drawing.new("Image")
    Fill.ZIndex = 100
    Fill.Data = readfile("beanhac.club/assets/img/gradient.png")
    Fill.Rounding = 1024

    Module.Render = {Circle = Circle, Outline = Outline, Fill = Fill}
end

function Module.GetTarget(FOV, Hitboxes, Scan)
    local Target = nil
    local Max = FOV

    ReplicationInterface.operateOnAllEntries(function(Player, Entry)
        if not Entry:isAlive() or not Entry:isEnemy() then return end

        local ThirdPersonObject = Entry:getThirdPersonObject()
        local CharacterModel = ThirdPersonObject and ThirdPersonObject:getCharacterModel()
        if not CharacterModel or CharacterModel.Parent == nil then return end

        local WeaponController = WeaponControllerInterface:getActiveWeaponController()
        local Weapon = WeaponController and WeaponController:getActiveWeapon()
        if not Weapon or Weapon:getWeaponType() ~= "Firearm" then return end

        local CharacterHash = ThirdPersonObject:getCharacterHash()
        local BulletSpeed = Weapon:getWeaponStat("bulletspeed")
        local TravelTime = (Camera.CFrame.Position - Entry:getPosition()).Magnitude / BulletSpeed
        
        local Origin = UserInputService:GetMouseLocation()
        local Magnitude = 0

        if Options["Legit/Settings/Priority"].Value == "Closest to Mouse" then
            if Options["Legit/Settings/Origin"].Value == "Barrel" then
                local BarrelCFrame = Weapon:getBarrelCFrame()
                local OriginVector = Camera:WorldToViewportPoint(BarrelCFrame.Position + BarrelCFrame.LookVector * Options["Legit/Settings/Offset"].Value)
                
                Origin = Vector2.new(OriginVector.X, OriginVector.Y)
            end
        else
            Magnitude = (Camera.CFrame.Position - Entry:getPosition()).Magnitude
            if Magnitude > Max then
                return
            end
        end

        for Hitbox in {Head = Hitboxes.Head, Torso = Hitboxes.Torso, ["Left Arm"] = Hitboxes.Arms, ["Right Arm"] = Hitboxes.Arms, ["Left Leg"] = Hitboxes.Legs, ["Right Leg"] = Hitboxes.Legs} do
            local Bodypart = CharacterHash[Hitbox]
            local Position = Bodypart.Position

            if Toggles["Legit/Settings/Movement"].Value then Position += Entry._velspring.t * TravelTime end
            if Toggles["Legit/Settings/Bullet"].Value then Position += 0.5 * -BulletAcceleration * TravelTime^2 end

            local ScreenVector = Camera:WorldToViewportPoint(Position)
            local ScreenPosition = Vector2.new(ScreenVector.X, ScreenVector.Y)

            if Options["Legit/Settings/Priority"].Value == "Closest to Mouse" then
                Magnitude = (Origin - ScreenPosition).Magnitude
                if Magnitude > Max then
                    continue
                end
            end
            
            local TargetPosition = Toggles["Legit/Settings/Prediction"].Value and Position or Bodypart.Position
            local BulletOrigin = Camera.CFrame.Position
            local BulletVelocity = (TargetPosition - BulletOrigin).Unit * BulletSpeed

            local IsValid = true
            if Scan == "Autowall" then
                IsValid = BulletCheck(BulletOrigin, TargetPosition, BulletVelocity, BulletAcceleration, Weapon:getWeaponStat("penetrationdepth"))
            elseif Scan == "Visible" then
                IsValid = Raycast.raycast(BulletOrigin, Position - BulletOrigin, IgnoreList, IgnoreFunction) == nil
            end

            if IsValid then
                Max, Target = Magnitude, {
                    Player = Player,
                    BodyPart = Bodypart,
                    Position = TargetPosition,
                    ScreenPosition = ScreenPosition,
                }
            end
        end
    end)

    return Target
end

function Module.CalculateDegree(Degree)
    return math.tan(math.rad(Degree / 2)) * (Camera.ViewportSize.X / 2) / math.tan(math.rad(Camera.FieldOfView / 2))
end

function Module.Barrel2DPosition()
    local WeaponController = WeaponControllerInterface:getActiveWeaponController()
    local Weapon = WeaponController and WeaponController:getActiveWeapon()

    if Weapon and Weapon:getWeaponType() == "Firearm" then
        local BarrelCFrame = Weapon:getBarrelCFrame()
        local BarrelVector = Camera:WorldToViewportPoint(BarrelCFrame.Position + BarrelCFrame.LookVector * Options["Legit/Settings/Offset"].Value)
        
        return Vector2.new(BarrelVector.X, BarrelVector.Y)
    end

    return UserInputService:GetMouseLocation()
end

function Module.Update()
    local FOVSize = Module.CalculateDegree(Options["Legit/Aimbot/FOV/Size"].Value)
    if Toggles["Legit/Aimbot/Enabled"].Value then
        Module.Target = CharacterInterface.isAlive() and Module.GetTarget(
            Toggles["Legit/Aimbot/FOV/Enabled"].Value and FOVSize or math.huge,
            Options["Legit/Aimbot/Hitbox"].Value,
            Options["Legit/Aimbot/Scan"].Value
        )

        if Module.Target and Options["Legit/Aimbot/Keybind"]:GetState() then
            local Delta, Smoothing = (Module.Target.ScreenPosition - UserInputService:GetMouseLocation()),  1 - Options["Legit/Aimbot/Smoothness"].Value / 100
            mousemoverel(Delta.X * Smoothing, Delta.Y * Smoothing)
        end
    end
    
    local Circle, Outline, Fill = Module.Render.Circle, Module.Render.Outline, Module.Render.Fill
    if Toggles["Legit/Aimbot/Enabled"].Value and Toggles["Legit/Aimbot/FOV/Enabled"].Value and Toggles["Legit/Aimbot/FOV/Draw"].Value then
        Circle.Visible = true
        Circle.Radius = FOVSize
        Circle.Color = Options["Legit/Aimbot/FOV/Colour"].Value

        Outline.Visible = Circle.Visible
        Outline.Radius = Circle.Radius

        Fill.Visible = Circle.Visible
        Fill.Color = Circle.Color
        Fill.Transparency = 1 - Options["Legit/Aimbot/FOV/Colour"].Transparency
        Fill.Size = Vector2.one * Circle.Radius * 2

        Circle.Position = Toggles["Legit/Settings/Barrel"].Value and Module.Barrel2DPosition() or UserInputService:GetMouseLocation()
        Outline.Position = Circle.Position
        Fill.Position = Circle.Position - Fill.Size / 2
    else
        Circle.Visible = false
        Outline.Visible = false
        Fill.Visible = false
    end
end

return Module