Debug.beginFile("Megaseadramon\\Abilities\\Spontaneous Storm")
OnInit(function ()
    Require "BossFightUtils"
    local Color = Require "Color" ---@type Color

    local SPELL = FourCC('A00X')
    local CLOUD_MODEL = "war3mapImported\\NoxCloudMissile.mdl"
    local DURATION = 10.
    local COLOR = Color.new(0, 224, 255)
    local AREA = 200.
    local DAMAGE = 5.

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetSpellTargetX(), GetSpellTargetY()
        -- Create the cloud
        local cloud = AddSpecialEffect(CLOUD_MODEL, x, y)
        BlzSetSpecialEffectZ(cloud, 200.)
        BlzSetSpecialEffectColor(cloud, COLOR)
        BlzSetSpecialEffectScale(cloud, 2.5)
        Timed.echo(0.2, DURATION, function ()
            ForUnitsInRange(x, y, AREA, function (u)
                if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                    Damage.apply(caster, u, DAMAGE, true, false, udg_Air, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                end
            end)
        end, function ()
            DestroyEffect(cloud)
        end)
    end)

end)
Debug.endFile()