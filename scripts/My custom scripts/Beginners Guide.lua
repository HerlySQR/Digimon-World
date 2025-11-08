Debug.beginFile("Beginners Guide")
OnInit.final(function ()
    Require "Transmission"
    Require "Environment"
    Require "Backpack"
    Require "Digimon"
    Require "Stats"

    local Menu = DialogCreate() ---@type dialog
    DialogSetMessage(Menu, GetLocalizedString("DO_YOU_WANNA_DO_BEGINNER_GUIDE"))
    local Yes = DialogAddButton(Menu, GetLocalizedString("YES"), 0) ---@type button
    local No = DialogAddButton(Menu, GetLocalizedString("NO"), 0x1B) ---@type button

    local inTutorial = __jarray(false) ---@type table<player, boolean>
    local canFollow = __jarray(false) ---@type table<player, boolean>
    local firstPart = __jarray(false) ---@type table<player, boolean>
    local secondPart = __jarray(false) ---@type table<player, boolean>
    local thirdPart = __jarray(false) ---@type table<player, boolean>
    local secondPartSkipped = __jarray(false) ---@type table<player, boolean>
    local itemPicked = __jarray(false) ---@type table<player, boolean>
    local equipPicked = __jarray(false) ---@type table<player, boolean>
    local netPicked = __jarray(false) ---@type table<player, boolean>
    local shopEnter = __jarray(false) ---@type table<player, boolean>
    local restaurantEnter = __jarray(false) ---@type table<player, boolean>
    local enemyFound = __jarray(false) ---@type table<player, boolean>
    local enemyKilled = __jarray(false) ---@type table<player, boolean>
    local digimonDied = __jarray(false) ---@type table<player, boolean>
    local hospitalEnter = __jarray(false) ---@type table<player, boolean>
    local transportFound = __jarray(false) ---@type table<player, boolean>
    local resourceFound = __jarray(false) ---@type table<player, boolean>
    local bankEnter = __jarray(false) ---@type table<player, boolean>
    local gymEnter = __jarray(false) ---@type table<player, boolean>
    local trainEnter = __jarray(false) ---@type table<player, boolean>
    local fishEnter = __jarray(false) ---@type table<player, boolean>
    local tutorialsDone = __jarray(0) ---@type table<player, integer>
    local idle = __jarray(0) ---@type table<player, integer>
    local finish = {} ---@type table<player, function>
    local threads = {} ---@type table<player, thread>
    local piximons = {} ---@type table<player, Digimon>
    local checkForEnemy = nil ---@type fun(p: player)
    local checkForTransport = nil ---@type fun(p: player)
    local checkForResource = nil ---@type fun(p: player)

    local MAX_TUTORIALS = 13
    local DIGITAMA = FourCC('n00A')
    local PIXIMON = FourCC('O06U')
    local WHAMON = FourCC('N009')
    local BIRDRAMON = FourCC('N00F')
    local SELECT_HERO = FourCC('A0EQ')
    local NET = FourCC('I000')
    local TELEPORT_CASTER_EFFECT = "war3mapImported\\Blink Purple Caster.mdx"
    local TELEPORT_TARGET_EFFECT = "war3mapImported\\Blink Purple Target.mdx"
    local SAVE_ITEM = FourCC('A0C6')
    local SELL_ITEM = FourCC('A0F4')

    local Tentomon = gg_unit_N01F_0075

    local queue = {} ---@type table<player, Transmission[]>

    ---@param tr Transmission
    ---@param p player
    local function enquequeTransmission(tr, p)
        idle[p] = 20
        if not queue[p] then
            queue[p] = {}
        end
        if not queue[p][1] then
            tr:Start()
        end
        table.insert(queue[p], tr)
    end

    ---@param p player
    local function dequequeTransmission(p)
        if not queue[p] then
            queue[p] = {}
        end
        table.remove(queue[p], 1)
        if queue[p][1] then
            queue[p][1]:Start()
        end
    end

    ---@param p player
    ---@param d Digimon
    function RunBeginnersGuide(p, d)
        threads[p] = coroutine.running()
        d.environment = Environment.jijimon
        d:hide()
        DialogDisplay(p, Menu, true)
        SetPlayerAbilityAvailable(p, SAVE_ITEM, false)
        SetPlayerAbilityAvailable(p, SELL_ITEM, false)
        coroutine.yield()
    end

    ---Paused units doesn't active the shops, so I need to refresh them when are unpaused
    ---@param x number
    ---@param y number
    local function ClearShops(x, y)
        ForUnitsInRange(x, y, 451., function (u)
            if GetUnitAbilityLevel(u, SELECT_HERO) > 0 then
                UnitRemoveAbility(u, SELECT_HERO)
                Timed.call(function ()
                    UnitAddAbility(u, SELECT_HERO)
                end)
            end
        end)
    end

    ---@param pixie Digimon
    ---@param x number
    ---@param y number
    local function MovePixie(pixie, x, y)
        local eff = AddSpecialEffect(TELEPORT_CASTER_EFFECT, pixie:getPos())
        BlzSetSpecialEffectHeight(eff, GetUnitFlyHeight(pixie.root))
        BlzSetSpecialEffectScale(eff, 0.75)
        DestroyEffect(eff)

        pixie:setPos(x, y)

        eff = AddSpecialEffect(TELEPORT_TARGET_EFFECT, pixie:getPos())
        BlzSetSpecialEffectHeight(eff, GetUnitFlyHeight(pixie.root))
        BlzSetSpecialEffectScale(eff, 0.75)
        DestroyEffect(eff)
    end

    ---@param p player
    local function FinishTutorial(p)
        if finish[p] then
            finish[p]()
            finish[p] = nil
        end
        inTutorial[p] = false
        ShowSave(p, true)
        ShowLoad(p, true)
        ShowBank(p, true)
        --ShowSellItem(p, true)
        --ShowSaveItem(p, true)
        SetPlayerAbilityAvailable(p, SAVE_ITEM, true)
        SetPlayerAbilityAvailable(p, SELL_ITEM, true)
        ShowFish(p, true)
        ShowMaterials(p, true)
        ShowHotkeys(p, true)
        ShowCosmetics(p, true)
        ShowHelp(p, true)
        ShowMapButton(p, true)
        ShowStats(p)

        local pixie = piximons[p]
        piximons[p] = nil

        local eff = AddSpecialEffect(TELEPORT_TARGET_EFFECT, pixie:getPos())
        BlzSetSpecialEffectHeight(eff, GetUnitFlyHeight(pixie.root))
        BlzSetSpecialEffectScale(eff, 0.75)
        DestroyEffect(eff)

        pixie:destroy()

        threads[p] = nil
        canFollow[p] = false
        firstPart[p] = false
        secondPart[p] = false
        thirdPart[p] = false
        secondPartSkipped[p] = false
        itemPicked[p] = false
        equipPicked[p] = false
        netPicked[p] = false
        shopEnter[p] = false
        enemyFound[p] = false
        enemyKilled[p] = false
        digimonDied[p] = false
        hospitalEnter[p] = false
        transportFound[p] = false
        resourceFound[p] = false
        bankEnter[p] = false
        gymEnter[p] = false
        trainEnter[p] = false
        tutorialsDone[p] = 0
    end

    ---@param p player
    local function AddCompletedTutorial(p)
        tutorialsDone[p] = tutorialsDone[p] + 1
        if tutorialsDone[p] >= MAX_TUTORIALS then
            local tr = Transmission.create(Force(p))
            local pixie = piximons[p]
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_COMPLETED_1"), Transmission.SET, 2., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_COMPLETED_2"), Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_COMPLETED_3"), Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_COMPLETED_4"), Transmission.SET, 6., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_COMPLETED_5"), Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_COMPLETED_6"), Transmission.SET, 2., true)
            tr:AddEnd(function ()
                FinishTutorial(p)
                dequequeTransmission(p)
            end)
            enquequeTransmission(tr, p)
        end
    end

    -- Player starts the beginner's guide
    local t = CreateTrigger()
    TriggerRegisterDialogEvent(t, Menu)
    TriggerAddAction(t, function ()
        local p = GetTriggerPlayer()
        if GetClickedButton() == Yes then
            inTutorial[p] = true

            local d = GetUsedDigimons(p)[1]
            d:show()
            SelectUnitForPlayerSingle(d.root, p)

            ForUnitsOfPlayer(p, function (u)
                if GetUnitTypeId(u) == DIGITAMA then -- Digitama
                    d:setPos(GetUnitX(u), GetUnitY(u))
                end
            end)

            d:pause()

            local pixie = Digimon.create(Digimon.CITY, PIXIMON, d:getX(), d:getY(), bj_UNIT_FACING)
            pixie.owner = p
            piximons[p] = pixie

            local eff = AddSpecialEffect(TELEPORT_CASTER_EFFECT, d:getPos())
            BlzSetSpecialEffectHeight(eff, GetUnitFlyHeight(pixie.root))
            BlzSetSpecialEffectScale(eff, 0.75)
            DestroyEffect(eff)

            local tr = Transmission.create(Force(p))
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_START_1"), Transmission.SET, 3., true)
            tr:AddActions(1., function ()
                local angle = math.random() * 2 * math.pi
                pixie:issueOrder(Orders.move, pixie:getX() + 100 * math.cos(angle), pixie:getY() + 100 * math.sin(angle))
            end)
            tr:AddEnd(function ()
                tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_START_2"), Transmission.SET, 4., true)
                tr:AddEnd(function ()
                    IssuePointOrderById(pixie.root, Orders.move, GetRectCenterX(gg_rct_JijimonsHouse_Inside), GetRectCenterY(gg_rct_JijimonsHouse_Inside))
                    Timed.call(1.5, function ()
                        dequequeTransmission(p)
                        if d:getTypeId() == 0 then
                            return
                        end
                        d:unpause()
                        ClearShops(d:getPos())
                    end)
                end)
                tr:Start()
            end)
            enquequeTransmission(tr, p)

            checkForEnemy(p)
            checkForTransport(p)
            checkForResource(p)
        else
            coroutine.resume(threads[p])
        end
    end)

    -- Player lefts Jijimon's house
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_JijimonsHouse_Inside)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        if d then
            local p = d.owner
            if not inTutorial[p] then
                return
            end
            if d:getTypeId() == PIXIMON then
                d:setPos(GetRectCenterX(gg_rct_JijimonTP_outside), GetRectCenterY(gg_rct_JijimonTP_outside))
            elseif not firstPart[p] then
                d:pause()
                firstPart[p] = true

                local pixie = piximons[p]

                canFollow[p] = true
                Timed.echo(4., function ()
                    if inTutorial[p] then
                        local d2 = GetMainDigimon(p)

                        if d2 then
                            if pixie:isHidden() then
                                pixie:show()
                            end
                            if canFollow[p] then
                                if DistanceBetweenCoords(pixie:getX(), pixie:getY(), d2:getPos()) > 1000. then
                                    MovePixie(pixie, d2:getPos())
                                    SetUnitFacing(pixie.root, -GetUnitFacing(d2.root))
                                end

                                pixie:issueOrder(Orders.smart, d2.root)
                            end
                        else
                            if not pixie:isHidden() then
                                pixie:hide()
                            end
                        end
                    else
                        return true
                    end
                end)

                idle[p] = 15
                local warnings = 0
                local scolded = false
                finish[p] = Timed.echo(3., function ()
                    idle[p] = idle[p] - 1
                    if not scolded then
                        for _, d2 in ipairs(GetUsedDigimons(p)) do
                            local x, y = d2:getPos()
                            if DistanceBetweenCoords(GetRectCenterX(gg_rct_Player_1_Spawn), GetRectCenterY(gg_rct_Player_1_Spawn), x, y) > 4300. and
                                not RectContainsCoords(gg_rct_Jijimon_House, x, y) and
                                not RectContainsCoords(gg_rct_BirdraTransport_Inner, x, y) and
                                not RectContainsCoords(gg_rct_Hospital_Inner, x, y) and
                                not RectContainsCoords(gg_rct_Bank_Inner, x, y) and
                                not RectContainsCoords(gg_rct_Shop_Inner, x, y) and
                                not RectContainsCoords(gg_rct_Restaurant_Inner, x, y) and
                                not RectContainsCoords(gg_rct_Gym_Lobby, x, y) and
                                not RectContainsCoords(gg_rct_Gym_Arena_1, x, y) and
                                not RectContainsCoords(gg_rct_Gym_Arena_2, x, y) and
                                not RectContainsCoords(gg_rct_Gym_Arena_3, x, y) and
                                not RectContainsCoords(gg_rct_Gym_Arena_4, x, y) then

                                scolded = true
                                canFollow[p] = false
                                warnings = warnings + 1
                                idle[p] = 15

                                if DistanceBetweenCoords(pixie:getX(), pixie:getY(), d2:getPos()) > 1000. then
                                    MovePixie(pixie, d2:getPos())
                                    SetUnitFacing(pixie.root, -GetUnitFacing(d2.root))
                                end

                                pixie:issueOrder(Orders.smart, d2.root)

                                local tr = Transmission.create(Force(p))
                                if warnings == 1 then
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_LEAVE_1"), Transmission.SET, 2., true)
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_LEAVE_2"), Transmission.SET, 3.5, true)
                                elseif warnings == 2 then
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_LEAVE_3"), Transmission.SET, 3., true)
                                else
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_LEAVE_4"), Transmission.SET, 2., true)
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_LEAVE_5"), Transmission.SET, 3.5, true)
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_LEAVE_6"), Transmission.SET, 3.5, true)
                                end
                                tr:AddEnd(function ()
                                    if warnings > 2 then
                                        FinishTutorial(p)
                                    end
                                    Timed.call(3., function ()
                                        scolded = false
                                    end)
                                end)
                                tr:Start()

                                break
                            end
                        end
                    end

                    if idle[p] <= 0 then
                        idle[p] = 15
                        local line
                        if not secondPart[p] then
                            line = GetLocalizedString("TUTORIAL_HINT_MAP")
                        elseif not thirdPart[p] then
                            line = GetLocalizedString("TUTORIAL_HINT_TENTOMON")
                        else
                            local options = {}
                            if not restaurantEnter[p] then
                                table.insert(options, GetLocalizedString("TUTORIAL_HINT_RESTAURANT"))
                            end
                            if not shopEnter[p] then
                                table.insert(options, GetLocalizedString("TUTORIAL_HINT_SHOP"))
                            end
                            if not enemyFound[p] then
                                table.insert(options, GetLocalizedString("TUTORIAL_HINT_ENEMY"))
                            end
                            if not hospitalEnter[p] then
                                table.insert(options, GetLocalizedString("TUTORIAL_HINT_HOSPITAL"))
                            end
                            if not transportFound[p] then
                                table.insert(options, GetLocalizedString("TUTORIAL_HINT_TRANSPORT"))
                            end
                            --if not resourceFound[p] then
                            --    table.insert(options, ".")
                            --end
                            if not bankEnter[p] then
                                table.insert(options, GetLocalizedString("TUTORIAL_HINT_BANK"))
                            end
                            if not gymEnter[p] then
                                table.insert(options, GetLocalizedString("TUTORIAL_HINT_GYM"))
                            end
                            if not trainEnter[p] then
                                table.insert(options, GetLocalizedString("TUTORIAL_HINT_TRAIN"))
                            end
                            if not fishEnter[p] then
                                table.insert(options, GetLocalizedString("TUTORIAL_HINT_FISH"))
                            end
                            line = options[math.random(#options)]
                        end
                        if line then
                            local tr = Transmission.create(Force(p))
                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, line, Transmission.SET, 3., true)
                            tr:AddEnd(function ()
                                dequequeTransmission(p)
                            end)
                            enquequeTransmission(tr, p)
                        end
                    end

                    if warnings > 2 then
                        finish[p] = nil
                        return true
                    end
                end)

                Timed.call(0.5, function ()
                    local tr = Transmission.create(Force(p))
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_INTRO_1"), Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_INTRO_2"), Transmission.SET, 3.5, true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_INTRO_3"), Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_INTRO_4"), Transmission.SET, 3.5, true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_INTRO_5"), Transmission.SET, 3.5, true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_INTRO_6"), Transmission.SET, 3.5, true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_INTRO_7"), Transmission.SET, 3., true)
                    tr:AddEnd(function ()
                        dequequeTransmission(p)
                        ShowMapButton(p, true)
                    end)
                    enquequeTransmission(tr, p)
                end)
            end
        end
    end)

    local function dontWannaTalkWithTentomon(p)
        if not inTutorial[p] then
            return
        end

        if not thirdPart[p] then
            thirdPart[p] = true
            secondPartSkipped[p] = true
            local pixie = piximons[p]
            local tr = Transmission.create(Force(p))
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_DONT_WANNA_TALK_WITH_TENTOMON"), Transmission.SET, 3.5, true)
            tr:AddActions(1., function ()
                dequequeTransmission(p)
            end)
            enquequeTransmission(tr, p)
        end
    end

    -- Player closes the map menu
    OnSeeMapClosed(function (p)
        if not inTutorial[p] then
            return
        end

        local d = GetUsedDigimons(p)[1]
        if inTutorial[p] and not secondPart[p] then
            secondPart[p] = true
            local pixie = piximons[p]

            local tr = Transmission.create(Force(p))
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_MAP_1"), Transmission.SET, 2., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_MAP_2"), Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_MAP_3"), Transmission.SET, 4., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_MAP_4"), Transmission.SET, 3.5, true)
            tr:AddActions(1., function ()
                local angle = math.atan(GetUnitY(Tentomon) - pixie:getY(), GetUnitX(Tentomon) - pixie:getX())
                pixie:setFacing(math.deg(angle))
            end)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_MAP_5"), Transmission.SET, 3., true)
            tr:AddEnd(function ()
                Timed.call(2., function ()
                    if d:getTypeId() == 0 then
                        return
                    end
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                local scolded = false
                local howMany = 0

                Timed.echo(3., function ()
                    if not inTutorial[p] or thirdPart[p] then
                        return true
                    end
                    if not scolded then
                        if DistanceBetweenCoords(GetUnitX(Tentomon), GetUnitY(Tentomon), d:getPos()) > 400. then
                            if d:getTypeId() == 0 then
                                return true
                            end

                            canFollow[p] = false

                            scolded = true
                            howMany = howMany + 1

                            local face = GetUnitFacing(d.root)

                            d:pause()

                            local line
                            if howMany == 1 then
                                line = GetLocalizedString("TUTORIAL_DONT_WANNA_TALK_WITH_TENTOMON_1")
                            elseif howMany == 2 then
                                line = GetLocalizedString("TUTORIAL_DONT_WANNA_TALK_WITH_TENTOMON_2")
                            else
                                line = GetLocalizedString("TUTORIAL_DONT_WANNA_TALK_WITH_TENTOMON_3")
                            end

                            local angle = math.rad(face)
                            pixie:issueOrder(Orders.move, d:getX() + 100 * math.cos(angle), d:getY() + 100 * math.cos(angle))
                            Timed.call(1.5, function ()
                                if d:getTypeId() == 0 then
                                    return
                                end
                                SetUnitFacing(pixie.root, -face)
                                tr = Transmission.create(Force(p))
                                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, line, Transmission.SET, 3., true)
                                tr:AddEnd(function ()
                                    canFollow[p] = true
                                    Timed.call(3, function ()
                                        scolded = false
                                    end)
                                    if d:getTypeId() == 0 then
                                        return
                                    end
                                    d:unpause()
                                    ClearShops(d:getPos())
                                end)
                                tr:Start()
                            end)

                            if howMany > 2 then
                                secondPartSkipped[p] = true
                                thirdPart[p] = true
                                return true
                            end
                        end
                    end
                end)
            end)
            tr:Start()
        end
    end)

    -- Player gets a quest
    OnQuestAdded(function (p, id)
        if not inTutorial[p] then
            return
        end
        Timed.call(2.5, function ()
            local d = GetUsedDigimons(p)[1]
            local pixie = piximons[p]

            if secondPartSkipped[p] then
                d:pause()
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_QUEST_TENTOMON_1"), Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_QUEST_TENTOMON_2"), Transmission.SET, 3.5, true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    d:unpause()
                    ClearShops(d:getPos())
                    AddCompletedTutorial(p)
                end)
                enquequeTransmission(tr, p)
            elseif id == udg_TalkDigimonsId then
                thirdPart[p] = true
                d:pause()
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_QUEST_1"), Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_QUEST_2"), Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_QUEST_3"), Transmission.SET, 4., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_QUEST_4"), Transmission.SET, 4., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_QUEST_5"), Transmission.SET, 4., true)

                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    d:unpause()
                    ClearShops(d:getPos())
                    AddCompletedTutorial(p)
                end)
                enquequeTransmission(tr, p)
            end
        end)
    end)

    -- Player picks a consummable item
    OnBackpackPick(function (u, id)
        local p = GetOwningPlayer(u)
        if not inTutorial[p] then
            return
        end

        dontWannaTalkWithTentomon(p)
        if not itemPicked[p] then
            itemPicked[p] = true
            local pixie = piximons[p]
            local tr = Transmission.create(Force(p))
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BACKPACK_1"), Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BACKPACK_2"), Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BACKPACK_3"), Transmission.SET, 4., true)
            local extra = nil
            if id == NET then
                netPicked[p] = true
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BACKPACK_NET_1"), Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BACKPACK_NET_2"), Transmission.SET, 4., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BACKPACK_NET_3"), Transmission.SET, 4., true)
                tr:AddActions(function ()
                    ShowBank(p, true)
                end)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BACKPACK_NET_4"), Transmission.SET, 3., true)
                extra = function ()
                    if tr:WasSkipped() then
                        ShowBank(p, true)
                    end
                    AddCompletedTutorial(p)
                end
            end
            tr:AddEnd(function ()
                dequequeTransmission(p)
                AddCompletedTutorial(p)
                if extra then
                    extra()
                end
            end)
            enquequeTransmission(tr, p)
        elseif not netPicked[p] and id == NET then
            netPicked[p] = true
            local pixie = piximons[p]
            local tr = Transmission.create(Force(p))
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_NET_1"), Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_NET_2"), Transmission.SET, 4., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_NET_3"), Transmission.SET, 4., true)
            tr:AddActions(function ()
                ShowBank(p, true)
            end)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_NET_4"), Transmission.SET, 3., true)
            tr:AddEnd(function ()
                dequequeTransmission(p)
                if tr:WasSkipped() then
                    ShowBank(p, true)
                end
                AddCompletedTutorial(p)
            end)
            enquequeTransmission(tr, p)
        end
    end)

    -- Player picks a non-consummable item
    t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetManipulatingUnit())
        if not d then
            return
        end
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        local m = GetManipulatedItem()

        dontWannaTalkWithTentomon(p)
        Timed.call(function ()
            if UnitHasItem(d.root, m) then
                if not equipPicked[p] then
                    equipPicked[p] = true
                    local pixie = piximons[p]

                    local tr = Transmission.create(Force(p))
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_EQUIPMENT_1"), Transmission.SET, 2., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_EQUIPMENT_2"), Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_EQUIPMENT_3"), Transmission.SET, 3.5, true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_EQUIPMENT_4"), Transmission.SET, 4., true)
                    tr:AddActions(function ()
                        ShowStats(p)
                    end)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_EQUIPMENT_5"), Transmission.SET, 3., true)
                    tr:AddEnd(function ()
                        dequequeTransmission(p)
                        if d:getTypeId() == 0 then
                            return
                        end
                        if tr:WasSkipped() then
                            ShowStats(p)
                        end
                        AddCompletedTutorial(p)
                        ClearShops(d:getPos())
                    end)
                    enquequeTransmission(tr, p)
                end
            end
        end)
    end)

    -- Player enters in the shop
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Shop_Inner)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        if not d then
            return
        end
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        dontWannaTalkWithTentomon(p)
        if not shopEnter[p] then
            shopEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                local tr = Transmission.create(Force(p))
                if not restaurantEnter[p] then
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_SHOP_1"), Transmission.SET, 4., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_SHOP_2"), Transmission.SET, 3., true)
                end
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_SHOP_3"), Transmission.SET, 4., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_SHOP_4"), Transmission.SET, 3., true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                enquequeTransmission(tr, p)
            end)
        end
    end)

    -- Player enters in the restaraunt
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Restaurant_Inner)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        if not d then
            return
        end
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        dontWannaTalkWithTentomon(p)
        if not restaurantEnter[p] then
            restaurantEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                if d:getTypeId() == 0 then
                    return
                end
                local tr = Transmission.create(Force(p))
                if not shopEnter[p] then
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_RESTAURANT_1"), Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_RESTAURANT_2"), Transmission.SET, 3., true)
                end
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_RESTAURANT_3"), Transmission.SET, 4., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_RESTAURANT_4"), Transmission.SET, 4., true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                enquequeTransmission(tr, p)
            end)
        end
    end)

    -- Player encounters an enemy

    ---@param p player
    function checkForEnemy(p)
        Timed.echo(1., function ()
            if not inTutorial[p] then
                return true
            end
            if not enemyFound[p] then
                for _, d in ipairs(GetUsedDigimons(p)) do
                    Digimon.enumInRange(d:getX(), d:getY(), 700., function (d2)
                        if not enemyFound[p] and d2:getOwner() == Digimon.NEUTRAL then
                            enemyFound[p] = true
                            local pixie = piximons[p]
                            canFollow[p] = false

                            if DistanceBetweenCoords(pixie:getX(), pixie:getY(), d:getPos()) > 1000. then
                                MovePixie(pixie, d:getPos())
                            end

                            d:issueOrder(Orders.attack, d.root)

                            local tr = Transmission.create(Force(p))
                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_ENEMY_1"), Transmission.SET, 1., true)
                            tr:AddEnd(function ()
                                if d:getTypeId() == 0 then
                                    dequequeTransmission(p)
                                    return
                                end
                                pixie:issueOrder(Orders.move, d2:getPos())
                                Timed.call(1., function ()
                                    tr = Transmission.create(Force(p))
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_ENEMY_2"), Transmission.SET, 2., true)
                                    tr:AddEnd(function ()
                                        if d:getTypeId() == 0 then
                                            dequequeTransmission(p)
                                            return
                                        end
                                        pixie:issueOrder(Orders.move, d:getPos())
                                        Timed.call(1., function ()
                                            if d:getTypeId() == 0 then
                                                dequequeTransmission(p)
                                                return
                                            end
                                            tr = Transmission.create(Force(p))
                                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_ENEMY_3"), Transmission.SET, 3., true)
                                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_ENEMY_4"), Transmission.SET, 2.5, true)
                                            tr:AddActions(function ()
                                                ShowStats(p)
                                            end)
                                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_ENEMY_5"), Transmission.SET, 3., true)
                                            tr:AddEnd(function ()
                                                dequequeTransmission(p)
                                                if tr:WasSkipped() then
                                                    ShowStats(p)
                                                end
                                            end)
                                            tr:Start()
                                            canFollow[p] = true
                                        end)
                                    end)
                                    tr:Start()
                                end)
                            end)
                            enquequeTransmission(tr, p)
                        end
                    end)
                    if enemyFound[p] then
                        break
                    end
                end
            else
                return true
            end
        end)
    end

    Digimon.killEvent:register(function (info)
        local killer = Wc3Type(info.killer) == "unit" and Digimon.getInstance(info.killer) or info.killer
        if killer then
            local p = killer:getOwner()

            if inTutorial[p] and not enemyKilled[p] then
                enemyKilled[p] = true
                local pixie = piximons[p]
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_KILL_1"), Transmission.SET, 5., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_KILL_2"), Transmission.SET, 4.5, true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    AddCompletedTutorial(p)
                end)
                enquequeTransmission(tr, p)
            end
        end

        -- If a player digimon dies
        local target = info.target
        local p = target:getOwner()
        if not inTutorial[p] then
            return
        end

        if not digimonDied[p] then
            digimonDied[p] = true
            local pixie = piximons[p]
            local tr = Transmission.create(Force(p))
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_DEATH_1"), Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_DEATH_2"), Transmission.SET, 3.5, true)
            tr:AddEnd(function ()
                dequequeTransmission(p)
            end)
            enquequeTransmission(tr, p)
        end
    end)

    -- Player enters in the hospital
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Hospital_Inner)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        if not d then
            return
        end
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        dontWannaTalkWithTentomon(p)
        if not hospitalEnter[p] then
            hospitalEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                if d:getTypeId() == 0 then
                    return
                end
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_HOSPITAL_1"), Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_HOSPITAL_2"), Transmission.SET, 4., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_HOSPITAL_3"), Transmission.SET, 4.5, true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                enquequeTransmission(tr, p)
            end)
        end
    end)

    -- Player gets closer to a transport

    ---@param p player
    function checkForTransport(p)
        Timed.echo(1., function ()
            if not inTutorial[p] then
                return true
            end
            if not transportFound[p] then
                for _, d in ipairs(GetUsedDigimons(p)) do
                    Digimon.enumInRange(d:getX(), d:getY(), 400., function (d2)
                        if not transportFound[p] and d2:getTypeId() == WHAMON or d2:getTypeId() == BIRDRAMON then
                            transportFound[p] = true
                            dontWannaTalkWithTentomon(p)
                            local pixie = piximons[p]
                            canFollow[p] = false

                            if DistanceBetweenCoords(pixie:getX(), pixie:getY(), d2:getPos()) > 1000. then
                                MovePixie(pixie, d2:getPos())
                            end

                            d:pause()

                            local tr = Transmission.create(Force(p))
                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_TRANSPORT_1"), Transmission.SET, 1., true)
                            tr:AddEnd(function ()
                                if d:getTypeId() == 0 then
                                    dequequeTransmission(p)
                                    return
                                end
                                pixie:issueOrder(Orders.move, d2:getPos())
                                Timed.call(1., function ()
                                    if d:getTypeId() == 0 then
                                        dequequeTransmission(p)
                                        return
                                    end
                                    tr = Transmission.create(Force(p))
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_TRANSPORT_2"), Transmission.SET, 4., true)
                                    tr:AddEnd(function ()
                                        if d:getTypeId() == 0 then
                                            dequequeTransmission(p)
                                            return
                                        end
                                        pixie:issueOrder(Orders.move, d:getPos())
                                        Timed.call(1., function ()
                                            if d:getTypeId() == 0 then
                                                dequequeTransmission(p)
                                                return
                                            end
                                            tr = Transmission.create(Force(p))
                                            if tutorialsDone[p] == MAX_TUTORIALS - 1 then
                                                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_TRANSPORT_3"), Transmission.SET, 3., true)
                                            else
                                                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_TRANSPORT_4"), Transmission.SET, 3., true)
                                            end
                                            tr:AddEnd(function ()
                                                dequequeTransmission(p)
                                                canFollow[p] = true
                                                d:unpause()
                                                ClearShops(d:getPos())
                                                AddCompletedTutorial(p)
                                            end)
                                            tr:Start()
                                        end)
                                    end)
                                    tr:Start()
                                end)
                            end)
                            enquequeTransmission(tr, p)
                        end
                    end)
                    if transportFound[p] then
                        break
                    end
                end
            else
                return true
            end
        end)
    end

    -- Player gets closer to a resource

    ---@param p player
    function checkForResource(p)
        Timed.echo(1., function ()
            if not inTutorial[p] then
                return true
            end
            if not resourceFound[p] then
                for _, d in ipairs(GetUsedDigimons(p)) do
                    ForUnitsInRange(d:getX(), d:getY(), 400., function (r)
                        if not resourceFound[p] and GetOwningPlayer(r) == Digimon.RESOURCE then
                            resourceFound[p] = true
                            dontWannaTalkWithTentomon(p)
                            local pixie = piximons[p]
                            canFollow[p] = false

                            if DistanceBetweenCoords(pixie:getX(), pixie:getY(), GetUnitX(r), GetUnitY(r)) > 1000. then
                                MovePixie(pixie, GetUnitX(r), GetUnitY(r))
                            else
                                pixie:issueOrder(Orders.move, GetUnitX(r), GetUnitY(r))
                            end

                            pixie:issueOrder(Orders.move, GetUnitX(r), GetUnitY(r))
                            Timed.call(1., function ()
                                if d:getTypeId() == 0 then
                                    return
                                end
                                local tr = Transmission.create(Force(p))
                                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_RESOURCE_1"), Transmission.SET, 4., true)
                                tr:AddEnd(function ()
                                    if d:getTypeId() == 0 then
                                        dequequeTransmission(p)
                                        return
                                    end
                                    pixie:issueOrder(Orders.move, d:getPos())
                                    Timed.call(1., function ()
                                        if d:getTypeId() == 0 then
                                            dequequeTransmission(p)
                                            return
                                        end
                                        tr = Transmission.create(Force(p))
                                        if equipPicked[p] then
                                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_RESOURCE_2"), Transmission.SET, 3., true)
                                        else
                                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_RESOURCE_3"), Transmission.SET, 3., true)
                                        end
                                        tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_RESOURCE_4"), Transmission.SET, 3., true)
                                        tr:AddEnd(function ()
                                            dequequeTransmission(p)
                                            canFollow[p] = true
                                            ClearShops(d:getPos())
                                            AddCompletedTutorial(p)
                                        end)
                                        tr:Start()
                                    end)
                                end)
                                tr:Start()
                            end)
                        end
                    end)
                    if resourceFound[p] then
                        break
                    end
                end
            else
                return true
            end
        end)
    end

    -- Player enters in the bank
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Bank_Inner)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        if not d then
            return
        end
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        dontWannaTalkWithTentomon(p)
        if not bankEnter[p] then
            bankEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                if d:getTypeId() == 0 then
                    return
                end
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BANK_1"), Transmission.SET, 4., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BANK_2"), Transmission.SET, 4., true)
                tr:AddActions(function ()
                    --ShowSaveItem(p, true)
                    SetPlayerAbilityAvailable(p, SAVE_ITEM, true)
                end)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BANK_3"), Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BANK_4"), Transmission.SET, 3.5, true)
                tr:AddActions(function ()
                    --ShowSellItem(p, true)
                    SetPlayerAbilityAvailable(p, SELL_ITEM, true)
                end)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BANK_5"), Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_BANK_6"), Transmission.SET, 3.5, true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    if tr:WasSkipped() then
                        --ShowSellItem(p, true)
                        --ShowSaveItem(p, true)
                        SetPlayerAbilityAvailable(p, SAVE_ITEM, true)
                        SetPlayerAbilityAvailable(p, SELL_ITEM, true)
                    end
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                enquequeTransmission(tr, p)
            end)
        end
    end)

    -- Player enters in the gym
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Gym_Lobby)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        if not d then
            return
        end
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        dontWannaTalkWithTentomon(p)
        if not gymEnter[p] then
            gymEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                if d:getTypeId() == 0 then
                    return
                end
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_GYM_1"), Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_GYM_2"), Transmission.SET, 4, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_GYM_3"), Transmission.SET, 4.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_GYM_4"), Transmission.SET, 5., true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                enquequeTransmission(tr, p)
            end)
        end
    end)

    -- Player enters the train area
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Train_Area)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        if not d then
            return
        end
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        dontWannaTalkWithTentomon(p)
        if not trainEnter[p] then
            trainEnter[p] = true
            canFollow[p] = false
            local pixie = piximons[p]
            MovePixie(pixie, d:getPos())
            d:pause()

            Timed.call(0.5, function ()
                if d:getTypeId() == 0 then
                    return
                end
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_TRAIN_1"), Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_TRAIN_2"), Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_TRAIN_3"), Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_TRAIN_4"), Transmission.SET, 2., true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    canFollow[p] = true
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                enquequeTransmission(tr, p)
            end)
        end
    end)

    -- Player gets close to the fisher
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_FishingZone)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        if not d then
            return
        end
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        dontWannaTalkWithTentomon(p)
        if not fishEnter[p] then
            fishEnter[p] = true
            canFollow[p] = false
            local pixie = piximons[p]
            MovePixie(pixie, d:getPos())
            d:pause()

            Timed.call(0.5, function ()
                if d:getTypeId() == 0 then
                    return
                end
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_FISH_1"), Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_FISH_2"), Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_FISH_3"), Transmission.SET, 4.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, GetLocalizedString("TUTORIAL_FISH_4"), Transmission.SET, 3.5, true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    canFollow[p] = true
                    ShowFish(p, true)
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                enquequeTransmission(tr, p)
            end)
        end
    end)

    -- Finish tutorial if a player restarts
    OnRestart(function (p)
        if inTutorial[p] then
            FinishTutorial(p)
            ShowSave(p, true)
            ShowLoad(p, true)
            ShowBank(p, false)
            SetPlayerAbilityAvailable(p, SAVE_ITEM, false)
            SetPlayerAbilityAvailable(p, SELL_ITEM, false)
            --ShowSellItem(p, false)
            --ShowSaveItem(p, false)
            ShowFish(p, false)
            ShowMaterials(p, false)
            ShowHotkeys(p, false)
            ShowCosmetics(p, false)
            ShowHelp(p, false)
            ShowMapButton(p, false)
        end
    end)
end)
Debug.endFile()