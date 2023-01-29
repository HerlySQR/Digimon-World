OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O061_0445 ---@type unit

    local fireBallOrder = Orders.firebolt
    local lavaExplosionsOrder = Orders.volcano
    local scorchingHeatOrder = Orders.incineratearrow

    InitBossFight("Meramon", boss, function (u)
        local fireBallChance = math.random(0, 100)
            if fireBallChance <= 50 then
                IssueTargetOrderById(boss, fireBallOrder, u)
            end
            if not BossStillCasting(boss) then
                local spellChance = math.random(0, 100)
                if spellChance <= 70 then
                    IssueImmediateOrderById(boss, lavaExplosionsOrder)
                elseif spellChance > 70 then
                    IssueImmediateOrderById(boss, scorchingHeatOrder)
                end
            end
    end)
end)