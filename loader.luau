local Executor = identifyexecutor and identifyexecutor():lower() or ""
if not Executor:find("potassium") and not Executor:find("volt") then
    return warn("Unsupported executor!")
end

if game.GameId == 113491250 then -- PF
    local run_on_actor = run_on_thread or run_on_actor
    local getactors = getactorthreads or getactors

    for _, actor in getactors() do
        run_on_actor(actor, [[
            if getrenv().shared.require then
                loadfile("beanhac.club/src/pf/main.luau")()
            end
        ]])
    end
elseif game.GameId == 7633926880 then -- Bloxstrike
    loadfile("beanhac.club/src/bloxstrike/main.luau")()
else
    return warn("Unsupported game!")
end