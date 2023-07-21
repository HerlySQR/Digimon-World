Debug.beginFile("Panjyamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O037_0096 ---@type unit

    local iceFistOrder = Orders.breathoffrost
    local iceStompOrder = Orders.stomp
    local punchRushOrder = Orders.berserk
    local mammothmonRushOrder = Orders.breathoffire
    local catJumpOrder = Orders.shadowstrike

    InitBossFight("Panjyamon", boss, function (u)
        if not BossStillCasting(boss) then
            local spellChance = math.random(0, 100)
            if spellChance <= 20 then
                IssuePointOrderById(boss, iceFistOrder, GetUnitX(u), GetUnitY(u))
            elseif (spellChance > 20 and spellChance <= 40) and DistanceBetweenCoords(GetUnitX(boss), GetUnitY(boss), GetUnitX(u), GetUnitY(u)) <= 300. then
                IssueImmediateOrderById(boss, iceStompOrder)
            elseif spellChance > 40 and spellChance <= 60 then
                IssueImmediateOrderById(boss, punchRushOrder)
            elseif spellChance > 60 and spellChance <= 80 then
                IssuePointOrderById(boss, mammothmonRushOrder, GetUnitX(u), GetUnitY(u))
            else
                IssueTargetOrderById(boss, catJumpOrder, u)
            end
        end
    end, function ()
        BlzStartUnitAbilityCooldown(boss, FourCC('A0DM'), 60.)
    end)

    -- Ice aura
    local BUFF = FourCC('B01N')
    local owner = GetOwningPlayer(boss)
    local battlefield = {} ---@type rect[]
    local i = 1
    while true do
        -- To be sure that the target is inside the bossfight area
        if not rawget(_G, "gg_rct_Panjyamon_" .. i) then
            break
        end
        battlefield[i] = rawget(_G, "gg_rct_Panjyamon_" .. i)
        i = i + 1
    end

    ---@param u unit
    local function CheckEnemies(u)
        if IsUnitEnemy(u, owner) and not UnitHasBuffBJ(u, BUFF) then
            DummyCast(owner, GetUnitX(u), GetUnitY(u), SLOW_SPELL, SLOW_ORDER, 3, CastType.TARGET, u)
            Damage.apply(boss, u, 2.5, false, false, udg_Air, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
        end
    end

    Timed.echo(0.5, function ()
        if UnitAlive(boss) then
            for j = 1, #battlefield do
                ForUnitsInRect(battlefield[j], CheckEnemies)
            end
        end
    end)
end)
Debug.endFile()