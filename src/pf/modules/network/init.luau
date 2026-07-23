local Module = {}

local Template, Params, Points = loadfile("beanhac.club/src/pf/modules/network/tracers.luau")()

local TweenService = game:GetService("TweenService")
local NetworkClient = shared.require("NetworkClient")
local NumberValue = Instance.new("NumberValue")

local NetworkMap = debug.getupvalue(NetworkClient.fireReady, 5)
local send, correctposition

function Module.Init()
    local Silent = shared.Fetch("silent")
    
    --[[correctposition = NetworkMap.correctposition
    NetworkMap.correctposition = function(Position)
        if Toggles["Misc/Movement/Bypass"].Value then
            
        else
            return correctposition(Position)
        end
    end]]

    send = NetworkClient.send
    NetworkClient.send = function(Self, CMD, ...)
        local Args = {...}

        if CMD == "newbullets" then
            for _, Bullet in Args[2].bullets do
                local Target = Silent.Target
                if Target and Silent.GetChance() then
                    Bullet[1] = (Target.Position - Args[2].firepos).Unit

                    if Toggles["Rage/Ragebot/Enabled"].Value and Options["Rage/Ragebot/Keybind"]:GetState() and Toggles["Rage/Ragebot/Force"].Value and Args[4] then
                        Args[4] = "Head"
                    end
                end

                if Toggles["Visuals/World/Tracer/Enabled"].Value then
                    local Origin = Args[2].firepos
                    local Direction = Bullet[1] * 1000
                
                    local Result = workspace:Raycast(Origin, Direction, Params)
                    local A0 = Instance.new("Attachment", Points[1])
                    local A1 = Instance.new("Attachment", Points[2])

                    A0.WorldCFrame = CFrame.new(Origin)
                    A1.WorldCFrame = Result and CFrame.new(Result.Position) or CFrame.new(Origin + Direction)

                    local Tracer: Beam = Template:Clone()
                    Tracer.Parent = workspace.Terrain
                    Tracer.Color = ColorSequence.new(Options["Visuals/World/Tracer/Colour"].Value)
                    Tracer.Transparency = NumberSequence.new(Options["Visuals/World/Tracer/Colour"].Transparency)
                    Tracer.Attachment0 = A0
                    Tracer.Attachment1 = A1
                    NumberValue.Value = Options["Visuals/World/Tracer/Colour"].Transparency

                    local Info = TweenInfo.new(Options["Visuals/World/Tracer/Lifetime"].Value, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                    TweenService:Create(Tracer, Info, {TextureSpeed = 2}):Play()
                    TweenService:Create(NumberValue, Info, {Value = 1}):Play()

                    task.spawn(function()
                        while NumberValue.Value < 1 do
                            task.wait()
                            Tracer.Transparency = NumberSequence.new(NumberValue.Value)
                        end

                        Tracer:Destroy()
                        A0:Destroy()
                        A1:Destroy()
                    end)
                end
            end
        end

        return send(Self, CMD, table.unpack(Args))
    end
end

function Module.Cleanup()
    NetworkClient.send = send
    --NetworkMap["correctposition"] = correctposition

    NumberValue:Destroy()
    Template:Destroy()
    Points[1]:Destroy()
    Points[2]:Destroy()
end

return Module