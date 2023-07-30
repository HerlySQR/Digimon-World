Debug.beginFile("Master Tyranomon\\Abilities\\Tower of fire")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0B1')
    local FIRE_MODEL = "Doodads\\Cinematic\\FireTrapUp\\FireTrapUp.mdl"
    local DISTANCE = 300.
    local AREA = 200.
    local DAMAGE = 5.
    local DURATION = 3.

    local towerOfFireOrder = Orders.roar

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        -- Create the fire
        local face = GetUnitFacing(caster) * bj_DEGTORAD
        local newX, newY = x + DISTANCE * math.cos(face), y + DISTANCE * math.sin(face)
        local fire = AddSpecialEffect(FIRE_MODEL, newX, newY)
        BlzSetSpecialEffectScale(fire, 5)
        BlzSetSpecialEffectTimeScale(fire, 4)

        Timed.echo(0.1, DURATION, function ()
            ForUnitsInRange(newX, newY, AREA, function (u)
                if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                    Damage.apply(caster, u, DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                end
            end)
            if GetUnitCurrentOrder(caster) ~= towerOfFireOrder then
                DestroyEffect(fire)
                return true
            end
        end, function ()
            DestroyEffect(fire)
        end)
    end)

end)
Debug.endFile()