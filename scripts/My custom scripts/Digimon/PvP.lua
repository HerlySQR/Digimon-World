Debug.beginFile("PvP")
OnInit("PvP", function ()
    Require "Digimon"
    Require "MDTable"

    local inPeace = MDTable.create(2) ---@type table<player, table<player, boolean>>

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    TriggerAddAction(t, function ()
        if GetIssuedOrderId() == Orders.attack then
            local target = GetOrderTargetUnit()
            if target then -- The target can be something that is no unit
                local source = GetOrderedUnit()
                if inPeace[GetOwningPlayer(source)][GetOwningPlayer(target)] then
                    IssueTargetOrderById(source, Orders.smart, target)
                end
            end
        end
    end)

    ---@param p1 player
    ---@param p2 player
    function EnablePvP(p1, p2)
        inPeace[p1][p2] = false
        inPeace[p2][p1] = false
    end

    ---@param p1 player
    ---@param p2 player
    function DisablePvP(p1, p2)
        inPeace[p1][p2] = true
        inPeace[p2][p1] = true
    end

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        local p1 = Player(i)
        for j = 0, bj_MAX_PLAYER_SLOTS - 1 do
            local p2 = Player(j)
            inPeace[p1][p2] = IsPlayerAlly(p1, p2)
        end
    end
end)
Debug.endFile()