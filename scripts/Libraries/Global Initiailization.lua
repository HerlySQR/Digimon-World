do -- Global Initialization 3.0.0.1
    -- Special thanks to Tasyen, Forsakn and Troll-Brain

    local call = pcall
    if try then call = try end --Requires optional Error Console by Eikonium: https://www.hiveworkshop.com/threads/lua-debug-utils-ingame-console-etc.330758

    local PRINT_CAUGHT_ERRORS = true
    local errors = {}

    local gFuncs = {}
    local tFuncs = {}
    local iFuncs = {}
    local sFuncs = {}

    function OnGlobalInit(func) -- Runs once all variables are instantiated.
        gFuncs[#gFuncs+1] = func
    end

    function OnTrigInit(func) -- Runs once all InitTrig_ are called
        tFuncs[#tFuncs+1] = func
    end

    function OnMapInit(func) -- Runs once all Map Initialization triggers are run
        iFuncs[#iFuncs+1] = func
    end

    function OnGameStart(func) -- Runs once the game has actually started
        sFuncs[#sFuncs+1] = func
    end

    local function saveError(where, error)
        if not PRINT_CAUGHT_ERRORS then return end
        errors[#errors+1] = "Global Initialization: caught error in " .. where .. ": " .. error
    end

    local function printErrors()
        if #errors < 1 then return end
        print("|cffff0000Global Initialization: " .. #errors .. " errors occured during Initialization.|r")
        for _, error in ipairs(errors) do
            print(error)
        end
        errors = nil
    end

    local function run(list, name)
        for _, func in ipairs(list) do
            local result, error = call(func)
            if not result then
                saveError(name, error)
            end
        end
    end

    local function runInitialization()
        run(iFuncs, "OnMapInit")
        iFuncs = nil
    end

    local function runTriggerInit()
        run(tFuncs, "OnTrigInit")
        tFuncs = nil

        local old = RunInitializationTriggers
        if old then
            function RunInitializationTriggers()
                old()
                runInitialization()
            end
        else
            runInitialization()
        end
    end

    local function runGlobalInit()
        run(gFuncs, "OnGlobalInit")
        gFuncs = nil

        local old = InitCustomTriggers
        if old then
            function InitCustomTriggers()
                old()
                runTriggerInit()
            end
        else
            runTriggerInit()
        end
    end

    local oldBliz = InitBlizzard
    function InitBlizzard()
        oldBliz()

        local old = InitGlobals
        if old then
            function InitGlobals()
                old()
                runGlobalInit()
            end
        else
            runGlobalInit()
        end

        -- Start timer to run gamestart-functions and then print all caught errors if PRINT_CAUGHT_ERRORS
        TimerStart(CreateTimer(), 0.00, false, function()
            DestroyTimer(GetExpiredTimer())

            run(sFuncs, "OnGameStart")
            sFuncs = nil
            if PRINT_CAUGHT_ERRORS then
                printErrors()
            end
        end)
    end
 end--End of Global Initialization