Debug.beginFile("Abilities\\Regenerator")
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A039')
    local ResetCombat = 57.
    local LifeRegenOnCombat = 0.75
    local ManaRegenOnCombat = 0.75
    local LifeRegenOffCombat = 2.5
    local ManaRegenOffCombat = 2.5

    local onCombat = __jarray(0.) ---@type table<Digimon, number>
    local instances = {} ---@type Digimon[]

    Digimon.createEvent:register(function (new)
        Timed.call(function ()
            if new:hasAbility(Spell) then
                table.insert(instances, new)
                if instances[1] == new then
                    Timed.echo(1., function ()
                        for i = #instances, 1, -1 do
                            local d = instances[i]
                            if d:getTypeId() == 0 then
                                table.remove(instances, i)
                            else
                                onCombat[d] = onCombat[d] - 1
                                SetUnitState(d.root, UNIT_STATE_LIFE, GetUnitState(d.root, UNIT_STATE_LIFE) + (onCombat[d] > 0 and LifeRegenOnCombat or LifeRegenOffCombat))
                                SetUnitState(d.root, UNIT_STATE_MANA, GetUnitState(d.root, UNIT_STATE_MANA) + (onCombat[d] > 0 and ManaRegenOnCombat or ManaRegenOffCombat))
                            end
                        end
                        if instances == 0 then
                            return true
                        end
                    end)
                end
            end
        end)
    end)

    Digimon.onCombatEvent:register(function (d)
        onCombat[d] = ResetCombat
    end)
end)
Debug.endFile()