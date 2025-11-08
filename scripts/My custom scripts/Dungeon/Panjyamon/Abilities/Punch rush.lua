Debug.beginFile("Panjyamon\\Abilities\\Punch rush")
OnInit(function ()
    Require "AbilityUtils"

    local SPELL = FourCC('A0DL')
    local MAX_HITS = 8
    local BUFF = FourCC('B01L')

    local hits = __jarray(0) ---@type table<unit, integer>

    RegisterSpellEffectEvent(SPELL, function ()
        hits[GetSpellAbilityUnit()] = MAX_HITS
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterVariableEvent(t, "udg_AfterDamageEvent", EQUAL, 1.00)
        TriggerAddAction(t, function ()
            if udg_IsDamageAttack and UnitHasBuffBJ(udg_DamageEventSource, BUFF) then
                hits[udg_DamageEventSource] = hits[udg_DamageEventSource] - 1
                if hits[udg_DamageEventSource] <= 0 then
                    UnitRemoveBuffBJ(BUFF, udg_DamageEventSource)
                end
            end
        end)
    end

end)
Debug.endFile()