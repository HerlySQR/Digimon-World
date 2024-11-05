Debug.beginFile("Meramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O061_0445 ---@type unit

    local meltAll = FourCC('A0H4')
    local fireBallOrder = Orders.firebolt

    InitBossFight({
        name = "Meramon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52788},
        inner = gg_rct_MeramonInner,
        entrance = gg_rct_MeramonEntrance,
        spells = {
            4, Orders.thunderclap, CastType.IMMEDIATE, -- Scorching heat
            0, Orders.howlofterror, CastType.IMMEDIATE, -- Melt All
            5, Orders.stomp, CastType.IMMEDIATE, -- Lava explosions
        },
        actions = function (u)
            if GetUnitCurrentOrder(boss) == Orders.smart or  GetUnitCurrentOrder(boss) == 0 then
                IssueTargetOrderById(boss, fireBallOrder, u)
            end
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, meltAll)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, meltAll)
        end
    })
end)
Debug.endFile()