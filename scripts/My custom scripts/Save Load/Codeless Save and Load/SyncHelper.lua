OnInit("SyncHelper", function ()
    local SYNC_PREFIX = "S"

    local syncTrigger ---@type trigger

    ---@param s string
    ---@return boolean
    function SyncString(s)
        return BlzSendSyncData(SYNC_PREFIX, s)
    end

    ---@param func function
    ---@return triggeraction
    function OnSyncString(func)
        return TriggerAddAction(syncTrigger, func)
    end

    ---@param t triggeraction
    function RemoveSyncString(t)
        TriggerRemoveAction(syncTrigger, t)
    end

    OnInit.trig(function ()
        syncTrigger = CreateTrigger()
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            BlzTriggerRegisterPlayerSyncEvent(syncTrigger, Player(i), SYNC_PREFIX, false)
        end
    end)
end)