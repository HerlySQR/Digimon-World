if Debug then Debug.beginFile("FrameLoader") end
-- in 1.31 and upto 1.32.9 PTR (when I wrote this). Frames are not correctly saved and loaded, breaking the game.
-- This runs all functions added to it with a 0s delay after the game was loaded.
OnInit("FrameLoader", function ()
    Require "AddHook"

    FrameLoader = {
        OnLoadTimer = function ()
            for _,v in ipairs(FrameLoader) do v() end
        end
        ,OnLoadAction = function()
            TimerStart(FrameLoader.Timer, 0, false, FrameLoader.OnLoadTimer)
        end
    }

    ---@param func function
    function FrameLoaderAdd(func)
        if not FrameLoader.Timer then
            FrameLoader.Trigger = CreateTrigger()
            FrameLoader.Timer = CreateTimer()
            TriggerRegisterGameEvent(FrameLoader.Trigger, EVENT_GAME_LOADED)
            TriggerAddAction(FrameLoader.Trigger, FrameLoader.OnLoadAction)
        end
        table.insert(FrameLoader, func)
        func()
    end

    local t = CreateTrigger()
    TriggerAddAction(t, function ()
        if BlzFrameGetEnable(BlzGetTriggerFrame()) then
            BlzFrameSetEnable(BlzGetTriggerFrame(), false)
            BlzFrameSetEnable(BlzGetTriggerFrame(), true)
        end
    end)

    local oldCreateFrame
    oldCreateFrame = AddHook("BlzCreateFrame", function (name, owner, priority, createContext)
        local frame = oldCreateFrame(name, owner, priority, createContext)
        if name == "IconButtonTemplate" or name == "ScriptDialogButton" then
            BlzTriggerRegisterFrameEvent(t, frame, FRAMEEVENT_CONTROL_CLICK)
        end
        return frame
    end)

    local oldBlzCreateFrameByType
    oldBlzCreateFrameByType = AddHook("BlzCreateFrameByType", function (typeName, name, owner, inherits, createContext)
        local frame = oldBlzCreateFrameByType(typeName, name, owner, inherits, createContext)
        if typeName == "TEXT" then
            BlzFrameSetEnable(frame, false)
        end
        return frame
    end)

    local LocalPlayer = GetLocalPlayer()
    local Console = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    local original = 0.0001
    local actualRatio = 1.
    local waitToMessage = 10

    Timed.echo(1., function ()
        actualRatio = original/BlzFrameGetWidth(Console)
        if math.abs(actualRatio - 1.) > 0.0001 then
            waitToMessage = waitToMessage - 1
            if waitToMessage <= 0 then
                waitToMessage = 45
                DisplayTextToPlayer(LocalPlayer, 0, 0, "|cff00ffccHelp: |r if the UI looks messed up, try setting the HUD size to 100 in the options menu.")
                StartSound(bj_questHintSound)
            end
        end
    end)
end)
if Debug then Debug.endFile() end