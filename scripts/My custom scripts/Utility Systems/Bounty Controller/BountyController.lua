-- The pure Lua version of the Bounty Controller
-- GUI version: https://www.hiveworkshop.com/threads/gui-bounty-controller.332114/

OnInit("BountyController", function() -- https://www.hiveworkshop.com/threads/global-initialization.317099/
    Require "Event" -- https://www.hiveworkshop.com/threads/event-harmonization-of-lua-and-gui-events.339451/

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

    -- This function is run at the start of the game, if you wanna use it to your bounties, you can do it
    local function Config()
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
    Bounty = {
        base  = __jarray(0),
        dice  = __jarray(0),
        sides = __jarray(0)
    }

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

    -- Events

    local runOnDead, runOnRun

    ---The callback runs when a unit kills another
    Bounty.OnDead, runOnDead = Event.create()

    ---The callback runs when a bounty is runned
    Bounty.OnRun, runOnRun = Event.create()

    -- Functions

    function Bounty:destroy()
        if self.LocPos then
            RemoveLocation(self.LocPos)
        end
        self._canSee = nil
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

        if self.State == "gold" then
            what = PLAYER_STATE_RESOURCE_GOLD
        elseif self.State == "lumber" then
            what = PLAYER_STATE_RESOURCE_LUMBER
        else
            self:destroy()
            error("Invalid state: " .. self.State) --If the state is not valid, the process stops
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
        SetTextTagVisibility(self.TextTag, self:Seeing(GetLocalPlayer()) and self.Show)
        SetTextTagPos(self.TextTag, self.PosX, self.PosY, self.Height)
        SetTextTagFadepoint(self.TextTag, self.FadePoint)
        SetTextTagLifespan(self.TextTag, self.LifeSpan)
        SetTextTagVelocityBJ(self.TextTag, self.Speed, self.Direction)
        SetTextTagAge(self.TextTag, self.Age)

        if self.ShowEff then
            DestroyEffect(AddSpecialEffect(self.Effect, self.PosX, self.PosY))
        end

        what = self.TextTag

        runOnRun(self)

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

    ---Defines the bounty of a unit-type
    ---@param id integer
    ---@param base integer
    ---@param dice integer
    ---@param sides integer
    function Bounty.Set(id, base, dice, sides)
        Bounty.base[id] = base
        Bounty.dice[id] = dice
        Bounty.sides[id] = sides
    end

    ---Returns a random bounty that the unit-type should give
    ---@param id integer
    ---@return integer
    function Bounty.Get(id)
        return Bounty.base[id] + math.random(0, Bounty.dice[id] * Bounty.sides[id])
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
        return setmetatable({
            Amount = 0,
            Size = DEF_SIZE,
            LifeSpan = DEF_LIFE_SPAN,
            Age = DEF_AGE,
            Speed = DEF_SPEED,
            Direction = DEF_DIRECTION,
            FadePoint = DEF_FADE_POINT,
            State = DEF_STATE,
            Height = DEF_HEIGHT,
            Show = DEF_SHOW,
            ShowNothing = DEF_SHOW_NOTHING,
            Effect = DEF_EFFECT,
            ShowEff = DEF_SHOW_EFFECT,
            Permanent = DEF_PERMANENT,
            AllowFriendFire = DEF_ALLOW_FRIEND_FIRE,
            PosX = 0.00,
            PosY = 0.00,
            _canSee = {}
        }, Bounty)
    end

    ---Enables the bounty controller
    function Bounty:Enable()
        EnableTrigger(self.trig)
    end

    ---Disables the bounty controller
    function Bounty:Disable()
        DisableTrigger(self.trig)
    end

    --The trigger that runs when a unit dies
    Bounty.trig = CreateTrigger()
    TriggerRegisterAnyUnitEventBJ(Bounty.trig, EVENT_PLAYER_UNIT_DEATH)
    TriggerAddAction(Bounty.trig, function()
        local killer = GetKillingUnit()
        if killer then -- If there is no killing unit then the process stops

            local self = Bounty.create()

            self.KillingUnit = killer
            self.DyingUnit = GetTriggerUnit()
            self.Amount = Bounty.Get(GetUnitTypeId(self.DyingUnit))

            self.Receiver = GetOwningPlayer(self.KillingUnit)
            self:CanSee(self.Receiver, true)
            self.UnitPos = self.DyingUnit

            runOnDead(self)

            if IsUnitEnemy(self.DyingUnit, self.Receiver) or self.AllowFriendFire then
                self:Run()
            else
                self:destroy()
            end
        end
    end)

    OnInit.final(Config)
end)