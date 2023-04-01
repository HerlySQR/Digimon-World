OnInit("Digimon Capture", function ()
    Require "AbilityUtils"

    Digimon.capturedEvent = EventListener.create()

    local function Lerp(min, max, percentage)
        return min + (max - min) * percentage * 0.01
    end

    RegisterSpellEffectEvent(FourCC('A009'), function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        local p = GetOwningPlayer(caster)

        if GetOwningPlayer(target) == Digimon.NEUTRAL then
            if not IsFullOfDigimons(p) then
                local dTarget = Digimon.getInstance(target)
                local captureChance = 0
                if not udg_NetAlwaysCapture then
                    if dTarget.rank == Rank.ROOKIE then
                        -- The first 2 parameters of Lerp are the min. and max. chance that you need to capture
                        captureChance = R2I(Lerp(25, 50, 100 - GetUnitLifePercent(target)))
                    else
                        DisplayTextToPlayer(p, 0, 0, "This digimon is too powerful.")
                        return
                    end
                    -- Add this to divide the chance based on the rarity, but what rarity exactly?
                    if dTarget.rarity == Rarity.UNCOMMON then
                        captureChance = captureChance // 2
                    end
                else
                    captureChance = 101
                end
                -- Here is the chance that you get and should be lesser than the capture chance to capture
                local randomCapture = math.random(0, 100)
                DisplayTextToPlayer(p, 0, 0, "Your chance is: " .. captureChance)
                DisplayTextToPlayer(p, 0, 0, "You got: " .. randomCapture)
                if randomCapture < captureChance then
                    StoreDigimon(p, dTarget)
                    SendToBank(p, dTarget)
                    DestroyEffectTimed(AddSpecialEffect("Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualCaster.mdl", GetUnitX(target), GetUnitY(target)), 2.00)
                    Digimon.capturedEvent:run({caster = Digimon.getInstance(caster), target = dTarget})
                else
                    DisplayTextToPlayer(p, 0, 0, "Not this time.")
                end
            else
                DisplayTextToPlayer(p, 0, 0, "You can't have more digimons.")
            end
        else
            DisplayTextToPlayer(p, 0, 0, "You can't capture this digimon.")
        end
    end)
end)