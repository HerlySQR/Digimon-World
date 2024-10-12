Debug.beginFile("Cherrymon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02V_0095 ---@type unit

    local entagle = FourCC('A0DG')

    InitBossFight({
        name = "Cherrymon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofw_13139},
        inner = gg_rct_CherrymonInner,
        entrance = gg_rct_CherrymonEntrance,
        spells = {
            4, Orders.clusterrockets, CastType.POINT, -- Pit Pelter
            0, Orders.entanglingroots, CastType.TARGET, -- Entangle
            5, Orders.spiritwolf, CastType.IMMEDIATE, -- Forest Rage
            3, Orders.stomp, CastType.IMMEDIATE -- Entangle Branches
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, entagle)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, entagle)
        end
    })
end)
Debug.endFile()