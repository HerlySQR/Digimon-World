Debug.beginFile("Abilities\\Targetable mana replish")
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A03O')

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local data = BlzGetAbilityExtendedTooltip(Spell, GetUnitAbilityLevel(caster, Spell)-1)

        local amount = assert(tonumber(data), "Invalid amount from: " .. GetObjectName(Spell))

        local target = GetSpellTargetUnit()
        SetUnitManaBJ(target, GetUnitState(target, UNIT_STATE_MANA) + amount)
    end)
end)
Debug.endFile()