Debug.beginFile("Crabmon\\Abilities\\Scissor Magic")
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A0H6')
    local StrDmgFactor = 0.6
    local AgiDmgFactor = 0.1
    local IntDmgFactor = 0.5
    local AttackFactor = 1.2
    local MissileModel = "Missile\\TCSlashProj.mdx"
    local TargetUnitEffect = "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl"

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Create the missile
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 50, GetUnitX(target), GetUnitY(target), 50)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.target = target
        missile.damage = damage
        missile:model(MissileModel)
        missile:scale(2*BlzGetUnitRealField(caster, UNIT_RF_SCALING_VALUE))
        missile:speed(1000.)
        missile:arc(10.)
        missile:playerColor(9)
        missile.collision = 32.
        missile.collideZ = true
        missile.onFinish = function ()
            ForUnitsInRange(GetUnitX(target), GetUnitY(target), 200., function (u)
                if IsUnitEnemy(u, missile.owner) then
                    Damage.apply(caster, u, damage, true, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                    DestroyEffect(AddSpecialEffect(TargetUnitEffect, GetUnitX(u), GetUnitY(u)))
                end
            end)
        end
        missile:launch()
    end)
end)
Debug.endFile()