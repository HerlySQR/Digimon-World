Debug.beginFile("Abilities\\Drimogemon\\Iron Drill Spin")
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A0H7')
    local StrDmgFactor = 0.6
    local AgiDmgFactor = 0.6
    local IntDmgFactor = 0.2
    local AttackFactor = 1.5
    local MissileModel = "Missile\\TCSlashProj.mdx"
    local TargetUnitEffect = "Effect\\Ephemeral Cut Silver.mdx"

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
        missile:playerColor(20)
        missile:scale(2)
        missile:speed(400.)
        missile:arc(50.)
        missile.collision = 32.
        missile.collideZ = true
        missile.onFinish = function ()
            ForUnitsInRange(GetUnitX(target), GetUnitY(target), 200., function (u)
                if IsUnitEnemy(u, missile.owner) then
                    Damage.apply(caster, u, damage, true, false, udg_Machine, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                    DestroyEffect(AddSpecialEffect(TargetUnitEffect, GetUnitX(target), GetUnitY(target)))
                            DummyCast(missile.owner,
                            GetUnitX(caster), GetUnitY(caster),
                            CURSE_SPELL,
                            CURSE_ORDER,
                            1,
                            CastType.TARGET,
                            u)
                end
            end)
        end
        missile:launch()
    end)
end)
Debug.endFile()