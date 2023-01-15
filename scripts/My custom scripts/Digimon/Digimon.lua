OnInit("Digimon", function ()
    Require "HeroRecycler"
    Require "UnitEnum"
    Require "EventListener"
    Require "Damage"
    Require "Environment"
    Require "Vec2"
    Require "GlobalRemap"

    local LocalPlayer = GetLocalPlayer() ---@type player

    ---@enum Rank
    Rank = {
        ROOKIE = 0,
        CHAMPION = 1,
        ULTIMATE = 2,
        MEGA = 3
    }

    ---@enum Rarity
    Rarity = {
        COMMON = 0,
        UNCOMMON = 1,
        RARE = 2,
        EPIC = 3,
        LEGENDARY = 4
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

    local rarities = __jarray(Rarity.COMMON) ---@type table<integer, Rarity>

    function Digimon.getRarity(id)
        return rarities[id]
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
        local oldLevel = GetHeroLevel(self.root)
        if l < oldLevel then
            UnitStripHeroLevel(self.root, oldLevel - l)
        elseif l > oldLevel then
            SetHeroLevel(self.root, l, false)
        end
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

    function Digimon:show()
        ShowUnitShow(self.root)
    end

    function Digimon:hide()
        ShowUnitHide(self.root)
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

    Digimon.createEvent = EventListener.create()

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

            self.rarity = rarities[GetUnitTypeId(u)]

            self.environment = Environment.initial
            self.onCombat = false

            Digimon._instance[u] = self
        end

        Digimon.createEvent:run(self)

        return self
    end

    -- Destroy

    Digimon.destroyEvent = EventListener.create()

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

    Digimon.killEvent = EventListener.create()

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddAction(t, function ()
            local killer = GetKillingUnit()
            local target = Digimon._instance[GetDyingUnit()]

            if target then
                Digimon.killEvent:run({killer = Digimon._instance[killer] or killer, target = target})

                if not IsUnitType(target.root, UNIT_TYPE_ANCIENT) and (target:getOwner() == Digimon.NEUTRAL or target:getOwner() == Digimon.PASSIVE) then
                    target:remove(6.)
                end
            end
        end)
    end

    -- Level Up

    Digimon.levelUpEvent = EventListener.create()

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_HERO_LEVEL)
        TriggerAddAction(t, function ()
            local d = Digimon._instance[GetLevelingUnit()]
            if d then
                Digimon.levelUpEvent:run(d)
            end
        end)
    end

    -- Evolution

    Digimon.evolutionEvent = EventListener.create()

    ---Evolves the digimon
    ---@param evolveForm integer
    function Digimon:evolveTo(evolveForm)
        local old = self.root
        local oldExp = self:getExp()
        local hidden = IsUnitHidden(old)
        local paused = IsUnitPaused(old)
        local select = IsUnitSelected(old, LocalPlayer)
        local invul = BlzIsUnitInvulnerable(old)
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

        if invul then
            SetUnitInvulnerable(self.root, true)
        end

        UnitRemoveAbility(old, EvolveAbil)
        UnitAddAbility(self.root, EvolveAbilDis)

        RecycleHero(old)

        self:setExp(oldExp) -- This could run the level up event

        Digimon.evolutionEvent:run(self)
    end

    -- Pre-damage

    Digimon.preDamageEvent = EventListener.create()

    do
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
    end

    -- Post-damage

    Digimon.postDamageEvent = EventListener.create()

    do
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
    end

    -- On/Off combat

    Digimon.onCombatEvent = EventListener.create()
    Digimon.offCombatEvent = EventListener.create()

    do
        local onCombat = __jarray(0) ---@type table<Digimon, integer>

        Digimon.postDamageEvent:register(function (info)
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
    end

    -- Selection

    Digimon.selectionEvent = EventListener.create()

    do
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
    end

    -- Double-click

    Digimon.doubleclickEvent = EventListener.create()

    local clicks = __jarray(0)
    local delay = 0.5

    Digimon.selectionEvent:register(function (p, d)
        xpcall(function ()
        clicks[d] = clicks[d] + 1
        Timed.call(delay, function ()
            clicks[d] = math.max(clicks[d] - 1, 0)
        end)
        if clicks[d] == 2 then
            clicks[d] = 0
            Digimon.doubleclickEvent:run(p, d)
        end
        end, print)
    end)

    -- Order events

    Digimon.issueTargetOrderEvent = EventListener.create()
    Digimon.issuePointOrderEvent = EventListener.create()
    Digimon.issueOrderEvent = EventListener.create()

    RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER, function ()
        local d1 = Digimon._instance[GetOrderedUnit()]
        if d1 then
            local d2 = Digimon._instance[GetOrderTargetUnit()]
            if d2 then
                Digimon.issueTargetOrderEvent:run(d1, GetIssuedOrderId(), d2)
            end
        end
    end)
    RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, function ()
        local d1 = Digimon._instance[GetOrderedUnit()]
        if d1 then
            Digimon.issuePointOrderEvent:run(d1, GetIssuedOrderId(), Vec2.new(GetOrderPointX(), GetOrderPointY()))
        end
    end)
    RegisterAnyPlayerUnitEvent(EVENT_PLAYER_UNIT_ISSUED_ORDER, function ()
        local d1 = Digimon._instance[GetOrderedUnit()]
        if d1 then
            Digimon.issueOrderEvent:run(d1, GetIssuedOrderId())
        end
    end)

    -- Initialization

    Digimon.NEUTRAL = Player(12)
    Digimon.PASSIVE = Player(PLAYER_NEUTRAL_PASSIVE)

    GlobalRemap("udg_SetCommon", nil, function (id) rarities[id] = Rarity.COMMON end)
    GlobalRemap("udg_SetUncommon", nil, function (id) rarities[id] = Rarity.UNCOMMON end)
    GlobalRemap("udg_SetRare", nil, function (id) rarities[id] = Rarity.RARE end)
    GlobalRemap("udg_SetEpic", nil, function (id) rarities[id] = Rarity.EPIC end)
    GlobalRemap("udg_SetLegendary", nil, function (id) rarities[id] = Rarity.LEGENDARY end)

    -- Init rarities
    OnInit.trig(function ()
        TriggerExecute(gg_trg_Set_rarities)
    end)
    -- --
    local exclude = Set.create(
        FourCC('n00A') -- Digispirit
    )
    -- Add the current digimons in the map
    ForUnitsInRect(bj_mapInitialPlayableArea, function (u)
        if not exclude:contains(GetUnitTypeId(u)) then
            Digimon.add(u)
        end
    end)

    -- Change the environment when double-click a Digimon
    Digimon.doubleclickEvent:register(function (p, d)
        if d:getOwner() == p and  d.environment ~= GetPlayerEnviroment(p) then
            d.environment:apply(p)
            if p == LocalPlayer then
                PanCameraToTimed(d:getX(), d:getY(), 0)
            end
        end
    end)
end)