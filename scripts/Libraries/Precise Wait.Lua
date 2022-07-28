if AddHook then -- https://www.hiveworkshop.com/threads/hook.339153
    --Precise Wait v1.4.0.2
    --This changes the default functionality of TriggerAddAction, PolledWait
    --and (because they don't work with manual coroutines) TriggerSleepAction and SyncSelections.

    local _ACTION_PRIORITY  =  1 --Specify the hook priority for hooking TriggerAddAction (higher numbers run earlier in the sequence).
    local _WAIT_PRIORITY    = -2 --The hook priority for TriggerSleepAction/PolledWait

    local function wait(duration)
        local thread = coroutine.running()
        if thread then
            local t = CreateTimer()
            TimerStart(t, duration, false, function()
                DestroyTimer(t)
                coroutine.resume(thread)
            end)
            coroutine.yield(thread)
        end
    end

    AddHook("PolledWait", wait, _WAIT_PRIORITY)
    AddHook("TriggerSleepAction", wait, _WAIT_PRIORITY)

    local oldSync
    oldSync = AddHook("SyncSelections",
    function()
        local thread = coroutine.running()
        if thread then
            function SyncSelectionsHelper()
                oldSync()
                coroutine.resume(thread)
            end
            ExecuteFunc("SyncSelectionsHelper")
            coroutine.yield(thread)
        end
    end)

    local oldAdd, init
    oldAdd = AddHook("TriggerAddAction", function(trig, func)
        if GlobalRemap and not init then
            init = true
            GlobalRemap("udg_WaitIndex", coroutine.running)
        end
        return oldAdd(trig, function() coroutine.resume(coroutine.create(func)) end)
    end, _ACTION_PRIORITY)
    
end --End of library PolledWait