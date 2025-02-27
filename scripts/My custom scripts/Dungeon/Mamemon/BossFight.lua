Debug.beginFile("Mamemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00A_0062 ---@type unit

    InitBossFight({
        name = "Mamemon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_52789},
        inner = gg_rct_MamemonInner,
        entrance = gg_rct_MamemonEntrance,
        spells = {
            FourCC('A0B3'), 3, Orders.thunderbolt, CastType.TARGET, -- Knockback punch
            FourCC('A0B4'), 3, Orders.creepthunderbolt, CastType.TARGET, -- Knockup punch
            FourCC('A0B6'), 3, Orders.roar, CastType.IMMEDIATE, -- Increase Damage
            FourCC('A0J0'), 4, Orders.spiritwolf, CastType.IMMEDIATE, -- Summon Mudfrigimon
            FourCC('A09L'), 6, Orders.inferno, CastType.POINT -- Smiley bomb
        },
        actions = function (u)
        end
    })
end)
Debug.endFile()