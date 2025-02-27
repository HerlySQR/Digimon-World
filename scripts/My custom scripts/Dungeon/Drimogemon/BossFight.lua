Debug.beginFile("Drimogemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O060_0442 ---@type unit

    local movingEarthquake = FourCC('A02F')
    local hunger = FourCC('A0AG')

    InitBossFight({
        name = "Drimogemon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52787},
        inner = gg_rct_DrimogemonInner,
        entrance = gg_rct_DrimogemonEntrance,
        spells = {
            FourCC('A05W'), 3, Orders.curse, CastType.TARGET, -- Iron drill spin
            FourCC('A02E'), 2, Orders.battleroar, CastType.TARGET, -- Missile Dash
            FourCC('A02F'), 0, Orders.earthquake, CastType.POINT, -- Moving Earthquake
            FourCC('A02D'), 1, Orders.burrow, CastType.IMMEDIATE, -- Burrow
            FourCC('A0AG'), 3, 852623, CastType.IMMEDIATE -- Hunger
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, movingEarthquake)
                UnitAddAbility(boss, hunger)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, movingEarthquake)
            UnitRemoveAbility(boss, hunger)
        end
    })
end)
Debug.endFile()