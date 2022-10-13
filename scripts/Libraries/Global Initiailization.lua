do  --Global Initialization 4.1.0.0

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
    
    local prePrint,run={},{}
    local initInitializers
    local _G        = _G
    local rawget    = rawget
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
    
    local initHandlerQueue, initHandlerExists, missingRequirements
    
    initInitializers=function()
        initInitializers = DoNothing
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
        local checkStr=function(s) return rawget(_G, s) and s end
        --try to hook anything that could be called before InitBlizzard to see if we can initialize even sooner
        local hookAt =
            checkStr("InitSounds") or
            checkStr("CreateRegions") or
            checkStr("CreateCameras") or
            checkStr("InitUpgrades") or
            checkStr("InitTechTree") or
            checkStr("CreateAllDestructables") or
            checkStr("CreateAllItems") or
            checkStr("CreateAllUnits") or
            checkStr("InitBlizzard")
        local oldMain=rawget(_G, hookAt)
        rawset(_G, hookAt, function()
            run["OnMainInit"]()
            oldMain()
            hook("InitGlobals", "OnGlobalInit", function()
                hook("InitCustomTriggers", "OnTrigInit", function()
                    hook("RunInitializationTriggers", "OnMapInit", function()
                        TimerStart(CreateTimer(), 0.00, false, function()
                            DestroyTimer(GetExpiredTimer())
                            run["OnGameStart"]()
                            run=nil
                            if initHandlerQueue then
                                if #initHandlerQueue>0 then
                                    for _,ini in ipairs(missingRequirements) do
                                        if not rawget(_G, ini) and not rawget(initHandlerExists, ini) then
                                            displayError("OnLibraryInit missing requirement: "..ini)
                                        end
                                    end
                                end
                                initHandlerQueue=nil
                                initHandlerExists=nil
                                missingRequirements=nil
                            end
                            for i=1, #prePrint do oldPrint(prePrint[i]) end
                            prePrint=nil
                            if print==newPrint then print=oldPrint end --restore the function only if no other functions have overriden it.
                        end)
                    end)
                end)
            end)
        end)
    end
    
    local function callUserInitFunction(initFunc, name)
        xpcall(initFunc, function(msg)
            xpcall(error, displayError, "\nGlobal Initialization Error with "..name..":\n"..msg, 4)
        end)
    end

    for _,name in ipairs({
        "OnMainInit",    -- Runs "before" InitBlizzard is called. Meant for assigning things like hooks.
        "OnGlobalInit",  -- Runs once all GUI variables are instantiated.
        "OnTrigInit",    -- Runs once all InitTrig_ are called.
        "OnMapInit",     -- Runs once all Map Initialization triggers are run.
        "OnGameStart"    -- Runs once the game has actually started.
    }) do
        local funcs={}
        --Add On..Init to the global API for users to call.
        rawset(_G, name, function(func)
            funcs[#funcs+1]=type(func)=="function" and func or load(func)
            initInitializers()
        end)
        --Create a handler function to run all initializers pertaining to this initialization level.
        run[name]=function()
            for _,f in ipairs(funcs) do
                callUserInitFunction(f, name)
            end
            funcs=nil
            rawset(_G, name, nil)
            --I encountered some bugs with allowing libraries to initialize in sync with OnMainInit, so I need to exclude that block.
            if initHandlerQueue and name ~= "OnMainInit" then
                ::runAgain::
                local runRecursively,tempQ
                tempQ,initHandlerQueue=initHandlerQueue,{}
                
                for _,func in ipairs(tempQ) do
                    --If the queued initializer returns true, that means it ran, so we can remove it.
                    if func() then
                        runRecursively=true
                    else
                        table.insert(initHandlerQueue, func)
                    end
                end
                if runRecursively and #initHandlerQueue > 0 then
                    --Something was initialized, which might mean that further systems can now be initialized.
                    goto runAgain
                end
            end
        end
    end
    
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
    ---@param initFunc fun()
    function OnLibraryInit(whichInit, initFunc)
        if not initHandlerQueue then
            initInitializers()
            initHandlerQueue={} ---@type function[] fun():boolean
            initHandlerExists={}
            missingRequirements={}
        end
        local initName=""
        local runInit;runInit=function()
            runInit=nil --nullify itself to prevent potential recursive calls during initFunc's execution.
            
            callUserInitFunction(initFunc, initName)
            return true
        end
        local initFuncHandler
        if type(whichInit)=="string" then
            initName=whichInit
            if not rawget(_G, initName) and not rawget(missingRequirements, initName) then
                table.insert(missingRequirements, initName)
            end
            initFuncHandler=function() return runInit and rawget(_G, whichInit) and runInit() end
        elseif type(whichInit)=="table" then
            initFuncHandler=function()
                if runInit then
                    for _,ini in ipairs(whichInit) do
                        --check all strings in the table and make sure they exist in _G or were already initialized by OnLibraryInit with a non-global name.
                        if not rawget(_G, ini) and not rawget(initHandlerExists, ini) then return end
                    end
                    if whichInit.optional then
                        for _,ini in ipairs(whichInit.optional) do
                            --If the item isn't yet initialized, but is queued to initialize, then we postpone the initialization.
                            --Declarations would be made in the Lua root, so if optional dependencies are not found by the time
                            --OnLibraryInit runs its triggers, we can assume that it doesn't exist in the first place.
                            if not rawget(_G, ini) and rawget(initHandlerExists, ini)==false then return end
                        end
                    end
                    if whichInit.name then
                        initHandlerExists[whichInit.name]=true
                    end
                    --run the initializer if all requirements either exist in _G or have been loaded by OnLibraryInit.
                    return runInit()
                end
            end
            if whichInit.name then
                initHandlerExists[whichInit.name]=false
            end
            for _,ini in ipairs(whichInit) do
                if not rawget(_G, ini) then
                    table.insert(missingRequirements, ini)
                end
            end
        else
            displayError("Invalid requirement type passed to OnLibraryInit")
            return
        end
        table.insert(initHandlerQueue, initFuncHandler)
    end
end