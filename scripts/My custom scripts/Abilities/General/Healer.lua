Debug.beginFile("Abilities\\Healer")
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A02J')
    local Buff = FourCC('B006')
    local IntFactor = 3
    local Area = 600. -- The same as is in the object editor
    local CasterEff = "Abilities\\Spells\\Orc\\Disenchant\\DisenchantSpecialArt.mdl"
    local TargetEff = "Abilities\\Spells\\Human\\Heal\\HealTarget.mdl"

    local t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(t, function ()
        local caster = GetSpellAbilityUnit()
        if GetUnitAbilityLevel(caster, Spell) > 0 then
            local eff = AddSpecialEffect(CasterEff, GetUnitX(caster), GetUnitY(caster))
            BlzSetSpecialEffectAlpha(eff, 127)
            BlzSetSpecialEffectScale(eff, 3.)
            DestroyEffectTimed(eff, 1.)

            Timed.call(0.1, function ()
                local heal = GetHeroInt(caster, true) * IntFactor
                local owner = GetOwningPlayer(caster)
                ForUnitsInRange(GetUnitX(caster), GetUnitY(caster), Area, function (u)
                    if IsUnitAlly(u, owner) and GetUnitAbilityLevel(u, Buff) > 0 then
                        SetWidgetLife(u, GetWidgetLife(u) + heal)
                        DestroyEffectTimed(AddSpecialEffectTarget(TargetEff, u, "origin"), 1.)
                    end
                end)
            end)
        end
    end)
end)
Debug.endFile()