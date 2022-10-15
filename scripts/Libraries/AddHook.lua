--[[
    Hook 5.0.1 - better speed, features, code length, intuitive and has no requirements.
    Core API has been reduced from Hook.add, Hook.addSimple, Hook.remove, Hook.flush to just AddHook
    Secondary API has been reduced from hook.args, hook.returned, hook.old, hook.skip to just old(...)
    AddHook returns two functions: 1) old function* and 2) function to call to remove the hook.**
    
    *The old function will point to either the originally-hooked function, or it will point to the next-lower priority
        "AddHook" function a user requested. Not calling "oldFunc" means that any lower-priority callbacks will not
        execute. It is therefore key to make sure to prioritize correctly: higher numbers are called before lower ones.
"Classic" way of hooking in Lua is shown below, but doesn't allow other hooks to take a higher priority, nor can it be removed safely.
    local oldFunc = BJDebugMsg
    BJDebugMsg = print
The below allows other hooks to coexist with it, based on a certain priority, and can be removed:
    local oldFunc, removeFunc = AddHook("BJDebugMsg", print)
A small showcase of what you can do with the API:
    
    local oldFunc, removeFunc --remember to declare locals before any function that uses them
   
    oldFunc, removeFunc = AddHook("BJDebugMsg", function(s)
        if want_to_display_to_all_players then
            oldFunc(s) --this either calls the native function, or allows lower-priority hooks to run.
        elseif want_to_remove_hook then
            removeFunc() --removes just this hook from BJDebugMsg
        elseif want_to_remove_all_hooks then
            removeFunc(true) --removes all hooks on BJDebugMsg
        else
            print(s) --not calling the native function means that lower-priority hooks will be skipped.
        end
    end)
Version 5.0 also introduces a "metatable" boolean as the last parameter, which will get or create a new metatable
for the parentTable parameter, and assign the "oldFunc" within the metatable (or "default" if no oldFunc exists).
This is envisioned to be useful for hooking __index and __newindex on the _G table, such as with Global Variable
Remapper.
]]--
OnLibraryInit({name = "AddHook"}, function ()
---@param oldFunc string
---@param userFunc function
---@param priority? number
---@param parentTable? table
---@param default? function
---@param storeIntoMetatable? boolean
---@return function old_function
---@return function call_this_to_remove
function AddHook(oldFunc, userFunc, priority, parentTable, default, storeIntoMetatable)
    parentTable = parentTable or _G --if no parent table is specified, assume the user just wants a regular global hook.
    if default and storeIntoMetatable then
        local mt = getmetatable(parentTable)
        if not mt then
            mt = {}
            setmetatable(parentTable, mt) --create a new metatable in case none existed.
        end
        parentTable = mt --index the hook to this metatable instead of to the 
    end
    local index     = 2 --the index defaults to 2 (index 1 is reserved for the original function that you're trying to hook)
    local hookStr   = "_hooked_"..oldFunc --You can change the prefix if you want, in case it conflicts with any other prefixes you use in your table.
    local hooks     = rawget(parentTable, hookStr)
    priority        = priority or 0
    if hooks then
        local fin   = #hooks
        repeat
            if hooks[index][2] > priority then break end -- search manually for an index based on the priority of all other hooks.
            index = index + 1
        until index > fin
        --print("adding to index:",index)
    else
        hooks = { --create a table that stores all hooks that can be added to this function.
            { --this is the root hook table.
                rawget(parentTable, oldFunc) or default,  --index[1] either points to the native function or to the default function if none existed.
                ---@param where integer
                ---@param instance? table
                function(where, instance)               --index[2] is a function called to update hook indices when a new hook is added or an old is removed.
                    local n = #hooks
                    if where > n then --this only occurs when this is the first hook.
                        hooks[where] = instance
                    elseif where == n and not instance then --the top hook is being removed.
                        hooks[where] = nil
                        rawset(parentTable, oldFunc, hooks[where-1][1]) --assign the next function to the parent table
                        --print("removing hook index:",where)
                    else
                        if instance then
                            table.insert(hooks, where, instance) --if an instance is provided, we add it
                            where = where + 1
                            n = n + 1 --added in 5.0.1
                            --print("adding hook instance:",where)
                        else
                            table.remove(hooks, where) --if no instance is provided, we remove the existing index. 
                        end
                        for i = where, n do
                            --print("bumping up hook index at:",i)
                            hooks[i][3](i) --when an index is added or removed in the middle of the list, re-map the subsequent indices.
                        end
                    end
                end
            }
        } --create a new table with the callback functions defined above
        rawset(parentTable, hookStr, hooks) --this would store the hook-table holding BJDebugMsg as _G["_hooked_BJDebugMsg"]
    end
    --call the stored function at root-hook-table[2] to assign indices.
    hooks[1][2](index, { --this table belongs specifically to this newly-added Hook instance.
        userFunc, --index[1] is the function that needs to be called in place of the original function.
        priority, --index[2] is the priority specified by the user so it can be compared with future added hooks.
        function(i) index = i end --index[3] is the function that is used to inject an instruction to realign the instance's local index (almost everything is processed in local scope).
    })
    if index == #hooks then -- this is the highest-priority hook and should be called first.
        rawset(parentTable, oldFunc, userFunc) --insert the user's function as the actual function that gets natively called.
        --print("setting parent-table hook function as userFunc at index:",index)
    end
    return function(...)
        return hooks[index-1][1](...) --this is the "old" function, that will either call the original or call the next lower-priorty hook,
    end,                              --and allows "..." without packing/unpacking.
    --this is the "RemoveHook" function:
    function(removeAll)
        local fin = #hooks
        if removeAll or fin == 2 then --remove all hooks.
            rawset(parentTable, hookStr, nil) --clear memory
            rawset(parentTable, oldFunc, hooks[1][1]) --restore the original function to the parent table.
        else
            hooks[1][2](index) --remove just the single hook instance
        end
    end
end

--[[
local oldInitGlobals
oldInitGlobals = AddHook("InitGlobals", function ()
    xpcall(oldInitGlobals, function (msg)
        TimerStart(CreateTimer(), 0, false, function ()
            print(msg)
        end)
    end)
end)
]]
local oldInitCustomTriggers
oldInitCustomTriggers = AddHook("InitCustomTriggers", function ()
    xpcall(oldInitCustomTriggers, function (msg)
        TimerStart(CreateTimer(), 0, false, function ()
            print(msg)
        end)
    end)
end)
end)