local Module = {}

local ReplicationInterface = shared.require("ReplicationInterface")
local WeaponControllerInterface = shared.require("WeaponControllerInterface")
local HudStatusInterface = shared.require("HudStatusInterface")
local PublicSettings = shared.require("PublicSettings")
local BulletCheck = shared.require("BulletCheck")
local NetworkClient = shared.require("NetworkClient")
local GameClock = shared.require("GameClock")
local BulletInterface = shared.require("BulletInterface")
local HitDetectionInterface = shared.require("HitDetectionInterface")
local FirearmObject = shared.require("FirearmObject")
local AudioSystem = shared.require("AudioSystem")
local PhysicsLib = shared.require("PhysicsLib")

local Camera = workspace.CurrentCamera
local BulletAcceleration = PublicSettings.bulletAcceleration
local IgnoreList = {workspace.Terrain, workspace.Ignore, workspace.CurrentCamera, workspace.Players}
local OnPlayerHit = debug.getupvalue(FirearmObject.fireRound, 15)

function Module.PlayFireSound(WeaponData)
    local Sound: Sound = AudioSystem.getSound()
    Sound.SoundId = WeaponData.firesoundid
    Sound.Pitch = WeaponData.firepitch + (math.random() * 0.1 - 0.05)
    Sound.Volume = WeaponData.firevolume
    Sound.Parent = Camera
    Sound.Ended:Connect(function() Sound:Destroy() end)
    Sound:Play()

    return Sound
end

function Module.Trajectory(Origin, Target, Speed, TargetVelocity, TargetAcceleration)
    if TargetVelocity and TargetVelocity.Magnitude > 0.1 then
        local Velocity, Time = PhysicsLib.so
    end
end

function Module.ScanTarget(Origin, Target, BulletSpeed, BulletPenetration)
    local Origins = {CFrame.lookAt(Origin, Target).Position}
    local Targets = {CFrame.lookAt(Target, Origin).Position}

    for _, NormalId in Enum.NormalId:GetEnumItems() do
        table.insert(Origins, Origins[1] + Vector3.FromNormalId(NormalId) * Options["Rage/Ragebot/Scanning/Origin"].Value)
        table.insert(Targets, Targets[1] + Vector3.FromNormalId(NormalId) * Options["Rage/Ragebot/Scanning/Target"].Value)
    end

    for _, NewOrigin in Origins do
        for _, NewTarget in Targets do
            local Direction = PhysicsLib.ballisticsTrajectory(
                NewOrigin.X, NewOrigin.Y, NewOrigin.Z,
                BulletSpeed,
                BulletAcceleration,  -- Just use it directly
                NewTarget.X, NewTarget.Y, NewTarget.Z
            )
            
            if Direction then
                local BulletVelocity = Direction * BulletSpeed
                
                if BulletCheck(NewOrigin, NewTarget, BulletVelocity, BulletAcceleration, BulletPenetration) then
                    return {
                        Origin = NewOrigin,
                        Target = NewTarget,
                        Direction = Direction,
                        Velocity = BulletVelocity,
                    }
                end
            end
        end
    end
end

function Module.GetTarget()
    local Max, Result = math.huge, nil
    ReplicationInterface.operateOnAllEntries(function(Player, Entry)
        if not Toggles["Rage/Ragebot/Enabled"].Value or not Options["Rage/Ragebot/Keybind"]:GetState() then return end
        if not Entry:isAlive() or not Entry:isEnemy() then return end

        local ThirdPersonObject = Entry:getThirdPersonObject()
        local CharacterModel = ThirdPersonObject and ThirdPersonObject:getCharacterModel()
        if not CharacterModel or CharacterModel.Parent == nil then return end

        local Magnitude = (Camera.CFrame.Position - Entry:getPosition()).Magnitude
        if Magnitude > Max then return end

        local WeaponController = WeaponControllerInterface:getActiveWeaponController()
        local Weapon = WeaponController and WeaponController:getActiveWeapon()
        if not Weapon or Weapon:getWeaponType() ~= "Firearm" then return end

        local Hitboxes = Options["Rage/Ragebot/Hitbox"].Value
        local CharacterHash = ThirdPersonObject:getCharacterHash()

        local BulletSpeed = Weapon:getWeaponStat("bulletspeed")
        local BulletPenetration = Weapon:getWeaponStat("penetrationdepth")
        local BulletTime = Magnitude / BulletSpeed

        for Hitbox in {Head = Hitboxes.Head, Torso = Hitboxes.Torso, ["Left Arm"] = Hitboxes.Arms, ["Right Arm"] = Hitboxes.Arms, ["Left Leg"] = Hitboxes.Legs, ["Right Leg"] = Hitboxes.Legs} do
            local Bodypart = CharacterHash[Hitbox]
            local TargetPosition = Bodypart.Position + (Entry._velspring.t * BulletTime) + (0.5 * -BulletAcceleration * BulletTime^2)
            local Scan = Module.ScanTarget(Weapon._barrelPart.Position, TargetPosition, BulletSpeed, BulletPenetration)

            if Scan then
                Max, Result = Magnitude, {
                    Player = Player,
                    Hitbox = Hitbox,
                    Origin = Scan.Origin,
                    Target = Scan.Target,
                    Direction = Scan.Direction,
                    Velocity = Scan.Velocity,
                    Weapon = Weapon
                }
                break
            end

            --[[if BulletCheck(BulletOrigin, TargetPosition, BulletVelocity, BulletAcceleration, BulletPenetration) then
                Max, Result = Magnitude, {
                    Player = Player,
                    Hitbox = Hitbox,
                    Origin = BulletOrigin,
                    Target = TargetPosition,
                    Direction = BulletDirection,
                    Velocity = BulletVelocity,
                    Weapon = Weapon
                }
            end]]
        end
    end)

    return Result
