if Debug then Debug.beginFile("GetSyncedData") end
OnInit("GetSyncedData", function ()
    Require "LinkedList" -- https://www.hiveworkshop.com/threads/definitive-doubly-linked-list.339392/
    Require "Obj2Str" -- https://www.hiveworkshop.com/pastebin/65b5fc46fc82087ba24609b14f2dc4ff.25120

    local PREFIX = "SYNC"
    local END_PREFIX = "END_SYNC"
    local BLOCK_LENGHT = 246

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
    ---@async
    ---@generic T
    ---@param p player
    ---@param func fun(...): T || table
    ---@vararg any
    ---@return T | table
    function GetSyncedData(p, func, ...)
        if type(func) == "function" then
            if p == GetLocalPlayer() then
                Sync(Obj2Str(func(...)))
            end
        elseif type(func) == "table" then
            if p == GetLocalPlayer() then
                local result = {}
                for i = 1, #func, 2 do
                    table.insert(result, func[i](table.unpack(func[i+1])))
                end
                Sync(Obj2Str(result))
            end
        else
            error("Invalid parameter", 2)
        end

        EnqueueThread(coroutine.running())

        local success, value = coroutine.yield() ---@type boolean, T | table

        if not success then
            error("Error during the conversion", 2)
        end

        return value
    end

    local actString = ""

    local t = CreateTrigger()
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        BlzTriggerRegisterPlayerSyncEvent(t, Player(i), PREFIX, false)
        BlzTriggerRegisterPlayerSyncEvent(t, Player(i), END_PREFIX, false)
    end
    TriggerAddAction(t, function ()
        actString = actString .. BlzGetTriggerSyncData()
        if BlzGetTriggerSyncPrefix() == END_PREFIX then
            coroutine.resume(DequeueThread(), pcall(Str2Obj, actString))
            actString = ""
        end
    end)
end)
if Debug then Debug.endFile() end