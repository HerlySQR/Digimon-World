OnMapInit(function ()
    local Spell = FourCC('A02R')
    local HealOnCombat = 1. + 1.
    local HealOffCombat = 1. + 2.5

    local timers = {} ---@type timedNode[]
    local onCombat = __jarray(0) ---@type integer[]

    Digimon.createEvent(function (new)
        if new:hasAbility(Spell) then
            timers[new] = Timed.echo(function ()
                SetWidgetLife(new.root, GetWidgetLife(new.root) + (onCombat[new] > 0 and HealOnCombat or HealOffCombat) * BlzGetUnitRealField(new.root, UNIT_RF_HIT_POINTS_REGENERATION_RATE))
                onCombat[new] = math.max(onCombat[new] - 1, 0)
            end, 1.)
        end
    end)

    Digimon.postDamageEvent(function (info)
        if info.source:hasAbility(Spell) then
            onCombat[info.source] = 3
        end
        if info.target:hasAbility(Spell) then
            onCombat[info.target] = 3
        end
    end)

    Digimon.destroyEvent(function (old)
        if old:hasAbility(Spell) then
            timers[old]:remove()
        end
    end)
end)