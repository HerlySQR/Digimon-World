OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A038')
    local Chance = 10
    local Area = 250.
    local Model = "Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl"

    Digimon.postDamageEvent:register(function (info)
        local caster = info.target ---@type Digimon
        if caster:hasAbility(Spell) then
            if math.random(0, 100) <= Chance then
                local x, y = caster:getPos()
                local owner = caster:getOwner()
                local u = GetRandomUnitOnRange(x, y, Area, function (u1)
                    return IsUnitEnemy(u1, owner) and not IsUnitType(u1, UNIT_TYPE_STRUCTURE)
                end)
                if u then
                    -- Create the missile
                    local missile = Missiles:create(x, y, 25, GetUnitX(u), GetUnitY(u), 25)
                    missile.source = caster
                    missile.owner = owner
                    missile.target = u
                    missile:model(Model)
                    missile:speed(1500.)
                    missile:arc(0)
                    missile:scale(0.5)
                    missile.collision = 32.
                    missile.collideZ = true
                    missile.onFinish = function ()
                        -- Ice effect
                        DummyCast(missile.owner, x, y, CURSE_SPELL, CURSE_ORDER, 2, CastType.TARGET, u)
                    end
                    missile:launch()
                end
            end
        end
    end)
end)