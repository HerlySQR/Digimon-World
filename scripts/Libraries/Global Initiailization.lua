--[==[
Global Initialization 4.3.1 by Bribe

Special thanks:
Eikonium, Tasyen, HerlySQR, Forsakn and Troll-Brain

What this does:
Allows you to postpone the initialization of your script until a specific point in the loading sequence.
Additionally, all callback functions in this resource are safely called via xpcall or pcall, giving you highly valuable debugging information.
Also provides the ability to Require another resource. This functions similarly to Lua's "require" method, which was disabled in the WarCraft 3 environment.

Why not just use do...end blocks in the Lua root?
Creating WarCraft 3 objects in the Lua root has been reported to cause desyncs. Even still, the Lua root is a weird place to initialize
(e.g. doesn't allow "print", which makes debugging extremely difficult). do...end blocks force you to organize your triggers from top to bottom based on their requirements.

What is the sequence of events?
1) On...Init functions that require nothing - or - already have their requirements fulfilled in the Lua root.
2) On...Init functions that have their requirements fulfilled based on other On...Init declarations.
3) Repeat step 2 until all executables are loaded and all subsequent initializers have run.
4) OnGameStart is the final initializer.
5) Display an error message to reveal any missing requirements.

Basic API for initializer functions:
OnGlobalInit(function()
    print "All udg_ variables have been initialized"
end)
OnTrigInit(function()
    print "All InitTrig_ functions have been called"
end)
OnMapInit(function()
    print "All Map Initialization events have run"
end)
OnGameStart(function()
    print "The game has now started"
end)

Note: You can optionally include a string as an argument to give your initializer a name. This is useful in two scenarios:
      1) If you don't add anything to the global API but want it to be useful as a requirment.
      2) If you want it to be accurately defined for initializers that optionally require it.

API for Requirements:
local someLibrary = Require "SomeLibrary"
> Imitates Lua's built-in (but disabled in WarCraft 3) "require" method, provided that you use it from an On...Init or OnGameStart callback function.

local optionalRequirement = Require "OptionalRequirement"
> Similar to the Require method, but will only wait if the optional requirement was declared in an On...Init string parameter.

