Debug.beginFile("Tonosama Gekomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O012_0067 ---@type unit
    local owner = GetOwningPlayer(boss)

    local sonicWaveOrder = Orders.shockwave
    local summonGekomonOrder = Orders.spiritwolf
    local summonOtamamonOrder = Orders.summonwareagle
    local bigLeapOrder = Orders.stomp
    local birdOfFireOrder = Orders.flamestrike

    InitBossFight({
        name = "TonosamaGekomon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_B082_12252, gg_dest_B082_12254},
        inner = gg_rct_TonosamaGekomonInner,
        entrance = gg_rct_TonosamaGekomonEntrance,
        actions = function (u)
            local rad = math.random(0, 100)
            if rad <= 20 then
                IssueTargetOrderById(boss, sonicWaveOrder, u)
            elseif rad > 20 and rad <= 40 then
                IssueTargetOrderById(boss, birdOfFireOrder, u)
            elseif rad > 40 and rad <= 60 then
                IssueImmediateOrderById(boss, summonGekomonOrder)
            elseif rad > 60 and rad <= 80 then
                IssueImmediateOrderById(boss, summonOtamamonOrder)
            elseif rad > 80 then
                local x, y = GetConcentration(GetUnitX(boss), GetUnitY(boss), 600., owner, 300., true, false)
                if x then
                    IssuePointOrderById(boss, bigLeapOrder, x, y)
                end
            end
        end
    })
end)
Debug.endFile()