end

local LastShot = tick()
function Module.Update()
    Module.Target = Module.GetTarget()
    if not Module.Target then return end

    local Target = Module.Target
    local Weapon = Target.Weapon

    if Weapon._magCount < 1 and Weapon._spareCount < 1 then return end

    local WeaponData = Weapon:getWeaponData()
    if not WeaponData then return end

    local Delta = tick() - LastShot
    local Firerate = Weapon:getFirerate()
    if Toggles["Legit/Mods/Firerate/Enabled"].Value then
        Firerate = Weapon:getFirerate() * Options["Legit/Mods/Firerate/Value"].Value / 100
    end

    if Delta < 60 / Firerate then return end
    LastShot = tick()

    local BulletCount = WeaponData.pelletcount or 1
    local BulletTicket = debug.getupvalue(Weapon.fireRound, 11)
    local Bullets = table.create(BulletCount, {Target.Direction, BulletTicket})

    for Index, Bullet in Bullets do
        Bullet[2] += Index
    end

    debug.setupvalue(Weapon.fireRound, 11, BulletTicket + BulletCount)

    NetworkClient:send("newbullets", Weapon.uniqueId, {
        firepos = Target.Origin,
        camerapos = Camera.CFrame.Position,
        bullets = Bullets
    }, GameClock.getTime())

    for _, Bullet in Bullets do
        BulletInterface.newBullet({
            position = Target.Origin,
            velocity = Target.Velocity,
            acceleration = BulletAcceleration,
            color = Weapon:getWeaponStat("bulletcolor") or Color3.fromRGB(255, 94, 94),
            size = 0.2,
            bloom = 0.005,
            brightness = Weapon:getWeaponStat("bulletbrightness") or 400,
            life = PublicSettings.bulletLifeTime,
            visualorigin = Weapon._barrelPart.Position,
            physicsignore = IgnoreList,
            dt = Delta,
            penetrationdepth = Weapon:getWeaponStat("penetrationdepth"),
            tracerless = Weapon:getWeaponStat("tracerless"),
            extra = {
                playersHit = {},
                bulletTicket = Bullet[2],
                firstHits = {},
                firearmObject = Weapon,
                uniqueId = Weapon.uniqueId
            },
            onplayerhit = OnPlayerHit,
            ontouch = HitDetectionInterface.hitDetection
        })

        NetworkClient:send("bullethit", Weapon.uniqueId, Target.Player, Target.Target, Target.Hitbox, Bullet[2], GameClock.getTime())
        Module.PlayFireSound(WeaponData)
    end

    Weapon._magCount -= 1
    if Weapon._magCount <= 0 and Weapon._spareCount > 0 then
        local MagSize = Weapon:getWeaponStat("magsize") + (Weapon:getWeaponStat("chamber") and 1 or 0)
        local New = MagSize - Weapon._magCount
        if New < Weapon._spareCount then
            Weapon._magCount = Weapon._magCount + New
            Weapon._spareCount = Weapon._spareCount - New
        else
            Weapon._magCount = Weapon._magCount + Weapon._spareCount
            Weapon._spareCount = 0
        end
        NetworkClient:send("reload")
        HudStatusInterface.updateAmmo(Weapon)
        Weapon._chamberState:setState("chambered", GameClock.getTime())
    end
end

return Module