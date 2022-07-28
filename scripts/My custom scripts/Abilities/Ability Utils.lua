do

    LOCUST_ID = FourCC('Aloc')

    ARMOR_REDUCE_SPELL = FourCC('A01R')
    ARMOR_REDUCE_ORDER = Orders.innerfire

    ICE_SPELL = FourCC('A01J')
    ICE_ORDER = Orders.frostnova

    FREEZE_SPELL = FourCC('A01L')
    FREEZE_ORDER = Orders.entanglingroots

    STUN_SPELL = FourCC('A01S')
    STUN_ORDER = Orders.thunderbolt

    POISON_SPELL = FourCC('A01U')
    POISON_ORDER = Orders.shadowstrike

    CURSE_SPELL = FourCC('A01Y')
    CURSE_ORDER = Orders.curse

    SLEEP_SPELL = FourCC('A021')
    SLEEP_ORDER = Orders.thunderbolt

    SLOW_SPELL = FourCC('A02G')
    SLOW_ORDER = Orders.slow

    PURGE_SPELL = FourCC('A034')
    PURGE_ORDER = Orders.purge

    -- Remove sleep when is attacked
    local SLEEP_BUFF = FourCC('B005')
    OnMapInit(function ()
        Digimon.postDamageEvent(function (info)
            if info.target:hasAbility(SLEEP_BUFF) and not udg_IsDamageCode then
                info.target:removeAbility(SLEEP_BUFF)
            end
        end)
    end)

    ---Return a damage based in the hero attributes
    ---@param caster unit
    ---@param strFactor real
    ---@param agiFactor real
    ---@param intFactor real
    ---@return real
    function GetAttributeDamage(caster, strFactor, agiFactor, intFactor)
        return GetHeroStr(caster, true) * strFactor +
               GetHeroAgi(caster, true) * agiFactor +
               GetHeroInt(caster, true) * intFactor
    end

    ---Returns the avarage attack damage of the unit
    ---@param caster unit
    ---@return real
    function GetAvarageAttack(caster)
        local base = BlzGetUnitWeaponIntegerField(caster, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
        local dice = BlzGetUnitWeaponIntegerField(caster, UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE, 0)
        local side = BlzGetUnitWeaponIntegerField(caster, UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE, 0)
        return base + (dice * (side + 1)) / 2
    end

    ---Returns the distance between the given coords
    ---@param x1 real
    ---@param y1 real
    ---@param x2 real
    ---@param y2 real
    ---@return real
    function DistanceBetweenCoords(x1, y1, x2, y2)
        return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
    end

    ---Returns the squared distance between the given coords
    ---@param x1 real
    ---@param y1 real
    ---@param x2 real
    ---@param y2 real
    ---@return real
    function DistanceBetweenCoordsSq(x1, y1, x2, y2)
        return (x1 - x2)^2 + (y1 - y2)^2
    end

    local MAX_RANGE = 100.
    local DUMMY_ITEM = nil ---@type item
    local SEARCH_RECT = nil ---@type rect
    local hiddenItems = {} ---@type item[]
    OnMapInit(function ()
        DUMMY_ITEM = CreateItem(FourCC('wolg'), 0, 0)
        SetItemVisible(DUMMY_ITEM, false)
        SEARCH_RECT = Rect(0, 0, 128, 128)
    end)

    ---@param x real
    ---@param y real
    ---@return boolean
    function IsTerrainWalkable(x, y)
        -- Hide any items in the area to avoid conflicts with our item
        MoveRectTo(SEARCH_RECT, x, y)
        EnumItemsInRect(SEARCH_RECT, nil, function ()
            if IsItemVisible(GetEnumItem()) then
                table.insert(hiddenItems, GetEnumItem())
            end
        end)

        -- Try to move the test item and get its coords
        SetItemPosition(DUMMY_ITEM, x, y) -- Unhides the item
        local tempX, tempY = GetItemX(DUMMY_ITEM), GetItemY(DUMMY_ITEM)
        SetItemVisible(DUMMY_ITEM, false) -- Hide it again

        -- Unhide any items hidden at the start
        for i = 1, #hiddenItems do
            SetItemVisible(hiddenItems[i], true)
        end
        hiddenItems = {}

        return DistanceBetweenCoordsSq(x, y, tempX, tempY) <= MAX_RANGE and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
    end

end