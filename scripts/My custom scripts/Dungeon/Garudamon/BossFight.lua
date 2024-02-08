Debug.beginFile("Garudamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O015_0092 ---@type unit

    local fireBallOrder = Orders.firebolt
    local birdOfFireOrder = Orders.flamestrike
    local dashOrder = Orders.battleroar
    local flyAndThrowOrder = Orders.avengerform

    InitBossFight({
        name = "Garudamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_13138},
        returnPlace = gg_rct_Great_Cannyon_Tp,
        inner = gg_rct_GarudamonInner,
        entrance = gg_rct_GarudamonEntrance,
        toTeleport = gg_rct_GarudamonToReturn,
        actions = function (u)
            if math.random(0, 100) <= 30 then
                IssueTargetOrderById(boss, birdOfFireOrder, u)
            end
            if not BossStillCasting(boss) then
                if math.random(0, 100) <= 50 then
                    IssueTargetOrderById(boss, fireBallOrder, u)
                end
                local spellChance = math.random(0, 100)
                if spellChance <= 70 then
                    IssuePointOrderById(boss, dashOrder, GetUnitX(u), GetUnitY(u))
                elseif spellChance > 70 then
                    IssueTargetOrderById(boss, flyAndThrowOrder, u)
                end
            end
        end
    })
end)
Debug.endFile()