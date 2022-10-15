OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A02Z')
    local DmgFactor = 1.5
    local Chance = 15
    local Area = 200.
    local Effect = "Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl"
    local Sound = "Abilities\\Spells\\Orc\\Shockwave\\Shockwave.flac"

    Digimon.preDamageEvent(function (info)
        if udg_IsDamageAttack then
            local source = info.source ---@type Digimon
            if source:hasAbility(Spell) then
                if math.random(0, 100) <= Chance then
                    local target = info.target ---@type Digimon
                    local amount = info.amount * DmgFactor

                    DestroyEffect(AddSpecialEffectTarget(Effect, target.root, "origin"))

                    local snd = CreateSound(Sound, false, true, true, 10, 10, "DefaultEAXON")
                    AttachSoundToUnit(snd, target.root)
                    SetSoundVolume(snd, 127)
                    StartSound(snd)
                    KillSoundWhenDone(snd)

                    ForUnitsInRange(target:getX(), source:getY(), Area, function (u)
                        Damage.apply(source.root, u, amount, false, false, ATTACK_TYPE_MELEE, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_AXE_MEDIUM_CHOP)
                    end)

                    info.amount = 0.
                end
            end
        end
    end)
end)