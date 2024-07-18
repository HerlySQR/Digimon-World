Debug.beginFile("Mamemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00A_0062 ---@type unit

    InitBossFight({
        name = "Mamemon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_52789},
        returnPlace = gg_rct_MamemonReturnPlace,
        inner = gg_rct_MamemonInner,
        entrance = gg_rct_MamemonEntrance,
        toTeleport = gg_rct_MamemonToReturn,
        spells = {
            FourCC('A0B4'), 20, Orders.creepthunderbolt, CastType.TARGET, -- Knockup punch
            FourCC('A0B3'), 30, Orders.thunderbolt, CastType.TARGET, -- Knockback punch
            FourCC('A0B6'), 30, Orders.roar, CastType.IMMEDIATE -- Increase Damage
        },
        actions = function (u)
        end
    })
end)
Debug.endFile()