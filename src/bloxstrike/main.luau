local RunService: RunService = cloneref(game:GetService("RunService"))
local Library = loadfile("beanhac.club/src/bloxstrike/menu/init.luau")()
local HookManager = loadfile("beanhac.club/libs/hookmanager.luau")()

local Modules, Updates = {}, {} do
    for _, Path in listfiles("beanhac.club/src/bloxstrike/modules") do
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
    HookManager:RestoreHooks()
    
    for _, Data in Modules do
        if Data.Cleanup then
            setthreadidentity(8)
            Data.Cleanup()
        end
    end
end