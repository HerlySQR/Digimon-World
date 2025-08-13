Debug.beginFile("Flymon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O067_0406 ---@type unit
    local owner = GetOwningPlayer(boss)

    local MISSILE_MODEL = "Abilities\\Weapons\\HarpyMissile\\HarpyMissile.mdl"

    UnitAddAbility(boss, CROW_FORM_ID)
    UnitRemoveAbility(boss, CROW_FORM_ID)

    local flying = false
    local waitFlying = 6

    local SS_DELAY = 2.5
    local SS_DAMAGE_PER_SHOT = 48.
    local SS_MAX_SHOTS = 14
    local SS_AREA = 170.
    local SS_MISSILE_MODEL = "Abilities\\Weapons\\HarpyMissile\\HarpyMissile.mdl"
    local SS_INTERVAL = 0.03125

    local function onStingerShots(caster, x, y)
        local cx = GetUnitX(caster)
        local cy = GetUnitY(caster)

        PauseUnit(caster, true)
        SetUnitAnimation(caster, "spell")
        BossIsCasting(caster, true)

        Timed.call(0.5, function ()
            local bar = ProgressBar.create()
            bar:setColor(PLAYER_COLOR_PEANUT)
            bar:setZOffset(300)
            bar:setSize(1.3)
            bar:setTargetUnit(caster)

            local progress = 0
            Timed.echo(0.02, SS_DELAY, function ()
                if not UnitAlive(caster) then
                    bar:destroy()
                    return true
                end
                progress = progress + 0.02
                bar:setPercentage((progress/SS_DELAY)*100, 1)
            end, function ()
                bar:destroy()
                if UnitAlive(caster) then
                    local counter = SS_MAX_SHOTS
                    Timed.echo(SS_INTERVAL, function ()
                        if counter == 0 then
                            PauseUnit(caster, false)
                            ResetUnitAnimation(caster)
                            BossIsCasting(caster, false)
                            return true
                        end
                        SetUnitAnimation(caster, "spell throw")

                        local angle = 2 * math.pi * math.random()
                        local dist = SS_AREA * math.random()
                        local tx = x + dist * math.cos(angle)
                        local ty = y + dist * math.sin(angle)
                        local missile = Missiles:create(cx, cy, 25, tx, ty, 0)
                        missile.source = caster
                        missile.owner = GetOwningPlayer(caster)
                        missile.damage = SS_DAMAGE_PER_SHOT
                        missile:model(SS_MISSILE_MODEL)
                        missile:speed(900.)
                        missile:arc(60.)
                        missile.onFinish = function ()
                            ForUnitsInRange(missile.x, missile.y, 128., function (u)
                                if IsUnitEnemy(u, missile.owner) then
                                    Damage.apply(caster, u, SS_DAMAGE_PER_SHOT, true, false, udg_Nature, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                                end
                            end)
                        end
                        missile:launch()
                        counter = counter - 1
                    end)
                end
            end)
        end)
    end

    local PP_DAMAGE_PER_SEC = 15.
    local PP_DURATION = 8.
    local PP_AREA = 300.
    local PP_CLOUD_MODEL = "Abilities\\Spells\\Undead\\PlagueCloud\\PlagueCloudCaster.mdl"
    local PP_INTERVAL = 1.0

    local function onPoisonPowder(caster, x, y)
        PauseUnit(caster, true)
        SetUnitAnimation(caster, "spell")

        Timed.call(0.5, function ()
            PauseUnit(caster, false)
            ResetUnitAnimation(caster)

            local eff = AddSpecialEffect(PP_CLOUD_MODEL, x, y)
            Timed.echo(PP_INTERVAL, PP_DURATION, function ()
                ForUnitsInRange(x, y, PP_AREA, function (u)
                    if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                        Damage.apply(caster, u, PP_DAMAGE_PER_SEC, true, false, udg_Nature, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
                        -- Poison
                        if not UnitHasBuffBJ(u, POISON_BUFF) then
                            PoisonUnit(caster, u)
                        end
                    end
                end)
            end, function ()
                DestroyEffect(eff)
            end)
        end)
    end

    BlzSetUnitAbilityCooldown(boss, FourCC('A0AB'), 0, 24)

    InitBossFight({
        name = "Flymon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_52785},
        inner = gg_rct_FlymonInner,
        entrance = gg_rct_FlymonEntrance,
        moveOption = 3,
        spells = {
            0, CastType.POINT, onStingerShots, -- Stinger Shots
            3, CastType.POINT, onPoisonPowder -- Poison Powder
        },
        extraSpells = {
            FourCC('A0AB'), Orders.cyclone, CastType.TARGET, -- Cyclone
            FourCC('A07A'), Orders.berserk, CastType.IMMEDIATE, -- Berserk
            FourCC('A06Z'), Orders.charm, CastType.TARGET, -- Stinger
        },
        castCondition = function ()
            return not flying
        end,
        actions = function (u)
            if not flying then
                waitFlying = waitFlying - 1
                if not flying and waitFlying <= 0 and not BossStillCasting(boss) then
                    if math.random() < 0.1 then
                        waitFlying = 6
                        flying = true
                        SetUnitPathing(boss, false)
                        PauseUnit(boss, true)
                        local height = GetUnitZ(boss, false)

                        SetUnitFlyHeight(boss, 150, 300)

                        SetUnitAnimation(boss, "ready")

                        BossIsCasting(boss, true)
                        BossCanLeave(boss, true)

                        Timed.call(2., function ()
                            local centerX, centerY = GetUnitX(boss), GetUnitY(boss)
                            local theta = -math.pi/4
                            local factor = 1
                            local stepSize = 0.001
                            local rotation = 2*math.pi*math.random()
                            Timed.echo(0.02, function ()
                                if math.cos(2*theta) < 0 then
                                    theta = theta + math.pi/2
                                    factor = -factor
                                else
                                    theta = theta + stepSize
                                end

                                local posX = 1000*math.sqrt(math.cos(2*theta))*math.cos(theta)
                                local posY = 1000*math.sqrt(math.cos(2*theta))*math.sin(theta)*factor
                                -- Rotation
                                posX, posY = centerX + posX*math.cos(rotation) - posY*math.sin(rotation), centerY + posX*math.sin(rotation) + posY*math.cos(rotation)
                                local posZ = 200 + 100*math.sin(theta) + (height - GetUnitZ(boss, false))
                                SetUnitFlyHeight(boss, posZ, 99999.)

                                SetUnitPosition(boss, posX, posY)
                                SetUnitFacing(
                                    boss,
                                    math.deg(math.atan(
                                        -math.sin(3*theta)/math.sqrt(math.cos(2*theta))*factor,
                                        math.cos(3*theta)/math.sqrt(math.cos(2*theta))
                                    ))
                                )

                                if posZ <= 300 then
                                    for _ = 1, 3 do
                                        local angle = 2*math.pi*math.random()
                                        local dist = 250*math.random()
                                        local missile = Missiles:create(posX, posY, posZ, posX + dist*math.cos(angle), posY + dist*math.sin(angle), 0)
                                        missile:arc(35)
                                        missile:scale(0.5)
                                        missile.owner = owner
                                        missile:speed(900)
                                        missile:model(MISSILE_MODEL)
                                        missile.onFinish = function ()
                                            ForUnitsInRange(missile.x, missile.y, 96, function (u2)
                                                if IsUnitEnemy(u2, owner) then
                                                    Damage.apply(boss, u2, 10, false, false, udg_Nature, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                                                end
                                            end)
                                        end
                                        missile:launch()
                                    end
                                end

                                if theta < 0 then
                                    stepSize = math.min(stepSize + 0.00001, 0.0075)
                                elseif theta > 2*math.pi and theta <= 9*math.pi/4 then
                                    stepSize = math.max(stepSize - 0.00001, 0.0025)
                                elseif theta > 9*math.pi/4 or not UnitAlive(boss) then
                                    ResetUnitAnimation(boss)
                                    SetUnitPathing(boss, true)
                                    PauseUnit(boss, false)
                                    SetUnitFlyHeight(boss, GetUnitDefaultFlyHeight(boss), 400)
                                    BossCanLeave(boss, false)
                                    BossIsCasting(boss, false)
                                    flying = false
                                    return true
                                end
                            end)
                        end)
                    end
                end
            end
        end
    })
end)
Debug.endFile()