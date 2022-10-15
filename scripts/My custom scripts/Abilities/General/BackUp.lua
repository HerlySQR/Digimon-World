OnLibraryInit("AbilityUtils", function ()
    local Spell = FourCC('A032')
    local StrHealthFactor = 8
    local LifeBound = 40.
    local Duration = 60.
    local Cooldown = 120.
    local Model = "Abilities\\Spells\\Undead\\AntiMagicShell\\AntiMagicShell.mdl"

    local Shielded = {} ---@type table<unit, boolean>

    Digimon.postDamageEvent(function (info)
        local target = info.target ---@type Digimon
        if target:hasAbility(Spell) then
            local u = target.root
            if not Shielded[u] and GetUnitLifePercent(u) <= LifeBound and UnitAlive(u) then
                Shielded[u] = true
                local shield = Shield.create()
                shield.caster = u
                shield.target = u
                shield:setModel(Model, "chest")
                shield.health = StrHealthFactor * GetHeroStr(u, true)
                shield.duration = Duration
                Timed.call(Cooldown, function ()
                    Shielded[u] = false
                end)
                shield:apply()
            end
        end
    end)
end)