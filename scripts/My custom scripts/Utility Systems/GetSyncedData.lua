OnLibraryInit({name = "GetSyncedData",
    "LinkedList", -- https://www.hiveworkshop.com/threads/definitive-doubly-linked-list.339392/
    "Obj2Str"}, function ()

    local PREFIX = "SYNC"

    local threads = LinkedList.create()

    ---@param co thread
    local function EnqueueThread(co)
        threads:insert(co)
    end

    ---@return thread
    local function DequeueThread()
        local node = threads:getNext() ---@type LinkedList
        local co = node.value
        node:remove()
        return co
    end

    ---Syncs the value of the player of the returned value of the given function,
    ---you can also pass the parameters of the function.
    ---
    ---Or you can pass an array (table) with various functions to sync and the next
    ---index of each function should be an array (table) with its arguments, and then the returned
    ---value is an array (table) with the results in the order you set them.
    ---
    ---The sync takes time, so the function yields the thread until the data is synced.
    ---
    ---Be careful, because if the returned value converted to string has a length greater
    ---than 247 the system returns an error.
    ---@generic T
    ---@param p player
    ---@param func fun(...?: any): T || table
    ---@param ...? any
    ---@return T | table
    function GetSyncedData(p, func, ...)
        if p == GetLocalPlayer() then
            if type(func) == "function" then
                BlzSendSyncData(PREFIX, Obj2Str(func(...)))
            elseif type(func) == "table" then
                local result = {}
                for i = 1, #func, 2 do
                    table.insert(result, func[i](table.unpack(func[i+1])))
                end
                BlzSendSyncData(PREFIX, Obj2Str(result))
            else
                error("Invalid parameter", 2)
            end
        end

        EnqueueThread(coroutine.running())

        local success, value = coroutine.yield()

        if not success then
            error("Error during the conversion", 2)
        end

        return value
    end

    OnTrigInit(function ()
        local t = CreateTrigger()
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            BlzTriggerRegisterPlayerSyncEvent(t, Player(i), PREFIX, false)
        end
        TriggerAddAction(t, function ()
            coroutine.resume(DequeueThread(), pcall(Str2Obj, BlzGetTriggerSyncData()))
        end)
    end)
end)