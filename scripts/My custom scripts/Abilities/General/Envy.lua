Debug.beginFile("Abilities\\Envy")
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A031')
    local ManaReduced = 0.1
    local ManaGained = 0.5
    local MissileModel = "Abilities\\Spells\\Undead\\AbsorbMana\\AbsorbManaBirthMissile.mdl"

    local durations = __jarray(0)
    local hasBuff = __jarray(false)

    Digimon.postDamageEvent:register(function (info)
        local source = info.source ---@type Digimon
        if source:hasAbility(Spell) then
            local target = info.target.root ---@type unit
            durations[target] = Duration
            if not hasBuff[target] then
                hasBuff[target] = true
                local eff = AddSpecialEffectTarget(TargetEffect, target, "origin")
                local dmg = StrDmgFactor * DmgPerSecFactor * GetHeroStr(source.root, true)
                Timed.echo(1., function ()
                    durations[target] = durations[target] - 1.
                    Damage.apply(source.root, target, dmg, false, false, udg_Fire, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS)
                    if durations[target] <= 0 then
                        hasBuff[target] = false
                        DestroyEffect(eff)
                        return true
                    end
                end)
            end
        end
    end)
end)
Debug.endFile()