--------------
CONFIGURABLES:       ]==]
do
    --change this assignment to false or nil if you don't want to print any caught errors at the start of the game.
    --You can otherwise change the color code to a different hex code if you want.
    local _ERROR           = "ff5555"
    
    local _USE_COROUTINES  = true       --Change this to false if you don't use the "Require" API.
    local _USE_LIBRARY_API = true       --Change this to false if you don't use the "library" API.
    
    --END CONFIGURABLES
    -------------------
    
    local _G     = _G
    local rawget = rawget
    local insert = table.insert
    
    local function doesVariableExist(name) --added for readability.
        return rawget(_G, name)~=nil
    end
    
    local printError = DoNothing
    local errorQueue
    if _ERROR then
        errorQueue = {}
        printError = function(errorMsg)
            insert(errorQueue, "|cff".._ERROR..errorMsg.."|r")
        end
    end
    local library
    if _USE_LIBRARY_API then
        library = {
            declarations = {},
            initQueue    = {},
            loaded       = {},
            initiallyMissingRequirements = _ERROR and {},
            initialize = function(forceOptional)
                if library.initQueue[1] then
                   
                    local continue, tempInitQueue
                    repeat
                        continue=false
                       
                        library.initQueue, tempInitQueue = {}, library.initQueue
                       
                        for _,func in ipairs(tempInitQueue) do
                            if func(forceOptional) then
                                --Something was initialized; therefore further systems might be able to initialize.
                                continue=true
                            else
                                --If the queued initializer returns false, that means it did not run, so we re-add it.
                                insert(library.initQueue, func)
                            end
                        end
                    until not continue or not library.initQueue[1]
                end
            end
        }
    end
    
    local runInitializer = {}
    local oldInitBlizzard = InitBlizzard
    InitBlizzard = function()
        runInitializer["OnMainInit"](true) --now we are safely outside of the Lua root and can start initializing.
        oldInitBlizzard()
    
        --Try to hook, if the variable doesn't exist, run the initializer immediately. Once either have executed, call the continue function.
        local function tryHook(whichHook, whichInit, continue)
            local hookedFunction = rawget(_G, whichHook)
            if hookedFunction then
                _G[whichHook] = function()
                    hookedFunction()
                    runInitializer[whichInit]()
                    continue()
                end
            else
                runInitializer[whichInit]()
                continue()
            end
        end
        tryHook("InitGlobals", "OnGlobalInit", function()
            tryHook("InitCustomTriggers", "OnTrigInit", function()
                tryHook("RunInitializationTriggers", "OnMapInit", function()
                   
                    local function runOnGameStart()
                        runInitializer["OnGameStart"]()
                        runInitializer=nil
                        if _ERROR then
                            if _USE_LIBRARY_API and library.initQueue[1] then
                                for _,ini in ipairs(library.initiallyMissingRequirements) do
                                    if not doesVariableExist(ini) and not library.loaded[ini] then
                                        printError("OnLibraryInit missing requirement: "..ini)
                                    end
                                end
                            end
                            for _,msg in ipairs(errorQueue) do
                                print(msg) --now that the game has started, call the queued error messages.
                            end
                            errorQueue=nil
                        end
                        library=nil
                    end
    
                    --Use a timer to mark when the game has actually started.
                    TimerStart(CreateTimer(), 0, false, function()
                        DestroyTimer(GetExpiredTimer())
    
                        runOnGameStart()
                    end)
                end)
            end)
        end)
    end
    
    local function callUserInitFunction(initFunc, name, initDeclaresItsName)
        local function initFuncWrapper()
            local function funcWrapper()
                initFunc()
                if _USE_LIBRARY_API and initDeclaresItsName then
                    library.loaded[initDeclaresItsName]=true
                end
            end
            if _ERROR then
                if try then try(funcWrapper) --https://www.hiveworkshop.com/threads/debug-utils-ingame-console-etc.330758/post-3552846
                else
                    xpcall(funcWrapper, function(msg)
                        xpcall(error, printError, "\nGlobal Initialization Error with "..name..":\n"..msg, 4)
                    end)
                end
            else
                pcall(funcWrapper)
            end
        end
        if _USE_COROUTINES then
            coroutine.resume(coroutine.create(initFuncWrapper))
        else
            initFuncWrapper()
        end
    end
    
    ---Handle logic for initialization functions that wait for certain initialization points during the map's loading sequence.
    ---@param name string
    ---@return fun(libName?:string|fun(), userFunc:fun()|string) OnInit --Calls userFunc during the defined initialization stage.
    local function createInitAPI(name)
        local userInitFunctionList = {}
       
        --Create a handler function to run all initializers pertaining to this particular sequence.
        runInitializer[name]=function(skipLibrary)
            local function initialize()
                for _,f in ipairs(userInitFunctionList) do
                    callUserInitFunction(f, name, _USE_LIBRARY_API and library.declarations[f])
                end
                userInitFunctionList=nil
                _G[name] = nil
            end
            if _USE_LIBRARY_API and not skipLibrary then
                library.initialize()
                initialize()
                library.initialize()
                library.initialize(true) --force libraries with optional requirements to run.
            else
                initialize()
            end
        end
    
        ---Calls userFunc during the map loading process.
        ---@param libName string|fun()
        ---@param userFunc fun()|string
        return function(libName, userFunc)
            if not userFunc or type(userFunc)=="string" then
                libName,userFunc=userFunc,libName
            end
            if type(userFunc) == "function" then
                insert(userInitFunctionList, userFunc)
                if _USE_LIBRARY_API and libName then
                    library.declarations[userFunc] = libName
                    library.loaded[libName]=library.loaded[libName] or false
                end
            else
                printError(name.." Error: function expected, got "..type(userFunc))
            end
        end
    end
    OnMainInit   = createInitAPI("OnMainInit")    -- Runs "before" InitBlizzard is called. Might not actually have any benefit over OnGlobalInit and might be deprecated at some future point.
    OnGlobalInit = createInitAPI("OnGlobalInit")  -- Runs once all GUI variables are instantiated.
    OnTrigInit   = createInitAPI("OnTrigInit")    -- Runs once all InitTrig_ are called.
    OnMapInit    = createInitAPI("OnMapInit")     -- Runs once all Map Initialization triggers are run.
    OnGameStart  = createInitAPI("OnGameStart")   -- Runs once the game has actually started.
    
    if _USE_LIBRARY_API then
    
        ---Might be deprecated at some future point in favor of Require, Require.optional and On...Init functions which declare a name string.
        ---@param whichInit string|table
        ---@param userFunc fun()
        function OnLibraryInit(whichInit, userFunc)
            local  nameOfInit
            local  typeOfInit =         type(whichInit)
            if     typeOfInit=="string" then whichInit = {whichInit}
            elseif typeOfInit~="table"  then
                printError("Invalid requirement type passed to OnLibraryInit: "..typeOfInit)
                return
            else
                nameOfInit = whichInit.name
                if nameOfInit then
                    library.loaded[nameOfInit]=false
                end
            end
            if _ERROR then
                for _,initName in ipairs(whichInit) do
                    if not doesVariableExist(initName) then
                        insert(library.initiallyMissingRequirements, initName)
                    end
                end
            end
            insert(library.initQueue, function(forceOptional)
                if whichInit then
                    for _,initName in ipairs(whichInit) do
                        --check all strings in the table and make sure they exist in _G or were already initialized by OnLibraryInit with a non-global name.
                        if not doesVariableExist(initName) and not library.loaded[initName] then return end
                    end
                    if not forceOptional and whichInit.optional then
                        for _,initName in ipairs(whichInit.optional) do
                            --If the item isn't yet initialized, but is queued to initialize, then we postpone the initialization.
                            --Declarations would be made in the Lua root, so if optional dependencies are not found by the time
                            --OnLibraryInit runs its triggers, we can assume that it doesn't exist in the first place.
                            if not doesVariableExist(initName) and library.loaded[initName]==false then return end
                        end
                    end
                    whichInit = nil --flag as nil to prevent recursive calls.
                   
                    --run the initializer if all requirements either exist in _G or have been fully declared.
                    callUserInitFunction(userFunc, "OnLibraryInit", nameOfInit)
                    return true
                end
            end)
        end
    end
    
    if _USE_LIBRARY_API and _USE_COROUTINES then
        local function addReq(optional, ...)
            if not doesVariableExist(...) and not optional or library.loaded[...]==false then
                local co = coroutine.running()
                OnLibraryInit(optional and {optional={...}} or {...}, function() coroutine.resume(co) end)
                coroutine.yield(co)
            end
            return rawget(_G, ...) or library.loaded[...]
        end
        ---@class Require
        ---@field __call fun(requirement: string):any       --local requirement = Require "SomeRequirement"     --Patiently waits for the requirement and returns it
        ---@field optional fun(requirement: string):any     --local optReq = Require.optional "SomethingElse"   --Impatiently waits for the requirement and returns it
        Require = {
            __call   = function(_, ...)  return addReq(false, ...) end,
            optional = function(...)     return addReq(true,  ...) end
        }
        setmetatable(Require, Require)
    end
    
    end