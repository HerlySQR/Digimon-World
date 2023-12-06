Debug.beginFile("Crabmon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O02B_0083 ---@type unit

    local ScissorMagicChaosOrder = Orders.blackarrow
    local ScissorMagicOrder = Orders.chainlightning
    local InnerFireOrder = Orders.innerfire
    local BeserkOrder = Orders.berserk

    InitBossFight("Crabmon", boss, function (u)
        if not BossStillCasting(boss) then
            local rad = math.random(0, 100)
            if not IssueTargetOrderById(boss, ScissorMagicOrder, u) then
                if rad <= 29 then
                    IssuePointOrderById(boss, ScissorMagicChaosOrder, GetUnitX(u), GetUnitY(u))
                elseif 30 <= rad and rad <= 67 then
                    IssueTargetOrderById(boss, InnerFireOrder, boss)
                elseif rad <= 68 then
                    IssueImmediateOrderById(boss, BeserkOrder)
                end
            end

            BossMove(boss, math.random(0, 3), 600., 100., math.random(0, 1) == 1)
        end
    end)
end)
Debug.endFile()