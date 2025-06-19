Debug.beginFile("SpellAISystem")
OnInit("SpellAISystem", function ()
    Require "AbilityUtils"
    Require "ZTS"
    Require "UnitEnterEvent"
    Require "AddHook"
    Require "GameStatus"
    Require "Set"
    Require "SyncedTable"

    local SpellAIs = {} ---@type table<integer, fun(u: unit):boolean>
    local UnitSpellAIs = SyncedTable.create() ---@type table<unit, Set>
    local isCasting = __jarray(false) ---@type table<unit, boolean>
    local isPaused = __jarray(false) ---@type table<unit, boolean>

    ---@param range number
    ---@return number
    local function convertedRange(range)
        local r = range/100
        return (2/r + r)*100
    end

    Timed.echo(1., function ()
        for creep, set in pairs(UnitSpellAIs) do
            if not isCasting[creep] and ZTS_GetCombatState(creep) and not IsUnitPaused(creep) and not IsUnitHidden(creep) then
                set:random()(creep)
            end
        end
    end)

    ---@param u unit
    ---@param flag boolean
    function PauseSpellAI(u, flag)
        isPaused[u] = flag
    end

    ---@param u unit
    ---@param spell integer
    local function insertSpell(u, spell)
        if IsPlayerInGame(GetOwningPlayer(u)) then
            return
        end
        local set = UnitSpellAIs[u]
        if not set then
            set = Set.create()
            UnitSpellAIs[u] = set
            ZTS_AddThreatUnit(u, false)
        end
        set:addSingle(SpellAIs[spell])
    end

    local function removeSpell(u, spell)
        local set = UnitSpellAIs[u]
        if not set or not set:contains(SpellAIs[spell]) then
            return
        end
        set:removeSingle(SpellAIs[spell])
        if set:isEmpty() then
            UnitSpellAIs[u] = nil
            ZTS_RemoveThreatUnit(u)
        end
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
        TriggerAddCondition(t, Condition(function () return UnitSpellAIs[GetSpellAbilityUnit()] ~= nil end))
        TriggerAddAction(t, function ()
            isCasting[GetSpellAbilityUnit()] = GetTriggerEventId() == EVENT_PLAYER_UNIT_SPELL_CHANNEL
        end)
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
            if isPaused[u] then
                return false
            end
            if not UnitCanCastAbility(u, spell) then
                return false
            end
            local abil = BlzGetUnitAbility(u, spell)
            local level = GetUnitAbilityLevel(u, spell)
            local range = convertedRange(BlzGetAbilityRealLevelField(abil, ABILITY_RLF_CAST_RANGE, level - 1))
            local area = BlzGetAbilityRealLevelField(abil, ABILITY_RLF_AREA_OF_EFFECT, level - 1)
            if hasUnitTarget then
                local target
                if enemyTarget then
                    local maxThreat = -1
                    ForUnitsInRange(GetUnitX(u), GetUnitY(u), range, function (u2)
                        if not BlzIsUnitInvulnerable(u2) and UnitAlive(u2) then
                            local threat = ZTS_GetThreatUnitAmount(u, u2)
                            if threat > maxThreat then
                                target = u2
                                maxThreat = threat
                            end
                        end
                    end)
                end
                if allyTarget then
                    target = GetRandomUnitOnRange(GetUnitX(u), GetUnitY(u), range, function (u2)
                        return IsUnitAlly(u, GetOwningPlayer(u2)) and UnitAlive(u2)
                    end)
                end
                if target then
                    return IssueTargetOrderById(u, order, target)
                end
            elseif hasPointTarget then
                area = area > 0 and area or 200.
                local x, y = GetConcentration(GetUnitX(u), GetUnitY(u), range, GetOwningPlayer(u), area, enemyTarget, allyTarget)
                if x then
                    return IssuePointOrderById(u, order, x, y)
                else
                    local random = GetRandomUnitOnRange(GetUnitX(u), GetUnitY(u), range, function (u2)
                        return ((enemyTarget and UnitAlive(u2) and IsUnitEnemy(u, GetOwningPlayer(u2)) and not BlzIsUnitInvulnerable(u2)) or (allyTarget and IsUnitAlly(u, GetOwningPlayer(u2))))
                    end)
                    if random then
                        return IssuePointOrderById(u, order, GetUnitX(random), GetUnitY(random))
                    end
                end
            elseif hasNoTarget then
                local count = 0
                ForUnitsInRange(GetUnitX(u), GetUnitY(u), area, function (u2)
                    if enemyTarget and (not IsUnitEnemy(u, GetOwningPlayer(u2)) or BlzIsUnitInvulnerable(u2)) and UnitAlive(u2) then
                        return
                    end
                    if allyTarget and not IsUnitAlly(u, GetOwningPlayer(u2)) and UnitAlive(u2) then
                        return
                    end
                    count = count + 1
                end)
                if count >= 1 then
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

        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_CHANGE_OWNER)
        TriggerAddCondition(t, Condition(function () return GetUnitAbilityLevel(GetChangingUnit(), spell) > 0 end))
        TriggerAddAction(t, function ()
            local whichUnit = GetChangingUnit()
            local whichPlayer = GetOwningPlayer(whichUnit)
            if IsPlayerInForce(whichPlayer, FORCE_PLAYING) then
                removeSpell(whichUnit, spell)
            else
                insertSpell(whichUnit, spell)
            end
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

    OnInit.map(function ()
        ForUnitsInRect(bj_mapInitialPlayableArea, function (u)
            local index = 0
            while true do
                local abil = BlzGetUnitAbilityByIndex(u, index)
                if not abil then break end
                local id = BlzGetAbilityId(abil)
                if SpellAIs[id] then
                    insertSpell(u, id)
                end
                index = index + 1
            end
        end)
    end)
end)
Debug.endFile()