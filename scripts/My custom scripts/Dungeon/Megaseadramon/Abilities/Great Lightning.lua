Debug.beginFile("Megaseadramon\\Abilities\\Great Lightning")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A00Y')
    local BOLT_MODEL = "war3mapImported\\Great Lightning.mdl"
    local AREA = 170.
    local DAMAGE = 100.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetSpellTargetX(), GetSpellTargetY()
        -- Create the cloud
        DestroyEffect(AddSpecialEffect(BOLT_MODEL, x, y))
        ForUnitsInRange(x, y, AREA, function (u)
            if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                Damage.apply(caster, u, DAMAGE, true, false, udg_Air, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
            end
        end)
    end)

end)
Debug.endFile()