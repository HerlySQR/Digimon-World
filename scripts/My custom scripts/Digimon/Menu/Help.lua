Debug.beginFile("Help")
OnInit("Help", function ()
    Require "Menu"
    Require "FrameLoader"
    Require "FrameEffects"

    local HelpButton = nil ---@type framehandle
    local BackdropHelpButton = nil ---@type framehandle
    local HelpImage = nil ---@type framehandle

    local function ShowImage()
        local p = GetTriggerPlayer()

        if p == GetLocalPlayer() then
            BlzFrameSetVisible(HelpImage, true)
            BlzFrameSetAlpha(HelpImage, 255)
        end
        Timed.call(4.25, function ()
            FrameFadeOut(HelpImage, 1., p)
        end)
    end

    local function InitFrames()
        local t

        HelpButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        BlzFrameSetAbsPoint(HelpButton, FRAMEPOINT_TOPLEFT, 0.400000, 0.180000)
        BlzFrameSetAbsPoint(HelpButton, FRAMEPOINT_BOTTOMRIGHT, 0.435000, 0.145000)
        BlzFrameSetVisible(HelpButton, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, HelpButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ShowImage)
        BlzFrameSetVisible(HelpButton, false)
        AddFrameToMenu(HelpButton)
        AddDefaultTooltip(HelpButton, "Help", "Press to get help about the UI.")

        BackdropHelpButton = BlzCreateFrameByType("BACKDROP", "BackdropHelpButton", HelpButton, "", 0)
        BlzFrameSetAllPoints(BackdropHelpButton, HelpButton)
        BlzFrameSetTexture(BackdropHelpButton, "ReplaceableTextures\\CommandButtons\\BTNHelpIcon.blp", 0, true)

        HelpImage = BlzCreateFrameByType("BACKDROP", "HelpImage", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
        BlzFrameSetAllPoints(HelpImage, BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0))
        BlzFrameSetTexture(HelpImage, "war3mapImported\\Help.blp", 0, true)
        BlzFrameSetVisible(HelpImage, false)
    end

    FrameLoaderAdd(InitFrames)

    ---@param p player
    ---@param flag boolean
    function ShowHelp(p, flag)
        if p == GetLocalPlayer() then
            BlzFrameSetVisible(HelpButton, flag)
        end
    end
end)
Debug.endFile()