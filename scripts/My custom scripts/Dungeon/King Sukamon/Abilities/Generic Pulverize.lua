Debug.beginFile("King Sukamon\\Abilities\\Generic Pulverize")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A0BA')
    local DAMAGE_PER_INT = 60.
    local AREA = 250.
    local CLOUD_MODEL = "Abilities\\Spells\\Undead\\PlagueCloud\\PlagueCloudCaster.mdl"
    local INTERVAL = 1
    local CHANCE = 40

    Digimon.postDamageEvent:register(function (info)
        if udg_IsDamageAttack then
            local caster = info.source.root ---@type unit
            if GetUnitAbilityLevel(caster, SPELL) > 0 and math.random(0, 100) <= CHANCE then
                local target = info.target.root ---@type unit
                local x, y = GetUnitX(target), GetUnitY(target)
                local owner = GetOwningPlayer(caster)
                DestroyEffectTimed(AddSpecialEffect(CLOUD_MODEL, x, y), 1.)

                Timed.echo(INTERVAL, 1, function ()
                    ForUnitsInRange(x, y, AREA, function (u)
                        if IsUnitEnemy(u, owner) then
                            Damage.apply(caster, u, DAMAGE_PER_INT, true, false, udg_Dark, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
                        end
                    end)
                end)
            end
        end
    end)
end)
Debug.endFile()