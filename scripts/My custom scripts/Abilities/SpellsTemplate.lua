Debug.beginFile("SpellsTemplate")
OnInit("SpellsTemplate", function ()
    Require "AbilityUtils"

    ---@enum BuffSpell
    BuffSpell = {
        REDUCE_ARMOR = 0,
        ICE = 1,
        FREEZE = 2,
        STUN = 3,
        POISON = 4,
        CURSE = 5,
        SLEEP = 6,
        SLOW = 7,
        PURGE = 8
    }

    ---@param data {spell: integer, strDmgFactor: number?, agiDmgFactor: number?, intDmgFactor: number?, attackFactor: number?, missileModel: string, zOffsetSource: number, zOffsetTarget: number, scale: number, speed: number, arc: number, pColor: integer?, attType: attacktype, dmgType: damagetype, targetEffect: string?, buffType: BuffSpell?, buffLevel: integer?}
    function CreateSingleMissileSpell(data)
        data.strDmgFactor = data.strDmgFactor or 0
        data.agiDmgFactor = data.strDmgFactor or 0
        data.intDmgFactor = data.strDmgFactor or 0
        data.attackFactor = data.attackFactor or 0
        if data.buffType then
            data.buffLevel = data.buffLevel or 1
        end

        RegisterSpellEffectEvent(data.spell, function ()
            local caster = GetSpellAbilityUnit()
            local target = GetSpellTargetUnit()
            -- Calculating the damage
            local damage = GetAttributeDamage(caster, data.strDmgFactor, data.agiDmgFactor, data.intDmgFactor) +
                           GetAvarageAttack(caster) * data.attackFactor
            -- Create the missile
            local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), data.zOffsetSource, GetUnitX(target), GetUnitY(target), data.zOffsetTarget)
            missile.source = caster
            missile.owner = GetOwningPlayer(caster)
            missile.target = target
            missile.damage = damage
            missile:model(data.missileModel)
            missile:scale(data.scale)
            missile:speed(data.speed)
            missile:arc(data.arc)
            if data.pColor then
                missile:playerColor(data.pColor)
            end
            missile.collision = 32.
            missile.collideZ = true
            missile.onFinish = function ()
                Damage.apply(caster, target, damage, true, false, data.attType, data.dmgType, WEAPON_TYPE_WHOKNOWS)
                if data.targetEffect then
                    DestroyEffect(AddSpecialEffect(data.targetEffect, GetUnitX(target), GetUnitY(target)))
                end
                if data.buffType then
                    if data.buffType == BuffSpell.POISON then
                        PoisonUnit(caster, target)
                    else
                        local spell, order
                        if data.buffType == BuffSpell.REDUCE_ARMOR then
                            spell = ARMOR_REDUCE_SPELL
                            order = ARMOR_REDUCE_ORDER
                        elseif data.buffType == BuffSpell.ICE then
                            spell = ICE_SPELL
                            order = ICE_ORDER
                        elseif data.buffType == BuffSpell.FREEZE then
                            spell = FREEZE_SPELL
                            order = FREEZE_ORDER
                        elseif data.buffType == BuffSpell.STUN then
                            spell = STUN_SPELL
                            order = STUN_ORDER
                        elseif data.buffType == BuffSpell.POISON then
                            spell = POISON_SPELL
                            order = POISON_ORDER
                        elseif data.buffType == BuffSpell.CURSE then
                            spell = CURSE_SPELL
                            order = CURSE_ORDER
                        elseif data.buffType == BuffSpell.SLEEP then
                            spell = SLEEP_SPELL
                            order = SLEEP_ORDER
                        elseif data.buffType == BuffSpell.SLOW then
                            spell = SLOW_SPELL
                            order = SLOW_ORDER
                        elseif data.buffType == BuffSpell.PURGE then
                            spell = PURGE_SPELL
                            order = PURGE_ORDER
                        end
                        DummyCast(missile.owner,GetUnitX(caster), GetUnitY(caster), spell, order, data.buffLevel, CastType.TARGET, target)
                    end
                end
            end
            missile:launch()
        end)
    end

    ---@param data {spell: integer, strDmgFactor: number?, agiDmgFactor: number?, intDmgFactor: number?, attackFactor: number?, missileCount: integer, missileModel: string, zOffsetSource: number, zOffsetTarget: number, area: number, scale: number, speed: number, arc: number, pColor: integer?, attType: attacktype, dmgType: damagetype, targetEffect: string?, buffType: BuffSpell?}
    function CreateMultipleMissilesSpell(data)
        data.strDmgFactor = data.strDmgFactor or 0
        data.agiDmgFactor = data.strDmgFactor or 0
        data.intDmgFactor = data.strDmgFactor or 0
        data.attackFactor = data.attackFactor or 0

        RegisterSpellEffectEvent(data.spell, function ()
            local caster = GetSpellAbilityUnit()
            local owner = GetOwningPlayer(caster)
            local cx = GetUnitX(caster)
            local cy = GetUnitY(caster)
            local x = GetSpellTargetX()
            local y = GetSpellTargetY()
            -- Calculating the damage
            local damage = (GetAttributeDamage(caster, data.strDmgFactor, data.agiDmgFactor, data.intDmgFactor) +
                           GetAvarageAttack(caster) * data.attackFactor)
            -- --
            damage = damage * 2 / data.missileCount
            local counter = data.missileCount
            Timed.echo(0.125, function ()
                if counter == 0 or GetUnitCurrentOrder(caster) ~= Orders.clusterrockets then return true end
                local angle = 2 * math.pi * math.random()
                local dist = data.area * math.random()
                local tx = x + dist * math.cos(angle)
                local ty = y + dist * math.sin(angle)
                local missile = Missiles:create(cx, cy, data.zOffsetSource, tx, ty, data.zOffsetTarget)
                missile.source = caster
                missile.owner = owner
                missile.damage = damage
                missile:scale(data.scale)
                missile:model(data.missileModel)
                missile:speed(data.speed)
                missile:arc(data.arc)
                missile.onFinish = function ()
                    ForUnitsInRange(missile.x, missile.y, data.area, function (u)
                        if IsUnitEnemy(u, missile.owner) then
                            Damage.apply(caster, u, damage, true, false, data.attType, data.dmgType, WEAPON_TYPE_WHOKNOWS)
                            if data.targetEffect then
                                DestroyEffect(AddSpecialEffect(data.targetEffect, GetUnitX(u), GetUnitY(u)))
                            end
                            if data.buffType then
                                if data.buffType == BuffSpell.POISON then
                                    PoisonUnit(caster, u)
                                else
                                    local spell, order
                                    if data.buffType == BuffSpell.REDUCE_ARMOR then
                                        spell = ARMOR_REDUCE_SPELL
                                        order = ARMOR_REDUCE_ORDER
                                    elseif data.buffType == BuffSpell.ICE then
                                        spell = ICE_SPELL
                                        order = ICE_ORDER
                                    elseif data.buffType == BuffSpell.FREEZE then
                                        spell = FREEZE_SPELL
                                        order = FREEZE_ORDER
                                    elseif data.buffType == BuffSpell.STUN then
                                        spell = STUN_SPELL
                                        order = STUN_ORDER
                                    elseif data.buffType == BuffSpell.POISON then
                                        spell = POISON_SPELL
                                        order = POISON_ORDER
                                    elseif data.buffType == BuffSpell.CURSE then
                                        spell = CURSE_SPELL
                                        order = CURSE_ORDER
                                    elseif data.buffType == BuffSpell.SLEEP then
                                        spell = SLEEP_SPELL
                                        order = SLEEP_ORDER
                                    elseif data.buffType == BuffSpell.SLOW then
                                        spell = SLOW_SPELL
                                        order = SLOW_ORDER
                                    elseif data.buffType == BuffSpell.PURGE then
                                        spell = PURGE_SPELL
                                        order = PURGE_ORDER
                                    end
                                    DummyCast(missile.owner,GetUnitX(caster), GetUnitY(caster), spell, order, data.buffLevel, CastType.TARGET, target)
                                end
                            end
                        end
                    end)
                end
                missile:launch()
                counter = counter - 1
            end)
        end)
    end
end)
Debug.endFile()