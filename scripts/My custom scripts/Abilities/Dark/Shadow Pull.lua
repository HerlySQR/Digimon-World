OnMapInit(function ()
    local Spell = FourCC('A020')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.
    local IntDmgFactor = 0.30
    local AttackFactor = 0.5
    local PullArea = 200.

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- --
        local eff = AddSpecialEffect("Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl", x, y)
        BlzSetSpecialEffectScale(eff, 2.)
        DestroyEffect(eff)
        -- --
        ForUnitsInRange(x, y, PullArea, function (u)
            if IsUnitEnemy(u, owner) then
                Damage.apply(caster, u, damage, true, false, udg_Dark, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                -- Pull the target
                if not IsUnitType(u, UNIT_TYPE_ANCIENT) then
                    Knockback(
                        u,
                        math.atan(GetUnitY(caster) - GetUnitY(u), GetUnitX(caster) - GetUnitX(u)),
                        DistanceBetweenCoords(GetUnitX(caster), GetUnitY(caster), GetUnitX(u), GetUnitY(u)),
                        1000.,
                        "Abilities\\Spells\\Other\\Tornado\\Tornado_Target.mdl",
                        "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl"
                    )
                end
            end
        end)
    end)

end)