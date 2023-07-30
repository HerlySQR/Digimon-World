Debug.beginFile("Skull Satamon\\Abilities\\Fire pillar")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0DY')
    local FIRE_MODEL = "Doodads\\Cinematic\\FireTrapUp\\FireTrapUp.mdl"
    local AREA = 150.
    local DAMAGE = 40.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetSpellTargetX(), GetSpellTargetY()
        -- Create the fire
        local fire = AddSpecialEffect(FIRE_MODEL, x, y)
        BlzSetSpecialEffectTime(fire, 0)

        Timed.echo(3.3, function ()
            ForUnitsInRange(x, y, AREA, function (u)
                if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                    Damage.apply(caster, u, DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                end
            end)
            if not UnitAlive(caster) or not GetRandomUnitOnRange(GetUnitX(caster), GetUnitY(caster), 700, function (u2) return IsUnitEnemy(u2, owner) end) then
                DestroyEffect(fire)
                return true
            end
        end)
    end)

end)
Debug.endFile()