if Debug then Debug.beginFile("File IO") end
OnInit("FileIO", function ()
    --[[**************************************************************
    *
    *   based on File IO v1.1.0, by TriggerHappy
    *   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    *
    *   Provides functionality to read and write files.
    *   _________________________________________________________________________
    *   1. Requirements
    *   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    *       - Patch 1.31 or higher.
    *   _________________________________________________________________________
    *   2. Installation
    *   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    *   Copy the script to your map and save it.
    *   _________________________________________________________________________
    *   3. API
    *   ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
    *
    *           integer File.AbilityCount
    *           integer File.PreloadLimit
    *
    *           boolean File.ReadEnabled
    *
    *           function File.open(string filename) returns File
    *           function File.create(string filename) returns File
    *
    *           ---------
    *
    *           function File:write(string value) returns File
    *           function File:read() returns string
    *
    *           function File:readEx(boolean close) returns string
    *           function File:readAndClose() returns string
    *           function File:readBuffer() returns string
    *           function File:writeBuffer(string contents) returns nothing
    *           function File:appendBuffer(string contents) returns nothing
    *
    *           function File:close()
    *
    *           function FileIO.Write(string filename, string contents)
    *           function FileIO.Read(string filename)
    *
    **************************************************************]]--

    ---@class File
    ---@field filename string
    ---@field buffer string
    File = {
        AbilityCount = 10,
        PreloadLimit = 200,

        Counter = 0,
        AbilityList = __jarray(0),   ---@type integer[]

        ReadEnabled = false
    }
    File.__index = File

    ---@param filename string
    ---@return File
    function File.open(filename)
        local file = setmetatable({}, File)

        file.filename = filename
        file.buffer = ""

        return file
    end

    local function validateInput(contents)
        for i = 1, contents:len() do
            local ch = contents:sub(i, i)
            if (ch == "\\") then
                return ch
            elseif (ch == "\"") then
                return ch
            end
        end
        return nil
    end

    ---@param contents string
    ---@return File
    function File:write(contents)
        local c = 0
        local len = contents:len()
        if validateInput(contents) then
            DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 120, "FileIO(" .. self.filename .. ") ERROR: Invalid character |cffffcc00" .. validateInput(contents) .. "|r")
            return self
        end

        self.buffer = ""

        -- Check if the string is empty. If "", the contents will be cleared.
        if contents == "" then
            len = len + 1
        end

        -- Begin to generate the file
        PreloadGenClear()
        PreloadGenStart()
        local i = 1
        while i <= len do

            if c >= File.AbilityCount then
                DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 120, "FileIO(" .. self.filename .. ") ERROR: String exceeds max length (" .. I2S(File.AbilityCount * File.PreloadLimit) .. ").|r")
            end

            local chunk = contents:sub(i, i + File.PreloadLimit)
            Preload("\" )\ncall BlzSetAbilityTooltip(" .. File.AbilityList[c] .. ", \"" .. "-" .. chunk .. "\", " .. 0 .. ")\n//")
            i = i + File.PreloadLimit + 1
            c = c + 1
        end
        Preload("\" )\nendfunction\nfunction a takes nothing returns nothing\n //")
        PreloadGenEnd(self.filename)

        return self
    end

    ---@return File
    function File:clear()
        return File:write("")
    end

    ---@return string
    function File:_readPreload()
        local original = __jarray("")
        local output = ""

        for i = 0, File.AbilityCount - 1 do
            original[i] = BlzGetAbilityTooltip(File.AbilityList[i], 0)
        end

        -- Execute the preload file
        Preloader(self.filename)

        -- Read the output
        for i = 0, File.AbilityCount - 1 do
            -- Make sure the tooltip has changed
            local chunk = BlzGetAbilityTooltip(File.AbilityList[i], 0)

            if chunk == original[i] then
                if i == 0 and output == "" then
                    return "" -- empty file
                end
                return output
            end

            -- Check if the file is an empty string or null
            if (i == 0) then
                if chunk:sub(1, 1) ~= "-" then
                    return "" -- empty file
                end
                chunk = chunk:sub(2)
            end

            -- Remove the prefix
            if i > 0 then
                chunk = chunk:sub(2)
            end

            -- Restore the tooltip and append the chunk
            BlzSetAbilityTooltip(File.AbilityList[i], original[i], 0)

            output = output .. chunk
        end

        return output
    end

    function File:close()
        if self.buffer ~= "" then
            self:write(self:_readPreload() .. self.buffer)
            self.buffer = ""
        end
    end

    ---@param close boolean
    ---@return string
    function File:readEx(close)
        local output = self:_readPreload()
        local buf = self.buffer

        if close then
            self:close()
        end

        if output == "" then
            return buf
        end

        if buf ~= "" then
            output = output .. buf
        end

        return output
    end

    ---@return string
    function File:read()
        return self:readEx(false)
    end

    ---@return string
    function File:readAndClose()
        return self:readEx(true)
    end

    ---@param contents string
    ---@return File
    function File:appendBuffer(contents)
        self.buffer = self.buffer .. contents
        return self
    end

    ---@return string
    function File:readBuffer()
        return self.buffer
    end

    ---@param contents string
    function File:writeBuffer(contents)
        self.buffer = contents
    end

    ---@param filename string
    ---@return File
    function File.create(filename)
        return File.open(filename):write("")
    end

    OnInit.trig(function ()
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

        -- Read check
        File.ReadEnabled = File.open("FileTester.pld"):write("FileIO__"):readAndClose() == "FileIO__"
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
        return File.open(filename):readEx(true)
    end
end)
if Debug then Debug.endFile() end