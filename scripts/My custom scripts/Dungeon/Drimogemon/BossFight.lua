Debug.beginFile("Drimogemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O060_0442 ---@type unit

    local movingEarthquake = FourCC('A02F')
    local hunger = FourCC('A0AG')

    local D_MAX_DIST = 400.
    local D_KB_DIST = 150.
    local D_DAMAGE = 85.
    local D_COLLISION = 192.
    local D_INTERVAL = 0.03125

    local function onDash(caster, tx, ty)
        local owner = GetOwningPlayer(caster)
        SetUnitAnimation(caster, "spell three")

        Timed.call(0.5, function ()
            local angle = math.atan(ty - GetUnitY(caster), tx - GetUnitX(caster))
            local affected = Set.create()
            local reached = 0
            Timed.echo(D_INTERVAL, function ()
                local x = GetUnitX(caster)
                local y = GetUnitY(caster)
                if reached < D_MAX_DIST then
                    x = x + 50 * math.cos(angle)
                    y = y + 50 * math.sin(angle)
                    if not IsTerrainWalkable(x, y) then
                        ResetUnitAnimation(caster)
                        return true
                    else
                        SetUnitPosition(caster, x, y)
                        ForUnitsInRange(x, y, D_COLLISION, function (u)
                            if not affected:contains(u) and IsUnitEnemy(u, owner) then
                                affected:addSingle(u)
                                Damage.apply(caster, u, D_DAMAGE, true, false, udg_Dark, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
                                -- Knockback
                                if not IsUnitType(u, UNIT_TYPE_GIANT) then
                                    Knockback(
                                        u,
                                        math.atan(GetUnitY(u) - GetUnitY(caster), GetUnitX(u) - GetUnitX(caster)),
                                        D_KB_DIST,
                                        500.,
                                        "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl",
                                        nil
                                    )
                                end
                            end
                        end)
                    end
                else
                    ResetUnitAnimation(caster)
                    return true
                end
                reached = reached + 50
            end)
        end)
    end

    local ME_AREA = 300.
    local ME_DURATION = 22.
    local ME_ROCK_ID = FourCC('o063')

    local ME_nodes = GetRects("MovingEarthQuakeNode")

    local function onEarthQuake(caster, tx, ty)
        local owner = GetOwningPlayer(caster)
        SetUnitAnimation(caster, "spell")

        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)

            local rock = SummonMinion(caster, ME_ROCK_ID, tx, ty, 0, ME_DURATION)
            SetUnitAnimation(rock.root, "death")
            local eff = AddSpecialEffect("Abilities\\Spells\\Orc\\EarthQuake\\EarthQuakeTarget.mdl", tx, ty)
            local actNode = 0
            local options = Set.create()
            Timed.echo(1., function ()
                if not rock:isAlive() then
                    DestroyEffect(eff)
                    return true
                end
                SetUnitAnimation(rock.root, "stand")
                if math.random(3) == 3 then
                    for i = 1, #ME_nodes do
                        if i ~= actNode then
                            options:addSingle(i)
                        end
                    end
                    actNode = options:random()
                    rock:issueOrder(Orders.move, GetRectCenterX(ME_nodes[actNode]), GetRectCenterY(ME_nodes[actNode]))
                end
                local x, y = rock:getPos()
                ForUnitsInRange(x, y, ME_AREA, function (u)
                    if IsUnitEnemy(u, owner) then
                        -- Slow
                        if not UnitHasBuffBJ(u, FourCC('Bchd')) then
                            DummyCast(owner, x, y, SLOW_SPELL, SLOW_ORDER, 1, CastType.TARGET, u)
                        end
                    end
                end)
                BlzSetSpecialEffectPosition(eff, x, y, BlzGetLocalSpecialEffectZ(eff))
            end)
        end)
    end

    local B_DURATION = 4.
    local B_DAMAGE = 105.
    local B_RANGE = 600.
    local B_AREA = 110.
    local B_CASTER_MODEL = "war3mapImported\\Drimogemon.mdl"
    local B_INTERVAL = 0.02
    local B_Z_DIFF = B_INTERVAL * 150.
    local B_PITCH_DIFF = (math.pi/4) * B_INTERVAL

    local function onBurrow(caster)
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)

        -- Burrow effect
        ShowUnitHide(caster)
        BossIsCasting(caster, true)
        PauseUnit(caster, true)

        local dust = AddSpecialEffect("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl", x, y)
        BlzSetSpecialEffectScale(dust, 2.)
        DestroyEffect(dust)

        local eff = AddSpecialEffect(B_CASTER_MODEL, x, y)
        BlzSetSpecialEffectScale(eff, BlzGetUnitRealField(caster, UNIT_RF_SCALING_VALUE))
        local yaw = GetUnitFacing(caster) * bj_DEGTORAD
        BlzSetSpecialEffectOrientation(eff, yaw, 0, 0)
        BlzSpecialEffectAddSubAnimation(eff, SUBANIM_TYPE_TWO)
        BlzSetSpecialEffectZ(eff, GetUnitZ(caster, true))
        local z = BlzGetLocalSpecialEffectZ(eff)
        local pitch = 0
        Timed.echo(B_INTERVAL, 1., function ()
            BlzPlaySpecialEffect(eff, ANIM_TYPE_SPELL)
            z = z - B_Z_DIFF
            pitch = pitch + B_PITCH_DIFF
            BlzSetSpecialEffectOrientation(eff, yaw, pitch, 0)
            BlzSetSpecialEffectZ(eff, z)
        end, function ()
            BlzSetSpecialEffectScale(eff, 0.01)
        end)

        Timed.call(1.5, function ()
            Timed.echo(0.05, B_DURATION, function ()
                CameraSetSourceNoise(0, 0)
                CameraSetTargetNoise(0, 0)

                -- Show an earthquake effect only if the player is seeing the place where the effect is casted
                if DistanceBetweenCoords(GetCameraTargetPositionX(), GetCameraTargetPositionY(), x, y) <= B_RANGE then
                    CameraSetTargetNoiseEx(10., 500000, true)
                    CameraSetSourceNoiseEx(10., 500000, true)
                end

                local chance = math.random(0, 100)
                if chance <= 20 then
                    for _ = 1, math.random(4) do
                        local angle = 2 * math.pi * math.random()
                        local dist = B_RANGE * math.random()
                        local tx = x + dist * math.cos(angle)
                        local ty = y + dist * math.sin(angle)
                        -- Falls a rock
                        local rock = Missiles:create(tx, ty, 640., tx, ty, 0.)
                        rock.source = caster
                        rock.owner = owner
                        rock.damage = B_DAMAGE
                        rock:model("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl")
                        rock:speed(0.)
                        rock.collision = 0
                        rock.collideZ = true
                        -- Gravity
                        rock.onPeriod = function ()
                            rock:speed(rock.Speed + 0.025)
                        end
                        rock.onFinish = function ()
                            ForUnitsInRange(tx, ty, B_AREA, function (u)
                                if IsUnitEnemy(u, owner) then
                                    Damage.apply(caster, u, B_DAMAGE, true, false, udg_Dark, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
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
                        rock:launch()
                    end
                end
            end, function ()
                CameraSetSourceNoise(0, 0)
                CameraSetTargetNoise(0, 0)

                -- Unburrow effect

                dust = AddSpecialEffect("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl", x, y)
                BlzSetSpecialEffectScale(dust, 2.)
                DestroyEffect(dust)

                BlzSetSpecialEffectScale(eff, BlzGetUnitRealField(caster, UNIT_RF_SCALING_VALUE))
                pitch = -pitch
                BlzSetSpecialEffectOrientation(eff, yaw, pitch, 0)
                Timed.echo(B_INTERVAL, 1., function ()
                    BlzPlaySpecialEffect(eff, ANIM_TYPE_SPELL)
                    z = z + B_Z_DIFF
                    pitch = pitch + B_PITCH_DIFF
                    BlzSetSpecialEffectOrientation(eff, yaw, pitch, 0)
                    BlzSetSpecialEffectZ(eff, z)
                end, function ()
                    BlzSetSpecialEffectScale(eff, 0.01)
                    DestroyEffect(eff)

                    ShowUnitShow(caster)
                    BossIsCasting(caster, false)
                    PauseUnit(caster, false)
                end)
            end)
        end)
    end

    InitBossFight({
        name = "Drimogemon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_52787},
        inner = gg_rct_DrimogemonInner,
        entrance = gg_rct_DrimogemonEntrance,
        moveOption = 2,
        spells = {
            5, CastType.POINT, onDash, -- Missile Dash
            2, CastType.POINT, onEarthQuake, -- Moving Earthquake
            7, CastType.IMMEDIATE, onBurrow -- Burrow
        },
        extraSpells = {
            FourCC('A05W'), Orders.curse, CastType.TARGET, -- Iron drill spin
            FourCC('A0AG'), 852623, CastType.IMMEDIATE -- Hunger
        },
        castCondition = function (spell)
            if spell == onEarthQuake then
                return GetUnitHPRatio(boss) < 0.5
            end
            return true
        end,
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, hunger)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, hunger)
        end
    })
end)
Debug.endFile()