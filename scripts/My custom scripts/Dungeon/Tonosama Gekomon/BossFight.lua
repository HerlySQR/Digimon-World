Debug.beginFile("Tonosama Gekomon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"
    Require "JumpSystem"

    local boss = gg_unit_O012_0067 ---@type unit

    local aquaMagic = FourCC('A0AC')

    local SG_SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local GEKOMON_ID = FourCC('O01A')

    local function onSummonGekomon(caster)
        SetUnitAnimation(caster, "spell")

        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            local x, y = GetUnitX(caster), GetUnitY(caster)
            -- Create the Gekomon
            for _ = 1, 3 do
                local d = SummonMinion(caster, GEKOMON_ID, x, y, GetUnitFacing(caster))
                DestroyEffect(AddSpecialEffect(SG_SUMMON_EFFECT, d:getX(), d:getY()))
                d:setLevel(GetHeroLevel(caster))
            end
        end)
    end

    local BL_SPEED = 700.
    local BL_HEIGHT = 100.
    local BL_STOMP = FourCC('A0BL')

    local function onBigLeap(caster, x, y)
        Jump(caster, x, y, BL_SPEED, BL_HEIGHT, nil, nil, function ()
            DummyCast(
                GetOwningPlayer(caster),
                GetUnitX(caster), GetUnitY(caster),
                BL_STOMP,
                Orders.thunderclap,
                1,
                CastType.IMMEDIATE)
        end)
    end

    local SO_SUMMON_EFFECT = "Abilities\\Spells\\Items\\TomeOfRetraining\\TomeOfRetrainingCaster.mdl"
    local SO_MINION = FourCC('h01T')
    local SO_HEAL = FourCC('A0BI')
    local SO_HEAL_FACTOR = 0.05
    local SO_INTERVAL = 6.
    local SO_DISTANCE = 270.

    local function onSummonOtamamon(caster)
        SetUnitAnimation(caster, "spell")

        Timed.call(0.5, function ()
            ResetUnitAnimation(caster)
            local x, y = GetUnitX(caster), GetUnitY(caster)
            local angle = 0
            -- Create the Otamamon
            for _ = 1, 2 do
                angle = angle + math.pi + math.random() * math.pi/2
                local minion = SummonMinion(caster, SO_MINION, x + SO_DISTANCE*math.cos(angle), y + SO_DISTANCE*math.sin(angle), bj_UNIT_FACING)
                DestroyEffect(AddSpecialEffect(SO_SUMMON_EFFECT, minion:getX(), minion:getY()))
                Timed.echo(SO_INTERVAL, function ()
                    if minion:isAlive() then
                        minion:issueOrder(Orders.heal, caster)
                    else
                        return true
                    end
                end)
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterVariableEvent(t, "udg_PreDamageEvent", EQUAL, 1.00)
        TriggerAddAction(t, function ()
            if GetUnitTypeId(udg_DamageEventTarget) == SO_MINION then
                udg_DamageEventAmount = 1.
            end
        end)
    end

    RegisterSpellEffectEvent(SO_HEAL, function ()
        local target = GetSpellTargetUnit()
        SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + SO_HEAL_FACTOR * GetUnitState(target, UNIT_STATE_MAX_LIFE))
    end)

    local SW_RANGE = 900.
    local SW_DAMAGE = 220.
    local SW_DISTANCE_PUSH = 200.
    local SW_AREA = 200.
    local SW_MISSILE_MODEL = "Abilities\\Spells\\Orc\\Shockwave\\ShockwaveMissile.mdl"
    local SW_PUSH_MODEL = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl"

    local function onSonicWave(caster, tx, ty)
        local x = GetUnitX(caster)
        local y = GetUnitY(caster)
        local angle = math.atan(ty - y, tx - x)
        local missile = Missiles:create(x, y, 50., x + SW_RANGE * math.cos(angle), y + SW_RANGE * math.sin(angle), 50.)
        missile:model(SW_MISSILE_MODEL)
        missile:speed(900.)
        missile:scale(2.5)
        missile.source = caster
        missile.owner = GetOwningPlayer(caster)
        missile.collision = SW_AREA
        missile:alpha(127)
        missile.onHit = function (u)
            if IsUnitEnemy(caster, GetOwningPlayer(u)) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                UnitDamageTarget(caster, u, SW_DAMAGE, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                -- Knockback
                if not IsUnitType(u, UNIT_TYPE_GIANT) then
                    Knockback(
                        u,
                        math.atan(GetUnitY(u) - missile.y, GetUnitX(u) - missile.x),
                        SW_DISTANCE_PUSH,
                        500.,
                        SW_PUSH_MODEL,
                        nil
                    )
                end
            end
        end
        missile:launch()
    end

    local SdW_DISTANCE = 700.
    local SdW_DAMAGE = 650.
    local SdW_DAMAGE_PER_SEC = 20.
    local SdW_AREA = 156.
    local SdW_DELAY = 2.

    local function onSoundWave(caster, tx, ty)
        PauseUnit(caster, true)
        SetUnitAnimation(caster, "spell")
        BossIsCasting(caster, true)

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_PEANUT)
        bar:setZOffset(300)
        bar:setSize(1.3)
        bar:setTargetUnit(caster)

        local progress = 0
        Timed.echo(0.02, SdW_DELAY, function ()
            if not UnitAlive(caster) then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/SdW_DELAY)*100, 1)
        end, function ()
            bar:destroy()

            PauseUnit(caster, false)
            ResetUnitAnimation(caster)
            BossIsCasting(caster, false)

            local x = GetUnitX(caster)
            local y = GetUnitY(caster)
            local angle = math.atan(ty - y, tx - x)
            local missile = Missiles:create(x, y, 50., x + SdW_DISTANCE * math.cos(angle), y + SdW_DISTANCE * math.sin(angle), 50.)
            missile:model("Missile\\SoundWave.mdx")
            missile:speed(800.)
            missile:scale(1.)
            missile.source = caster
            missile.owner = GetOwningPlayer(caster)
            missile.collision = SdW_AREA
            missile.onHit = function (u)
                if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                    UnitDamageTarget(caster, u, SdW_DAMAGE, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                    local eff = AddSpecialEffectTarget("Effect\\SparkleStampedeMissileDeath.mdx", u, "chest")
                    Timed.echo(1., 4., function ()
                        UnitDamageTarget(caster, u, SdW_DAMAGE_PER_SEC, true, false, udg_Fire, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
                    end, function ()
                        DestroyEffect(eff)
                    end)
                end
            end
            missile:launch()
        end)
    end

    InitBossFight({
        name = "TonosamaGekomon",
        boss = boss,
        maxPlayers = 2,
        forceWall = {gg_dest_B082_12252, gg_dest_B082_12254},
        inner = gg_rct_TonosamaGekomonInner,
        entrance = gg_rct_TonosamaGekomonEntrance,
        moveOption = 3,
        spells = {
            3, CastType.IMMEDIATE, onSummonGekomon, -- Summon Gekomon
            4, CastType.POINT, onSoundWave, -- Sonic wave
            3, CastType.POINT, onBigLeap, -- Big leap
            4, CastType.IMMEDIATE, onSummonOtamamon, -- Summon Otamamon
            4, CastType.POINT, onSonicWave -- Sonic wave
        },
        extraSpells = {
            FourCC('A07F'), Orders.howlofterror, CastType.IMMEDIATE, -- Howl
        },
        castCondition = function (spell)
            if spell == onSummonOtamamon then
                return GetUnitHPRatio(boss) < 0.5, true
            end
            return true
        end,
        actions = function (u)
            if GetUnitHPRatio(boss) < 0.5 then
                UnitAddAbility(boss, aquaMagic)
            end
        end,
        onStart = function ()
            UnitRemoveAbility(boss, aquaMagic)
        end
    })
end)
Debug.endFile()