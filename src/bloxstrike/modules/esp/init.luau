local Module = {Cache = {}}

local Players: Players = cloneref(game:GetService("Players"))

function Module.Init()
    Module.Storage = Instance.new("Folder", game.CoreGui)
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
            DrawingObject:Remove()
        end
    end
end

return Module