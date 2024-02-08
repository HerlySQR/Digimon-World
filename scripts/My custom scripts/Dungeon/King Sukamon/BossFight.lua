Debug.beginFile("King Sukamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00X_0101 ---@type unit
    local owner = GetOwningPlayer(boss)

    local healingMinionsOrder = Orders.spiritwolf
    local totemOrder = Orders.healingward
    local missileOrder = Orders.firebolt
    local PoopChaosOrder = Orders.blackarrow

    InitBossFight({
        name = "KingSukamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52792, gg_dest_Dofw_12379},
        returnPlace = gg_rct_KingSukamonReturnPlace,
        inner = gg_rct_KingSukamonInner,
        entrance = gg_rct_KingSukamonEntrance,
        toTeleport = gg_rct_KingSukamonToReturn,
        actions = function (u)
            if not BossStillCasting(boss) then
                local rad = math.random(0, 100)
                if not IssueTargetOrderById(boss, missileOrder, u) then
                    if rad <= 30 then
                        IssueImmediateOrderById(boss, healingMinionsOrder)
                    elseif rad > 30 and rad <= 70 then
                        IssuePointOrderById(boss, PoopChaosOrder, GetUnitX(u), GetUnitY(u))
                    elseif rad > 70 then
                        local x, y = GetConcentration(GetUnitX(boss), GetUnitY(boss), 600., owner, 300., true, false)
                        if x then
                            IssuePointOrderById(boss, totemOrder, x, y)
                        end
                    end
                end
            end
        end,
        onStart = function ()
            -- Delay the use of the Healing Minions
            BlzStartUnitAbilityCooldown(boss, FourCC('A0B8'), 80.)
        end
    })
end)
Debug.endFile()