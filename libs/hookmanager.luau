local HookManager = {__Hooks = {}}

function HookManager:CreateHook(Func, Hook)
    local FuncName = debug.getinfo(Func, "n").name
    local FuncTable = filtergc("table", {
        IgnoreExecutor = true,
		Values = {Func}
    }, true)

    if not FuncTable then
        return warn(`Failed to hook "{FuncName}"`)
    end

    local Original = FuncTable[FuncName]
    FuncTable[FuncName] = Hook

    self.__Hooks[Hook] = {
        Table = FuncTable,
        Name = FuncTable,
        Original = Original
    }

    return Original
end

function HookManager:RestoreHook(HookedFunc)
    local HookData = self.__Hooks[HookedFunc]
    if HookData then
        HookData.Table[HookData.Name] = HookData.Original
    else
        warn(`Failed to restore hook for "{debug.getinfo(HookedFunc, "n").name}"`)
    end
end

function HookManager:RestoreHooks()
    for HookedFunc in self.__Hooks do
        self:RestoreHook(HookedFunc)
    end
end

getgenv().HookManager = HookManager
return HookManager