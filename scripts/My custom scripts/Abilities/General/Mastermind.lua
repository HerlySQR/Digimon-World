OnMapInit(function ()
    local Spell = FourCC('A03A')
    local ResetCombat = 42.
    local MaxChargeOnCombat = 0.05
    local MaxChargeOffCombat = 0.15
    local ChargePerSecond = 0.01

    local timersEcho = {} ---@type table<Digimon, function>
    local timersCombat = {} ---@type table<Digimon, function>
    local onCombat = __jarray(false) ---@type table<Digimon, boolean>
    local charges = __jarray(0) ---@type table<Digimon, number>

    Digimon.createEvent(function (new)
        Timed.call(function ()
            if new:hasAbility(Spell) then
                timersEcho[new] = Timed.echo(function ()
                    charges[new] = math.min(charges[new] + ChargePerSecond, onCombat[new] and MaxChargeOnCombat or MaxChargeOffCombat)
                end, 1.)
            end
        end)
    end)

    Digimon.preDamageEvent(function (info)
        local source = info.source ---@type Digimon
        if source:hasAbility(Spell) then
            info.amount = info.amount * (1 + charges[source])
            charges[source] = 0
        end
    end)

    Digimon.onCombatEvent(function (d)
        onCombat[d] = true
    end)

    Digimon.offCombatEvent(function (d)
        pcall(function ()
            timersCombat[d]()
        end)
        timersCombat[d] = Timed.call(ResetCombat, function ()
            onCombat[d] = false
        end)
    end)

    Digimon.destroyEvent(function (old)
        Timed.call(function ()
            if old:hasAbility(Spell) then
                timersEcho[old]()
            end
        end)
    end)
end)