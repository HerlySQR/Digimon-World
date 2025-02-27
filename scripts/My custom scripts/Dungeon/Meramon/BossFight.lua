Debug.beginFile("Meramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O061_0445 ---@type unit

    local meltAll = FourCC('A0H4')

    InitBossFight({
        name = "Meramon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52788},
        inner = gg_rct_MeramonInner,
        entrance = gg_rct_MeramonEntrance,
        spells = {
            FourCC('A02C'), 4, Orders.thunderclap, CastType.IMMEDIATE, -- Scorching heat
            FourCC('A0H4'), 0, Orders.howlofterror, CastType.IMMEDIATE, -- Melt All
            FourCC('A02B'), 5, Orders.stomp, CastType.IMMEDIATE, -- Lava explosions
        },
        extraSpells = {
            FourCC('A02A'), Orders.firebolt, CastType.TARGET, -- Fire ball attack
        },
        actions = function (u)
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