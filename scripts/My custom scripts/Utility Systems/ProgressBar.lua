if Debug then Debug.beginFile("ProgressBar") end
OnInit("ProgressBar", function ()
    Require "Timed"
    local Color = Require "Color"
    --[[*************************************************************
    *
    *   Based on ProgressBars v2.0.1 by TriggerHappy https://www.hiveworkshop.com/threads/progressbars-v2-0-1.245414/
    *
    *   This library allows you to easily create and modify progress bars.
    *   It works by creating a dummy unit with a special model and changing
    *   the animation speed to increase or reduce the bar speed. It is more than
    *   just a wrapper as it recycles each progress bar, meaning it will avoid
    *   costly CreateUnit calls whenever possible which also leak.
    *
    *   Options:
    *       x            - set X coordinate
    *       y            - set Y coordinate
    *       xOffset      - offset of the target unit, if any.
    *       yOffset      - offset of the target unit, if any.
    *       zOffset      - how high the bar is from the ground.
    *       color        - allows you to tint the bar or add transparency
    *       targetUnit   - pick which unit the bar should hover over
    *       size         - set model scale
    *
    *   Usage:
    *       local bar = ProgressBar.create()
    *       bar:setXOffset(150)
    *       bar:setColor(PLAYER_COLOR_RED)
    *       bar:setTargetUnit(CreateUnit(Player(0), 'hfoo', 0, 0, 0))
    *       bar:setPercentage(30)
    *
    *   Installation:
    *       1. Copy the dummy unit over to your map
    *       2. Change the DUMMY constant to fit the Raw code of the dummy.
    *       3. Copy this and all required libraries over to your map.
    *
    *   Thanks to JesusHipster for the Progress Bar models
    *   and to Vexorian for TimerUtils & BoundSentinel
    *
    *************************************************************]]

    local PROGRESS_BAR_DUMMY     = FourCC('e002') -- the default one
    local PROGRESS_BAR_OWNER     = Player(PLAYER_NEUTRAL_PASSIVE) -- owner of the dummy
    local UPDATE_POSITION_PERIOD = 0.03 -- the timer period used with .targetUnit

    local dummy = {} ---@type unit[]

    ---@return unit
    local function getDummy()
        local d = table.remove(dummy)
        if not d then
            d = CreateUnit(PROGRESS_BAR_OWNER, PROGRESS_BAR_DUMMY, 0, 0, 270)
            PauseUnit(d, true)
        end
        SetUnitAnimationByIndex(d, 1)
        return d
    end

    ---@class ProgressBar
    ---@field bar unit
    ---@field target unit
    ---@field xOffset number
    ---@field yOffset number
    ---@field private timer function
    ---@field private timer2 function
    ---@field private t_enabled boolean
    ---@field private endVal number
    ---@field private curVal number
    ---@field private pspeed number
    ---@field private reverse boolean
    ---@field private done boolean
    ---@field private recycle boolean
    local ProgressBar = {}
    ProgressBar.__index = ProgressBar

    ---@param x number
    function ProgressBar:setX(x)
        SetUnitX(self.bar, x)
    end

    ---@return number
    function ProgressBar:getX()
        return GetUnitX(self.bar)
    end

    ---@param y number
    function ProgressBar:setY(y)
        SetUnitY(self.bar, y)
    end

    ---@return number
    function ProgressBar:getY()
        return GetUnitY(self.bar)
    end

    ---@param offset number
    function ProgressBar:setZOffset(offset)
        SetUnitFlyHeight(self.bar, offset, 0)
    end

    ---@return number
    function ProgressBar:getZOffset()
        return GetUnitFlyHeight(self.bar)
    end

    ---@param size number
    function ProgressBar:setSize(size)
        SetUnitScale(self.bar, size, size, size)
    end

    ---@param color playercolor
    function ProgressBar:setColor(color)
        SetUnitColor(self.bar, color)
    end

    ---@param flag boolean
    function ProgressBar:show(flag)
        UnitRemoveAbility(self.bar, FourCC('Aloc'))
        ShowUnit(self.bar, flag)
        UnitAddAbility(self.bar, FourCC('Aloc'))
    end

    function ProgressBar:reset()
        SetUnitAnimationByIndex(self.bar, 1)
    end

    ---@param color Color
    function ProgressBar:RGB(color)
        SetUnitVertexColor(self.bar, color)
    end

    function ProgressBar:destroy()
        if self.recycle then
            table.insert(dummy, self.bar)
            SetUnitAnimationByIndex(self.bar, 1)
            SetUnitTimeScale(self.bar, 1)
            self:show(false)
        end

        self.bar        = nil
        self.target     = nil
        self.t_enabled  = false
        self.endVal     = 0
        self.curVal     = 0

        if self.timer then
            self.timer()
            self.timer = nil
        end

        if self.timer2 then
            self.timer2()
            self.timer2 = nil
        end
    end

    ---@param unitId? integer
    ---@return ProgressBar
    function ProgressBar.create(unitId)
        local self = setmetatable({}, ProgressBar)

        if unitId then
            self.bar        = CreateUnit(PROGRESS_BAR_OWNER, unitId, 0, 0, 0)
            self.recycle    = false
        else
            self.bar        = getDummy()
            self.recycle    = true
        end
        self.done       = true
        self.xOffset    = 0
        self.yOffset    = 0
        self.curVal     = 0

        SetUnitAnimationByIndex(self.bar, 1)
        SetUnitTimeScale(self.bar, 0)
        self:show(true)

        return self
    end

    ---@param percent number
    ---@param speed number
    function ProgressBar:setPercentage(percent, speed)
        self.endVal = percent
        self.pspeed = speed

        self.reverse = self.curVal > self.endVal

        if self.done then
            if self.timer2 then
                self.timer2()
            end

            self.timer2 = Timed.echo(0.01, function ()
                if self.reverse then
                    if self.curVal > self.endVal then
                        SetUnitTimeScale(self.bar, -self.pspeed)
                        self.curVal = self.curVal - self.pspeed
                    elseif (self.curVal <= self.endVal) then
                        SetUnitTimeScale(self.bar, 0)
                        self.curVal = self.endVal
                        self.done = true
                        return true
                    end
                else
                    if self.curVal < self.endVal then
                        SetUnitTimeScale(self.bar, self.pspeed)
                        self.curVal = self.curVal + self.pspeed
                    elseif self.curVal >= self.endVal then
                        SetUnitTimeScale(self.bar, 0)
                        self.curVal = self.endVal
                        self.done = true
                        return true
                    end
                end
            end)
            self.done = false
        end
    end

    ---@param u unit
    function ProgressBar:setTargetUnit(u)
        self.target = u

        if u then
            if self.timer then
                self.timer()
            end
            self.timer = Timed.echo(UPDATE_POSITION_PERIOD, function ()
                if self.target then
                    SetUnitX(self.bar, GetUnitX(self.target) + self.xOffset)
                    SetUnitY(self.bar, GetUnitY(self.target) + self.yOffset)
                else
                    return true
                end
            end)
            SetUnitX(self.bar, GetUnitX(self.target) - self.xOffset)
            SetUnitY(self.bar, GetUnitY(self.target) - self.yOffset)
            self.t_enabled = true
        else
            if self.timer then
                self.timer()
            end
            self.t_enabled = false
        end
    end

    return ProgressBar
end)
if Debug then Debug.endFile() end