OnInit("Color", function ()
    Require "AddHook" -- https://www.hiveworkshop.com/threads/hook.339153/

    ---If this value is true the W3 native color functions are hooked to accept `Color` as parameter
    local HOOK_COLOR_FUNCTIONS = true

    ---Converts an integer to a string of the format AARRGGBB
    ---@param num integer
    ---@return string
    function Hex2Str(num)
        return string.format("\x2502x", num)
    end

    ---Converts an string of the format AARRGGBB to a integer or a failure
    ---@param s string
    ---@return integer
    function Str2Hex(s)
        if s:sub(1, 2) == "0x" then
            s = s:sub(3)
        end
        return tonumber(s, 16)
    end

    ---@param i1 integer
    ---@param alpha number
    ---@param i2 integer
    ---@return integer
    local function lerp(i1, alpha, i2)
        return math.floor(i1 * (1 - alpha) + (i2 * alpha))
    end

    ---@class Color
    ---@field red integer
    ---@field green integer
    ---@field blue integer
    ---@field alpha integer
    local Color = {}
    Color.__index = Color

    ---@param r integer | string  Could be an integer in the range 0-255, an integer in the hex base or a string with the format "0xRRGGBB" or "RRGGBB" "0xAARRGGBB" or "AARRGGBB"
    ---@param g? integer          Should be an integer in the range 0-255 or a hex with at most 2 digits
    ---@param b? integer          Should be an integer in the range 0-255 or a hex with at most 2 digits
    ---@param a? integer          Should be an integer in the range 0-255 or a hex with at most 2 digits or nil
    ---@return Color
    function Color.new(r, g, b, a)
        if type(r) == "string" then
            r = assert(Str2Hex(r), "Invalid parameter at Color()")
        elseif math.type(r) ~= "integer" then
            error("Invalid parameter at Color()", 2)
        end

        if not g then
            local col = r
            if col > 0x1000000 then
                a = col // 0x1000000
                col = col - a * 0x1000000
            else
                a = 0xff
            end

            r = col // 0x10000
            col = col-r * 0x10000
            g = col // 0x100
            b = col-g * 0x100
        else
            a = a or 0xff
            assert(a >= 0x00 and a <= 0xff, "Parameter alpha is out of bounds")
            assert(r >= 0x00 and r <= 0xff, "Parameter red is out of bounds")
            assert(g >= 0x00 and g <= 0xff, "Parameter green is out of bounds")
            assert(b >= 0x00 and b <= 0xff, "Parameter red is out of bounds")
        end

        return setmetatable({red = r, green = g, blue = b, alpha = a}, Color)
    end

    ---Returns the color to a hex number
    ---@return integer
    function Color:toHex()
        return BlzConvertColor(self.alpha, self.red, self.green, self.blue)
    end

    ---Returns the color to a string with the format AARRGGBB
    ---@return string
    function Color:toHexString()
        return Hex2Str(self:toHex())
    end

    ---Returns the linear interpolation between this and the other color
    ---@param other Color
    ---@param smoothness? number [0, 1] Default 0.5
    ---@return Color
    function Color:lerp(other, smoothness)
        return Color.new(lerp(self:toHex(), smoothness or 0.5, other:toHex()))
    end

    Color[0] = Color.new(0xFF0303) -- red
    Color[1] = Color.new(0x0042FF)  -- blue
    Color[2] = Color.new(0x1CE6B9)  -- teal
    Color[3] = Color.new(0x540081)  -- purple
    Color[4] = Color.new(0xFFFC00)  -- yellow
    Color[5] = Color.new(0xFE8A0E)  -- orange
    Color[6] = Color.new(0x20C000)  -- green
    Color[7] = Color.new(0xE55BB0)  -- pink
    Color[8] = Color.new(0x959697)  -- gray
    Color[9] = Color.new(0x7EBFF1)  -- lightBlue
    Color[10] = Color.new(0x106246)  -- darkGreen
    Color[11] = Color.new(0x4A2A04)  -- brown
    Color[12] = Color.new(0x9B0000)  -- maroon
    Color[13] = Color.new(0x0000C3)  -- navy
    Color[14] = Color.new(0x00EAFF)  -- turquoise
    Color[15] = Color.new(0xBE00FE)  -- violet
    Color[16] = Color.new(0xEBCD87)  -- wheat
    Color[17] = Color.new(0xF8A48B)  -- peach
    Color[18] = Color.new(0xBFFF80)  -- mint
    Color[19] = Color.new(0xDCB9EB)  -- lavender
    Color[20] = Color.new(0x282828)  -- coal
    Color[21] = Color.new(0xEBF0FF)  -- snow
    Color[22] = Color.new(0x00781E)  -- emerald
    Color[23] = Color.new(0xA46F33)  -- peanut

    for i = 0, bj_MAX_PLAYERS - 1 do
        Color[Player(i)] = Color[i]
        Color[ConvertPlayerColor(i)] = Color[i]
    end

    ---@param s string
    ---@param c Color
    ---@return string
    function string.color(s, c)
        return "|c" .. c:toHexString() .. s .. "|r"
    end

    -- Utility functions

    ---@param whichItem item
    ---@return Color
    function GetItemTintingColor(whichItem)
        return Color.new(
            BlzGetItemIntegerField(whichItem, ITEM_IF_TINTING_COLOR_RED),
            BlzGetItemIntegerField(whichItem, ITEM_IF_TINTING_COLOR_GREEN),
            BlzGetItemIntegerField(whichItem, ITEM_IF_TINTING_COLOR_BLUE),
            BlzGetItemIntegerField(whichItem, ITEM_IF_TINTING_COLOR_ALPHA)
        )
    end

    ---@param whichUnit unit
    ---@return Color
    function GetUnitTintingColor(whichUnit)
        return Color.new(
            BlzGetUnitIntegerField(whichUnit, UNIT_IF_TINTING_COLOR_RED),
            BlzGetUnitIntegerField(whichUnit, UNIT_IF_TINTING_COLOR_GREEN),
            BlzGetUnitIntegerField(whichUnit, UNIT_IF_TINTING_COLOR_BLUE),
            BlzGetUnitIntegerField(whichUnit, UNIT_IF_TINTING_COLOR_ALPHA)
        )
    end

    ---@param whichBolt lightning
    ---@return Color
    function GetLightningColor(whichBolt)
        return Color.new(
            R2I(255 * GetLightningColorR(whichBolt) + 0.5),
            R2I(255 * GetLightningColorG(whichBolt) + 0.5),
            R2I(255 * GetLightningColorB(whichBolt) + 0.5),
            R2I(255 * GetLightningColorA(whichBolt) + 0.5)
        )
    end

    if HOOK_COLOR_FUNCTIONS then
        ---@param func string
        local function hook1(func)
            AddHook(func, function (h, red, green, blue, alpha)
                if not green then
                    _G[func].original(h, red.red, red.green, red.blue, red.alpha)
                else
                    _G[func].original(h, red, green, blue, alpha)
                end
            end)
        end

        ---@param func string
        local function hook2(func)
            AddHook(func, function (red, green, blue, alpha)
                if not green then
                    _G[func].original(red.red, red.green, red.blue, red.alpha)
                else
                    _G[func].original(red, green, blue, alpha)
                end
            end)
        end

        hook1("SetUnitVertexColor")
        hook1("SetTextTagColor")
        hook1("TimerDialogSetTitleColor")
        hook1("TimerDialogSetTimeColor")
        hook1("LeaderboardSetLabelColor")
        hook1("LeaderboardSetValueColor")
        hook1("LeaderboardSetItemLabelColor")
        hook1("LeaderboardSetItemValueColor")
        hook1("MultiboardSetTitleTextColor")
        hook1("MultiboardSetItemsValueColor")
        hook1("MultiboardSetItemValueColor")
        hook1("LeaderboardSetItemValueColor")
        AddHook("SetLightningColor", function (whichBolt, r, g, b)
            if not g then
                SetLightningColor.original(whichBolt, r.red/255, r.green/255, r.blue/255, r.alpha/255)
            else
                SetLightningColor.original(whichBolt, r, g, b)
            end
        end)
        hook1("SetImageColor")
        AddHook("BlzSetSpecialEffectColor", function (whichEffect, r, g, b)
            if not g then
                BlzSetSpecialEffectColor.original(whichEffect, r.red, r.green, r.blue)
                BlzSetSpecialEffectAlpha(whichEffect, r.alpha)
            else
                BlzSetSpecialEffectColor.original(whichEffect, r, g, b)
            end
        end)
        AddHook("BlzFrameSetTextColor", function (frame, color)
            if type(color) == "table" then
                BlzFrameSetTextColor.original(frame, color:toHex())
            else
                BlzFrameSetTextColor.original(frame, color)
            end
        end)
        AddHook("BlzFrameSetVertexColor", function (frame, color)
            if type(color) == "table" then
                BlzFrameSetTextColor.original(frame, color:toHex())
            else
                BlzFrameSetTextColor.original(frame, color)
            end
        end)

        hook2("SetCineFilterStartColor")
        hook2("SetCineFilterEndColor")
        hook2("SetWaterBaseColor")
    end

    return Color
end)