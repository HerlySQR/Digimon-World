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
    local secondPart = __jarray(false) ---@type table<player, boolean>
    local thirdPart = __jarray(false) ---@type table<player, boolean>
    local secondPartSkipped = __jarray(false) ---@type table<player, boolean>
    local itemPicked = __jarray(false) ---@type table<player, boolean>
    local equipPicked = __jarray(false) ---@type table<player, boolean>
    local netPicked = __jarray(false) ---@type table<player, boolean>
    local shopEnter = __jarray(false) ---@type table<player, boolean>
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
    end

    ---@param p player
    local function AddCompletedTutorial(p)
        tutorialsDone[p] = tutorialsDone[p] + 1
        if tutorialsDone[p] >= MAX_TUTORIALS then
            local tr = Transmission.create(Force(p))
            local pixie = piximons[p]
            tr:AddLine(pixie.root, nil, "Piximon", nil, "Well done!", Transmission.SET, 2., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "You are now ready to start your journey.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "So you no longer need my help.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "Go to explore the Digimon World.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "Good luck!", Transmission.SET, 2., true)
            tr:AddEnd(function ()
                FinishTutorial(p)
            end)
            tr:Start()
        end
    end

    -- Player starts the beginner's guide
    local t = CreateTrigger()
    TriggerRegisterDialogEvent(t, Menu)
    TriggerAddAction(t, function ()
        local p = GetTriggerPlayer()
        if GetClickedButton() == Yes then
            inTutorial[p] = true

            local d = GetDigimons(p)[1]
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
            tr:AddLine(pixie.root, nil, "Piximon", nil, "Oh look, a new adventurer.", Transmission.SET, 3., true)
            tr:AddActions(1., function ()
                local angle = math.random() * 2 * math.pi
                pixie:issueOrder(Orders.move, pixie:getX() + 100 * math.cos(angle), pixie:getY() + 100 * math.sin(angle))
            end)
            tr:AddEnd(function ()
                tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "Piximon", nil, "Alright, let's not waste time, follow me.", Transmission.SET, 4., true)
                tr:AddEnd(function ()
                    IssuePointOrderById(pixie.root, Orders.move, GetRectCenterX(gg_rct_JijimonsHouse_Inside), GetRectCenterY(gg_rct_JijimonsHouse_Inside))
                    Timed.call(1.5, function ()
                        d:unpause()
                        ClearShops(d:getPos())
                    end)
                end)
                tr:Start()
            end)
            tr:Start()

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
        local p = d.owner
        if not inTutorial[p] then
            return
        end
        if d then
            if d:getTypeId() == PIXIMON then
                d:setPos(GetRectCenterX(gg_rct_JijimonTP_outside), GetRectCenterY(gg_rct_JijimonTP_outside))
            else
                d:pause()

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
                            if DistanceBetweenCoords(GetRectCenterX(gg_rct_Player_1_Spawn), GetRectCenterY(gg_rct_Player_1_Spawn), x, y) > 3300. and
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
                                    tr:AddLine(pixie.root, nil, "Piximon", nil, "Wait!", Transmission.SET, 2., true)
                                    tr:AddLine(pixie.root, nil, "Piximon", nil, "You don't know all the basics yet to you can explore.", Transmission.SET, 3.5, true)
                                elseif warnings == 2 then
                                    tr:AddLine(pixie.root, nil, "Piximon", nil, "Seriously, you are not ready yet.", Transmission.SET, 3., true)
                                else
                                    tr:AddLine(pixie.root, nil, "Piximon", nil, "I see.", Transmission.SET, 2., true)
                                    tr:AddLine(pixie.root, nil, "Piximon", nil, "If you are decided to explore now, I won't stop you.", Transmission.SET, 3.5, true)
                                    tr:AddLine(pixie.root, nil, "Piximon", nil, "Sadly I can't go further, so good luck in your journey!.", Transmission.SET, 3.5, true)
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
                    tr:AddLine(pixie.root, nil, "Piximon", nil, "Welcome to the File City!", Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "Piximon", nil, "This is your starting point in the Digimon World.", Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "Piximon", nil, "Do you wanna explore it all?", Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "Piximon", nil, "You can see all the places you visited in your map.", Transmission.SET, 3., true)
                    tr:AddEnd(function ()
                        ShowMapButton(p, true)
                    end)
                    tr:Start()
                end)
            end
        end
    end)

    -- Player closes the map menu
    OnSeeMapClosed(function (p)
        if not inTutorial[p] then
            return
        end

        local d = GetDigimons(p)[1]
        if inTutorial[p] and not secondPart[p] then
            secondPart[p] = true
            local pixie = piximons[p]

            local tr = Transmission.create(Force(p))
            tr:AddLine(pixie.root, nil, "Piximon", nil, "Very good!", Transmission.SET, 2., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "In the Digimon World are digimons that could need your help.", Transmission.SET, 3., true)
            tr:AddActions(1., function ()
                local angle = math.atan(GetUnitY(Tentomon) - pixie:getY(), GetUnitX(Tentomon) - pixie:getX())
                pixie:setFacing(math.deg(angle))
            end)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "Try talking with Tentomon to see what he needs.", Transmission.SET, 3., true)
            tr:AddEnd(function ()
                Timed.call(2., function ()
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
                                SetUnitFacing(pixie.root, -face)
                                tr = Transmission.create(Force(p))
                                tr:AddLine(pixie.root, nil, "Piximon", nil, line, Transmission.SET, 3., true)
                                tr:AddEnd(function ()
                                    canFollow[p] = true
                                    Timed.call(3, function ()
                                        scolded = false
                                    end)
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
            local d = GetDigimons(p)[1]
            local pixie = piximons[p]

            if secondPartSkipped[p] then
                d:pause()
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "Piximon", nil, "This digimon asked for your help.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "You can consult to your quest log for more information.", Transmission.SET, 3.5, true)
                tr:AddEnd(function ()
                    d:unpause()
                    ClearShops(d:getPos())
                    AddCompletedTutorial(p)
                end)
                tr:Start()
            elseif id == udg_TalkDigimonsId then
                thirdPart[p] = true
                d:pause()
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "Piximon", nil, "As you heard, he asked you to talk with other digimons.", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "You can also try interact with them and see what they want.", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "In that case you can consult to your quest log.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "But if you want you can just explore the city.", Transmission.SET, 3., true)
                tr:AddEnd(function ()
                    d:unpause()
                    ClearShops(d:getPos())
                    AddCompletedTutorial(p)
                end)
                tr:Start()
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
            tr:AddLine(pixie.root, nil, "Piximon", nil, "It seems that you picked a consummable item.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "This type of item goes to your backpack.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "To use that item open your backpack and select to who you wanna use it.", Transmission.SET, 3.5, true)
            local extra = nil
            if id == NET then
                netPicked[p] = true
                tr:AddLine(pixie.root, nil, "Piximon", nil, "The item you picked is a digimon net.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "You can use it to capture enemy digimon rookies to join them to your side.", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "Is easier capture them when are weak.", Transmission.SET, 3., true)
                tr:AddActions(function ()
                    ShowBank(p, true)
                end)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "Then you can look at them in your menu.", Transmission.SET, 3., true)
                extra = function ()
                    if tr:WasSkipped() then
                        ShowBank(p, true)
                    end
                    AddCompletedTutorial(p)
                end
            end
            tr:AddEnd(function ()
                AddCompletedTutorial(p)
                if extra then
                    extra()
                end
            end)
            tr:Start()
        elseif not netPicked[p] and id == NET then
            netPicked[p] = true
            local pixie = piximons[p]
            local tr = Transmission.create(Force(p))
            tr:AddLine(pixie.root, nil, "Piximon", nil, "This is a digimon net.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "It's used to capture enemy digimon rookies to join them to your side.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "I recommend weak them before trying to capture them.", Transmission.SET, 3., true)
            tr:AddActions(function ()
                ShowBank(p, true)
            end)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "Then you can look at them in your menu.", Transmission.SET, 3., true)
            tr:AddEnd(function ()
                if tr:WasSkipped() then
                    ShowBank(p, true)
                end
                AddCompletedTutorial(p)
            end)
            tr:Start()
        end
    end)

    -- Player picks a non-consummable item
    t = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetManipulatingUnit())
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
                    tr:AddLine(pixie.root, nil, "Piximon", nil, "This is an equipment.", Transmission.SET, 2., true)
                    tr:AddLine(pixie.root, nil, "Piximon", nil, "It helps you to increase your stats.", Transmission.SET, 3., true)
                    tr:AddLine(pixie.root, nil, "Piximon", nil, "But you are limited in how many you can have at the time.", Transmission.SET, 3.5, true)
                    tr:AddEnd(function ()
                        AddCompletedTutorial(p)
                        d:unpause()
                        ClearShops(d:getPos())
                    end)
                    tr:Start()
                end
            end
        end)
    end)

    -- Player enters in the shop or restaraunt
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Restaurant_Inner)
    TriggerRegisterEnterRectSimple(t, gg_rct_Shop_Inner)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
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
                tr:AddLine(pixie.root, nil, "Piximon", nil, "In the Digimon World are places where you can buy items from other digimons.", Transmission.SET, 4., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "That is if you have digibits of course.", Transmission.SET, 2., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "Those items can have special qualities.", Transmission.SET, 2., true)
                tr:AddEnd(function ()
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                tr:Start()
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
                            tr:AddLine(pixie.root, nil, "Piximon", nil, "Watch out!", Transmission.SET, 1., true)
                            tr:AddEnd(function ()
                                pixie:issueOrder(Orders.move, d2:getPos())
                                Timed.call(1., function ()
                                    tr = Transmission.create(Force(p))
                                    tr:AddLine(pixie.root, nil, "Piximon", nil, "An enemy!", Transmission.SET, 2., true)
                                    tr:AddEnd(function ()
                                        pixie:issueOrder(Orders.move, d:getPos())
                                        Timed.call(1., function ()
                                            tr = Transmission.create(Force(p))
                                            tr:AddLine(pixie.root, nil, "Piximon", nil, "If you feel confident you can try fight it.", Transmission.SET, 3., true)
                                            tr:AddLine(pixie.root, nil, "Piximon", nil, "But you could flee if you can't.", Transmission.SET, 2., true)
                                            tr:Start()
                                            canFollow[p] = true
                                        end)
                                    end)
                                    tr:Start()
                                end)
                            end)
                            tr:Start()
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
                tr:AddLine(pixie.root, nil, "Piximon", nil, "When you win you will get digibits and also experience if he has a similar level as yours", Transmission.SET, 4., true)
                tr:AddEnd(function ()
                    AddCompletedTutorial(p)
                end)
                tr:Start()
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
            tr:AddLine(pixie.root, nil, "Piximon", nil, "Your digimon died.", Transmission.SET, 3., true)
            tr:AddLine(pixie.root, nil, "Piximon", nil, "Don't worry, after a while it will be ready for action.", Transmission.SET, 3.5, true)
            tr:AddEnd(function ()
                AddCompletedTutorial(p)
            end)
            tr:Start()
        end
    end)

    -- Player enters in the hospital
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Hospital_Inner)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        if not hospitalEnter[p] then
            hospitalEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "Piximon", nil, "This is the Centauromon's hospital.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "You can come here to heal.", Transmission.SET, 2., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "And in case all your crew fall on combat, you will appear here.", Transmission.SET, 3.5, true)
                tr:AddEnd(function ()
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                tr:Start()
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
                            tr:AddLine(pixie.root, nil, "Piximon", nil, "Hey look!", Transmission.SET, 1., true)
                            tr:AddEnd(function ()
                                pixie:issueOrder(Orders.move, d2:getPos())
                                Timed.call(1., function ()
                                    tr = Transmission.create(Force(p))
                                    tr:AddLine(pixie.root, nil, "Piximon", nil, "This is one of the digimons that can transport to the Digimon World.", Transmission.SET, 4., true)
                                    tr:AddEnd(function ()
                                        pixie:issueOrder(Orders.move, d:getPos())
                                        Timed.call(1., function ()
                                            tr = Transmission.create(Force(p))
                                            if tutorialsDone[p] == MAX_TUTORIALS - 1 then
                                                tr:AddLine(pixie.root, nil, "Piximon", nil, "You can buy for their services if you are ready to explore.", Transmission.SET, 3., true)
                                            else
                                                tr:AddLine(pixie.root, nil, "Piximon", nil, "But I don't recommend that yet, you are not ready.", Transmission.SET, 3., true)
                                            end
                                            tr:AddEnd(function ()
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
                            tr:Start()
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
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        if not bankEnter[p] then
            bankEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "Piximon", nil, "Here at the bank you can look at the items you stored.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "And also the digimons you decided to save.", Transmission.SET, 2.5, true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "...", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "You know how to do it, right?", Transmission.SET, 2.5, true)
                tr:AddEnd(function ()
                    ShowBank(p, true)
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                tr:Start()
            end)
        end
    end)

    -- Player enters in the gym
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Gym_Lobby)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
        local p = d:getOwner()
        if not inTutorial[p] then
            return
        end

        if not gymEnter[p] then
            gymEnter[p] = true
            local pixie = piximons[p]
            d:pause()

            Timed.call(0.5, function ()
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "Piximon", nil, "So you decided to enter the gym.", Transmission.SET, 3., true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "Where you can fight with the strongest digimons (if you pay of course |cff00ff00;)|r ).", Transmission.SET, 4, true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "You can also have friendly fights with other adventurers.", Transmission.SET, 2.5, true)
                tr:AddEnd(function ()
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                tr:Start()
            end)
        end
    end)

    -- Player enters the train area
    t = CreateTrigger()
    TriggerRegisterEnterRectSimple(t, gg_rct_Train_Area)
    TriggerAddAction(t, function ()
        local d = Digimon.getInstance(GetEnteringUnit())
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
                local tr = Transmission.create(Force(p))
                tr:AddLine(pixie.root, nil, "Piximon", nil, "Maybe you noticed that you have a damage type and defense type.", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "Some damage types are better to certain armor types than others.", Transmission.SET, 3.5, true)
                tr:AddLine(pixie.root, nil, "Piximon", nil, "You can test it with this targets.", Transmission.SET, 2., true)
                tr:AddEnd(function ()
                    canFollow[p] = true
                    AddCompletedTutorial(p)
                    d:unpause()
                    ClearShops(d:getPos())
                end)
                tr:Start()
            end)
        end
    end)
end)
Debug.endFile()