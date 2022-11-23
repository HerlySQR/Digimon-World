OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A037')

    Digimon.onCombatEvent:register(function (d)
        if d:hasAbility(Spell) then
            SetUnitAbilityLevel(d.root, Spell, 2)
        end
    end)

    Digimon.offCombatEvent:register(function (d)
        if d:hasAbility(Spell) then
            SetUnitAbilityLevel(d.root, Spell, 1)
        end
    end)
end)