Debug.beginFile("Megaseadramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O006_0036 ---@type unit

    InitBossFight({
        name = "Megaseadramon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofw_52791},
        returnPlace = gg_rct_MegaseadramonReturnPlace,
        inner = gg_rct_MegaseadramonInner,
        entrance = gg_rct_MegaseadramonEntrance,
        toTeleport = gg_rct_MegaseadramonToReturn,
        spells = {
            FourCC('A00W'), 30, Orders.frostnova, CastType.TARGET, -- Ice prison
            FourCC('A00X'), 30, Orders.monsoon, CastType.POINT, -- Spontaneous storm
            FourCC('A00Y'), 30, Orders.chainlightning, CastType.TARGET, -- Great lightning
            FourCC('A00Z'), 10, Orders.stampede, CastType.IMMEDIATE -- Cold storm
        },
        actions = function (u)
        end
    })
end)
Debug.endFile()