OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O061_0445 ---@type unit

    local fireBallOrder = Orders.firebolt
    local lavaExplosionsOrder = Orders.volcano
    local scorchingHeatOrder = Orders.incineratearrow

    InitBossFight({
        name = "Meramon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52788},
        returnPlace = gg_rct_MeramonReturnPlace,
        inner = gg_rct_MeramonInner,
        entrance = gg_rct_MeramonEntrance,
        toTeleport = gg_rct_MeramonToReturn,
        actions = function (u)
            local spellChance = math.random(0, 100)
            if not BossStillCasting(boss) then
                if spellChance <= 30 then
                    IssueImmediateOrderById(boss, lavaExplosionsOrder)
                elseif spellChance > 30 and spellChance <= 70 then
                    IssueTargetOrderById(boss, fireBallOrder, u)
                elseif spellChance > 70 then
                    IssueImmediateOrderById(boss, scorchingHeatOrder)
                end
            end
        end
    })
end)