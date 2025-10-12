if Debug then Debug.beginFile("GetSyncedData") end
OnInit("GetSyncedData", function ()
    Require "Obj2Str" -- https://www.hiveworkshop.com/pastebin/65b5fc46fc82087ba24609b14f2dc4ff.25120
    Require "Timed"

    local PREFIX = "GetSyncedData__SYNC"
    local END_PREFIX = "GetSyncedData__END_SYNC"
    local BLOCK_LENGHT = 246
    local MAX_WAIT = 5 -- in seconds

    local LocalPlayer = GetLocalPlayer()
    local callbacks = {} ---@type (fun(noSync: boolean?): thread)[]
    local actString = ""
    local actThread = nil ---@type thread
    local areWaiting = {} ---@type table<thread, thread[]>
    local areSyncs = false

    ---@param s string
    local function Sync(s)
        while true do
            local sub = s:sub(1, BLOCK_LENGHT)
            s = s:sub(BLOCK_LENGHT + 1)
            if s:len() > 0 then
                BlzSendSyncData(PREFIX, sub)
            else
                BlzSendSyncData(END_PREFIX, sub)
                break
            end
        end
    end

    ---Syncs the value of the player of the returned value of the given function,
    ---you can also pass the parameters of the function.
    ---
    ---Or you can pass an array (table) with various functions to sync and the next
    ---index of each function should be an array (table) with its arguments, and then the returned
    ---value is an array (table) with the results in the order you set them.
    ---
    ---The sync takes time, so the function yields the thread until the data is synced.
    ---If you call this function from a non in-game player, it raises an error.
    ---If the sync takes too much (or is aborted because the player left), it will return nil
    ---@async
    ---@overload fun(p: player, func: table): table
    ---@generic T
    ---@param p player
    ---@param func fun(...): T
    ---@vararg any
    ---@return T | nil
    function GetSyncedData(p, func, ...)
        if not (GetPlayerController(p) == MAP_CONTROL_USER and GetPlayerSlotState(p) == PLAYER_SLOT_STATE_PLAYING) then
            error("The player " .. GetPlayerName(p) .. " is not an in-game player.", 2)
        end

        local data = ""
        if type(func) == "function" then
            if p == LocalPlayer then
                data = Obj2Str(func(...))
            end
        elseif type(func) == "table" then
            if p == LocalPlayer then
                local result = {}
                for i = 1, #func, 2 do
                    table.insert(result, func[i](func[i+1] and table.unpack(func[i+1])))
                end
                data = Obj2Str(result)
            end
        else
            error("Invalid parameter", 2)
        end

        local t = coroutine.running()

        table.insert(callbacks, function (noSync)
            if not noSync and p == LocalPlayer then
                Sync(data)
            end
            return t
        end)

        if #callbacks == 1 then
            actThread = callbacks[1]()
        end

        local cancel = Timed.call(MAX_WAIT, function ()
            if coroutine.status(t) == "suspended" then
                coroutine.resume(t, false, nil)
                if areWaiting[t] then
                    for _, thr in ipairs(areWaiting[t]) do
                        coroutine.resume(thr)
                    end
                    areWaiting[t] = nil
                end
                for i = 1, #callbacks do
                    if callbacks[i](true) == t then
                        table.remove(callbacks, i)
                        break
                    end
                end
            end
        end)

        areSyncs = true
        local success, value = coroutine.yield() ---@type boolean, T | table

        cancel(false)

        if not success then
            error("Error during the conversion", 2)
        end

        return value
    end

    ---Yields the thread until last sync called from `GetSyncedData` ends.
    ---
    ---It does nothing if there isn't a queued sync from `GetSyncedData` or is the thread that function yielded or is yielded for another reason.
    function WaitLastSync()
        if areSyncs then
            local thr = coroutine.running()
            local last = callbacks[#callbacks](true)
            if last == thr or coroutine.status(thr) == "suspended" then
                return
            end
            if not areWaiting[last] then
                areWaiting[last] = {}
            end
            table.insert(areWaiting[last], thr)
            coroutine.yield(thr)
        end
    end

    local t = CreateTrigger()
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        BlzTriggerRegisterPlayerSyncEvent(t, Player(i), PREFIX, false)
        BlzTriggerRegisterPlayerSyncEvent(t, Player(i), END_PREFIX, false)
    end
    TriggerAddAction(t, function ()
        actString = actString .. BlzGetTriggerSyncData()
        if BlzGetTriggerSyncPrefix() == END_PREFIX then
            table.remove(callbacks, 1)

            local thre = nil
            if #callbacks > 0 then
                thre = callbacks[1]()
            else
                areSyncs = false
            end

            coroutine.resume(actThread, pcall(Str2Obj, actString))

            if areWaiting[actThread] then
                for _, thr in ipairs(areWaiting[actThread]) do
                    coroutine.resume(thr)
                end
                areWaiting[actThread] = nil
            end

            actThread = thre or actThread -- Is nil if there are no more callbacks
            actString = ""
        end
    end)
end)
if Debug then Debug.endFile() end