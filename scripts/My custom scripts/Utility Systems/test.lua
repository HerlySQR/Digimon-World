Debug.beginFile("test various syncs")
OnInit(function ()
    Require "GetSyncedData"

    local t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "-various", true)
    TriggerAddAction(t, function ()
        coroutine.wrap(function ()
            print(GetSyncedData(Player(0), function ()
                return "This come first"
            end))
        end)()
        coroutine.wrap(function ()
            print(GetSyncedData(Player(0), function ()
                return "This come second"
            end))
        end)()
        coroutine.wrap(function ()
            print(GetSyncedData(Player(0), function ()
                return "This come third"
            end))
        end)()
        TimerStart(CreateTimer(), 0.04, false, function ()
            coroutine.wrap(function ()
                print(GetSyncedData(Player(0), function ()
                    return "This come fourth"
                end))
            end)()
            TimerStart(CreateTimer(), 0.04, false, function ()
                coroutine.wrap(function ()
                    print("The last sync")
                    print(GetSyncedData(Player(0), function ()
                        return "This come fifth"
                    end))
                    print("was done")
                end)()
            end)
        end)

        print(GetSyncedData(Player(0), function ()
            return "What?"
        end))

        print(GetSyncedData(Player(0), function ()
            return "Wait"
        end))
    end)
end)
Debug.endFile()