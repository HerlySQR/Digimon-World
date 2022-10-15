OnLibraryInit("BossFightUtils", function ()
    local SPELL = FourCC('A02D')
    local DURATION = 10.
    local DAMAGE = 75.
    local RANGE = 1000.
    local AREA = 128.
    local CASTER_MODEL = "war3mapImported\\Drimogemon.mdl"
    local INTERVAL = 0.03125
    local Z_DIFF = INTERVAL * 160.
    local PITCH_DIFF = (math.pi/4) * INTERVAL

    RegisterSpellEffectEvent(SPELL, function ()
        local caster = GetSpellAbilityUnit()
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)


        -- Burrow effect
        ShowUnitHide(caster)
        BossIsCasting(caster, true)

        local dust = AddSpecialEffect("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl", x, y)
        BlzSetSpecialEffectScale(dust, 2.)
        DestroyEffect(dust)

        local eff = AddSpecialEffect(CASTER_MODEL, x, y)
        local yaw = GetUnitFacing(caster) * bj_DEGTORAD
        BlzSetSpecialEffectOrientation(eff, yaw, 0, 0)
        BlzSpecialEffectAddSubAnimation(eff, SUBANIM_TYPE_TWO)
        local z = BlzGetLocalSpecialEffectZ(eff)
        local pitch = 0
        local elapsed = 0
        Timed.echo(function ()
            if elapsed < 1. then
                BlzPlaySpecialEffect(eff, ANIM_TYPE_SPELL)
                z = z - Z_DIFF
                pitch = pitch + PITCH_DIFF
                BlzSetSpecialEffectOrientation(eff, yaw, pitch, 0)
                BlzSetSpecialEffectZ(eff, z)
                elapsed = elapsed + INTERVAL
            else
                BlzSetSpecialEffectScale(eff, 0.01)
                return true
            end
        end, INTERVAL)

        Timed.call(1.5, function ()
            Timed.echo(function (node)
                if node.elapsed < DURATION then
                    CameraSetSourceNoise(0, 0)
                    CameraSetTargetNoise(0, 0)

                    -- Show an earthquake effect only if the player is seeing the place where the effect is casted
                    if DistanceBetweenCoords(GetCameraTargetPositionX(), GetCameraTargetPositionY(), x, y) <= RANGE then
                        CameraSetTargetNoiseEx(10., 500000, true)
                        CameraSetSourceNoiseEx(10., 500000, true)
                    end

                    local chance = math.random(0, 100)
                    if chance <= 20 then
                        for _ = 1, math.random(4) do
                            local angle = 2 * math.pi * math.random()
                            local dist = RANGE * math.random()
                            local tx = x + dist * math.cos(angle)
                            local ty = y + dist * math.sin(angle)
                            -- Falls a rock
                            local rock = Missiles:create(tx, ty, 640., tx, ty, 0.)
                            rock.source = caster
                            rock.owner = owner
                            rock.damage = DAMAGE
                            rock:model("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl")
                            rock:speed(0.)
                            rock.collision = 0
                            rock.collideZ = true
                            -- Gravity
                            rock.onPeriod = function ()
                                rock:speed(rock.Speed + 0.025)
                            end
                            rock.onFinish = function ()
                                ForUnitsInRange(tx, ty, AREA, function (u)
                                    if IsUnitEnemy(u, owner) then
                                        Damage.apply(caster, u, DAMAGE, true, false, udg_Dark, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
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
                else
                    CameraSetSourceNoise(0, 0)
                    CameraSetTargetNoise(0, 0)

                    -- Unburrow effect

                    dust = AddSpecialEffect("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl", x, y)
                    BlzSetSpecialEffectScale(dust, 2.)
                    DestroyEffect(dust)

                    BlzSetSpecialEffectScale(eff, 1.)
                    pitch = -pitch
                    BlzSetSpecialEffectOrientation(eff, yaw, pitch, 0)
                    elapsed = 0
                    Timed.echo(function ()
                        if elapsed < 1. then
                            BlzPlaySpecialEffect(eff, ANIM_TYPE_SPELL)
                            z = z + Z_DIFF
                            pitch = pitch + PITCH_DIFF
                            BlzSetSpecialEffectOrientation(eff, yaw, pitch, 0)
                            BlzSetSpecialEffectZ(eff, z)
                            elapsed = elapsed + INTERVAL
                        else
                            BlzSetSpecialEffectScale(eff, 0.01)
                            DestroyEffect(eff)

                            ShowUnitShow(caster)
                            Timed.call(5., function () BossIsCasting(caster, false) end)
                            return true
                        end
                    end, INTERVAL)
                    return true
                end
            end, 0.05)
        end)
    end)

end)