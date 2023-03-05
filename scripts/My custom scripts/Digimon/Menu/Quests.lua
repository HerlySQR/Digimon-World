Debug.beginFile("Quests")
OnInit("Quests", function ()
    local FrameList = Require "FrameList" ---@type FrameList
    Require "GlobalRemap"
    Require "FrameLoader"
    Require "ErrorMessage"
    Require "Timed"
    Require "AbilityUtils"
    local BitSet = Require "BitSet" ---@type BitSet

    local QuestButton = nil ---@type framehandle
    local BackdropQuestButton = nil ---@type framehandle
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
    local PressedQuest = 0
    local QUEST_MARK = "Abilities\\Spells\\Other\\TalkToMe\\TalkToMe.mdl"
    local MAX_UNIQUE_QUESTS = udg_MAX_UNIQUE_QUESTS - 1

    ---@class QuestTemplate
    ---@field name string
    ---@field description string
    ---@field level integer
    ---@field onlyOnce boolean
    ---@field maxProgress integer
    ---@field questMark effect

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
    local BitSets = {} ---@type table<player, BitSet>

    local function UpdateMenu()
        if PressedQuest == 0 then
            BlzFrameSetVisible(QuestInformation, false)
        else
            local quest = PlayerQuests[LocalPlayer][PressedQuest]
            BlzFrameSetText(QuestInformationName, "|cffFFCC00" .. quest.name .. "|r")
            BlzFrameSetText(QuestInformationDescription, quest.description)
            local max = QuestTemplates[quest.id].maxProgress
            if max > 0 then
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
            local progress = "In progress"
            local max = QuestTemplates[q.id].maxProgress
            if max > 0 then
                if q.progress < max then
                    progress = progress .. " " .. q.progress .. "/" .. max
                else
                    progress = progress .. " |cff00ff00" .. q.progress .. "/" .. max .. "|r"
                end
            end
            BlzFrameSetText(QuestOptionText[i], "|cffFFCC00" .. q.name .. "|r - Level " .. q.level .. "\n" .. progress)
        end
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
        BlzFrameSetAbsPoint(QuestButton, FRAMEPOINT_TOPLEFT, 0.820000, 0.105000)
        BlzFrameSetAbsPoint(QuestButton, FRAMEPOINT_BOTTOMRIGHT, 0.850000, 0.0750000)
        local t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, QuestButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ShowMenu)
        BlzFrameSetVisible(QuestButton, false)

        BackdropQuestButton = BlzCreateFrameByType("BACKDROP", "BackdropQuestButton", QuestButton, "", 0)
        BlzFrameSetAllPoints(BackdropQuestButton, QuestButton)
        BlzFrameSetTexture(BackdropQuestButton, "ReplaceableTextures\\CommandButtons\\BTNBansheeMaster.blp", 0, true)

        QuestMenu = BlzCreateFrame("QuestButtonBaseTemplate", Origin, 0, 0)
        BlzFrameSetAbsPoint(QuestMenu, FRAMEPOINT_TOPLEFT, 0.740000, 0.440000)
        BlzFrameSetAbsPoint(QuestMenu, FRAMEPOINT_BOTTOMRIGHT, 0.930000, 0.200000)
        BlzFrameSetVisible(QuestMenu, false)

        QuestInformation = BlzCreateFrame("CheckListBox", QuestMenu, 0, 0)
        BlzFrameSetAbsPoint(QuestInformation, FRAMEPOINT_TOPLEFT, 0.550000, 0.440000)
        BlzFrameSetAbsPoint(QuestInformation, FRAMEPOINT_BOTTOMRIGHT, 0.740000, 0.200000)
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

        for i = 0, udg_MAX_QUESTS do
            QuestOptionT[i] = BlzCreateFrame("ScriptDialogButton", Quests, 0, 0)
            BlzFrameSetPoint(QuestOptionT[i], FRAMEPOINT_TOPLEFT, Quests, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetSize(QuestOptionT[i], 0.15300, 0.04000)
            BlzFrameSetText(QuestOptionT[i], "")
            BlzFrameSetScale(QuestOptionT[i], 1.00)
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

    InitFrames()
    FrameLoaderAdd(InitFrames)

    Timed.call(function ()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            PlayerQuests[GetEnumPlayer()] = {}
            BitSets[GetEnumPlayer()] = BitSet.create()
        end)
    end)

    ---@param p player
    ---@param id integer
    local function AddQuest(p, id)
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
        if p == LocalPlayer then
            QuestList:add(QuestOptionT[id])
            BlzPlaySpecialEffect(QuestTemplates[id].questMark, ANIM_TYPE_DEATH)
            UpdateMenu()
            StartSound(bj_questDiscoveredSound)
            if not BlzFrameIsVisible(QuestMenu) then
                DisplayTextToPlayer(p, 0, 0, "|cffFFCC00NEW QUEST:|r " .. PlayerQuests[p][id].name)
            end
            BlzFrameSetVisible(QuestButton, true)
        end
        Timed.call(0.667, function ()
            if p == LocalPlayer then
                BlzSetSpecialEffectAlpha(QuestTemplates[id].questMark, 0)
            end
        end)
    end

    ---@param name string
    ---@param description string
    ---@param id integer
    ---@param level integer
    ---@param onlyOnce boolean
    ---@param maxProgress integer
    ---@param petitioner unit
    local function DefineQuestTemplate(name, description, id, level, onlyOnce, maxProgress, petitioner)
        if QuestTemplates[id] then
            error("You are repiting a quest id: " .. QuestTemplates[id].name .. " and " .. name)
        end
        QuestTemplates[id] = {name = name, description = description, level = level, onlyOnce = onlyOnce, maxProgress = maxProgress}
        if petitioner then
            local questMark = AddSpecialEffect(QUEST_MARK, GetUnitX(petitioner), GetUnitY(petitioner))
            BlzSetSpecialEffectZ(questMark, GetUnitZ(petitioner, true) + 50)
            QuestTemplates[id].questMark = questMark
        end
    end

    ---@param p player
    ---@param id integer
    local function SetQuestCompleted(p, id)
        if not QuestTemplates[id].onlyOnce then
            Timed.call(udg_DO_QUEST_AGAIN_DELAY, function ()
                PlayerQuests[p][id] = nil
            end)
        else
            BitSets[p]:set(id)
        end
        PlayerQuests[p][id].completed = true
        if p == LocalPlayer then
            QuestList:remove(QuestOptionT[id])
            PressedQuest = 0
            UpdateMenu()
            StartSound(bj_questCompletedSound)
            if not BlzFrameIsVisible(QuestMenu) then
                DisplayTextToPlayer(p, 0, 0, "|cffFFCC00QUEST COMPLETED:|r |cff00ff00" .. PlayerQuests[p][id].name .. "|r")
            end
        end
    end

    ---@param p player
    ---@param value integer
    function SetCompletedQuests(p, value)
        local bitset = BitSet.create(value)
        for i = 0, MAX_UNIQUE_QUESTS do
            if QuestTemplates[i] then
                local alpha
                if bitset:get(i) then
                    PlayerQuests[p][i] = {
                        name = QuestTemplates[i].name,
                        description = QuestTemplates[i].description,
                        owner = p,
                        id = i,
                        level = QuestTemplates[i].level,
                        completed = true,
                        progress = 0
                    }
                    alpha = 0
                else
                    PlayerQuests[p][i] = nil
                    alpha = 255
                end
                if p == LocalPlayer then
                    if QuestTemplates[i].questMark then
                        BlzSetSpecialEffectAlpha(QuestTemplates[i].questMark, alpha)
                    end
                end
            end
        end
        BitSets[p] = bitset
    end

    ---@param p player
    ---@return integer
    function GetCompletedQuests(p)
        return BitSets[p]:toInt()
    end

    ---@param bit integer
    ---@return string
    function GetCompletedQuestNames(bit)
        local bitset = BitSet.create(bit)
        local result = ""
        for i = 0, MAX_UNIQUE_QUESTS do
            if bitset:get(i) then
                local name = QuestTemplates[i].name
                if name:len() >= 11 then
                    name = name:sub(1, 11) .. "..."
                end
                result = result .. "-" .. name .. "\n"
            end
        end
        return result
    end

    OnInit.trig(function ()
        udg_QuestDefine = CreateTrigger()
        TriggerAddAction(udg_QuestDefine, function ()
            if udg_QuestOnlyOnce and udg_QuestId > MAX_UNIQUE_QUESTS then
                error("You are asigning an id greater than the max to the unique mission: " .. udg_QuestName)
            end
            DefineQuestTemplate(udg_QuestName, udg_QuestDescription, udg_QuestId, udg_QuestLevel, udg_QuestOnlyOnce, udg_QuestMaxProgress, udg_QuestPetitioner)
            udg_QuestName = ""
            udg_QuestDescription = ""
            udg_QuestId = 0
            udg_QuestLevel = 0
            udg_QuestOnlyOnce = false
            udg_QuestMaxProgress = 0
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
    end)

    GlobalRemap("udg_PlayerIsOnQuest", function ()
        return PlayerQuests[udg_QuestPlayer][udg_QuestId] ~= nil
    end)
    GlobalRemap("udg_QuestIsCompleted", function ()
        return udg_PlayerIsOnQuest and PlayerQuests[udg_QuestPlayer][udg_QuestId].completed
    end)
    GlobalRemap("udg_QuestProgress", function ()
        return PlayerQuests[udg_QuestPlayer][udg_QuestId].progress
    end, function (value)
        PlayerQuests[udg_QuestPlayer][udg_QuestId].progress = value
        if udg_QuestPlayer == LocalPlayer then
            UpdateMenu()
        end
    end)

end)
Debug.endFile()