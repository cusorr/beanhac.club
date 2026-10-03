local Module = {Cache = {}}

local Players: Players = cloneref(game:GetService("Players"))
local Workspace: Workspace = cloneref(game:GetService("Workspace"))

local Client = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

function Module.Init()
    Module.Storage = Instance.new("Folder", game.CoreGui)
    Module.Fonts = {
        ["smallestpixel-7"] = Module.LoadFont("smallestpixel-7"),
        ["tahoma-xp"] = Module.LoadFont("tahoma-xp"),
        ["csgo-icons"] = Module.LoadFont("csgo_icons.ttf")
    }
end

function Module.LoadFont(Name)
    local Path = "beanhac.club/assets/fonts/"..Name..".ttf"
    if DrawFont then
        return DrawFont.Register(Path, {PixelSize = 20})
    end

    local FontObject = Drawing.new("Font")
    FontObject.Data = readfile(Path)
    
    return FontObject
end

function Module.Drawing(Class, Properties)
    local Object = Drawing.new(Class)

    for Property, Value in Properties do
        Object[Property] = Value
    end

    return Object
end

function Module.Create(Player)
    local Cache = {
        Box = Module.Drawing("Square", {ZIndex = 2}),
        BoxOutline = Module.Drawing("Square", {ZIndex = 1, Thickness = 3}),

        Name = Module.Drawing("Text", {ZIndex = 2, Font = 3, Size = 12, Outline = true}),
        Highlight = Instance.new("Highlight", Module.Storage)
    }

    Cache[Player] = Cache
    return Cache
end

function Module.Remove(Player)
    local Cache = Module.Cache[Player]
    if Cache then
        for _, DrawingObject in Cache do
            if isrenderobj(DrawingObject) then
                DrawingObject:Destroy()
            else
                DrawingObject:Remove()
            end
        end
    end
end

function Module.ToggleCache(Player)
    local Cache = Module.Cache[Player]
    if Cache then
        for _, DrawingObject in Cache do
            if isrenderobj(DrawingObject) then
                DrawingObject.Visible = false
            else
                DrawingObject.Enabled = false
            end
        end
    end
end

local CornerOffsets = {
    Vector3.new(-1, -1, -1),
    Vector3.new(-1, -1,  1),
    Vector3.new(-1,  1, -1),
    Vector3.new(-1,  1,  1),
    Vector3.new( 1, -1, -1),
    Vector3.new( 1, -1,  1),
    Vector3.new( 1,  1, -1),
    Vector3.new( 1,  1,  1),
}

function Module.CalculateBounds(Character: Model)
    local _, OnScreen = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
    if not OnScreen then return end

    local Orientation, Size = Character:GetBoundingBox()
    local MinX, MaxX = math.huge, -math.huge
    local MinY, MaxY = math.huge, -math.huge

    for _, Offset in CornerOffsets do
        local ScreenPosition = Camera:WorldToScreenPoint(Orientation:PointToWorldSpace(Offset * Size / 2))
        MinX = math.min(MinX, ScreenPosition.X)
        MinY = math.min(MinY, ScreenPosition.Y)
        MaxX = math.max(MaxX, ScreenPosition.X)
        MaxY = math.max(MaxY, ScreenPosition.Y)
    end

    return {
        Position = Vector2.new(MinX, MinY):Abs(),
        Size = Vector2.new(MaxX - MinX, MaxY - MinY):Abs()
    }
end

function Module.Update()
    
end

return Module