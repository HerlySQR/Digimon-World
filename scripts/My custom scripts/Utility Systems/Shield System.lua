if Debug then Debug.beginFile("Shield") end
OnInit("Shield", function ()
    Require "Damage" -- https://www.hiveworkshop.com/threads/damage-engine-5-9-0-0.201016/
    Require "Set" -- https://www.hiveworkshop.com/threads/set-group-datastructure.331886/
    Require "Timed" -- https://www.hiveworkshop.com/threads/timed-call-and-echo.339222/
    Require "EventListener" -- https://www.hiveworkshop.com/threads/event-gui-friendly.339451/]]

    -- Inspired on: GUI Friendly Shield System 1.00b by AutisticTenacity
    -- https://www.hiveworkshop.com/threads/gui-friendly-shield-system-1-00b.316372/

    local INTERVAL = 0.03125

    ---@class Shield
    ---The unit who casted the shield
    ---@field caster unit
    ---The unit who has the shield
    ---@field target unit
    ---Unique id to difference types
    ---@field typeId integer
    ---The duration of the shield
    ---@field duration number
    ---The health of the shield
    ---@field health number
    ---The max health of the shield
    ---@field maxHealth number
    ---A callback when the target gets damage, if returns true, then the shield will be bypassed
    ---@field onDamaged fun(self: Shield, source: unit, amount: number): boolean
    ---A callback that runs every `INTERVAL` seconds
    ---@field onPeriodic fun(self: Shield)
    ---A callback when the shield is destroyed (calls onBreak with nil source)
    ---@field onDestroy fun(self: Shield)
    ---@field _model string
    ---@field _point string
    ---@field _eff effect
    ---@field _timer function
    Shield = {}
    Shield.__index = Shield

    local Shields = {} ---@type table<unit, Set>

    ---Runs everytime the `Shield:apply()` function is called
    Shield.applyEvent = EventListener.create()

    ---@return Shield
    function Shield.create()
        local self = setmetatable({}, Shield) ---@type Shield

        self.typeId = 0
        self._elapsed = 0
        self.duration = 0
        self.health = 0
        self.maxHealth = 0

        return self
    end

    function Shield:apply()
        local set = Shields[self.target]
        if not set then
            set = Set.create()
            Shields[self.target] = set
        end
        set:addSingle(self)

        self.maxHealth = math.max(self.maxHealth, self.health)

        if not self._eff and self._model and self._point then
            self:setModel(self._model, self._point)
        end

        self._timer = Timed.echo(INTERVAL, function ()
            self._elapsed = self._elapsed + INTERVAL

            if self.onPeriodic then
                self:onPeriodic()
            end

            if self._elapsed >= self.duration then
                self:destroy()
            end
        end)

        Shield.applyEvent:run(self)
    end

    ---@param model string
    ---@param point string
    function Shield:setModel(model, point)
        if self._eff then
            DestroyEffect(self._eff)
            self._eff = nil
        end
        self._model = model
        self._point = point
        if self.target then
            self._eff = AddSpecialEffectTarget(self._model, self.target, self._point)
        end
    end

    ---Breaks the shield, returns true if the shield was removed
    function Shield:destroy()
        self.health = 0.

        if self._eff then
            DestroyEffect(self._eff)
        end

        if self.onDestroy then
            self:onDestroy()
        end

        if self._timer then
            self._timer()
        end

        Shields[self.target]:removeSingle(self)
    end

    ---Returns a copy of the set of shields the unit has.
    ---If the unit don't have any shield, returns an empty set
    ---@param u unit
    ---@return Set
    function GetUnitShields(u)
        return Shields[u] ~= nil and Shields[u]:copy() or Set.create()
    end

    OnInit.trig(function ()
        local t = CreateTrigger()
        TriggerRegisterVariableEvent(t, "udg_ArmorDamageEvent", EQUAL, 1.00)
        TriggerAddAction(t, function ()
            local set = Shields[udg_DamageEventTarget]

            if set then
                for shield in set:elements() do
                    --local shield = shield ---@type Shield
                    if not shield.onDamaged or not shield:onDamaged(udg_DamageEventSource, udg_DamageEventAmount) then
                        shield.health = shield.health - udg_DamageEventAmount
                        if shield.health <= 0 then
                            shield:destroy()
                            udg_DamageEventAmount = -shield.health
                        else
                            udg_DamageEventAmount = 0
                        end
                    end
                end
            end
        end)

        t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddAction(t, function ()
            local set = Shields[GetDyingUnit()]
            if set then
                for shield in set:elements() do
                    shield:destroy()
                end
            end
        end)
    end)
end)
if Debug then Debug.endFile() end