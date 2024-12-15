Debug.beginFile("Mamemon\\Abilities\\Knockback punch")
OnInit(function ()
    Require "AbilityUtils"

    local SPELL = FourCC('A0B3')
    local DAMAGE = 35.
    local PUSH_DIST = 300.
    local AREA = 200.
    local PUNCH_EFFECT = "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl"
    local TARGET_UNIT_EFFECT = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl"

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        local owner = GetOwningPlayer(GetSpellAbilityUnit())
        local x, y = GetUnitX(target), GetUnitY(target)

        ForUnitsInRange(x, y, AREA, function (u)
            if UnitAlive(u) and IsUnitEnemy(u, owner) then
                Damage.apply(caster, u, DAMAGE, true, false, udg_Machine, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
            end
        end)
        DestroyEffect(AddSpecialEffect(PUNCH_EFFECT, x, y))

        -- Push the target
        if not IsUnitType(target, UNIT_TYPE_GIANT) then
            Knockback(
                target,
                math.atan(y - GetUnitY(caster), x - GetUnitX(caster)),
                PUSH_DIST,
                2400.,
                TARGET_UNIT_EFFECT,
                nil,
                false
            )
        end
    end)

end)
Debug.endFile()