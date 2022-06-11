if LinkedList then
    -- System based in Paladon's GUI Knockback System

    local INTERVAL = 0.02

    local All = LinkedList.create()
    local Knockbacked = {}

    local function Update()
        for node in All:loop() do
            if node.reachedDistance >= node.maxDistance then
                Knockbacked[node.target] = Knockbacked[node.target] - 1
                All:remove(node)
                if All.head.next == All.head then
                    return true
                end
            else
                local reduce = (node.speed / node.maxDistance) * node.reachedDistance
                node.reduceSpeed = reduce - node.reduceSpeed * 0.1

                local dist = (node.speed - node.reduceSpeed) * 2.
                local x = GetUnitX(node.target)
                local y = GetUnitY(node.target)
                local tx = x + dist * math.cos(node.direction)
                local ty = y + dist * math.sin(node.direction)

                node.effectCounter1 = node.effectCounter1 + 1
                node.effectCounter2 = node.effectCounter2 + 1

                if node.destroyTrees then
                    local l = Location(tx, ty)
                    EnumDestructablesInCircleBJ(200., l, function() KillDestructable(GetEnumDestructable()) end)
                    RemoveLocation(l)
                end

                if node.effect1 and node.effectCounter1 == 6 then
                    node.effectCounter1 = 0
                    DestroyEffect(AddSpecialEffect(node.effect1, x, y))
                end

                if node.effect2 and node.effectCounter2 == 8 then
                    node.effectCounter2 = 0
                    DestroyEffect(AddSpecialEffect(node.effect2, x, y))
                end

                SetUnitPosition(node.target, tx, ty)
                node.reachedDistance = node.reachedDistance + dist
            end
        end
    end

    ---Creates a knockback to the target, the effect1 displays more often than the effect2
    ---@param target unit
    ---@param direction real
    ---@param distance real
    ---@param speed real
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
        Knockbacked[target] = (Knockbacked[target] or 0) + 1
        All:insert(new)
        if new.next == All.head then
            Timed.echo(Update, INTERVAL)
        end
    end

    ---Returns if the unit is affected by the knockback
    ---@param u unit
    ---@return boolean
    function IsKnockbacked(u)
        return Knockbacked[u] and Knockbacked[u] > 0
    end
end