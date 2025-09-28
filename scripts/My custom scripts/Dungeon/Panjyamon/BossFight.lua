Debug.beginFile("Panjyamon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"
    Require "JumpSystem"

    local boss = gg_unit_O037_0096 ---@type unit

    local battlefield = GetRects("Panjyamon")

    local punchRush = FourCC('A0DL')

    local CJ_MIN_DIST = 300.
    local CJ_MAX_DIST = 500.
    local CJ_DAMAGE = 350.
    local CJ_DAMAGE_PER_SEC = 50.
    local CJ_DURATION = 5.
    local CJ_EFFECT = "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl"

    local function onCatJump(caster, target)
        BossIsCasting(caster, true)
        Timed.echo(0.1, 2., function ()
            IssueTargetOrderById(caster, Orders.smart, target)
            local x, y = GetUnitX(caster), GetUnitY(caster)
            if DistanceBetweenCoordsSq(x, y, GetUnitX(target), GetUnitY(target)) < 38416 then
                local toX, toY

                for _ = 1, 5 do
                    local dist = CJ_MIN_DIST + (CJ_MAX_DIST - CJ_MIN_DIST) * math.random()
                    local angle = 2 * math.pi * math.random()
                    local checkX = x + dist * math.cos(angle)
                    local checkY = y + dist * math.sin(angle)

                    -- To be sure that the target is inside the bossfight area
                    local contains = false
                    for i = 1, #battlefield do
                        if RectContainsCoords(battlefield[i], checkX, checkY) then
                            contains = true
                            break
                        end
                    end

                    if contains and IsTerrainWalkable(checkX, checkY) then
                        toX, toY = checkX, checkY
                        break
                    end
                end

                if not toX then
                    BossIsCasting(caster, false)
                    return true
                end

                UnitAddAbility(target, CROW_FORM_ID)
                UnitRemoveAbility(target, CROW_FORM_ID)

                local originHeight = GetUnitFlyHeight(target)

                local endTimer = Timed.echo(0.02, function ()
                    local angle = math.rad(GetUnitFacing(caster))
                    SetUnitPosition(target, GetUnitX(caster) + 50*math.cos(angle), GetUnitY(caster) + 50*math.sin(angle))
                    SetUnitFlyHeight(target, GetUnitFlyHeight(caster) + 50, 1000000000)
                end)

                Jump(caster, toX, toY, 300., 100., nil, "slam", function ()
                    endTimer()
                    SetUnitFlyHeight(target, originHeight, 1000000000)

                    DestroyEffect(AddSpecialEffect(CJ_EFFECT, GetUnitX(caster), GetUnitY(caster)))
                    Damage.apply(caster, target, CJ_DAMAGE, false, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                    DummyCast(
                        GetOwningPlayer(caster),
                        GetUnitX(target), GetUnitY(target),
                        ICE_SPELL,
                        ICE_ORDER,
                        1,
                        CastType.TARGET,
                        target
                    )
                    Timed.echo(1., CJ_DURATION, function ()
                        Damage.apply(caster, target, CJ_DAMAGE_PER_SEC, false, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                    end)
                    BossIsCasting(caster, false)
                end)
                return true
            end
        end, function ()
            BossIsCasting(caster, false)
        end)
    end

    local IF_DISTANCE = 600.
    local IF_DAMAGE = 1500.
    local IF_DELAY = 2. -- Same as object editor
    local IF_EFFECT_CASTER = "Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathMissile.mdl"
    local IF_EFFECT_TARGET = "war3mapImported\\DetroitSmash_Effect.mdx"

    local function onIceFist(caster, tx, ty)
        PauseUnit(caster, true)
        BossIsCasting(caster, true)

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_AQUA)
        bar:setZOffset(250)
        bar:setSize(1.5)
        bar:setTargetUnit(caster)

        SetUnitAnimationByIndex(caster, 1) -- stand ready

        local progress = 0
        local interval = 0
        Timed.echo(0.02, IF_DELAY, function ()
            if not UnitAlive(caster) then
                bar:destroy()
                return true
            end
            progress = progress + 0.02
            interval = interval + 0.02
            if interval >= 0.1 then
                interval = 0
                local eff = AddSpecialEffectTarget(IF_EFFECT_CASTER, caster, "hand right")
                BlzSetSpecialEffectColor(eff, 0, 209, 255)
                DestroyEffect(eff)
            end
            bar:setPercentage((progress/IF_DELAY)*100, 1)
        end, function ()
            bar:destroy()

            SetUnitAnimation(caster, "spell")
            Timed.call(0.5, function ()
                local owner = GetOwningPlayer(caster)

                SetUnitAnimation(caster, "slam")

                Timed.call(0.4, function ()
                    local x = GetUnitX(caster)
                    local y = GetUnitY(caster)
                    local angle = math.atan(ty - y, tx - x)

                    local eff = AddSpecialEffect(IF_EFFECT_TARGET, x, y)
                    BlzSetSpecialEffectPosition(eff, x + 50*math.cos(angle - math.pi/6), y + 50*math.sin(angle - math.pi/6), 165.)
                    BlzSetSpecialEffectYaw(eff, angle)
                    BlzSetSpecialEffectColor(eff, 0, 209, 255)
                    DestroyEffect(eff)

                    ForUnitsInRange(x - 100*math.cos(angle), y - 100*math.sin(angle), IF_DISTANCE, function (u)
                        if math.abs(math.atan(GetUnitY(u) - y, GetUnitX(u) - x)) <= math.pi/6 and IsUnitEnemy(u, owner) then
                            DummyCast(owner, GetUnitX(u), GetUnitY(u), ICE_SPELL, ICE_ORDER, 1, CastType.TARGET, u)
                            Damage.apply(caster, u, IF_DAMAGE, false, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                        end
                    end)

                    PauseUnit(caster, false)
                    BossIsCasting(caster, false)
                end)
            end)
        end)
    end

    local IS_DAMAGE = 350.
    local IS_AREA = 255.
    local IS_DURATION = 1.
    local IS_HEIGHT = 120.^2
    local IS_SPEED = math.sqrt(2)*IS_DURATION
    local IS_EFFECT = "Abilities\\Weapons\\FrostWyrmMissile\\FrostWyrmMissile.mdl"

    local function onIceStomp(caster)
        SetUnitAnimation(caster, "spell")
        local x, y = GetUnitX(caster), GetUnitY(caster)
        Jump(caster, x + IS_DURATION, y + IS_DURATION, IS_SPEED, IS_HEIGHT, nil, nil, function ()
            for i = 1, 6 do
                DestroyEffect(AddSpecialEffect(IS_EFFECT, x + (IS_AREA*0.75)*math.cos(2*i*math.pi/6), y + (IS_AREA*0.75)*math.sin(2*i*math.pi/6)))
            end
            DestroyEffect(AddSpecialEffect(IS_EFFECT, x, y))
            ForUnitsInRange(x, y, IS_AREA, function (u)
                if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                    Damage.apply(caster, u, IS_DAMAGE, false, false, udg_Water, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
                    DummyCast(
                        GetOwningPlayer(caster),
                        GetUnitX(u), GetUnitY(u),
                        ICE_SPELL,
                        ICE_ORDER,
                        1,
                        CastType.TARGET,
                        u
                    )
                end
            end)
        end)
    end

    local MR_DAMAGE = 400.
    local MR_DURATION = 8.
    local MR_MAMOTHMON_SPEED = 300.
    local MR_MAMOTHMON_MODEL = "war3mapImported\\MammonDMO - optimized3.mdl"
    local MR_EXPLOSION_MODEL = "Abilities\\Spells\\Other\\Stampede\\StampedeMissileDeath.mdl"
    local MR_MAX_DIST = 1500.
    local MR_MAX_DIST_2 = MR_MAX_DIST/2

    local function onMammothmonRush(caster)
        local owner = GetOwningPlayer(caster)
        local x, y = GetUnitX(caster), GetUnitY(caster)
        local face = math.rad(GetUnitFacing(caster))

        PauseUnit(caster, true)
        BossIsCasting(caster, true)

        Timed.echo(0.4, MR_DURATION, function ()
            SetUnitAnimation(caster, "attack slam")

            if not UnitAlive(caster) then
                ResetUnitAnimation(caster)
                return true
            end
            local angle = math.pi/4 * (-1 + 2*math.random())
            local convAngle = angle + face
            local oppConvAngle = math.pi - angle + face
            local mammothmon = Missiles:create(x + MR_MAX_DIST_2*math.cos(oppConvAngle), y + MR_MAX_DIST_2*math.sin(oppConvAngle), 0,
                                               x + MR_MAX_DIST_2*math.cos(convAngle), y + MR_MAX_DIST_2*math.sin(convAngle), 0)
            mammothmon:model(MR_MAMOTHMON_MODEL)
            mammothmon:speed(MR_MAMOTHMON_SPEED)
            mammothmon:scale(0.4)
            mammothmon:animation(5)
            mammothmon.collision = 32.
            mammothmon.owner = owner
            mammothmon.source = caster
            mammothmon:color(127, 127, 127)
            mammothmon.onHit = function (u)
                if IsUnitEnemy(u, owner) then
                    Damage.apply(caster, u, MR_DAMAGE, false, false, udg_Beast, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
                    DestroyEffect(AddSpecialEffect(MR_EXPLOSION_MODEL, mammothmon.x, mammothmon.y))
                    mammothmon:alpha(0)
                    return true
                end
            end
            mammothmon.onFinish = function ()
                mammothmon:alpha(0)
            end
            mammothmon:launch()
        end, function ()
            BossIsCasting(caster, false)
            PauseUnit(caster, false)
        end)
    end

    InitBossFight({
        name = "Panjyamon",
        boss = boss,
        maxPlayers = 3,
        forceWall = {gg_dest_Dofv_13463, gg_dest_Dofv_13464},
        inner = gg_rct_PanjyamonInner,
        entrance = gg_rct_PanjyamonEntrance,
        moveOption = 0,
        spells = {
            6, CastType.TARGET, onCatJump, -- Cat jump
            2, CastType.POINT, onIceFist,-- Ice fist
            5, CastType.TARGET, onCatJump, -- Cat jump
            2, CastType.IMMEDIATE, onIceStomp, -- Ice stomp
            2, CastType.POINT, onMammothmonRush -- Mammothmon rush
        },
        extraSpells = {
            punchRush, Orders.berserk, CastType.IMMEDIATE, -- Punch rush
        },
        castCondition = function (spell)
            if spell == onIceFist or spell == onIceStomp then
                return GetUnitHPRatio(boss) < 0.5, true
            end
            return true
        end,
        actions = function (u)
        end,
        onStart = function ()
            BlzStartUnitAbilityCooldown(boss, punchRush, 20.)
        end
    })

    -- Ice aura
    local BUFF = FourCC('B01N')
    local owner = GetOwningPlayer(boss)

    ---@param u unit
    local function CheckEnemies(u)
        if IsUnitEnemy(u, owner) and not UnitHasBuffBJ(u, BUFF) then
            DummyCast(owner, GetUnitX(u), GetUnitY(u), SLOW_SPELL, SLOW_ORDER, 3, CastType.TARGET, u)
            Damage.apply(boss, u, 2.5, false, false, udg_Air, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
        end
    end

    Timed.echo(0.5, function ()
        if UnitAlive(boss) then
            for j = 1, #battlefield do
                ForUnitsInRect(battlefield[j], CheckEnemies)
            end
        end
    end)
end)
Debug.endFile()