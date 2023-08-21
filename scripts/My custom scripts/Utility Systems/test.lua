Debug.beginFile("test wait")
OnInit(function ()
    Require "GetSyncedData"

    local data

    local testThread2 = CreateTrigger()
    TriggerAddAction(testThread2, function ()
        data = GetSyncedData(Player(0), os.date, "*t")
    end)

    local t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "-wait", true)
    TriggerAddAction(t, function ()
        data = nil
        TriggerExecute(testThread2)
        WaitLastSync() -- without this line, this thread won't be yield
        for k, v in pairs(data) do
            print(k, v)
        end
    end)
end)
Debug.endFile()