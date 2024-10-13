Debug.beginFile("Megaseadramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O006_0036 ---@type unit

    local icePrison = FourCC('A00W')

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
            2, Orders.chainlightning, CastType.TARGET, -- Great lightning
            2, Orders.frostnova, CastType.TARGET, -- Ice prison
            0, Orders.frostnova, CastType.TARGET, -- Ice prison
            2, Orders.chainlightning, CastType.TARGET, -- Great lightning
            2, Orders.monsoon, CastType.POINT, -- Spontaneous storm
            3, Orders.stampede, CastType.IMMEDIATE -- Cold storm
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.7 then
                UnitAddAbility(boss, icePrison)
            elseif GetUnitHPRatio(boss) < 0.4 then
                BlzEndUnitAbilityCooldown(boss, icePrison)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, icePrison)
        end
    })
end)
Debug.endFile()