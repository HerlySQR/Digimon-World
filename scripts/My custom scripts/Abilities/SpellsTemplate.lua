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

    local SLOW_ALTER = FourCC('A0IJ')

    ---@param data table
    ---@param missile table
    ---@param target unit
    local function applyEffects(data, missile, target)
        Damage.apply(missile.source, target, missile.damage, false, false, data.attType, data.dmgType, WEAPON_TYPE_WHOKNOWS)
        if data.targetEffect then
            DestroyEffect(AddSpecialEffect(data.targetEffect, GetUnitX(target), GetUnitY(target)))
        end
        if data.buffType then
            if data.buffType == BuffSpell.POISON then
                PoisonUnit(missile.source, target)
            else
                local spell, order
                if data.buffType == BuffSpell.REDUCE_ARMOR then
                    spell = ARMOR_REDUCE_SPELL
                    order = ARMOR_REDUCE_ORDER
                elseif data.buffType == BuffSpell.ICE then
                    spell = ICE_SPELL
                    order = ICE_ORDER
                elseif data.buffType == BuffSpell.FREEZE then
                    if IsUnitType(target, UNIT_TYPE_GIANT) then
                        spell = ICE_SPELL
                        order = ICE_ORDER
                    else
                        spell = FREEZE_SPELL
                        order = FREEZE_ORDER
                    end
                elseif data.buffType == BuffSpell.STUN then
                    if IsUnitType(target, UNIT_TYPE_GIANT) then
                        spell = SLOW_ALTER
                        order = SLOW_ORDER
                    else
                        spell = STUN_SPELL
                        order = STUN_ORDER
                    end
                elseif data.buffType == BuffSpell.CURSE then
                    spell = CURSE_SPELL
                    order = CURSE_ORDER
                elseif data.buffType == BuffSpell.SLEEP then
                    if IsUnitType(target, UNIT_TYPE_GIANT) then
                        spell = CURSE_SPELL
                        order = CURSE_ORDER
                    else
                        spell = SLEEP_SPELL
                        order = SLEEP_ORDER
                    end
                elseif data.buffType == BuffSpell.SLOW then
                    spell = SLOW_SPELL
                    order = SLOW_ORDER
                elseif data.buffType == BuffSpell.PURGE then
                    spell = PURGE_SPELL
                    order = PURGE_ORDER
                end
                DummyCast(missile.owner, GetUnitX(missile.source), GetUnitY(missile.source), spell, order, data.buffLevel, CastType.TARGET, target)
            end
        end
    end

    ---@param data table
    local function baseSingleMissileSpell(data)
        data.strDmgFactor = data.strDmgFactor or 0
        data.agiDmgFactor = data.strDmgFactor or 0
        data.intDmgFactor = data.strDmgFactor or 0
        data.attackFactor = data.attackFactor or 0
        data.finalDmgFactor = data.finalDmgFactor or 1
        if data.buffType then
            data.buffLevel = data.buffLevel or 1
        end

        RegisterSpellEffectEvent(data.spell, function ()
            local caster = GetSpellAbilityUnit()
            local target = GetSpellTargetUnit()
            local targetX, targetY
            if target then
                targetX, targetY = GetUnitX(target), GetUnitY(target)
            else
                targetX, targetY = GetSpellTargetX(), GetSpellTargetY()
            end
            -- Calculating the damage
            local damage = (GetAttributeDamage(caster, data.strDmgFactor, data.agiDmgFactor, data.intDmgFactor) +
                           GetAvarageAttack(caster) * data.attackFactor)*data.finalDmgFactor
            -- Create the missile
            local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), data.zOffsetSource, targetX, targetY, data.zOffsetTarget)
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
                data.onFinish(missile)
            end
            missile:launch()
        end)
    end

    ---@param data {spell: integer, strDmgFactor: number?, agiDmgFactor: number?, intDmgFactor: number?, attackFactor: number?, finalDmgFactor: number?, missileModel: string, zOffsetSource: number, zOffsetTarget: number, scale: number, speed: number, arc: number, pColor: integer?, attType: attacktype, dmgType: damagetype, casterEffect: string?, targetEffect: string?, buffType: BuffSpell?, buffLevel: integer?, onFinish: fun(missile: Missiles)?}
    function CreateSingleMissileSpell(data)
        data.onFinish = function (missile)
            applyEffects(data, missile, missile.target)
        end
        baseSingleMissileSpell(data)
    end

    ---@param data {spell: integer, strDmgFactor: number?, agiDmgFactor: number?, intDmgFactor: number?, attackFactor: number?, finalDmgFactor: number?, missileModel: string, zOffsetSource: number, zOffsetTarget: number, scale: number, speed: number, arc: number, pColor: integer?, attType: attacktype, dmgType: damagetype, casterEffect: string?, targetEffect: string?, buffType: BuffSpell?, buffLevel: integer?, onFinish: fun(missile: Missiles)?}
    function CreateAreaMissileSpell(data)
        data.onFinish = function (missile)
            ForUnitsInRange(missile.x, missile.y, BlzGetAbilityRealLevelField(BlzGetUnitAbility(missile.source, data.spell), ABILITY_RLF_AREA_OF_EFFECT, GetUnitAbilityLevel(missile.source, data.spell) - 1), function (u)
                if IsUnitEnemy(u, missile.owner) then
                    applyEffects(data, missile, u)
                end
            end)
        end
        baseSingleMissileSpell(data)
    end

    ---@param data {spell: integer, strDmgFactor: number?, agiDmgFactor: number?, intDmgFactor: number?, attackFactor: number?, finalDmgFactor: number?, dmgPerSecFactor: number, missileModel: string, zOffsetSource: number, zOffsetTarget: number, scale: number, speed: number, arc: number, fragmentsOffset: number, pColor: integer?, attType: attacktype, dmgType: damagetype, casterEffect: string?, targetEffect: string?, fragmentsEffect: string?, buffType: BuffSpell?, buffLevel: integer?, onFinish: fun(missile: Missiles)?}
    function CreateFragmentsSpell(data)
        data.dmgPerSecFactor = data.dmgPerSecFactor or 0
        data.onFinish = function (missile)
            local affected = {}
            local area = BlzGetAbilityRealLevelField(BlzGetUnitAbility(missile.source, data.spell), ABILITY_RLF_AREA_OF_EFFECT, GetUnitAbilityLevel(missile.source, data.spell) - 1)
            ForUnitsInRange(missile.x, missile.y, area, function (u)
                if IsUnitEnemy(u, missile.owner) then
                    Damage.apply(missile.source, u, missile.damage, true, false, data.attType, data.dmgType, WEAPON_TYPE_WHOKNOWS)
                    affected[u] = true
                end
            end)
            -- Start the spell
            local mx = missile.x
            local my = missile.y
            local dur = 1
            local offset = area * data.fragmentsOffset
            local dmgPerSec = missile.damage * data.dmgPerSecFactor
            Timed.echo(1., function ()
                if dur > 0 then
                    dur = dur - 1
                    -- Effects
                    if data.fragmentsEffect then
                        DestroyEffect(AddSpecialEffect(data.fragmentsEffect, mx, my))
                        for i = 1, 6 do
                            local angle = (math.pi / 3) * i
                            local x = mx + offset * math.cos(angle)
                            local y = my + offset * math.sin(angle)
                            DestroyEffect(AddSpecialEffect(data.fragmentsEffect, x, y))
                        end
                    end
                    -- Enum the enemies
                    ForUnitsInRange(mx, my, area, function (u)
                        if IsUnitEnemy(u, missile.owner) and not affected[u] then
                            Damage.apply(missile.source, u, dmgPerSec, true, false, data.attType, data.dmgType, WEAPON_TYPE_WHOKNOWS)
                            affected[u] = true
                        end
                    end)
                else
                    return true
                end
            end)
        end
        baseSingleMissileSpell(data)
    end

    ---@param data {spell: integer, strDmgFactor: number?, agiDmgFactor: number?, intDmgFactor: number?, attackFactor: number?, finalDmgFactor: number?, missileCount: integer, missileModel: string, zOffsetSource: number, zOffsetTarget: number, scale: number, speed: number, arc: number, pColor: integer?, attType: attacktype, dmgType: damagetype, casterEffect: string?, targetEffect: string?, buffType: BuffSpell?, buffLevel: integer?}
    function CreateMultipleMissilesSpell(data)
        data.strDmgFactor = data.strDmgFactor or 0
        data.agiDmgFactor = data.strDmgFactor or 0
        data.intDmgFactor = data.strDmgFactor or 0
        data.attackFactor = data.attackFactor or 0
        data.finalDmgFactor = data.finalDmgFactor or 1
        if data.buffType then
            data.buffLevel = data.buffLevel or 1
        end

        RegisterSpellEffectEvent(data.spell, function ()
            local caster = GetSpellAbilityUnit()
            local owner = GetOwningPlayer(caster)
            local cx = GetUnitX(caster)
            local cy = GetUnitY(caster)
            local x = GetSpellTargetX()
            local y = GetSpellTargetY()
            local area = BlzGetAbilityRealLevelField(BlzGetUnitAbility(caster, data.spell), ABILITY_RLF_AREA_OF_EFFECT, GetUnitAbilityLevel(caster, data.spell) - 1)
            -- Calculating the damage
            local damage = (GetAttributeDamage(caster, data.strDmgFactor, data.agiDmgFactor, data.intDmgFactor) +
                           GetAvarageAttack(caster) * data.attackFactor)
            -- --
            damage = damage / data.missileCount
            local counter = data.missileCount
            Timed.echo(0.125, function ()
                if counter == 0 or GetUnitCurrentOrder(caster) ~= Orders.clusterrockets then return true end
                local angle = 2 * math.pi * math.random()
                local dist = area * math.random()
                local tx = x + dist * math.cos(angle)
                local ty = y + dist * math.sin(angle)
                local missile = Missiles:create(cx, cy, data.zOffsetSource, tx, ty, data.zOffsetTarget)
                missile.source = caster
                missile.owner = owner
                missile.damage = damage
                missile:model(data.missileModel)
                missile:scale(data.scale)
                missile:speed(data.speed)
                missile:arc(data.arc)
                missile.onFinish = function ()
                    ForUnitsInRange(missile.x, missile.y, area, function (u)
                        if IsUnitEnemy(u, missile.owner) then
                            applyEffects(data, missile, u)
                        end
                    end)
                end
                missile:launch()
                counter = counter - 1
            end)
        end)
    end

    ---@param data {spell: integer, strDmgFactor: number?, agiDmgFactor: number?, intDmgFactor: number?, attackFactor: number?, finalDmgFactor: number?, maxRange: number, collision: number, missileModel: string, zOffsetSource: number, zOffsetTarget: number, scale: number, speed: number, arc: number, pColor: integer?, attType: attacktype, dmgType: damagetype, casterEffect: string?, targetEffect: string?, buffType: BuffSpell?, buffLevel: integer?}
    function CreateWaveSpell(data)
        data.strDmgFactor = data.strDmgFactor or 0
        data.agiDmgFactor = data.strDmgFactor or 0
        data.intDmgFactor = data.strDmgFactor or 0
        data.attackFactor = data.attackFactor or 0
        data.finalDmgFactor = data.finalDmgFactor or 1
        if data.buffType then
            data.buffLevel = data.buffLevel or 1
        end

        --[[
            Grow the wave up to the double of the original size
            The calculations are (considering the period = 0.025 seconds)
            700 max range / 1050 speed / period = aprox 27 instances

            150 / 27 = aprox 5.56
            1 / 27 = aprox 0.04
        ]]
        local instances = data.maxRange / data.speed / 0.025
        local extraCollision = 150 / instances
        local extraScale = 1 / instances

        RegisterSpellEffectEvent(data.spell, function ()
            local caster = GetSpellAbilityUnit()
            local x = GetUnitX(caster)
            local y = GetUnitY(caster)
            local angle = math.atan(GetSpellTargetY() - y, GetSpellTargetX() - x)
            -- Calculating the damage
            local damage = (GetAttributeDamage(caster, data.strDmgFactor, data.agiDmgFactor, data.intDmgFactor) +
                           GetAvarageAttack(caster) * data.attackFactor) * data.finalDmgFactor
            -- Create the missile
            local missile = Missiles:create(x, y, data.zOffsetSource, x + data.maxRange * math.cos(angle), y + data.maxRange * math.sin(angle), data.zOffsetTarget)
            missile.source = caster
            missile.owner = GetOwningPlayer(caster)
            missile.damage = damage
            missile:model(data.missileModel)
            missile:speed(data.speed)
            missile:scale(data.scale)
            missile:arc(data.arc)
            missile.collision = data.collision
            missile:scale(data.scale)
            missile.collideZ = true
            missile.onPeriod = function ()
                missile.collision = missile.collision + extraCollision
                missile:scale(missile.Scale + extraScale)
            end
            missile.onHit = function (u)
                if IsUnitEnemy(u, missile.owner) and GetUnitAbilityLevel(u, LOCUST_ID) == 0 then
                    applyEffects(data, missile, u)
                end
            end
            missile:launch()
        end)
    end

    ---@param data {spell: integer, strDmgFactor: number?, agiDmgFactor: number?, intDmgFactor: number?, attackFactor: number?, finalDmgFactor: number?, attType: attacktype, dmgType: damagetype, casterEffect: string?, targetEffect: string?, buffType: BuffSpell?, buffLevel: integer?}
    function CreateImmediateAreaTargetSpell(data)
        data.strDmgFactor = data.strDmgFactor or 0
        data.agiDmgFactor = data.strDmgFactor or 0
        data.intDmgFactor = data.strDmgFactor or 0
        data.attackFactor = data.attackFactor or 0
        data.finalDmgFactor = data.finalDmgFactor or 1
        if data.buffType then
            data.buffLevel = data.buffLevel or 1
        end

        RegisterSpellEffectEvent(data.spell, function ()
            local caster = GetSpellAbilityUnit()
            local owner = GetOwningPlayer(caster)
            local x = GetUnitX(caster)
            local y = GetUnitY(caster)
            local area = BlzGetAbilityRealLevelField(BlzGetUnitAbility(caster, data.spell), ABILITY_RLF_AREA_OF_EFFECT, GetUnitAbilityLevel(caster, data.spell) - 1)

            if data.casterEffect then
                local eff = AddSpecialEffect(data.casterEffect, x, y)
                DestroyEffectTimed(eff, 2.)
            end

            local damage = (GetAttributeDamage(caster, data.strDmgFactor, data.agiDmgFactor, data.intDmgFactor) +
                           GetAvarageAttack(caster) * data.attackFactor) * data.finalDmgFactor

            ForUnitsInRange(x, y, area, function (u)
                if IsUnitEnemy(u, owner) then
                    applyEffects(data, {source = caster, owner = owner, damage = damage}, u)
                end
            end)
        end)
    end
end)
Debug.endFile()