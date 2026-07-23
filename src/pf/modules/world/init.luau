local Module = {}

local CharacterInterface = shared.require("CharacterInterface")
local Effects = shared.require("Effects")

local Lighting = game:GetService("Lighting")
local MapLighting = Lighting:FindFirstChild("MapLighting")

function Module.Update()
    local isAlive = CharacterInterface.isAlive()
    if Toggles["Visuals/World/Ambient/Enabled"].Value then
        Lighting.Ambient = Options["Visuals/World/Ambient/Colour"].Value
    elseif isAlive then
        Lighting.Ambient = MapLighting.Ambient.Value
    end

    if Toggles["Visuals/World/Color/Enabled"].Value then
        Lighting.ColorShift_Top = Options["Visuals/World/Color/Colour"].Value
        Lighting.ColorShift_Bottom = Options["Visuals/World/Color/Colour"].Value
    elseif isAlive then
        Lighting.ColorShift_Top = MapLighting.ColorShift_Top.Value
        Lighting.ColorShift_Bottom = MapLighting.ColorShift_Bottom.Value
    end

    if Toggles["Visuals/World/Clocktime/Enabled"].Value then
        Lighting.ClockTime = Options["Visuals/World/Clocktime/Value"].Value
    end

    local Map = workspace.Map
    local MapParts = Map:FindFirstChild("MapParts")

    if Toggles["Visuals/Removal/Textures"].Value and MapParts and not MapParts:GetAttribute("Removed") then
        MapParts:SetAttribute("Removed", true)
        
        for _, v in MapParts:GetDescendants() do
            if v:IsA("BasePart") then
                v.Material = "SmoothPlastic"
            end
        end
    end

    if not isAlive then
        Effects:setuplighting(false)
    end
end

function Module.Cleanup()
    Effects:setuplighting(CharacterInterface.isAlive())
end

return Module