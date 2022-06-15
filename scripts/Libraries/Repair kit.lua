-- Debug
local oldTimerStart = TimerStart
function TimerStart(whichTimer, timeout, periodic, handlerFunc)
    oldTimerStart(whichTimer, timeout, periodic, function ()
        try(handlerFunc)
    end)
end

function TriggerRegisterDestDeathInRegionEvent(trig, r)
    --Removes the limit on the number of destructables that can be registered.
    EnumDestructablesInRect(r, nil, function() TriggerRegisterDeathEvent(trig, GetEnumDestructable()) end)
end

function IsUnitDeadBJ(u) return not UnitAlive(u) end --uses the reliable native instead of the life check

function IsUnitAliveBJ(u) return UnitAlive(u) end --uses the reliable native instead of the life check

function SetUnitPropWindowBJ(whichUnit, propWindow)
    --Allows the Prop Window to be set to zero to allow unit movement to be suspended.
    SetUnitPropWindow(whichUnit, propWindow*bj_DEGTORAD)
end

do
    --[[-----------------------------------------------------------------------------------------

    __jarray cleaner 1.0 by Bribe

    This snippet will ensure that objects used as indices in udg_ arrays will be automatically
    cleaned up when the garbage collector runs, and tries to re-use metatables whenever possible.

    -------------------------------------------------------------------------------------------]]
    local mts = {}
    local cleaner = {__mode = "k"} --without this, tables with non-nilled values pointing to dynamic objects will never be garbage collected.
    local setmt = function(default, tab)
        local mt
        if default then
            mt = mts[default]
            if not mt then
                mt = {__index = function() return default end, __mode = "k"}
                mts[default] = mt
            end
        else
            mt = cleaner
        end
        return setmetatable(tab or {}, mt)
    end
    --have to do a wide search for all arrays in the variable editor. The WarCraft 3 _G table is HUGE.
    local t = type
    for k,v in pairs(_G) do
        if t(v) == "table" and k:find("^udg_") then
            setmt(v[0], v)
        end
    end
    __jarray = setmt --remap this for Lua users who want default values in their table/automatic cleanup as needed.
end

do
--[[---------------------------------------------------------------------------------------------

    RegisterAnyPlayerUnitEvent v1.2.0.0 by Bribe

    I designed the original JASS system RegisterAnyPlayerUnitEvent to help to cut down on handles
    that are generated for events, but this has the benefit of using raw function calls (for Lua
    users) instead of triggers, as well as being able to "skip" a playerunitevent.

    Version 1.1 implements the "skip" option which disables the specified event while allowing a
    single function to run discretely. It also allows (if Global Variable Remapper is included)
    GUI to un-register an AnyPlayerUnitEvent by setting udg_RemoveAnyUnitEvent to a trigger.

    Version 1.2 embeds the "skip" behavior into the RegisterAnyPlayerUnitEvent optional 3rd arg.
    It also makes the "return" value of RegisterAnyPlayerUnitEvent call the "remove" method. The
    API, therefore, has been reduced to just this one function (in addition to the bj override).

-----------------------------------------------------------------------------------------------]]
    local fStack = {}
    local tStack = {}
    local bj = TriggerRegisterAnyUnitEventBJ

    function RegisterAnyPlayerUnitEvent(event, userFunc, skip)
        if skip then
            local t = tStack[event]
            if t and IsTriggerEnabled(t) then
                DisableTrigger(t)
                userFunc()
                EnableTrigger(t)
            else
                userFunc()
            end
            return
        end
        local r, funcs = 0, fStack[event]
        if funcs then
            r = #funcs
            if r == 0 then EnableTrigger(tStack[event]) end
        else
            funcs = {}
            fStack[event] = funcs
            local t = CreateTrigger()
            tStack[event] = t
            bj(t, event)
            TriggerAddCondition(t, Filter(
            function()
                for _, func in ipairs(funcs) do func() end
            end))
        end
        funcs[r + 1] = userFunc
        return function()
            r = -1
            for i, func in ipairs(funcs) do
                if func == userFunc then r = i break end
            end
            if r > 0 then
                local i = #funcs
                if i > 1 then
                    funcs[r] = funcs[i]
                else
                    DisableTrigger(tStack[event])
                end
                funcs[i] = nil
            end
        end
    end

    local trigFuncs
    function TriggerRegisterAnyUnitEventBJ(trig, event)
        local removeFunc = RegisterAnyPlayerUnitEvent(event, function() if IsTriggerEnabled(trig) and TriggerEvaluate(trig) then TriggerExecute(trig) end end)
        if GlobalRemap then
            if not trigFuncs then
                trigFuncs = {}
                GlobalRemap("udg_RemoveAnyUnitEvent", nil, function(t)
                    local func = trigFuncs[t]
                    if func then
                        func()
                        trigFuncs[t] = nil
                    end
                end)
            end
            trigFuncs[trig] = removeFunc
        end
        return removeFunc
    end
