if Debug then Debug.beginFile("PairingHeap") end
OnInit("PairingHeap", function ()

    ---@class Node
    ---@field key any
    ---@field value any
    ---@field parent Node?
    ---@field next Node?
    ---@field child Node?

    ---A pairing heap is a type of heap data structure with relatively simple implementation
    ---and excellent practical amortized performance.
    ---@class PairingHeap
    ---@field root Node?
    ---@field comparator fun(k1: any, k2: any): integer
    ---@field size integer
    PairingHeap = {}
    PairingHeap.__index = PairingHeap

    ---@param a Node?
    ---@param b Node?
    ---@param comparator fun(k1: any, k2: any): integer
    ---@return Node?
    local function fmerge(a, b, comparator)
        if not a then
            return b
        elseif not b then
            return a
        elseif comparator(a.key, b.key) >= 0 then
            a.next = b.child
            b.child = a
            a.parent = b
            return b
        else
            b.next = a.child
            a.child = b
            b.parent = a
            return a
        end
    end

    ---@param n Node?
    ---@param comparator fun(k1: any, k2: any): integer
    ---@return Node?
    local function fmergePairs(n, comparator)
        local e2 = n and n.next
        local e3 = e2 and e2.next

        if not n then
            return nil
        elseif not e2 then
            return n
        else
            return fmerge(fmerge(n, e2, comparator), fmergePairs(e3, comparator), comparator)
        end
    end

    ---@param h PairingHeap
    ---@param comparator fun(k1: any, k2: any): integer
    ---@return any
    local function fdeleteMin(h, comparator)
        local v = h.root and h.root.value
        local c = h.root
        h.root = fmergePairs(h.root and h.root.child, comparator)
        return v
    end

    ---@param h PairingHeap
    ---@param n Node
    ---@param k any
    local function fmodifyKey(h, n, k)
        local tmp = n.parent
        local v = n.value

        if n ~= h.root then
            tmp = n.parent
            tmp.child = fmergePairs(n.child, h.comparator)
            if tmp.child then
                tmp.child.parent = tmp
            end

            n.key = k
            n.parent = nil
            n.next = nil
            n.child = nil

            h.root = fmerge(h.root, n, h.comparator)
        else
            fdeleteMin(h, h.comparator)
            h:add(k, v)
        end
    end

    ---@overload fun(comparator: fun(k1: any, k2: any): integer): PairingHeap
    ---@param key any
    ---@param value any
    ---@param comparator fun(k1: any, k2: any): integer
    ---@return PairingHeap
    function PairingHeap.create(key, value, comparator)
        local self = setmetatable({}, PairingHeap)
        if type(key) == "function" then
            comparator = key
            self.size = 0
        else
            self.root = {key = key, value = value}
            self.size = 1
        end
        self.comparator = comparator
        return self
    end

    ---Adds the given key-value pair to this heap
    ---@param k any
    ---@param v any
    ---@return Node
    function PairingHeap:add(k, v)
        local n = {key = k, value = v} ---@type Node
        self.root = fmerge(self.root, n, self.comparator)
        self.size = self.size + 1
        return n
    end

    ---@param pos Node
    ---@param key any
    function PairingHeap:modifyKey(pos, key)
        fmodifyKey(self, pos, key)
    end

    ---Returns whether this heap has any nodes
    ---@return boolean
    function PairingHeap:isEmpty()
        return self.root == nil
    end

    ---Returns the value of the minimal key
    ---@return any
    function PairingHeap:min()
        return self.root and self.root.value
    end

    ---Deletes the minimal node and returns its value
    ---@return any
    function PairingHeap:deleteMin()
        self.size = self.size - 1
        return fdeleteMin(self, self.comparator)
    end

    function PairingHeap:destroy()
        while not self:isEmpty() do
            self:deleteMin()
        end
    end

    -- Tests
    if true then
        return
    end
    assert(PairingHeap.create(function (a, b) return R2I(a - b) end):isEmpty() == true, "Failed testInsert")

    local h = PairingHeap.create(function (a, b) return a - b end)
    h:add(4, 1)
    h:add(3, 2)
    h:add(2, 3)
    h:add(1, 4)

    assert(h:deleteMin() == 4, "Failed assertDeleteMinAndEmpty")
    assert(h:deleteMin() == 3, "Failed assertDeleteMinAndEmpty")
    assert(h:deleteMin() == 2, "Failed assertDeleteMinAndEmpty")
    assert(h:deleteMin() == 1, "Failed assertDeleteMinAndEmpty")
    assert(h:isEmpty() == true, "Failed assertDeleteMinAndEmpty")


    h = PairingHeap.create(1, 2, function (a, b) return a - b end)
    assert(not h:isEmpty(), "Failed assertNotEmpty")


    h = PairingHeap.create(function (a, b) return a - b end)
    local p1 = h:add(1, 1)
    h:add(2, 2)
    h:add(3, 3)
    h:add(4, 4)
    h:add(5, 5)

    h:modifyKey(p1, 7)
    assert(h:deleteMin() == 2, "Failed assertModifyPrioHead")
    assert(h:deleteMin() == 3, "Failed assertModifyPrioHead")
    assert(h:deleteMin() == 4, "Failed assertModifyPrioHead")
    assert(h:deleteMin() == 5, "Failed assertModifyPrioHead")
    assert(h:deleteMin() == 1, "Failed assertModifyPrioHead")


    h = PairingHeap.create(function (a, b) return a - b end)
    h:add(1, 1)
    h:add(2, 2)
    local p3 = h:add(3, 3)
    h:add(4, 4)
    h:add(5, 5)

    h:deleteMin()
    h:deleteMin()

    h:modifyKey(p3, 7)
    assert(h:deleteMin() == 4, "Failed assertModifyPrioHeadAfterDelete")
    assert(h:deleteMin() == 5, "Failed assertModifyPrioHeadAfterDelete")
    assert(h:deleteMin() == 3, "Failed assertModifyPrioHeadAfterDelete")


    h = PairingHeap.create(function (a, b) return a - b end)
    h:add(1, 1)
    h:add(2, 2)
    h:add(3, 3)
    h:add(4, 4)
    local p5 = h:add(5, 5)

    h:deleteMin()
    h:deleteMin()

    h:modifyKey(p5, 0)
    assert(h:deleteMin() == 5, "Failed assertModifyPrioLastAfterDelete")
    assert(h:deleteMin() == 3, "Failed assertModifyPrioLastAfterDelete")
    assert(h:deleteMin() == 4, "Failed assertModifyPrioLastAfterDelete")
end)
if Debug then Debug.endFile() end