do

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

    ---@param slot integer
    ---@return string
    function SaveFile.getPath(slot)
        if slot == 0 then
            return SaveFile.getFolder() .. "\\SaveSlot_" .. SaveFile.InvalidPath .. ".pld"
        elseif slot > 0 and (slot < SaveFile.MIN or slot > SaveFile.MAX) then
            return SaveFile.getFolder() .. "\\SaveSlot_" .. SaveFile.InvalidPath .. ".pld"
        elseif slot < 0 then
            return SaveFile.getFolder() .. "\\SaveSlot_" .. SaveFile.ManualPath .. ".pld"
        end
        return SaveFile.getFolder() ..  "\\SaveSlot_" .. slot .. ".pld"
    end

    ---@param p player
    ---@param title string
    ---@param slot integer
    ---@param data string
    function SaveFile.create(p, title, slot, data)
        if GetLocalPlayer() == p then
            FileIO.Write(SaveFile.getPath(slot), title .. "\n" .. data)
        end
    end

    ---@param p player
    ---@param slot integer
    function SaveFile.clear(p, slot)
        if GetLocalPlayer() == p then
            FileIO.Write(SaveFile.getPath(slot), "")
        end
    end

    ---async
    ---@param slot integer
    ---@return boolean
    function SaveFile.exists(slot)
        return FileIO.Read(SaveFile.getPath(slot)) ~= nil
    end

    ---async
    ---@param slot integer
    ---@param line integer
    ---@param includePrevious boolean
    ---@return string
    function SaveFile.getLines(slot, line, includePrevious)
        local contents = FileIO.Read(SaveFile.getPath(slot)) or ""
        local len = StringLength(contents)
        local buffer = ""
        local curLine = 0
        for i = 0, len do
            local char = SubString(contents, i, i + 1)
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
        return nil
    end

    ---async
    ---@param slot integer
    ---@param line integer
    ---@return string
    function SaveFile.getLine(slot, line)
        return SaveFile.getLines(slot, line, false)
    end

    ---async
    ---@param slot integer
    ---@return string
    function SaveFile.getTitle(slot)
        return SaveFile.getLines(slot, 0, false)
    end

    ---async
    ---@param slot integer
    ---@return string
    function SaveFile.getData(slot)
        return SaveFile.getLines(slot, 1, false)
    end
end