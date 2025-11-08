Debug.beginFile("Dummies")
OnInit(function()
    Require "GetSyncedData"
    Require "AbilityUtils"

    local DUMMY_UNIT_ID = FourCC('o07C')

    local t = CreateTrigger()
    ForForce(bj_FORCE_ALL_PLAYERS, function ()
        TriggerRegisterPlayerChatEvent(t, GetEnumPlayer(), "-dummies", false)
    end)
    TriggerAddCondition(t, Condition(function ()
        return GetEventPlayerChatString():sub(1, 8) == "-dummies"
    end))
    TriggerAddAction(t, function ()
        local p = GetTriggerPlayer()
        local pos = GetSyncedData(p, {GetCameraTargetPositionX, nil, GetCameraTargetPositionY})

        ForEachCellInRange(pos[1], pos[2], 600, function (x, y)
            local dummy = CreateUnit(Player(PLAYER_NEUTRAL_AGGRESSIVE), DUMMY_UNIT_ID, x, y, 270)
            IssueImmediateOrderById(dummy, Orders.holdposition)
        end)
    end)
end)
Debug.endFile()