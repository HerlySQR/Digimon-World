Debug.beginFile("ModifyThreat")
OnInit("ModifyThreat", function ()
    Require "ZTS"
    Require "AbilityUtils"

    local DAMAGE_THREAT_FACTOR = 0.75
    local SPELL_THREAT_FACTOR = 0.5

    local abilityThreat = {} ---@type table<integer, number>
    local itemModifiers = __jarray(1) ---@type table<integer, number>
    local passiveThreat = __jarray(1) ---@type table<integer, number>

    ---@param spell integer
    ---@param passive integer
    ---@param item integer
    ---@param factor integer
    local function Create(spell, passive, item, factor)
        if spell ~= 0 then
            abilityThreat[spell] = factor
        elseif passive ~= 0 then
            passiveThreat[passive] = factor
        elseif item ~= 0 then
            itemModifiers[item] = factor
        end
    end

    local function applyModifiers(source, threat)
        local index = 0
        while true do
            local abil = BlzGetUnitAbilityByIndex(source, index)
            if not abil then break end
            threat = threat * passiveThreat[BlzGetAbilityId(abil)]
            index = index + 1
        end
        for i = 0, 5 do
            threat = threat * itemModifiers[GetItemTypeId(UnitItemInSlot(source, i))]
        end
        return threat
    end

    local t = CreateTrigger()
    TriggerRegisterVariableEvent(t, "udg_AfterDamageEvent", EQUAL, 1.00)
    TriggerAddAction(t, function ()
        local source = udg_DamageEventSource ---@type unit
        local target = udg_DamageEventTarget ---@type unit

        if IsPlayerInGame(GetOwningPlayer(source)) and not IsPlayerInGame(GetOwningPlayer(target)) then
            local threat = udg_DamageEventAmount
            if udg_IsDamageSpell then
                threat = threat * SPELL_THREAT_FACTOR
            else
                threat = threat * DAMAGE_THREAT_FACTOR
            end
            ZTS_ModifyThreat(source, target, applyModifiers(source, threat), true)
        end
    end)

    t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(t, function ()
        local source = GetSpellAbilityUnit() ---@type unit
        local id = GetSpellAbilityId()

        if abilityThreat[id] and IsPlayerInGame(GetOwningPlayer(source)) then
            local threat = abilityThreat[id] * SPELL_THREAT_FACTOR
            local g = ZTS_GetAttackers(source)
            while true do
                local u = FirstOfGroup(g)
                if not u then break end
                ZTS_ModifyThreat(source, u, applyModifiers(source, threat), true)
                GroupRemoveUnit(g, u)
            end
            DestroyGroup(g)
        end
    end)

    udg_ThreatModifierCreate = CreateTrigger()
    TriggerAddAction(udg_ThreatModifierCreate, function ()
        Create(
            udg_ThreatSpell,
            udg_ThreatPassive ~= 0 and udg_ThreatPassive or udg_ThreatBuff,
            udg_ThreatItem,
            udg_ThreatFactor
        )
        udg_ThreatSpell = 0
        udg_ThreatPassive = 0
        udg_ThreatBuff = 0
        udg_ThreatItem = 0
        udg_ThreatFactor = 0.
    end)
end)
Debug.endFile()