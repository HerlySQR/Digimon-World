Debug.beginFile("Master Tyranomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O008_0081 ---@type unit

    local towerOfFireOrder = Orders.roar
    local fireBallOrder = Orders.firebolt
    local summonTyranomonOrder = Orders.spiritwolf

    InitBossFight("MasterTyranomon", boss, function (u)
        if not BossStillCasting(boss) then
            local rad = math.random(0, 100)
            if rad <= 33 then
                local face = math.deg(math.atan(GetUnitY(u) - GetUnitY(boss), GetUnitX(u) - GetUnitX(boss)))
                SetUnitFacing(boss, face)
                Timed.call(0.9, function ()
                    IssueImmediateOrderById(boss, towerOfFireOrder)
                end)
            elseif rad > 33 and rad <= 66 then
                IssueTargetOrderById(boss, fireBallOrder, u)
            elseif rad > 66 then
                IssueImmediateOrderById(boss, summonTyranomonOrder)
            end
        end
    end)
end)
Debug.endFile()