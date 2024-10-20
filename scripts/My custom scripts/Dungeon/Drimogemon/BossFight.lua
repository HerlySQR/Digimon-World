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
        returnPlace = gg_rct_DrimogemonReturnPlace,
        inner = gg_rct_DrimogemonInner,
        entrance = gg_rct_DrimogemonEntrance,
        toTeleport = gg_rct_DrimogemonToReturn,
        spells = {
            3, Orders.curse, CastType.TARGET, -- Iron drill spin
            2, Orders.battleroar, CastType.TARGET, -- Missile Dash
            0, Orders.earthquake, CastType.POINT, -- Moving Earthquake
            1, Orders.burrow, CastType.IMMEDIATE, -- Burrow
            3, Orders.submerge, CastType.IMMEDIATE -- Hunger
        },
        actions = function (u)
            if GetUnitCurrentOrder(boss) == 0 then
                IssuePointOrderById(boss, Orders.attack, GetUnitX(u), GetUnitY(u))
            end
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