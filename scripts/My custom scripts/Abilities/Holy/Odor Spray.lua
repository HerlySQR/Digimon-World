OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A026')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5
    local Chance = 25
    local Area = 350.

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local eff = AddSpecialEffect("Abilities\\Spells\\Other\\BreathOfFrost\\BreathOfFrostMissile.mdl", GetSpellTargetX(), GetSpellTargetY())
        BlzSetSpecialEffectOrientation(eff, GetUnitFacing(caster) * bj_DEGTORAD, 0, 0)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Enum the enemies
        ForUnitsInRange(GetSpellTargetX(), GetSpellTargetY(), Area, function (u)
            if IsUnitEnemy(u, owner) then
                Damage.apply(caster, u, damage, true, false, udg_Holy, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                -- Poison
                local chance = math.random(0, 100)
                if chance <= Chance then
                    DummyCast(owner,
                              GetUnitX(caster), GetUnitY(caster),
                              POISON_SPELL,
                              POISON_ORDER,
                              1,
                              CastType.TARGET,
                              u)
                end
            end
        end)
    end)

end)