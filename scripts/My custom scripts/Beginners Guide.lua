Debug.beginFile("Beginners Guide")
OnInit.final(function ()
    Require "Transmission"
    Require "Environment"
    Require "Backpack"
    Require "Digimon"

    local Menu = DialogCreate() ---@type dialog
    DialogSetMessage(Menu, "Do you wanna do the beginners guide?")
    local Yes = DialogAddButton(Menu, "Yes", 0) ---@type button
    local No = DialogAddButton(Menu, "No", 0x1B) ---@type button

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
    local bankEnter = __jarray(false) ---@type table<player, boolean>
    local gymEnter = __jarray(false) ---@type table<player, boolean>
    local trainEnter = __jarray(false) ---@type table<player, boolean>
    local tutorialsDone = __jarray(0) ---@type table<player, integer>
    local threads = {} ---@type table<player, thread>
    local piximons = {} ---@type table<player, Digimon>
    local checkForEnemy = nil ---@type fun(p: player)
    local checkForTransport = nil ---@type fun(p: player)

    local MAX_TUTORIALS = 12
    local DIGITAMA = FourCC('n00A')
    local PIXIMON = FourCC('O06U')
    local WHAMON = FourCC('N009')
    local BIRDRAMON = FourCC('N00F')
    local SELECT_HERO = FourCC('A0EQ')
    local NET = FourCC('I000')
    local TELEPORT_CASTER_EFFECT = "war3mapImported\\Blink Purple Caster.mdx"
    local TELEPORT_TARGET_EFFECT = "war3mapImported\\Blink Purple Target.mdx"

    local Tentomon = gg_unit_N01F_0075

    local queue = {} ---@type table<player, Transmission[]>

    ---@param tr Transmission
    ---@param p player
    local function enquequeTransmission(tr, p)
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
        inTutorial[p] = false
        ShowSave(p, true)
        ShowLoad(p, true)
        ShowBank(p, true)
        ShowHotkeys(p, true)
        ShowCosmetics(p, true)
        ShowHelp(p, true)
        ShowMapButton(p, true)

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
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Well done!", Transmission.SET, 2., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You are now ready to start your journey.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "So you no longer need my help.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Go to explore the Digimon World.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Good luck!", Transmission.SET, 2., true)
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
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Oh look, a new adventurer.", Transmission.SET, 3., true)
            tr:AddActions(1., function ()
                local angle = math.random() * 2 * math.pi
                pixie:issueOrder(Orders.move, pixie:getX() + 100 * math.cos(angle), pixie:getY() + 100 * math.sin(angle))
            end)
            tr:AddEnd(function ()
                tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Alright, let's not waste time, follow me.", Transmission.SET, 4., true)
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

                local warnings = 0
                local scolded = false
                Timed.echo(3., function ()
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

                                if DistanceBetweenCoords(pixie:getX(), pixie:getY(), d2:getPos()) > 1000. then
                                    MovePixie(pixie, d2:getPos())
                                    SetUnitFacing(pixie.root, -GetUnitFacing(d2.root))
                                end

                                pixie:issueOrder(Orders.smart, d2.root)

                                local tr = Transmission.create(Force(p))
                                if warnings == 1 then
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Wait!", Transmission.SET, 2., true)
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You don't know all the basics yet to you can explore.", Transmission.SET, 3.5, true)
                                elseif warnings == 2 then
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Seriously, you are not ready yet.", Transmission.SET, 3., true)
                                else
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "I see.", Transmission.SET, 2., true)
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "If you are decided to explore now, I won't stop you.", Transmission.SET, 3.5, true)
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Sadly I can't go further, so good luck in your journey!.", Transmission.SET, 3.5, true)
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

                    if warnings > 2 then
                        return true
                    end
                end)

                Timed.call(0.5, function ()
                    local tr = Transmission.create(Force(p))
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Welcome to the File City!", Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "This is your starting point in the Digimon World.", Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Do you wanna explore it all?", Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You can see all the places you visited in your map.", Transmission.SET, 3., true)
                    tr:AddEnd(function ()
                        dequequeTransmission(p)
                        ShowMapButton(p, true)
                    end)
                    enquequeTransmission(tr, p)
                end)
            end
        end
    end)

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
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Very good!", Transmission.SET, 2., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "In the Digimon World are digimons that could need your help.", Transmission.SET, 3., true)
            tr:AddActions(1., function ()
                local angle = math.atan(GetUnitY(Tentomon) - pixie:getY(), GetUnitX(Tentomon) - pixie:getX())
                pixie:setFacing(math.deg(angle))
            end)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Try talking with Tentomon to see what he needs.", Transmission.SET, 3., true)
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
                    if not scolded then
                        if DistanceBetweenCoords(GetUnitX(Tentomon), GetUnitY(Tentomon), d:getPos()) > 400. then
                            if thirdPart[p] then
                                return true
                            end
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
                                line = "Hey! Where are you going?"
                            elseif howMany == 2 then
                                line = "Are you gonna take this seriously?"
                            else
                                line = "Fine... Let's do something else."
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
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "This digimon asked for your help.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You can consult to your quest log for more information.", Transmission.SET, 3.5, true)
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
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "As you heard, he asked you to talk with other digimons.", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You can also try interact with them and see what they want.", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "In that case you can consult to your quest log.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "But if you want you can just explore the city.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "And remember to return to him when you finish the quest.", Transmission.SET, 3., true)

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

        if not itemPicked[p] then
            itemPicked[p] = true
            local pixie = piximons[p]
            local tr = Transmission.create(Force(p))
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "It seems that you picked a consummable item.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "This type of item goes to your backpack.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "To use that item open your backpack and select to who you wanna use it.", Transmission.SET, 3.5, true)
            local extra = nil
            if id == NET then
                netPicked[p] = true
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "The item you picked is a digimon net.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "The digimon net is used to capture an wild rookie digimon", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Is easier capture them when they have low health.", Transmission.SET, 3., true)
                tr:AddActions(function ()
                    ShowBank(p, true)
                end)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Then you can look at them in your menu.", Transmission.SET, 3., true)
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
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "This is a digimon net.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "the digimon net is used to capture an wild rookie digimon to make it join to your side.", Transmission.SET, 4., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "I recommend you reduce their health before capturing them.", Transmission.SET, 3., true)
            tr:AddActions(function ()
                ShowBank(p, true)
            end)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Then you can look for them in your digimon menu.", Transmission.SET, 3., true)
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

        Timed.call(function ()
            if UnitHasItem(d.root, m) then
                if not equipPicked[p] then
                    equipPicked[p] = true
                    local pixie = piximons[p]
                    d:pause()

                    local tr = Transmission.create(Force(p))
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "This is an equipment.", Transmission.SET, 2., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "It helps you to increase your stats.", Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "But you are limited in how many you can have at the time.", Transmission.SET, 3.5, true)
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

        if not shopEnter[p] then
            shopEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                local tr = Transmission.create(Force(p))
                if not restaurantEnter[p] then
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "In the Digimon World are places where you can buy items from other digimons.", Transmission.SET, 4., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "That is if you have digibits of course.", Transmission.SET, 2., true)
                end
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "In this shop you can buy equipment.", Transmission.SET, 2., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Those items can have special qualities.", Transmission.SET, 2., true)
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
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "In the Digimon World are places where you can buy items from other digimons.", Transmission.SET, 4., true)
                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "That is if you have digibits of course.", Transmission.SET, 2., true)
                end
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "In the restaurant they sell you food or drinks that buffs you for a long time.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "But you can only have one at the time.", Transmission.SET, 2.5, true)
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
                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Watch out!", Transmission.SET, 1., true)
                            tr:AddEnd(function ()
                                if d:getTypeId() == 0 then
                                    dequequeTransmission(p)
                                    return
                                end
                                pixie:issueOrder(Orders.move, d2:getPos())
                                Timed.call(1., function ()
                                    tr = Transmission.create(Force(p))
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "An enemy!", Transmission.SET, 2., true)
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
                                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "If you feel confident you can try fight it.", Transmission.SET, 3., true)
                                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "But you could flee if you can't.", Transmission.SET, 2., true)
                                            tr:AddEnd(function ()
                                                dequequeTransmission(p)
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
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "When you win you will get digibits and also experience if he has a similar level as yours", Transmission.SET, 4., true)
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
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Your digimon died.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Don't worry, after a while it will be ready for action.", Transmission.SET, 3.5, true)
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

        if not hospitalEnter[p] then
            hospitalEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                if d:getTypeId() == 0 then
                    return
                end
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "This is the Centauromon's hospital.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You can come here to heal.", Transmission.SET, 2., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "And in case all your crew fall on combat, you will appear here.", Transmission.SET, 3.5, true)
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
            if not transportFound[p] then
                for _, d in ipairs(GetUsedDigimons(p)) do
                    Digimon.enumInRange(d:getX(), d:getY(), 400., function (d2)
                        if not transportFound[p] and d2:getTypeId() == WHAMON or d2:getTypeId() == BIRDRAMON then
                            transportFound[p] = true
                            local pixie = piximons[p]
                            canFollow[p] = false

                            if DistanceBetweenCoords(pixie:getX(), pixie:getY(), d2:getPos()) > 1000. then
                                MovePixie(pixie, d2:getPos())
                            end

                            d:pause()

                            local tr = Transmission.create(Force(p))
                            tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Hey look!", Transmission.SET, 1., true)
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
                                    tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "This is one of the digimons that can transport to the Digimon World.", Transmission.SET, 4., true)
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
                                                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You can buy for their services if you are ready to explore.", Transmission.SET, 3., true)
                                            else
                                                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "But I don't recommend that yet, you are not ready.", Transmission.SET, 3., true)
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

        if not bankEnter[p] then
            bankEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                if d:getTypeId() == 0 then
                    return
                end
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Here at the bank you can look at the items you stored.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "And also the digimons you decided to save.", Transmission.SET, 2.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "...", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You know how to do it, right?", Transmission.SET, 2.5, true)
                tr:AddEnd(function ()
                    dequequeTransmission(p)
                    if d:getTypeId() == 0 then
                        return
                    end
                    ShowBank(p, true)
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

        if not gymEnter[p] then
            gymEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                if d:getTypeId() == 0 then
                    return
                end
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "So you decided to enter the |cffffff00Grey Arena|r.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Where you can fight with the strongest digimons (if you pay of course |cff00ff00;)|r ).", Transmission.SET, 4, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You can also have friendly fights with other adventurers.", Transmission.SET, 2.5, true)
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
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Maybe you noticed that you have a damage type and defense type.", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "Some damage types are better to certain armor types than others.", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "MarineAngemon", nil, "You can test it with this targets.", Transmission.SET, 2., true)
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

    -- Finish tutorial if a player restarts
    OnRestart(function (p)
        if inTutorial[p] then
            FinishTutorial(p)
            ShowSave(p, true)
            ShowLoad(p, true)
            ShowBank(p, false)
            ShowHotkeys(p, false)
            ShowCosmetics(p, false)
            ShowHelp(p, false)
            ShowMapButton(p, false)
        end
    end)
end)
Debug.endFile()