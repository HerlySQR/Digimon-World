Debug.beginFile("Megaseadramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O006_0036

    local icePrisonOrder = Orders.frostnova
    local spontaneousStormOrder = Orders.monsoon
    local greatLightningOrder = Orders.chainlightning
    local coldStormOrder = Orders.stampede

    InitBossFight("Megaseadramon", boss, function (u)
        if not BossStillCasting(boss) then
            local rad = math.random(0, 100)
            if rad <= 30 then
                IssueTargetOrderById(boss, icePrisonOrder, u)
            elseif rad > 30 and rad <= 60 then
                IssuePointOrderById(boss, spontaneousStormOrder, GetUnitX(u), GetUnitY(u))
            elseif rad > 60 and rad <= 90 then
                IssuePointOrderById(boss, greatLightningOrder, GetUnitX(u), GetUnitY(u))
            elseif rad > 90 then
                IssueImmediateOrderById(boss, coldStormOrder)
            end
        end
    end)
end)
Debug.endFile()