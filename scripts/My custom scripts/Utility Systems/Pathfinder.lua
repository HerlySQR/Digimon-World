if Debug then Debug.beginFile("Pathfinder") end
OnInit("Pathfinder", function ()
    Require "Timed"
    Require "PairingHeap"
    Require "Maths"

    local GRID_SIZE = 64.

    ---@param x1 number
    ---@param y1 number
    ---@param x2 number
    ---@param y2 number
    ---@return number
    local function distanceHeuristic(x1, y1, x2, y2)
        local dx = math.abs(x1 - x2)
        local dy = math.abs(y1 - y2)
        return 1 * (dx + dy) + (1.41 - 2 * 1) * math.min(dx, dy)
    end

    ---@class SearchNode
    ---@field posX number
    ---@field posY number
    ---@field parent SearchNode
    ---@field h number
    ---@field g number
    ---@field tt texttag
    ---@field pruned boolean
    ---@field scale number
    ---@field debug boolean
    SearchNode = {}
    SearchNode.__index = SearchNode
    SearchNode.__name = "SearchNode"

    local effectMap = {} ---@type table<integer, effect>

    ---@param posX number
    ---@param posY number
    ---@param parent SearchNode?
    ---@param debug boolean
    ---@return SearchNode
    function SearchNode.create(posX, posY, parent, debug)
        return setmetatable({
            posX = posX, posY = posY,
            parent = parent,
            debug = debug,
            h = 0.,
            g = 0.,
            pruned = false,
            scale = 0.6
        }, SearchNode)
    end

    function SearchNode:destroy()
        local hash = self:hash()
        if self.debug and effectMap[hash] then
            DestroyEffect(effectMap[hash])
            effectMap[hash] = nil
        end
        if self.tt then
            DestroyTextTag(self.tt)
        end
    end

    function SearchNode:setOpen()
        if self.debug then
            if not effectMap[self:hash()] then
                effectMap[self:hash()] = AddSpecialEffect("Abilities\\Weapons\\VengeanceMissile\\VengeanceMissile.mdl", self.posX, self.posY)
                self.tt = CreateTextTag()
                SetTextTagPos(self.tt, self.posX, self.posY, 0)
                SetTextTagTextBJ(self.tt, tostring(self:f()), 5.)
            end
            BlzSetSpecialEffectColor(effectMap[self:hash()], 0, 0, 255)
        end
    end

    function SearchNode:setClosed()
        if self.debug then
            BlzSetSpecialEffectColor(effectMap[self:hash()], 255, 0, 0)
        end
        DestroyTextTag(self.tt)
        self.tt = nil
    end

    function SearchNode:setFinish()
        if self.debug then
            BlzSetSpecialEffectColor(effectMap[self:hash()], 0, 255, 0)
        end
    end

    function SearchNode:setActive()
        if self.debug then
            BlzSetSpecialEffectColor(effectMap[self:hash()], 55, 255, 55)
        end
    end

    ---@return integer
    function SearchNode:hash()
        return R2I(self.posX) * 64 + R2I(self.posY)
    end

    ---@param h number
    function SearchNode:setH(h)
        self.h = h
        SetTextTagTextBJ(self.tt, tostring(self:f()), 5.)
    end

    ---@param g number
    function SearchNode:setG(g)
        self.g = g
        SetTextTagTextBJ(self.tt, tostring(self:f()), 5.)
    end

    ---@return number
    function SearchNode:f()
        return self.g + self.h
    end

    ---@class GoalNode
    ---@field posX number
    ---@field posY number
    GoalNode = {}
    GoalNode.__index = GoalNode
    GoalNode.__name = "GoalNode"

    ---@param posX number
    ---@param posY number
    ---@return GoalNode
    function GoalNode.create(posX, posY)
        return setmetatable({posX = posX, posY = posY}, GoalNode)
    end

    ---@param other SearchNode
    ---@return boolean
    function GoalNode:inGoal(other)
        return math.sqrt((self.posX - other.posX)^2 + (self.posY - other.posY)^2) <= GRID_SIZE
    end

    ---@return integer
    function GoalNode:hash()
        return R2I(self.posX * GRID_SIZE + self.posY)
    end

    ---Stores all nodes that should be considered for path finding.
    ---@class OpenSet
    ---@field heap PairingHeap
    ---@field map table<integer, SearchNode>
    OpenSet = {}
    OpenSet.__index = OpenSet
    OpenSet.__name = "OpenSet"

    ---@return OpenSet
    function OpenSet.create()
        return setmetatable({
            heap = PairingHeap.create(function (i1, i2) return R2I(i1 - i2) end),
            map = {}
        }, OpenSet)
    end

    ---Removes and returns the next node in the open set with the lowest G value
    ---@return SearchNode
    function OpenSet:poll()
        local result
        local ret = self.heap:deleteMin()
        if ret then
            while not self.map[ret:hash()] do
                ret = self.heap:deleteMin()
            end
            self.map[ret:hash()] = nil
            result = ret
        end
        return result
    end

    ---@param node SearchNode
    function OpenSet:add(node)
        self.heap:add(node:f(), node)
        self.map[node:hash()] = node
    end

    ---@return boolean
    function OpenSet:isEmpty()
        return self.heap:isEmpty()
    end

    ---@param node SearchNode
    function OpenSet:remove(node)
        self.map[node:hash()] = nil
    end

    ---@param node SearchNode
    ---@return SearchNode?
    function OpenSet:getNode(node)
        return self.map[node:hash()]
    end

    function OpenSet:destroy()
        self.heap:destroy()
        self.heap = nil
        self.map = nil
    end

    ---Stores all nodes that have been fully processed.
    ---@class ClosedSet
    ---@field list integer[]
    ---@field map table<integer, SearchNode>
    ClosedSet = {}
    ClosedSet.__index = ClosedSet
    ClosedSet.__name = "ClosedSet"

    ---@return ClosedSet
    function ClosedSet.create()
        return setmetatable({
            list = {},
            map = {}
        }, ClosedSet)
    end

    ---@param node SearchNode
    ---@return boolean
    function ClosedSet:has(node)
        return node and self.map[node:hash()] ~= nil
    end

    ---@param node SearchNode
    function ClosedSet:add(node)
        table.insert(self.list, node:hash())
        self.map[node:hash()] = node
    end

    function ClosedSet:destroy()
        for i = 1, #self.list do
            if self.map[self.list[i]] then
                self.map[self.list[i]]:destroy()
            end
        end
        self.map = nil
        self.list = nil
    end

    ---@param posX number
    ---@param posY number
    ---@return number newX, number newY
    local function normalizePosition(posX, posY)
        return math.round(posX / GRID_SIZE) * GRID_SIZE + (posX < 0 and GRID_SIZE or -GRID_SIZE) / 2,
               math.round(posY / GRID_SIZE) * GRID_SIZE + (posY < 0 and GRID_SIZE or -GRID_SIZE) / 2
    end

    ---@class Pathfinder
    ---@field allNodes table<integer, SearchNode>
    ---@field done boolean
    ---@field inSubStep integer
    ---@field startX number
    ---@field startY number
    ---@field target GoalNode
    ---@field pathingCondition fun(x: number, y: number): boolean
    ---@field openSet OpenSet
    ---@field closedSet ClosedSet
    ---@field outputPath boolean
    ---@field debug boolean
    ---@field stepDelay number
    ---@field maxJumpDepth integer
    ---@field lastJumpPoint SearchNode
    Pathfinder = {}
    Pathfinder.__index = Pathfinder
    Pathfinder.__name = "Pathfinder"

    ---@param startX number
    ---@param startY number
    ---@param targetX number
    ---@param targetY number
    ---@return Pathfinder
    function Pathfinder.create(startX, startY, targetX, targetY)
        local self = setmetatable({}, Pathfinder)

        self.startX, self.startY = normalizePosition(startX, startY)
        self.target = GoalNode.create(normalizePosition(targetX, targetY))
        self.allNodes = {}

        self.done = false
        self.inSubStep = 0
        self.outputPath = false
        self.debug = false
        self.stepDelay = 0.1
        self.maxJumpDepth = 64

        return self
    end

    ---@param cond fun(x: number, y: number): boolean
    function Pathfinder:setCond(cond)
        self.pathingCondition = cond
    end

    ---@param onFinish fun(sucess: boolean, path: SearchNode[]?)
    function Pathfinder:search(onFinish)
        if not self.pathingCondition then
            error("Pathing condition may not be nil")
        end

        local startTime = os.clock()
        self.openSet = OpenSet.create()

        local node = self:getNode(self.startX, self.startY, nil)
        node:setOpen()
        self.openSet:add(node)

        self.closedSet = ClosedSet.create()

        Timed.echo(self.stepDelay, function ()
            if self.openSet:isEmpty() and self.inSubStep == 0 then
                self.done = true

                onFinish(false, nil)
                self:destroy()
                return true
            elseif self.inSubStep == 0 then
                self.lastJumpPoint = self.openSet:poll()

                self.lastJumpPoint:setActive()
                if self.target:inGoal(self.lastJumpPoint) then
                    self.lastJumpPoint:setFinish()
                    self.done = true
                    if self.debug then
                        print("Found path. took: " .. (os.clock() - startTime) .. " seconds")
                    end
                    onFinish(true, self.outputPath and self:backtrace(self.lastJumpPoint) or {})
                    self:destroy()
                    return true
                else
                    self:identifySuccessors(self.lastJumpPoint)

                    self.closedSet:add(self.lastJumpPoint)
                    self.lastJumpPoint:setClosed()
                end
            end
        end)
    end

    ---@param tx any
    ---@param ty any
    ---@param parent SearchNode?
    ---@return SearchNode
    function Pathfinder:getNode(tx, ty, parent)
        local hash = math.round(tx / GRID_SIZE) + math.round(ty)
        if not self.allNodes[hash] then
            self.allNodes[hash] = SearchNode.create(tx, ty, parent, self.debug)
        end
        return self.allNodes[hash]
    end

    ---@param theNode SearchNode
    ---@return SearchNode[]
    function Pathfinder:backtrace(theNode)
        local list = {} ---@type SearchNode[]
        local parent = theNode
        while parent do
            table.insert(list, parent)
            parent:setFinish()
            parent = parent.parent
        end
        return list
    end

    ---@param currentNode SearchNode
    function Pathfinder:identifySuccessors(currentNode)
        local pathingTop = self.pathingCondition(currentNode.posX, currentNode.posY + GRID_SIZE)
        local pathingBot = self.pathingCondition(currentNode.posX, currentNode.posY - GRID_SIZE)
        local pathingLeft = self.pathingCondition(currentNode.posX - GRID_SIZE, currentNode.posY)
        local pathingRight = self.pathingCondition(currentNode.posX + GRID_SIZE, currentNode.posY)

        self.inSubStep = 4
        Timed.call(self.stepDelay, function ()
            self:checkCandidate(currentNode, GRID_SIZE, 0.)
            self.inSubStep = self.inSubStep - 1
        end)
        Timed.call(self.stepDelay, function ()
            self:checkCandidate(currentNode, -GRID_SIZE, 0.)
            self.inSubStep = self.inSubStep - 1
        end)
        Timed.call(self.stepDelay, function ()
            self:checkCandidate(currentNode, 0., GRID_SIZE)
            self.inSubStep = self.inSubStep - 1
        end)
        Timed.call(self.stepDelay, function ()
            self:checkCandidate(currentNode, 0., -GRID_SIZE)
            self.inSubStep = self.inSubStep - 1
        end)

        if pathingTop or pathingRight then
            self.inSubStep = self.inSubStep + 1
            Timed.call((self.inSubStep - 3.) * self.stepDelay, function ()
                self:checkCandidate(currentNode, GRID_SIZE, GRID_SIZE)
                self.inSubStep = self.inSubStep - 1
            end)
        end

        if pathingTop or pathingLeft then
            self.inSubStep = self.inSubStep + 1
            Timed.call((self.inSubStep - 3.) * self.stepDelay, function ()
                self:checkCandidate(currentNode, -GRID_SIZE, GRID_SIZE)
                self.inSubStep = self.inSubStep - 1
            end)
        end

        if pathingBot or pathingRight then
            self.inSubStep = self.inSubStep + 1
            Timed.call((self.inSubStep - 3.) * self.stepDelay, function ()
                self:checkCandidate(currentNode, GRID_SIZE, -GRID_SIZE)
                self.inSubStep = self.inSubStep - 1
            end)
        end

        if pathingBot or pathingLeft then
            self.inSubStep = self.inSubStep + 1
            Timed.call((self.inSubStep - 3.) * self.stepDelay, function ()
                self:checkCandidate(currentNode, -GRID_SIZE, -GRID_SIZE)
                self.inSubStep = self.inSubStep - 1
            end)
        end
    end

    ---@param currentNode SearchNode
    ---@param dx number
    ---@param dy number
    function Pathfinder:checkCandidate(currentNode, dx, dy)
        local candidate = self:getNode(currentNode.posX + dx, currentNode.posY + dy, currentNode)
        if not self.closedSet:has(candidate) and self.pathingCondition(candidate.posX, candidate.posY) then
            local jumpNode = self:jump(currentNode, dx, dy, 0)
            if jumpNode then
                self:registerNode(jumpNode, self.lastJumpPoint)
            end
        end
    end

    ---@param node SearchNode
    ---@param parent SearchNode
    function Pathfinder:registerNode(node, parent)
        if not self.openSet:getNode(node) and not self.closedSet:has(node) then
            node.parent = parent
            self:calculateNodeScore(node, parent)
            self.openSet:add(node)
            node:setOpen()
        end
    end

    ---JPS jump function
    ---Skips along in dx, dy direction until it finds a forced neighbour.
    ---@param curNode SearchNode
    ---@param dx number
    ---@param dy number
    ---@param depth integer
    ---@return SearchNode?
    function Pathfinder:jump(curNode, dx, dy, depth)
        local nextNode = self:getNode(curNode.posX + dx, curNode.posY + dy, curNode)
        if not nextNode or nextNode.pruned or not self.pathingCondition(nextNode.posX, nextNode.posY) then
            return nil
        end
        if self.target:inGoal(nextNode) then
            return nextNode
        end

        if depth > self.maxJumpDepth then
            self:registerNode(nextNode, self.lastJumpPoint)
            return nil
        end

        if self.debug then
            local eff = AddSpecialEffect("Abilities\\Weapons\\MurgulMagicMissile\\MurgulMagicMissile.mdx", nextNode.posX, nextNode.posY)
            nextNode.pruned = true
            Timed.call(1., function ()
                DestroyEffect(eff)
            end)
        end

        -- Diagonal
        if R2I(dx) ~= 0 and R2I(dy) ~= 0 then
            if (not self.pathingCondition(nextNode.posX - dx, nextNode.posY) and self.pathingCondition(nextNode.posX - dx, nextNode.posY + dy)
                or not self.pathingCondition(nextNode.posX, nextNode.posY - dy) and self.pathingCondition(nextNode.posX + dx, nextNode.posY - dy)) then
                return nextNode
            end

            local xjump = self:jump(nextNode, dx, 0, depth + 1)
            local yjump = self:jump(nextNode, 0, dy, depth + 1)

            if xjump or yjump then
                self:registerNode(nextNode, self.lastJumpPoint)

                if xjump then
                    self:registerNode(xjump, nextNode)
                end

                if yjump then
                    self:registerNode(yjump, nextNode)
                end

                return nil
            end

        else
            -- Vertical and horizontal
            if R2I(dx) ~= 0 then
                if (self.pathingCondition(nextNode.posX + dx, nextNode.posY + GRID_SIZE) and not self.pathingCondition(nextNode.posX, nextNode.posY + GRID_SIZE)
                    or self.pathingCondition(nextNode.posX + dx, nextNode.posY - GRID_SIZE) and not self.pathingCondition(nextNode.posX, nextNode.posY - GRID_SIZE)) then
                    return nextNode
                end
            elseif R2I(dy) ~= 0 then
                if (self.pathingCondition(nextNode.posX + GRID_SIZE, nextNode.posY + dy) and not self.pathingCondition(nextNode.posX + GRID_SIZE, nextNode.posY)
                    or self.pathingCondition(nextNode.posX - GRID_SIZE, nextNode.posY + dy) and not self.pathingCondition(nextNode.posX - GRID_SIZE, nextNode.posY)) then
                    return nextNode
                end
            end
        end


        if self.pathingCondition(nextNode.posX + dx, nextNode.posY) or self.pathingCondition(nextNode.posX, nextNode.posY + dy) then
            return self:jump(nextNode, dx, dy, depth + 1)
        else
            return nil
        end
    end

    ---@param node SearchNode
    ---@param parent SearchNode
    function Pathfinder:calculateNodeScore(node, parent)
        local h = distanceHeuristic(self.target.posX, self.target.posY, node.posX, node.posY)

        node:setH(h)

        node:setG(parent.g + self:calculateGScore(node, parent))
    end

    function Pathfinder:calculateGScore(newNode, oldNode)
        local dist = distanceHeuristic(newNode.posX, newNode.posY, oldNode.posX, oldNode.posY)
        return R2I(dist)
    end

    function Pathfinder:destroy()
        for _, node in pairs(self.allNodes) do
            node:destroy()
        end
        self.allNodes = nil
        self.target = nil
        self.openSet:destroy()
        self.openSet = nil
        self.closedSet:destroy()
        self.closedSet = nil
    end
end)
if Debug then Debug.endFile() end