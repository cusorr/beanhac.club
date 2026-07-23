local Module = {}

local WeaponControllerInterface = shared.require("WeaponControllerInterface")
local GameClock = shared.require("GameClock")
local RecoilSprings = shared.require("RecoilSprings")
local FirearmObject = shared.require("FirearmObject")
local HudStatusInterface = shared.require("HudStatusInterface")
local NetworkClient = shared.require("NetworkClient")
local CameraInterface = shared.require("CameraInterface")
local HudScopeInterface = shared.require("HudScopeInterface")
local MainCameraObject = shared.require("MainCameraObject")
local MeleeObject = shared.require("MeleeObject")
local GrenadeObject = shared.require("GrenadeObject")
local Sway = shared.require("Sway")

local applyImpulse, impulseSprings, reload, setScope, setSuppression, computeGunSway, computeWalkSway, MwalkSway, meleeSway, GwalkSway, modelSway, getSwayCFrame

function Module.Init()
    applyImpulse = RecoilSprings.applyImpulse
    RecoilSprings.applyImpulse = function(self, CF, Impulse)
        if Toggles["Legit/Mods/Recoil/Enabled"].Value then
            return applyImpulse(self, CF, Impulse * Options["Legit/Mods/Recoil/Value"].Value / 100)
        end

        return applyImpulse(self, CF, Impulse)
    end

    impulseSprings = FirearmObject.impulseSprings
    FirearmObject.impulseSprings = function(self, ...)
        if Toggles["Legit/Mods/Spread/Enabled"].Value then
            return impulseSprings(self, 1 - Options["Legit/Mods/Spread/Value"].Value / 100)
        end

        return impulseSprings(self, ...)
    end

    reload = FirearmObject.reload
    FirearmObject.reload = function(Weapon)
        if not Toggles["Legit/Mods/Reload"].Value then return reload(Weapon) end
        if Weapon:isEquipping() or Weapon:isUnequipping() or not Weapon:canReload() then return end

        local MagSize = Weapon:getWeaponStat("magsize") + (Weapon:getWeaponStat("chamber") and 1 or 0)
        local Refill = MagSize - Weapon._magCount

        if Refill > 0 then
            if Refill < Weapon._spareCount then
                Weapon._magCount = Weapon._magCount + Refill
                Weapon._spareCount = Weapon._spareCount - Refill
            else
                Weapon._magCount = Weapon._magCount + Weapon._spareCount
                Weapon._spareCount = 0
            end

            NetworkClient:send("reload")
            HudStatusInterface.updateAmmo(Weapon)
        end

        Weapon._chamberState:setState("chambered", GameClock.getTime())
    end

    setScope = HudScopeInterface.setScope
    HudScopeInterface.setScope = function(Enabled, ...)
        if Toggles["Visuals/Removal/Scope"].Value then
            return setScope(false, ...)
        end

        return setScope(Enabled, ...)
    end

    setSuppression = MainCameraObject.setSuppression
    MainCameraObject.setSuppression = function(self, ...)
        if Toggles["Visuals/Removal/Suppression"].Value then
            return setSuppression(self, Vector3.zero)
        end

        return setSuppression(self, ...)
    end

    computeWalkSway = FirearmObject.computeWalkSway
    FirearmObject.computeWalkSway = function(...)
        if Toggles["Legit/Mods/WalkSway"].Value then
            return CFrame.new()
        end

        return computeWalkSway(...)
    end

    computeGunSway = FirearmObject.computeGunSway
    FirearmObject.computeGunSway = function(...)
        if Toggles["Legit/Mods/GunSway"].Value then
            return CFrame.new()
        end

        return computeGunSway(...)
    end

    MwalkSway = MeleeObject.walkSway
    MeleeObject.walkSway = function(...)
        if Toggles["Legit/Mods/WalkSway"].Value then
            return CFrame.new()
        end

        return MwalkSway(...)
    end

    meleeSway = MeleeObject.meleeSway
    MeleeObject.meleeSway = function(...)
        if Toggles["Legit/Mods/GunSway"].Value then
            return CFrame.new()
        end

        return meleeSway(...)
    end

    GwalkSway = GrenadeObject.walkSway
    GrenadeObject.walkSway = function(...)
        if Toggles["Legit/Mods/WalkSway"].Value then
            return CFrame.new()
        end

        return GwalkSway(...)
    end

    modelSway = GrenadeObject.modelSway
    GrenadeObject.modelSway = function(...)
        if Toggles["Legit/Mods/GunSway"].Value then
            return CFrame.new()
        end

        return modelSway(...)
    end

    getSwayCFrame = Sway.getSwayCFrame
    Sway.getSwayCFrame = function(...)
        if Toggles["Legit/Mods/GunSway"].Value then
            return CFrame.new()
        end

        return getSwayCFrame(...)
    end
end

