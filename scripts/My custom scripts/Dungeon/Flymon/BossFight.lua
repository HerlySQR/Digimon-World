OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O067_0406

    local brownStingerShotsOrder = Orders.blackarrow
    local brownStingerOrder = Orders.charm
    local poisonPowderOrder = Orders.cloudoffog

    InitBossFight("Flymon", boss, function (unitsInTheField)
        if not BossStillCasting(boss) then
            local u = unitsInTheField[math.random(1, #unitsInTheField)]
            if not IssueTargetOrderById(boss, brownStingerOrder, u) then
                if math.random(0, 100) <= 50 then
                    IssuePointOrderById(boss, brownStingerShotsOrder, GetUnitX(u), GetUnitY(u))
                elseif math.random(0, 100) <= 50 then
                    IssuePointOrderById(boss, poisonPowderOrder, GetUnitX(u), GetUnitY(u))
                end
            end
        end
    end)
end)