Debug.beginFile("Player Data")
OnInit("Player Data", function ()
    Require "PlayerDigimons"
    Require "AddHook"
    Require "Quests"
    Require "WorldBounds"
    Require "EventListener"
    Require "Cosmetic"

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

    do
        ---@class Inventory
        ---@field items integer[] -- (raw code)
        ---@field charges integer[]
        ---@field classes integer[]
        Inventory = {}
        Inventory.__index = Inventory

        ---@return Inventory
        function Inventory.create()
            local self = setmetatable({}, Inventory)

            self.items = {}
            self.charges = {}
            self.classes = {}

            return self
        end

        ---@param id integer
        ---@param charge integer
        ---@param index integer
        function Inventory:add(id, charge, index, class)
            index = index - 1
            self.items[index] = id
            self.charges[index] = charge
            self.classes[index] = class
        end

        ---@param u unit
        function Inventory:useTheItems(u)
            for i = 0, 5 do
                if self.items[i] then
                    local m = UnitAddItemById(u, self.items[i])
                    UnitDropItemSlot(u, m, i)
                    if self.charges[i] > 1 then
                        SetItemCharges(m, self.charges[i])
                    end
                    SetItemPlayer(m, GetOwningPlayer(u), true)
                end
            end
        end

        function Inventory:destroy()
            self.items = nil
            self.charges = nil
        end
    end

    ---@class PlayerData
    ---@field gold integer
    ---@field lumber integer
    ---@field food integer
    ---@field backpackItems integer[]
    ---@field backpackItemCharges integer[]
    ---@field bankItems integer[]
    ---@field bankItemCharges integer[]
    ---@field bankItemsMaxStock integer
    ---@field digimons integer[]
    ---@field strLevels integer[]
    ---@field agiLevels integer[]
    ---@field intLevels integer[]
    ---@field IVsta integer[]
    ---@field IVdex integer[]
    ---@field IVwis integer[]
    ---@field isSaved integer[]
    ---@field bankDigimonsMaxStock integer
    ---@field inventories Inventory[]
    ---@field levels integer[]
    ---@field experiences integer[]
    ---@field questsIds integer[]
    ---@field questsProgresses integer[]
    ---@field questsIsCompleted boolean[]
    ---@field completedQuests integer
    ---@field date osdate
    ---@field usedCosmetics table<integer, integer[]>
    ---@field vistedPlaces boolean[]

    PlayerDatas = {} ---@type table<player, PlayerData[]>

    for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
        PlayerDatas[Player(i)] = {}
    end

    udg_SaveLoadBackpackItems = {}
    udg_SaveLoadBackpackItemCharges = {}
    udg_SaveLoadDigimons = {}
    udg_SaveLoadInventories = {}

    ---Since the save-load system loads the data in the reverse order, I have to reverse it again
    ---@param list table
    ---@return table
    local function reverse(list)
        local newList = setmetatable({}, getmetatable(list))
        for i = #list, 1, -1 do
            table.insert(newList, list[i])
        end
        return newList
    end

    ---Since the save-load system loads the data in the reverse order, I have to reverse it again
    ---@param list table
    ---@param begin integer
    ---@param final integer
    ---@return table
    local function reverseManual(list, begin, final)
        local newList = setmetatable({}, getmetatable(list))
        for i = final, begin, -1 do
            newList[final + begin - i] = list[i]
        end
        return newList
    end

    ---After set the GUI variables use this function to store them in a slot
    ---@param p player
    ---@param slot integer
    ---@param save? boolean
    function StoreData(p, slot, save)
        -- This overwrites the slot if was previously set
        PlayerDatas[p][slot] = {
            gold = udg_SaveLoadGold,
            lumber = udg_SaveLoadLumber,
            food = udg_SaveLoadFood,
            backpackItems = save and udg_SaveLoadBackpackItems or reverse(udg_SaveLoadBackpackItems),
            backpackItemCharges = save and udg_SaveLoadBackpackItemCharges or reverse(udg_SaveLoadBackpackItemCharges),
            bankItems = save and udg_SaveLoadBankItems or reverse(udg_SaveLoadBankItems),
            bankItemCharges = save and udg_SaveLoadBankItemsCharges or reverse(udg_SaveLoadBankItemsCharges),
            bankItemsMaxStock = udg_SaveLoadBankItemsMaxStock,
            digimons = save and udg_SaveLoadDigimons or reverse(udg_SaveLoadDigimons),
            strLevels = save and udg_SaveLoadDigimonStrLevels or reverse(udg_SaveLoadDigimonStrLevels),
            agiLevels = save and udg_SaveLoadDigimonAgiLevels or reverse(udg_SaveLoadDigimonAgiLevels),
            intLevels = save and udg_SaveLoadDigimonIntLevels or reverse(udg_SaveLoadDigimonIntLevels),
            IVsta = save and udg_SaveLoadDigimonIVSta or reverse(udg_SaveLoadDigimonIVSta),
            IVdex = save and udg_SaveLoadDigimonIVDex or reverse(udg_SaveLoadDigimonIVDex),
            IVwis = save and udg_SaveLoadDigimonIVWis or reverse(udg_SaveLoadDigimonIVWis),
            isSaved = save and udg_SaveLoadIsSaved or reverse(udg_SaveLoadIsSaved),
            bankDigimonsMaxStock = udg_SaveLoadBankDigimonsMaxStock,
            inventories = save and udg_SaveLoadInventories or reverse(udg_SaveLoadInventories),
            levels = save and udg_SaveLoadLevels or reverse(udg_SaveLoadLevels),
            experiences = save and udg_SaveLoadExps or reverse(udg_SaveLoadExps),
            questsIds = save and udg_SaveLoadQuestIds or reverse(udg_SaveLoadQuestIds),
            questsProgresses = save and udg_SaveLoadQuestProgresses or reverse(udg_SaveLoadQuestProgresses),
            questsIsCompleted = save and udg_SaveLoadQuestIsCompleted or reverse(udg_SaveLoadQuestIsCompleted),
            completedQuests = udg_SaveLoadCompletedQuests,
            date = {sec = udg_SaveLoadSec, min = udg_SaveLoadMin, hour = udg_SaveLoadHour, day = udg_SaveLoadDay,
                month = udg_SaveLoadMonth, year = udg_SaveLoadYear, wday = udg_SaveLoadWDay, yday = udg_SaveLoadYDay,
                isdst = udg_SaveLoadIsDst},
            usedCosmetics = udg_SaveLoadUsedCosmetics,
            vistedPlaces = udg_SaveLoadVisitedPlaces
        }

        ClearSaveLoadData()
    end

    ---Clears all the data of the player
    ---@param p player
    function RestartData(p)
        for i = 0, udg_MAX_DIGIMONS - 1 do
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
        ClearDigimons(p)
        SetQuestsData(p)

        restartListener:run(p)
    end

    ---After store the data use this function from the slot to use them
    ---@param p player
    ---@param slot integer
    function UseData(p, slot)
        if PlayerDatas[p] then
            -- Flush the previous data
            RestartData(p)

            -- Use the new data
            local data = PlayerDatas[p][slot]
            if data then
                SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, data.gold)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, data.lumber)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED, data.food)
                SetBackpackItems(p, data.backpackItems, data.backpackItemCharges)
                SetBankItems(p, data.bankItems, data.bankItemCharges, data.bankItemsMaxStock)
                SetMaxSavedDigimons(p, data.bankDigimonsMaxStock)
                for i = 1, #data.digimons do
                    local d = Digimon.create(p, data.digimons[i], 0, 0, bj_UNIT_FACING)
                    local count1 = 0
                    Timed.echo(0, function ()
                        count1 = count1 + 1
                        if count1 <= data.strLevels[i] then
                            SelectHeroSkill(d.root, udg_STAMINA_TRAINING)
                        else
                            return true
                        end
                    end)
                    local count2 = 0
                    Timed.echo(0, function ()
                        count2 = count2 + 1
                        if count2 <= data.agiLevels[i] then
                            SelectHeroSkill(d.root, udg_DEXTERITY_TRAINING)
                        else
                            return true
                        end
                    end)
                    local count3 = 0
                    Timed.echo(0, function ()
                        count3 = count3 + 1
                        if count3 <= data.intLevels[i] then
                            SelectHeroSkill(d.root, udg_WISDOM_TRAINING)
                        else
                            return true
                        end
                    end)
                    d:setIV(data.IVsta[i], data.IVdex[i], data.IVwis[i])
                    data.inventories[i]:useTheItems(d.root)
                    --d:setLevel(math.max(1, data.levels[i])) -- Just in case
                    --d:setExp(d:getExp() + data.experiences[i])
                    d:setExp(data.experiences[i])
                    if data.isSaved[i] == 1 then
                        SaveDigimon(p, d)
                    else
                        StoreDigimon(p, d)
                        SendToBank(p, d)
                    end
                    local cosmetics = data.usedCosmetics[i]
                    if cosmetics then
                        for j = 1, #cosmetics do
                            ApplyCosmetic(p, cosmetics[j], d)
                        end
                    end
                end
                SetQuestsData(p, data.questsIds, data.questsProgresses, data.questsIsCompleted)

                ApplyVisitedPlaces(p, data.vistedPlaces)

                loadListener:run(p)
            end
        end
    end

    function ClearSaveLoadData()
        udg_SaveLoadGold = 0
        udg_SaveLoadLumber = 0
        udg_SaveLoadFood = 0
        udg_SaveLoadBackpackItems = __jarray(0)
        udg_SaveLoadBackpackItemCharges = __jarray(0)
        udg_SaveLoadBankItems = __jarray(0)
        udg_SaveLoadBankItemsCharges = __jarray(0)
        udg_SaveLoadBankItemsMaxStock = 0
        udg_SaveLoadDigimons = {}
        udg_SaveLoadDigimonStrLevels = __jarray(0)
        udg_SaveLoadDigimonAgiLevels = __jarray(0)
        udg_SaveLoadDigimonIntLevels = __jarray(0)
        udg_SaveLoadDigimonIVSta = __jarray(0)
        udg_SaveLoadDigimonIVDex = __jarray(0)
        udg_SaveLoadDigimonIVWis = __jarray(0)
        udg_SaveLoadIsSaved = __jarray(0)
        udg_SaveLoadBankDigimonsMaxStock = 0
        udg_SaveLoadInventories = {}
        udg_SaveLoadLevels = __jarray(0)
        udg_SaveLoadExps = __jarray(0)
        udg_SaveLoadCompletedQuests = 0
        udg_SaveLoadQuestIds = __jarray(0)
        udg_SaveLoadQuestProgresses = __jarray(0)
        udg_SaveLoadQuestIsCompleted = __jarray(false)
        udg_SaveLoadSec = 0
        udg_SaveLoadMin = 0
        udg_SaveLoadHour = 0
        udg_SaveLoadDay = 1
        udg_SaveLoadMonth = 1
        udg_SaveLoadYear = 1970
        udg_SaveLoadWDay = 1
        udg_SaveLoadYDay = 1
        udg_SaveLoadIsDst = false
        udg_SaveLoadUsedCosmetic = 1
    end

    ---I prefered create my own level XP function
    ---@param lvl integer
    ---@return integer
    function GetLevelXP(lvl)
        local xp = 0
        if lvl > 0 then
            xp = udg_HeroXPRequired
            for i = 2, lvl do
                xp = xp * udg_HeroXPPrevLevelFactor + (i+1) * udg_HeroXPLevelFactor + udg_HeroXPConstant -- I don't get the "+1"
            end
        end
        return xp
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