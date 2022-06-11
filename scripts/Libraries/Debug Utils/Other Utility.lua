--************Undeclared Globals***********

setmetatable(_G,{__index=function(_, n) if string.sub(tostring(n),1,3) ~= 'bj_' and string.sub(tostring(n),1,4) ~= 'udg_' then print("Trying to read undeclared global : "..tostring(n)) end end,})

--******************TRY********************
---Engulf a function in a try-block to catch and print errors.
---Example use: Assume you have a code line like "CreateUnit(0)", which doesn't work and you want to know why.
---* Option 1: Change it to "try(CreateUnit, 0)", i.e. separating the function from the parameters.
---* Option 2: Change it to "try(function() return CreateUnit(0) end)", i.e. pack it into an anonymous function. You can leave out the "return", if you don't need to forward the return value to the try function.
---* Option 3: Change it to "try('return CreateUnit(0)')", i.e. engulf the function call by string-marks and pass it to the try function as a string. Again, you can skip the 'return' keyword in case you don't need the return values. Pay attention that input variables are taken from global scope, if you do it this way.
---When no error occured, the try-function will return all values returned by the input function.
---When an error occurs, try will print the resulting error.
---@param input function | string
function try(input, ...)
    local execFunc = (type(input) == 'function' and input) or load(input)
    local results = table.pack(pcall(execFunc, ...)) --second return value is either the error message or the actual return value of execFunc, depending on if it executed properly.
    if not results[1] then
        print("|cffff5555" .. results[2] .. "|r")
    end
    return select(2, table.unpack(results, 1, results.n)) --if the function was executed properly, we return its return values
end

--Overwrite TriggerAddAction native to let it automatically apply "try" to any actionFunc.
do
    local oldTriggerAddAction = TriggerAddAction
    TriggerAddAction = function(whichTrigger, actionFunc)
        oldTriggerAddAction(whichTrigger, function() try(actionFunc) end)
    end
end

--***************deep table.print**************
---Returns a string showing all pairs included in the specified table.  E.g. {"a", 5, {7}} will result in '{(1, a), (2, 5), (3, {(1, 7)})}'.
---For any non-table object, returns the existing tostring(anyObject).
---Optional param recursionDepth: Defines, on which depth level of nested tables the elements should be included in the string. Setting this to nil will display elements on any depth. Setting this to 0 will just return tostring(table). 1 will show pairs within the table. 2 will show pairs within tables within the table etc.
---table.toString is not multiplayer synced.
---@param anyObject table | any
---@param recursionDepth integer --optional
---@return string
function table.tostring(anyObject, recursionDepth)
    recursionDepth = recursionDepth or -1
    local result = tostring(anyObject)
    if recursionDepth ~= 0 and type(anyObject) == 'table' then
        local elementArray = {}
        for k,v in pairs(anyObject) do
            table.insert(elementArray, '(' .. tostring(k) .. ', ' .. table.tostring(v, recursionDepth -1) .. ')')
        end
        result = '{' .. table.concat(elementArray, ', ') .. '}'
    end
    return result
end

---Displays all pairs of the specified table on screen. E.g. {"a", 5, {7}} will display as '{(1, a), (2, 5), (3, {(1, 7)})}'.
---Second parameter recursionDepth defines, in what depth elements of tables should be printed. Tables below the specified depth will not show their elements, but the usual "table: <hash>" instead. Setting this to nil displays elements to infinite depth.
---@param anyObject any
---@param recursionDepth integer | nil --optional
function table.print(anyObject, recursionDepth)
    print(table.tostring(anyObject, recursionDepth))
end

--****************Wc3Type*******************
---Returns the type of a warcraft object as string, e.g. "location", when inputting a location.
---@param input anyWarcraftObject
---@return string
function Wc3Type(input)
    local typeString = type(input)
    if typeString == 'number' then
        return (math.type(input) =='float' and 'real') or 'integer'
    elseif typeString == 'userdata' then
        typeString = tostring(input) --toString returns the warcraft type plus a colon and some hashstuff.
        return string.sub(typeString, 1, (string.find(typeString, ":", nil, true) or 0) -1) --string.find returns nil, if the argument is not found, which would break string.sub. So we need or as coalesce.
    else
        return typeString
    end
end