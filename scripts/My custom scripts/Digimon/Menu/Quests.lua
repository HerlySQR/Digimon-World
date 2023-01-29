Debug.beginFile("Quests")
OnInit(function ()
    local FrameList = Require "FrameList" ---@type FrameList
    Require "GlobalRemap"
    Require "FrameLoader"

    local MAX_MISSIONS = 99

    local QuestButton = nil ---@type framehandle
    local BackdropQuestButton = nil ---@type framehandle
    local QuestMenu = nil ---@type framehandle
    local QuestInformation = nil ---@type framehandle
    local QuestText = nil ---@type framehandle
    local Quests = nil ---@type framehandle
    local QuestInformationName = nil ---@type framehandle
    local QuestInformationDescription = nil ---@type framehandle
    local QuestOptionT = {} ---@type framehandle[]
    local QuestOptionText = {} ---@type framehandle[]

    local QuestList = nil ---@type FrameList
    local Origin = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local LocalPlayer = GetLocalPlayer()
    local PressedQuest = 0

    local function UpdateMenu()
        
    end

    local function ShowInformation(i)
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(QuestInformation, true)
            PressedQuest = i
            UpdateMenu()
        end
    end

    local function ShowMenu()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetVisible(QuestMenu, true)
        end
    end

    local function InitFrames()
        BlzLoadTOCFile("war3mapImported\\QuestsTOC.toc")

        QuestButton = BlzCreateFrame("IconButtonTemplate", Origin, 0, 0)
        BlzFrameSetAbsPoint(QuestButton, FRAMEPOINT_TOPLEFT, 0.700000, 0.200000)
        BlzFrameSetAbsPoint(QuestButton, FRAMEPOINT_BOTTOMRIGHT, 0.740000, 0.160000)
        local t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, QuestButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ShowMenu)

        BackdropQuestButton = BlzCreateFrameByType("BACKDROP", "BackdropQuestButton", QuestButton, "", 0)
        BlzFrameSetAllPoints(BackdropQuestButton, QuestButton)
        BlzFrameSetTexture(BackdropQuestButton, "ReplaceableTextures\\CommandButtons\\BTNBansheeMaster.blp", 0, true)

        QuestMenu = BlzCreateFrame("QuestButtonBaseTemplate", Origin, 0, 0)
        BlzFrameSetAbsPoint(QuestMenu, FRAMEPOINT_TOPLEFT, 0.740000, 0.440000)
        BlzFrameSetAbsPoint(QuestMenu, FRAMEPOINT_BOTTOMRIGHT, 0.930000, 0.200000)

        QuestInformation = BlzCreateFrame("CheckListBox", Origin, 0, 0)
        BlzFrameSetAbsPoint(QuestInformation, FRAMEPOINT_TOPLEFT, 0.550000, 0.440000)
        BlzFrameSetAbsPoint(QuestInformation, FRAMEPOINT_BOTTOMRIGHT, 0.740000, 0.200000)

        QuestText = BlzCreateFrameByType("TEXT", "name", QuestMenu, "", 0)
        BlzFrameSetPoint(QuestText, FRAMEPOINT_TOPLEFT, QuestMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(QuestText, FRAMEPOINT_BOTTOMRIGHT, QuestMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.21000)
        BlzFrameSetText(QuestText, "|cffFFCC00Quest Log|r")
        BlzFrameSetEnable(QuestText, false)
        BlzFrameSetScale(QuestText, 1.14)
        BlzFrameSetTextAlignment(QuestText, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        Quests = BlzCreateFrameByType("BACKDROP", "BACKDROP", QuestMenu, "", 1)
        BlzFrameSetPoint(Quests, FRAMEPOINT_TOPLEFT, QuestMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(Quests, FRAMEPOINT_BOTTOMRIGHT, QuestMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetTexture(Quests, "CustomFrame.png", 0, true)

        QuestInformationName = BlzCreateFrameByType("TEXT", "name", QuestInformation, "", 0)
        BlzFrameSetPoint(QuestInformationName, FRAMEPOINT_TOPLEFT, QuestInformation, FRAMEPOINT_TOPLEFT, 0.015000, -0.015000)
        BlzFrameSetPoint(QuestInformationName, FRAMEPOINT_BOTTOMRIGHT, QuestInformation, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.20500)
        BlzFrameSetText(QuestInformationName, "|cffFFCC00QuestName|r")
        BlzFrameSetEnable(QuestInformationName, false)
        BlzFrameSetScale(QuestInformationName, 1.00)
        BlzFrameSetTextAlignment(QuestInformationName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        QuestInformationDescription = BlzCreateFrameByType("TEXTAREA", "name", QuestInformation, "", 0)
        BlzFrameSetPoint(QuestInformationDescription, FRAMEPOINT_TOPLEFT, QuestInformation, FRAMEPOINT_TOPLEFT, 0.015000, -0.035000)
        BlzFrameSetPoint(QuestInformationDescription, FRAMEPOINT_BOTTOMRIGHT, QuestInformation, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.015000)
        BlzFrameSetText(QuestInformationDescription, "|cffffffffDescription|r")

        for i = 0, MAX_MISSIONS - 1 do
            QuestOptionT[i] = BlzCreateFrame("ScriptDialogButton", Quests, 0, 0)
            BlzFrameSetPoint(QuestOptionT[i], FRAMEPOINT_TOPLEFT, Quests, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetPoint(QuestOptionT[i], FRAMEPOINT_BOTTOMRIGHT, Quests, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.16000)
            BlzFrameSetText(QuestOptionT[i], "|cffFCD20D|r")
            BlzFrameSetScale(QuestOptionT[i], 1.00)
            BlzFrameSetVisible(QuestOptionT[i], false)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, QuestOptionT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () ShowInformation(i) end)

            QuestOptionText[i] = BlzCreateFrameByType("TEXT", "name", QuestOptionT[i], "", 0)
            BlzFrameSetPoint(QuestOptionText[i], FRAMEPOINT_TOPLEFT, QuestOptionT[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
            BlzFrameSetPoint(QuestOptionText[i], FRAMEPOINT_BOTTOMRIGHT, QuestOptionT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.0050000)
            BlzFrameSetText(QuestOptionText[i], "QuestName\nQuestStatus")
            BlzFrameSetEnable(QuestOptionText[i], false)
            BlzFrameSetScale(QuestOptionText[i], 1.00)
            BlzFrameSetTextAlignment(QuestOptionText[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
        end

        QuestList = FrameList.create(false, Quests)
        BlzFrameSetPoint(QuestList.Frame, FRAMEPOINT_TOPLEFT, Quests, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
        BlzFrameSetPoint(QuestList.Frame, FRAMEPOINT_BOTTOMRIGHT, Quests, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
    end

    InitFrames()
    FrameLoaderAdd(InitFrames)

    ---@class QuestTemplate
    ---@field name string
    ---@field id integer

    ---@class Quest
    ---@field name string
    ---@field owner player
    ---@field id integer
    ---@field completed boolean

    local PlayerQuests = {} ---@type table<player, Quest[]>

    OnInit.final(function ()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            PlayerQuests[GetEnumPlayer()] = {}
        end)
        if LocalPlayer == Player(0) then
            QuestList:add(QuestOptionT[0])
            QuestList:add(QuestOptionT[1])
        end
        if LocalPlayer == Player(1) then
            QuestList:add(QuestOptionT[3])
            QuestList:add(QuestOptionT[4])
            QuestList:add(QuestOptionT[5])
        end
    end)

    ---@param p player
    ---@param q QuestTemplate
    local function AddQuest(p, q)
        PlayerQuests[p][q.id] = {
            name = q.name,
            owner = p,
            id = q.id,
            completed = false
        }
        if p == LocalPlayer then
            UpdateMenu()
        end
    end

end)
Debug.endFile()