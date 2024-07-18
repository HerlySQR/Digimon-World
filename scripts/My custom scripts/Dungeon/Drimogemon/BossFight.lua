Debug.beginFile("Drimogemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O060_0442 ---@type unit

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
            FourCC('A02E'), 23, Orders.battleroar, CastType.TARGET, -- Missile Dash
            FourCC('A02F'), 15, Orders.earthquake, CastType.POINT, -- Moving Earthquake
            FourCC('A05W'), 20, Orders.chainlightning, CastType.TARGET, -- Iron
            FourCC('A02D'), 17, Orders.burrow, CastType.IMMEDIATE, -- Burrow
            FourCC('A0AG'), 33, Orders.submerge, CastType.IMMEDIATE -- Hunger
        },
        actions = function (u)
            if GetUnitCurrentOrder(boss) == 0 then
                IssuePointOrderById(boss, Orders.attack, GetUnitX(u), GetUnitY(u))
            end
        end
    })
end)
Debug.endFile()