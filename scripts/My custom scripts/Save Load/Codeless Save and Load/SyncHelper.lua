OnLibraryInit({name = "SyncHelper"}, function ()
    SyncHelper = {
        SYNC_PREFIX = "S"
    }

    local trig = nil ---@type trigger

    OnTrigInit(function ()
        trig = CreateTrigger()
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            BlzTriggerRegisterPlayerSyncEvent(trig, Player(i), SyncHelper.SYNC_PREFIX, false)
        end
    end)

    ---@param s string
    ---@return boolean
    function SyncString(s)
        return BlzSendSyncData(SyncHelper.SYNC_PREFIX, s)
    end

    ---@param func function
    ---@return triggeraction
    function OnSyncString(func)
        return TriggerAddAction(trig, func)
    end

    ---@param t triggeraction
    function RemoveSyncString(t)
        TriggerRemoveAction(trig, t)
    end
end)