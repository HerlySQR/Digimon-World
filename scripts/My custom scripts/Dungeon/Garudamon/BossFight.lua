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
            FourCC('A0BN'), 3, Orders.battleroar, CastType.POINT, -- Dash
            FourCC('A08L'), 0, Orders.carrionswarm, CastType.POINT, -- Wing blade
            FourCC('A02A'), 3, Orders.firebolt, CastType.TARGET, -- Fire ball
            FourCC('A0BM'), 4, Orders.flamestrike, CastType.TARGET, -- Bird of Fire
            FourCC('A0BO'), 4, Orders.avengerform, CastType.TARGET, -- Fly and Throw
            FourCC('A01B'), 1, Orders.curse, CastType.TARGET -- Ashes
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