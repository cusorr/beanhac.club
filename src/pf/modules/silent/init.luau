local Module = {}

local BulletInterface = shared.require("BulletInterface")
local WeaponControllerInterface = shared.require("WeaponControllerInterface")
local CharacterInterface = shared.require("CharacterInterface")

local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Aimbot, newBullet
local Chance

function Module.Init()
    Aimbot = shared.Fetch("aimbot")

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

    newBullet = BulletInterface.newBullet
    BulletInterface.newBullet = function(Bullet)
        if Module.Target and Bullet then
            local WeaponController = WeaponControllerInterface:getActiveWeaponController()
            local Weapon = WeaponController and WeaponController:getActiveWeapon()
            
            if Weapon and Module.GetChance() then
                Bullet.velocity = (Module.Target.Position - Bullet.position).Unit * Weapon:getWeaponStat("bulletspeed")
            end
        end

        return newBullet(Bullet)
    end
end

function Module.Update()
    local FOVSize = Aimbot.CalculateDegree(Options["Legit/Silent/FOV/Size"].Value)
    Module.Target = Toggles["Legit/Silent/Enabled"].Value and Options["Legit/Silent/Keybind"]:GetState() and CharacterInterface.isAlive() and Aimbot.GetTarget(
        Toggles["Legit/Silent/FOV/Enabled"].Value and FOVSize or math.huge,
        Options["Legit/Silent/Hitbox"].Value,
        Options["Legit/Silent/Scan"].Value
    )

    if Module.Target and Toggles["Legit/Silent/Auto"].Value then
        task.wait()
        mouse1press()
        task.wait()
        mouse1release()
    end

    local Circle, Outline, Fill = Module.Render.Circle, Module.Render.Outline, Module.Render.Fill
    if Toggles["Legit/Silent/Enabled"].Value and Toggles["Legit/Silent/FOV/Enabled"].Value and Toggles["Legit/Silent/FOV/Draw"].Value then
        Circle.Visible = true
        Circle.Radius = FOVSize
        Circle.Color = Options["Legit/Silent/FOV/Colour"].Value

        Outline.Visible = Circle.Visible
        Outline.Radius = Circle.Radius

        Fill.Visible = Circle.Visible
        Fill.Color = Circle.Color
        Fill.Transparency = 1 - Options["Legit/Silent/FOV/Colour"].Transparency
        Fill.Size = Vector2.one * Circle.Radius * 2

        Circle.Position = Toggles["Legit/Settings/Barrel"].Value and Aimbot.Barrel2DPosition() or UserInputService:GetMouseLocation()
        Outline.Position = Circle.Position
        Fill.Position = Circle.Position - Fill.Size / 2
    else
        Circle.Visible = false
        Outline.Visible = false
        Fill.Visible = false
    end

    Chance = Toggles["Legit/Silent/Hitchance/Enabled"].Value and math.random(0, 100) <= Options["Legit/Silent/Hitchance/Value"].Value or true
end

function Module.GetChance()
    return Chance
end

function Module.Cleanup()
    BulletInterface.newBullet = newBullet
end

return Module