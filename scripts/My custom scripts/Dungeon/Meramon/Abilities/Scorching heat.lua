OnLibraryInit("BossFightUtils", function ()
    local SPELL = FourCC('A02C')
    local DURATION = 10. -- seconds
    local DAMAGE = 25. -- per second
    local AREA = 250.
    local INTERVAL = 0.03125
    local DMG_PER_TICK = DAMAGE * INTERVAL

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        BossIsCasting(caster, true)
        local eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\Doom\\DoomTarget.mdl", caster, "origin")
        BlzSetSpecialEffectScale(eff, 2.)
        Timed.echo(INTERVAL, DURATION, function ()
            ForUnitsInRange(GetUnitX(caster), GetUnitY(caster), AREA, function (u)
                if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                    UnitDamageTarget(caster, u, DMG_PER_TICK, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                    DestroyEffect(AddSpecialEffectTarget("Abilities\\Weapons\\LordofFlameMissile\\LordofFlameMissile.mdl", u, "chest"))
                end
            end)
        end, function ()
            BossIsCasting(caster, false)
            BlzSetSpecialEffectScale(eff, 0.01)
            DestroyEffect(eff)
        end)
    end)
end)