local RunService = game:GetService("RunService")
local Modules, Updates = {}, {} do
    function RegisterFont(Name)
        local Path = "beanhac.club/assets/fonts/"..Name..".ttf"
        if DrawFont then
            return DrawFont.Register(Path, {PixelSize = 20})
        end

        local FontObject = Drawing.new("Font")
        FontObject.Data = readfile(Path)
        
        return FontObject
    end

    shared.require = getrenv().shared.require
    shared.Fonts = {Tahoma = RegisterFont("tahoma-xp"), SmallestPixel = RegisterFont("smallestpixel-7")}
    shared.Fetch = function(Name)
        local Data = Modules[Name]
        if Data then
            return Data
        end

        warn("Failed to fetch module: "..Name)
    end
end

local Library = loadfile("beanhac.club/src/pf/menu/init.luau")()

repeat
    task.wait()
until Library ~= nil

do
    for _, Path in listfiles("beanhac.club/src/pf/modules") do
        local Name = Path:match("[^\\]+$")

        local Ok, Data = pcall(loadfile(Path.."/init.luau"))
        if Ok then
            Modules[Name] = Data
            Updates[Name] = Data.Update
        else
            return warn("Failed to load module: "..Name..", "..Data)
        end
    end
    for Name, Data in Modules do
        if Data.Init then
            local Success, Err = pcall(Data.Init)
            if not Success then
                return warn("Failed to init module: "..Name..", "..Err)
            end
        end
    end

    Library:Connect(RunService.RenderStepped:Connect(function(Delta)
        for Name, Update in Updates do
            setthreadidentity(8)
            local Ok, Err = pcall(Update, Delta)
            if not Ok then
                warn("Update failed: "..Name..", "..Err)
            end
        end
    end))
end

Library.OnUnload = function()
    cleardrawcache()
    getgenv().Loaded = nil

    for _, Data in Modules do
        if Data.Cleanup then
            setthreadidentity(8)
            Data.Cleanup()
        end
    end
end

getgenv().Loaded = true