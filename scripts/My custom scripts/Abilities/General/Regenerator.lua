Debug.beginFile("Abilities\\Regenerator")
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A039')
    local ResetCombat = 57.
    local LifeRegenOnCombat = 1.75 - 1
    local ManaRegenOnCombat = 1.75 - 1
    local LifeRegenOffCombat = 3.5 - 1
    local ManaRegenOffCombat = 3.5 - 1

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
                                SetWidgetLife(d.root, GetWidgetLife(d.root) + ((onCombat[d] > 0) and LifeRegenOnCombat or LifeRegenOffCombat) * BlzGetUnitRealField(d.root, UNIT_RF_HIT_POINTS_REGENERATION_RATE))
                                SetUnitState(d.root, UNIT_STATE_MANA, GetUnitState(d.root, UNIT_STATE_MANA) + ((onCombat[d] > 0) and ManaRegenOnCombat or ManaRegenOffCombat) * BlzGetUnitRealField(d.root, UNIT_RF_MANA_REGENERATION))
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