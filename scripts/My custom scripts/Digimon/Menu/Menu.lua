Debug.beginFile("Menu")
OnInit("Menu", function ()
    local Frames = {} ---@type framehandle[]
    local WasVisible = __jarray(false) ---@type boolean[]
    local LocalPlayer = GetLocalPlayer()
    local Console = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local DefaultHeight = BlzFrameGetHeight(Console)
    local MenuStack = {} ---@type framehandle[]
    --local HideSimpleFrame = nil ---@type framehandle

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

    if not BlzLoadTOCFile("Templates.toc") then
        print("Loading Templates Toc file failed")
    end

    ---@param frame framehandle
    ---@param title string
    ---@param content string
    function AddDefaultTooltip(frame, title, content)
        local tooltip = BlzCreateFrame("BoxedText", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        local text = BlzGetFrameByName("BoxedTextValue", 0)

        BlzFrameSetText(BlzGetFrameByName("BoxedTextTitle", 0), title)

        BlzFrameSetText(text, content)
        BlzFrameSetSize(text, 0.25, 0)
        BlzFrameSetAbsPoint(text, FRAMEPOINT_BOTTOMRIGHT, 0.790000, 0.18500)
        BlzFrameSetPoint(tooltip,FRAMEPOINT_TOPLEFT, text, FRAMEPOINT_TOPLEFT, -0.01, 0.025)
        BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOMRIGHT, text, FRAMEPOINT_BOTTOMRIGHT, 0.01, -0.01)

        BlzFrameSetTooltip(frame, tooltip)
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

        --[[HideSimpleFrame = BlzCreateFrameByType("SIMPLEFRAME", "HideSimpleFrame", BlzGetFrameByName("ConsoleUI", 0), "", 0)
        -- Warcraft 3 V1.31
        BlzFrameSetParent(BlzFrameGetParent(BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, 0)), HideSimpleFrame)
        -- Current has access by Name for it (Parent hierachy is a little bit different from V1.31)
        BlzFrameSetParent(BlzGetFrameByName("CommandBarFrame", 0), HideSimpleFrame)
        AddFrameToMenu(HideSimpleFrame)]]
    end)

end)
Debug.endFile()