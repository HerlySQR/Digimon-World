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
        inner = gg_rct_MegaseadramonInner,
        entrance = gg_rct_MegaseadramonEntrance,
        spells = {
            FourCC('A00Y'), 2, Orders.chainlightning, CastType.TARGET, -- Great lightning
            FourCC('A00W'), 2, Orders.frostnova, CastType.TARGET, -- Ice prison
            FourCC('A00W'), 0, Orders.frostnova, CastType.TARGET, -- Ice prison
            FourCC('A00Y'), 2, Orders.chainlightning, CastType.TARGET, -- Great lightning
            FourCC('A00X'), 2, Orders.monsoon, CastType.POINT, -- Spontaneous storm
            FourCC('A00Z'), 3, Orders.stampede, CastType.IMMEDIATE -- Cold storm
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