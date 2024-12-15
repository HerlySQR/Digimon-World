Debug.beginFile("Mamemon\\Abilities\\Knockup punch")
OnInit(function ()
    Require "AbilityUtils"

    local SPELL = FourCC('A0B4')
    local DAMAGE = 60.
    local FLY_DIST = 600.
    local SPEED = 70.
    local AREA = 200.
    local FALL_EFFECT = "Abilities\\Spells\\Human\\ThunderClap\\ThunderClapCaster.mdl"

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        local speed = 1400.

        UnitAddAbility(target, CROW_FORM_ID)
        UnitRemoveAbility(target, CROW_FORM_ID)
        PauseUnit(target, true)

        Timed.echo(0.04, function ()
            speed = speed - SPEED
            if speed > -1400. then
                local rate
                local goal
                if speed >= 0. then
                    rate = speed
                    goal = FLY_DIST
                else
                    rate = -speed
                    goal = 0.
                end
                SetUnitFlyHeight(target, goal, rate)
            else
                local posX, posY = GetUnitX(target), GetUnitY(target)
                local owner = GetOwningPlayer(caster)
                DestroyEffect(AddSpecialEffect(FALL_EFFECT, posX, posY))
                TerrainDeformationRippleBJ(2., false, Location(posX, posY), AREA, AREA, 64., 1., AREA)

                ForUnitsInRange(posX, posY, AREA, function (u)
                    if IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                        Damage.apply(caster, u, DAMAGE, true, false, udg_Machine, DAMAGE_TYPE_SONIC, WEAPON_TYPE_ROCK_HEAVY_BASH)
                    end
                end)
                PauseUnit(target, false)
                SetUnitFlyHeight(target, GetUnitDefaultFlyHeight(target), 1000.)
                return true
            end
        end)
    end)

end)
Debug.endFile()