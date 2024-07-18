Debug.beginFile("Garudamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O015_0092 ---@type unit

    local fireBallOrder = Orders.firebolt

    InitBossFight({
        name = "Garudamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_13138},
        returnPlace = gg_rct_Great_Cannyon_Tp,
        inner = gg_rct_GarudamonInner,
        entrance = gg_rct_GarudamonEntrance,
        toTeleport = gg_rct_GarudamonToReturn,
        spells = {
            FourCC('A0BM'), 30, Orders.firebolt, CastType.TARGET, -- Bird of Fire
            FourCC('A0BN'), 70, Orders.battleroar, CastType.POINT, -- Dash
            FourCC('A070'), 30, Orders.avengerform, CastType.TARGET -- Fly and Throw
        },
        actions = function (u)
            if math.random(0, 100) <= 50 then
                IssueTargetOrderById(boss, fireBallOrder, u)
            end
        end
    })
end)
Debug.endFile()