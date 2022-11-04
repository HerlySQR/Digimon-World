OnLibraryInit({name = "DigimonCapture", "AbilityUtils"}, function ()

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
                if dTarget.rank == Rank.ROOKIE then
                    captureChance = R2I(Lerp(25, 50, 100 - GetUnitLifePercent(target)))
                elseif dTarget.rank == Rank.CHAMPION then
                    captureChance = R2I(Lerp(12, 25, 100 - GetUnitLifePercent(target)))
                elseif dTarget.rank == Rank.ULTIMATE or dTarget.rank == Rank.MEGA then
                    DisplayTextToPlayer(p, 0, 0, "This digimon is too powerful.")
                    return
                end
                local randomCapture = math.random(0, 100)
                DisplayTextToPlayer(p, 0, 0, "Your chance is: " .. captureChance)
                DisplayTextToPlayer(p, 0, 0, "You got: " .. randomCapture)
                if randomCapture < captureChance then
                    StoreDigimon(p, dTarget)
                    SendToBank(p, dTarget)
                    DestroyEffectTimed(AddSpecialEffect("Abilities\\Spells\\Undead\\DarkRitual\\DarkRitualCaster.mdl", GetUnitX(target), GetUnitY(target)), 2.00)
                    Digimon.capturedEvent:run(Digimon.getInstance(caster), dTarget)
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