globals
    hashtable h = InitHashtable()
endglobals

native UnitAlive takes unit u returns boolean

function UnitToInt takes unit u returns integer
    return GetHandleId(u)
endfunction

function IntToItem takes integer i returns item
    call SaveFogStateHandle(h, 0, 0, ConvertFogState(i))
    return LoadItemHandle(h, 0, 0)
endfunction

function IntToUnit takes integer i returns unit
    call SaveFogStateHandle(h, 0, 0, ConvertFogState(i))
    return LoadUnitHandle(h, 0, 0)
endfunction

function GetUnitAbilityByIndex takes unit u, integer i returns ability
    return BlzGetItemAbilityByIndex(IntToItem(UnitToInt(u)), i)
endfunction

function Trig_Untitled_Trigger_001_Actions takes nothing returns nothing
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 0))))
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 1))))
    call BJDebugMsg(DebugIdInteger2IdString(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 2))))
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 3))))
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 4))))
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 5))))
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 6))))
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 7))))
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 8))))
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 9))))
    call BJDebugMsg(GetObjectName(BlzGetAbilityId(BlzGetUnitAbilityByIndex(gg_unit_Hpal_0000, 10))))
endfunction

//===========================================================================
function InitTrig_Untitled_Trigger_001 takes nothing returns nothing
    set gg_trg_Untitled_Trigger_001 = CreateTrigger(  )
    call TriggerRegisterTimerEventSingle( gg_trg_Untitled_Trigger_001, 0.00 )
    call TriggerAddAction( gg_trg_Untitled_Trigger_001, function Trig_Untitled_Trigger_001_Actions )
endfunction

