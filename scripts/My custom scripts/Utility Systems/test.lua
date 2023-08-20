Debug.beginFile("test table")
OnInit(function ()
    Require "GetSyncedData"

    local function GetTable()
        return {
            true,
            [{1}] = "asas",
            tab = {0},
            [{"a5"}] = {"a6", "a7"},
            point = Location(0, 0)
        }
    end

    local t = CreateTrigger()
    TriggerRegisterPlayerChatEvent(t, Player(0), "-table", true)
    TriggerAddAction(t, function ()
        print(Obj2Str(GetSyncedData(Player(0), GetTable)))
    end)

end)
Debug.endFile()