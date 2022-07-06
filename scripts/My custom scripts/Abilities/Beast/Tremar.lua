OnMapInit(function ()
    local Spell = FourCC('A01O')
    local StrDmgFactor = 0.45
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.
    local AttackFactor = 0.5
    local Area = 200.
    local PushDist = 200.

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- --
        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\NightElf\\Taunt\\TauntCaster.mdl", x, y))
        -- --
        Timed.call(0.1, function ()
            ForUnitsInRange(x, y, Area, function (u)
                if IsUnitEnemy(u, owner) then
                    Damage.apply(caster, u, damage, true, false, udg_Beast, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                    -- Push the units
                    if not IsUnitType(u, UNIT_TYPE_GIANT) then
                        Knockback(
                            u,
                            math.atan(GetUnitY(u) - GetUnitY(caster), GetUnitX(u) - GetUnitX(caster)),
                            PushDist,
                            1250.,
                            "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl",
                            nil
                        )
                    end
                end
            end)
        end)
    end)

end)