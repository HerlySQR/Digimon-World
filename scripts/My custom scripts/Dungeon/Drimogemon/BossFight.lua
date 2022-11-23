OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O060_0442 ---@type unit

    local dashOrder = Orders.battleroar
    local movingEarthquake = Orders.earthquake
    local burrowOrder = Orders.burrow

    InitBossFight("Drimogemon", boss, function (unitsInTheField)
        local spellChance = math.random(0, 100)
        if spellChance <= 35 then
            IssueTargetOrderById(boss, dashOrder, unitsInTheField[math.random(1, #unitsInTheField)])
        elseif spellChance > 35 and spellChance <= 45 then
            local u = unitsInTheField[math.random(1, #unitsInTheField)]
            IssuePointOrderById(boss, movingEarthquake, GetUnitX(u), GetUnitY(u))
        end
        if not BossStillCasting(boss) then
            if math.random(0, 100) <= 25 then
                IssueImmediateOrderById(boss, burrowOrder)
            end
        end
    end)
end)