end

--[[ Remove some pointless BJ functions (basically that they just call the native function with the same parameters)

StringIdentity                          = GetLocalizedString
GetEntireMapRect                        = GetWorldBounds
GetHandleIdBJ                           = GetHandleId
StringHashBJ                            = StringHash
TriggerRegisterTimerExpireEventBJ       = TriggerRegisterTimerExpireEvent
TriggerRegisterDialogEventBJ            = TriggerRegisterDialogEvent
TriggerRegisterUpgradeCommandEventBJ    = TriggerRegisterUpgradeCommandEvent
RemoveWeatherEffectBJ                   = RemoveWeatherEffect
DestroyLightningBJ                      = DestroyLightning
GetLightningColorABJ                    = GetLightningColorA
GetLightningColorRBJ                    = GetLightningColorR
GetLightningColorGBJ                    = GetLightningColorG
GetLightningColorBBJ                    = GetLightningColorB
SetLightningColorBJ                     = SetLightningColor
GetAbilityEffectBJ                      = GetAbilityEffectById
GetAbilitySoundBJ                       = GetAbilitySoundById
ResetTerrainFogBJ                       = ResetTerrainFog
SetSoundDistanceCutoffBJ                = SetSoundDistanceCutoff
SetSoundPitchBJ                         = SetSoundPitch
AttachSoundToUnitBJ                     = AttachSoundToUnit
KillSoundWhenDoneBJ                     = KillSoundWhenDone
PlayThematicMusicBJ                     = PlayThematicMusic
EndThematicMusicBJ                      = EndThematicMusic
StopMusicBJ                             = StopMusic
ResumeMusicBJ                           = ResumeMusic
VolumeGroupResetImmediateBJ             = VolumeGroupReset
WaitForSoundBJ                          = TriggerWaitForSound
ClearMapMusicBJ                         = ClearMapMusic
DestroyEffectBJ                         = DestroyEffect
GetItemLifeBJ                           = GetWidgetLife -- This was just to type casting
SetItemLifeBJ                           = SetWidgetLife -- This was just to type casting
UnitRemoveBuffBJ                        = UnitRemoveAbility -- The buffs are abilities
GetLearnedSkillBJ                       = GetLearnedSkill
UnitDropItemPointBJ                     = UnitDropItemPoint
UnitDropItemTargetBJ                    = UnitDropItemTarget
UnitUseItemDestructable                 = UnitUseItemTarget -- This was just to type casting
UnitInventorySizeBJ                     = UnitInventorySize
SetItemInvulnerableBJ                   = SetItemInvulnerable
SetItemDropOnDeathBJ                    = SetItemDropOnDeath
SetItemDroppableBJ                      = SetItemDroppable
SetItemPlayerBJ                         = SetItemPlayer
ChooseRandomItemBJ                      = ChooseRandomItem
ChooseRandomNPBuildingBJ                = ChooseRandomNPBuilding
ChooseRandomCreepBJ                     = ChooseRandomCreep
-- UnitId2OrderIdBJ     This only returns its parameter
String2UnitIdBJ                         = UnitId -- I think they just wanted a better name
GetIssuedOrderIdBJ                      = GetIssuedOrderId
GetKillingUnitBJ                        = GetKillingUnit
IsUnitHiddenBJ                          = IsUnitHidden
IssueTrainOrderByIdBJ                   = IssueImmediateOrderById -- I think they just wanted a better name
GroupTrainOrderByIdBJ                   = GroupImmediateOrderById -- I think they just wanted a better name
IssueUpgradeOrderByIdBJ                 = IssueImmediateOrderById -- I think they just wanted a better name
GetAttackedUnitBJ                       = GetTriggerUnit -- I think they just wanted a better name
SetUnitFlyHeightBJ                      = SetUnitFlyHeight
SetUnitTurnSpeedBJ                      = SetUnitTurnSpeed
GetUnitDefaultPropWindowBJ              = GetUnitDefaultPropWindow
SetUnitBlendTimeBJ                      = SetUnitBlendTime
SetUnitAcquireRangeBJ                   = SetUnitAcquireRange
UnitSetCanSleepBJ                       = UnitAddSleep
UnitCanSleepBJ                          = UnitCanSleep
UnitWakeUpBJ                            = UnitWakeUp
UnitIsSleepingBJ                        = UnitIsSleeping
IsUnitPausedBJ                          = IsUnitPaused
SetUnitExplodedBJ                       = SetUnitExploded
GetTransportUnitBJ                      = GetTransportUnit
GetLoadedUnitBJ                         = GetLoadedUnit
IsUnitInTransportBJ                     = IsUnitInTransport
IsUnitLoadedBJ                          = IsUnitLoaded
IsUnitIllusionBJ                        = IsUnitIllusion
SetDestructableInvulnerableBJ           = SetDestructableInvulnerable
IsDestructableInvulnerableBJ            = IsDestructableInvulnerable
SetDestructableMaxLifeBJ                = SetDestructableMaxLife
WaygateIsActiveBJ                       = WaygateIsActive
QueueUnitAnimationBJ                    = QueueUnitAnimation
SetDestructableAnimationBJ              = SetDestructableAnimation
QueueDestructableAnimationBJ            = QueueDestructableAnimation
DialogSetMessageBJ                      = DialogSetMessage
DialogClearBJ                           = DialogClear
GetClickedButtonBJ                      = GetClickedButton
GetClickedDialogBJ                      = GetClickedDialog
DestroyQuestBJ                          = DestroyQuest
QuestSetTitleBJ                         = QuestSetTitle
QuestSetDescriptionBJ                   = QuestSetDescription
QuestSetCompletedBJ                     = QuestSetCompleted
QuestSetFailedBJ                        = QuestSetFailed
QuestSetDiscoveredBJ                    = QuestSetDiscovered
QuestItemSetDescriptionBJ               = QuestItemSetDescription
QuestItemSetCompletedBJ                 = QuestItemSetCompleted
DestroyDefeatConditionBJ                = DestroyDefeatCondition
DefeatConditionSetDescriptionBJ         = DefeatConditionSetDescription
FlashQuestDialogButtonBJ                = FlashQuestDialogButton
DestroyTimerBJ                          = DestroyTimer
DestroyTimerDialogBJ                    = DestroyTimerDialog
TimerDialogSetTitleBJ                   = TimerDialogSetTitle
TimerDialogSetSpeedBJ                   = TimerDialogSetSpeed
TimerDialogDisplayBJ                    = TimerDialogDisplay
LeaderboardSetStyleBJ                   = LeaderboardSetStyle
LeaderboardGetItemCountBJ               = LeaderboardGetItemCount
LeaderboardHasPlayerItemBJ              = LeaderboardHasPlayerItem
DestroyLeaderboardBJ                    = DestroyLeaderboard
LeaderboardDisplayBJ                    = LeaderboardDisplay
LeaderboardSortItemsByPlayerBJ          = LeaderboardSortItemsByPlayer
LeaderboardSortItemsByLabelBJ           = LeaderboardSortItemsByLabel
PlayerGetLeaderboardBJ                  = PlayerGetLeaderboard
DestroyMultiboardBJ                     = DestroyMultiboard
SetTextTagPosUnitBJ                     = SetTextTagPosUnit
SetTextTagSuspendedBJ                   = SetTextTagSuspended
SetTextTagPermanentBJ                   = SetTextTagPermanent
SetTextTagAgeBJ                         = SetTextTagAge
SetTextTagLifespanBJ                    = SetTextTagLifespan
SetTextTagFadepointBJ                   = SetTextTagFadepoint
DestroyTextTagBJ                        = DestroyTextTag
ForceCinematicSubtitlesBJ               = ForceCinematicSubtitles
DisplayCineFilterBJ                     = DisplayCineFilter
SaveGameCacheBJ                         = SaveGameCache
FlushGameCacheBJ                        = FlushGameCache
FlushParentHashtableBJ                  = FlushParentHashtable
SaveGameCheckPointBJ                    = SaveGameCheckpoint
LoadGameBJ                              = LoadGame
RenameSaveDirectoryBJ                   = RenameSaveDirectory
RemoveSaveDirectoryBJ                   = RemoveSaveDirectory
CopySaveGameBJ                          = CopySaveGame
IssueTargetOrderBJ                      = IssueTargetOrder
IssuePointOrderLocBJ                    = IssuePointOrderLoc
IssueTargetDestructableOrder            = IssueTargetOrder -- This was just to type casting
IssueTargetItemOrder                    = IssueTargetOrder -- This was just to type casting
IssueImmediateOrderBJ                   = IssueImmediateOrder
GroupTargetOrderBJ                      = GroupTargetOrder
GroupPointOrderLocBJ                    = GroupPointOrderLoc
GroupImmediateOrderBJ                   = GroupImmediateOrder
GroupTargetDestructableOrder            = GroupTargetOrder -- This was just to type casting
GroupTargetItemOrder                    = GroupTargetOrder -- This was just to type casting
GetDyingDestructable                    = GetTriggerDestructable -- I think they just wanted a better name
GetAbilityName                          = GetObjectName -- I think they just wanted a better name
]]