if Debug then Debug.beginFile("jarray") end
do
    --[[-----------------------------------------------------------------------------------------
    __jarray expander by Bribe
    
    This snippet will ensure that objects used as indices in udg_ arrays will be automatically
    cleaned up when the garbage collector runs, and tries to re-use metatables whenever possible.
    -------------------------------------------------------------------------------------------]]
    local mts = {}
    local weakKeys = {__mode="k"} --ensures tables with non-nilled objects as keys will be garbage collected.

    ---Re-define __jarray.
    ---@param default? any
    ---@param tab? table
    ---@return table
    __jarray=function(default, tab)
        local mt
        if default then
            mts[default]=mts[default] or {
                __index=function()
                    return default
                end,
                __mode="k"
            }
            mt=mts[default]
        else
            mt=weakKeys
        end
        return setmetatable(tab or {}, mt)
    end
    --have to do a wide search for all arrays in the variable editor. The WarCraft 3 _G table is HUGE,
    --and without editing the war3map.lua file manually, it is not possible to rewrite it in advance.
    for k,v in pairs(_G) do
        if type(v) == "table" and string.sub(k, 1, 4)=="udg_" then
            __jarray(v[0], v)
        end
    end
end
if Debug then Debug.endFile() end