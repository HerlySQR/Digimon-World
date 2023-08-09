Debug.beginFile("SpellAISystem")
OnInit("SpellAISystem", function ()
    Require "AbilityUtils"
    Require "ZTS"
    Require "UnitEnterEvent"
    Require "AddHook"
    Require "PlayerUtils"

    local SpellAIs = {} ---@type table<integer, fun(u: unit):boolean>
    local UnitSpellAIs = {} ---@type table<unit, (fun(u: unit):boolean)[]>

    ---@param range number
    ---@return number
    local function convertedRange(range)
        local r = range/100
        return (2/r + r)*100
    end

    local noRun = false

    local castTrigger = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(castTrigger, EVENT_PLAYER_UNIT_ISSUED_ORDER)
    TriggerRegisterAnyUnitEventBJ(castTrigger, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    TriggerRegisterAnyUnitEventBJ(castTrigger, EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER)
    TriggerRegisterAnyUnitEventBJ(castTrigger, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    TriggerAddAction(castTrigger, function ()
        if noRun then
            return
        end

        local u = GetOrderedUnit()
        Timed.call(1., function ()
            if UnitSpellAIs[u] and not IsUnitPaused(u) and not IsUnitHidden(u) then
                noRun = true
                UnitSpellAIs[u][math.random(1, #UnitSpellAIs[u])](u)
                noRun = false
            end
        end)
    end)

    ---@param u unit
    ---@param spell integer
    local function insertSpell(u, spell)
        if IsPlayerInForce(GetOwningPlayer(u), FORCE_PLAYING) then
            return
        end
        local list = UnitSpellAIs[u]
        if not list then
            list = {}
            UnitSpellAIs[u] = list
            ZTS_AddThreatUnit(u, false)
        end
        table.insert(list, SpellAIs[spell])
    end

    local function removeSpell(u, spell)
        local list = UnitSpellAIs[u]
        if not list then
            return
        end
        for i = #list, 1, -1 do
            if list[i] == SpellAIs[spell] then
                table.remove(list, i)
            end
        end
        if #list == 0 then
            UnitSpellAIs[u] = nil
            ZTS_RemoveThreatUnit(u)
        end
    end

    ---@param spell integer
    ---@param order string
    ---@param hasUnitTarget boolean
    ---@param hasPointTarget boolean
    ---@param hasNoTarget boolean
    ---@param enemyTarget boolean
    ---@param allyTarget boolean
    local function Create(spell, order, hasUnitTarget, hasPointTarget, hasNoTarget, enemyTarget, allyTarget)
        assert(hasUnitTarget or hasPointTarget or hasNoTarget, "SpellAISystem: target-type wasn't set")
        assert(not ((hasUnitTarget and hasPointTarget) or (hasPointTarget and hasNoTarget) or (hasUnitTarget and hasNoTarget)), "SpellAISystem: set more than 1 target-type")

        order = Orders[order]

        if not (enemyTarget or allyTarget) then
            enemyTarget = true
            allyTarget = true
        end

        SpellAIs[spell] = function (u)
            local abil = BlzGetUnitAbility(u, spell)
            local level = GetUnitAbilityLevel(u, spell)
            local range = convertedRange(BlzGetAbilityRealLevelField(abil, ABILITY_RLF_CAST_RANGE, level - 1))
            local area = BlzGetAbilityRealLevelField(abil, ABILITY_RLF_AREA_OF_EFFECT, level - 1)
            if hasUnitTarget then
                local target
                if enemyTarget then
                    local maxThreat = -1
                    ForUnitsInRange(GetUnitX(u), GetUnitY(u), range, function (u2)
                        local threat = ZTS_GetThreatUnitAmount(u, u2)
                        if threat > maxThreat then
                            target = u2
                            maxThreat = threat
                        end
                    end)
                end
                if allyTarget then
                    target = GetRandomUnitOnRange(GetUnitX(u), GetUnitY(u), range, function (u2)
                        return IsUnitAlly(u, GetOwningPlayer(u2))
                    end)
                end
                if target then
                    return IssueTargetOrderById(u, order, target)
                end
            elseif hasPointTarget then
                if area > 0 then
                    area = 200.
                end
                local x, y = GetConcentration(GetUnitX(u), GetUnitY(u), range, GetOwningPlayer(u), area, enemyTarget, allyTarget)
                if x then
                    return IssuePointOrderById(u, order, x, y)
                end
            elseif hasNoTarget then
                local count = 0
                ForUnitsInRange(GetUnitX(u), GetUnitY(u), area, function (u2)
                    if enemyTarget and not IsUnitEnemy(u, GetOwningPlayer(u2)) then
                        return
                    end
                    if allyTarget and not IsUnitAlly(u, GetOwningPlayer(u2)) then
                        return
                    end
                    count = count + 1
                end)
                if count >= 2 then
                    return IssueImmediateOrderById(u, order)
                end
            end
            return false
        end

        OnUnitEnter(function (u)
            if GetUnitAbilityLevel(u, spell) > 0 then
                insertSpell(u, spell)
            end
        end)

        OnUnitLeave(function (u)
            if GetUnitAbilityLevel(u, spell) > 0 then
                removeSpell(u, spell)
            end
        end)


        local oldUnitAddAbility
        oldUnitAddAbility = AddHook("UnitAddAbility", function (u, id)
            if id == spell then
                insertSpell(u, spell)
            end
            return oldUnitAddAbility(u, id)
        end)

        local oldUnitRemoveAbility
        oldUnitRemoveAbility = AddHook("UnitRemoveAbility", function (u, id)
            if id == spell then
                removeSpell(u, spell)
            end
            return oldUnitRemoveAbility(u, id)
        end)
    end

    udg_SpellAICreate = CreateTrigger()
    TriggerAddAction(udg_SpellAICreate, function ()
        Create(
            udg_SpellAIAbility,
            udg_SpellAIOrder,
            udg_SpellAIHasUnitTarget,
            udg_SpellAIHasPointTarget,
            udg_SpellAIHasNoTarget,
            udg_SpellAIEnemyTarget,
            udg_SpellAIAllyTarget
        )
        udg_SpellAIAbility = 0
        udg_SpellAIOrder = ""
        udg_SpellAIHasUnitTarget = false
        udg_SpellAIHasPointTarget = false
        udg_SpellAIHasNoTarget = false
        udg_SpellAIEnemyTarget = false
        udg_SpellAIAllyTarget = false
    end)

end)
Debug.endFile()