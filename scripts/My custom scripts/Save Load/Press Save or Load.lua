Debug.beginFile("PressSaveOrLoad")
OnInit("PressSaveOrLoad", function ()
    Require "AddHook"
    Require "Timed"
    Require "Menu"
    Require "GameStatus"
    local FrameList = Require "FrameList" ---@type FrameList
    Require "GetSyncedData"
    Require "Serializable"

    local restartListener = EventListener.create()
    local loadListener = EventListener.create()

    ---@param func fun(p: player)
    function OnRestart(func)
        restartListener:register(func)
    end

    ---@param func fun(p: player)
    function OnLoad(func)
        loadListener:register(func)
    end

    ---@class PlayerData: Serializable
    ---@field gold integer
    ---@field lumber integer
    ---@field food integer
    ---@field date osdate
    ---@field vistedPlaces boolean[]
    ---@field vistedPlaceCount integer
    PlayerData = setmetatable({}, Serializable)
    PlayerData.__index = PlayerData

    ---@param p player?
    ---@return PlayerData|Serializable
    function PlayerData.create(p)
        local self = setmetatable({
            vistedPlaces = __jarray(false)
        }, PlayerData)
        if p then
            self.gold = GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD)
            self.lumber = GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER)
            self.food = GetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED)
            self.date = GetSyncedData(p, os.date, "*t")
            self.vistedPlaces = GetVisitedPlaces(p)
            self.vistedPlaceCount = #self.vistedPlaces
        end
        return self
    end

    function PlayerData:serializeProperties()
        self:addProperty("gold", self.gold)
        self:addProperty("lumber", self.lumber)
        self:addProperty("food", self.food)
        self:addProperty("date", Obj2Str(self.date))
        self:addProperty("vpCount", self.vistedPlaceCount)
        for i = 1, self.vistedPlaceCount do
            self:addProperty("vp" .. i, self.vistedPlaces[i])
        end
    end

    function PlayerData:deserializeProperties()
        self.gold = self:getIntProperty("gold")
        self.lumber = self:getIntProperty("lumber")
        self.food = self:getIntProperty("food")
        self.date = Str2Obj(self:getStringProperty("date"))
        self.vistedPlaceCount = self:getIntProperty("vpCount")
        for i = 1, self.vistedPlaceCount do
            self.vistedPlaces[i] = self:getBoolProperty("vp" .. i)
        end
    end

    local PlayerDatas = {} ---@type table<player, PlayerData[]>
    local DigimonDatas = {} ---@type table<player, BankData[]>
    local BackpackDatas = {} ---@type table<player, BackpackData[]>
    local QuestDatas = {} ---@type table<player, QuestData[]>

    for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
        PlayerDatas[Player(i)] = {}
        DigimonDatas[Player(i)] = {}
        BackpackDatas[Player(i)] = {}
        QuestDatas[Player(i)] = {}
    end

    ---Clears all the data of the player
    ---@param p player
    function RestartData(p)
        --[[for i = 0, udg_MAX_DIGIMONS - 1 do
            pcall(RemoveFromBank, p, i, true)
        end
        for i = 0, udg_MAX_SAVED_DIGIMONS - 1 do
            pcall(RemoveSavedDigimon, p, i)
        end
        SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, 0)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, 0)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED, 0)
        SetBackpackItems(p, nil)
        SetBankItems(p)
        EnumItemsInRect(WorldBounds.rect, nil, function ()
            if GetItemPlayer(GetEnumItem()) == p then
                RemoveItem(GetEnumItem())
            end
        end)
        SetQuestsData(p)]]

        restartListener:run(p)
    end

    ---@param p player
    ---@param slot integer
    function SavePlayerData(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, "PlayerData")
        local data = PlayerData.create(p)
        local code = EncodeString(p, data:serialize())

        if p == GetLocalPlayer() then
            FileIO.Write(fileRoot, code)
        end

        PlayerDatas[p][slot] = data
        DigimonDatas[p][slot] = SaveDigimons(p, slot)
        BackpackDatas[p][slot] = SaveBackpack(p, slot)
        QuestDatas[p][slot] = SaveQuests(p, slot)
    end

    ---@param p player
    ---@param slot integer
    ---@return boolean
    function LoadPlayerData(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, "PlayerData")
        local data = PlayerData.create()
        local code = GetSyncedData(p, FileIO.Read, fileRoot)

        if code ~= "" then
            local success, decode = xpcall(DecodeString, print, p, code)
            if not success or not decode then
                DisplayTextToPlayer(p, 0, 0, "The file " .. fileRoot .. " has invalid data.")
                return false
            end
            data:deserialize(decode)
        else
            return false
        end

        PlayerDatas[p][slot] = data
        DigimonDatas[p][slot] = LoadDigimons(p, slot)
        BackpackDatas[p][slot] = LoadBackpack(p, slot)
        QuestDatas[p][slot] = LoadQuests(p, slot)

        loadListener:run(p)

        return true
    end

    function SetPlayerData(p, slot)
        if PlayerDatas[p][slot] then
            local data = PlayerDatas[p][slot]
            SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, data.gold)
            SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, data.lumber)
            SetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED, data.food)
            ApplyVisitedPlaces(p, data.vistedPlaces)
        end
        if DigimonDatas[p][slot] then
            SetBank(p, DigimonDatas[p][slot])
        end
        if BackpackDatas[p][slot] then
            SetBackpack(p, BackpackDatas[p][slot])
        end
        if QuestDatas[p][slot] then
            SetQuests(p, QuestDatas[p][slot])
        end
    end

    local MAX_DIGIMONS = udg_MAX_DIGIMONS
    local MAX_SAVED = udg_MAX_SAVED_DIGIMONS
    local MAX_QUESTS = udg_MAX_QUESTS

    local CHUNK_SIZE = 150

    local NormalColor = "FCD20D"
    local DisabledColor = "FFFFFF"
    local LocalPlayer = GetLocalPlayer()

    local Pressed = __jarray(0) ---@type table<player, integer>
    local SaveButton = nil ---@type framehandle
    local BackdropSaveButton = nil ---@type framehandle
    local LoadButton = nil ---@type framehandle
    local BackdropLoadButton = nil ---@type framehandle
    local SaveLoadMenu = nil ---@type framehandle
    local SaveSlotT = {} ---@type framehandle[]
    local Information = nil ---@type framehandle
    local TooltipName = nil ---@type framehandle
    local TooltipDate = nil ---@type framehandle
    local TooltipGold = nil ---@type framehandle
    local TooltipLumber = nil ---@type framehandle
    local TooltipFood = nil ---@type framehandle
    local TooltipDigimonT = {} ---@type framehandle[]
    local TooltipDigimonIconT = {} ---@type framehandle[]
    local TooltipDigimonItemsT = {} ---@type framehandle[]
    local TooltipDigimonLevelT = {} ---@type framehandle[]
    local TooltipDigimonStamina = {} ---@type framehandle[] 
    local TooltipDigimonDexterity = {} ---@type framehandle[] 
    local TooltipDigimonWisdom = {} ---@type framehandle[] 
    local TooltipUsing = nil ---@type framehandle
    local TooltipSaved = nil ---@type framehandle
    local TooltipBackpack = nil ---@type framehandle
    local TooltipSavedItems = nil ---@type framehandle
    local TooltipQuests = nil ---@type framehandle
    local TooltipQuestsArea = nil ---@type FrameList
    local TooltipQuestsName = {} ---@type framehandle[]
    local AbsoluteSave = nil ---@type framehandle
    local AbsoluteLoad = nil ---@type framehandle
    local Exit = nil ---@type framehandle

    local NotOnline = false
    local QuestsAdded = {}

    OnInit.final(function ()
        NotOnline = GameStatus.get() ~= GameStatus.ONLINE and not udg_SaveOnSinglePlayer

        PolledWait(1.)

        if NotOnline then
            print("You are in single player, save data is disabled.")
            BlzFrameSetEnable(AbsoluteSave, false)
        end
    end)

    ---This function always should be in a "if player == GetLocalPlayer() then" block
    local function UpdateMenu()
        local list = PlayerDatas[LocalPlayer]
        for i = 1, 5 do
            if list[i] then
                BlzFrameSetText(SaveSlotT[i-1], "|cffFCD20DSaved Slot " .. i .. "|r")
            else
                BlzFrameSetText(SaveSlotT[i-1], "|cffFCD20DEmpty|r")
            end
        end
    end

    -- This function always should be in a "if player == GetLocalPlayer() then" block
    local function UpdateInformation()
        local pData = PlayerDatas[LocalPlayer][Pressed[LocalPlayer]]
        local dData = DigimonDatas[LocalPlayer][Pressed[LocalPlayer]]
        local bData = BackpackDatas[LocalPlayer][Pressed[LocalPlayer]]
        local qData = QuestDatas[LocalPlayer][Pressed[LocalPlayer]]

        for i = 1, #QuestsAdded do
            TooltipQuestsArea:remove(TooltipQuestsName[QuestsAdded[i]])
        end
        QuestsAdded = {}

        if pData then
            BlzFrameSetText(TooltipName, "|cffff6600Information|r")
            BlzFrameSetText(TooltipDate, os.date("\x25c", os.time(pData.date)))
            BlzFrameSetText(TooltipGold, "|cff828282DigiBits: |r" .. pData.gold)
            BlzFrameSetText(TooltipLumber, "|cffc882c8DigiCrystal: |r" .. pData.lumber)
            BlzFrameSetText(TooltipFood, "|cff8080ffTamer Rank: |r" .. pData.food)
            for i = 0, MAX_DIGIMONS - 1 do
                local index = i
                if dData.stocked[i] then
                    local s = ""
                    for j = 0, 5 do
                        if dData.stocked[i]["invSlot" .. j] ~= 0 then
                            s = s .. GetObjectName(dData.stocked[i]["invSlot" .. j]) -- Thank you guys
                            if j ~= 5 then
                                s = s .. ", "
                            end
                        end
                    end
                    BlzFrameSetText(TooltipDigimonItemsT[index], "|cff00ffffItems: |r" .. s)
                    BlzFrameSetTexture(TooltipDigimonIconT[index], BlzGetAbilityIcon(dData.stocked[i].typeId), 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index], "|cffFFCC00Level " .. I2S(dData.stocked[i].level) .. "|r")
                    BlzFrameSetText(TooltipDigimonStamina[index], "|cffff7d00STA:|r" .. dData.stocked[i].lvlSta .. " (+" .. dData.stocked[i].IVsta .. ")")
                    BlzFrameSetText(TooltipDigimonDexterity[index], "|cff007d32DEX:|r" .. dData.stocked[i].lvlDex .. " (+" .. dData.stocked[i].IVdex .. ")")
                    BlzFrameSetText(TooltipDigimonWisdom[index], "|cff0078c8WIS:|r" .. dData.stocked[i].lvlWis .. " (+" .. dData.stocked[i].IVwis .. ")")
                else
                    BlzFrameSetText(TooltipDigimonItemsT[index], "|cff00ffffItems: |r")
                    BlzFrameSetTexture(TooltipDigimonIconT[index], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index], "|cffFFCC00Level 0|r")
                    BlzFrameSetText(TooltipDigimonStamina[index], "|cffff7d00STA:|r")
                    BlzFrameSetText(TooltipDigimonDexterity[index], "|cff007d32DEX:|r")
                    BlzFrameSetText(TooltipDigimonWisdom[index], "|cff0078c8WIS:|r")
                end
            end
            for i = 0, udg_MAX_SAVED_DIGIMONS - 1 do
                local index = i + MAX_DIGIMONS
                if dData.saved[i] then
                    local s = ""
                    for j = 0, 5 do
                        if dData.saved[i]["invSlot" .. j] ~= 0 then
                            s = s .. GetObjectName(dData.saved[i]["invSlot" .. j]) -- Thank you guys
                            if j ~= 5 then
                                s = s .. ", "
                            end
                        end
                    end
                    BlzFrameSetText(TooltipDigimonItemsT[index], "|cff00ffffItems: |r" .. s)
                    BlzFrameSetTexture(TooltipDigimonIconT[index], BlzGetAbilityIcon(dData.saved[i].typeId), 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index], "|cffFFCC00Level " .. I2S(dData.saved[i].level) .. "|r")
                    BlzFrameSetText(TooltipDigimonStamina[index], "|cffff7d00STA:|r" .. dData.saved[i].lvlSta .. " (+" .. dData.saved[i].IVsta .. ")")
                    BlzFrameSetText(TooltipDigimonDexterity[index], "|cff007d32DEX:|r" .. dData.saved[i].lvlDex .. " (+" .. dData.saved[i].IVdex .. ")")
                    BlzFrameSetText(TooltipDigimonWisdom[index], "|cff0078c8WIS:|r" .. dData.saved[i].lvlWis .. " (+" .. dData.saved[i].IVwis .. ")")
                else
                    BlzFrameSetText(TooltipDigimonItemsT[index], "|cff00ffffItems: |r")
                    BlzFrameSetTexture(TooltipDigimonIconT[index], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index], "|cffFFCC00Level 0|r")
                    BlzFrameSetText(TooltipDigimonStamina[index], "|cffff7d00STA:|r")
                    BlzFrameSetText(TooltipDigimonDexterity[index], "|cff007d32DEX:|r")
                    BlzFrameSetText(TooltipDigimonWisdom[index], "|cff0078c8WIS:|r")
                end
            end
            BlzFrameSetText(TooltipSaved, "|cff00eeffSaved:|r |cffffff00Max. " .. dData.maxSaved .. "|r")

            local result = ""
            for i = 1, bData.amount do
                result = result .. GetObjectName(bData.id[i]) .. "(" .. bData.charges[i] .. "), "
            end
            BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r\n" .. result:sub(1, result:len() - 2))

            result = ""
            for i = 1, dData.sItmsSto do
                if dData.sItms[i] then
                    result = result .. GetObjectName(dData.sItms[i])
                    if dData.sItmsCha[i] > 1 then
                        result = result .. "(" .. dData.sItmsCha[i] .. ")"
                    end
                    if i ~= dData.sItmsSto then
                        result = result .. ", "
                    end
                end
            end
            BlzFrameSetText(TooltipSavedItems, "|cff4566ffSaved Items:|r |cffffff00Max. " .. dData.sItmsSto .. "|r\n" .. result)

            for i = 1, qData.amount do
                local id = qData.id[i]
                if not IsQuestARequirement(id) then
                    local s = GetQuestName(id)
                    if qData.comp[i] then
                        s = "|cffFFCC00" .. s .. "|r"
                    else
                        local max = GetQuestMaxProgress(id)
                        if max > 1 then
                            s = s .. " " .. ((max == qData.prog[i]) and "|cff00ff00" or "|cffffffff") .. "(" .. qData.prog[i] .. "/" .. max .. ")|r"
                        end
                    end
                    BlzFrameSetText(TooltipQuestsName[id], s)
                    TooltipQuestsArea:add(TooltipQuestsName[id])
                    table.insert(QuestsAdded, id)
                end
            end
        else
            BlzFrameSetText(TooltipName, "|cffff6600Empty|r")
            BlzFrameSetText(TooltipDate, "Date")
            BlzFrameSetText(TooltipGold, "|cff828282DigiBits:|r")
            BlzFrameSetText(TooltipLumber, "|cffc882c8DigiCrystal:|r")
            BlzFrameSetText(TooltipFood, "|cff8080ffTamer Rank:|r")
            for i = 0, MAX_DIGIMONS + MAX_SAVED - 1 do
                BlzFrameSetText(TooltipDigimonItemsT[i], "|cff00ffffItems:|r")
                BlzFrameSetTexture(TooltipDigimonIconT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                BlzFrameSetText(TooltipDigimonLevelT[i], "|cffFFCC00Level 0|r")
            end
            BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r")
            BlzFrameSetText(TooltipSavedItems, "|cff4566ffSaved Items:|r")
            BlzFrameSetEnable(AbsoluteLoad, false)
        end
    end

    local function SaveLoadActions(slot)
        local p = GetTriggerPlayer()
        local oldSlot = Pressed[p] - 1
        Pressed[p] = slot + 1
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetEnable(SaveSlotT[oldSlot], true)
            BlzFrameSetEnable(SaveSlotT[slot], false)
            BlzFrameSetVisible(Information, true)
            BlzFrameSetEnable(AbsoluteSave, BlzFrameIsVisible(AbsoluteSave) and not NotOnline)
            BlzFrameSetEnable(AbsoluteLoad, BlzFrameIsVisible(AbsoluteLoad))
            UpdateInformation()
        end
    end

    local function ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            BlzFrameSetEnable(SaveSlotT[Pressed[LocalPlayer] - 1], true)
            BlzFrameSetVisible(Information, false)
            BlzFrameSetVisible(SaveLoadMenu, false)
            RemoveButtonFromEscStack(Exit)
        end
    end

    local function SaveFunc()
        ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            if not BlzFrameIsVisible(SaveLoadMenu) then
                AddButtonToEscStack(Exit)
            end
            BlzFrameSetVisible(SaveLoadMenu, true)
            BlzFrameSetVisible(AbsoluteSave, true)
            BlzFrameSetEnable(AbsoluteSave, false)
            BlzFrameSetVisible(AbsoluteLoad, false)
            UpdateMenu()
        end
    end

    local function LoadFunc()
        ExitFunc()
        if GetTriggerPlayer() == LocalPlayer then
            if not BlzFrameIsVisible(SaveLoadMenu) then
                AddButtonToEscStack(Exit)
            end
            BlzFrameSetVisible(SaveLoadMenu, true)
            BlzFrameSetVisible(AbsoluteSave, false)
            BlzFrameSetVisible(AbsoluteLoad, true)
            BlzFrameSetEnable(AbsoluteLoad, false)
            UpdateMenu()
        end
    end

    local function AbsoluteSaveFunc()
        local p = GetTriggerPlayer()
        SavePlayerData(p, Pressed[p])
        if p == LocalPlayer then
            UpdateMenu()
            UpdateInformation()
        end
    end

    local function AbsoluteLoadFunc()
        local p = GetTriggerPlayer()
        TriggerExecute(gg_trg_Absolute_Load)
        SetPlayerData(p, Pressed[p])
        ExitFunc()
    end

    local function InitFrames()
        local t = nil ---@type trigger

        BlzLoadTOCFile("ButtonsTOC.toc")
        BlzLoadTOCFile("war3mapImported\\slider.toc")

        -- Save Button
        SaveButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(SaveButton, 9)
        BlzFrameSetText(SaveButton, "|cff" .. NormalColor .. "Save|r")
        BlzFrameSetScale(SaveButton, 1.00)
        BlzFrameSetVisible(SaveButton, false)
        AddFrameToMenu(SaveButton)
        AddDefaultTooltip(SaveButton, "Save", "Save your progress.")

        BackdropSaveButton = BlzCreateFrameByType("BACKDROP", "BackdropSaveButton", SaveButton, "", 0)
        BlzFrameSetAllPoints(BackdropSaveButton, SaveButton)
        BlzFrameSetTexture(BackdropSaveButton, "ReplaceableTextures\\CommandButtons\\BTNSave.blp", 0, true)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SaveButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SaveFunc)

        -- Load Button

        LoadButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0),0,0)
        AddButtonToTheRight(LoadButton, 10)
        BlzFrameSetText(LoadButton, "|cff" .. NormalColor .. "Load|r")
        BlzFrameSetScale(LoadButton, 1.00)
        BlzFrameSetVisible(LoadButton, false)
        AddFrameToMenu(LoadButton)
        AddDefaultTooltip(LoadButton, "Load", "Load your progress.")

        BackdropLoadButton = BlzCreateFrameByType("BACKDROP", "BackdropLoadButton", LoadButton, "", 0)
        BlzFrameSetAllPoints(BackdropLoadButton, LoadButton)
        BlzFrameSetTexture(BackdropLoadButton, "ReplaceableTextures\\CommandButtons\\BTNLoad.blp", 0, true)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, LoadButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, LoadFunc)

        -- Menu

        SaveLoadMenu = BlzCreateFrame("QuestButtonPushedBackdropTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0),0,0)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.27, 0.535000)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.315000)
        BlzFrameSetVisible(SaveLoadMenu, false)
        AddFrameToMenu(SaveLoadMenu)

        for i = 0, 4 do
            SaveSlotT[i] = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
            BlzFrameSetPoint(SaveSlotT[i], FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.01000 - i * 0.035)
            BlzFrameSetPoint(SaveSlotT[i], FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.18000 - i * 0.035)
            BlzFrameSetText(SaveSlotT[i], "|cffFCD20DEmpty|r")
            BlzFrameSetScale(SaveSlotT[i], 1.00)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, SaveSlotT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () SaveLoadActions(i) end) -- :D
        end

        AbsoluteSave = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(AbsoluteSave, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.18000)
        BlzFrameSetPoint(AbsoluteSave, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.010000)
        BlzFrameSetText(AbsoluteSave, "|cffFCD20DSave|r")
        BlzFrameSetScale(AbsoluteSave, 1.00)
        BlzFrameSetVisible(AbsoluteSave, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, AbsoluteSave, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, AbsoluteSaveFunc)

        AbsoluteLoad = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(AbsoluteLoad, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.18000)
        BlzFrameSetPoint(AbsoluteLoad, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.010000)
        BlzFrameSetText(AbsoluteLoad, "|cffFCD20DLoad|r")
        BlzFrameSetScale(AbsoluteLoad, 1.00)
        BlzFrameSetVisible(AbsoluteLoad, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, AbsoluteLoad, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, AbsoluteLoadFunc)

        Exit = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.12000, -0.18000)
        BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.010000)
        BlzFrameSetText(Exit, "|cffFCD20DExit|r")
        BlzFrameSetScale(Exit, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Exit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ExitFunc)

        -- Tooltip

        Information = BlzCreateFrame("CheckListBox", SaveLoadMenu, 0, 0)
        BlzFrameSetPoint(Information, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, -0.50000, 0.0000)
        BlzFrameSetPoint(Information, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.22000, -0.30000)
        BlzFrameSetLevel(Information, 100)

        TooltipName = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.49000)
        BlzFrameSetText(TooltipName, "|cffff6600Name|r")
        BlzFrameSetEnable(TooltipName, false)
        BlzFrameSetScale(TooltipName, 1.00)
        BlzFrameSetTextAlignment(TooltipName, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipDate = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipDate, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.25000, -0.010000)
        BlzFrameSetPoint(TooltipDate, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.49000)
        BlzFrameSetText(TooltipDate, "Date")
        BlzFrameSetEnable(TooltipDate, false)
        BlzFrameSetScale(TooltipDate, 1.00)
        BlzFrameSetTextAlignment(TooltipDate, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)

        TooltipGold = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipGold, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(TooltipGold, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.33000, 0.47000)
        BlzFrameSetText(TooltipGold, "|cffFFCC00Gold: |r")
        BlzFrameSetEnable(TooltipGold, false)
        BlzFrameSetScale(TooltipGold, 1.00)
        BlzFrameSetTextAlignment(TooltipGold, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipLumber = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipLumber, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.17000, -0.030000)
        BlzFrameSetPoint(TooltipLumber, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.17000, 0.47000)
        BlzFrameSetText(TooltipLumber, "|cff20bc20Lumber: |r")
        BlzFrameSetEnable(TooltipLumber, false)
        BlzFrameSetScale(TooltipLumber, 1.00)
        BlzFrameSetTextAlignment(TooltipLumber, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipFood = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipFood, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.33000, -0.030000)
        BlzFrameSetPoint(TooltipFood, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.47000)
        BlzFrameSetText(TooltipFood, "|cffa34f00Food: |r")
        BlzFrameSetEnable(TooltipFood, false)
        BlzFrameSetScale(TooltipFood, 1.00)
        BlzFrameSetTextAlignment(TooltipFood, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        local x1 = {}
        local y1 = {}
        local x2 = {}
        local y2 = {}

        local div = math.ceil(MAX_DIGIMONS / 3)
        for i = 0, 2 do
            for j = 0, div - 1 do
                local id = i*div + j
                if id >= MAX_DIGIMONS then break end
                x1[id] = 0.015000 + i * 0.16
                y1[id] = -0.071750 - j * 0.06075
                x2[id] = -0.33500 + i * 0.16
                y2[id] = 0.39250 - j * 0.06075
            end
        end

        div = math.ceil(MAX_SAVED / 3)
        for i = 0, 2 do
            for j = 0, div - 1 do
                local id = i*div + j
                if id >= MAX_SAVED then break end
                id = id + MAX_DIGIMONS
                x1[id] = 0.015000 + i * 0.16
                y1[id] = -0.27050 - j * 0.06075
                x2[id] = -0.33500 + i * 0.16
                y2[id] = 0.19375 - j * 0.06075
            end
        end

        for i = 0, MAX_DIGIMONS + MAX_SAVED - 1 do
            TooltipDigimonT[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", Information, "", 1)
            BlzFrameSetPoint(TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])
            BlzFrameSetTexture(TooltipDigimonT[i], "war3mapImported\\EmptyBTN.blp", 0, true)

            TooltipDigimonIconT[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", TooltipDigimonT[i], "", 1)
            BlzFrameSetPoint(TooltipDigimonIconT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.0017500)
            BlzFrameSetPoint(TooltipDigimonIconT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.10750, 0.016500)
            BlzFrameSetTexture(TooltipDigimonIconT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

            TooltipDigimonItemsT[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetPoint(TooltipDigimonItemsT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.045000, -0.0032500)
            BlzFrameSetPoint(TooltipDigimonItemsT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0045000, 0.010000)
            BlzFrameSetText(TooltipDigimonItemsT[i], "|cff00ffffItems:|r")
            BlzFrameSetEnable(TooltipDigimonItemsT[i], false)
            BlzFrameSetScale(TooltipDigimonItemsT[i], 1.00)
            BlzFrameSetTextAlignment(TooltipDigimonItemsT[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            TooltipDigimonLevelT[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetPoint(TooltipDigimonLevelT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.0037500, -0.040750)
            BlzFrameSetPoint(TooltipDigimonLevelT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.10625, 0.0000)
            BlzFrameSetText(TooltipDigimonLevelT[i], "|cffFFCC00Level 0|r")
            BlzFrameSetEnable(TooltipDigimonLevelT[i], false)
            BlzFrameSetScale(TooltipDigimonLevelT[i], 1.00)
            BlzFrameSetTextAlignment(TooltipDigimonLevelT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

            TooltipDigimonStamina[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonStamina[i], 0.65)
            BlzFrameSetPoint(TooltipDigimonStamina[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.045000, -0.045750)
            BlzFrameSetPoint(TooltipDigimonStamina[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.071500, 0.0000)
            BlzFrameSetText(TooltipDigimonStamina[i], "")
            BlzFrameSetEnable(TooltipDigimonStamina[i], false)
            BlzFrameSetTextAlignment(TooltipDigimonStamina[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            TooltipDigimonDexterity[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonDexterity[i], 0.65)
            BlzFrameSetPoint(TooltipDigimonDexterity[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.078500, -0.045750)
            BlzFrameSetPoint(TooltipDigimonDexterity[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.038000, 0.0000)
            BlzFrameSetText(TooltipDigimonDexterity[i], "")
            BlzFrameSetEnable(TooltipDigimonDexterity[i], false)
            BlzFrameSetTextAlignment(TooltipDigimonDexterity[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            TooltipDigimonWisdom[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonWisdom[i], 0.65)
            BlzFrameSetPoint(TooltipDigimonWisdom[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.11200, -0.045750)
            BlzFrameSetPoint(TooltipDigimonWisdom[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0045000, 0.0000)
            BlzFrameSetText(TooltipDigimonWisdom[i], "")
            BlzFrameSetEnable(TooltipDigimonWisdom[i], false)
            BlzFrameSetTextAlignment(TooltipDigimonWisdom[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
        end

        TooltipUsing = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipUsing, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.050000)
        BlzFrameSetPoint(TooltipUsing, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.38500, 0.45000)
        BlzFrameSetText(TooltipUsing, "|cff00eeffUsing:|r")
        BlzFrameSetEnable(TooltipUsing, false)
        BlzFrameSetScale(TooltipUsing, 1.00)
        BlzFrameSetTextAlignment(TooltipUsing, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipSaved = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipSaved, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.25000)
        BlzFrameSetPoint(TooltipSaved, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.38500, 0.25000)
        BlzFrameSetText(TooltipSaved, "|cff00eeffSaved:|r")
        BlzFrameSetEnable(TooltipSaved, false)
        BlzFrameSetScale(TooltipSaved, 1.00)
        BlzFrameSetTextAlignment(TooltipSaved, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipBackpack = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipBackpack, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.39000)
        BlzFrameSetPoint(TooltipBackpack, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.34000, 0.010000)
        BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r")
        BlzFrameSetEnable(TooltipBackpack, false)
        BlzFrameSetScale(TooltipBackpack, 1.00)
        BlzFrameSetTextAlignment(TooltipBackpack, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipSavedItems = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipSavedItems, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.17500, -0.39000)
        BlzFrameSetPoint(TooltipSavedItems, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.010000)
        BlzFrameSetText(TooltipSavedItems, "|cff4566ffSaved Items:|r")
        BlzFrameSetEnable(TooltipSavedItems, false)
        BlzFrameSetScale(TooltipSavedItems, 1.00)
        BlzFrameSetTextAlignment(TooltipSavedItems, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipQuests = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipQuests, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.34000, -0.39000)
        BlzFrameSetPoint(TooltipQuests, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetText(TooltipQuests, "|cff5257ffQuests:|r")
        BlzFrameSetEnable(TooltipQuests, false)
        BlzFrameSetScale(TooltipQuests, 1.00)
        BlzFrameSetTextAlignment(TooltipQuests, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipQuestsArea = FrameList.create(false, TooltipQuests)
        BlzFrameSetPoint(TooltipQuestsArea.Frame, FRAMEPOINT_TOPLEFT, TooltipQuests, FRAMEPOINT_TOPLEFT, 0.0000, -0.010000)
        BlzFrameSetPoint(TooltipQuestsArea.Frame, FRAMEPOINT_BOTTOMRIGHT, TooltipQuests, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
        TooltipQuestsArea:setSize(BlzFrameGetWidth(TooltipQuestsArea.Frame), BlzFrameGetHeight(TooltipQuestsArea.Frame))

        Timed.call(function ()
            for i = 0, MAX_QUESTS do
                TooltipQuestsName[i] = BlzCreateFrameByType("TEXT", "name", TooltipQuests, "", 0)
                BlzFrameSetSize(TooltipQuestsName[i], 0.13, 0.015)
                BlzFrameSetText(TooltipQuestsName[i], GetQuestName(i))
                BlzFrameSetEnable(TooltipQuestsName[i], false)
                BlzFrameSetScale(TooltipQuestsName[i], 1.00)
                BlzFrameSetTextAlignment(TooltipQuestsName[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
                BlzFrameSetVisible(TooltipQuestsName[i], false)
            end
        end)
    end

    FrameLoaderAdd(InitFrames)

    OnChangeDimensions(function ()
        BlzFrameClearAllPoints(SaveLoadMenu)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.27, 0.535000)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.315000)
    end)

    OnLeaderboard(function ()
        BlzFrameSetParent(SaveLoadMenu, BlzGetFrameByName("Leaderboard", 0))
    end)

    -- Functions to use

    ---@param p player
    ---@param flag boolean
    function ShowSave(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(SaveButton, flag)
        end
    end

    ---@param p player
    ---@param flag boolean
    function ShowLoad(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(LoadButton, flag)
        end
    end

    ---@param p player
    function UpdateSaveLoad(p)
        if p == LocalPlayer then
            UpdateMenu()
            UpdateInformation()
        end
    end

    ---@param p player
    ---@param s string
    ---@return string
    function EncodeString(p, s)
        local len = s:len()
        local iter = math.floor(len/CHUNK_SIZE)
        local code = ""

        for j = 1, iter do
            local savecode = Savecode.create()

            for i = 1, CHUNK_SIZE do
                savecode:Encode(s:byte((j-1)*CHUNK_SIZE+i), 255)
            end

            code = code .. savecode:Save(p, 1) .. "~"
            savecode:destroy()
        end

        local rest = len - iter*CHUNK_SIZE
        local savecode = Savecode.create()

        for i = 1, rest do
            savecode:Encode(s:byte(iter*CHUNK_SIZE+i), 255)
        end
        savecode:Encode(rest, CHUNK_SIZE)

        code = code .. savecode:Save(p, 1)
        savecode:destroy()

        return code
    end

    ---@param p player
    ---@param s string
    ---@return string?
    function DecodeString(p, s)
        local decode = ""
        local prevBuffer = 1
        local buffer = s:find("~")

        while buffer do
            local sub = s:sub(prevBuffer, buffer - 1)

            local savecode = Savecode.create()
            if not savecode:Load(p, sub, 1) then
                savecode:destroy()
                return nil
            end
            local decode2 = ""
            for _ = 1, CHUNK_SIZE do
                decode2 = string.char(savecode:Decode(255)) .. decode2
            end
            savecode:destroy()
            decode = decode .. decode2

            prevBuffer = buffer + 1
            buffer = s:find("~", buffer + 1)
        end

        local sub = s:sub(prevBuffer)
        local savecode = Savecode.create()
        if not savecode:Load(p, sub, 1) then
            savecode:destroy()
            return nil
        end
        local len = savecode:Decode(CHUNK_SIZE)
        local decode2 = ""
        for _ = 1, len do
            decode2 = string.char(savecode:Decode(255)) .. decode2
        end
        savecode:destroy()
        decode = decode .. decode2

        return decode
    end

    -- Check for invalid values

    local function hook(func, thing)
        local old
        old = AddHook(func, function (id)
            if not id or id == 0 then
                error("Trying to get an invalid " .. thing .. ".\nMaybe you have an invalid or corrupted saved file.", 2)
            end
            return old(id)
        end)
    end
    hook("BlzGetAbilityIcon", "icon")
    hook("GetObjectName", "name")
    local old1
    old1 = AddHook("BlzGetAbilityExtendedTooltip", function (id, lvl)
        if not id or id == 0 then
            error("Trying to get an invalid tooltip.\nMaybe you have an invalid or corrupted saved file.", 2)
        end
        return old1(id, lvl)
    end)
    local old2
    old2 = AddHook("CreateUnit", function (owningPlayer, unitid, x, y, face)
        if not unitid or unitid == 0 then
            error("Trying to create an invalid unit.\nMaybe you have an invalid or corrupted saved file.", 2)
        end
        return old2(owningPlayer, unitid, x, y, face)
    end)

    -- I don't know why these functions returns real now

    local function hookReal(func)
        local old
        old = AddHook(func, function (obj)
            return math.floor(old(obj))
        end)
    end

    hookReal("GetItemCharges")
    hookReal("GetHeroXP")
end)
Debug.endFile()