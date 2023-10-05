//TESH.scrollpos=0
//TESH.alwaysfold=0
//***********************************************************
//*1.Copy this trigger to your map
//*2.Create a gamecache variable named gamecache
//*3.Create all the abilitys and units needed in your map as that in this demo
//*4.Replace the following data, including unitid and abilityid, by that in your map
//***********************************************************
//                    *Replaceable Data*
globals
    hashtable H
endglobals


function GetConstant takes integer i returns integer
    if i==1 then
        return 'AHfa'    //abilityid of constant 1
    elseif i==2 then
        return 'e001'    //unitid of constant 2
    elseif i==3 then
        return 'A000'    //abilityid of constant 3
    elseif i==4 then
        return 'A001'    //abilityid of constant 4
    elseif i==5 then
        return 'ewsp'    //unitid of constant 5
    elseif i==6 then
        return 'A003'    //abilityid of constant 6
    elseif i==7 then
        return 15        //percent damage increased per level
    elseif i==8 then
        return 50        //equal to mana cost per arrow
    elseif i==9 then
        return 3         //basic number of targets
    elseif i==10 then
        return 1         //number of targets increased each level
    endif
    return 0
endfunction

function GetHero takes nothing returns unit
    return gg_unit_H000_0001
endfunction
//************************************************************

function GetGameCache takes nothing returns gamecache
    return udg_gamecache
endfunction

function H2I takes handle h returns integer
    return GetHandleId(h)
endfunction

function SetHandleInt takes handle subject,string name,integer value returns nothing
    if value==0 then
        call FlushStoredInteger(GetGameCache(),I2S(H2I(subject)),name)
    else
        call StoreInteger(GetGameCache(),I2S(H2I(subject)),name,value)
    endif
endfunction

function SetHandleHandle takes handle subject,string name,handle value returns nothing
    call SetHandleInt(subject,name,H2I(value))
endfunction

function GetHandleHandle takes handle subject,string name returns integer
    return GetStoredInteger(GetGameCache(),I2S(H2I(subject)),name)
endfunction

function GetHandleUnit takes handle subject,string name returns unit
    call SaveFogStateHandle(H, 0, 0, ConvertFogState(GetHandleHandle(subject,name)))
    return LoadUnitHandle(H, 0, 0)
endfunction

function GetHandleTimer takes handle subject,string name returns timer
    call SaveFogStateHandle(H, 0, 0, ConvertFogState(GetHandleHandle(subject,name)))
    return LoadTimerHandle(H, 0, 0)
endfunction

function GetHandleTrigger takes handle subject,string name returns trigger
    call SaveFogStateHandle(H, 0, 0, ConvertFogState(GetHandleHandle(subject,name)))
    return LoadTriggerHandle(H, 0, 0)
endfunction

function GetHandleInt takes handle subject,string name returns integer
    return GetStoredInteger(GetGameCache(),I2S(H2I(subject)),name)
endfunction

function FlushHandleLocals takes handle subject returns nothing
    call FlushStoredMission(GetGameCache(),I2S(H2I(subject)))
endfunction

function ColdArrowDamage_Conditions takes nothing returns boolean
    return GetEventDamageSource()==GetHero()
endfunction

function ColdArrowDamage_Actions takes nothing returns nothing
    local integer loopindex=1
    local unit caster=GetTriggerUnit()
    local unit target=GetHandleUnit(caster,"target")
    local integer i=GetUnitAbilityLevel(GetHero(),GetConstant(1))
    if Pow(GetUnitX(target)-GetUnitX(caster),2)+Pow(GetUnitY(target)-GetUnitY(caster),2)>10000 then
        return  
    endif
    if GetHandleInt(caster,"maintarget")==0 then
        call UnitDamageTarget(caster,target,(1+0.01*GetConstant(7)*i)*GetEventDamage(),true,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_WHOKNOWS)
    else   
        call UnitDamageTarget(caster,target,0.01*GetConstant(7)*i*GetEventDamage(),true,false,ATTACK_TYPE_HERO,DAMAGE_TYPE_NORMAL,WEAPON_TYPE_WHOKNOWS)
    endif
    call SetHandleInt(caster,"timercount",20)
    set caster=CreateUnit(GetOwningPlayer(caster),GetConstant(2),GetUnitX(target),GetUnitY(target),0)
    call ShowUnit(caster,false)
    call UnitApplyTimedLife(caster,0,0.5)
    call SetUnitAbilityLevel(caster,GetConstant(6),i)
    call IssueTargetOrder(caster,"coldarrowstarg",target)
    set caster=null
    set target=null
