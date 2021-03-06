do Struct = {} --vJass-style Struct version 1.5.0.0 by Bribe

    --Requires optional Global Initialization: https://www.hiveworkshop.com/threads/global-initialization.317099/

    ---@class keyword
    ---@class thistype
    ---Constructor: Struct([optional_parent_struct])
    ---@class Struct : table
    ---@field allocate fun(from_struct)
    ---@field deallocate fun(struct_instance)
    ---@field create fun(from_struct)
    ---@field destroy fun(struct_instance)
    ---@field onDestroy fun(struct_instance)
    ---@field onCreate fun(struct_instance)
    ---@field extends fun(other_struct_or_table)
    ---@field super Struct
    ---@field isType fun(struct_to_compare, other_struct)
    ---@field environment fun(struct_to_iterate)
    ---@field interface fun(default_return_value) -> interface
    ---@field _operatorset fun(your_struct, var_name, your_func)
    ---@field _operatorget fun(your_struct, var_name, your_func)
    ---@field _getindex fun(your_struct, index)
    ---@field _setindex fun(your_struct, index, value)
    ---Constructor: Struct.interface([default_value])
    ---@class interface : table
    ---Constructor: Struct.module(module_function)
    ---@class Struct.module : table
    ---@field private init boolean
    ---@field public implement function
    local mt = {
        __index = function(self, key)
            local get = rawget(self, "_getindex") --declaring a _getindex function in your struct enables it to act as method operator []
            return get and get(self, key) or rawget(Struct, key) --however, it doesn't extend to child structs.
        end
        ,
        __newindex = function(self, key, val)
            local set = rawget(self, "_setindex") --declaring a _setindex function in your struct enables it to act as method operator []=
            if set then set(self, key, val) else rawset(self, key, val) end
        end
    }
    setmetatable(Struct, mt)
    ---Allocate, call the stub method onCreate and return a new struct instance via myStruct:create().
    ---@return Struct new_instance
    function Struct:allocate()
        local newInstance = {}
        setmetatable(newInstance, {__index = self})
        newInstance:onCreate()
        return newInstance
    end

    ---Deallocate and call the stub method onDestroy via myStructInstance:destroy().
    function Struct:deallocate()
        self:onDestroy()
        for key,_ in pairs(self) do self[key] = nil end
    end

    local moduleQueue = {}
    local structQueue = {}
    ---Acquire another struct's keys via myStruct:extends(otherStruct)
    ---@param parent Struct
    function Struct:extends(parent)
        for key, val in pairs(parent) do
            if self[key] == nil then
                self[key] = val
            end
        end
    end

    ---Create a new "vJass"-style struct with myStruct = Struct([parentStruct]).
    ---@param parent? Struct
    ---@return Struct new_struct
    function mt:__call(parent)
        if self == Struct then
            local struct
            if parent then
                struct = setmetatable({super = parent, allocate = parent.create, deallocate = parent.destroy}, {__index = parent})
            else
                struct = setmetatable({}, {__index = self})
            end
            structQueue[#structQueue+1] = struct
            return struct
        end
        return self --vJass typecasting... shouldn't be used in Lua, but there could be cases where this will work without the user having to change anything.
    end

    --More vJass typecasting that really should be fixed by the user rather than a resource like this. Comparison to zero will break.
    ---@param struct Struct
    ---@return Struct same_struct
    function integer(struct) return struct end

    --stub methods:
    Struct.create = Struct.allocate
    Struct.destroy = Struct.deallocate
    Struct.onCreate = DoNothing
    Struct.onDestroy = DoNothing
    ---Check if a child struct belongs to a particular parent struct.
    ---@param parent Struct
    ---@return boolean
    function Struct:isType(parent)
        local upper = self.super
        while upper do
            if upper == parent then return true end
            upper = upper.super --loop through all parent structs of the child.
        end
        return parent == self
    end

    ---Create a new module that can be implemented by any struct.
    ---@param moduleFunc fun(struct : Struct)
    ---@return Struct.module new_module
    function Struct.module(moduleFunc)
        local module = {}
        module.init = {}
        moduleQueue[#moduleQueue+1] = module
        module.implement = function(struct)
            if not module.init[struct] then
                module.init[struct] = true
                moduleFunc(struct)
            end
        end
        return module
    end

    --Does its best to automatically handle the vJass "interface" concept.
    local defaults
    local interface
    function Struct.interface(default)
        interface = interface or {
            __index = function(tab, key)
                local default = rawget(Struct, key)
                if not default then
                    return defaults[tab]
                end
                return default
            end
        }
        local new = setmetatable({}, interface)
        defaults = defaults or {}
        defaults[new] = default and function() return default end or DoNothing
        return new
    end
    mt = {}
    local environment = setmetatable({}, mt)
    environment.struct = environment
    local getter = function(key)
        local super = rawget(environment.struct, "super")
        while super do
            local get = rawget(super, key)
            if get ~= nil then
                return get
            else
                super = rawget(super, "super")
            end
        end
    end
    mt.__index = function(_, key)
        --first check the initial struct, then check extended structs (if any), then check the main Struct library, or finally check if it's a global
        return rawget(environment.struct, key) or getter(key) or rawget(Struct, key) or rawget(_G, key)
    end
    mt.__newindex = environment.struct

    ---Complicated, but allows invisible encapsulation via:
    ---do local _ENV = myStruct:environment()
    ---    x = 10
    ---    y = 100 --assigns myStruct.x to 10 and myStruct.y to 100.
    ---end
    ---@param self Struct
    ---@return table
    function Struct:environment()
        environment.struct = self
        return environment
    end

    local function InitOperators(struct)
        if not struct.__getterFuncs then
            local mt = getmetatable(struct)
            if not mt then mt = {} ; setmetatable(struct, mt) end
            struct.__getterFuncs = {}
            struct.__setterFuncs = {}
            mt.__index = function(self, var)
                local call = self.__getterFuncs[var]
                if call then return call(self)
                elseif not self.__setterFuncs[var] then
                    return rawget(rawget(self, "parent") or Struct, var)
                end
            end
            mt.__newindex = function(self, var, val)
                local call = rawget(self, "__setterFuncs")
                call = call[var]
                if call then call(self, val)
                elseif not self.__getterFuncs[var] then
                    rawset(self, var, val)
                end
            end
        end
    end

    ---Create a new method operator with myStruct:_operatorset("x", function(val) SetUnitX(u, val) end)
    ---@param var string
    ---@param func fun(val)
    function Struct:_operatorset(var, func)
        InitOperators(self)
        self.__setterFuncs[var] = func
    end
    ---Create a new method operator with myStruct:_operatorget("x", function() return GetUnitX(u) end)
    ---@param var string
    ---@param func fun()->any
    function Struct:_operatorget(var, func)
        InitOperators(self)
        self.__getterFuncs[var] = func
    end

    if OnGlobalInit then
        OnGlobalInit(function()
            for module in ipairs(moduleQueue) do
                if module.onInit then pcall(module.onInit) end
            end
            for struct in ipairs(structQueue) do
                if struct.onInit then pcall(struct.onInit) end
            end
        end)
    end
end --end of Struct library