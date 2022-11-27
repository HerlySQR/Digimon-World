OnInit("CastBar", function ()
    local Color = Require "Color" ---@type Color
    Require "Timed"
    Require "EventListener"
    --[[                     CastBar System v1.12
                                by Flux
                    http://www.hiveworkshop.com/forums/members/flux/
                    
            CastBarSystem allows you to easily create and modifies CastBars.
            
            Required skill to use:
                * Minimum Lua scripting skills, if you know how to remove
                leaks, you can easily use this system. 
            
            Features:
                * CastBar comes with a name and time remaining displayed as
                a floating text.
                * Customizable colors of CastBar and CastBar text.
                * CastBars can be free-floating, attached to unit or attached
                to a player's camera.
                * Provides event APIs allowing you to easily detect when a
                CastBar has expired.
            
        **************   HOW TO USE:   **************************
        1. Copy the variable "CastBar_Expires" to your map then copy 
        the CastBarSystem Trigger. Make sure you have Jass New Gen Pack 
        for this to work because it is written in vJASS. 
        
        2.1 If you are satisfied with the CastBar design, import Bar.blp and 
            LightningData.slk to your map as well. Make sure you have
            the same path as shown here (Press F12).
        
        2.2 If you want a different/custom design, create your own artwork
            and LightningData.slk. Then configure BAR_ID based on your
            values in LightningData.slk. Make sure the texture you create 
            is white-filled color for you to change the color.
        
        Read more here on how to customize lightning effects so you can
        make your own design for a CastBar.
        
        http://www.hiveworkshop.com/forums/general-mapping-tutorials-278/how-customise-lightning-effects-203171/
        
        3. Configure and read the API provided.
        
    ]]
    -- CONFIGURATION
    -- Initial Height of created CastBars
    local DEFAULT_HEIGHT = 50.0
    -- Initial Height of created CastBars attached to unit
    local DEFAULT_HEIGHT_IN_UNIT = 150.0
    -- The size of the floating text in the center of the CastBar
    local DEFAULT_TEXT_SIZE = 0.025
    -- The visual appearance of the CastBar
    local BAR_ID = "CBAR"

-- --------------------- SET THE COLOR OF THE CAST BAR ------------------
    -- Set the default color of the Cast Bar. Value is between 0 and 1
    -- In this current setting, CastBars will have a green color by default

    -- RGB of empty CastBar
    local EMPTY = Color.new(127, 0, 0)
    -- RGB of full CastBar by default
    local FULL = Color.new(0, 255, 0)

-- --------------------- SET THE TEXT COLOR OF THE CAST BAR ----------------
    -- Determines the defualt initial and final color of the CastBar's text
    -- In this current setting, text colors will start in fully red color and end up
    -- in fully green color. Value is between 0 and 255.
    local TEXT1 = Color.new(255, 0, 0)
    local TEXT2 = Color.new(0, 255, 0)

    --[[
            
    ==========================   Application Program Interface:   ===========================
    
    ------------------------------------CREATE CASTBAR------------------------------------
        CREATE CASTBAR INPUT ARGUMENTS
        - real time: How long the CastBar will last.
        - real barLength: The horizontal length of the CastBar.
        - string whichName: The name in the center of the CastBar
        - boolean emptyToFull: Determines the direction flow of the CastBar. If selfto true, the
            CastBar will start empty and fills as time goes. Setting it to false result to
            opposite effect.
        - boolean visibleInFog: Determines when the CastBar can be seen through Fog and BlackMask
    ]]

    -- SYSTEM VARIABLES
    local TIMEOUT = 0.03125
    local l = Location(0, 0)

    ---@class CastBar
    ---@field private u unit              The unit the CastBar is attached if any
    ---@field private paused boolean      Determines whether a CastBar is paused or not
    ---@field private t number            The current time left in the CastBar
    ---@field private t0 number           The initial time
    ---@field private height number       CastBar Height
    ---@field private p player            The player whose camera the CastBar is attached
    ---@field yOffset number              How much below the CastBar from the center of camera
    ---@field textSize number             Size of the texttag in the CastBar
    ---@field text texttag
    ---@field private e Color             CAST BAR COLOR
    ---@field private f Color             CAST BAR COLOR
    ---@field private t1 Color            TEXT COLOR CHANGE
    ---@field private t2 Color            TEXT COLOR CHANGE
    ---@field nameOffset number           x-offset of the string name, to make it appear in the middle
    ---@field textInValue boolean         If true, the texttag in the CastBar dispays the actual value. If false, the texttag in the CastBar dispays the percentage
    ---@field private x number            CastBar X Location
    ---@field private y number            CastBar Y Location
    ---@field name string                 The name of the castbar
    ---@field startEmpty boolean          If true, the cast bar will start empty and fills as time goes
    ---@field fullBar lightning
    ---@field emptyBar lightning
    ---@field private length number             The length of the CastBar
    ---@field private checkVisibility boolean
    ---@field private removeCallback function

    CastBar = {}
    CastBar.__index = CastBar
    setmetatable(CastBar, CastBar)

    CastBar.expireEvent = EventListener.create()

    ---@param time number
    ---@param barLength number
    ---@param whichName string
    ---@param emptyToFull boolean
    ---@param visibileInFog boolean
    ---@return CastBar
    function CastBar.create(time, barLength, whichName, emptyToFull, visibileInFog)
        local self = setmetatable({}, CastBar)

        self.t0 = time
        self.t = time
        self.length = barLength
        self.name = whichName
        self.startEmpty = emptyToFull
        self.checkVisibility = not visibileInFog
        self.paused = false
        self.height = DEFAULT_HEIGHT
        self.textSize = DEFAULT_TEXT_SIZE
        self.textInValue = true
        self.nameOffself= I2R(StringLength(whichName) + 5)/(8*DEFAULT_TEXT_SIZE)
        self.emptyBar = AddLightning(BAR_ID, self.checkVisibility, 0, 0, 0, 0)
        self.fullBar = AddLightning(BAR_ID, self.checkVisibility, 0, 0, 0, 0)
        self.text = CreateTextTag()

        -- CastBar Color
        self.e = EMPTY
        self.f = FULL

        SetLightningColor(self.emptyBar, self.e)
        SetLightningColor(self.fullBar, self.f)

        -- Text Color Change
        self.t1 = TEXT1
        self.t2 = TEXT2

        SetTextTagText(self.text, self.name .. ": " .. R2S(self.t), DEFAULT_TEXT_SIZE)
        SetTextTagColor(self.text, self.t1)

        self.removeCallback = Timed.echo(TIMEOUT, function () self:update() end)
    end

    ---@param x number
    ---@param y number
    ---@param time number
    ---@param barLength number
    ---@param whichName string
    ---@param emptyToFull boolean
    ---@param visibileInFog boolean
    ---@return CastBar
    function CastBar.createAtPos(x, y, time, barLength, whichName, emptyToFull, visibileInFog)
        local cb = CastBar.create(time, barLength, whichName, emptyToFull, visibileInFog)
        cb:move(x, y)
        return cb
    end

    ---@param whichUnit unit
    ---@param time number
    ---@param barLength number
    ---@param whichName string
    ---@param emptyToFull boolean
    ---@param visibileInFog boolean
    ---@return CastBar
    function CastBar.createAtUnit(whichUnit, time, barLength, whichName, emptyToFull, visibileInFog)
        local cb = CastBar.create(time, barLength, whichName, emptyToFull, visibileInFog)
        cb.u = whichUnit
        cb.height = DEFAULT_HEIGHT_IN_UNIT
        return cb
    end

    ---@param whichPlayer player
    ---@param cameraOffset number
    ---@param time number
    ---@param barLength number
    ---@param whichName string
    ---@param emptyToFull boolean
    ---@param visibileInFog boolean
    ---@return CastBar
    function CastBar.createAtPlayer(whichPlayer, cameraOffset, time, barLength, whichName, emptyToFull, visibileInFog)
        local cb = CastBar.create(time, barLength, whichName, emptyToFull, visibileInFog)
        cb.p = whichPlayer
        cb.yOffset = cameraOffset
        return cb
    end

    ---@param flag boolean
    function CastBar:pause(flag)
        self.paused = flag
    end

    function CastBar:update()
        -- If CastBar is paused and attached, update position
            if self.paused then
                if self.u  then
                    self:move(GetUnitX(self.u), GetUnitY(self.u))
                elseif self.p then
                    self:move(GetCameraTargetPositionX(), GetCameraTargetPositionY() + self.yOffset)
                end
            else
                self.t = self.t - TIMEOUT
                if self.t > 0 then
                    local percent
                    if self.u then
                        percent = self:move(GetUnitX(self.u), GetUnitY(self.u))
                    elseif self.p then
                        percent = self:move(GetCameraTargetPositionX(), GetCameraTargetPositionY() + self.yOffset)
                    else
                        percent = self:move(self.x, self.y)
                    end
                    if self.textInValue then
                        SetTextTagText(self.text, self.name .. ": " .. R2S(self.t), self.textSize)
                    else
                        SetTextTagText(self.text, self.name .. ": " .. I2S(R2I(percent*100)), self.textSize)
                    end
                    percent = 1 - percent
                    SetTextTagColor(self.text, R2I((self.tr2 - self.tr1)*percent + self.tr1), R2I((self.tg2 - self.tg1)*percent + self.tg1), R2I((self.tb2 - self.tb1)*percent + self.tb1), 255)
                else
                    CastBar.expireEvent:run(self)
                    self:destroy()
                end
            end
    end

    ---@param xPos number
    ---@param yPos number
    ---@return number
    function CastBar:move(xPos, yPos)
        local xOffset = 0.5 * self.length
        local xMin = xPos - xOffset
        local xMax = xPos + xOffset
        local percent = self.t / self.t0
        local xMid
        local zBar = self.height
        local zText = self.height - 5

        if self.startEmpty then
            xMid = xMax - (xMax - xMin)*percent
        else
            xMid = xMin + (xMax - xMin)*percent
        end
        if self.u then
            MoveLocation(l, xPos, yPos)
            zBar = zBar + GetLocationZ(l)
        elseif self.p then
            MoveLocation(l, xPos, yPos)
            zText = zText - GetLocationZ(l)
        end
        if self.checkVisibility then
            if IsVisibleToPlayer(xPos, yPos, GetLocalPlayer()) then
                SetLightningColor(self.emptyBar, self.e)
                SetLightningColor(self.fullBar, self.f)
            else
                SetLightningColor(self.fullBar, 0, 0, 0, 0)
                SetLightningColor(self.emptyBar, 0, 0, 0, 0)
            end
        end
        MoveLightningEx(self.emptyBar, self.checkVisibility, xMin, yPos, zBar, xMax, yPos, zBar)
        MoveLightningEx(self.fullBar, self.checkVisibility, xMin, yPos, zBar, xMid, yPos, zBar)
        SetTextTagPos(self.text, xPos - self.nameOffset, yPos, zText)
        self.x = xPos
        self.y = yPos

        return percent
    end

    function CastBar:destroy()
        -- Timer
        self.removeCallback()
        -- Clean Handles
        DestroyLightning(self.fullBar)
        DestroyLightning(self.emptyBar)
        if self.text then
            DestroyTextTag(self.text)
             self.text = nil
        end
        -- Clean References
        self.u = nil
        self.p = nil
        self.fullBar = nil
        self.emptyBar = nil
    end

    function CastBar:detach()
        self.cb = nil
    end

    function CastBar:reset()
        self.t = self.t0
        self.paused = false
    end

    ---@param flag boolean
    function CastBar:showText(flag)
        SetTextTagVisibility(self.text, flag)
    end

    ---@param flag boolean
    function CastBar:show(flag)
        if flag then
            SetLightningColor(self.emptyBar, self.e)
            SetLightningColor(self.fullBar, self.f)
        else
            SetLightningColor(self.fullBar, 0, 0, 0, 0)
            SetLightningColor(self.emptyBar, 0, 0, 0, 0)
        end
        SetTextTagVisibility(self.text, flag)
    end

    ---@param newTime number
    function CastBar:setTime(newTime)
        if newTime > self.t0 then
            self.t = self.t0
        else
            self.t = newTime
        end
        local percent = self.t/self.t0
        if self.textInValue then
            SetTextTagText(self.text, self.name .. ": " .. self.t, self.textSize)
        else
            SetTextTagText(self.text, self.name .. ": " .. R2I(percent*100), self.textSize)
        end
        SetTextTagColor(self.text, self.t1:lerp(self.t2, percent))
    end

    ---@param percent number
    function CastBar:setPercent(percent)
        if percent > 1 then
            self.t = self.t0
            SetTextTagColor(self.text, self.t2)
        else
            self.t = self.t0*(1 - percent)
            SetTextTagColor(self.text, self.t1:lerp(self.t2, percent))
        end
        if self.textInValue then
            SetTextTagText(self.text, self.name .. ": " .. self.t, self.textSize)
        else
            SetTextTagText(self.text, self.name .. ": " .. R2I(percent*100), self.textSize)
        end
    end

    ---@param newHeight number
    function CastBar:setHeight(newHeight)
        self.height = newHeight
    end

    ---@param newSize number
    function CastBar:setTextSize(newSize)
        local percent = self.t/self.t0
        self.textSize = newSize
        self.nameOffset = (self.name:len() + 5)/(8*newSize)
        self:move(self.x, self.y)
        if self.textInValue then
            SetTextTagText(self.text, self.name .. ": " .. self.t, self.textSize)
        else
            SetTextTagText(self.text, self.name .. ": " .. R2I(percent*100), self.textSize)
        end
        SetTextTagColor(self.text, self.t1:lerp(self.t2, percent))
    end

    ---@param flag boolean
    function CastBar:displayPercent(flag)
        self.textInValue = not flag
    end

    ---@param color Color
    function CastBar:setColor(color)
        self.f = color
        SetLightningColor(self.fullBar, color)
    end

    ---@param color1 Color
    ---@param color2 Color
    function CastBar:setColorChange(color1, color2)
        self.t1 = color1
        self.t2 = color2
    end

    ---@param newInitTime number
    function CastBar:setInitialTime(newInitTime)
        self.t0 = newInitTime
    end

    ---@return string
    function CastBar:getName()
        return self.name
    end

    ---@return unit
    function CastBar:getUnit()
        return self.u
    end

    ---@return number x, number y
    function CastBar:getPos()
        return self.x, self.y
    end
end)