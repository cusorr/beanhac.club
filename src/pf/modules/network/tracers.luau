local Terrain = workspace.Terrain

local TracerTemplate = Instance.new("Beam", game.CoreGui) do
    TracerTemplate.Parent = Terrain
    TracerTemplate.FaceCamera = true
    TracerTemplate.Width0 = 0.5
    TracerTemplate.Width1 = 0.5
    TracerTemplate.LightEmission = 1
    TracerTemplate.Texture = getcustomasset("beanhac.club/assets/img/beam.png")
    TracerTemplate.TextureMode = Enum.TextureMode.Static
    TracerTemplate.TextureSpeed = 12
    TracerTemplate.TextureLength = 1.3
end

local TracerOrigin, TracerDestination = Instance.new("Part", Terrain), Instance.new("Part", Terrain) do
    TracerOrigin.Anchored = true
    TracerOrigin.CanCollide = false
    TracerOrigin.Size = Vector3.zero
    TracerOrigin.Transparency = 1

    TracerDestination.Anchored = true
    TracerDestination.CanCollide = false
    TracerDestination.Size = Vector3.zero
    TracerDestination.Transparency = 1
end

local TracerParams = RaycastParams.new() do
    TracerParams.FilterType = Enum.RaycastFilterType.Include
    TracerParams.FilterDescendantsInstances = {workspace.Map}
    TracerParams.IgnoreWater = true
end

return TracerTemplate, TracerParams, {TracerOrigin, TracerDestination}