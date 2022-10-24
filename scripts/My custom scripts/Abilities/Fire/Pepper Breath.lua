OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A03T')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.15
    local AttackFactor = 0.5
    local DmgPerSecFactor = 0.1
    local MissileModel = "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl"
    local TargetUnitEffect = ""

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        local x = target and GetUnitX(target) or GetSpellTargetX()
        local y = target and GetUnitY(target) or GetSpellTargetY()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- Create the missile
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 80, x, y, 50)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.target = target
        missile.damage = damage
        missile:model(MissileModel)
        missile:scale(1.2)
        missile:speed(1000.)
        missile:arc(10.)
        missile.collision = 32.
        missile.collideZ = true
        missile:launch()
    end)

end)