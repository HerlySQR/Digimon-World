OnLibraryInit({name = "HeroRecycler", "LinkedList", "Timed", "AddHook", optional = {"WorldBounds"}}, function ()
    -- System based on UnitRecycler https://www.hiveworkshop.com/threads/286701/
    -- but with heros

    -- CONFIGURATION SECTION

    -- The owner of the stocked/recycled units
    local OWNER = Player(PLAYER_NEUTRAL_PASSIVE)
    -- Determines if dead units will be automatically recycled
    -- after a delay designated by the "constant function
    -- DeathTime below"
    local AUTO_RECYCLE_DEAD = false

    --  The delay before dead units will be automatically recycled in case when AUTO_RECYCLE_DEAD == true
    local DeathTime = nil ---@type function
    if AUTO_RECYCLE_DEAD then
        function DeathTime(u)
            --[[if <condition> then
                return someValue
            elseif <condition> then
                return someValue
            endif]]
            return 8.00
        end
    end

    -- Filters units allowed for recycling
    local function UnitTypeFilter(u)
        return IsUnitType(u, UNIT_TYPE_HERO) and not IsUnitIllusion(u) and not IsUnitType(u, UNIT_TYPE_SUMMONED)
    end

    local originalScale = __jarray(1) ---@type number[]

    -- When recycling a unit back to the stock, these resets will be applied to the
    -- unit. You can add more actions to this or you can delete this module if you
    -- don't need it.
    local function HeroRecyclerResets(u)
        SetHeroXP(u, 0, false)
        SetUnitScale(u, BlzGetUnitRealField(u, UNIT_RF_SCALING_VALUE), 0., 0.)
        SetUnitVertexColor(u, 255, 255, 255, 255)
        SetUnitFlyHeight(u, GetUnitDefaultFlyHeight(u), 0)
    end

    -- END OF CONFIGURATION

    --[[ == Do not do changes below this line if you're not so sure on what you're doing == ]]--

    HeroRecycler = true

    -- Hide recycled units at the top of the map beyond reach of the camera
    local unitCampX = 0.
    local unitCampY = 0.

    OnMapInit(function ()
        if WorldBounds then
            unitCampY = WorldBounds.maxY
        else
            local bounds = GetWorldBounds()
            unitCampY = GetRectMaxY(bounds)
            RemoveRect(bounds)
        end
    end)

    local List = {} ---@type table<integer, unit[]>

    local function RecycleHeroInternal(u)
        local list = List[GetUnitTypeId(u)] or {}
        List[GetUnitTypeId(u)] = list

        table.insert(list, u)
        if UnitAlive(u) then
            SetUnitPosition(u, unitCampX, unitCampY)
        else
            ReviveHero(u, unitCampX, unitCampY, false)
        end
        for i = 0, 5 do
            if UnitItemInSlot(u, i) then
                RemoveItem(UnitItemInSlot(u, i))
            end
        end
        PauseUnit(u, true)
        ShowUnitHide(u)
        SetUnitOwner(u, OWNER, true)
        SetWidgetLife(u, GetUnitState(u, UNIT_STATE_MAX_LIFE))
        SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA))
        HeroRecyclerResets(u)
    end

    ---Stores the hero to use it later and return if the process was successful
    ---you can add a delay
    ---@param u unit
    ---@param delay? number
    ---@return boolean
    function RecycleHero(u, delay)
        if u and UnitTypeFilter(u) then
            if delay then
                Timed.call(delay, function () RecycleHeroInternal(u) end)
            else
                RecycleHeroInternal(u)
            end
            return true
        end
        return false
    end

    ---Returns a stored hero, if there is no a stored hero, it creates one
    ---@param owner player
    ---@param id integer
    ---@param x number
    ---@param y number
    ---@param angle number
    ---@return unit
    function GetRecycledHero(owner, id, x, y, angle)
        if IsHeroUnitId(id) then
            local list = List[id] or {}
            List[id] = list

            local u = table.remove(list)
            if not u then
                u = CreateUnit(owner, id, x, y, angle)
                originalScale[id] = BlzGetUnitRealField(u, UNIT_RF_SCALING_VALUE)
            else
                SetUnitOwner(u, owner, true)
                SetUnitPosition(u, x, y)
                BlzSetUnitFacingEx(u, angle)
                PauseUnit(u, false)
                ShowUnitShow(u)
            end
            return u
        end
        return nil
    end

    ---Pre-place a hero to use them and return if the process was successful
    ---@param id integer
    ---@return boolean added
    function HeroAddToStock(id)
        if IsHeroUnitId(id) then
            local u = CreateUnit(OWNER, id, 0.00, 0.00, 0)
            if u and UnitTypeFilter(u) then
                RecycleHero(u)
                return true
            end
        end
        return false
    end

    if AUTO_RECYCLE_DEAD then
        OnMapInit(function ()
            local t = CreateTrigger()
            for i = 0, PLAYER_NEUTRAL_PASSIVE do
                TriggerRegisterPlayerUnitEvent(t, Player(i), EVENT_PLAYER_UNIT_DEATH, nil)
            end
            TriggerAddCondition(t, Condition(function ()
                local u = GetTriggerUnit()
                if UnitTypeFilter(u) and not IsUnitType(u, UNIT_TYPE_STRUCTURE) then
                    RecycleHero(u, DeathTime(u))
                end
            end))
        end)
    end
end)