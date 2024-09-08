Debug.beginFile("Help")
OnInit("Help", function ()
    Require "Menu"
    Require "FrameLoader"
    Require "FrameEffects"

    local HelpButton = nil ---@type framehandle
    local BackdropHelpButton = nil ---@type framehandle
    local HelpImage = nil ---@type framehandle
    local DiscordBackdrop = nil ---@type framehandle
    local DiscordLogo = nil ---@type framehandle
    local DiscordLink = nil ---@type framehandle
    local DiscordText = nil ---@type framehandle

    local DISCORD_LINK = "https://discord.gg/RZVSYWzA7b"

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
        HelpButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(HelpButton, 11)
        BlzFrameSetVisible(HelpButton, false)
        local t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, HelpButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ShowImage)
        BlzFrameSetVisible(HelpButton, false)
        AddFrameToMenu(HelpButton)
        AddDefaultTooltip(HelpButton, "Help", "Press to get help about the UI.")

        BackdropHelpButton = BlzCreateFrameByType("BACKDROP", "BackdropHelpButton", HelpButton, "", 0)
        BlzFrameSetAllPoints(BackdropHelpButton, HelpButton)
        BlzFrameSetTexture(BackdropHelpButton, "ReplaceableTextures\\CommandButtons\\BTNHelp3.blp", 0, true)

        HelpImage = BlzCreateFrameByType("BACKDROP", "HelpImage", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
        BlzFrameSetAllPoints(HelpImage, BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0))
        BlzFrameSetTexture(HelpImage, "war3mapImported\\Help.blp", 0, true)
        BlzFrameSetVisible(HelpImage, false)
    end

    FrameLoaderAdd(InitFrames)

    OnInit.final(function ()
        BlzFrameClick(BlzGetFrameByName("UpperButtonBarQuestsButton", 0))
        BlzFrameClick(BlzGetFrameByName("QuestAcceptButton", 0))

        FrameLoaderAdd(function ()
            DiscordBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 1)
            BlzFrameSetAbsPoint(DiscordBackdrop, FRAMEPOINT_TOPLEFT, 0.640000, 0.520000)
            BlzFrameSetAbsPoint(DiscordBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.270000)
            BlzFrameSetTexture(DiscordBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
            BlzFrameSetVisible(DiscordBackdrop, false)

            DiscordLogo = BlzCreateFrameByType("BACKDROP", "BACKDROP", DiscordBackdrop, "", 1)
            BlzFrameSetPoint(DiscordLogo, FRAMEPOINT_TOPLEFT, DiscordBackdrop, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetPoint(DiscordLogo, FRAMEPOINT_BOTTOMRIGHT, DiscordBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.090000)
            BlzFrameSetTexture(DiscordLogo, "war3mapImported\\discord_logo.blp", 0, true)

            DiscordLink = BlzCreateFrame("EscMenuEditBoxTemplate", DiscordBackdrop, 0, 0)
            BlzFrameSetPoint(DiscordLink, FRAMEPOINT_TOPLEFT, DiscordBackdrop, FRAMEPOINT_TOPLEFT, 0.0000, -0.20000)
            BlzFrameSetPoint(DiscordLink, FRAMEPOINT_BOTTOMRIGHT, DiscordBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.010000)
            BlzFrameSetText(DiscordLink, DISCORD_LINK)

            local t2 = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t2, DiscordLink, FRAMEEVENT_EDITBOX_TEXT_CHANGED)
            TriggerAddAction(t2, function ()
                if BlzFrameGetText(DiscordLink) ~= DISCORD_LINK then
                    BlzFrameSetText(DiscordLink, DISCORD_LINK)
                end
            end)

            DiscordText = BlzCreateFrameByType("TEXT", "name", DiscordBackdrop, "", 0)
            BlzFrameSetScale(DiscordText, 2.14)
            BlzFrameSetPoint(DiscordText, FRAMEPOINT_TOPLEFT, DiscordBackdrop, FRAMEPOINT_TOPLEFT, 0.0000, -0.16000)
            BlzFrameSetPoint(DiscordText, FRAMEPOINT_BOTTOMRIGHT, DiscordBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.050000)
            BlzFrameSetText(DiscordText, "|cffFFCC00Join our discord|r")
            BlzFrameSetEnable(DiscordText, false)
            BlzFrameSetTextAlignment(DiscordText, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        end)
    end)

    ---@param p player
    ---@param flag boolean
    function ShowHelp(p, flag)
        if p == GetLocalPlayer() then
            BlzFrameSetVisible(HelpButton, flag)
        end
    end
end)
Debug.endFile()