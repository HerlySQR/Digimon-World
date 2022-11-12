OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A039')
    local ResetCombat = 57.
    local LifeRegenOnCombat = 1.75 - 1
    local ManaRegenOnCombat = 1.75 - 1
    local LifeRegenOffCombat = 3.5 - 1
    local ManaRegenOffCombat = 3.5 - 1

    local timersEcho = {} ---@type table<Digimon, function>
    local timersCombat = {} ---@type table<Digimon, function>
    local onCombat = __jarray(false) ---@type table<Digimon, boolean>

    Digimon.createEvent(function (new)
        Timed.call(function ()
            if new:hasAbility(Spell) then
                timersEcho[new] = Timed.echo(function ()
                    SetWidgetLife(new.root, GetWidgetLife(new.root) + (onCombat[new] and LifeRegenOnCombat or LifeRegenOffCombat) * BlzGetUnitRealField(new.root, UNIT_RF_HIT_POINTS_REGENERATION_RATE))
                    SetUnitState(new.root, UNIT_STATE_MANA, GetUnitState(new.root, UNIT_STATE_MANA) + (onCombat[new] and ManaRegenOnCombat or ManaRegenOffCombat) * BlzGetUnitRealField(new.root, UNIT_RF_MANA_REGENERATION))
                end, 1.)
            end
        end)
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