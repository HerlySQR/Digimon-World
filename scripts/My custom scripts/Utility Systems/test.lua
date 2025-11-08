WaitPlayers = nil 
TriggerWaitPlayers = nil 
WaitPlayersText = nil 
TriggerWaitPlayersText = nil 
PlayerLabel = nil 
TriggerPlayerLabel = nil 
PlayerName = nil 
TriggerPlayerName = nil 
PlayerStatus = nil 
TriggerPlayerStatus = nil 
PlayerReady = nil 
PlayerProgress = nil 
TriggerPlayerProgress = nil 
REFORGEDUIMAKER = {}
REFORGEDUIMAKER.Initialize = function()
BlzHideOriginFrames(true) 
BlzFrameSetSize(BlzGetFrameByName("ConsoleUIBackdrop",0), 0, 0.0001)


WaitPlayers = BlzCreateFrame("QuestButtonPushedBackdropTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
BlzFrameSetAbsPoint(WaitPlayers, FRAMEPOINT_TOPLEFT, 0.250000, 0.530000)
BlzFrameSetAbsPoint(WaitPlayers, FRAMEPOINT_BOTTOMRIGHT, 0.540000, 0.450000)

WaitPlayersText = BlzCreateFrameByType("TEXT", "name", WaitPlayers, "", 0)
BlzFrameSetPoint(WaitPlayersText, FRAMEPOINT_TOPLEFT, WaitPlayers, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
BlzFrameSetPoint(WaitPlayersText, FRAMEPOINT_BOTTOMRIGHT, WaitPlayers, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.040000)
BlzFrameSetText(WaitPlayersText, "|cff0091ffWaiting for load data of players|r")
BlzFrameSetEnable(WaitPlayersText, false)
BlzFrameSetScale(WaitPlayersText, 2.00)
BlzFrameSetTextAlignment(WaitPlayersText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

PlayerLabel = BlzCreateFrame("CheckListBox", WaitPlayers, 0, 0)
BlzFrameSetPoint(PlayerLabel, FRAMEPOINT_TOPLEFT, WaitPlayers, FRAMEPOINT_TOPLEFT, 0.010000, -0.050000)
BlzFrameSetPoint(PlayerLabel, FRAMEPOINT_BOTTOMRIGHT, WaitPlayers, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)

PlayerName = BlzCreateFrameByType("TEXT", "name", PlayerLabel, "", 0)
BlzFrameSetPoint(PlayerName, FRAMEPOINT_TOPLEFT, PlayerLabel, FRAMEPOINT_TOPLEFT, 0.030000, -5.5511e-17)
BlzFrameSetPoint(PlayerName, FRAMEPOINT_BOTTOMRIGHT, PlayerLabel, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.010000)
BlzFrameSetText(PlayerName, "|cffffffffName|r")
BlzFrameSetEnable(PlayerName, false)
BlzFrameSetScale(PlayerName, 1.00)
BlzFrameSetTextAlignment(PlayerName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

PlayerStatus = BlzCreateFrameByType("TEXT", "name", PlayerLabel, "", 0)
BlzFrameSetPoint(PlayerStatus, FRAMEPOINT_TOPLEFT, PlayerLabel, FRAMEPOINT_TOPLEFT, 0.030000, -0.010000)
BlzFrameSetPoint(PlayerStatus, FRAMEPOINT_BOTTOMRIGHT, PlayerLabel, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
BlzFrameSetText(PlayerStatus, "|cffff7f00Status|r")
BlzFrameSetEnable(PlayerStatus, false)
BlzFrameSetScale(PlayerStatus, 1.00)
BlzFrameSetTextAlignment(PlayerStatus, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

PlayerReady = BlzCreateFrame("QuestCheckBox", PlayerLabel, 0, 0)
BlzFrameSetPoint(PlayerReady, FRAMEPOINT_TOPLEFT, PlayerLabel, FRAMEPOINT_TOPLEFT, 0.0037000, 0.0000)
BlzFrameSetPoint(PlayerReady, FRAMEPOINT_BOTTOMRIGHT, PlayerLabel, FRAMEPOINT_BOTTOMRIGHT, -0.24630, 0.0000)
TriggerChPlayerReady = CreateTrigger() 
BlzTriggerRegisterFrameEvent(TriggerChPlayerReady, PlayerReady, FRAMEEVENT_CHECKBOX_CHECKED) 
BlzTriggerRegisterFrameEvent(TriggerChPlayerReady, PlayerReady, FRAMEEVENT_CHECKBOX_UNCHECKED) 
TriggerAddAction(TriggerChPlayerReady, function() 
if BlzGetTriggerFrameEvent() == FRAMEEVENT_CHECKBOX_CHECKED then
TRIGvar = 2
else 
TRIGvar = 1
end
end) 
 

PlayerProgress = BlzCreateFrameByType("TEXT", "name", PlayerLabel, "", 0)
BlzFrameSetPoint(PlayerProgress, FRAMEPOINT_TOPLEFT, PlayerLabel, FRAMEPOINT_TOPLEFT, 0.0037000, 0.0000)
BlzFrameSetPoint(PlayerProgress, FRAMEPOINT_BOTTOMRIGHT, PlayerLabel, FRAMEPOINT_BOTTOMRIGHT, -0.24630, 0.0000)
BlzFrameSetText(PlayerProgress, "|cffffffff100%|r")
BlzFrameSetEnable(PlayerProgress, false)
BlzFrameSetScale(PlayerProgress, 0.572)
BlzFrameSetTextAlignment(PlayerProgress, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
end
