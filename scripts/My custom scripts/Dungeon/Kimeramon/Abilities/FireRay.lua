Debug.beginFile("Kimeramon\\Abilities\\FireRay")
OnInit(function ()
    Require "BossFightUtils"
    local ProgressBar = Require "ProgressBar" ---@type ProgressBar

    local SPELL = FourCC('A0GE')
    local DELAY = 2. -- Same as object editor
    local DMG_PER_TICK = 4.
    local DISTANCE = 1250.
    local DURATION = 15.
    local RAY = "HWSB"
    local FIRE_EFFECT = "Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl"
    local RED = Color.new(0xFF0000)
    local YELLOW = Color.new(0xFFFF00)

    local t = CreateTrigger()
    TriggerRegisterPlayerUnitEvent(t, Digimon.VILLAIN, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
    TriggerAddCondition(t, Condition(function () return GetSpellAbilityId() == SPELL end))
    TriggerAddAction(t, function ()
        local caster = GetSpellAbilityUnit()
        SetUnitAnimation(caster, "spell")

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_RED)
        bar:setZOffset(300)
        bar:setSize(1.5)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, DELAY, function ()
            if not UnitAlive(caster) then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/DELAY)*100, 1)
        end, function ()
            bar:destroy()
        end)
    end)

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local x, y = GetUnitX(caster), GetUnitY(caster)
        local face = math.rad(GetUnitFacing(caster))
        local lightnings = {} ---@type lightning[]
        SetUnitMoveSpeed(caster, 200)
        for i = -5, 5 do
            local xOffset = x + 8*i*math.cos(face+math.pi/2)
            local yOffset = y + 8*i*math.sin(face+math.pi/2)
            local newX, newY = xOffset + DISTANCE*math.cos(face), yOffset + DISTANCE*math.sin(face)
            lightnings[i] = AddLightningEx(RAY, true, xOffset, yOffset, GetUnitZ(caster, true) + 100, newX, newY, GetPosZ(newX, newY))
            SetLightningColor(lightnings[i], RED:lerp(YELLOW, math.exp(-(i/2)^2)))
        end
        local oldTurn = BlzGetUnitRealField(caster, UNIT_RF_TURN_RATE)
        BlzSetUnitWeaponBooleanField(caster, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, false)
        BlzSetUnitWeaponBooleanField(caster, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, false)
        BlzSetUnitRealField(caster, UNIT_RF_TURN_RATE, 0.05)

        local function onFinish()
            SetUnitMoveSpeed(caster, GetUnitDefaultMoveSpeed(caster))
            for i = -5, 5 do
                DestroyLightning(lightnings[i])
            end
            BlzSetUnitWeaponBooleanField(caster, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, true)
            BlzSetUnitWeaponBooleanField(caster, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, true)
            BlzSetUnitRealField(caster, UNIT_RF_TURN_RATE, oldTurn)
        end

        local tick = 0
        Timed.echo(0.02, DURATION, function ()
            x, y = GetUnitX(caster), GetUnitY(caster)

            for i = -5, 5 do
                local xOffset = x + 8*i*math.cos(face+math.pi/2)
                local yOffset = y + 8*i*math.sin(face+math.pi/2)
                local newX, newY = xOffset + DISTANCE*math.cos(face), yOffset + DISTANCE*math.sin(face)
                MoveLightningEx(lightnings[i], true, xOffset, yOffset, GetUnitZ(caster, true) + 100, newX, newY, GetPosZ(newX, newY))
            end

            if tick >= 5 then
                tick = 0
                local u = ZTS_GetThreatSlotUnit(caster, 1)
                if u then
                    SetUnitFacing(caster, math.deg(math.atan(GetUnitY(u) - y, GetUnitX(u) - x)))
                end
                face = math.rad(GetUnitFacing(caster))
                local ax, ay = x + 64*math.cos(face+math.pi/2), y + 64*math.sin(face+math.pi/2)
                local bx, by = x + 64*math.cos(face-math.pi/2), y + 64*math.sin(face-math.pi/2)
                local cx, cy = bx + DISTANCE*math.cos(face), by + DISTANCE*math.sin(face)
                local dx, dy = ax + DISTANCE*math.cos(face), ay + DISTANCE*math.sin(face)

                ForUnitsInRange(x, y, DISTANCE + 100, function (u2)
                    if IsUnitEnemy(caster, GetOwningPlayer(u2)) and IsPointInRectangle(ax, ay, bx, by, cx, cy, dx, dy, GetUnitX(u2), GetUnitY(u2)) then
                        Damage.apply(caster, u2, DMG_PER_TICK, false, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                        DestroyEffect(AddSpecialEffectTarget(FIRE_EFFECT, u2, "chest"))
                    end
                end)
            end
            tick = tick + 1
            if not UnitAlive(caster) then
                onFinish()
                return true
            end
        end, onFinish)
    end)
end)
Debug.endFile()