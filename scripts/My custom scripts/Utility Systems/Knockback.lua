OnLibraryInit({name = "Knockback", "LinkedList"}, function ()
    -- System based in Paladon's GUI Knockback System

    local INTERVAL = 0.02

    local All = LinkedList.create()
    local Knockbacked = __jarray(0)

    local function Update()
        for node in All:loop() do
            local knock = node.value
            if knock.reachedDistance >= knock.maxDistance then
                Knockbacked[knock.target] = Knockbacked[knock.target] - 1
                All:remove(knock)
                if All.head.next == All.head then
                    return true
                end
            else
                local reduce = (knock.speed / knock.maxDistance) * knock.reachedDistance
                knock.reduceSpeed = reduce - knock.reduceSpeed * 0.1

                local dist = (knock.speed - knock.reduceSpeed) * 2.
                local x = GetUnitX(knock.target)
                local y = GetUnitY(knock.target)
                local tx = x + dist * math.cos(knock.direction)
                local ty = y + dist * math.sin(knock.direction)

                knock.effectCounter1 = knock.effectCounter1 + 1
                knock.effectCounter2 = knock.effectCounter2 + 1

                if knock.destroyTrees then
                    local l = Location(tx, ty)
                    EnumDestructablesInCircleBJ(200., l, function() KillDestructable(GetEnumDestructable()) end)
                    RemoveLocation(l)
                end

                if knock.effect1 and knock.effectCounter1 == 6 then
                    knock.effectCounter1 = 0
                    DestroyEffect(AddSpecialEffect(knock.effect1, x, y))
                end

                if knock.effect2 and knock.effectCounter2 == 8 then
                    knock.effectCounter2 = 0
                    DestroyEffect(AddSpecialEffect(knock.effect2, x, y))
                end

                SetUnitPosition(knock.target, tx, ty)
                knock.reachedDistance = knock.reachedDistance + dist
            end
        end
    end

    ---Creates a knockback to the target, the effect1 displays more often than the effect2
    ---@param target unit
    ---@param direction number
    ---@param distance number
    ---@param speed number
    ---@param effect1 string
    ---@param effect2 string
    ---@param destroyTrees? boolean
    function Knockback(target, direction, distance, speed, effect1, effect2, destroyTrees)
        local new = {
            target = target,
            direction = direction,
            maxDistance = distance,
            speed = speed * INTERVAL,
            effect1 = effect1,
            effect2 = effect2,
            destroyTrees = destroyTrees,
            reachedDistance = 0,
            reduceSpeed = 0,
            effectCounter1 = 0,
            effectCounter2 = 0,
        }
        Knockbacked[target] = Knockbacked[target] + 1
        All:insert(new)
        if new.next == All.head then
            Timed.echo(Update, INTERVAL)
        end
    end

    ---Returns if the unit is affected by the knockback
    ---@param u unit
    ---@return boolean
    function IsKnockbacked(u)
        return Knockbacked[u] > 0
    end
end)