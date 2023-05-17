OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O060_0442 ---@type unit

    local dashOrder = Orders.battleroar
    local movingEarthquake = Orders.earthquake
    local burrowOrder = Orders.burrow
    local submergeOrder = Orders.submerge
    local ironOrder = Orders.chainlightning

    InitBossFight("Drimogemon", boss, function (u)
        local spellChance = math.random(0, 100)
        if spellChance <= 25 then
            IssueTargetOrderById(boss, dashOrder, u)
        elseif spellChance > 25 and spellChance <= 45 then
            IssuePointOrderById(boss, movingEarthquake, GetUnitX(u), GetUnitY(u))
        elseif spellChance > 45 and spellChance <= 65 then
            IssueTargetOrderById(boss, ironOrder, u)
        else
            IssuePointOrderById(boss, Orders.attack, GetUnitX(u), GetUnitY(u))
        end

        if not BossStillCasting(boss) then
            spellChance = math.random(0, 100)
            if spellChance <= 25 then
                IssueImmediateOrderById(boss, burrowOrder)
            elseif spellChance > 25 and spellChance <= 50 then
                IssueImmediateOrderById(boss, submergeOrder)
            end
        end
    end)
end)