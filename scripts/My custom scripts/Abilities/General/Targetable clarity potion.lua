OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A03N')

    local Effects = {} ---@type table<unit, effect>
    local Timers = {} ---@type table<unit, function>
    local INTERVAL = 0.03125

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local data = BlzGetAbilityExtendedTooltip(Spell, GetUnitAbilityLevel(caster, Spell))

        local comma = assert(data:find(","), "Invalid data from: " .. GetObjectName(Spell))

        local amount = assert(tonumber(data:sub(1, comma - 1)), "Invalid amount from: " .. GetObjectName(Spell))
        local duration = assert(tonumber(data:sub(comma + 1)), "Invalid duration from: " .. GetObjectName(Spell))

        local manaPerSec = amount / duration * INTERVAL
        local target = GetSpellTargetUnit()
        if Effects[target] then
            DestroyEffect(Effects[target])
            Effects[target] = nil
        end
        Effects[target] = AddSpecialEffectTarget("Abilities\\Spells\\Other\\ANrl\\ANrlTarget.mdl", target, "origin")
        Timers[target] = Timed.echo(function (node)
            if node.elapsed < duration then
                SetUnitManaBJ(target, GetUnitState(target, UNIT_STATE_MANA) + manaPerSec)
            else
                DestroyEffect(Effects[target])
                Effects[target] = nil
                return true
            end
        end, INTERVAL)
    end)

    Digimon.postDamageEvent:register(function (info)
        if Effects[info.target] then
            pcall(function ()
                Timers[info.target]()
            end)
            DestroyEffect(Effects[info.target])
            Effects[info.target] = nil
        end
    end)
end)