endfunction

function SetCasterPosition takes nothing returns nothing
    local timer t=GetExpiredTimer()
    local unit caster=GetHandleUnit(t,"caster")
    local unit target=GetHandleUnit(caster,"target")
    local integer timercount=GetHandleInt(caster,"timercount")
    call IssuePointOrder(caster,"smart",GetUnitX(target),GetUnitY(target))  
    call SetHandleInt(caster,"timercount",timercount+1)
    if timercount>=24 or GetUnitState(target,UNIT_STATE_LIFE)<=0 then
        call FlushHandleLocals(caster)
        call DestroyTrigger(GetHandleTrigger(t,"trigger"))
        call RemoveUnit(caster)
        call FlushHandleLocals(t)
        call PauseTimer(t)
        call DestroyTimer(t)
    endif
    set t=null
    set caster=null
    set target=null
endfunction

function UnitTypeFilter takes unit u returns boolean
    return IsUnitEnemy(u,GetOwningPlayer(GetTriggerUnit())) and IsUnitType(u,UNIT_TYPE_MAGIC_IMMUNE)==false and IsUnitType(u,UNIT_TYPE_STRUCTURE)==false
endfunction

function Filter_Conditions takes nothing returns boolean
    return GetUnitState(GetFilterUnit(),UNIT_STATE_LIFE)>0 and UnitTypeFilter(GetFilterUnit())
endfunction

function CreateCasters takes unit trigunit,unit targetunit returns nothing
    local integer loopindex=1
    local integer loopend=GetConstant(9)+GetConstant(10)*GetUnitAbilityLevel(GetHero(),GetConstant(1))-1
    local unit caster
    local unit pickedunit
    local timer t
    local trigger trig
    local group g=CreateGroup()
    local boolexpr filter=Condition(function Filter_Conditions)
    call GroupEnumUnitsInRange(g,GetUnitX(trigunit),GetUnitY(trigunit),700,filter)
    call DestroyBoolExpr(filter)
    set filter=null
    set pickedunit=targetunit
    loop
        set caster=CreateUnit(GetOwningPlayer(trigunit),GetConstant(5),GetUnitX(pickedunit),GetUnitY(pickedunit),0)
        call SetUnitFlyHeight(caster,GetUnitFlyHeight(pickedunit),0)
        call SetHandleHandle(caster,"target",pickedunit)
        if loopindex==1 then
            call SetHandleInt(caster,"maintarget",1)        
        endif
        call UnitRemoveType(GetHandleUnit(trigunit,"caster"+I2S(loopindex)),UNIT_TYPE_MECHANICAL)
        call SetHandleHandle(trigunit,"caster"+I2S(loopindex),caster)
        set t=CreateTimer()
        call SetHandleHandle(t,"caster",caster)
        call TimerStart(t,0.15,true,function SetCasterPosition)
        set trig=CreateTrigger()
        call TriggerRegisterUnitEvent(trig,caster,EVENT_UNIT_DAMAGED)
        call TriggerAddCondition(trig,Condition(function ColdArrowDamage_Conditions))
        call TriggerAddAction(trig,function ColdArrowDamage_Actions)
        call SetHandleHandle(t,"trigger",trig)
        call GroupRemoveUnit(g,pickedunit)
        set pickedunit=FirstOfGroup(g)
        exitwhen loopindex==loopend or pickedunit==null
        set loopindex=loopindex+1  
    endloop
    call DestroyGroup(g)
    set caster=null
    set pickedunit=null
    set t=null
    set trig=null
    set g=null
endfunction

function ManualCast_Conditions takes nothing returns boolean
    return GetSpellAbilityId()==GetConstant(1)
endfunction

function ManualCast_Actions takes nothing returns nothing
    local unit trigunit=GetTriggerUnit()
    call SetPlayerAbilityAvailable(GetOwningPlayer(trigunit),GetConstant(3),true)
    call CreateCasters(trigunit,GetSpellTargetUnit())
    call SetHandleHandle(trigunit,"target",GetSpellTargetUnit())
    set trigunit=null
