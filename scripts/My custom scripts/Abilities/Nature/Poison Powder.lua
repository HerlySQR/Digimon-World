OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A01W')
    local StrDmgFactor = 0.
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.45
    local AttackFactor = 0.5
    local TargetPointEffect = "Abilities\\Spells\\NightElf\\MoonWell\\MoonWellCasterArt.mdl"
    -- The same as it is in the object editor
    local Area = 250.

    RegisterSpellCastEvent(Spell, function ()
        local eff = AddSpecialEffect(TargetPointEffect, GetSpellTargetX(), GetSpellTargetY())
        BlzSetSpecialEffectScale(eff, 2.5)
        BlzSetSpecialEffectColor(eff, 0, 255, 0)
        DestroyEffect(eff)
    end)

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Enum the enemies
        ForUnitsInRange(GetSpellTargetX(), GetSpellTargetY(), Area, function (u)
            if IsUnitEnemy(u, owner) then
                Damage.apply(caster, u, damage, true, false, udg_Nature, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                -- Poison
                DummyCast(GetOwningPlayer(caster),
                          GetUnitX(caster), GetUnitY(caster),
                          POISON_SPELL,
                          POISON_ORDER,
                          1,
                          CastType.TARGET,
                          u)
            end
        end)
    end)

end)