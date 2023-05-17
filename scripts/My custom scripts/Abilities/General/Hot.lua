Debug.beginFile("Abilities\\Hot")
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A02N')
    local IntDmgFactor = 0.25
    local IntPerSecFactor = 0.1
    local TargetEffect = "Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl"
    local Duration = 2.

    local durations = __jarray(0)
    local hasBuff = __jarray(false)
    local skip = false

    Digimon.postDamageEvent:register(function (info)
        if skip then
            return
        end
        local source = info.source ---@type Digimon
        if source:hasAbility(Spell) then
            local target = info.target.root ---@type unit
            durations[target] = Duration
            if not hasBuff[target] then
                hasBuff[target] = true
                local eff = AddSpecialEffectTarget(TargetEffect, target, "origin")
                local dmg = 1 + (IntDmgFactor * IntPerSecFactor * GetHeroInt(source.root, true))
                Timed.echo(1., function ()
                    durations[target] = durations[target] - 1.
                    skip = true
                    Damage.apply(source.root, target, dmg, false, false, udg_Fire, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS)
                    skip = false
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