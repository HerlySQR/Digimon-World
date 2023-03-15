Debug.beginFile("Menu")
OnInit("Menu", function ()
    local Frames = {} ---@type framehandle[]
    local WasVisible = __jarray(false) ---@type boolean[]
    local LocalPlayer = GetLocalPlayer()
    local DefaultHeight = BlzFrameGetHeight(BlzGetFrameByName("ConsoleUIBackdrop",0))

    ---@param showOriginFrames boolean?
    function ShowMenu(showOriginFrames)
        for i, frame in ipairs(Frames) do
            BlzFrameSetVisible(frame, WasVisible[i])
        end
        if showOriginFrames then
            BlzHideOriginFrames(false)
            BlzFrameSetSize(BlzGetFrameByName("ConsoleUIBackdrop",0), 0, DefaultHeight)
        end
    end

    ---@param hideOriginFrames boolean?
    function HideMenu(hideOriginFrames)
        for i, frame in ipairs(Frames) do
            WasVisible[i] = BlzFrameIsVisible(frame)
            BlzFrameSetVisible(frame, false)
        end
        if hideOriginFrames then
            BlzHideOriginFrames(true)
            BlzFrameSetSize(BlzGetFrameByName("ConsoleUIBackdrop",0), 0, 0.0001)
        end
    end

    ---@param frame framehandle
    function AddFrameToMenu(frame)
        table.insert(Frames, frame)
        WasVisible[#Frames] = BlzFrameIsVisible(frame)
    end
end)
Debug.endFile()