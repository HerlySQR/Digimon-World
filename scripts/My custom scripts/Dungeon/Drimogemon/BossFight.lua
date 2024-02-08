OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O060_0442 ---@type unit

    local dashOrder = Orders.battleroar
    local movingEarthquake = Orders.earthquake
    local burrowOrder = Orders.burrow
    local submergeOrder = Orders.submerge
    local ironOrder = Orders.chainlightning

    InitBossFight({
        name = "Drimogemon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52787},
        returnPlace = gg_rct_DrimogemonReturnPlace,
        inner = gg_rct_DrimogemonInner,
        entrance = gg_rct_DrimogemonEntrance,
        toTeleport = gg_rct_DrimogemonToReturn,
        actions = function (u)
            local spellChance = math.random(0, 100)
            if spellChance > 17 and spellChance <= 40 then
                IssueTargetOrderById(boss, dashOrder, u)
            elseif spellChance > 40 and spellChance <= 55 then
                IssuePointOrderById(boss, movingEarthquake, GetUnitX(u), GetUnitY(u))
            elseif spellChance > 55 and spellChance <= 75 then
                IssueTargetOrderById(boss, ironOrder, u)
            else
                IssuePointOrderById(boss, Orders.attack, GetUnitX(u), GetUnitY(u))
            end

            if not BossStillCasting(boss) then
                if spellChance <= 17 then
                    IssueImmediateOrderById(boss, burrowOrder)
                elseif spellChance > 17 and spellChance <= 50 then
                    IssueImmediateOrderById(boss, submergeOrder)
                elseif spellChance > 50 then
                    IssueImmediateOrderById(boss, submergeOrder)
                end
            end
        end
    })
end)