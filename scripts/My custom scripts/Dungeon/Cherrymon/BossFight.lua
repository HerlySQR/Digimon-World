Debug.beginFile("Cherrymon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02V_0095 ---@type unit

    local pitPelterOrder = Orders.clusterrockets
    local entangleBranchesOrder = Orders.stomp
    local entangleOrder = Orders.entanglingroots
    local forestRageOrder = Orders.spiritwolf

    local quarterLife = BlzGetUnitMaxHP(boss) * 0.25
    local damageDone = 0

    InitBossFight("Cherrymon", boss, function (u)
        local spellChance = math.random(0, 100)
        if spellChance <= 45 then
            IssueTargetOrderById(boss, entangleOrder, u)
        elseif spellChance > 45 and spellChance <= 85 then
            IssuePointOrderById(boss, pitPelterOrder, GetUnitX(u), GetUnitY(u))
        else
            IssueImmediateOrderById(boss, entangleBranchesOrder)
        end

        if damageDone >= quarterLife then
            damageDone = 0
            IssueImmediateOrderById(boss, forestRageOrder)
        end
    end, function ()
        damageDone = 0
    end)

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