endfunction

function AutoCast_Actions takes nothing returns nothing
    local unit trigunit=GetTriggerUnit()
    local player p=GetOwningPlayer(trigunit)
    if GetHandleInt(trigunit,"ColdArrowOn")==1 and UnitTypeFilter(GetEventTargetUnit()) then
        if GetUnitState(trigunit,UNIT_STATE_MANA)>=I2R(GetConstant(8)) then
            call SetPlayerAbilityAvailable(p,GetConstant(3),true)
        else
            call SetPlayerAbilityAvailable(p,GetConstant(3),false)
        endif
        call CreateCasters(trigunit,GetEventTargetUnit())
    else
        call SetPlayerAbilityAvailable(p,GetConstant(3),false)
    endif
    call SetHandleHandle(trigunit,"target",GetEventTargetUnit())
    set trigunit=null
    set p=null
endfunction

function ColdArrowSwitch_Conditions takes nothing returns boolean
    return GetIssuedOrderId()==OrderId("flamingarrows") or GetIssuedOrderId()==OrderId("unflamingarrows")
endfunction

function ColdArrowSwitch_Actions takes nothing returns nothing
    local unit trigunit=GetTriggerUnit()
    local player p=GetOwningPlayer(trigunit)
    if GetIssuedOrderId()==OrderId("flamingarrows") then
        call SetHandleInt(trigunit,"ColdArrowOn",1)
        if GetUnitState(trigunit,UNIT_STATE_MANA)>=I2R(GetConstant(8)) and UnitTypeFilter(GetHandleUnit(trigunit,"target")) then
            call SetPlayerAbilityAvailable(p,GetConstant(3),true)
            call CreateCasters(trigunit,GetHandleUnit(trigunit,"target"))
        endif
    else
        call SetPlayerAbilityAvailable(p,GetConstant(3),false)
        call SetHandleInt(trigunit,"ColdArrowOn",0)
    endif
    set trigunit=null
    set p=null
endfunction

function ManaUseUp_Actions takes nothing returns nothing
    local unit trigunit=GetTriggerUnit()
    if GetHandleInt(trigunit,"ColdArrowOn")==1 and UnitTypeFilter(GetHandleUnit(trigunit,"target")) then
        call SetPlayerAbilityAvailable(GetOwningPlayer(trigunit),GetConstant(3),true)
    endif
    set trigunit=null
endfunction

function InitTrig_MultiColdArrow takes nothing returns nothing
    set H = InitHashtable()
    set udg_gamecache=InitGameCache("GameCache.w3v")
    call SetPlayerAbilityAvailable(GetOwningPlayer(GetHero()),GetConstant(3),false)
    call SetPlayerAbilityAvailable(GetOwningPlayer(GetHero()),GetConstant(4),false)
    set gg_trg_MultiColdArrow=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_MultiColdArrow,GetHero(),EVENT_UNIT_ISSUED_ORDER)
    call TriggerAddCondition(gg_trg_MultiColdArrow,Condition(function ColdArrowSwitch_Conditions))
    call TriggerAddAction(gg_trg_MultiColdArrow,function ColdArrowSwitch_Actions)
    set gg_trg_MultiColdArrow=CreateTrigger()
    call TriggerRegisterUnitManaEvent(gg_trg_MultiColdArrow,GetHero(),GREATER_THAN_OR_EQUAL,I2R(GetConstant(8)))
    call TriggerAddAction(gg_trg_MultiColdArrow,function ManaUseUp_Actions)
    set gg_trg_MultiColdArrow=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_MultiColdArrow,GetHero(),EVENT_UNIT_SPELL_CAST)
    call TriggerAddCondition(gg_trg_MultiColdArrow,Condition(function ManualCast_Conditions))
    call TriggerAddAction(gg_trg_MultiColdArrow,function ManualCast_Actions)
    set gg_trg_MultiColdArrow=CreateTrigger()
    call TriggerRegisterUnitEvent(gg_trg_MultiColdArrow,GetHero(),EVENT_UNIT_TARGET_IN_RANGE)
    call TriggerAddAction(gg_trg_MultiColdArrow,function AutoCast_Actions)
endfunction