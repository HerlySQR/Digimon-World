OnLibraryInit({name = "PvP", "Digimon"}, function ()
    local inPeace = {} ---@type table<player, table<player, boolean>>

    Digimon.issueTargetOrderEvent(function (digimon, order, target)
        if order == Orders.attack then
            if inPeace[digimon:getOwner()][target:getOwner()] then
                digimon:issueOrder(Orders.smart, target.root)
            end
        end
    end)

    function EnablePvP(p1, p2)
        inPeace[p1][p2] = false
    end

    function DisablePvP(p1, p2)
        inPeace[p1][p2] = true
    end

    OnMapInit(function ()
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            local p1 = Player(i)
            inPeace[p1] = {}
            for j = 0, bj_MAX_PLAYER_SLOTS - 1 do
                local p2 = Player(j)
                inPeace[p1][p2] = IsPlayerAlly(p1, p2)
            end
        end
    end)
end)