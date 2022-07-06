--Lua RegisterSpellEvent
do
    -- I use the handle id because when these events are type casted to
    -- eventid they become different objects
    local tb = {
        [GetHandleId(EVENT_PLAYER_UNIT_SPELL_CHANNEL)] = {},
        [GetHandleId(EVENT_PLAYER_UNIT_SPELL_CAST)] = {},
        [GetHandleId(EVENT_PLAYER_UNIT_SPELL_EFFECT)] = {},
        [GetHandleId(EVENT_PLAYER_UNIT_SPELL_FINISH)] = {},
        [GetHandleId(EVENT_PLAYER_UNIT_SPELL_ENDCAST)] = {}
    }

    local trig = nil

    ---@param abil integer (raw-code)
    ---@param onCast function
    ---@param event playerunitevent
    local function RegisterSpell(abil, onCast, event)
        if not trig then
            trig = CreateTrigger()
            TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
            TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_CAST)
            TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_EFFECT)
            TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_FINISH)
            TriggerRegisterAnyUnitEventBJ(trig, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
            TriggerAddCondition(trig, Condition(function ()
                local i = tb[GetHandleId(GetTriggerEventId())][GetSpellAbilityId()]
                if i then i() end
            end))
        end
        tb[GetHandleId(event)][abil] = onCast
    end

    ---@param abil integer (raw-code)
    ---@param onCast function
    function RegisterSpellChannelEvent(abil, onCast)
        RegisterSpell(abil, onCast, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    end

    ---@param abil integer (raw-code)
    ---@param onCast function
    function RegisterSpellCastEvent(abil, onCast)
        RegisterSpell(abil, onCast, EVENT_PLAYER_UNIT_SPELL_CAST)
    end

    ---@param abil integer (raw-code)
    ---@param onCast function
    function RegisterSpellEffectEvent(abil, onCast)
        RegisterSpell(abil, onCast, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    end

    ---@param abil integer (raw-code)
    ---@param onCast function
    function RegisterSpellFinishEvent(abil, onCast)
        RegisterSpell(abil, onCast, EVENT_PLAYER_UNIT_SPELL_FINISH)
    end

    ---@param abil integer (raw-code)
    ---@param onCast function
    function RegisterSpellEndCastEvent(abil, onCast)
        RegisterSpell(abil, onCast, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
    end
end

--syntax is:
--RegisterSpellEffectEvent(FourCC('Abil'), function() print(GetUnitName(GetTriggerUnit())) end)