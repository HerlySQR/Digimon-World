Debug.beginFile("Master Tyranomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O008_0081 ---@type unit

    local hungry = FourCC('A0AG')

    local TOF_FIRE_MODEL = "Effects\\FireShield.mdx"
    local TOF_DISTANCE = 300.
    local TOF_AREA = 300.
    local TOF_DAMAGE = 30.
    local TOF_DURATION = 3.

    local function onTowerOfFire(caster)
        local owner = GetOwningPlayer(caster)
        SetUnitAnimation(caster, "spell")
        BossIsCasting(caster, true)
        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)

            local x, y = GetUnitX(caster), GetUnitY(caster)
            -- Create the fire
            local face = GetUnitFacing(caster) * bj_DEGTORAD
            local newX, newY = x + TOF_DISTANCE * math.cos(face), y + TOF_DISTANCE * math.sin(face)
            local fire = AddSpecialEffect(TOF_FIRE_MODEL, newX, newY)
            BlzSetSpecialEffectScale(fire, 2)
            BlzSetSpecialEffectTimeScale(fire, 1)

            Timed.echo(0.3, TOF_DURATION, function ()
                ForUnitsInRange(newX, newY, TOF_AREA, function (u)
                    if UnitAlive(u) and IsUnitEnemy(u, owner) and not IsUnitType(u, UNIT_TYPE_MAGIC_IMMUNE) then
                        Damage.apply(caster, u, TOF_DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS)
                    end
                end)
                if not UnitAlive(caster) then
                    DestroyEffect(fire)
                    BossIsCasting(caster, false)
                    return true
                end
            end, function ()
                DestroyEffect(fire)
                BossIsCasting(caster, false)
            end)
        end)
    end

    local FW_DISTANCE = 700. -- The same as in the object editor
    local FW_DAMAGE = 550.
    local FW_DAMAGE_PER_SEC = 40.
    local FW_AREA = 156.
    local FW_DELAY = 2. -- Same as object editor

    local function FlameWave(caster, tx, ty)
        PauseUnit(caster, true)
        BossIsCasting(caster, true)

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_PEANUT)
        bar:setZOffset(300)
        bar:setSize(1.3)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, FW_DELAY, function ()
            if not UnitAlive(caster) then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/FW_DELAY)*100, 1)
        end, function ()
            bar:destroy()

            SetUnitAnimation(caster, "spell")
            Timed.call(0.5, function ()
                ResetUnitAnimation(caster)
                PauseUnit(caster, false)
                BossIsCasting(caster, false)

                local x = GetUnitX(caster)
                local y = GetUnitY(caster)
                local angle = math.atan(ty - y, tx - x)
                local missile = Missiles:create(x, y, 50., x + FW_DISTANCE * math.cos(angle), y + FW_DISTANCE * math.sin(angle), 50.)
                missile:model("Abilities\\Weapons\\FireBallMissile\\FireBallMissile.mdl")
                missile:speed(600.)
                missile:scale(3.)
                missile.source = caster
                missile.owner = GetOwningPlayer(caster)
                missile.collision = FW_AREA
                missile.onHit = function (u)
                    if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                        UnitDamageTarget(caster, u, FW_DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                        local eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireDamage.mdl", u, "chest")
                        Timed.echo(1., 4., function ()
                            UnitDamageTarget(caster, u, FW_DAMAGE_PER_SEC, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                        end, function ()
                            DestroyEffect(eff)
                        end)
                    end
                end
                missile:launch()
            end)
        end)
    end

    InitBossFight({
        name = "MasterTyranomon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_Dofv_12250},
        inner = gg_rct_MasterTyranomonInner,
        entrance = gg_rct_MasterTyranomonEntrance,
        moveOption = 3,
        spells = {
            7, CastType.IMMEDIATE, onTowerOfFire, -- Tower of fire
            5, CastType.POINT, FlameWave -- Flame wave
        },
        extraSpells = {
            FourCC('A07L'), Orders.roar, CastType.IMMEDIATE, -- War cry
            FourCC('A0AG'), 852623, CastType.TARGET, -- Hungry
            FourCC('A02A'), Orders.firebolt, CastType.TARGET, -- Fire ball
            FourCC('A0B2'), Orders.spiritwolf, CastType.IMMEDIATE, -- Summon Tyranomon
        },
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, hungry)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, hungry)
        end
    })
end)
Debug.endFile()