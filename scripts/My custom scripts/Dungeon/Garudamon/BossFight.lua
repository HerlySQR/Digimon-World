Debug.beginFile("Garudamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O015_0092 ---@type unit

    local wingBlade = FourCC('A08L')

    local D_MAX_DIST = 700.
    local D_DAMAGE = 270.
    local D_COLLISION = 192.
    local D_INTERVAL = 0.03125

    local function onDash(caster, tx, ty)
        local owner = GetOwningPlayer(caster)
        local angle = math.atan(ty - GetUnitY(caster), tx - GetUnitX(caster))
        local affected = Set.create()
        SetUnitPathing(caster, false)
        PauseUnit(caster, true)
        local reached = 0
        Timed.echo(D_INTERVAL, 1, function ()
            local x = GetUnitX(caster)
            local y = GetUnitY(caster)
            SetUnitAnimation(caster, "walk")
            if reached < D_MAX_DIST then
                x = x + 50 * math.cos(angle)
                y = y + 50 * math.sin(angle)
                if not IsTerrainWalkable(x, y) then
                    ResetUnitAnimation(caster)
                    SetUnitPathing(caster, true)
                    PauseUnit(caster, false)
                    return true
                else
                    SetUnitPosition(caster, x, y)
                    ForUnitsInRange(x, y, D_COLLISION, function (u)
                        if not affected:contains(u) and IsUnitEnemy(u, owner) then
                            affected:addSingle(u)
                            Damage.apply(caster, u, D_DAMAGE, true, false, udg_Air, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
                            -- Slow
                            DummyCast(owner, GetUnitX(caster), GetUnitY(caster), SLOW_SPELL, SLOW_ORDER, 2, CastType.TARGET, u)
                        end
                    end)
                end
            else
                ResetUnitAnimation(caster)
                SetUnitPathing(caster, true)
                PauseUnit(caster, false)
                return true
            end
            reached = reached + 50
        end, function ()
            ResetUnitAnimation(caster)
            SetUnitPathing(caster, true)
            PauseUnit(caster, false)
        end)
    end

    local BoF_DISTANCE = 600.
    local BoF_DAMAGE = 950.
    local BoF_DAMAGE_PER_SEC = 30.
    local BoF_AREA = 156.
    local BoF_DELAY = 2.

    local function onBirdOfFire(caster, tx, ty)
        PauseUnit(caster, true)
        SetUnitAnimation(caster, "spell")
        BossIsCasting(caster, true)

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_PEANUT)
        bar:setZOffset(300)
        bar:setSize(1.3)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, BoF_DELAY, function ()
            if not UnitAlive(caster) then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/BoF_DELAY)*100, 1)
        end, function ()
            bar:destroy()

            SetUnitAnimation(caster, "attack")
            Timed.call(0.5, function ()
                PauseUnit(caster, false)
                BossIsCasting(caster, false)
                ResetUnitAnimation(caster)

                local x = GetUnitX(caster)
                local y = GetUnitY(caster)
                local angle = math.atan(ty - y, tx - x)
                local missile = Missiles:create(x, y, 50., x + BoF_DISTANCE * math.cos(angle), y + BoF_DISTANCE * math.sin(angle), 50.)
                missile:model("Missile\\SpiritDragonMissile(Red).mdx")
                missile:speed(800.)
                missile:scale(3.)
                missile.source = caster
                missile.owner = GetOwningPlayer(caster)
                missile.collision = BoF_AREA
                missile.onHit = function (u)
                    if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                        UnitDamageTarget(caster, u, BoF_DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                        local eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl", u, "chest")
                        Timed.echo(1., 4., function ()
                            UnitDamageTarget(caster, u, BoF_DAMAGE_PER_SEC, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                        end, function ()
                            DestroyEffect(eff)
                        end)
                    end
                end
                missile:launch()
            end)
        end)
    end

    local FaT_DAMAGE = 350.
    local FaT_AREA = 190.

    local function onFlyAndThrow(caster, target)
        BossIsCasting(caster, true)
        SetUnitPathing(caster, false)
        PauseUnit(caster, true)

        Timed.echo(0.02, 2., function ()
            if not UnitAlive(caster) then
                SetUnitPathing(caster, true)
                return true
            end

            if DistanceBetweenCoordsSq(GetUnitX(caster), GetUnitY(caster), GetUnitX(target), GetUnitY(target)) < 16384 then
                SetUnitPathing(caster, true)

                UnitAddAbility(caster, CROW_FORM_ID)
                UnitRemoveAbility(caster, CROW_FORM_ID)

                SetUnitFlyHeight(caster, 200, 100)
                ShowUnitHide(target)
                local eff = AddSpecialEffectTarget("Units\\Human\\Phoenix\\PhoenixEgg.mdl", caster, "hand")
                BlzSetSpecialEffectScale(eff, 2)
                BlzSpecialEffectAddSubAnimation(eff, SUBANIM_TYPE_ALTERNATE_EX)
                BlzPlaySpecialEffect(eff, ANIM_TYPE_STAND)

                Timed.call(3, function ()
                    if not UnitAlive(caster) then
                        ShowUnitShow(target)
                    else
                        SetUnitAnimation(caster, "attack")
                        local x, y = GetUnitX(caster), GetUnitY(caster)
                        local newTarget = GetRandomUnitOnRange(x, y, 700., function (u)
                            return RectContainsUnit(gg_rct_Garudamon_1, u) or RectContainsUnit(gg_rct_Garudamon_2, u) or RectContainsUnit(gg_rct_Garudamon_3, u)
                        end)
                        local targetX, targetY = table.unpack(newTarget and {GetUnitX(newTarget), GetUnitY(newTarget)} or {x + math.random(-128, 128), y + math.random(-128, 128)})

                        SetUnitFacing(caster, math.deg(math.atan(targetY - y, targetX - x)))

                        Timed.call(0.8, function ()
                            SetUnitFlyHeight(caster, GetUnitDefaultFlyHeight(caster), 100)
                            ResetUnitAnimation(caster)
                            BossIsCasting(caster, false)
                            PauseUnit(caster, false)

                            BlzSetSpecialEffectScale(eff, 0.001)
                            DestroyEffect(eff)
                            local missile = Missiles:create(x, y, 200., targetX, targetY, newTarget and GetUnitFlyHeight(newTarget) or 0.)
                            missile:model("Units\\Human\\Phoenix\\PhoenixEgg.mdl")
                            missile:speed(800.)
                            missile:scale(2.)
                            missile.source = caster
                            missile.owner = GetOwningPlayer(caster)
                            missile.onFinish = function ()
                                DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\WarStomp\\WarStompCaster.mdl", missile.x, missile.y))
                                ForUnitsInRange(missile.x, missile.y, FaT_AREA, function (u)
                                    if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                                        UnitDamageTarget(caster, u, FaT_DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                                    end
                                end)
                                SetUnitPosition(target, missile.x, missile.y)
                                ShowUnitShow(target)
                            end
                            missile:launch()
                        end)
                    end
                end)
                return true
            end

            local angle = math.atan(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster))
            SetUnitFacing(caster, math.deg(angle))
            SetUnitPosition(caster, GetUnitX(caster) + 20 * math.cos(angle), GetUnitY(caster) + 20 * math.sin(angle))
        end, function ()
            BossIsCasting(caster, false)
            SetUnitPathing(caster, true)
            PauseUnit(caster, false)
        end)
    end

    InitBossFight({
        name = "Garudamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofw_13138},
        inner = gg_rct_GarudamonInner,
        entrance = gg_rct_GarudamonEntrance,
        moveOption = 0,
        spells = {
            5, CastType.POINT, onDash, -- Dash
            6, CastType.POINT, onBirdOfFire, -- Bird of Fire
            6, CastType.TARGET, onFlyAndThrow -- Fly and Throw
        },
        extraSpells = {
            FourCC('A08L'), Orders.carrionswarm, CastType.POINT, -- Wing blade
            FourCC('A02A'), Orders.firebolt, CastType.TARGET, -- Fire ball
            FourCC('A01B'), Orders.curse, CastType.TARGET, -- Ashes
            FourCC('A0J2'), Orders.spiritwolf, CastType.IMMEDIATE, -- Summon Saberdramon
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, wingBlade)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, wingBlade)
        end
    })
end)
Debug.endFile()