local Module = {}

local CharacterInterface = shared.require("CharacterInterface")
local WeaponControllerInterface = shared.require("WeaponControllerInterface")

function Module.Update()
    local CharacterObject = CharacterInterface.getCharacterObject()
    if not CharacterObject then return end

    if Toggles["Misc/Movement/Walkspeed"].Value and Options["Misc/Movement/Walkspeed/Keybind"]:GetState() then
        CharacterObject:setBaseWalkSpeed(Options["Misc/Movement/Walkspeed/Value"].Value)
    else
        local WeaponController = WeaponControllerInterface.getActiveWeaponController()
        local Weapon = WeaponController and WeaponController:getActiveWeapon()
        if Weapon then
            
            CharacterObject:setBaseWalkSpeed(Weapon:getWeaponStat("walkspeed"))
        end
    end

    local Humanoid = CharacterObject._humanoid
    if Toggles["Misc/Movement/Bunnyhop"].Value and Options["Misc/Movement/Bunnyhop/Keybind"]:GetState() and Humanoid.FloorMaterial ~= Enum.Material.Air then
        Humanoid.Jump = true
        Humanoid.JumpPower = 29.065
        CharacterObject._lastJumpTime = 0
        CharacterObject._lastLandTime = math.huge
    end

    if Toggles["Misc/Movement/Stamina"].Value then
        CharacterObject._stamina0 = 1
        CharacterObject._staminaTime0 = 0
    end

    if Toggles["Misc/Movement/Cooldown"].Value then
        CharacterObject.dived = false
        CharacterObject.sprintDisabled = false

        if CharacterObject._inSlideLoop then
            CharacterObject._sliding = true
        end
    end
end

return Module