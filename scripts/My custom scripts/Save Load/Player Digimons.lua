Debug.beginFile("PlayerDigimons")
OnInit("PlayerDigimons", function ()
    Require "Digimon"

    local MAX_DIGIMONS = udg_MAX_DIGIMONS

    local digimons = {}

    for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
        digimons[Player(i)] = {}
    end

    ---@param owner player
    ---@param d Digimon
    ---@return boolean
    function StoreDigimon(owner, d)
        local list = digimons[owner]
        if #list < MAX_DIGIMONS then
            table.insert(list, d)
            return true
        end
        return false
    end

    ---Not recommended
    ---@param owner player
    ---@param u unit
    ---@return boolean
    function StoreDigimonByUnit(owner, u)
        return StoreDigimon(owner, Digimon.getInstance(u))
    end

    ---@param owner player
    ---@param d Digimon
    ---@return boolean
    function ReleaseDigimon(owner, d)
        local list = digimons[owner]
        for i = 1, #list do
            if list[i] == d then
                table.remove(list, i)
                return true
            end
        end
        return false
    end

    ---Not recommended
    ---@param owner player
    ---@param u unit
    ---@return boolean
    function ReleaseDigimonByUnit(owner, u)
        return ReleaseDigimon(owner, Digimon.getInstance(u))
    end

    ---@param owner player
    ---@return Digimon[]
    function GetDigimons(owner)
        return digimons[owner]
    end

    ---@param owner player
    ---@return integer
    function GetDigimonCount(owner)
        return #digimons[owner]
    end

    ---@param owner player
    ---@return boolean
    function IsFullOfDigimons(owner)
        return #digimons[owner] == MAX_DIGIMONS
    end

    ---@param owner player
    function ClearDigimons(owner)
        digimons[owner] = {}
    end

    ---@param owner player
    ---@return Digimon[]
    function GetAllDigimons(owner)
        local list = {}
        for _, v in ipairs(digimons[owner]) do
            table.insert(list, v)
        end
        for _, v in ipairs(GetSavedDigimons(owner)) do
            table.insert(list, v)
        end
        return list
    end
end)
Debug.endFile()