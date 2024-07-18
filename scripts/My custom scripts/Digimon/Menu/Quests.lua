Debug.beginFile("Quests")
OnInit("Quests", function ()
    local FrameList = Require "FrameList" ---@type FrameList
    Require "GlobalRemap"
    Require "FrameLoader"
    Require "ErrorMessage"
    Require "Timed"
    Require "AbilityUtils"
    Require "Menu"
    Require "SyncedTable"
    Require "AddHook"
    local Color = Require "Color" ---@type Color
    Require "EventListener"

    local YELLOW = Color.new(255, 255, 0)
    local GREEN = Color.new(0, 255, 255)
    local WHITE = Color.new(255, 255, 255)
    local QUEST_MARK = "Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl"
    local QUEST_MARK_DONE = "Objects\\RandomObject\\RandomObject.mdl"
    local MAX_QUESTS = udg_MAX_QUESTS
    local DO_QUEST_AGAIN_DELAY = udg_DO_QUEST_AGAIN_DELAY

    local NoRepeat = {} ---@type table<player, table<trigger, boolean>>
    local QuestTrigger = SyncedTable.create() ---@type table<thread, trigger>
    local onQuestAdded = EventListener.create()

    local QuestButton = nil ---@type framehandle
    local BackdropQuestButton = nil ---@type framehandle
    local QuestButtonSprite = nil ---@type framehandle
    local QuestMenu = nil ---@type framehandle
    local QuestInformation = nil ---@type framehandle
    local QuestText = nil ---@type framehandle
    local Quests = nil ---@type framehandle
    local QuestInformationName = nil ---@type framehandle
    local QuestInformationDescription = nil ---@type framehandle
    local QuestInformationProgress = nil ---@type framehandle
    local QuestOptionT = {} ---@type framehandle[]
    local QuestOptionText = {} ---@type framehandle[]

    local QuestList = nil ---@type FrameList
    local Origin = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local LocalPlayer = GetLocalPlayer()
    local PressedQuest = -1

    ---@class QuestTemplate
    ---@field name string
    ---@field description string
    ---@field id integer
    ---@field level integer
    ---@field onlyOnce boolean
    ---@field maxProgress integer
    ---@field questMark effect?
    ---@field questMarkDone effect?
    ---@field counter texttag?
    ---@field isRequirement boolean
    ---@field requirements QuestTemplate[]?

    local QuestTemplates = {} ---@type table<integer, QuestTemplate>

    ---@class Quest
    ---@field name string
    ---@field description string
    ---@field owner player
    ---@field id integer
    ---@field level integer
    ---@field progress integer
    ---@field completed boolean

    local PlayerQuests = {} ---@type table<player, Quest[]>

    local function UpdateMenu()
        if PressedQuest < 0 or PressedQuest > MAX_QUESTS then
            BlzFrameSetVisible(QuestInformation, false)
        else
            local quest = PlayerQuests[LocalPlayer][PressedQuest]
            BlzFrameSetText(QuestInformationName, "|cffFFCC00" .. quest.name .. "|r")

            local description = quest.description
            if QuestTemplates[quest.id].requirements then
                for _, req in ipairs(QuestTemplates[quest.id].requirements) do
                    description = description
                                    .. "\n |cff" .. (PlayerQuests[LocalPlayer][req.id].completed and "888888" or "ffffff") .. "- "
                                    .. req.description
                                    .. (QuestTemplates[req.id].maxProgress > 1 and ("(" .. PlayerQuests[LocalPlayer][req.id].progress .. "/" .. QuestTemplates[req.id].maxProgress .. ")") or "")
                                    .. "|r"
                end
            end
            BlzFrameSetText(QuestInformationDescription, description)

            local max = QuestTemplates[quest.id].maxProgress
            if max > 1 then
                BlzFrameSetVisible(QuestInformationProgress, true)
                if quest.progress < max then
                    BlzFrameSetText(QuestInformationProgress, quest.progress .. "/" .. max)
                else
                    BlzFrameSetText(QuestInformationProgress, "|cff00ff00" .. quest.progress .. "/" .. max .. "|r")
                end
            else
                BlzFrameSetVisible(QuestInformationProgress, false)
            end
        end
        for i, q in pairs(PlayerQuests[LocalPlayer]) do
            if not QuestTemplates[i].isRequirement then
                local progress = "In progress"
                local max = QuestTemplates[q.id].maxProgress
                if max > 1 then
                    if q.progress < max then
                        progress = progress .. " " .. q.progress .. "/" .. max
                    else
                        progress = progress .. " |cff00ff00" .. q.progress .. "/" .. max .. "|r"
                    end
                end
                BlzFrameSetText(QuestOptionText[i], "|cffFFCC00" .. q.name .. "|r" .. (q.level > 0 and (" - Level " .. q.level) or "") .. "\n" .. progress)
            end
        end
    end

    local function ShowInformation(i)
        if GetTriggerPlayer() == LocalPlayer then
            if PressedQuest ~= i then
                BlzFrameSetVisible(QuestInformation, true)
                PressedQuest = i
                UpdateMenu()
            else
                PressedQuest = -1
                BlzFrameSetVisible(QuestInformation, false)
            end
        end
    end

    local function ShowMenu()
        if GetTriggerPlayer() == LocalPlayer then
            if BlzFrameIsVisible(QuestMenu) then
                RemoveButtonFromEscStack(QuestButton)
            else
                AddButtonToEscStack(QuestButton)
            end
            BlzFrameSetVisible(QuestMenu, not BlzFrameIsVisible(QuestMenu))
            BlzFrameSetVisible(QuestInformation, false)
            BlzFrameSetEnable(QuestButton, false)
            BlzFrameSetEnable(QuestButton, true)
            UpdateMenu()
        end
    end

    local function InitFrames()
        BlzLoadTOCFile("war3mapImported\\QuestsTOC.toc")

        QuestButton = BlzCreateFrame("IconButtonTemplate", Origin, 0, 0)
        BlzFrameSetAbsPoint(QuestButton, FRAMEPOINT_TOPLEFT, 0.480000, 0.180000)
        BlzFrameSetAbsPoint(QuestButton, FRAMEPOINT_BOTTOMRIGHT, 0.515000, 0.145000)
        local t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, QuestButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ShowMenu)
        BlzFrameSetVisible(QuestButton, false)
        AddFrameToMenu(QuestButton)
        AddDefaultTooltip(QuestButton, "Quest Log", "Look at the progress of your accepted quests.")

        BackdropQuestButton = BlzCreateFrameByType("BACKDROP", "BackdropQuestButton", QuestButton, "", 0)
        BlzFrameSetAllPoints(BackdropQuestButton, QuestButton)
        BlzFrameSetTexture(BackdropQuestButton, "ReplaceableTextures\\CommandButtons\\BTNQuestIcon.blp", 0, true)

        QuestButtonSprite =  BlzCreateFrameByType("SPRITE", "QuestButtonSprite", QuestButton, "", 0)
        BlzFrameSetAllPoints(QuestButtonSprite, QuestButton)
        BlzFrameSetModel(QuestButtonSprite, "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl", 0)
        BlzFrameSetScale(QuestButtonSprite, BlzFrameGetWidth(QuestButtonSprite)/0.039)
        BlzFrameSetVisible(QuestButtonSprite, false)

        QuestMenu = BlzCreateFrame("QuestButtonBaseTemplate", Origin, 0, 0)
        BlzFrameSetAbsPoint(QuestMenu, FRAMEPOINT_TOPLEFT, 0.690000, 0.440000)
        BlzFrameSetAbsPoint(QuestMenu, FRAMEPOINT_BOTTOMRIGHT, 0.880000, 0.200000)
        BlzFrameSetVisible(QuestMenu, false)
        AddFrameToMenu(QuestMenu)

        QuestInformation = BlzCreateFrame("CheckListBox", QuestMenu, 0, 0)
        BlzFrameSetPoint(QuestInformation, FRAMEPOINT_TOPLEFT, QuestMenu, FRAMEPOINT_TOPLEFT, -0.19000, 0.00000)
        BlzFrameSetPoint(QuestInformation, FRAMEPOINT_BOTTOMRIGHT, QuestMenu, FRAMEPOINT_BOTTOMLEFT, 0.00000, 0.00000)
        BlzFrameSetVisible(QuestInformation, false)

        QuestText = BlzCreateFrameByType("TEXT", "name", QuestMenu, "", 0)
        BlzFrameSetPoint(QuestText, FRAMEPOINT_TOPLEFT, QuestMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(QuestText, FRAMEPOINT_BOTTOMRIGHT, QuestMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.20500)
        BlzFrameSetText(QuestText, "|cffFFCC00Quest Log|r")
        BlzFrameSetEnable(QuestText, false)
        BlzFrameSetScale(QuestText, 1)
        BlzFrameSetTextAlignment(QuestText, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        Quests = BlzCreateFrameByType("BACKDROP", "BACKDROP", QuestMenu, "", 1)
        BlzFrameSetPoint(Quests, FRAMEPOINT_TOPLEFT, QuestMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(Quests, FRAMEPOINT_BOTTOMRIGHT, QuestMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetTexture(Quests, "war3mapImported\\EmptyBTN.blp", 0, true)

        QuestInformationName = BlzCreateFrameByType("TEXT", "name", QuestInformation, "", 0)
        BlzFrameSetPoint(QuestInformationName, FRAMEPOINT_TOPLEFT, QuestInformation, FRAMEPOINT_TOPLEFT, 0.015000, -0.015000)
        BlzFrameSetPoint(QuestInformationName, FRAMEPOINT_BOTTOMRIGHT, QuestInformation, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.20500)
        BlzFrameSetText(QuestInformationName, "|cffFFCC00QuestName|r")
        BlzFrameSetEnable(QuestInformationName, false)
        BlzFrameSetScale(QuestInformationName, 1.00)
        BlzFrameSetTextAlignment(QuestInformationName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        QuestInformationDescription = BlzCreateFrameByType("TEXTAREA", "name", QuestInformation, "", 0)
        BlzFrameSetPoint(QuestInformationDescription, FRAMEPOINT_TOPLEFT, QuestInformation, FRAMEPOINT_TOPLEFT, 0.015000, -0.035000)
        BlzFrameSetPoint(QuestInformationDescription, FRAMEPOINT_BOTTOMRIGHT, QuestInformation, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.035000)
        BlzFrameSetText(QuestInformationDescription, "|cffffffffDescription|r")

        QuestInformationProgress = BlzCreateFrameByType("TEXT", "name", QuestInformation, "", 0)
        BlzFrameSetPoint(QuestInformationProgress, FRAMEPOINT_TOPLEFT, QuestInformation, FRAMEPOINT_TOPLEFT, 0.11000, -0.20500)
        BlzFrameSetPoint(QuestInformationProgress, FRAMEPOINT_BOTTOMRIGHT, QuestInformation, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.010000)
        BlzFrameSetText(QuestInformationProgress, "100/100")
        BlzFrameSetEnable(QuestInformationProgress, false)
        BlzFrameSetScale(QuestInformationProgress, 1.)
        BlzFrameSetTextAlignment(QuestInformationProgress, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)

        for i = 0, MAX_QUESTS do
            QuestOptionT[i] = BlzCreateFrame("ScriptDialogButton", Quests, 0, 0)
            BlzFrameSetPoint(QuestOptionT[i], FRAMEPOINT_TOPLEFT, Quests, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetSize(QuestOptionT[i], 0.15300, 0.04000)
            BlzFrameSetText(QuestOptionT[i], "")
            BlzFrameSetScale(QuestOptionT[i], 1.00)
            BlzFrameSetEnable(QuestOptionT[i], false)
            BlzFrameSetVisible(QuestOptionT[i], false)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, QuestOptionT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () ShowInformation(i) end)

            QuestOptionText[i] = BlzCreateFrameByType("TEXT", "name", QuestOptionT[i], "", 0)
            BlzFrameSetPoint(QuestOptionText[i], FRAMEPOINT_TOPLEFT, QuestOptionT[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
            BlzFrameSetPoint(QuestOptionText[i], FRAMEPOINT_BOTTOMRIGHT, QuestOptionT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.0050000)
            BlzFrameSetText(QuestOptionText[i], "Quest " .. i .. "\nQuestStatus")
            BlzFrameSetEnable(QuestOptionText[i], false)
            BlzFrameSetScale(QuestOptionText[i], 1.00)
            BlzFrameSetTextAlignment(QuestOptionText[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
        end

        QuestList = FrameList.create(false, Quests)
        BlzFrameSetPoint(QuestList.Frame, FRAMEPOINT_TOPLEFT, Quests, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
        BlzFrameSetPoint(QuestList.Frame, FRAMEPOINT_TOPRIGHT, Quests, FRAMEPOINT_TOPRIGHT, -0.0050000, 0.0050000)
        QuestList:setSize(BlzFrameGetWidth(QuestList.Frame), BlzFrameGetHeight(QuestList.Frame) + 0.05)
    end

    FrameLoaderAdd(InitFrames)

    OnInit.final(function ()
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            PlayerQuests[Player(i)] = {}
            NoRepeat[Player(i)] = __jarray(false)
        end
    end)

    local setRequirements = false
    local setRequirementsToQuestId = -1
    local lastRequirements = {} ---@type QuestTemplate[]
    local savedFields

    ---@param p player
    ---@param id integer
    local function AddQuest(p, id)
        if QuestTemplates[id].isRequirement then
            error("You can't manually add a requirement to a player, id: " .. id)
        end
        if PlayerQuests[p][id] then
            if PlayerQuests[p][id].completed then
                ErrorMessage("You already completed this quest.", p)
            else
                ErrorMessage("You already have this quest.", p)
            end
            return
        end
        PlayerQuests[p][id] = {
            name = QuestTemplates[id].name,
            description = QuestTemplates[id].description,
            owner = p,
            id = id,
            level = QuestTemplates[id].level,
            completed = false,
            progress = 0
        }
        if QuestTemplates[id].requirements then
            for _, v in ipairs(QuestTemplates[id].requirements) do
                PlayerQuests[p][v.id] = {
                    name = v.name,
                    description = v.description,
                    owner = p,
                    id = v.id,
                    level = v.level,
                    completed = false,
                    progress = 0
                }
            end
        end
        if p == LocalPlayer then
            BlzFrameSetEnable(QuestOptionT[id], true)
            BlzFrameSetVisible(QuestOptionT[id], true)
            QuestList:add(QuestOptionT[id])
            UpdateMenu()
            StartSound(bj_questDiscoveredSound)
            BlzFrameSetVisible(QuestButton, true)
            if not BlzFrameIsVisible(QuestMenu) then
                DisplayTextToPlayer(p, 0, 0, "|cffFFCC00NEW QUEST:|r " .. PlayerQuests[p][id].name)
                BlzFrameSetVisible(QuestButtonSprite, true)
                BlzFrameSetSpriteAnimate(QuestButtonSprite, 1, 0)
            end
            if QuestTemplates[id].questMark then
                BlzSetSpecialEffectAlpha(QuestTemplates[id].questMark, 0)
                BlzSetSpecialEffectAlpha(QuestTemplates[id].questMarkDone, 255)
                BlzSetSpecialEffectColor(QuestTemplates[id].questMarkDone, WHITE)
            end
        end
        Timed.call(8., function ()
            if p == LocalPlayer then
                BlzFrameSetVisible(QuestButtonSprite, false)
            end
        end)
        onQuestAdded:run(p, id)
    end

    ---@param name string
    ---@param description string
    ---@param id integer
    ---@param level integer
    ---@param onlyOnce boolean
    ---@param maxProgress integer
    ---@param petitioner unit
    local function DefineQuestTemplate(name, description, id, level, onlyOnce, maxProgress, petitioner)
        if id == -1 then
            error("The quest id wasn't set.")
        end
        if QuestTemplates[id] then
            error("You are repiting a quest id: " .. QuestTemplates[id].name .. " and " .. name)
        end
        QuestTemplates[id] = {name = name, description = description, level = level, id = id, onlyOnce = onlyOnce, maxProgress = maxProgress}
        if petitioner then
            local questMark = AddSpecialEffect(QUEST_MARK, GetUnitX(petitioner), GetUnitY(petitioner))
            if onlyOnce then
                BlzSetSpecialEffectColor(questMark, YELLOW)
            else
                BlzSetSpecialEffectColor(questMark, GREEN)
            end
            BlzSetSpecialEffectZ(questMark, GetUnitZ(petitioner, true) + 175)
            QuestTemplates[id].questMark = questMark
            QuestTemplates[id].counter = CreateTextTagUnitBJ("", petitioner, 50., 10., 100., 100., 100., 0.)

            local questMarkDone = AddSpecialEffect(QUEST_MARK_DONE, GetUnitX(petitioner), GetUnitY(petitioner))
            BlzSetSpecialEffectZ(questMarkDone, GetUnitZ(petitioner, true) + 175)
            BlzSetSpecialEffectAlpha(questMarkDone, 0)
            QuestTemplates[id].questMarkDone = questMarkDone
        end
        if setRequirements then
            QuestTemplates[id].isRequirement = true
            table.insert(lastRequirements, QuestTemplates[id])
        else
            QuestTemplates[id].isRequirement = false
            if setRequirementsToQuestId ~= -1 then
                QuestTemplates[id].requirements = lastRequirements

                lastRequirements = {}
                setRequirementsToQuestId = -1
            end
        end
    end

    ---@param p player
    ---@param id integer
    local function SetQuestCompleted(p, id)
        if not PlayerQuests[p][id] then
            return
        end
        if not QuestTemplates[id].onlyOnce and not QuestTemplates[id].isRequirement then
            local counter = QuestTemplates[id].counter
            local remain = DO_QUEST_AGAIN_DELAY
            if counter then
                if p == LocalPlayer then
                    SetTextTagTextBJ(counter, "Comeback in: " .. DO_QUEST_AGAIN_DELAY, 10.)
                end
            end
            Timed.echo(1., DO_QUEST_AGAIN_DELAY, function ()
                remain = remain - 1
                if counter then
                    if p == LocalPlayer then
                        SetTextTagTextBJ(counter, "Comeback in: " .. remain, 10.)
                    end
                end
            end, function ()
                PlayerQuests[p][id] = nil
                if QuestTemplates[id].requirements then
                    for _, v in ipairs(QuestTemplates[id].requirements) do
                        PlayerQuests[p][v.id] = nil
                    end
                end
                if p == LocalPlayer then
                    if QuestTemplates[id].questMarkDone then
                        BlzSetSpecialEffectAlpha(QuestTemplates[id].questMark, 255)
                        BlzPlaySpecialEffect(QuestTemplates[id].questMark, ANIM_TYPE_STAND)
                        BlzSetSpecialEffectColor(QuestTemplates[id].questMark, GREEN)
                    end
                    if counter then
                        SetTextTagTextBJ(counter, "", 10.)
                    end
                end
            end)
        end
        PlayerQuests[p][id].completed = true
        if p == LocalPlayer then
            if not QuestTemplates[id].isRequirement then
                QuestList:remove(QuestOptionT[id])
                BlzFrameSetEnable(QuestOptionT[id], false)
                BlzFrameSetVisible(QuestOptionT[id], false)
                PressedQuest = -1
                StartSound(bj_questCompletedSound)
                if not BlzFrameIsVisible(QuestMenu) then
                    DisplayTextToPlayer(p, 0, 0, "|cffFFCC00QUEST COMPLETED:|r |cff00ff00" .. PlayerQuests[p][id].name .. "|r")
                end
                if QuestTemplates[id].questMark then
                    BlzPlaySpecialEffect(QuestTemplates[id].questMarkDone, ANIM_TYPE_DEATH)
                end
            end
            UpdateMenu()
        end
        Timed.call(0.667, function ()
            if p == LocalPlayer and QuestTemplates[id].questMark then
                BlzSetSpecialEffectAlpha(QuestTemplates[id].questMarkDone, 0)
            end
        end)
    end

    ---@param p player
    ---@return integer[] ids, integer[] progresses, boolean[] isCompleted
    function GetQuestsData(p)
        local ids, progresses, isCompleted = {}, {}, {} ---@type integer[], integer[], boolean[]

        for i, q in pairs(PlayerQuests[p]) do
            table.insert(ids, i)
            table.insert(progresses, q.progress)
            table.insert(isCompleted, q.completed)
        end

        return ids, progresses, isCompleted
    end

    ---@param id integer
    ---@return integer
    function GetQuestMaxProgress(id)
        if not QuestTemplates[id] then
            return 0
        end
        return QuestTemplates[id].maxProgress
    end

    ---@overload fun(p: player)
    ---@param p player
    ---@param ids integer[]
    ---@param progresses integer[]
    ---@param isCompleted boolean[]
    function SetQuestsData(p, ids, progresses, isCompleted)
        local have = __jarray(false)
        if ids then
            for i = 1, #ids do
                local id = ids[i]
                if QuestTemplates[id] then
                    PlayerQuests[p][id] = {
                        name = QuestTemplates[id].name,
                        description = QuestTemplates[id].description,
                        owner = p,
                        id = id,
                        level = QuestTemplates[id].level,
                        completed = isCompleted[i],
                        progress = progresses[i]
                    }
                    if p == LocalPlayer then
                        if not QuestTemplates[id].isRequirement then
                            if isCompleted[i] then
                                QuestList:remove(QuestOptionT[id])
                            else
                                BlzFrameSetEnable(QuestOptionT[id], true)
                                BlzFrameSetVisible(QuestOptionT[id], true)
                                QuestList:add(QuestOptionT[id])
                            end
                        end
                        if QuestTemplates[id].questMark then
                            BlzSetSpecialEffectAlpha(QuestTemplates[id].questMark, 0)
                        end
                        UpdateMenu()
                        BlzFrameSetVisible(QuestButton, true)
                    end
                    have[id] = true
                end
            end
        else
            if p == LocalPlayer then
                while QuestList:remove() do end
            end
        end
        for i = 0, MAX_QUESTS do
            if not have[i] and QuestTemplates[i] then
                PlayerQuests[p][i] = nil
                if p == LocalPlayer then
                    if QuestTemplates[i].questMark then
                        BlzSetSpecialEffectAlpha(QuestTemplates[i].questMark, 255)
                    end
                end
            end
        end
    end

    ---@param id integer
    ---@return string
    function GetQuestName(id)
        if not QuestTemplates[id] then
            return ""
        end
        return QuestTemplates[id].name
    end

    ---@param id integer
    ---@return boolean
    function IsQuestARequirement(id)
        return QuestTemplates[id] and QuestTemplates[id].isRequirement
    end

    ---@param func fun(p:player, id: integer)
    function OnQuestAdded(func)
        onQuestAdded:register(func)
    end

    OnInit.trig(function ()
        udg_QuestDefine = CreateTrigger()
        TriggerAddAction(udg_QuestDefine, function ()
            if udg_QuestId > MAX_QUESTS then
                error("You are asigning an id greater than the max to the quests: " .. udg_QuestName)
            end
            if udg_QuestMaxProgress <= 0 then
                error("You are asigning a max progress lesser than 1 to the quest: " .. udg_QuestName)
            end
            DefineQuestTemplate(udg_QuestName, udg_QuestDescription, udg_QuestId, udg_QuestLevel, udg_QuestOnlyOnce, udg_QuestMaxProgress, udg_QuestPetitioner)
            udg_QuestName = ""
            udg_QuestDescription = ""
            udg_QuestId = -1
            udg_QuestLevel = 0
            udg_QuestOnlyOnce = false
            udg_QuestMaxProgress = 1
            udg_QuestPetitioner = nil
        end)

        udg_QuestAdd = CreateTrigger()
        TriggerAddAction(udg_QuestAdd, function ()
            AddQuest(udg_QuestPlayer, udg_QuestId)
        end)

        udg_QuestSetCompleted = CreateTrigger()
        TriggerAddAction(udg_QuestSetCompleted, function ()
            SetQuestCompleted(udg_QuestPlayer, udg_QuestId)
        end)

        udg_QuestCanReturn = CreateTrigger()
        TriggerAddAction(udg_QuestCanReturn, function ()
            local id = udg_QuestId
            if udg_QuestPlayer == LocalPlayer and QuestTemplates[id].questMarkDone then
                if QuestTemplates[id].onlyOnce then
                    BlzSetSpecialEffectColor(QuestTemplates[id].questMarkDone, YELLOW)
                else
                    BlzSetSpecialEffectColor(QuestTemplates[id].questMarkDone, GREEN)
                end
            end
        end)
    end)

    local questPlayer = SyncedTable.create() ---@type table<thread, player>
    local lastQuestPlayer = nil ---@type player
    local questId = SyncedTable.create() ---@type table<thread, integer>
    local lastQuestId = nil ---@type integer

    GlobalRemap("udg_QuestPlayer", function ()
        local thr = coroutine.running()
        if not thr then
            return nil
        end
        if not questPlayer[thr] then
            questPlayer[thr] = lastQuestPlayer
        end
        return questPlayer[thr]
    end, function (value)
        local thr = coroutine.running()
        if not thr then
            return
        end
        questPlayer[thr] = value
        lastQuestPlayer = value
    end)

    GlobalRemap("udg_QuestId", function ()
        local thr = coroutine.running()
        if not thr then
            return 0
        end
        if not questId[thr] then
            questId[thr] = lastQuestId
        end
        return questId[thr]
    end, function (value)
        local thr = coroutine.running()
        if not thr then
            return
        end
        questId[thr] = value
        lastQuestId = value
    end)

    OnInit.final(function ()
        ---@param func string
        local function hook(func)
            local oldFunc
            oldFunc = AddHook(func, function (...)
                lastQuestPlayer = udg_QuestPlayer
                lastQuestId = udg_QuestId
                return oldFunc(...)
            end)
        end

        hook("ForForce")
        hook("ForGroup")
        hook("TriggerEvaluate")
        hook("TriggerExecute")
    end)

    Timed.echo(60., function ()
        for k, _ in pairs(questPlayer) do
            if coroutine.status(k) == "dead" then
                questPlayer[k] = nil
            end
        end
        for k, _ in pairs(questId) do
            if coroutine.status(k) == "dead" then
                questId[k] = nil
            end
        end
        for k, _ in pairs(QuestTrigger) do
            if coroutine.status(k) == "dead" then
                QuestTrigger[k] = nil
            end
        end
    end)

    GlobalRemap("udg_PlayerIsOnQuest", function ()
        if not udg_QuestPlayer or not PlayerQuests[udg_QuestPlayer] then
            return false
        end
        return PlayerQuests[udg_QuestPlayer][udg_QuestId] ~= nil
    end)
    GlobalRemap("udg_QuestIsCompleted", function ()
        return udg_PlayerIsOnQuest and PlayerQuests[udg_QuestPlayer][udg_QuestId].completed
    end)
    GlobalRemap("udg_QuestProgress", function ()
        if not udg_PlayerIsOnQuest then
            return 0
        end
        return PlayerQuests[udg_QuestPlayer][udg_QuestId].progress
    end, function (value)
        if not udg_PlayerIsOnQuest then
            return
        end
        PlayerQuests[udg_QuestPlayer][udg_QuestId].progress = value
        if udg_QuestPlayer == LocalPlayer then
            UpdateMenu()
        end
    end)
    GlobalRemap("udg_QuestNoRepeat", nil, function (value)
        local trig = QuestTrigger[coroutine.running()]
        if not trig then
            trig = GetTriggeringTrigger()
            QuestTrigger[coroutine.running()] = trig
        end
        if value then
            if not NoRepeat[udg_QuestPlayer][trig] then
                NoRepeat[udg_QuestPlayer][trig] = true
            else
                coroutine.yield()
            end
        else
            NoRepeat[udg_QuestPlayer][trig] = false
        end
    end)
    DestroyForce(udg_QuestForce)
    GlobalRemap("udg_QuestForce", function ()
        return bj_FORCE_PLAYER[GetPlayerId(udg_QuestPlayer)]
    end)
    GlobalRemap("udg_QuestSetRequirements", nil, function (value)
        if value then
            if setRequirements then
                error("You can't set to true to \"QuestSetRequirements\" 2 times in a row")
            end
            setRequirements = true
            setRequirementsToQuestId = udg_QuestId
            savedFields = {udg_QuestName, udg_QuestDescription, udg_QuestLevel, udg_QuestOnlyOnce, udg_QuestMaxProgress, udg_QuestPetitioner}
            udg_QuestName = ""
            udg_QuestDescription = ""
            udg_QuestId = -1
            udg_QuestLevel = 0
            udg_QuestOnlyOnce = false
            udg_QuestMaxProgress = 1
            udg_QuestPetitioner = nil
        else
            if not setRequirements then
                error("You can't set to false to \"QuestSetRequirements\" 2 times in a row")
            end
            setRequirements = false
            udg_QuestName = savedFields[1]
            udg_QuestDescription = savedFields[2]
            udg_QuestId = setRequirementsToQuestId
            udg_QuestLevel = savedFields[3]
            udg_QuestOnlyOnce = savedFields[4]
            udg_QuestMaxProgress = savedFields[5]
            udg_QuestPetitioner = savedFields[6]
        end
    end)

end)
Debug.endFile()