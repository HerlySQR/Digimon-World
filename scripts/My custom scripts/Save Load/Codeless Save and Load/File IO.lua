if OnGlobalInit then
    local SCOPE_PREFIX  = "FileIO_"
    --
    --[[**************************************************************
    *
    *   Based on TriggerHappy's in FileIO v1.1.0
    *   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    *
    *   Provides functionality to read and write files.
    *   _________________________________________________________________________
    *   1. Requirements
    *   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    *       - Patch 1.29 or higher.
    *   _________________________________________________________________________
    *   2. Installation
    *   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    *   Copy the script to your map and save it.
    *   _________________________________________________________________________
    *   3. API
    *   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    *
    *   integer File.AbilityCount
    *   integer File.PreloadLimit
    *
    *   boolean File.ReadEnabled
    *   integer File.Counter
    *   integer[] File.List
    *
    *   function File.open(string filename) returns File
    *   function File.create(string filename) returns File
    *
    *           ---------
    *
    *   function File:write(string value) returns File
    *   function File:read() returns string
    *
    *   function File:readEx(boolean close) returns string
    *   function File:readAndClose() returns string
    *   function File:readBuffer() returns string
    *   function File:writeBuffer(string contents)
    *   function File:appendBuffer(string contents)
    *
    *   function File:close()
    *
    *   function File.Write(string filename, string contents)
    *   function File.Read(string filename)returns string
    *
    **************************************************************]]


    -- Enable self if you want to allow the system to read files generated in patch 1.30 or below.
    -- NOTE: For self to work properly you must edit the FourCC('Amls') ability and change the levels to 2
    -- as well as typing something in "Level 2 - Text - Tooltip - Normal" text field.
    --
    -- Enabling self will also cause the system to treat files written with self:write("") as empty files.
    --
    -- This setting is really only intended for those who were already using the system in their map
    -- prior to patch 1.31 and want to keep old files created with self system to still work.
    local BACKWARDS_COMPATABILITY = true

    -- Set this value to true to display the errors
    local DEBUG_MODE = true

    ---@class File
    ---@field filename string
    ---@field _buffer string
    File = {
        AbilityCount = 10,
        PreloadLimit = 200,

        AbilityList = {}
    }

    File.__index = File

    ---@param filename string
    ---@return File
    function File.open(filename)
        local self = setmetatable({}, File)

        self.filename = filename
        self._buffer = nil

        return self
    end

    local function validateInput(contents)
        local l = StringLength(contents) - 1
        local ch = ""
        for i = 0, l do
            ch = SubString(contents, i, i + 1)
            if ch == "\\" then
                return ch
            elseif ch == "\"" then
                return ch
            end
        end
        return nil
    end

    ---@param contents string
    ---@return File
    function File:write(contents)
        if DEBUG_MODE then
            if validateInput(contents) ~= nil then
                DisplayTimedTextToPlayer(GetLocalPlayer(),0,0, 120, "FileIO(" .. self.filename .. ") ERROR: Invalid character |cffffcc00" .. validateInput(contents) .. "|r")
                return self
            end
        end

        self._buffer = nil

        local len = StringLength(contents)

        -- Check if the string is empty. If nil, the contents will be cleared.
        if contents == "" then
            len = len + 1
        end

        local prefix = "-" -- this is used to signify an empty string vs a null one
        local c = 0

        -- Begin to generate the file
        PreloadGenClear()
        PreloadGenStart()

        local i = 0
        while i < len do
            if DEBUG_MODE then
                if c >= File.AbilityCount then
                    DisplayTimedTextToPlayer(GetLocalPlayer(),0,0, 120, "FileIO(" .. File.filename .. ") ERROR: String exceeds max length (" .. (File.AbilityCount * File.PreloadLimit) .. ").|r")
                end
            end

            local lev = 0
            if BACKWARDS_COMPATABILITY then
                if c == 0 then
                    lev = 1
                    prefix = ""
                else
                    prefix = "-"
                end
            end

            local chunk = SubString(contents, i, i + File.PreloadLimit)
            Preload("\" )\ncall BlzSetAbilityTooltip(" .. (File.AbilityList[c] or 0) .. ", \"" .. prefix .. chunk .. "\", " .. lev .. ")\n//")
            i = i + File.PreloadLimit
            c = c + 1
        end
        Preload("\" )\nendfunction\nfunction a takes nothing returns nothing\n //")
        PreloadGenEnd(self.filename)

        return self
    end

    ---@return File
    function File:clear()
        return self:write(nil)
    end

    ---@return string
    function File:_readPreload()
        local original = {}

        for i = 0, File.AbilityCount - 1 do
            original[i] = BlzGetAbilityTooltip(File.AbilityList[i], 0)
        end

        -- Execute the preload file
        Preloader(self.filename)

        -- Read the output
        local chunk = ""
        local output = ""
        for i = 0, File.AbilityCount - 1 do
            local lev = 0

            -- Read from ability index 1 instead of 0 if
            -- backwards compatability is enabled
            if BACKWARDS_COMPATABILITY then
                if i == 0 then
                    lev = 1
                end
            end

            -- Make sure the tooltip has changed
            chunk = BlzGetAbilityTooltip(File.AbilityList[i], lev)

            if chunk == original[i] then
                if i == 0 and output == "" then
                    return nil -- empty file
                end
                return output
            end

            -- Check if the file is an empty string or null
            if not BACKWARDS_COMPATABILITY then
                if i == 0 then
                    if SubString(chunk, 0, 1) ~= "-" then
                        return nil -- empty file
                    end
                    chunk = SubString(chunk, 1, StringLength(chunk))
                end
            end

            -- Remove the prefix
            if i > 0 then
                chunk = SubString(chunk, 1, StringLength(chunk))
            end

            -- Restore the tooltip and append the chunk
            BlzSetAbilityTooltip(File.AbilityList[i], original[i], lev)

            output = output .. chunk
        end

        return output
    end

    function File:close()
        if self._buffer then
            self:write(self:_readPreload() .. self._buffer)
            self._buffer = nil
        end
    end

    ---@param close? boolean
    ---@return string
    function File:read(close)
        local output = self:_readPreload()
        local buf = self._buffer

        if close then
            self:close()
        end

        if not output then
            return buf
        end

        if buf then
            output = output .. buf
        end

        return output
    end

    ---@param contents string
    ---@return File
    function File:appendBuffer(contents)
        self._buffer = self._buffer .. contents
        return self
    end

    ---@return string
    function File:readBuffer()
        return self._buffer
    end

    ---@param contents string
    function File:writeBuffer(contents)
        self._buffer = contents
    end

    ---@param filename string
    ---@return File
    function File.create(filename)
        return File.open(filename):write("")
    end

    OnTrigInit(function ()
        local originalTooltip

        -- We can't use a single ability with multiple levels because
        -- tooltips return the first level's value if the value hasn't
        -- been set. This way we don't need to edit any object editor data.
        File.AbilityList[0] = FourCC('Amls')
        File.AbilityList[1] = FourCC('Aroc')
        File.AbilityList[2] = FourCC('Amic')
        File.AbilityList[3] = FourCC('Amil')
        File.AbilityList[4] = FourCC('Aclf')
        File.AbilityList[5] = FourCC('Acmg')
        File.AbilityList[6] = FourCC('Adef')
        File.AbilityList[7] = FourCC('Adis')
        File.AbilityList[8] = FourCC('Afbt')
        File.AbilityList[9] = FourCC('Afbk')

        -- Backwards compatability check
        if BACKWARDS_COMPATABILITY then
            if DEBUG_MODE then
                originalTooltip = BlzGetAbilityTooltip(File.AbilityList[0], 1)
                BlzSetAbilityTooltip(File.AbilityList[0], SCOPE_PREFIX, 1)
                if BlzGetAbilityTooltip(File.AbilityList[0], 1) == originalTooltip then
                    DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 120, "FileIO WARNING: Backwards compatability enabled but \"" .. GetObjectName(File.AbilityList[0]) .. "\" isn't setup properly.|r")
                end
            end
        end

        -- Read check
        File.ReadEnabled = File.open("FileTester.pld"):write(SCOPE_PREFIX):read(true) == SCOPE_PREFIX
    end)

    FileIO = {}

    ---@param filename string
    ---@param contents string
    function FileIO.Write(filename, contents)
        File.open(filename):write(contents):close()
    end

    ---@param filename string
    ---@return string
    function FileIO.Read(filename)
        return File.open(filename):read(true)
    end

end