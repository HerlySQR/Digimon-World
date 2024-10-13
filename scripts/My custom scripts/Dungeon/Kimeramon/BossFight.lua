Debug.beginFile("Kimeramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O06V_0193 ---@type unit
    local originalSize = BlzGetUnitRealField(boss, UNIT_RF_SCALING_VALUE)
    local increasedSize = originalSize * 1.55
    local white = Color.new(0xFFFFFFFF)
    local indianRed = Color.new(0xFFCD5C5C)
    local tornadoPlace = gg_rct_KimeramonTornado ---@type rect

    local METEORMON = FourCC('O036')
    local VOLCAMON = FourCC('O056')
    local FIRE_RAY = FourCC('A0GE')
    local TORNADO = FourCC('n02J')
    local LIGHTNING_ATTACK = FourCC('A0GH')
    local EXTRA_HEALTH_FACTOR = 0.6
    local EXTRA_DMG_FACTOR = 6.

    local summons = {} ---@type Digimon[]

    local secondPhase = false

    Timed.call(0.01, function ()
        SetUnitOwner(gg_unit_O06H_0203, Digimon.VILLAIN, true)
    end)

    local defaultMoveType = BlzGetUnitIntegerField(boss, UNIT_IF_MOVE_TYPE)

    local landingPoints = {gg_rct_KimeramonLandPlace1, gg_rct_KimeramonLandPlace2, gg_rct_KimeramonLandPlace3, gg_rct_KimeramonLandPlace4}
    local landingOptions = Set.create(1, 2, 3)
    local canSee = CreateForce()
    local stop
    local flying = false
    local canFly = false
    local started = false
    local spawns = {} ---@type rect[]

    local numRect = 1
    while true do
        local r = rawget(_G, "gg_rct_KimeramonSpawn" .. numRect) -- To not display the error message
        if r then
            spawns[numRect] = r
        else
            break
        end
        numRect = numRect + 1
    end

    ---@param amount integer
    local function doAmbush(amount)
        local options = {}
        for i = 1, #spawns do
            local x, y = GetRectCenterX(spawns[i]), GetRectCenterY(spawns[i])
            local count = 0
            local angle = 0
            local target = nil
            ForUnitsInRange(x, y, 1600., function (u)
                if IsPlayerInGame(GetOwningPlayer(u)) then
                    count = count + 1
                    angle = math.deg(math.atan(GetUnitY(u) - y, GetUnitX(u) - x))
                    target = u
                end
            end)
            table.insert(options, {i, count, angle, target})
        end
        table.sort(options, function (a, b)
            return a[2] > b[2]
        end)
        for i = 1, math.min(#spawns, math.round(4.235*math.exp(0.166*amount))) do
            local x, y = GetRectCenterX(spawns[options[i][1]]), GetRectCenterY(spawns[options[i][1]])
            local d = Digimon.create(Digimon.VILLAIN, METEORMON, x, y, options[i][3])
            table.insert(summons, d)
            d:setLevel(95)
            AddUnitBonus(d.root, BONUS_STRENGTH, math.floor(GetHeroStr(d.root, false) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(d.root, BONUS_AGILITY, math.floor(GetHeroAgi(d.root, false) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(d.root, BONUS_INTELLIGENCE, math.floor(GetHeroInt(d.root, false) * EXTRA_HEALTH_FACTOR))
            AddUnitBonus(d.root, BONUS_DAMAGE, math.floor(GetAvarageAttack(d.root) * EXTRA_DMG_FACTOR))
            d.isSummon = true
            DestroyEffect(AddSpecialEffect("Abilities\\Weapons\\AncientProtectorMissile\\AncientProtectorMissile.mdl", x, y))
            ZTS_AddThreatUnit(d.root, false)
            if options[i][4] then
                ZTS_ModifyThreat(options[i][4], d.root, 1, false)
            end
            Timed.echo(1., 60., function ()
                if not UnitAlive(boss) and d:isAlive() then
                    d:destroy()
                    return true
                elseif not d:isAlive() then
                    return true
                end
            end, function ()
                DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl", d:getPos()))
                d:destroy()
            end)
        end
    end

    local function doFlight()
        if flying or BossStillCasting(boss) then
            return
        end

        flying = true
        BlzSetUnitIntegerField(boss, UNIT_IF_MOVE_TYPE, 2)
        SetUnitInvulnerable(boss, true)
        PauseUnit(boss, true)

        local drop = landingOptions:random()
        landingOptions:add(1, 2, 3, 4)
        landingOptions:removeSingle(drop)
        local landX, landY = GetRectCenterX(landingPoints[drop]), GetRectCenterY(landingPoints[drop])

        local canGrab = {}
        ForUnitsInRange(GetUnitX(boss), GetUnitY(boss), 200., function (u)
            if IsPlayerInGame(GetOwningPlayer(u)) and IsUnitType(u, UNIT_TYPE_HERO) then
                table.insert(canGrab, u)
            end
        end)
        local grabbed = canGrab[math.random(#canGrab)] ---@type unit?
        local defaultGrabbedFly

        local rate = 2250
        if grabbed then
            defaultGrabbedFly = GetUnitFlyHeight(grabbed)
            local face = math.rad(GetUnitFacing(boss))
            SetUnitPosition(grabbed, GetUnitX(boss) + 64*math.cos(face), GetUnitY(boss) + 64*math.sin(face))
            UnitAddAbility(grabbed, CROW_FORM_ID)
            UnitRemoveAbility(grabbed, CROW_FORM_ID)
            SetUnitFlyHeight(grabbed, 50, 999999)
            PauseUnit(grabbed, true)
            SetUnitInvulnerable(grabbed, true)
            SetUnitPathing(grabbed, false)

            if secondPhase then
                Timed.echo(0.1, 2., function ()
                    SetUnitFlyHeight(grabbed, 1600, rate)
                end)
            else
                SetUnitFlyHeight(grabbed, 1280, 640)
            end
        end

        local defaultFly = GetUnitFlyHeight(boss)
        if secondPhase then
            local actX, actY = GetUnitX(boss), GetUnitY(boss)
            DestroyEffect(AddSpecialEffect("war3mapImported\\HolyStomp.mdx", actX, actY))
            local eff = AddSpecialEffect("Abilities\\Spells\\Orc\\EarthQuake\\EarthQuakeTarget.mdl", actX, actY)
            Timed.call(3., function ()
                DestroyEffect(eff)
            end)
            Timed.echo(0.1, 2., function ()
                rate = rate - 86
                SetUnitFlyHeight(boss, 1600, rate)
            end)
            Timed.call(0.5, function ()
                DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\Volcano\\VolcanoDeath.mdl", actX, actY))
                Timed.call(1., function ()
                    local d = Digimon.create(Digimon.VILLAIN, VOLCAMON, actX, actY, bj_UNIT_FACING)
                    table.insert(summons, d)
                    d:setLevel(95)
                    AddUnitBonus(d.root, BONUS_STRENGTH, math.floor(GetHeroStr(d.root, false) * EXTRA_HEALTH_FACTOR))
                    AddUnitBonus(d.root, BONUS_AGILITY, math.floor(GetHeroAgi(d.root, false) * EXTRA_HEALTH_FACTOR))
                    AddUnitBonus(d.root, BONUS_INTELLIGENCE, math.floor(GetHeroInt(d.root, false) * EXTRA_HEALTH_FACTOR))
                    AddUnitBonus(d.root, BONUS_DAMAGE, math.floor(GetAvarageAttack(d.root) * EXTRA_DMG_FACTOR))
                end)
            end)
        else
            SetUnitFlyHeight(boss, 1280, 640)
        end
        SetUnitAnimationByIndex(boss, 1)
        SetUnitTimeScale(boss, 2)
        SetUnitPathing(boss, false)

        ZTS_RemoveThreatUnit(boss)

        Timed.call(2., function ()
            ShowUnitHide(boss)

            if grabbed then
                local color = GetUnitTintingColor(grabbed)
                color.alpha = 0
                SetUnitVertexColor(grabbed, color)
            end

            if IsPlayerInForce(GetLocalPlayer(), canSee) then
                PingMinimapEx(landX, landY, 5., 255, 128, 0, false)
            end

            Timed.call(1., function ()
                ShowUnitShow(boss)
                SetUnitFlyHeight(boss, defaultFly, 640)
                SetUnitPosition(boss, landX, landY)

                if grabbed then
                    local face = math.rad(GetUnitFacing(boss))
                    SetUnitPosition(grabbed, GetUnitX(boss) + 64*math.cos(face), GetUnitY(boss) + 64*math.sin(face))
                    SetUnitFlyHeight(grabbed, 50, 640)
                    local color = GetUnitTintingColor(grabbed)
                    color.alpha = 255
                    SetUnitVertexColor(grabbed, color)
                    SetUnitPathing(grabbed, true)
                end

                Timed.call(2., function ()
                    SetUnitInvulnerable(boss, false)
                    PauseUnit(boss, false)
                    BlzSetUnitIntegerField(boss, UNIT_IF_MOVE_TYPE, defaultMoveType)
                    ResetUnitAnimation(boss)
                    SetUnitTimeScale(boss, 1)
                    SetUnitPathing(boss, true)
                    flying = false

                    ZTS_AddThreatUnit(boss, false)

                    if grabbed then
                        SetUnitFlyHeight(grabbed, defaultGrabbedFly, 999999)
                        PauseUnit(grabbed, false)
                        SetUnitInvulnerable(grabbed, false)
                    end
                end)
            end)
        end)
    end

    local impale = FourCC('A0GB')

    InitBossFight({
        name = "Kimeramon",
        boss = boss,
        manualRevive = true,
        maxPlayers = 4,
        forceWall = {gg_dest_Dofv_53414},
        returnPlace = gg_rct_ASRReturn,
        returnEnv = "Ancient Dino Region",
        inner = gg_rct_KimeramonInner,
        entrance = gg_rct_KimeramonEntrance,
        toTeleport = gg_rct_Ancient_Speedy_Zone,
        spells = {
            3, Orders.howlofterror, CastType.IMMEDIATE, -- Howl
            4, Orders.tornado, CastType.POINT, -- Cyclone Clap
            0, Orders.impale, CastType.TARGET, -- Impale
            5, Orders.clusterrockets, CastType.POINT, -- Heat viper
            6, Orders.impale, CastType.TARGET, -- Impale
            3, Orders.creepthunderclap, CastType.IMMEDIATE, -- Fire Ray
        },
        castCondition = function ()
            return not flying
        end,
        actions = function (u, unitsInTheField)
            if GetUnitHPRatio(boss) < 0.6 then
                BlzEndUnitAbilityCooldown(boss, impale)
            end
            if u then
                if not started then
                    started = true
                    doFlight()
                    stop = Timed.echo(50., function ()
                        canFly = not canFly
                    end)
                end

                ForceClear(canSee)

                local close = false
                for u2 in unitsInTheField:elements() do
                    ForceAddPlayer(canSee, GetOwningPlayer(u2))
                    close = close or DistanceBetweenCoords(GetUnitX(u), GetUnitY(u), GetUnitX(boss), GetUnitY(boss)) < 1500
                end

                if close then
                    if not flying then
                        PauseUnit(boss, false)
                    end
                else
                    PauseUnit(boss, true)
                end

                if canFly then
                    canFly = false
                    doFlight()
                    Timed.call(1., function ()
                        doAmbush(#unitsInTheField)
                    end)
                end

                if math.random(100) > 90 then
                    BossMove(boss, 0, 600., GetHeroStr(boss, true), true)
                end

                -- Make the summons follow the nearest player unit to them
                for i = #summons, 1, -1 do
                    local d = summons[i]
                    if d:isAlive() then
                        local follow = nil ---@type unit
                        ForUnitsInRange(d:getX(), d:getY(), 900., function (u2)
                            if IsPlayerInGame(GetOwningPlayer(u2)) then
                                follow = u2
                            end
                        end)
                        if not follow then
                            ZTS_RemoveThreatUnit(d.root)
                            local nearby
                            local shortestDistance = math.huge
                            local x, y = d:getPos()
                            for _, u2 in ipairs(unitsInTheField) do
                                local dist = DistanceBetweenCoords(GetUnitX(u2), GetUnitY(u2), x, y)
                                if dist < shortestDistance then
                                    shortestDistance = dist
                                    nearby = u2
                                end
                            end
                            if nearby then
                                d:issueOrder(Orders.attack, GetUnitX(nearby), GetUnitY(nearby))
                            end
                        else
                            ZTS_AddThreatUnit(d.root, false)
                        end
                    else
                        table.remove(summons, i)
                    end
                end

                -- Summon moving tornado
                if math.random(4) == 1 then
                    SetUnitAnimation(boss, "spell")
                    local face = math.rad(GetUnitFacing(boss))

                    local tornado = CreateUnit(Digimon.VILLAIN, TORNADO, GetUnitX(boss) + 400.*math.cos(face), GetUnitY(boss) + 400.*math.sin(face), bj_UNIT_FACING)
                    DestroyEffect(AddSpecialEffect("Abilities\\Weapons\\GryphonRiderMissile\\GryphonRiderMissileTarget.mdl", GetUnitX(tornado), GetUnitY(tornado)))
                    SetUnitScale(tornado, 0.1, 0, 0)
                    local scale = 0.1
                    Timed.echo(0.02, 1, function ()
                        scale = scale + 0.018
                        SetUnitScale(tornado, scale, 0, 0)
                    end)

                    local xDir = math.cos(-face)
                    local yDir = math.sin(-face)

                    Timed.echo(0.02, 120., function ()
                        SetUnitX(tornado, GetUnitX(tornado) + 2 * xDir)
                        SetUnitY(tornado, GetUnitY(tornado) + 2 * yDir)

                        if GetUnitX(tornado) > GetRectMaxX(tornadoPlace) or GetUnitX(tornado) < GetRectMinX(tornadoPlace) then
                            xDir = -xDir
                        end
                        if GetUnitY(tornado) > GetRectMaxY(tornadoPlace) or GetUnitY(tornado) < GetRectMinY(tornadoPlace) then
                            yDir = -yDir
                        end
                        if not UnitAlive(boss) then
                            KillUnit(tornado)
                            return true
                        end
                    end, function ()
                        KillUnit(tornado)
                    end)
                end
            end

            if not secondPhase then
                if GetUnitHPRatio(boss) < 0.5 then
                    secondPhase = true
                    local current = 0
                    Timed.echo(0.02, 1., function ()
                        SetUnitVertexColor(boss, white:lerp(indianRed, current))
                        SetUnitScale(boss, Lerp(originalSize, current, increasedSize), 0., 0.)
                        current = current + 0.02
                    end)
                    AddUnitBonus(boss, BONUS_DAMAGE, 100)
                    UnitAddAbility(boss, FIRE_RAY)
                    BossChangeAttack(boss, 1)
                    UnitAddAbility(boss, LIGHTNING_ATTACK)
                end
            end
        end,
        onDeath = function ()
            local owners = CreateForce()
            ForUnitsInRect(gg_rct_KimeramonTornado, function (u)
                if IsPlayerInGame(GetOwningPlayer(u)) then
                    ForceAddPlayer(owners, GetOwningPlayer(u))
                end
            end)
            ForForce(owners, function ()
                CreateItem(RARE_DATA, GetUnitX(boss), GetUnitY(boss))
            end)
            DestroyForce(owners)
        end,
        onReset = function ()
            if started then
                started = false
                stop()
            end
            landingOptions:removeSingle(4)
            landingOptions:add(1, 2, 3)

            if secondPhase then
                secondPhase = false
                local current = 0
                Timed.echo(0.02, 1., function ()
                    SetUnitVertexColor(boss, indianRed:lerp(white, current))
                    SetUnitScale(boss, Lerp(increasedSize, current, originalSize), 0., 0.)
                    current = current + 0.02
                end)
                AddUnitBonus(boss, BONUS_DAMAGE, -100)
                UnitRemoveAbility(boss, FIRE_RAY)
                BossChangeAttack(boss, 0)
                UnitRemoveAbility(boss, LIGHTNING_ATTACK)
            end
        end
    })
end)
Debug.endFile()