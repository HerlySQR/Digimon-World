Debug.beginFile("Flymon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O067_0406 ---@type unit
    local owner = GetOwningPlayer(boss)

    local MISSILE_MODEL = "Abilities\\Weapons\\HarpyMissile\\HarpyMissile.mdl"

    UnitAddAbility(boss, CROW_FORM_ID)
    UnitRemoveAbility(boss, CROW_FORM_ID)

    local CycloneOrder = Orders.cyclone
    local BeserkOrder = Orders.berserk

    local flying = false
    local waitFlying = 3

    InitBossFight({
        name = "Flymon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_52785},
        returnPlace = gg_rct_FlymonReturnPlace,
        inner = gg_rct_FlymonInner,
        entrance = gg_rct_FlymonEntrance,
        toTeleport = gg_rct_FlymonToReturn,
        spells = {
            FourCC('A06Z'), 100, Orders.charm, CastType.TARGET, -- Stinger
            FourCC('A06Y'), 50, Orders.blackarrow, CastType.POINT, -- Stinger Shots
            FourCC('A070'), 20, Orders.cloudoffog, CastType.TARGET -- Poison Powder
        },
        actions = function (u)
            if not (BossStillCasting(boss) or flying) then
                if math.random(0, 100) >= 80 then
                    IssueTargetOrderById(boss, CycloneOrder, u)
                else
                    IssueImmediateOrderById(boss, BeserkOrder)
                end

                waitFlying = waitFlying - 1
                if not flying and waitFlying <= 0 then
                    if math.random() < 0.2 then
                        waitFlying = 3
                        flying = true
                        SetUnitPathing(boss, false)
                        PauseUnit(boss, true)
                        local height = GetUnitZ(boss, false)

                        SetUnitFlyHeight(boss, 150, 300)

                        SetUnitAnimation(boss, "ready")

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
                                BlzSetUnitFacingEx(
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
                                        missile.owner = owner
                                        missile:speed(900)
                                        missile:model(MISSILE_MODEL)
                                        missile.onFinish = function ()
                                            ForUnitsInRange(missile.x, missile.y, 96, function (u2)
                                                if IsUnitEnemy(u2, owner) then
                                                    Damage.apply(boss, u2, 5, false, false, udg_Nature, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
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