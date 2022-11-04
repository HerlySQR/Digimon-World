-- The pure Lua version of the Bounty Controller
-- GUI version: https://www.hiveworkshop.com/threads/gui-bounty-controller.332114/

OnLibraryInit({name = "BountyController", "Event"}, function ()
    ---@deprecated, use Bounty.Enable() and Bounty.Disable() instead
    Bounty_Controller = nil
    local LocalPlayer = nil ---@type player

    -- These can be edited (obviously only valid values)

    local DEF_COLOR_GOLD = "ffcc00"
    local DEF_COLOR_LUMBER = "32cd32"
    local DEF_SIZE = 10
    local DEF_LIFE_SPAN = 3.50
    local DEF_AGE = 0.00
    local DEF_SPEED = 64
    local DEF_DIRECTION = 90
    local DEF_FADE_POINT = 2.50
    local DEF_STATE = "gold"
    local DEF_HEIGHT = 0
    local DEF_SHOW = true
    local DEF_SHOW_NOTHING = false
    local DEF_ALLOW_FRIEND_FIRE = false
    local DEF_EFFECT = "UI\\Feedback\\GoldCredit\\GoldCredit.mdl"
    local DEF_SHOW_EFFECT = true
    local DEF_PERMANENT = false
    local LIMIT_RECURSION = 16 --If a loop caused by recursion is doing in porpouse you can edit the tolerance of how many calls can do

    local current = nil
    local Bounties0 = {}
    local Bounties1 = {}
    local Bounties2 = {}
    local Recursion = 0

    local onDead = Event.create()
    local onRun = Event.create()

    local t1
    local t2

    -- This function is runned at the map initialization,  if you wanna use it to your bounties,  you can do it
    local function SetData()

        --[[Peasant]] Bounty.Set(FourCC('hpea'), 15, 5, 3)

        for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
            SetPlayerState(Player(i), PLAYER_STATE_GIVES_BOUNTY, 0)
        end

    end

    ---@class Bounty
    ---@field Amount integer
    ---@field Color string
    ---@field Size number
    ---@field LifeSpan number
    ---@field Age number
    ---@field Speed number
    ---@field Direction number
    ---@field FadePoint number
    ---@field State string
    ---@field Height number
    ---@field Show boolean
    ---@field ShowNothing boolean
    ---@field AllowFriendFire boolean
    ---@field Effect string
    ---@field ShowEff boolean
    ---@field Permanent boolean
    ---@field Receiver player
    ---@field UnitPos unit
    ---@field LocPos location
    ---@field TextTag texttag
    ---@field PosX number
    ---@field PosY number
    ---@field KillingUnit unit
    ---@field DyingUnit unit
    Bounty = {}

    Bounty.__index = Bounty

    ---@param value any
    ---@return boolean
    function IsBounty(value)
        return getmetatable(value) == Bounty
    end

    -- The order it returns (if there is no error) is: number, Bounty
    local function ValidValues(v1, v2)
        if type(v1) == "number" and IsBounty(v2) then
            return v1, v2
        elseif IsBounty(v1) and type(v2) == "number" then
            return v2, v1
        else
            error("Wrong operators", 3)
        end
    end

    -- Metamethods

    function Bounty.__add(v1, v2)
        local num, bounty = ValidValues(v1, v2)
        local new = Bounty.Copy(bounty)
        new.Amount = new.Amount + num
        return new
    end

    function Bounty.__sub(v1, v2)
        local num, bounty = ValidValues(v1, v2)
        local new = Bounty.Copy(bounty)
        new.Amount = new.Amount - num
        return new
    end

   function Bounty.__mul (v1, v2)
        local num, bounty = ValidValues(v1, v2)
        local new = Bounty.Copy(bounty)
        new.Amount = new.Amount * num
        return new
    end

    function Bounty.__div(v1, v2)
        local num, bounty = ValidValues(v1, v2)
        local new = Bounty.Copy(bounty)
        new.Amount = new.Amount / num
        return new
    end

    function Bounty.__pow(v1, v2)
        if not (type(v2) == "number" and IsBounty(v1)) then
            error("Wrong operators", 2)
        end
        local new = Bounty.Copy(v1)
        new.Amount = new.Amount ^ v2
        return new
    end

    Bounty.__name = "Bounty"

    function Bounty.__tostring(t)
        return "Bounty: |cff" .. t.Color .. Bounty.Sign(t.Bounty) .. t.Bounty .. "|r"
    end

    -- Functions

    function Bounty:destroy()
        if self.LocPos then
            RemoveLocation(self.LocPos)
        end
        self._canSee = nil
        Recursion = Recursion - 1
    end

    ---Sets if the player can see the bounty
    ---@param p player
    ---@param flag boolean
    function Bounty:CanSee(p, flag)
        self._canSee[p] = flag
    end

    ---Returns if the player can see the bounty
    ---@param p player
    ---@return boolean
    function Bounty:Seeing(p)
        return self._canSee[p]
    end

    ---Runs the created bounty
    ---@return texttag
    function Bounty:Run()
        local what

        if Recursion > LIMIT_RECURSION then -- If there is recursion that don't stop soon, the system stops automatically
            print("There is a recursion with the Bounty system, check if you are not creating a infinite loop.")
            self:destroy()
            return nil -- This is my convention
        end

        if self.State == "gold" then
            what = PLAYER_STATE_RESOURCE_GOLD
        elseif self.State == "lumber" then
            what = PLAYER_STATE_RESOURCE_LUMBER
        else
            self:destroy()
            return nil --If the state is not valid, the process stop
        end

        if self.Amount == 0 and not self.ShowNothing then
            self.Show = false
            self.ShowEff = false
        end

        AdjustPlayerStateSimpleBJ(self.Receiver, what, self.Amount)

        if not self.Color then
            if self.State == "gold" then
                self.Color = DEF_COLOR_GOLD
            elseif self.State == "lumber" then
                self.Color = DEF_COLOR_LUMBER
            end
        end

        if self.LocPos then
            self.PosX = GetLocationX(self.LocPos)
            self.PosY = GetLocationY(self.LocPos)
        elseif self.UnitPos then
            self.PosX = GetUnitX(self.UnitPos)
            self.PosY = GetUnitY(self.UnitPos)
        else
            self.Show = false
            self.ShowEff = false --If there is no position to the text, the text and the effect won't show
        end

        self.TextTag = CreateTextTag()
        SetTextTagPermanent(self.TextTag, self.Permanent)
        SetTextTagText(self.TextTag, "|cff" .. self.Color .. Bounty.Sign(self.Amount) .. I2S(self.Amount) .. "|r", TextTagSize2Height(self.Size))
        SetTextTagVisibility(self.TextTag, self:Seeing(LocalPlayer) and self.Show)
        SetTextTagPos(self.TextTag, self.PosX, self.PosY, self.Height)
        SetTextTagFadepoint(self.TextTag, self.FadePoint)
        SetTextTagLifespan(self.TextTag, self.LifeSpan)
        SetTextTagVelocityBJ(self.TextTag, self.Speed, self.Direction)
        SetTextTagAge(self.TextTag, self.Age)

        if self.ShowEff then
            DestroyEffect(AddSpecialEffect(self.Effect, self.PosX, self.PosY))
        end

        current = self
        what = self.TextTag

        onRun(self)

        current = self

        self:destroy()

        return what
    end

    ---Creates and runs a bounty
    ---@param bounty integer
    ---@param pos unit
    ---@param myplayer player
    ---@param addplayer boolean
    ---@param perm boolean
    ---@return texttag
    function Bounty:Call(bounty, pos, myplayer, addplayer, perm)
        self.Amount = bounty
        self.UnitPos = pos
        self.Receiver = myplayer
        self:CanSee(myplayer, addplayer)
        self.Permanent = perm
        return self:Run()
    end

    ---Change the player who receive the bounty.
    ---Consider that only doing this won't affect if they can see the bounty
    ---so you can also modify that
    ---@param newPlayer player
    ---@param removePrevious boolean
    ---@param addNew boolean
    function Bounty:ChangeReceiver(newPlayer, removePrevious, addNew)
        self:CanSee(self.Receiver, not removePrevious)
        self.Receiver = newPlayer
        self:CanSee(newPlayer, addNew)
    end

    -- The functions to the bounty stats

    ---@param id integer
    ---@param base integer
    function Bounty.SetBase(id, base)
        Bounties0[id] = base
    end

    ---@param id integer
    ---@param dice integer
    function Bounty.SetDice(id, dice)
        Bounties1[id] = dice
    end

    ---@param id integer
    ---@param sides integer
    function Bounty.SetSides(id, sides)
        Bounties2[id] = sides
    end

    ---Defines the bounty of a unit-type
    ---@param id integer
    ---@param base integer
    ---@param dice integer
    ---@param side integer
    function Bounty.Set(id, base, dice, side)
        Bounty.SetBase(id, base)
        Bounty.SetDice(id, dice)
        Bounty.SetSides(id, side)
    end

    -- The functions to get the bounty stats (that you set before)

    ---@param id integer
    ---@return integer
    function Bounty.GetBase(id)
        return Bounties0[id] or 0
    end

    ---@param id integer
    ---@return integer
    function Bounty.GetDice(id)
        return Bounties1[id] or 0
    end

    ---@param id integer
    ---@return integer
    function Bounty.GetSides(id)
        return Bounties2[id] or 0
    end

    ---Returns a random bounty that the unit-type should give
    ---@param id integer
    ---@return integer
    function Bounty.Get(id)
        return Bounty.GetBase(id) + math.random(0, Bounty.GetDice(id) * Bounty.GetSides(id))
    end

    ---@deprecated
    ---Returns the bounty that fired the event
    ---@return Bounty
    function Bounty.GetCurrent()
        return current
    end

    ---Returns '+' if the value is positive or an empty string if is negative
    ---@param i number
    ---@return string
    function Bounty.Sign(i)
        return i < 0 and "" or "+"
    end

    ---@param bounty Bounty
    ---@return Bounty
    function Bounty.Copy(bounty)
        if IsBounty(bounty) then
            local new = setmetatable({}, Bounty)
            for k, v in pairs(bounty) do
                new[k] = v
            end
            return new
        else
            error("Wrong argument, expected Bounty", 2)
        end
    end

    ---@return Bounty
    function Bounty.create()
        Recursion = Recursion + 1
        local self = setmetatable({}, Bounty)
        self.Amount = 0
        self.Size = DEF_SIZE
        self.LifeSpan = DEF_LIFE_SPAN
        self.Age = DEF_AGE
        self.Speed = DEF_SPEED
        self.Direction = DEF_DIRECTION
        self.FadePoint = DEF_FADE_POINT
        self.State = DEF_STATE
        self.Height = DEF_HEIGHT
        self.Show = DEF_SHOW
        self.ShowNothing = DEF_SHOW_NOTHING
        self.Effect = DEF_EFFECT
        self.ShowEff = DEF_SHOW_EFFECT
        self.Permanent = DEF_PERMANENT
        self.AllowFriendFire = DEF_ALLOW_FRIEND_FIRE
        self.PosX = 0.00
        self.PosY = 0.00
        self._canSee = {}
        return self
    end

    ---Enables the bounty controller
    function Bounty.Enable()
        EnableTrigger(Bounty_Controller)
    end

    ---Disables the bounty controller
    function Bounty.Disable()
        DisableTrigger(Bounty_Controller)
    end

    OnTrigInit(function ()
        --The trigger that runs when a unit dies
        Bounty_Controller = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(Bounty_Controller, EVENT_PLAYER_UNIT_DEATH)
        TriggerAddAction(Bounty_Controller, function()
            if not GetKillingUnit() then return end -- If there is not killing unit then the process stop

            local self = Bounty.create()

            self.KillingUnit = GetKillingUnit()
            self.DyingUnit = GetDyingUnit()
            self.Amount = Bounty.Get(GetUnitTypeId(self.DyingUnit))

            self.Receiver = GetOwningPlayer(self.KillingUnit)
            self:CanSee(self.Receiver, true)
            self.UnitPos = self.DyingUnit

            current = self

            onDead:run(self)

            current = self

            if IsUnitEnemy(self.DyingUnit, self.Receiver) or self.AllowFriendFire then
                self:Run()
            else
                self:destroy()
            end
        end)

        -- Last details
        t1 = CreateTrigger()
        t2 = CreateTrigger()

        LocalPlayer = GetLocalPlayer()
        SetData()
    end)

    ---Adds a listener that will run when a unit kills another to the main trigger
    ---@param cb fun(bounty: Bounty)
    ---@return Event
    function Bounty.OnDead(cb)
        return onDead(cb)
    end

    ---Adds a listener that will run when a bounty is runned without problem
    ---@param cb fun(bounty: Bounty)
    ---@return Event
    function Bounty.OnRun(cb)
        return onRun(cb)
    end

    ---@deprecated
    ---Adds a listener that will run when a unit kills another to the main trigger
    ---@param func function
    ---@return Event
    function RegisterBountyDeadEvent(func)
        return onDead(func)
    end

    ---@deprecated
    ---Adds a listener that will run when a unit kills another
    ---@param t trigger
    ---@param func function
    ---@return Event
    function TriggerRegisterBountyDeadEvent(t, func)
        return onDead(func)
    end

    ---@deprecated
    ---Returns the main trigger that will run when a unit kills another
    ---@return trigger
    function GetNativeBountyDeadTrigger()
        return t1
    end

    ---@deprecated
    ---Adds a listener that will run when a bounty is runned without problem
    ---@param func function
    ---@return Event
    function RegisterBountyEvent(func)
        return onRun(func)
    end

    ---@deprecated
    ---Adds a listener that will run when a bounty is runned without problem to the main trigger
    ---@param t trigger
    ---@param func function
    ---@return Event
    function TriggerRegisterBountyEvent(t, func)
        return onRun(t, func)
    end

    ---@deprecated
    ---Returns the main trigger that will run when a bounty is runned without problem
    ---@return trigger
    function GetNativeBountyTrigger()
        return t2
    end
end)