if LinkedList then --https://www.hiveworkshop.com/threads/definitive-doubly-linked-list.339392
    --[[--------------------------------------------------------------------------------------
        Timed Call and Echo v1.2.1.0, code structure credit to Eikonium and Jesus4Lyf
        
        Timed.call([delay, ]userFunc)
        -> Call userFunc after 'delay' seconds. Delay defaults to 0 seconds.
        
        Timed.echo(userFunc[, timeout, userTable])
        -> Returns userTable or a new table.
        -> calls userFunc every "timeout" seconds until userFunc returns true or you call
           userTable:remove()
        
        Node API (for the tables returned by Timed.echo):
            node.elapsed -> the number of seconds that 'node' has been iterating for.
    ----------------------------------------------------------------------------------------]]
        
        local _TIMEOUT = 0.03125 --default echo timeout
        
        Timed = {}
        ---@class timedNode:listNode
        ---@field elapsed number
        
    --[[--------------------------------------------------------------------------------------
        Internal
    ----------------------------------------------------------------------------------------]]
        
        local zeroList, _ZERO_TIMER
        
    --[[--------------------------------------------------------------------------------------
        Name: Timed.call
        Args: [delay, ]userFunc
        Desc: After "delay" seconds, call "userFunc".
    ----------------------------------------------------------------------------------------]]
        
        ---Core function by Eikonium; zero-second expiration is a simple list by Bribe
        ---@param delay number|function
        ---@param userFunc? function|number
        function Timed.call(delay, userFunc)
            if not userFunc or delay == 0.00 then
                if not zeroList then
                    zeroList = {}
                    _ZERO_TIMER = _ZERO_TIMER or CreateTimer()
                    TimerStart(_ZERO_TIMER, 0.00, false, 
                    function()
                        local tempList = zeroList
                        zeroList = nil
                        for _, func in ipairs(tempList) do func() end
                    end)
                end
                zeroList[#zeroList + 1] = userFunc or delay
                return
            end
            local t = CreateTimer()
            TimerStart(t, delay, false,
            function()
                DestroyTimer(t)
                userFunc()
            end)
        end
     
        local lists = {}
     
    --[[--------------------------------------------------------------------------------------
        Timed.echo is reminiscent of Jesus4Lyf's Timer32 module. It borrows from it with the
        LinkedList syntax and "exitwhen true" nature of the original T32 module.
    
        Desc: Calls userFunc every timeout seconds (by default, every 0.03125 seconds). If
            your own node should be specified but you want to use the default timeout, you
            can use Timed.echo(yourFunc, nil, myTable).
        Warn: This merges all timeouts of the same value together, so large numbers can cause
            expirations to occur too early on.
    ----------------------------------------------------------------------------------------]]
        ---@param userFunc fun(node:timedNode):boolean -- if true, echo will stop
        ---@param timeout? number
        ---@param node? timedNode
        ---@return timedNode new_node
        function Timed.echo(userFunc, timeout, node)
            timeout = timeout or _TIMEOUT
            local list = lists[timeout]
            local t
            node = node or {} ---@type timedNode
            if list then
                t = list.timer
                local r = TimerGetRemaining(t)
                if r < timeout * 0.50 then --the merge uses rounding to determine if
                    local q = list.queue   --the first expiration should be skipped
                    if not q then
                        q = LinkedList.create()
                        list.queue = q
                    end
                    node.elapsed = r       --add the remaining timeout to the elapsed time for this node.
                    node.func = userFunc
                    return q:insert(node)
                end
                node.elapsed = r - timeout --the instance will be called on the next tick, despite not being around for the full tick.
            else
                list = LinkedList.create()
                lists[timeout] = list
                t = CreateTimer()       --one timer per timeout interval
                list.timer = t
                TimerStart(t, timeout, true,
                function()
                    for tNode in list:loop() do
                        tNode.elapsed = tNode.elapsed + timeout
                        if tNode.func(tNode) then --function can return true to remove itself from the list.
                            tNode:remove()
                        end
                    end
                    -- delayed add to list
                    if list.queue then
                        list.queue:merge(list)
                        list.queue = nil
                    end
                    --
                    if list.n == 0 then --list is empty; delete it.
                        lists[timeout] = nil
                        PauseTimer(t)
                        DestroyTimer(t)
                    end
                end)
                node.elapsed = 0.00
            end
            node.func = userFunc
            return list:insert(node)
        end
    end