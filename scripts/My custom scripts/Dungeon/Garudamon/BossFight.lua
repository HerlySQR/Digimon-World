Debug.beginFile("Garudamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O015_0092 ---@type unit

    local wingBlade = FourCC('A08L')

    InitBossFight({
        name = "Garudamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_13138},
        inner = gg_rct_GarudamonInner,
        entrance = gg_rct_GarudamonEntrance,
        spells = {
            3, Orders.battleroar, CastType.POINT, -- Dash
            0, Orders.carrionswarm, CastType.POINT, -- Wing blade
            3, Orders.firebolt, CastType.TARGET, -- Fire ball
            4, Orders.flamestrike, CastType.TARGET, -- Bird of Fire
            4, Orders.avengerform, CastType.TARGET, -- Fly and Throw
            1, Orders.curse, CastType.TARGET -- Ashes
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, wingBlade)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, wingBlade)
        end
    })
end)
Debug.endFile()