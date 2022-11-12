OnInit("SaveFile", function ()
    Require "FileIO"

    SaveFile = {
        ManualPath = "Manual",
        InvalidPath = "Unknown",
        MIN = 1,
        MAX = 10
    }

    ---@return string
    function SaveFile.getFolder()
        return udg_MapName
    end

    ---@param p player
    ---@param slot integer
    ---@return string
    function SaveFile.getPath(p, slot)
        if slot == 0 then
            return SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\SaveSlot_" .. SaveFile.InvalidPath .. ".pld"
        elseif slot > 0 and (slot < SaveFile.MIN or slot > SaveFile.MAX) then
            return SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\SaveSlot_" .. SaveFile.InvalidPath .. ".pld"
        elseif slot < 0 then
            return SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\SaveSlot_" .. SaveFile.ManualPath .. ".pld"
        end
        return SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\SaveSlot_" .. slot .. ".pld"
    end

    ---@param p player
    ---@param title string
    ---@param slot integer
    ---@param data string
    ---@return integer
    function SaveFile.create(p, title, slot, data)
        if GetLocalPlayer() == p then
            FileIO.Write(SaveFile.getPath(p, slot), title .. "\n" .. data)
        end
        return slot
    end

    ---@param p player
    ---@param slot integer
    ---@return integer
    function SaveFile.clear(p, slot)
        if GetLocalPlayer() == p then
            FileIO.Write(SaveFile.getPath(p, slot), "")
        end
        return slot
    end

    -- async
    ---@param p player
    ---@param slot integer
    ---@return boolean
    function SaveFile.exists(p, slot)
        return FileIO.Read(SaveFile.getPath(p, slot)):len() > 1
    end

    -- async
    ---@param p player
    ---@param slot integer
    ---@param line integer
    ---@param includePrevious boolean
    ---@return string
    function SaveFile.getLines(p, slot, line, includePrevious)
        local contents   = FileIO.Read(SaveFile.getPath(p, slot))
        local buffer     = ""
        local curLine   = 0

        for i = 1, contents:len() do
            local char = contents:sub(i, i)
            if char == "\n" then
                curLine = curLine + 1
                if curLine > line then
                    return buffer
                end
                if not includePrevious then
                    buffer = ""
                end
            else
                buffer = buffer .. char
            end
        end
        if curLine == line then
            return buffer
        end
        return ""
    end

    -- async
    ---@param p player
    ---@param slot integer
    ---@param line integer
    ---@return string
    function SaveFile.getLine(p, slot, line)
        return SaveFile.getLines(p, slot, line, false)
    end

    -- async
    ---@param p player
    ---@param slot integer
    ---@return string
    function SaveFile.getTitle(p, slot)
        return SaveFile.getLines(p, slot, 0, false)
    end

    -- async
    ---@param p player
    ---@param slot integer
    ---@return string
    function SaveFile.getData(p, slot)
        return SaveFile.getLines(p, slot, 1, false)
    end
end)