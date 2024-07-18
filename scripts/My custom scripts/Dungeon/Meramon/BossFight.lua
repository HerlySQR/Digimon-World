Debug.beginFile("Meramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O061_0445 ---@type unit

    InitBossFight({
        name = "Meramon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52788},
        returnPlace = gg_rct_MeramonReturnPlace,
        inner = gg_rct_MeramonInner,
        entrance = gg_rct_MeramonEntrance,
        toTeleport = gg_rct_MeramonToReturn,
        spells = {
            FourCC('A02B'), 30, Orders.stomp, CastType.IMMEDIATE, -- Lava explosions
            FourCC('A02A'), 40, Orders.firebolt, CastType.TARGET, -- Fire ball
            FourCC('A02C'), 30, Orders.thunderclap, CastType.TARGET -- Scorching heat
        },
        actions = function (u)
        end
    })
end)
Debug.endFile()