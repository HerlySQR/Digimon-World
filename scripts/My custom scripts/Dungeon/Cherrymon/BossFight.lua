Debug.beginFile("Cherrymon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02V_0095 ---@type unit

    local forestRageOrder = Orders.spiritwolf

    local quarterLife = BlzGetUnitMaxHP(boss) * 0.25
    local damageDone = 0

    InitBossFight({
        name = "Cherrymon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofw_13139},
        inner = gg_rct_CherrymonInner,
        entrance = gg_rct_CherrymonEntrance,
        spells = {
            FourCC('A0DG'), 45, Orders.entanglingroots, CastType.TARGET, -- Entangle
            FourCC('A0DD'), 45, Orders.clusterrockets, CastType.POINT, -- Pit Pelter
            FourCC('A0DE'), 25, Orders.stomp, CastType.IMMEDIATE -- Entangle Branches
        },
        actions = function (u)
            if damageDone >= quarterLife then
                damageDone = 0
                IssueImmediateOrderById(boss, forestRageOrder)
            end
        end,
        onStart = function ()
            damageDone = 0
        end
    })

    do
        local t = CreateTrigger()
        TriggerRegisterVariableEvent(t, "udg_AfterDamageEvent", EQUAL, 1.00)
        TriggerAddAction(t, function ()
            if udg_DamageEventTarget == boss then
                damageDone = damageDone + udg_DamageEventAmount
            end
        end)
    end
end)
Debug.endFile()