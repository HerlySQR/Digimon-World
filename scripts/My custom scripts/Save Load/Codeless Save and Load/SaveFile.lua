if Debug then Debug.beginFile("SaveFile") end
OnInit("SaveFile", function ()
    Require "FileIO"

    SaveFile = {
        ManualPath = "Manual",
        InvalidPath = "Unknown",
        MIN = 1,
        MAX = 10
    }

    ---@param version? string
    ---@return string
    function SaveFile.getFolder(version)
        if not version then
            return udg_MapName
        end
        return udg_MapName:sub(1, udg_MapName:find("\\") or -1) .. version
    end

    ---@param p player
    ---@param slot integer
    ---@param version? string
    ---@return string
    function SaveFile.getPath(p, slot, version)
        if slot == 0 then
            return SaveFile.getFolder(version) .. "\\" .. GetPlayerName(p) .. "\\SaveSlot_" .. SaveFile.InvalidPath .. ".pld"
        elseif slot > 0 and (slot < SaveFile.MIN or slot > SaveFile.MAX) then
            return SaveFile.getFolder(version) .. "\\" .. GetPlayerName(p) .. "\\SaveSlot_" .. SaveFile.InvalidPath .. ".pld"
        elseif slot < 0 then
            return SaveFile.getFolder(version) .. "\\" .. GetPlayerName(p) .. "\\SaveSlot_" .. SaveFile.ManualPath .. ".pld"
        end
        return SaveFile.getFolder(version) .. "\\" .. GetPlayerName(p) .. "\\SaveSlot_" .. slot .. ".pld"
    end

    ---@overload fun(p: player, name: string)
    ---@param p player
    ---@param slot integer
    ---@param name string
    ---@return string
    function SaveFile.getPath2(p, slot, name)
        if not name then
            name = slot
            slot = nil
        end
        if slot then
            return SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\SaveSlot_" .. slot .. "\\" .. name .. ".pld"
        else
            return SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\" .. name .. ".pld"
        end
    end

    ---@param p player
    ---@param title string
    ---@param slot integer
    ---@param data string
    ---@param version? string
    ---@return integer
    function SaveFile.create(p, title, slot, data, version)
        if GetLocalPlayer() == p then
            FileIO.Write(SaveFile.getPath(p, slot, version), title .. "\n" .. data)
        end
        return slot
    end

    ---@param p player
    ---@param slot integer
    ---@param version? string
    ---@return integer
    function SaveFile.clear(p, slot, version)
        if GetLocalPlayer() == p then
            FileIO.Write(SaveFile.getPath(p, slot, version), "")
        end
        return slot
    end

    ---@async
    ---@param p player
    ---@param slot integer
    ---@param version? string
    ---@return boolean
    function SaveFile.exists(p, slot, version)
        return FileIO.Read(SaveFile.getPath(p, slot, version)):len() > 1
    end

    ---@async
    ---@param p player
    ---@param slot integer
    ---@param line integer
    ---@param includePrevious boolean
    ---@param version? string
    ---@return string
    function SaveFile.getLines(p, slot, line, includePrevious, version)
        local contents   = FileIO.Read(SaveFile.getPath(p, slot, version))
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

    ---@async
    ---@param p player
    ---@param slot integer
    ---@param line integer
    ---@param version? string
    ---@return string
    function SaveFile.getLine(p, slot, line, version)
        return SaveFile.getLines(p, slot, line, false, version)
    end

    ---@async
    ---@param p player
    ---@param slot integer
    ---@param version? string
    ---@return string
    function SaveFile.getTitle(p, slot, version)
        return SaveFile.getLines(p, slot, 0, false, version)
    end

    ---@async
    ---@param p player
    ---@param slot integer
    ---@param version? string
    ---@return string
    function SaveFile.getData(p, slot, version)
        return SaveFile.getLines(p, slot, 1, false, version)
    end
end)
if Debug then Debug.endFile() end