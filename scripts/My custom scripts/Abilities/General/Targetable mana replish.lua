OnMapInit(function ()
    local Spell = FourCC('A03O')

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local data = BlzGetAbilityExtendedTooltip(Spell, GetUnitAbilityLevel(caster, Spell))

        local amount = assert(tonumber(data), "Invalid amount from: " .. GetObjectName(Spell))

        local target = GetSpellTargetUnit()
        SetUnitManaBJ(target, GetUnitState(target, UNIT_STATE_MANA) + amount)
    end)
end)