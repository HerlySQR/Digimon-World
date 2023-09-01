Debug.beginFile("test various syncs")
OnInit(function ()
    Require "GetSyncedData"

    local t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "-various", true)
    TriggerAddAction(t, function ()
        print(GetSyncedData(Player(0), function ()
            return "This come first"
        end))
        print(GetSyncedData(Player(0), function ()
            return "This come second"
        end))
        print(GetSyncedData(Player(0), function ()
            return "This come third"
        end))
        TimerStart(CreateTimer(), 0.02, false, function ()
            coroutine.resume(coroutine.create(function ()
                print(GetSyncedData(Player(0), function ()
                    return "This come fourth"
                end))
                TimerStart(CreateTimer(), 0.02, false, function ()
                    coroutine.resume(coroutine.create(function ()
                        print(GetSyncedData(Player(0), function ()
                            return "This come fifth"
                        end))
                    end))
                end)
            end))
        end)
    end)
end)
Debug.endFile()