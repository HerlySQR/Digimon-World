do

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
                end
            end
        end

        function Inventory:destroy()
            self.items = nil
            self.charges = nil
        end
    end

    PlayerDatas = {}

    OnTrigInit(function ()
        for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
            PlayerDatas[Player(i)] = {}
        end
    end)

    ---After set the GUI variables use this function to store them in a slot
    ---@param p player
    ---@param slot integer
    function StoreData(p, slot)
        -- This overwrites the slot if was previously set
        PlayerDatas[p][slot] = {
            gold = udg_SaveLoadGold, ---@type integer
            lumber = udg_SaveLoadLumber, ---@type integer
            food = udg_SaveLoadFood, ---@type integer
            digimons = udg_SaveLoadDigimons, ---@type Digimon[]
            inventories = udg_SaveLoadInventories, ---@type Inventory[]
            levels = udg_SaveLoadLevels, ---@type integer[]
            experiences = udg_SaveLoadExps, ---@type integer[]
        }

        udg_SaveLoadDigimons = {}
        udg_SaveLoadInventories = {}
        udg_SaveLoadLevels = __jarray(0)
        udg_SaveLoadExps = __jarray(0)
    end

    ---After store the data use this function from the slot to use them
    ---@param p player
    ---@param slot integer
    function UseData(p, slot)
        if PlayerDatas[p] then
            local data = PlayerDatas[p][slot]
            if data then
                -- Flush the previous data
                for i = 0, 5 do
                    pcall(function ()
                        RemoveFromBank(p, i):destroy() -- Also remove from the stored
                    end)
                end
                -- Use the new data
                SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, data.gold)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, data.lumber)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED, data.food)
                for i = 1, #data.digimons do
                    local d = Digimon.create(p, data.digimons[i], 0, 0, bj_UNIT_FACING)
                    data.inventories[i]:useTheItems(d.root)
                    --d:setLevel(math.max(1, data.levels[i])) -- Just in case
                    --d:setExp(d:getExp() + data.experiences[i])
                    d:setExp(data.experiences[i])
                    StoreDigimon(p, d)
                    SendToBank(p, d)
                end
            end
        end
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

end