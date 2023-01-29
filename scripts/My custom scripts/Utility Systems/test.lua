-- Trident Revolver
OnInit(function ()
    Require "AbilityUtils"

    local Spell = FourCC('A09F')
    local StrDmgFactor = 0.15
    local AgiDmgFactor = 0.15
    local IntDmgFactor = 0.15
    local AttackFactor = 0.6
    local MissieModel = "Missile\\Firebrand Shot Red.mdx"
    -- The same as it is in the object editor
    local Area = 200.
    local Order = Orders.clusterrockets
    local FrameList = Require "FrameList" ---@type FrameList

    local frameList = FrameList.create()
    frameList:setSize(1, 2)

    RegisterSpellEffectEvent(Spell, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local cx = GetUnitX(caster)
        local cy = GetUnitY(caster)
        local x = GetSpellTargetX()
        local y = GetSpellTargetY()
        -- Calculating the damage
        local damage = GetAttributeDamage(caster, StrDmgFactor, AgiDmgFactor, IntDmgFactor) +
                       GetAvarageAttack(caster) * AttackFactor
        -- --
        damage = damage / 2
        local counter = 8
        Timed.echo(0.125, function ()
            if counter == 0 or GetUnitCurrentOrder(caster) ~= Order then return true end
            local angle = 2 * math.pi * math.random()
            local dist = Area * math.random()
            local tx = x + dist * math.cos(angle)
            local ty = y + dist * math.sin(angle)
            local missile = Missiles:create(cx, cy, 150, tx, ty, 0)
            missile.source = caster
            missile.owner = owner
            missile.damage = damage
            missile:scale(0.7)
            missile:model(MissieModel)
            missile:speed(700.)
            missile:arc(20.)
            missile.onFinish = function ()
                ForUnitsInRange(missile.x, missile.y, Area, function (u)
                    if IsUnitEnemy(u, missile.owner) then
                        Damage.apply(caster, u, damage, true, false, udg_Machine, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                        -- Stun
                        DummyCast(
                            owner,
                            GetUnitX(caster), GetUnitY(caster),
                            STUN_SPELL,
                            STUN_ORDER,
                            2,
                            CastType.TARGET,
                            u
                        )
                    end
                end)
            end
            missile:launch()
            counter = counter - 1
        end)
    end)

end)