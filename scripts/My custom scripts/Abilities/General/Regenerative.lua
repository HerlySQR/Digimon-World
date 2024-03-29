OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A02R')
    local HealOnCombat = 1. + 1.
    local HealOffCombat = 1. + 2.5

    local timers = {} ---@type function[]

    Digimon.createEvent:register(function (new)
        Timed.call(function ()
            if new:hasAbility(Spell) then
                timers[new] = Timed.echo(function ()
                    SetWidgetLife(new.root, GetWidgetLife(new.root) + (new.onCombat and HealOnCombat or HealOffCombat) * BlzGetUnitRealField(new.root, UNIT_RF_HIT_POINTS_REGENERATION_RATE))
                end, 1.)
            end
        end)
    end)

    Digimon.destroyEvent:register(function (old)
        Timed.call(function ()
            if old:hasAbility(Spell) then
                timers[old]()
            end
        end)
    end)
end)