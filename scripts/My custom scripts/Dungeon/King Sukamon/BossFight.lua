Debug.beginFile("King Sukamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00X_0101
    local owner = GetOwningPlayer(boss)

    local healingMinionsOrder = Orders.spiritwolf
    local totemOrder = Orders.healingward
    local missileOrder = Orders.firebolt

    InitBossFight("KingSukamon", boss, function (u)
        if not BossStillCasting(boss) then
            if not IssueTargetOrderById(boss, missileOrder, u) then
                if math.random(0, 100) <= 50 then
                    IssueImmediateOrderById(boss, healingMinionsOrder)
                elseif math.random(0, 100) <= 50 then
                    local x, y = GetConcentration(GetUnitX(boss), GetUnitY(boss), 600., owner, 300.)
                    if x then
                        IssuePointOrderById(boss, totemOrder, x, y)
                    end
                end
            end
        end
    end, function ()
        -- Delay the use of the Healing Minions
        BlzSetUnitAbilityCooldown(boss, FourCC('A0B8'), 0, 80.)
    end)
end)
Debug.endFile()