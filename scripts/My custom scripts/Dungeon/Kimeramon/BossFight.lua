Debug.beginFile("Kimeramon\\BossFight")
OnInit(function ()
    Require "BossFightUtils"

    local boss = gg_unit_O06V_0193 ---@type unit
    local originalSize = BlzGetUnitRealField(boss, UNIT_RF_SCALING_VALUE)
    local increasedSize = originalSize * 1.55
    local white = Color.new(0xFFFFFFFF)
    local indianRed = Color.new(0xFFCD5C5C)

    local impaleOrder = Orders.impale

    local METEORMON = FourCC('O036')

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
            ForUnitsInRange(x, y, 700., function (u)
                if IsUnitEnemy(boss, GetOwningPlayer(u)) then
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
            d:setLevel(95)
            d.isSummon = true
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
        if flying then
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

        local defaultFly = GetUnitFlyHeight(boss)
        SetUnitFlyHeight(boss, 1280, 640)
        SetUnitAnimationByIndex(boss, 1)
        SetUnitTimeScale(boss, 2)

        ZTS_RemoveThreatUnit(boss)

        Timed.call(2., function ()
            ShowUnitHide(boss)

            if IsPlayerInForce(GetLocalPlayer(), canSee) then
                PingMinimapEx(landX, landY, 5., 255, 128, 0, false)
            end

            Timed.call(1., function ()
                ShowUnitShow(boss)
                SetUnitFlyHeight(boss, defaultFly, 640)
                SetUnitPosition(boss, landX, landY)

                Timed.call(2., function ()
                    SetUnitInvulnerable(boss, false)
                    PauseUnit(boss, false)
                    BlzSetUnitIntegerField(boss, UNIT_IF_MOVE_TYPE, defaultMoveType)
                    ResetUnitAnimation(boss)
                    SetUnitTimeScale(boss, 1)
                    flying = false

                    ZTS_AddThreatUnit(boss, false)
                end)
            end)
        end)
    end

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
        actions = function (u, unitsInTheField)
            if u then
                if not started then
                    started = true
                    doFlight()
                    stop = Timed.echo(100., function ()
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

                if not flying then
                    local chance = math.random(100)

                    if chance < 30 then
                        IssueTargetOrderById(boss, impaleOrder, u)
                    elseif chance > 90 then
                        BossMove(boss, 0, 600., GetHeroStr(boss, true), true)
                    end
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
                end
            end
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
            end
        end
    })
end)
Debug.endFile()