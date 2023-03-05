Debug.beginFile("Tonosama Gekomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O012_0067 ---@type unit
    local owner = GetOwningPlayer(boss)

    local sonicWaveOrder = Orders.shockwave
    local summonGekomonOrder = Orders.spiritwolf
    local summonOtamamonOrder = Orders.summonwareagle
    local bigLeapOrder = Orders.stomp

    InitBossFight("TonosamaGekomon", boss, function (u)
        if math.random(0, 100) <= 50 then
            IssueTargetOrderById(boss, sonicWaveOrder, u)
        elseif math.random(0, 100) <= 70 then
            IssueImmediateOrderById(boss, summonGekomonOrder)
        elseif math.random(0, 100) <= 30 then
            IssueImmediateOrderById(boss, summonOtamamonOrder)
        elseif math.random(0, 100) <= 50 then
            local x, y = GetConcentration(GetUnitX(boss), GetUnitY(boss), 600., owner, 300.)
            if x then
                IssuePointOrderById(boss, bigLeapOrder, x, y)
            end
        end
    end)
end)
Debug.endFile()