Debug.beginFile("Mamemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00A_0062

    local knockbackPunchOrder = Orders.thunderclap
    local knockupPunchOrder = Orders.stomp
    local increaseDamageOrder = Orders.roar

    InitBossFight("Mamemon", boss, function (u)
        if not BossStillCasting(boss) then
            local rad = math.random(0, 100)
            if rad <= 33 then
                IssueTargetOrderById(boss, knockupPunchOrder, u)
            elseif rad > 33 and rad <= 66 then
                IssueTargetOrderById(boss, knockbackPunchOrder, u)
            elseif rad > 66 then
                IssueImmediateOrderById(boss, increaseDamageOrder)
            end
        end
    end)
end)
Debug.endFile()