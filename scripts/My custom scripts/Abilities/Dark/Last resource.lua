OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A03C')
    local StrDmgFactor = 5.
    local IntDmgFactor = 1.
    local DelayIfAlive = 120.
    local Area = 250.
    local DelayIfAliveOffCombat = 60.
    local Model = "Abilities\\Spells\\Other\\HowlOfTerror\\HowlCaster.mdl"

    local cooldowns = __jarray(0) ---@type table<Digimon, number>

    Digimon.postDamageEvent(function (info)
        local target = info.target ---@type Digimon
        if target:hasAbility(Spell) and GetUnitLifePercent(target.root) <= 5. and cooldowns[target] <= 0. then
            local damage = StrDmgFactor * GetHeroStr(target.root, true) + IntDmgFactor * GetHeroInt(target.root, true)
            local owner = target:getOwner()
            DestroyEffect(AddSpecialEffect(Model, target:getX(), target:getY()))
            ForUnitsInRange(target:getX(), target:getY(), Area, function (u)
                if IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                    Damage.apply(target.root, u, damage, false, false, udg_Dark, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS)
                end
            end)

            if target:isAlive() then
                cooldowns[target] = DelayIfAlive
                Timed.echo(function ()
                    cooldowns[target] = cooldowns[target] - 1
                    if cooldowns[target] <= 0 then
                        return true
                    end
                end, 1.)
            end
        end
    end)

    Digimon.offCombatEvent(function (d)
        if d:hasAbility(Spell) then
            cooldowns[d] = math.min(cooldowns[d], DelayIfAliveOffCombat)
        end
    end)
end)