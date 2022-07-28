OnMapInit(function ()
    local Spell = FourCC('A033')
    local MaxHits = 8
    local MaxTime = 35.
    local Area = 200.
    local Dmg = 75.
    local Explosion = "Objects\\Spawnmodels\\Other\\NeutralBuildingExplosion\\NeutralBuildingExplosion.mdl"

    local Hits = __jarray(0) ---@type table<Digimon, integer>
    local Timers = {} ---@type table<Digimon, timedNode>

    local Off = false

    Digimon.postDamageEvent(function (info)
        if Off then
            return
        end

        local target = info.target ---@type Digimon
        if target:hasAbility(Spell) then
            Hits[target] = Hits[target] + 1

            pcall(function ()
                Timers[target]:remove()
            end)
            Timers[target] = Timed.call(MaxTime, function ()
                Hits[target] = 0
                Timers[target] = nil
            end)

            if Hits[target] == MaxHits then
                Hits[target] = 0

                DestroyEffect(AddSpecialEffect(Explosion, target:getX(), target:getY()))

                local owner = target:getOwner()
                Off = true
                ForUnitsInRange(target:getX(), target:getY(), Area, function (u)
                    if IsUnitEnemy(u, owner) then
                        Damage.apply(target.root, u, Dmg, false, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                    end
                end)
                Off = false
            end
        end
    end)
end)