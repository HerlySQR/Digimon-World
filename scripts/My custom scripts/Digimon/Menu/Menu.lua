Debug.beginFile("Menu")
OnInit("Menu", function ()
    local Frames = {} ---@type framehandle[]
    local WasVisible = __jarray(false) ---@type boolean[]
    local LocalPlayer = GetLocalPlayer()
    local Console = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local DefaultHeight = BlzFrameGetHeight(Console)
    local MenuStack = {} ---@type framehandle[]
    local HideSimpleFrame = nil ---@type framehandle

    ---@param showOriginFrames boolean?
    function ShowMenu(showOriginFrames)
        for i, frame in ipairs(Frames) do
            BlzFrameSetVisible(frame, WasVisible[i])
        end
        if showOriginFrames then
            BlzHideOriginFrames(false)
            BlzFrameSetSize(Console, 0, DefaultHeight)
        end
    end

    ---@param hideOriginFrames boolean?
    function HideMenu(hideOriginFrames)
        for i, frame in ipairs(Frames) do
            WasVisible[i] = BlzFrameIsVisible(frame)
            BlzFrameSetVisible(frame, false)
        end
        if hideOriginFrames then
            ClearSelection()
            BlzHideOriginFrames(true)
            BlzFrameSetSize(Console, 0, 0.0001)
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

        HideSimpleFrame = BlzCreateFrameByType("SIMPLEFRAME", "HideSimpleFrame", BlzGetFrameByName("ConsoleUI", 0), "", 0)
        -- Warcraft 3 V1.31
        BlzFrameSetParent(BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, 0)), HideSimpleFrame)
        -- Current has access by Name for it (Parent hierachy is a little bit different from V1.31)
        BlzFrameSetParent(BlzGetFrameByName("CommandBarFrame", 0), HideSimpleFrame)
        AddFrameToMenu(HideSimpleFrame)
    end)

end)
Debug.endFile()