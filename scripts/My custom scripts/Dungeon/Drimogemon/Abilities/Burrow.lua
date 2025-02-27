Debug.beginFile("Drimogemon\\Abilities\\Burrow")
OnInit(function ()
    Require "BossFightUtils"

    local SPELL = FourCC('A02D')
    local DURATION = 4.
    local DAMAGE = 105.
    local RANGE = 600.
    local AREA = 110.
    local CASTER_MODEL = "war3mapImported\\Drimogemon.mdl"
    local INTERVAL = 0.02
    local Z_DIFF = INTERVAL * 150.
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
        BlzSetSpecialEffectScale(eff, BlzGetUnitRealField(caster, UNIT_RF_SCALING_VALUE))
        local yaw = GetUnitFacing(caster) * bj_DEGTORAD
        BlzSetSpecialEffectOrientation(eff, yaw, 0, 0)
        BlzSpecialEffectAddSubAnimation(eff, SUBANIM_TYPE_TWO)
        local z = BlzGetLocalSpecialEffectZ(eff)
        local pitch = 0
        Timed.echo(INTERVAL, 1., function ()
            BlzPlaySpecialEffect(eff, ANIM_TYPE_SPELL)
            z = z - Z_DIFF
            pitch = pitch + PITCH_DIFF
            BlzSetSpecialEffectOrientation(eff, yaw, pitch, 0)
            BlzSetSpecialEffectZ(eff, z)
        end, function ()
            BlzSetSpecialEffectScale(eff, 0.01)
        end)

        Timed.call(1.5, function ()
            Timed.echo(0.05, DURATION, function ()
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
                Timed.echo(INTERVAL, 1., function ()
                    BlzPlaySpecialEffect(eff, ANIM_TYPE_SPELL)
                    z = z + Z_DIFF
                    pitch = pitch + PITCH_DIFF
                    BlzSetSpecialEffectOrientation(eff, yaw, pitch, 0)
                    BlzSetSpecialEffectZ(eff, z)
                end, function ()
                    BlzSetSpecialEffectScale(eff, 0.01)
                    DestroyEffect(eff)

                    ShowUnitShow(caster)
                    BossIsCasting(caster, false)
                end)
            end)
        end)
    end)
end)
Debug.endFile()