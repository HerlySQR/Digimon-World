do  --Global Initialization 4.2.0.1

    --4.2 adds Require and Require.optional to the API. You can now declare libraries
    --via a string parameter passed to On...Init and OnGameStart. You can add requirements
    --during the initialization process via Require "something" or optional requirements
    --via Require.optional "somethingElse". Requirements must be listed at the top of
    --the function you registered to On...Init.
    --OnLibraryInit will still treat a string parameter as a requirement, rather than as
    --a library name.

    --4.1 adds optional requirements to OnLibraryInit, and gives the option to specify
    --the name of your library.
    
    --4.0 introduces "OnLibraryInit", which will delay the running of the function
    --until certain variable(s) are present in the global table. This means that
    --only Global Initialization needs to be placed as the top trigger in your map,
    --and any resources which use OnLibraryInit to wait for each other can be found
    --in any order below that.
    
    --Special thanks to Tasyen, Forsakn, Troll-Brain and Eikonium
    
    --change this assignment to false or nil if you don't want to print any caught errors at the start of the game.
    --You can otherwise change the color code to a different hex code if you want.
    local _ERROR    = "ff5555"
    
    local prePrint,run,genericDeclarations,initHandlerExists={},{},{},{}
    local initInitializers
    local _G        = _G
    local rawget    = rawget
    local insert    = table.insert
    local oldPrint  = print
    local newPrint  = function(s)
        if prePrint then
            initInitializers()
            prePrint[#prePrint+1]=s
        else
            oldPrint(s)
        end
    end
    print           = newPrint
    
    local displayError=_ERROR and function(errorMsg)
        print("|cff".._ERROR..errorMsg.."|r")
    end or DoNothing
    
    local libraryInitQueue, missingRequirements
    
    initInitializers=function()
        initInitializers = DoNothing
        --try to hook anything that could be called before InitBlizzard to see if we can initialize even sooner
        for _,hookAt in ipairs {
            "InitSounds",
            "CreateRegions",
            "CreateCameras",
            "InitUpgrades",
            "InitTechTree",
            "CreateAllDestructables",
            "CreateAllItems",
            "CreateAllUnits",
            "InitBlizzard"
        } do
            local oldMain=rawget(_G, hookAt)
            if oldMain then
                rawset(_G, hookAt, function()
                    run["OnMainInit"]()
                    oldMain()
                    local function hook(oldFunc, userFunc, chunk)
                        local old = rawget(_G, oldFunc)
                        if old then
                            rawset(_G, oldFunc, function()
                                old()
                                run[userFunc]()
                                chunk()
                            end)
                        else
                            run[userFunc]()
                            chunk()
                        end
                    end
                    hook("InitGlobals", "OnGlobalInit", function()
                        hook("InitCustomTriggers", "OnTrigInit", function()
                            hook("RunInitializationTriggers", "OnMapInit", function()
                                TimerStart(CreateTimer(), 0.00, false, function()
                                    DestroyTimer(GetExpiredTimer())
                                    run["OnGameStart"]()
                                    run=nil
                                    if libraryInitQueue then
                                        if _ERROR and #libraryInitQueue>0 then
                                            for _,ini in ipairs(missingRequirements) do
                                                if not rawget(_G, ini) and not initHandlerExists[ini] then
                                                    displayError("OnLibraryInit missing requirement: "..ini)
                                                end
                                            end
                                        end
                                        libraryInitQueue=nil
                                    end
                                    missingRequirements=nil
                                    genericDeclarations=nil
                                    initHandlerExists=nil
                                    for i=1, #prePrint do oldPrint(prePrint[i]) end
                                    prePrint=nil
                                    if print==newPrint then print=oldPrint end --restore the function only if no other functions have overriden it.
                                end)
                            end)
                        end)
                    end)
                end)
                break
            end
        end
    end
    
    local state
    local function callUserInitFunction(initFunc, name, declareNameReady)
        state = coroutine.create(function()
            xpcall(initFunc, function(msg)
                xpcall(error, displayError, "\nGlobal Initialization Error with "..name..":\n"..msg, 4)
            end)
            if declareNameReady then
                initHandlerExists[declareNameReady]=true
            end
        end)
        coroutine.resume(state)
    end

    local function initLibraries(name)
        --I encountered some bugs with allowing libraries to initialize in sync with OnMainInit, so I need to exclude that block.
        if libraryInitQueue and name ~= "OnMainInit" then
            ::runAgain::
            local runRecursively,tempQ
            tempQ,libraryInitQueue=libraryInitQueue,{}
            
            for _,func in ipairs(tempQ) do
                --If the queued initializer returns true, that means it ran, so we can remove it.
                if func() then
                    runRecursively=runRecursively or coroutine.status(state)~="suspended"
                else
                    insert(libraryInitQueue, func)
                end
            end
            if runRecursively and #libraryInitQueue > 0 then
                --Something was initialized, which might mean that further systems can now be initialized.
                goto runAgain
            end
        end
    end

    ---Handle logic for initialization functions that wait for certain initialization points during the map's loading sequence.
    ---@param name string
    ---@return fun() userFunc --Calls userFunc during the defined initialization stage.
    local function createInitAPI(name)
        local funcs={}
        --Create a handler function to run all initializers pertaining to this initialization level.
        run[name]=function()
            initLibraries(name)
            for _,f in ipairs(funcs) do
                callUserInitFunction(f, name, genericDeclarations[f])
            end
            funcs=nil
            rawset(_G, name, nil)
            initLibraries(name)
        end
        ---Calls userFunc during the map loading process.
        ---@param libName string
        ---@param userFunc fun()
        return function(libName, userFunc)
            if not userFunc or type(userFunc)=="string" then
                libName,userFunc=userFunc,libName
            end
            if type(userFunc) == "function" then
                funcs[#funcs+1]=userFunc
                if libName then
                    genericDeclarations[userFunc] = libName
                    initHandlerExists[libName]=initHandlerExists[libName] or false
                end
                initInitializers()
            else
                displayError(name.." Error: function expected, got "..type(userFunc))
            end
        end
    end
    
    OnMainInit   = createInitAPI("OnMainInit")    -- Runs "before" InitBlizzard is called. Meant for assigning things like hooks.
    OnGlobalInit = createInitAPI("OnGlobalInit")  -- Runs once all GUI variables are instantiated.
    OnTrigInit   = createInitAPI("OnTrigInit")    -- Runs once all InitTrig_ are called.
    OnMapInit    = createInitAPI("OnMapInit")     -- Runs once all Map Initialization triggers are run.
    OnGameStart  = createInitAPI("OnGameStart")   -- Runs once the game has actually started.

    ---OnLibraryInit is a new function that allows your initialization to wait until others items exist.
    ---This is comparable to vJass library requirements in that you can specify your "library" to wait for
    ---those other libraries to be initialized, before initializing your own.
    ---For example, if you want to ensure your script is processed after "GlobalRemap" has been declared,
    ---you would use:
    ---OnLibraryInit("GlobalRemap", function() print "my library is initializing after GlobalRemap was declared" end)
    ---
    ---To include multiple requirements, pass a string table:
    ---OnLibraryInit({"GlobalRemap", "LinkedList", "MDTable"}, function() print "my library has waited for 3 requirements" end)
    ---To have optional requirements or to have named libraries (names are only useful for requirements):
    ---OnLibraryInit({name="MyLibrary", "MandatoryRequirement", optional={OptionalRequirement1, OptionalRequirement2}})
    ---@param whichInit string|table
    ---@param userFunc fun()
    function OnLibraryInit(whichInit, userFunc)
        if not libraryInitQueue then
            initInitializers()
            libraryInitQueue={} ---@type function[] fun():boolean
            missingRequirements=_ERROR and {}
        end
        local runInit;runInit=function()
            runInit=nil --nullify itself to prevent potential recursive calls during initFunc's execution.
            
            callUserInitFunction(userFunc, "OnLibraryInit", type(whichInit)=="table" and whichInit.name)
            return true
        end
        local initFuncHandler
        if type(whichInit)=="string" then
            if _ERROR and not rawget(_G, whichInit) and not missingRequirements[whichInit] then
                insert(missingRequirements, whichInit)
            end
            initFuncHandler=function() return runInit and rawget(_G, whichInit) and runInit() end
        elseif type(whichInit)=="table" then
            initFuncHandler=function()
                if runInit then
                    for _,initName in ipairs(whichInit) do
                        --check all strings in the table and make sure they exist in _G or were already initialized by OnLibraryInit with a non-global name.
                        if not rawget(_G, initName) and not initHandlerExists[initName] then return end
                    end
                    if whichInit.optional then
                        for _,initName in ipairs(whichInit.optional) do
                            --If the item isn't yet initialized, but is queued to initialize, then we postpone the initialization.
                            --Declarations would be made in the Lua root, so if optional dependencies are not found by the time
                            --OnLibraryInit runs its triggers, we can assume that it doesn't exist in the first place.
                            if not rawget(_G, initName) then
                                if initHandlerExists[initName]==false then return end
                                rawset(_G, initName, false)
                            end
                        end
                    end
                    --run the initializer if all requirements either exist in _G or have been loaded by OnLibraryInit.
                    return runInit()
                end
            end
            if whichInit.name then
                initHandlerExists[whichInit.name]=false
            end
            if _ERROR then
                for _,initName in ipairs(whichInit) do
                    if not rawget(_G, initName) then
                        insert(missingRequirements, initName)
                    end
                end
            end
        else
            displayError("Invalid requirement type passed to OnLibraryInit: "..type(whichInit))
            return
        end
        insert(libraryInitQueue, initFuncHandler)
    end

    local function addReq(name, optional)
        if not rawget(_G, name) then
            local co = coroutine.running()
            OnLibraryInit(optional and {optional={name}} or name, function() coroutine.resume(co) end)
            coroutine.yield(co)
        end
    end
    Require = {
        __call   = function(_, name)                                     addReq(name)           end,
        optional = function(name) if initHandlerExists[name]==false then addReq(name, true) end end
    }
    setmetatable(Require, Require)
end