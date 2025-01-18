Debug.beginFile("Digimon Capture")
OnInit("Digimon Capture", function ()
    Require "AbilityUtils"

    Digimon.capturedEvent = EventListener.create()

    local function Lerp(min, max, percentage)
        return min + (max - min) * percentage * 0.01
    end

    local spellCond = Condition(function ()
        return GetSpellAbilityId() == FourCC('A009') or GetSpellAbilityId() == FourCC('A0IK')
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)
        TriggerAddCondition(t, spellCond)
        TriggerAddAction(t, function ()
            local dTarget = Digimon.getInstance(GetSpellTargetUnit())
            if dTarget.rank ~= Rank.ROOKIE then
                DisplayTextToPlayer(GetOwningPlayer(GetSpellAbilityUnit()), 0, 0, "This digimon is too powerful.")
                UnitAbortCurrentOrder(GetSpellAbilityUnit())
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_EFFECT)
        TriggerAddCondition(t, spellCond)
        TriggerAddAction(t, function ()
            local caster = GetSpellAbilityUnit()
            local target = GetSpellTargetUnit()
            local p = GetOwningPlayer(caster)

            if GetOwningPlayer(target) == Digimon.NEUTRAL then
                if CanStockDigimons(p) or CanSaveDigimons(p) then
                    local dTarget = Digimon.getInstance(target)
                    local captureChance = 0
                    if not udg_NetAlwaysCapture then
                        if GetSpellAbilityId() == FourCC('A009') then
                            captureChance = R2I(Lerp(25, 50, 100 - GetUnitLifePercent(target)))
                        else
                            captureChance = R2I(Lerp(40, 65, 100 - GetUnitLifePercent(target)))
                        end
                    else
                        captureChance = 101
                    end
                    local randomCapture = math.random(0, 100)
                    DisplayTextToPlayer(p, 0, 0, "Your chance is: " .. captureChance)
                    DisplayTextToPlayer(p, 0, 0, "You got: " .. randomCapture)
                    if randomCapture < captureChance then
                        if SendToBank(p, dTarget) == -1 then
                            SaveDigimon(p, dTarget)
                        end
                        DisplayTextToPlayer(p, 0, 0, "You got it!")
                        DestroyEffectTimed(AddSpecialEffect("Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualCaster.mdl", GetUnitX(target), GetUnitY(target)), 2.00)
                        Digimon.capturedEvent:run({owner = p, target = dTarget})
                    else
                        DisplayTextToPlayer(p, 0, 0, "Was not this time.")
                    end
                else
                    DisplayTextToPlayer(p, 0, 0, "You can't have more digimons.")
                end
            else
                DisplayTextToPlayer(p, 0, 0, "You can't capture this digimon.")
            end
        end)
    end
end)
Debug.endFile()