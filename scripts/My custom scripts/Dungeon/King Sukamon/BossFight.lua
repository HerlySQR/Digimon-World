Debug.beginFile("King Sukamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O00X_0101 ---@type unit

    local WOD_WARD = FourCC('o00Y')
    local WOD_SLOW = FourCC('BUau')
    local WOD_DAMAGE_PER_SEC = 15.
    local WOD_AREA = 1000.
    local WOD_DURATION = 20.

    local function onWardOfDamage(caster, x, y)
        local owner = GetOwningPlayer(caster)
        SetUnitAnimation(caster, "spell")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            local ward = SummonMinion(caster, WOD_WARD, x, y, bj_UNIT_FACING, WOD_DURATION)
            Timed.echo(1.,function ()
                if ward:isAlive() then
                    ForUnitsInRange(x, y, WOD_AREA, function (u)
                        if UnitHasBuffBJ(u, WOD_SLOW) and IsUnitEnemy(u, owner) then
                            Damage.apply(caster, u, WOD_DAMAGE_PER_SEC, true, false, udg_Dark, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
                        end
                    end)
                else
                    return true
                end
            end)
        end)
    end

    local HM_MINION = FourCC('h01H')
    local HM_HEAL_FACTOR = 0.01
    local HM_LIGHTNING_MODEL = "HWPB"
    local HM_SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local HM_INTERVAL = 0.1
    local HM_HEAL_INTERVAL = 4.
    local HM_DISTANCE = 270.

    local function onHealingMinions(caster)
        SetUnitAnimation(caster, "spell")
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            local x, y = GetUnitX(caster), GetUnitY(caster)
            local angle = 0
            for _ = 1, 2 do
                angle = angle + math.pi + math.random() * math.pi/2
                local minion = SummonMinion(caster, HM_MINION, x + HM_DISTANCE*math.cos(angle), y + HM_DISTANCE*math.sin(angle), bj_UNIT_FACING)
                DestroyEffect(AddSpecialEffect(HM_SUMMON_EFFECT, minion:getPos()))
                local chain = AddLightningEx(HM_LIGHTNING_MODEL, true, minion:getX(), minion:getY(), minion:getZ() + 50, x, y, GetUnitZ(caster) + 75)
                local counter = 0
                Timed.echo(HM_INTERVAL, function ()
                    if minion:isAlive() then
                        minion:setFacing(math.deg(math.atan(GetUnitY(caster) - minion:getY(), GetUnitX(caster) - minion:getX())))
                        counter = counter + HM_INTERVAL
                        if counter >= HM_HEAL_INTERVAL then
                            counter = 0
                            SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + HM_HEAL_FACTOR * GetUnitState(caster, UNIT_STATE_MAX_LIFE))
                        end
                        MoveLightningEx(chain, true, minion:getX(), minion:getY(), minion:getZ() + 50, GetUnitX(caster), GetUnitY(caster), GetUnitZ(caster) + 75)
                    else
                        DestroyLightning(chain)
                        return true
                    end
                end)
            end
        end)
    end

    local t = CreateTrigger()
    TriggerRegisterVariableEvent(t, "udg_PreDamageEvent", EQUAL, 1.00)
    TriggerAddAction(t, function ()
        if GetUnitTypeId(udg_DamageEventTarget) == HM_MINION then
            udg_DamageEventAmount = 1.
        end
    end)

    local PC_DELAY = 2.5
    local PC_DAMAGE_PER_SHOT = 70.
    local PC_MAX_SHOTS = 10
    local PC_AREA = 200.
    local PC_MISSILE_MODEL = "Missile\\PoopMissile.mdx"
    local PC_INTERVAL = 0.03125

    local function onPoopChaos(caster, x, y)
        local owner = GetOwningPlayer(caster)
        local cx = GetUnitX(caster)
        local cy = GetUnitY(caster)

        PauseUnit(caster, true)
        BossIsCasting(caster, true)

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_PEANUT)
        bar:setZOffset(300)
        bar:setSize(1.5)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, PC_DELAY, function ()
            if not UnitAlive(caster) then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/PC_DELAY)*100, 1)
        end, function ()
            bar:destroy()
            if UnitAlive(caster) then
                local counter = PC_MAX_SHOTS
                Timed.echo(PC_INTERVAL, function ()
                    if counter == 0 then
                        PauseUnit(caster, false)
                        ResetUnitAnimation(caster)
                        BossIsCasting(caster, false)
                        return true
                    end
                    SetUnitAnimation(caster, "spell throw")

                    local angle = 2 * math.pi * math.random()
                    local dist = PC_AREA * math.random()
                    local tx = x + dist * math.cos(angle)
                    local ty = y + dist * math.sin(angle)
                    local missile = Missiles:create(cx, cy, 25, tx, ty, 0)
                    missile.source = caster
                    missile.owner = owner
                    missile:scale(2.5)
                    missile.damage = PC_DAMAGE_PER_SHOT
                    missile:model(PC_MISSILE_MODEL)
                    missile:speed(900.)
                    missile:arc(60.)
                    missile.onFinish = function ()
                        ForUnitsInRange(missile.x, missile.y, 128., function (u)
                            if IsUnitEnemy(u, missile.owner) then
                                Damage.apply(caster, u, PC_DAMAGE_PER_SHOT, true, false, udg_Dark, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
                            end
                        end)
                    end
                    missile:launch()
                    counter = counter - 1
                end)
            end
        end)
    end

    InitBossFight({
        name = "KingSukamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52792, gg_dest_Dofw_12379},
        inner = gg_rct_KingSukamonInner,
        entrance = gg_rct_KingSukamonEntrance,
        moveOption = 3,
        spells = {
            4, CastType.POINT, onWardOfDamage, -- Ward of damage
            0, CastType.IMMEDIATE, onHealingMinions, -- Healing Minions
            5, CastType.POINT, onPoopChaos -- Poop Chaos
        },
        extraSpells = {
            FourCC('A0B9'), Orders.firebolt, CastType.TARGET, -- Generic Missile
        },
        castCondition = function (spell)
            if spell == onHealingMinions then
                return GetUnitHPRatio(boss) < 0.5, true
            end
            return true
        end,
        actions = function (u)
        end
    })
end)
Debug.endFile()