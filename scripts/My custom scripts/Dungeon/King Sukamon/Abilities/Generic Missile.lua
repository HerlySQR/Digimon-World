Debug.beginFile("King Sukamon\\Abilities\\Generic Missile")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0B9')
    local DAMAGE = 90.
    local AREA = 175.
    local MISSILE_MODEL = "Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl"

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        local owner = GetOwningPlayer(caster)
        -- Create the missile
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 25, GetUnitX(target), GetUnitY(target), 25)
        missile.source = caster
        missile.owner = owner
        missile.target = target
        missile.damage = DAMAGE
        missile:model(MISSILE_MODEL)
        missile:speed(1500.)
        missile:arc(0.)
        missile.collision = 32.
        missile.collideZ = true
        missile.onFinish = function ()
            ForUnitsInRange(GetUnitX(target), GetUnitY(target), AREA, function (u)
                if IsUnitEnemy(u, owner) then
                    Damage.apply(caster, u, DAMAGE, true, false, udg_Nature, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                    -- Poison
                    DummyCast(owner,
                        GetUnitX(caster), GetUnitY(caster),
                        POISON_SPELL,
                        POISON_ORDER,
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