local nShots = 0
function Module.Update()
    local WeaponController = WeaponControllerInterface:getActiveWeaponController()
    local Weapon = WeaponController and WeaponController:getActiveWeapon()
    if not Weapon then return end

    local WeaponType = Weapon:getWeaponType()
    if Toggles["Legit/Mods/Firerate/Enabled"].Value and WeaponType == "Firearm" then
        if Weapon._nShots > 0 and Weapon._nShots > nShots then
            nShots = Weapon._nShots
            Weapon._nextShot = GameClock.getTime() + 60 / (Weapon:getFirerate() * Options["Legit/Mods/Firerate/Value"].Value / 100)
        elseif Weapon._nShots == 0 then
            nShots = 0
        end
    end

    local MainOffset = Weapon:getWeaponStat("mainoffset")
    local AimAlpha = Weapon._aimArmSpring and Weapon._aimArmSpring.p or 0

    if Toggles["Visuals/Local/Viewmodel/Enabled"].Value then
        Weapon._mainOffset = (MainOffset * CFrame.new(
            Options["Visuals/Local/Viewmodel/X"].Value,
            Options["Visuals/Local/Viewmodel/Y"].Value,
            Options["Visuals/Local/Viewmodel/Z"].Value
        ) * CFrame.fromEulerAnglesXYZ(
            math.rad(Options["Visuals/Local/Viewmodel/Pitch"].Value),
            math.rad(Options["Visuals/Local/Viewmodel/Yaw"].Value),
            math.rad(Options["Visuals/Local/Viewmodel/Roll"].Value)
        )):Lerp(MainOffset, AimAlpha)
    else
        Weapon._mainOffset = MainOffset
    end

    local ActiveCamera = debug.getupvalue(CameraInterface.getActiveCamera, 3) --> no console spam
    if ActiveCamera then
        if Toggles["Visuals/Camera/FOV/Enabled"].Value and not (WeaponType == "Firearm" and Toggles["Visuals/Camera/FOV/Ignore"].Value and Weapon:isBlackScoped()) then
            local FoV, ADSFoV = Options["Visuals/Camera/FOV/Value"].Value, Options["Visuals/Camera/FOV/ADS"].Value

            local TargetFoV = FoV + (ADSFoV - FoV) * AimAlpha
            ActiveCamera:setMagnification(math.tan(math.rad(80) / 2) / math.tan(math.rad(TargetFoV) / 2))
        end

        if Toggles["Legit/Mods/GunSway"].Value then
            ActiveCamera:setSway(0)
        end
    end

    for _, Arm: Model in {Weapon._characterObject:getArmModels()} do
        local Sleeves = Arm.Sleeves
        Sleeves.Transparency = Toggles["Visuals/Removal/Sleeves"].Value and 1 or 0

        for _, Texture: Texture in Sleeves:GetChildren() do
            if Texture:IsA("Texture") then
                Texture.Transparency = Toggles["Visuals/Local/Arms/Enabled"].Value and 1 or Sleeves.Transparency
            end
        end

        for _, Part in Arm:GetChildren() do
            if Part.Name == "Part" then
                Part.Transparency = Toggles["Visuals/Removal/Accessory"].Value and 1 or 0
            end

            if Part:IsA("BasePart") then
                local Enabled = Toggles["Visuals/Local/Arms/Enabled"].Value
                if not Part:GetAttribute("Colour") then
                    Part:SetAttribute("Colour", Part.Color)
                    Part:SetAttribute("Material", Part.Material.Name)
                end

                Part.Color = Enabled and Options["Visuals/Local/Arms/Colour"].Value or Part:GetAttribute("Colour")
                Part.LocalTransparencyModifier = Enabled and Options["Visuals/Local/Arms/Colour"].Transparency or 0
                Part.Material = Enabled and Options["Visuals/Local/Arms/Material"].Value or Part:GetAttribute("Material")
            end
        end
    end

    --print(Weapon:getActiveAimStat("sightpart"))

    if Weapon._weaponModel then
         for _, Object: Instance in Weapon._weaponModel:GetDescendants() do
            local Enabled = Toggles["Visuals/Local/Weapon/Enabled"].Value
            if Object:IsA("BasePart") and Object.Transparency == 0 then
                local IsLaser = Object:FindFirstChildOfClass("CylinderMesh")
                if Object:IsA("UnionOperation") then
                    Object.UsePartColor = true
                end

                if not Object:GetAttribute("Colour") then
                    Object:SetAttribute("Colour", Object.Color)
                    Object:SetAttribute("Material", Object.Material.Name)
                end

                Object.Color = Enabled and not IsLaser and Options["Visuals/Local/Weapon/Colour"].Value or Object:GetAttribute("Colour")
                Object.LocalTransparencyModifier = Enabled and Options["Visuals/Local/Weapon/Colour"].Transparency or 0
                Object.Material = Enabled and not IsLaser and Options["Visuals/Local/Weapon/Material"].Value or Object:GetAttribute("Material")
            elseif Object:IsA("Texture") or Object:IsA("Decal") then
                if not Object:GetAttribute("Transparency") then
                    Object:SetAttribute("Transparency", Object.Transparency)
                end

                Object.Transparency = Enabled and 1 or Object:GetAttribute("Transparency")
            end
        end
    end
end

function Module.Cleanup()
    RecoilSprings.applyImpulse = applyImpulse
    FirearmObject.impulseSprings = impulseSprings
    FirearmObject.reload = reload
    HudScopeInterface.setScope = setScope
    MainCameraObject.setSuppression = setSuppression
    FirearmObject.computeGunSway = computeGunSway
    FirearmObject.computeWalkSway = computeWalkSway
    MeleeObject.meleeSway = meleeSway
    MeleeObject.walkSway = MwalkSway
    GrenadeObject.modelSway = modelSway
    GrenadeObject.walkSway = GwalkSway
    Sway.getSwayCFrame = getSwayCFrame
end

return Module