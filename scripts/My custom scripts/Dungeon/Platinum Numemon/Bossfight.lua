Debug.beginFile("Platinum Numemon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"
    local ProgressBar = Require "ProgressBar" ---@type ProgressBar

    local boss = gg_unit_H04V_0175 ---@type unit
    local originalSize = BlzGetUnitRealField(boss, UNIT_RF_SCALING_VALUE)
    local increasedSize = originalSize * 1.5
    local owner = GetOwningPlayer(boss)
    local area = gg_rct_PlatinumNumemon_1 ---@type rect
    local white = Color.new(0xFFFFFFFF)
    local indianRed = Color.new(0xFFCD5C5C)

    local STINKY_AURA = FourCC('A0G5')
    local WARUMONZEAMON = FourCC('O058')
    local HEAL_NUMEMON = FourCC('A0JM')
    local HEAL_ORDER = Orders.holybolt
    local NUMEMON_MINION = FourCC('h06L')
    local HEAL_PERCENT = 0.05

    local EXTRA_HEALTH_FACTOR = 0.1
    local EXTRA_DMG_FACTOR = 2.

    local bigPoopOrder = Orders.breathoffrost

    local secondPhase = false
    local originalX, originalY = GetUnitX(boss), GetUnitY(boss)
    local pipes = {gg_rct_SummonRaremon1, gg_rct_SummonRaremon2, gg_rct_SummonRaremon3, gg_rct_SummonRaremon4} ---@type rect[]

    local stopGooTimer = false
    local gooRunning = false

    local GOO_BUFF = FourCC('B02X')

    local function createGoo(x, y)
        for _ = 1, math.random(5, 9) do
            local dist = GetRandomReal(0, 180)
            local angle = GetRandomReal(0, 2*math.pi)
            local newX, newY = x + dist * math.cos(angle), y + dist * math.sin(angle)
            local goo = AddSpecialEffect("war3mapImported\\puddle.mdl", newX, newY)
            BlzSetSpecialEffectScale(goo, 0.3)
            BlzSetSpecialEffectAlpha(goo, math.random(50, 150))
            BlzSetSpecialEffectYaw(goo, math.random(0, 2*math.pi))
            DestroyEffectTimed(goo, 5.)
        end
        Timed.echo(1.2, 5., function ()
            ForUnitsInRange(x, y, 200., function (u)
                if IsUnitEnemy(u, owner) and not UnitHasBuffBJ(u, GOO_BUFF) then
                    -- Slow
                    DummyCast(
                        owner,
                        GetUnitX(u), GetUnitY(u),
                        SLOW_SPELL,
                        SLOW_ORDER,
                        4,
                        CastType.TARGET,
                        u
                    )
                end
            end)
        end)
    end

    local function startGoo()
        if gooRunning then
            return
        end
        gooRunning = true
        Timed.echo(0.8, function ()
            if stopGooTimer then
                stopGooTimer = false
                return true
            end
            if not IsUnitHidden(boss) then
                createGoo(GetUnitX(boss), GetUnitY(boss))
            end
        end)
    end

    local function stopGoo()
        stopGooTimer = true
        gooRunning = false
    end

    local actualLifePercent = 1

    ---@param x number
    ---@param y number
    ---@param dmg number
    ---@param max integer
    local function dropFilth(x, y, dmg, max)
        local shadow = AddSpecialEffect("war3mapImported\\QuestMarking.mdx", x, y)
        Timed.call(1., function ()
            for _ = 1, math.random(max) do
                local filth = Missiles:create(x, y, 960., x, y, 0.)
                filth.source = boss
                filth.owner = owner
                filth.damage = dmg
                filth:model("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl")
                filth:speed(0.)
                filth.collision = 0
                filth.collideZ = true
                filth:color(128, 64, 0)
                -- Gravity
                filth.onPeriod = function ()
                    filth:speed(filth.Speed + 0.04)
                end
                filth.onFinish = function ()
                    DestroyEffect(shadow)
                    ForUnitsInRange(x, y, 150., function (u)
                        if IsUnitEnemy(u, owner) then
                            Damage.apply(boss, u, dmg, true, false, udg_Nature, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
                            -- Dirty
                            DummyCast(
                                owner,
                                GetUnitX(u), GetUnitY(u),
                                CURSE_SPELL,
                                CURSE_ORDER,
                                2,
                                CastType.TARGET,
                                u
                            )
                        end
                    end)
                    local s = CreateSoundFromLabel("ArtilleryExplodeDeath", false, true, true, 10, 10)
                    SetSoundPosition(s, x, y, 0.)
                    SetSoundVolume(s, 63)
                    StartSound(s)
                    KillSoundWhenDone(s)
                end
                filth:launch()
            end
        end)
    end

    local function onRainOfFilth(caster)
        PauseUnit(caster, true)
        SetUnitAnimation(caster, "channel")
        if not secondPhase then
            Timed.echo(0.25, 10., function ()
                local angle = 2*math.pi*math.random()
                local dist = GetRandomReal(100., 500.)
                dropFilth(GetUnitX(caster) + dist * math.cos(angle), GetUnitY(caster) + dist * math.sin(angle), 250., 3)
            end, function ()
                PauseUnit(caster, false)
                ResetUnitAnimation(caster)
            end)
        else
            Timed.echo(0.15, 10., function ()
                local l = GetRandomLocInRect(area)
                dropFilth(GetLocationX(l), GetLocationY(l), 375., 5)
                RemoveLocation(l)
            end, function ()
                PauseUnit(caster, false)
                ResetUnitAnimation(caster)
            end)
        end
    end

    local BIG_FART_DAMAGE = 75.
    local BIG_FART_SCALES_1 = {2., 2.5, 3., 3.5, 4., 4.5}
    local BIG_FART_SCALES_2 = {2.25, 3., 3.75, 4.5, 5.25, 6.}
    local BIG_FART_FACTOR = {1., 0.8, 0.6, 0.4, 0.2, 0.1}
    local BIG_FART_RANGES_1 = {500., 600., 700., 800., 900., 950.}
    local BIG_FART_RANGES_2 = {700., 800., 900., 1000., 1100., 1200.}

    local function onBigFart(caster)
        local s = CreateSound("Units\\Creeps\\Ogre\\OgrePissed5.flac", false, true, true, 10, 10, "DefaultEAXON")
        SetSoundPosition(s, GetUnitX(boss), GetUnitY(boss), 0)
        SetSoundVolume(s, 127)
        StartSound(s)
        KillSoundWhenDone(s)

        Timed.echo(0.02, 0.9, function ()
            local dist = 550 * math.random()
            local angle = GetRandomReal(5*math.pi/4, 7*math.pi/4)
            local xOffset, yOffset = dist * math.cos(angle), dist * math.sin(angle)
            local fart = AddSpecialEffect("Abilities\\Spells\\Undead\\PlagueCloud\\PlagueCloudCaster.mdl", GetUnitX(boss) + xOffset, GetUnitY(boss) + yOffset)
            BlzSetSpecialEffectZ(fart, 20)
            local ranges, scales
            if not secondPhase then
                ranges = BIG_FART_RANGES_1
                scales = BIG_FART_SCALES_1
            else
                ranges = BIG_FART_RANGES_2
                scales = BIG_FART_SCALES_2
            end
            local act = 1
            BlzSetSpecialEffectScale(fart, scales[act])
            Timed.echo(0.5, function ()
                DestroyEffect(fart)
                act = act + 1
                if act > 6 then
                    return true
                end
                local x, y = GetUnitX(boss), GetUnitY(boss)
                fart = AddSpecialEffect("Abilities\\Spells\\Undead\\PlagueCloud\\PlagueCloudCaster.mdl", GetUnitX(boss) + xOffset, GetUnitY(boss) + yOffset)
                BlzSetSpecialEffectZ(fart, 20)
                ForUnitsInRange(x, y, ranges[act], function (u)
                    if (not ranges[act-1] or DistanceBetweenCoords(x, y, GetUnitX(u), GetUnitY(u)) >= ranges[act-1]) and IsUnitEnemy(u, owner) then
                        Damage.apply(boss, u, BIG_FART_DAMAGE * BIG_FART_FACTOR[act], false, false, udg_Dark, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS)
                    end
                end)
                BlzSetSpecialEffectScale(fart, scales[act])
            end)
        end)
    end

    local RAREMON = FourCC('O02C')
    local RAREMON_PLACES = pipes
    local RAREMON_SUMMON_EFFECT = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl"
    local RAREMON_EXPLOSION_DAMAGE = 600.

    local function onSummonRaremon(caster)
        for i = 1, #RAREMON_PLACES do
            for _ = 1, math.random(1, 2) do
                local d = SummonMinion(caster, RAREMON, GetRectCenterX(RAREMON_PLACES[i]), GetRectCenterY(RAREMON_PLACES[i]), GetRandomReal(160, 200))
                DestroyEffect(AddSpecialEffect(RAREMON_SUMMON_EFFECT, GetRectCenterX(RAREMON_PLACES[i]), GetRectCenterY(RAREMON_PLACES[i])))

                d:setLevel(90)
                SetUnitMoveSpeed(d.root, 275)
                Threat.addNPC(d.root, false)
                SetUnitState(d.root, UNIT_STATE_MANA, 0)
                SetUnitVertexColor(d.root, 255, 150, 150, 255)
                AddUnitBonus(d.root, BONUS_DAMAGE, 25)
                AddUnitBonus(d.root, BONUS_HEALTH, GetUnitState(d.root, UNIT_STATE_MAX_LIFE))

                ForUnitsInRect(area, function (u)
                    if IsUnitEnemy(caster, GetOwningPlayer(u)) then
                        Threat.modify(u, d.root, 10., true)
                    end
                end)
                local exploding = false

                Timed.echo(1., function ()
                    if exploding or not UnitAlive(caster) then
                        if exploding and d:isAlive() then
                            local x, y = d:getPos()
                            ForUnitsInRange(x, y, 300., function (u)
                                if IsUnitEnemy(d.root, GetOwningPlayer(u)) then
                                    Damage.apply(d.root, u, RAREMON_EXPLOSION_DAMAGE, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_DEMOLITION, WEAPON_TYPE_WHOKNOWS)
                                elseif GetUnitTypeId(u) == RAREMON then
                                    SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_LIFE) - RAREMON_EXPLOSION_DAMAGE/3)
                                end
                            end)
                            DestroyEffect(AddSpecialEffect("Objects\\Spawnmodels\\Demon\\DemonLargeDeathExplode\\DemonLargeDeathExplode.mdl", x, y))
                            DestroyEffect(AddSpecialEffect("Abilities\\Weapons\\Mortar\\MortarMissile.mdl", x, y))
                            d:destroy()
                        else
                            d:kill()
                        end
                        return true
                    end
                    if math.random(20) == 1 then
                        exploding = true
                        d:pause()
                        local eff = AddSpecialEffectTarget("Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl", d.root, "overhead")
                        BlzSetSpecialEffectScale(eff, 3.)
                        DestroyEffectTimed(eff, 1.)
                    end
                end)
            end
        end
    end

    local BIG_POOP_MISSILE = "Missile\\PoopMissile.mdx"
    local BIG_POOP_DELAY = 2.
    local BIG_POOP_AREA = 300.
    local BIG_POOP_DMG = 600.

    local function onBigPoop(caster)
        local poop = AddSpecialEffectTarget("Missile\\Poop1.mdx", caster, "head")

        SetUnitAnimation(caster, "spell")
        BossIsCasting(caster, true)

        local bar = ProgressBar.create()
        bar:setColor(PLAYER_COLOR_BROWN)
        bar:setZOffset(300)
        bar:setSize(1.5)
        bar:setTargetUnit(caster)

        local scale = 1
        local progress = 0
        Timed.echo(0.02, BIG_POOP_DELAY, function ()
            scale = scale + 0.01
            BlzSetSpecialEffectScale(poop, scale)
            if not UnitAlive(caster) or GetUnitCurrentOrder(caster) ~= bigPoopOrder then
                bar:destroy()
                BlzSetSpecialEffectAlpha(poop, 0)
                DestroyEffect(poop)
                return true
            end
            progress = progress + 0.02
            bar:setPercentage((progress/BIG_POOP_DELAY)*100, 1)
        end, function ()
            BlzSetSpecialEffectAlpha(poop, 0)
            DestroyEffect(poop)
            bar:destroy()
            BossIsCasting(caster, false)

            local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 25, GetSpellTargetX(), GetSpellTargetY(), 0)
            missile.source = caster
            missile.owner = owner
            missile.damage = BIG_POOP_DMG
            missile:model(BIG_POOP_MISSILE)
            missile:scale(5)
            missile:speed(700.)
            missile:arc(60.)
            missile.onFinish = function ()
                ForUnitsInRange(missile.x, missile.y, BIG_POOP_AREA, function (u)
                    if IsUnitEnemy(u, missile.owner) then
                        Damage.apply(caster, u, BIG_POOP_DMG, true, false, udg_Dark, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS)
                    end
                end)
                local poop2 = AddSpecialEffect("Missile\\Poop1.mdx", missile.x, missile.y)
                BlzSetSpecialEffectScale(poop2, 4.5)
                missile:scale(0.01)
                Timed.call(2., function ()
                    DestroyEffect(poop2)
                end)
            end
            missile:launch()
        end)
    end

    InitBossFight({
        name = "PlatinumNumemon",
        boss = boss,
        manualRevive = true,
        maxPlayers = 5,
        forceWall = {gg_dest_B082_53321},
        returnPlace = gg_rct_DatamonReturnPlace,
        returnEnv = "Factorial Town",
        inner = gg_rct_PlatinumNumemonInner,
        entrance = gg_rct_PlatinumNumemonEntrance,
        toTeleport = gg_rct_Sewers,
        spells = {
            4, CastType.IMMEDIATE, onRainOfFilth, -- Rain of filth
            5, CastType.IMMEDIATE, onBigFart, -- Big fart
            6, CastType.IMMEDIATE, onSummonRaremon, -- Summon raremon
            2, CastType.IMMEDIATE, onRainOfFilth, -- Rain of filth
            4, CastType.POINT, onBigPoop -- Big poop
        },
        actions = function (u, unitsOnTheField)
            if GetUnitHPRatio(boss) < 1 - 0.2 * actualLifePercent then
                actualLifePercent = actualLifePercent + 1
                for _ = 1, 2 do
                    local dist = GetRandomReal(128, 256)
                    local angle = GetRandomReal(0, 2*math.pi)
                    local x, y = GetUnitX(boss) + dist * math.cos(angle), GetUnitY(boss) + dist * math.sin(angle)
                    local numemon = SummonMinion(boss, NUMEMON_MINION, x, y, 360*math.random())
                    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl", x, y))
                    Timed.echo(1., function ()
                        if not numemon:isAlive() then
                            return true
                        end
                        if numemon:getCurrentOrder() ~= HEAL_ORDER then
                            numemon:issueOrder(HEAL_ORDER, boss)
                        end
                    end)
                end
            end
            if u then
                if not BossStillCasting(boss) then
                    if math.random(100) <= 8 then
                        BossIsCasting(boss, true)
                        Threat.removeNPC(boss)

                        local options = {1, 2, 3, 4}
                        local enter = table.remove(options, math.random(#options))
                        local exit = table.remove(options, math.random(#options))
                        Timed.echo(0.1, function ()
                            if RectContainsUnit(pipes[enter], boss) then
                                ShowUnitHide(boss)
                                Timed.call(2., function ()

                                    local count = 0
                                    for u2 in unitsOnTheField:elements() do
                                        xpcall(function ()
                                            if IsPlayerInGame(GetOwningPlayer(u2)) and IsUnitType(u, UNIT_TYPE_HERO) and not IsUnitIllusion(u2) then
                                                count = count + 1
                                            end
                                        end, function ()
                                            print(GetUnitName(u2), GetHeroProperName(u2))
                                        end)
                                    end

                                    for _ = 1, math.round(4.235*math.exp(0.166*count)) do
                                        local l = GetRandomLocInRect(area)
                                        for _ = 1, 6 do
                                            if IsTerrainWalkable(GetLocationX(l), GetLocationY(l)) then
                                                local check = false
                                                ForUnitsInRange(GetLocationX(l), GetLocationY(l), 700., function (u2)
                                                    if IsUnitEnemy(u2, owner) then
                                                        check = true
                                                    end
                                                end)
                                                if check then
                                                    break
                                                end
                                            end
                                            RemoveLocation(l)
                                            l = GetRandomLocInRect(area)
                                        end

                                        if not IsTerrainWalkable(GetLocationX(l), GetLocationY(l)) then
                                            RemoveLocation(l)
                                            goto next_iteration
                                        else
                                            local check = false
                                            ForUnitsInRange(GetLocationX(l), GetLocationY(l), 700., function (u2)
                                                if IsUnitEnemy(u2, owner) then
                                                    check = true
                                                end
                                            end)
                                            if not check then
                                                goto next_iteration
                                            end
                                        end

                                        local w = SummonMinion(boss, WARUMONZEAMON, GetLocationX(l), GetLocationY(l), 360*math.random(), 100.)
                                        RemoveLocation(l)

                                        w:hide()
                                        w:addAbility(CROW_FORM_ID)
                                        w:removeAbility(CROW_FORM_ID)
                                        SetUnitFlyHeight(w.root, GetRandomReal(800., 1080.), 999999)
                                        Timed.call(1.5, function ()
                                            w:show()
                                            DestroyEffect(AddSpecialEffectTarget("Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl", w.root, "chest"))
                                            SetUnitFlyHeight(w.root, GetUnitDefaultFlyHeight(w.root), 960.)
                                        end)

                                        w:setLevel(90)
                                        w:pause()
                                        Threat.addNPC(w.root, false)
                                        AddUnitBonus(w.root, BONUS_STRENGTH, math.floor(GetHeroStr(w.root, false) * EXTRA_HEALTH_FACTOR))
                                        AddUnitBonus(w.root, BONUS_AGILITY, math.floor(GetHeroAgi(w.root, false) * EXTRA_HEALTH_FACTOR))
                                        AddUnitBonus(w.root, BONUS_INTELLIGENCE, math.floor(GetHeroInt(w.root, false) * EXTRA_HEALTH_FACTOR))
                                        AddUnitBonus(w.root, BONUS_DAMAGE, math.floor(GetAvarageAttack(w.root) * EXTRA_DMG_FACTOR))
                                        Timed.call(1.5, function ()
                                            w:unpause()
                                        end)
                                        ::next_iteration::
                                    end

                                    Timed.call(1., function ()
                                        -- Show an earthquake effect only if the player is seeing the place where the effect is casted
                                        if RectContainsCoords(area, GetCameraTargetPositionX(), GetCameraTargetPositionY()) then
                                            CameraSetTargetNoiseEx(15., 500000, false)
                                            CameraSetSourceNoiseEx(15., 500000, false)
                                        end
                                        Timed.echo(1.5, function ()
                                            CameraSetSourceNoise(0, 0)
                                            CameraSetTargetNoise(0, 0)
                                        end)

                                        Timed.call(3., function ()
                                            SetUnitX(boss, originalX)
                                            SetUnitY(boss, originalY)

                                            Threat.addNPC(boss, false)

                                            SetUnitX(boss, GetRectCenterX(pipes[exit]))
                                            SetUnitY(boss, GetRectCenterY(pipes[exit]))
                                            BlzSetUnitFacingEx(boss, 180.)

                                            ShowUnitShow(boss)

                                            BossIsCasting(boss, false)
                                        end)
                                    end)
                                end)
                                return true
                            end
                            if not UnitAlive(boss) then
                                return true
                            end
                            IssuePointOrderById(boss, Orders.move, GetRectCenterX(pipes[enter]), GetRectCenterY(pipes[enter]))
                        end)
                    end
                end
            end

            if not secondPhase then
                if GetUnitHPRatio(boss) < 0.5 then
                    secondPhase = true
                    UnitAddAbility(boss, STINKY_AURA)
                    local current = 0
                    Timed.echo(0.02, 1., function ()
                        SetUnitVertexColor(boss, white:lerp(indianRed, current))
                        SetUnitScale(boss, Lerp(originalSize, current, increasedSize), 0., 0.)
                        current = current + 0.02
                    end)
                    AddUnitBonus(boss, BONUS_DAMAGE, 100)
                    BossChangeAttack(boss, 1)
                end
            end
        end,
        onStart = function ()
            startGoo()
        end,
        onDeath = function ()
            local owners = CreateForce()
            ForUnitsInRect(gg_rct_PlatinumNumemon_1, function (u)
                if IsPlayerInGame(GetOwningPlayer(u)) then
                    ForceAddPlayer(owners, GetOwningPlayer(u))
                end
            end)
            for i = 1, math.ceil(CountPlayersInForceBJ(owners)/3) do
                CreateItem(udg_RARE_DATA, GetUnitX(boss), GetUnitY(boss))
                if i == 2 then
                    RerollItemDrop(boss)
                end
            end
            DestroyForce(owners)
            stopGoo()
        end,
        onReset = function ()
            if secondPhase then
                secondPhase = false
                UnitRemoveAbility(boss, STINKY_AURA)
                local current = 0
                Timed.echo(0.02, 1., function ()
                    SetUnitVertexColor(boss, indianRed:lerp(white, current))
                    SetUnitScale(boss, Lerp(increasedSize, current, originalSize), 0., 0.)
                    current = current + 0.02
                end)
                AddUnitBonus(boss, BONUS_DAMAGE, -100)
                BossChangeAttack(boss, 0)
            end
            actualLifePercent = 1
            stopGoo()
        end
    })

    RegisterSpellEffectEvent(HEAL_NUMEMON, function ()
        local caster = GetSpellAbilityUnit()
        local target = GetSpellTargetUnit()
        local missile = Missiles:create(GetUnitX(caster), GetUnitY(caster), 0., GetUnitX(target), GetUnitY(target), 0.)
        missile.source = caster
        missile.owner = owner
        missile.target = target
        missile:arc(10.)
        missile:model("war3mapImported\\Trash.mdl")
        missile:speed(900.)
        missile.onFinish = function ()
            DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl", target, "origin"))
            SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + HEAL_PERCENT * GetUnitState(target, UNIT_STATE_MAX_LIFE))
        end
        missile:launch()
    end)

    local t = CreateTrigger()
    TriggerRegisterVariableEvent(t, "udg_PreDamageEvent", EQUAL, 1.00)
    TriggerAddAction(t, function ()
        if GetUnitTypeId(udg_DamageEventTarget) == NUMEMON_MINION then
            udg_DamageEventAmount = 1.
        end
    end)
end)
Debug.endFile()