Debug.beginFile("Menu")
OnInit("Menu", function ()
    local Frames = {} ---@type framehandle[]
    local WasVisible = __jarray(false) ---@type boolean[]
    local LocalPlayer = GetLocalPlayer()
    local DefaultHeight = BlzFrameGetHeight(BlzGetFrameByName("ConsoleUIBackdrop",0))
    local MenuStack = {} ---@type framehandle[]

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

    ---@param frame framehandle
    function AddButtonToEscStack(frame)
        table.insert(MenuStack, frame)
    end

    ---@param frame framehandle
    function RemoveButtonFromEscStack(frame)
        for i = #MenuStack, 1, -1 do
            if MenuStack[i] == frame then
                table.remove(MenuStack, i)
                break
            end
        end
    end

    OnInit.final(function ()
        local t = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerEvent(t, GetEnumPlayer(), EVENT_PLAYER_END_CINEMATIC)
        end)
        TriggerAddAction(t, function ()
            if GetTriggerPlayer() == LocalPlayer then
                local frame = MenuStack[#MenuStack]
                if frame then
                    BlzFrameClick(frame)
                end
            end
        end)
    end)

end)
Debug.endFile()