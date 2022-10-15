OnLibraryInit({name = "Digimon", "HeroRecycler", "UnitEnum", "Event", "Damage", "Environment"}, function ()

    local LocalPlayer ---@type player

    ---@class Rank
    Rank = {
        ROOKIE = 0,     ---@type Rank
        CHAMPION = 1,   ---@type Rank
        ULTIMATE = 2,   ---@type Rank
        MEGA = 3        ---@type Rank
    }

    ---@class Rarity
    Rarity = {
        COMMON = 0,     ---@type Rarity
        RARE = 1,       ---@type Rarity
        LEGENDARY = 2   ---@type Rarity
    }

    ---@param s string
    ---@return string
    local function GetToken(s)
        if not s or s == "" then
            return ""
        else
            local m = s:len()
            for i = 1, m do
                if s:sub(i, i) == " " then
                    return s:sub(1, i - 1)
                end
            end
        end
        return s
    end

    -- The actual digimon class

    ---@class Digimon
    ---@field root unit
    ---@field rank Rank
    ---@field rarity Rarity
    ---@field environment Environment
    ---@field onCombat boolean
    Digimon = {
        _instance = {} ---@type table<unit, Digimon>
    }

    Digimon.__index = Digimon
    Digimon.__name = "Digimon"

    ---Create an instantiated digimon
    ---@param p player
    ---@param id integer
    ---@param x number
    ---@param y number
    ---@param facing number
    ---@return Digimon
    function Digimon.create(p, id, x, y, facing)
        return Digimon.add(GetRecycledHero(p, id, x, y, facing))
    end

    ---@param id integer
    ---@return boolean
    function Digimon:addAbility(id)
        return UnitAddAbility(self.root, id)
    end

    ---@param id integer
    ---@return boolean
    function Digimon:removeAbility(id)
        return UnitRemoveAbility(self.root, id)
    end

    ---@param id integer
    ---@return boolean
    function Digimon:hasAbility(id)
        return GetUnitAbilityLevel(self.root, id) > 0
    end

    ---@return player
    function Digimon:getOwner()
        return GetOwningPlayer(self.root)
    end

    ---@param p player
    function Digimon:setOwner(p)
        SetUnitOwner(self.root, p, true)
    end

    ---@return integer
    function Digimon:getLevel()
        return GetHeroLevel(self.root)
    end

    ---@param l integer
    function Digimon:setLevel(l)
        SetHeroLevel(self.root, l, false)
    end

    ---@return integer
    function Digimon:getExp()
        return GetHeroXP(self.root)
    end

    ---@param e integer
    function Digimon:setExp(e)
        SetHeroXP(self.root, e, false)
    end

    ---@return boolean
    function Digimon:isAlive()
        return UnitAlive(self.root)
    end

    ---@return integer
    function Digimon:getTypeId()
        return GetUnitTypeId(self.root)
    end

    ---@return number
    function Digimon:getX()
        return GetUnitX(self.root)
    end

    ---@param x number
    function Digimon:setX(x)
        return SetUnitX(self.root, x)
    end

    ---@return number
    function Digimon:getY()
        return GetUnitY(self.root)
    end

    ---@param y number
    function Digimon:setY(y)
        return SetUnitY(self.root, y)
    end

    ---@return location
    function Digimon:getLoc()
        return GetUnitLoc(self.root)
    end

    ---@param l location
    function Digimon:setLoc(l)
        SetUnitPositionLoc(self.root, l)
    end

    ---@param x number
    ---@param y number
    function Digimon:setPos(x, y)
        return SetUnitPosition(self.root, x, y)
    end

    ---@return number x, number y
    function Digimon:getPos()
        return GetUnitX(self.root), GetUnitY(self.root)
    end

    function Digimon:hideInTheCorner()
        ShowUnitHide(self.root)
        SetUnitPosition(self.root, WorldBounds.maxX, WorldBounds.maxY)
    end

    ---@param x number
    ---@param y number
    function Digimon:showFromTheCorner(x, y)
        ShowUnitShow(self.root)
        SetUnitPosition(self.root, x, y)
    end

    ---@param order integer
    ---@param x? number | unit
    ---@param y? number
    ---@return boolean
    function Digimon:issueOrder(order, x, y)
        if type(x) == "number" and y then
            return IssuePointOrderById(self.root, order, x, y)
        elseif Wc3Type(x) == "unit" then
            return IssueTargetOrderById(self.root, order, x)
        elseif not x and not y then
            return IssueImmediateOrderById(self.root, order)
        end
        error("Invalid target order", 2)
    end

    ---@param u unit
    ---@return Digimon
    function Digimon.getInstance(u)
        if not u then
            return nil
        end
        return Digimon._instance[u]
    end

    -- Enumaration

    ---@param where rect
    ---@param callback fun(d:Digimon)
    function Digimon.enumInRect(where, callback)
        ForUnitsInRect(where, function (u)
            callback(Digimon._instance[u])
        end)
    end

    ---@param x number
    ---@param y number
    ---@param range number
    ---@param callback fun(d:Digimon)
    function Digimon.enumInRange(x, y, range, callback)
        ForUnitsInRange(x, y, range, function (u)
            callback(Digimon._instance[u])
        end)
    end

    -- Events

    -- Create

    Digimon.createEvent = Event.create()

    ---Instance digimons that are created with other methods
    ---@param u unit
    ---@return Digimon
    function Digimon.add(u)
        local self = Digimon._instance[u]
        if not self then
            self = setmetatable({}, Digimon)

            self.root = u

            local check = GetToken(GetUnitName(u))

            if check == "Rookie" then
                self.rank = Rank.ROOKIE
            elseif check == "Champion" then
                self.rank = Rank.CHAMPION
            elseif check == "Ultimate" then
                self.rank = Rank.ULTIMATE
            elseif check == "Mega" then
                self.rank = Rank.MEGA
            end

            self.environment = Environment.allMap
            self.onCombat = false

            Digimon._instance[u] = self
        end

        Digimon.createEvent:run(self)

        return self
    end

    -- Destroy

    Digimon.destroyEvent = Event.create()

    function Digimon:destroy()
        Digimon.destroyEvent:run(self)

        RecycleHero(self.root)
        Digimon._instance[self.root] = nil
    end

    ---@param delay number
    function Digimon:remove(delay)
        Timed.call(delay, function () self:destroy() end)
    end

    -- Kill

    Digimon.killEvent = Event.create()

    OnMapInit(function ()
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddAction(t, function ()
            local killer = GetKillingUnit()
            local target = Digimon._instance[GetDyingUnit()]

            if target then
                Digimon.killEvent:run(Digimon._instance[killer] or killer, target)

                if not IsUnitType(target.root, UNIT_TYPE_ANCIENT) and (target:getOwner() == Digimon.NEUTRAL or target:getOwner() == Digimon.PASSIVE) then
                    target:remove(6.)
                end
            end
        end)
    end)

    -- Captured

    Digimon.capturedEvent = Event.create() -- I prefer running it in the Digimon Capture script

    -- Level Up

    Digimon.levelUpEvent = Event.create()

    OnMapInit(function ()
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_HERO_LEVEL)
        TriggerAddAction(t, function ()
            local d = Digimon._instance[GetLevelingUnit()]
            if d then
                Digimon.levelUpEvent:run(d)
            end
        end)
    end)

    -- Evolution

    Digimon.evolutionEvent = Event.create()

    ---Evolves the digimon
    ---@param evolveForm integer
    function Digimon:evolveTo(evolveForm)
        local old = self.root
        local oldExp = self:getExp()
        local hidden = IsUnitHidden(old)
        local paused = IsUnitPaused(old)
        local select = IsUnitSelected(old, LocalPlayer)
        local items = {}

        for i = 0, 5 do
            items[i] = UnitItemInSlot(old, i)
            if items[i] then
                UnitRemoveItemFromSlot(old, i)
            end
        end

        ShowUnitHide(old)
        self.root = GetRecycledHero(GetOwningPlayer(old), evolveForm, GetUnitX(old), GetUnitY(old), GetUnitFacing(old))

        Digimon._instance[old] = nil
        Digimon._instance[self.root] = self

        local check = GetToken(GetUnitName(self.root))

        if check == "Rookie" then
            self.rank = Rank.ROOKIE
        elseif check == "Champion" then
            self.rank = Rank.CHAMPION
        elseif check == "Ultimate" then
            self.rank = Rank.ULTIMATE
        elseif check == "Mega" then
            self.rank = Rank.MEGA
        end

        for i = 0, 5 do
            if items[i] then
                UnitAddItem(self.root, items[i])
                UnitDropItemSlot(self.root, items[i], i)
            end
        end

        if select then
            SelectUnit(self.root, true)
        end

        if hidden then
            ShowUnitHide(self.root)
        else
            ShowUnitShow(self.root)
        end

        if paused then
            PauseUnit(self.root, true)
        end

        UnitRemoveAbility(old, EvolveAbil)
        UnitAddAbility(self.root, EvolveAbilDis)

        RecycleHero(old)

        self:setExp(oldExp) -- This could run the level up event

        Digimon.evolutionEvent:run(self)
    end

    -- Pre-damage

    Digimon.preDamageEvent = Event.create()

    OnTrigInit(function ()
        local t = CreateTrigger()
        TriggerRegisterVariableEvent(t, "udg_PreDamageEvent", EQUAL, 1.00)
        TriggerAddAction(t, function ()
            local info = {
                source = Digimon._instance[udg_DamageEventSource],
                target = Digimon._instance[udg_DamageEventTarget],
                amount = udg_DamageEventAmount
            }

            if info.source and info.target then
                Digimon.preDamageEvent:run(info)

                udg_DamageEventAmount = info.amount
            end
        end)
    end)

    -- Post-damage

    Digimon.postDamageEvent = Event.create()

    OnTrigInit(function ()
        local t = CreateTrigger()
        TriggerRegisterVariableEvent(t, "udg_AfterDamageEvent", EQUAL, 1.00)
        TriggerAddAction(t, function ()
            local info = {
                source = Digimon._instance[udg_DamageEventSource],
                target = Digimon._instance[udg_DamageEventTarget],
                amount = udg_DamageEventAmount
            }

            if info.source and info.target then
                Digimon.postDamageEvent:run(info)
            end
        end)
    end)

    -- On/Off combat

    Digimon.onCombatEvent = Event.create()
    Digimon.offCombatEvent = Event.create()

    OnTrigInit(function ()
        local onCombat = __jarray(0) ---@type table<Digimon, integer>

        Digimon.postDamageEvent(function (info)
            local source = info.source ---@type Digimon
            source.onCombat = true
            Digimon.onCombatEvent:run(source)
            onCombat[source] = 3.
            Timed.echo(function ()
                local cd = onCombat[source] - 1
                onCombat[source] = cd
                if cd <= 0 then
                    source.onCombat = false
                    Digimon.offCombatEvent:run(source)
                    return true
                end
            end)

            local target = info.target ---@type Digimon
            target.onCombat = true
            Digimon.onCombatEvent:run(target)
            onCombat[target] = 3.
            Timed.echo(function ()
                local cd = onCombat[target] - 1
                onCombat[target] = cd
                if cd <= 0 then
                    target.onCombat = false
                    Digimon.offCombatEvent:run(target)
                    return true
                end
            end)
        end)
    end)

    -- Selection

    Digimon.selectionEvent = Event.create()

    OnTrigInit(function ()
        local t = CreateTrigger()
        for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
            TriggerRegisterPlayerSelectionEventBJ(t, Player(i), true)
        end
        TriggerAddAction(t, function ()
            local d = Digimon._instance[GetTriggerUnit()]
            if d then
                Digimon.selectionEvent:run(GetTriggerPlayer(), d)
            end
        end)
    end)

    -- Double-click

    Digimon.doubleclickEvent = Event.create()

    local clicks = __jarray(0)
    local delay = 0.5

    OnTrigInit(function ()
        Digimon.selectionEvent(function (p, d)
            clicks[d] = clicks[d] + 1
            Timed.call(delay, function ()
                clicks[d] = math.max(clicks[d] - 1, 0)
            end)
            if clicks[d] == 2 then
                clicks[d] = 0
                Digimon.doubleclickEvent:run(p, d)
            end
        end)
    end)

    -- Initialization

    Digimon.NEUTRAL = Player(12)
    Digimon.PASSIVE = Player(PLAYER_NEUTRAL_PASSIVE)

    OnTrigInit(function ()
        local exclude = Set.create(
            FourCC('n00A') -- Digispirit
        )
        -- Add the current digimons in the map
        ForUnitsInRect(bj_mapInitialPlayableArea, function (u)
            if not exclude:contains(GetUnitTypeId(u)) then
                Digimon.add(u)
            end
        end)

        LocalPlayer = GetLocalPlayer()

        -- Change the environment when double-click a Digimon
        Digimon.doubleclickEvent(function (p, d)
            if d:getOwner() == p and  d.environment ~= GetPlayerEnviroment(p) then
                d.environment:apply(p)
                if p == LocalPlayer then
                    PanCameraToTimed(d:getX(), d:getY(), 0)
                end
            end
        end)
    end)

end)