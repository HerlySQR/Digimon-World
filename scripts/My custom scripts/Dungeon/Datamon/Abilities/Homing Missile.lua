Debug.beginFile("Datamon\\Abilities\\Homing Missile")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0DZ')
    local MISSILE_MODEL = "Abilities\\Weapons\\Mortar\\MortarMissile.mdl"
    local TARGET_EFFECT = "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl"
    local DURATION = 5
    local WARNING_1 = 3
    local WARNING_2 = 1.5
    local DAMAGE = 200
    local PUSH_DIST = 300

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()

        SetUnitVertexColor(target, 255, 50, 50, 255)
        local m = Missiles:create(GetUnitX(caster), GetUnitY(caster), 50, GetUnitX(target), GetUnitY(target), 50)
        local speed = 300
        local duration = DURATION
        local orange = false
        local red = false
        m.owner = GetOwningPlayer(caster)
        m.target = target
        m:model(MISSILE_MODEL)
        m:speed(speed)
        m.onPeriod = function ()
            duration = duration - 0.025
            if not orange and duration <= WARNING_1 then
                orange = true
                m:color(255, 150, 150)
            end
            if not red and duration <= WARNING_2 then
                red = true
                m:color(255, 50, 50)
            end
            if duration <= 0 then
                return true
            end
        end
        m.onFinish = function ()
            Damage.apply(caster, target, DAMAGE, false, false, udg_Machine, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
            Knockback(
                target,
                m:getYaw(),
                PUSH_DIST,
                2000.,
                TARGET_EFFECT,
                nil
            )
        end
        m.onRemove = function ()
            SetUnitVertexColor(target, 255, 255, 255, 255)
        end

        Timed.call(2., function ()
            m:launch()
        end)
    end)
end)
Debug.endFile()