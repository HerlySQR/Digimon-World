OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A03T')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5

    RegisterSpellEffectEvent(Spell, function ()
        xpcall(function ()
        local caster = GetSpellAbilityUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Create the missile
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 25, GetSpellTargetX(), GetSpellTargetY(), 25)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.damage = damage
        missile:model("Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl")
        missile:speed(1000.)
        missile:arc(0)
        missile.collision = 32.
        missile.collideZ = true
        missile.onHit = function (u)
            Damage.apply(caster, u, damage, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
            return true
        end
        missile:launch()
                
        end, print)
    end)
end)