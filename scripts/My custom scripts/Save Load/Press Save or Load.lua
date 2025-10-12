Debug.beginFile("PressSaveOrLoad")
OnInit("PressSaveOrLoad", function ()
    Require "AddHook"
    Require "Timed"
    Require "Menu"
    Require "GameStatus"
    local FrameList = Require "FrameList" ---@type FrameList
    Require "GetSyncedData"
    Require "Serializable"
    Require "Hotkeys"

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
    ---@field id string
    ---@field gold integer
    ---@field lumber integer
    ---@field food integer
    ---@field date osdate
    ---@field vistedPlaces boolean[]
    ---@field vistedPlaceCount integer
    ---@field unlockedInfo UnlockedInfoData
    ---@field materials MaterialData
    ---@field unstableDataParts integer
    ---@field slot integer
    PlayerData = setmetatable({}, Serializable)
    PlayerData.__index = PlayerData

    ---@param p player?
    ---@param slot integer
    ---@return PlayerData|Serializable
    function PlayerData.create(p, slot)
        local self = setmetatable({
            vistedPlaces = __jarray(false)
        }, PlayerData)
        if type(p) == "number" then
            slot = p
            p = nil
        end
        assert(type(slot) == "number", "The slot must be a number.")
        self.slot = slot
        if p then
            self.gold = GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD)
            self.lumber = GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER)
            self.food = GetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED)
            _, self.date = pcall(GetSyncedData, p, os.date, "*t")
            self.vistedPlaces = GetVisitedPlaces(p)
            self.vistedPlaceCount = #self.vistedPlaces
            self.materials = MaterialData.create(p)
            self.unstableDataParts = GetUnstableDataParts(p)
            local id = ""
            for k, v in pairs(self.date) do
                if k == "isdst" then
                    v = v and "1" or "0"
                end
                id = id .. v
            end
            self.id = id
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
        self:addProperty("slot", self.slot)
        self:addProperty("materials", self.materials:serialize())
        self:addProperty("uDPs", self.unstableDataParts)
        self:addProperty("id", self.id)
    end

    function PlayerData:deserializeProperties()
        if self.slot ~= self:getIntProperty("slot") then
            error("The slot is not the same.")
            return
        end
        self.gold = self:getIntProperty("gold")
        self.lumber = self:getIntProperty("lumber")
        self.food = self:getIntProperty("food")
        self.date = Str2Obj(self:getStringProperty("date"))
        self.vistedPlaceCount = self:getIntProperty("vpCount")
        for i = 1, self.vistedPlaceCount do
            self.vistedPlaces[i] = self:getBoolProperty("vp" .. i)
        end
        self.materials = MaterialData.create()
        self.materials:deserialize(self:getStringProperty("materials"))
        self.unstableDataParts = self:getIntProperty("uDPs")
        self.id = self:getStringProperty("id")
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
        end]]
        SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, 0)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, 0)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED, 0)
        SetBank(p, BankData.create())
        SetBackpack(p, BackpackData.create())
        SetQuests(p, QuestData.create())
        MaterialData.create():apply(p)
        EnumItemsInRect(WorldBounds.rect, nil, function ()
            if GetItemPlayer(GetEnumItem()) == p then
                RemoveItem(GetEnumItem())
            end
        end)
        ClearDiary(p)
        SetUnstableDataParts(p, 0)
        if p == GetLocalPlayer() then
            RestartMusic()
        end

        restartListener:run(p)
    end

    ---@param p player
    ---@param slot integer
    function SavePlayerData(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, udg_PLAYER_DATA_ROOT)
        local data = PlayerData.create(p, slot)
        local code = EncodeString(p, data:serialize())

        if p == GetLocalPlayer() then
            FileIO.Write(fileRoot, code)
        end

        PlayerDatas[p][slot] = data
        DigimonDatas[p][slot] = SaveDigimons(p, slot, data.id)
        BackpackDatas[p][slot] = SaveBackpack(p, slot, data.id)
        QuestDatas[p][slot] = SaveQuests(p, slot, data.id)
        data.unlockedInfo = SaveDiary(p, slot, data.id)
    end

    ---@param p player
    ---@param slot integer
    ---@return boolean
    function LoadPlayerData(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, udg_PLAYER_DATA_ROOT)
        local data = PlayerData.create(slot)
        local loaded, code = pcall(GetSyncedData, p, FileIO.Read, fileRoot)

        if not loaded then
            print(GetPlayerName(p) .. " can't load its data.")
            return false
        end

        if code ~= "" then
            local success, decode = xpcall(DecodeString, print, p, code)
            if not success or not decode or not xpcall(data.deserialize, print, data, decode) then
                DisplayTextToPlayer(p, 0, 0, GetLocalizedString("INVALID_FILE"):format(fileRoot))
                return false
            end
        else
            return false
        end

        local id = data.id

        local bdata = LoadDigimons(p, slot)
        if not bdata or bdata.id ~= id then
            return false
        end

        local pdata = LoadBackpack(p, slot)
        if not pdata or pdata.ind ~= id then
            return false
        end

        local qdata = LoadQuests(p, slot)
        if not qdata or qdata.ind ~= id then
            return false
        end

        data.unlockedInfo = LoadDiary(p, slot)
        if not data.unlockedInfo or data.unlockedInfo.id ~= id then
            return false
        end

        PlayerDatas[p][slot] = data
        DigimonDatas[p][slot] = bdata
        BackpackDatas[p][slot] = pdata
        QuestDatas[p][slot] = qdata

        return true
    end

    function SetPlayerData(p, slot)
        EnumItemsInRect(WorldBounds.rect, nil, function ()
            if GetItemPlayer(GetEnumItem()) == p then
                RemoveItem(GetEnumItem())
            end
        end)
        if QuestDatas[p][slot] then
            SetQuests(p, QuestDatas[p][slot])
        end
        if PlayerDatas[p][slot] then
            local data = PlayerDatas[p][slot]
            SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, data.gold)
            SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, data.lumber)
            SetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED, data.food)
            data.unlockedInfo:apply()
            ApplyVisitedPlaces(p, data.vistedPlaces)
            data.materials:apply(p)
            SetUnstableDataParts(p, data.unstableDataParts)
        end
        if DigimonDatas[p][slot] then
            SetBank(p, DigimonDatas[p][slot])
        end
        if BackpackDatas[p][slot] then
            SetBackpack(p, BackpackDatas[p][slot])
        end
        if p == GetLocalPlayer() then
            RestartMusic()
        end

        loadListener:run(p)
    end

    local MAX_DIGIMONS = udg_MAX_DIGIMONS
    local MAX_SAVED = udg_MAX_SAVED_DIGIMONS_2
    local MAX_QUESTS = udg_MAX_QUESTS

    local CHUNK_SIZE = 150

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
    local TooltipSavedDigimons = nil ---@type FrameList
    local TooltipUsing = nil ---@type framehandle
    local TooltipSaved = nil ---@type framehandle
    local TooltipBackpack = nil ---@type framehandle
    local TooltipSavedItems = nil ---@type framehandle
    local TooltipMaterials = nil ---@type framehandle
    local TooltipQuests = nil ---@type framehandle
    local TooltipQuestsArea = nil ---@type FrameList
    local TooltipQuestsName = {} ---@type framehandle[]
    local AbsoluteSave = nil ---@type framehandle
    local AbsoluteLoad = nil ---@type framehandle
    local Exit = nil ---@type framehandle

    local NotOnline = false
    local QuestsAdded = {}
    local paused = __jarray(true)

    ---This function always should be in a "if player == GetLocalPlayer() then" block
    local function UpdateMenu()
        local list = PlayerDatas[LocalPlayer]
        for i = 1, 6 do
            if i == 6 then
                BlzFrameSetText(SaveSlotT[i-1], GetLocalizedString("SL_AUTO_SAVE"))
            else
                if list[i] then
                    BlzFrameSetText(SaveSlotT[i-1], GetLocalizedString("SL_SAVED_SLOT"):format(i))
                else
                    BlzFrameSetText(SaveSlotT[i-1], GetLocalizedString("SL_EMPTY_SLOT"):format(i))
                end
            end
        end
    end

    local days = {GetLocalizedString("SL_SUNDAY"), GetLocalizedString("SL_MONDAY"), GetLocalizedString("SL_TUESDAY"), GetLocalizedString("SL_WEDNESDAY"), GetLocalizedString("SL_THURSDAY"), GetLocalizedString("SL_FRIDAY"), GetLocalizedString("SL_SATURDAY")}
    local months = {GetLocalizedString("SL_JANUARY"), GetLocalizedString("SL_FEBRUARY"), GetLocalizedString("SL_MARCH"), GetLocalizedString("SL_APRIL"), GetLocalizedString("SL_MAY"), GetLocalizedString("SL_JUNE"), GetLocalizedString("SL_JULY"), GetLocalizedString("SL_AUGUST"), GetLocalizedString("SL_SEPTEMBER"), GetLocalizedString("SL_OCTOBER"), GetLocalizedString("SL_NOVEMBER"), GetLocalizedString("SL_DECEMBER")}

    ---@param template string
    ---@param valors osdate
    ---@return string
    local function replaceDate(template, valors)
        return (template:gsub("\x25$`(.-)`", function (k)
            if k == "wday" then
                return days[valors[k] or 1]
            elseif k == "month" then
                return months[valors[k] or 1]
            elseif k == "hour" or k == "min" or k == "sec" then
                return ("\x2502d"):format(valors[k] or 0)
            else
                return tostring(valors[k] or "?")
            end
        end))
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
            BlzFrameSetText(TooltipName, GetLocalizedString("SL_INFORMATION"))
            BlzFrameSetText(TooltipDate, replaceDate(GetLocalizedString("SL_DATE_FORMAT"), pData.date))
            BlzFrameSetText(TooltipGold, GetLocalizedString("SL_DIGIBITS") .. pData.gold)
            BlzFrameSetText(TooltipLumber, GetLocalizedString("SL_DIGICRYSTAL") .. pData.lumber)
            BlzFrameSetText(TooltipFood, GetLocalizedString("SL_TAMER_RANK") .. pData.food)
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
                    BlzFrameSetText(TooltipDigimonItemsT[index], GetLocalizedString("SL_ITEMS") .. s)
                    BlzFrameSetTexture(TooltipDigimonIconT[index], BlzGetAbilityIcon(dData.stocked[i].typeId), 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index], GetLocalizedString("SL_LEVEL"):format(math.floor(dData.stocked[i].level)))
                    BlzFrameSetText(TooltipDigimonStamina[index], GetLocalizedString("SL_STA") .. dData.stocked[i].lvlSta .. " (+" .. dData.stocked[i].IVsta .. ")")
                    BlzFrameSetText(TooltipDigimonDexterity[index], GetLocalizedString("SL_DEX") .. dData.stocked[i].lvlDex .. " (+" .. dData.stocked[i].IVdex .. ")")
                    BlzFrameSetText(TooltipDigimonWisdom[index], GetLocalizedString("SL_WIS") .. dData.stocked[i].lvlWis .. " (+" .. dData.stocked[i].IVwis .. ")")
                else
                    BlzFrameSetText(TooltipDigimonItemsT[index], GetLocalizedString("SL_ITEMS"))
                    BlzFrameSetTexture(TooltipDigimonIconT[index], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index], GetLocalizedString("SL_LEVEL"):format(0))
                    BlzFrameSetText(TooltipDigimonStamina[index], GetLocalizedString("SL_STA"))
                    BlzFrameSetText(TooltipDigimonDexterity[index], GetLocalizedString("SL_DEX"))
                    BlzFrameSetText(TooltipDigimonWisdom[index], GetLocalizedString("SL_WIS"))
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
                    BlzFrameSetText(TooltipDigimonItemsT[index], GetLocalizedString("SL_ITEMS") .. s)
                    BlzFrameSetTexture(TooltipDigimonIconT[index], BlzGetAbilityIcon(dData.saved[i].typeId), 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index],  GetLocalizedString("SL_LEVEL"):format(math.floor(dData.saved[i].level)))
                    BlzFrameSetText(TooltipDigimonStamina[index], GetLocalizedString("SL_STA") .. dData.saved[i].lvlSta .. " (+" .. dData.saved[i].IVsta .. ")")
                    BlzFrameSetText(TooltipDigimonDexterity[index], GetLocalizedString("SL_DEX") .. dData.saved[i].lvlDex .. " (+" .. dData.saved[i].IVdex .. ")")
                    BlzFrameSetText(TooltipDigimonWisdom[index], GetLocalizedString("SL_WIS") .. dData.saved[i].lvlWis .. " (+" .. dData.saved[i].IVwis .. ")")
                else
                    BlzFrameSetText(TooltipDigimonItemsT[index], GetLocalizedString("SL_ITEMS"))
                    BlzFrameSetTexture(TooltipDigimonIconT[index], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    BlzFrameSetText(TooltipDigimonLevelT[index],  GetLocalizedString("SL_LEVEL"):format(0))
                    BlzFrameSetText(TooltipDigimonStamina[index], GetLocalizedString("SL_STA"))
                    BlzFrameSetText(TooltipDigimonDexterity[index], GetLocalizedString("SL_DEX"))
                    BlzFrameSetText(TooltipDigimonWisdom[index], GetLocalizedString("SL_WIS"))
                end
            end
            BlzFrameSetText(TooltipSaved, GetLocalizedString("SL_MAX_SAVED"):format(dData.maxSaved))

            local result = ""
            for i = 1, bData.amount do
                result = result .. GetObjectName(bData.id[i]) .. "(" .. bData.charges[i] .. "), "
            end
            BlzFrameSetText(TooltipBackpack, GetLocalizedString("SL_BACKPACK") .. "\n" .. result:sub(1, result:len() - 2))

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
            BlzFrameSetText(TooltipSavedItems, GetLocalizedString("SL_MAX_SAVED_ITEMS"):format(dData.sItmsSto) .. "\n" .. result)

            result = ""
            for i = 1, pData.materials.count do
                result = result .. pData.materials.amounts[i] .. " " .. GetObjectName(pData.materials.itms[i]) .. ", "
            end
            BlzFrameSetText(TooltipMaterials, GetLocalizedString("SL_MATERIALS") .. "\n" .. result:sub(1, result:len() - 2))

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
            BlzFrameSetText(TooltipName, GetLocalizedString("SL_EMPTY_SLOT"))
            BlzFrameSetText(TooltipDate, GetLocalizedString("SL_DATE"))
            BlzFrameSetText(TooltipGold, GetLocalizedString("SL_DIGIBITS"))
            BlzFrameSetText(TooltipLumber, GetLocalizedString("SL_DIGICRYSTAL"))
            BlzFrameSetText(TooltipFood, GetLocalizedString("SL_TAMER_RANK"))
            for i = 0, MAX_DIGIMONS + MAX_SAVED - 1 do
                BlzFrameSetText(TooltipDigimonItemsT[i], GetLocalizedString("SL_ITEMS"))
                BlzFrameSetTexture(TooltipDigimonIconT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                BlzFrameSetText(TooltipDigimonLevelT[i], GetLocalizedString("SL_LEVEL"):format(0))
            end
            BlzFrameSetText(TooltipBackpack, GetLocalizedString("SL_BACKPACK"))
            BlzFrameSetText(TooltipSavedItems, GetLocalizedString("SL_SAVED_ITEMS_NO_MAX"))
            BlzFrameSetText(TooltipMaterials, GetLocalizedString("SL_MATERIALS_NO_MAX"))
            BlzFrameSetEnable(AbsoluteLoad, false)
        end
    end

    OnInit.final(function ()
        NotOnline = not udg_SaveOnSinglePlayer and GameStatus.get() ~= GameStatus.ONLINE

        PolledWait(1.)

        if NotOnline then
            print("You are on Singleplayer, save is disabled.")
            BlzFrameSetEnable(AbsoluteSave, false)
        else
            -- Auto-save
            local interval = 300.
            local timers = __jarray(0)
            ForForce(FORCE_PLAYING, function ()
                local p = GetEnumPlayer()
                timers[p] = interval

                Timed.echo(1., function ()
                    if not paused[p] and GetAllDigimonCount(p) > 0 then
                        timers[p] = timers[p] - 1.
                    end

                    if timers[p] <= 0. then
                        timers[p] = interval

                        if IsPlayerInGame(p) then
                            SavePlayerData(p, 6)
                            if p == LocalPlayer then
                                UpdateMenu()
                                UpdateInformation()
                            end
                        else
                            return true
                        end
                    end
                end)
            end)
        end
    end)

    local function SaveLoadActions(p, slot)
        local oldSlot = Pressed[p] - 1
        Pressed[p] = slot + 1
        if p == LocalPlayer then
            BlzFrameSetEnable(SaveSlotT[oldSlot], true)
            BlzFrameSetEnable(SaveSlotT[slot], false)
            BlzFrameSetVisible(Information, true)
            BlzFrameSetEnable(AbsoluteSave, slot ~= 5 and BlzFrameIsVisible(AbsoluteSave) and not NotOnline)
            BlzFrameSetEnable(AbsoluteLoad, BlzFrameIsVisible(AbsoluteLoad))
            UpdateInformation()
        end
    end

    local function ExitFunc(p)
        if p == LocalPlayer then
            BlzFrameSetEnable(SaveSlotT[Pressed[LocalPlayer] - 1], true)
            BlzFrameSetVisible(Information, false)
            BlzFrameSetVisible(SaveLoadMenu, false)
            RemoveButtonFromEscStack(Exit)
        end
        paused[p] = false
    end

    local function SaveFunc(p)
        ExitFunc(p)
        if p == LocalPlayer then
            if not BlzFrameIsVisible(SaveLoadMenu) then
                AddButtonToEscStack(Exit)
            end
            BlzFrameSetVisible(SaveLoadMenu, true)
            BlzFrameSetVisible(AbsoluteSave, true)
            BlzFrameSetEnable(AbsoluteSave, false)
            BlzFrameSetVisible(AbsoluteLoad, false)
            UpdateMenu()
        end
        paused[p] = true
    end

    local function LoadFunc(p)
        ExitFunc(p)
        if p == LocalPlayer then
            if not BlzFrameIsVisible(SaveLoadMenu) then
                AddButtonToEscStack(Exit)
            end
            BlzFrameSetVisible(SaveLoadMenu, true)
            BlzFrameSetVisible(AbsoluteSave, false)
            BlzFrameSetVisible(AbsoluteLoad, true)
            BlzFrameSetEnable(AbsoluteLoad, false)
            UpdateMenu()
        end
        paused[p] = true
    end

    local function AbsoluteSaveFunc(p)
        SavePlayerData(p, Pressed[p])
        if p == LocalPlayer then
            UpdateMenu()
            UpdateInformation()
        end
    end

    local function AbsoluteLoadFunc(p)
        TriggerExecute(gg_trg_Absolute_Load)
        SetPlayerData(p, Pressed[p])
        ExitFunc(p)
    end

    local function InitFrames()
        BlzLoadTOCFile("ButtonsTOC.toc")
        BlzLoadTOCFile("war3mapImported\\slider.toc")

        -- Save Button
        SaveButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(SaveButton, 9)
        BlzFrameSetVisible(SaveButton, false)
        AddFrameToMenu(SaveButton)
        SetFrameHotkey(SaveButton, "J")
        AddDefaultTooltip(SaveButton, GetLocalizedString("SL_SAVE"), GetLocalizedString("SL_SAVE_TOOLTIP"))

        BackdropSaveButton = BlzCreateFrameByType("BACKDROP", "BackdropSaveButton", SaveButton, "", 0)
        BlzFrameSetAllPoints(BackdropSaveButton, SaveButton)
        BlzFrameSetTexture(BackdropSaveButton, "ReplaceableTextures\\CommandButtons\\BTNSave.blp", 0, true)
        OnClickEvent(SaveButton, SaveFunc)

        -- Load Button

        LoadButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(LoadButton, 10)
        BlzFrameSetVisible(LoadButton, false)
        AddFrameToMenu(LoadButton)
        SetFrameHotkey(LoadButton, "K")
        AddDefaultTooltip(LoadButton, GetLocalizedString("SL_LOAD"), GetLocalizedString("SL_LOAD_TOOLTIP"))

        BackdropLoadButton = BlzCreateFrameByType("BACKDROP", "BackdropLoadButton", LoadButton, "", 0)
        BlzFrameSetAllPoints(BackdropLoadButton, LoadButton)
        BlzFrameSetTexture(BackdropLoadButton, "ReplaceableTextures\\CommandButtons\\BTNLoad.blp", 0, true)
        OnClickEvent(LoadButton, LoadFunc)

        -- Menu

        SaveLoadMenu = BlzCreateFrame("QuestButtonPushedBackdropTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0),0,0)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.27, 0.535000)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.280000)
        BlzFrameSetVisible(SaveLoadMenu, false)
        AddFrameToMenu(SaveLoadMenu)

        for i = 0, 5 do
            SaveSlotT[i] = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
            BlzFrameSetPoint(SaveSlotT[i], FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.010000, -0.01000 - i * 0.035)
            BlzFrameSetPoint(SaveSlotT[i], FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.21500 - i * 0.035)
            if i == 5 then
                BlzFrameSetText(SaveSlotT[i], GetLocalizedString("SL_AUTO_SAVE"))
            else
                BlzFrameSetText(SaveSlotT[i], GetLocalizedString("SL_EMPTY"))
            end
            OnClickEvent(SaveSlotT[i], function (p) SaveLoadActions(p, i) end) -- :D
        end

        AbsoluteSave = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(AbsoluteSave, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.22000)
        BlzFrameSetPoint(AbsoluteSave, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.0050000)
        BlzFrameSetText(AbsoluteSave, GetLocalizedString("SL_ABSOLUTE_SAVE"))
        BlzFrameSetVisible(AbsoluteSave, false)
        OnClickEvent(AbsoluteSave, AbsoluteSaveFunc)

        AbsoluteLoad = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(AbsoluteLoad, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.22000)
        BlzFrameSetPoint(AbsoluteLoad, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.0050000)
        BlzFrameSetText(AbsoluteLoad, GetLocalizedString("SL_ABSOLUTE_LOAD"))
        BlzFrameSetVisible(AbsoluteLoad, false)
        OnClickEvent(AbsoluteLoad, AbsoluteLoadFunc)

        Exit = BlzCreateFrame("ScriptDialogButton", SaveLoadMenu,0,0)
        BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, 0.12000, -0.22000)
        BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.0050000)
        BlzFrameSetText(Exit, GetLocalizedString("SL_EXIT"))
        OnClickEvent(Exit, ExitFunc)

        -- Tooltip

        Information = BlzCreateFrame("CheckListBox", SaveLoadMenu, 0, 0)
        BlzFrameSetPoint(Information, FRAMEPOINT_TOPLEFT, SaveLoadMenu, FRAMEPOINT_TOPLEFT, -0.50000, 0.0050000)
        BlzFrameSetPoint(Information, FRAMEPOINT_BOTTOMRIGHT, SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, -0.22000, -0.26000)
        BlzFrameSetLevel(Information, 100)

        TooltipName = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(TooltipName, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.49000)
        BlzFrameSetText(TooltipName, "|cffff6600Name|r")
        BlzFrameSetTextAlignment(TooltipName, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipDate = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipDate, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.25000, -0.010000)
        BlzFrameSetPoint(TooltipDate, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.49000)
        BlzFrameSetText(TooltipDate, "Date")
        BlzFrameSetTextAlignment(TooltipDate, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)

        TooltipGold = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipGold, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(TooltipGold, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.33000, 0.47000)
        BlzFrameSetText(TooltipGold, "|cffFFCC00Gold: |r")
        BlzFrameSetTextAlignment(TooltipGold, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipLumber = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipLumber, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.17000, -0.030000)
        BlzFrameSetPoint(TooltipLumber, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.17000, 0.47000)
        BlzFrameSetText(TooltipLumber, "|cff20bc20Lumber: |r")
        BlzFrameSetTextAlignment(TooltipLumber, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipFood = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipFood, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.33000, -0.030000)
        BlzFrameSetPoint(TooltipFood, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.47000)
        BlzFrameSetText(TooltipFood, "|cffa34f00Food: |r")
        BlzFrameSetTextAlignment(TooltipFood, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipUsing = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipUsing, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.050000)
        BlzFrameSetPoint(TooltipUsing, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.38500, 0.45000)
        BlzFrameSetText(TooltipUsing, "|cff00eeffUsing:|r")
        BlzFrameSetTextAlignment(TooltipUsing, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipSaved = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipSaved, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.25000)
        BlzFrameSetPoint(TooltipSaved, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.38500, 0.25000)
        BlzFrameSetText(TooltipSaved, "|cff00eeffSaved:|r")
        BlzFrameSetTextAlignment(TooltipSaved, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        TooltipSavedDigimonsBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", Information, "", 1)
        BlzFrameSetPoint(TooltipSavedDigimonsBackdrop, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.015000, -0.27050)
        BlzFrameSetPoint(TooltipSavedDigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.015000, 0.12950)
        BlzFrameSetTexture(TooltipSavedDigimonsBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)

        TooltipSavedDigimons = FrameList.create(false, TooltipSavedDigimonsBackdrop)
        BlzFrameSetPoint(TooltipSavedDigimons.Frame, FRAMEPOINT_TOPLEFT, TooltipSavedDigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.000, 0.00000)
        TooltipSavedDigimons:setSize(0.47, 0.126)

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

        local amount = 3
        local row

        for i = 0, MAX_DIGIMONS + MAX_SAVED - 1 do
            if i < MAX_DIGIMONS then
                TooltipDigimonT[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", Information, "", 1)
                BlzFrameSetPoint(TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
                BlzFrameSetPoint(TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])
            else
                if amount >= 3 then
                    amount = 0
                    row = BlzCreateFrameByType("BACKDROP", "row", TooltipSavedDigimonsBackdrop, "", 1)
                    BlzFrameSetSize(row, 0.47000, 0.06000)
                    BlzFrameSetTexture(row, "war3mapImported\\EmptyBTN.blp", 0, true)
                end

                TooltipDigimonT[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", row, "", 1)
                BlzFrameSetPoint(TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, row, FRAMEPOINT_TOPLEFT, amount*0.16500, 0.0000)
                BlzFrameSetPoint(TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, row, FRAMEPOINT_BOTTOMRIGHT, -0.33 + amount*0.16500, 0.0150)

                if amount == 0 then
                    TooltipSavedDigimons:add(row)
                end
                amount = amount + 1
            end
            BlzFrameSetTexture(TooltipDigimonT[i], "war3mapImported\\EmptyBTN.blp", 0, true)

            TooltipDigimonIconT[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", TooltipDigimonT[i], "", 1)
            BlzFrameSetPoint(TooltipDigimonIconT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.0017500)
            BlzFrameSetPoint(TooltipDigimonIconT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.10750, 0.016500)
            BlzFrameSetTexture(TooltipDigimonIconT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

            TooltipDigimonItemsT[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonItemsT[i], 0.75)
            BlzFrameSetPoint(TooltipDigimonItemsT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.045000, -0.0032500)
            BlzFrameSetPoint(TooltipDigimonItemsT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0045000, 0.010000)
            BlzFrameSetText(TooltipDigimonItemsT[i], "|cff00ffffItems:|r")
            BlzFrameSetTextAlignment(TooltipDigimonItemsT[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            TooltipDigimonLevelT[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetPoint(TooltipDigimonLevelT[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.0037500, -0.040750)
            BlzFrameSetPoint(TooltipDigimonLevelT[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.10625, 0.0000)
            BlzFrameSetText(TooltipDigimonLevelT[i], "|cffFFCC00Level 0|r")
            BlzFrameSetTextAlignment(TooltipDigimonLevelT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

            TooltipDigimonStamina[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonStamina[i], 0.65)
            BlzFrameSetPoint(TooltipDigimonStamina[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.045000, -0.045750)
            BlzFrameSetPoint(TooltipDigimonStamina[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.071500, 0.0000)
            BlzFrameSetText(TooltipDigimonStamina[i], "")
            BlzFrameSetTextAlignment(TooltipDigimonStamina[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            TooltipDigimonDexterity[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonDexterity[i], 0.65)
            BlzFrameSetPoint(TooltipDigimonDexterity[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.078500, -0.045750)
            BlzFrameSetPoint(TooltipDigimonDexterity[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.038000, 0.0000)
            BlzFrameSetText(TooltipDigimonDexterity[i], "")
            BlzFrameSetTextAlignment(TooltipDigimonDexterity[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            TooltipDigimonWisdom[i] = BlzCreateFrameByType("TEXT", "name", TooltipDigimonT[i], "", 0)
            BlzFrameSetScale(TooltipDigimonWisdom[i], 0.65)
            BlzFrameSetPoint(TooltipDigimonWisdom[i], FRAMEPOINT_TOPLEFT, TooltipDigimonT[i], FRAMEPOINT_TOPLEFT, 0.11200, -0.045750)
            BlzFrameSetPoint(TooltipDigimonWisdom[i], FRAMEPOINT_BOTTOMRIGHT, TooltipDigimonT[i], FRAMEPOINT_BOTTOMRIGHT, -0.0045000, 0.0000)
            BlzFrameSetText(TooltipDigimonWisdom[i], "")
            BlzFrameSetTextAlignment(TooltipDigimonWisdom[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
        end

        TooltipBackpack = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipBackpack, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.010000, -0.39000)
        BlzFrameSetPoint(TooltipBackpack, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.34000, 0.010000)
        BlzFrameSetText(TooltipBackpack, "|cff3874ffBackpack:|r")
        BlzFrameSetTextAlignment(TooltipBackpack, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipSavedItems = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipSavedItems, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.17500, -0.39000)
        BlzFrameSetPoint(TooltipSavedItems, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.075000)
        BlzFrameSetText(TooltipSavedItems, "|cff4566ffSaved Items:|r")
        BlzFrameSetTextAlignment(TooltipSavedItems, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipMaterials = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipMaterials, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.17500, -0.45500)
        BlzFrameSetPoint(TooltipMaterials, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.010000)
        BlzFrameSetText(TooltipMaterials, "|cff3874ffMaterials:|r")
        BlzFrameSetTextAlignment(TooltipMaterials, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipQuests = BlzCreateFrameByType("TEXT", "name", Information, "", 0)
        BlzFrameSetPoint(TooltipQuests, FRAMEPOINT_TOPLEFT, Information, FRAMEPOINT_TOPLEFT, 0.34000, -0.39000)
        BlzFrameSetPoint(TooltipQuests, FRAMEPOINT_BOTTOMRIGHT, Information, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.030000)
        BlzFrameSetText(TooltipQuests, "|cff5257ffQuests:|r")
        BlzFrameSetTextAlignment(TooltipQuests, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        TooltipQuestsArea = FrameList.create(false, TooltipQuests)
        BlzFrameSetPoint(TooltipQuestsArea.Frame, FRAMEPOINT_TOPLEFT, TooltipQuests, FRAMEPOINT_TOPLEFT, 0.0000, -0.010000)
        BlzFrameSetPoint(TooltipQuestsArea.Frame, FRAMEPOINT_BOTTOMRIGHT, TooltipQuests, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
        TooltipQuestsArea:setSize(BlzFrameGetWidth(TooltipQuestsArea.Frame), BlzFrameGetHeight(TooltipQuestsArea.Frame) - 0.02)

        Timed.call(function ()
            for i = 0, MAX_QUESTS do
                TooltipQuestsName[i] = BlzCreateFrameByType("TEXT", "name", TooltipQuests, "", 0)
                BlzFrameSetSize(TooltipQuestsName[i], 0.13, 0.015)
                BlzFrameSetText(TooltipQuestsName[i], GetQuestName(i))
                BlzFrameSetTextAlignment(TooltipQuestsName[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
                BlzFrameSetVisible(TooltipQuestsName[i], false)
            end
        end)
    end

    FrameLoaderAdd(InitFrames)

    OnChangeDimensions(function ()
        BlzFrameClearAllPoints(SaveLoadMenu)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.27, 0.535000)
        BlzFrameSetAbsPoint(SaveLoadMenu, FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.280000)
    end)

    OnLeaderboard(function ()
        BlzFrameSetParent(SaveLoadMenu, BlzGetFrameByName("Leaderboard", 0))
    end)

    OnInit.final(function ()
        -- I don't know why I should add this
        local buffer =  BlzCreateFrameByType("BACKDROP", "row", TooltipSavedDigimonsBackdrop, "", 1)
        BlzFrameSetSize(buffer, 0.47000, 0.06000)
        BlzFrameSetTexture(buffer, "war3mapImported\\EmptyBTN.blp", 0, true)
        TooltipSavedDigimons:add(buffer)
    end)

    -- Functions to use

    ---@param p player
    ---@param flag boolean
    function ShowSave(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(SaveButton, flag)
            if not flag then
                BlzFrameSetEnable(SaveLoadMenu, false)
            end
        end
    end

    ---@param p player
    ---@param flag boolean
    function ShowLoad(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(LoadButton, flag)
            if not flag then
                BlzFrameSetEnable(SaveLoadMenu, false)
            end
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

    local oldGetOwningPlayer
    oldGetOwningPlayer = AddHook("GetOwningPlayer", function (whichUnit)
        if not whichUnit then
            error("You are trying to get the owner of no unit.", 2)
        end
        local p = oldGetOwningPlayer(whichUnit)
        if not p then
            error("It wasn't possible to get the owner of this unit.", 2)
        end
        return p
    end)
end)
Debug.endFile()