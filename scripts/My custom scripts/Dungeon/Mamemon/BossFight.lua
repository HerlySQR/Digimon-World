Debug.beginFile("Mamemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00A_0062 ---@type unit

    local knockbackPunchOrder = Orders.thunderclap
    local knockupPunchOrder = Orders.stomp
    local increaseDamageOrder = Orders.roar
    local BombOrder = Orders.inferno

    InitBossFight({
        name = "Mamemon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_52789},
        returnPlace = gg_rct_MamemonReturnPlace,
        inner = gg_rct_MamemonInner,
        entrance = gg_rct_MamemonEntrance,
        toTeleport = gg_rct_MamemonToReturn,
        actions = function (u)
            if not BossStillCasting(boss) then
                local rad = math.random(0, 100)
                if rad <= 20 then
                    IssueTargetOrderById(boss, knockupPunchOrder, u)
                elseif rad > 20 and rad <= 50 then
                    IssueTargetOrderById(boss, knockbackPunchOrder, u)
                elseif rad > 50 and rad <= 80 then
                    IssueImmediateOrderById(boss, increaseDamageOrder)
               elseif rad > 80 then
                    IssuePointOrderById(boss, BombOrder, GetUnitX(u), GetUnitY(u))
                end
            end
        end
    })
end)
Debug.endFile()