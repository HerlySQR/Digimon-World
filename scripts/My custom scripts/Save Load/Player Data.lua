Debug.beginFile("Player Data")
OnInit("Player Data", function ()
    Require "PlayerDigimons"
    Require "AddHook"
    Require "Quests"

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
    ---@field digimons integer[]
    ---@field isSaved integer[]
    ---@field inventories Inventory[]
    ---@field levels integer[]
    ---@field experiences integer[]
    ---@field completedQuests integer
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
        local newList = {}
        for i = #list, 1, -1 do
            table.insert(newList, list[i])
        end
        return newList
    end

    ---Since the save-load system loads the data in the reverse order, I have to reverse it again
    ---@param list table
    ---@param begin? integer
    ---@param final? integer
    ---@return table
    local function reverseManual(list, begin, final)
        local newList = {}
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
        if not save then
            for i = 1, #udg_SaveLoadInventories do
                local inv = udg_SaveLoadInventories[i]
                inv.items = reverseManual(inv.items, 0, 5)
                inv.charges = reverseManual(inv.charges, 0, 5)
                inv.classes = reverseManual(inv.classes, 0, 5)
            end
        end

        -- This overwrites the slot if was previously set
        PlayerDatas[p][slot] = {
            gold = udg_SaveLoadGold,
            lumber = udg_SaveLoadLumber,
            food = udg_SaveLoadFood,
            backpackItems = save and udg_SaveLoadBackpackItems or reverse(udg_SaveLoadBackpackItems),
            backpackItemCharges = save and udg_SaveLoadBackpackItemCharges or reverse(udg_SaveLoadBackpackItemCharges),
            digimons = save and udg_SaveLoadDigimons or reverse(udg_SaveLoadDigimons),
            isSaved = save and udg_SaveLoadIsSaved or reverse(udg_SaveLoadIsSaved),
            inventories = save and udg_SaveLoadInventories or reverse(udg_SaveLoadInventories),
            levels = save and udg_SaveLoadLevels or reverse(udg_SaveLoadLevels),
            experiences = save and udg_SaveLoadExps or reverse(udg_SaveLoadExps),
            completedQuests = udg_SaveLoadCompletedQuests
        }

        udg_SaveLoadBackpackItems = {}
        udg_SaveLoadBackpackItemCharges = {}
        udg_SaveLoadDigimons = {}
        udg_SaveLoadIsSaved = __jarray(0)
        udg_SaveLoadInventories = {}
        udg_SaveLoadLevels = __jarray(0)
        udg_SaveLoadExps = __jarray(0)
    end

    ---Clears all the data of the player
    ---@param p player
    function RestartData(p)
        for i = 0, udg_MAX_DIGIMONS - 1 do
            pcall(function ()
                RemoveFromBank(p, i):destroy() -- Also remove from the stored
            end)
        end
        for i = 0, udg_MAX_SAVED_DIGIMONS - 1 do
            pcall(function ()
                RemoveSavedDigimon(p, i)
            end)
        end
        SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, 0)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, 0)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED, 0)
        SetBackpackItems(p, nil)
        ClearDigimons(p)
        SetCompletedQuests(p, 0)
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
                for i = 1, #data.digimons do
                    local d = Digimon.create(p, data.digimons[i], 0, 0, bj_UNIT_FACING)
                    data.inventories[i]:useTheItems(d.root)
                    --d:setLevel(math.max(1, data.levels[i])) -- Just in case
                    --d:setExp(d:getExp() + data.experiences[i])
                    d:setExp(data.experiences[i])
                    if data.isSaved[i] == 0 then
                        StoreDigimon(p, d)
                        SendToBank(p, d)
                    else
                        SaveDigimon(p, d)
                    end
                end
                SetCompletedQuests(p, data.completedQuests)
            end
        end
    end

    function ClearSaveLoadData()
        udg_SaveLoadGold = 0
        udg_SaveLoadLumber = 0
        udg_SaveLoadFood = 0
        udg_SaveLoadBackpackItems = {}
        udg_SaveLoadBackpackItemCharges = {}
        udg_SaveLoadDigimons = {}
        udg_SaveLoadInventories = {}
        udg_SaveLoadLevels = __jarray(0)
        udg_SaveLoadExps = __jarray(0)
        udg_SaveLoadCompletedQuests = 0
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