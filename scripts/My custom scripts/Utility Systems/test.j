//TESH.scrollpos=85
//TESH.alwaysfold=0
//############################## ~AdvancedAura~ ######################################//
//##
//## Version:       1.0
//## System:        Axarion
//## IndexerUtils:  Axarion
//## AbilityEvent:  Axarion
//## AutoIndex:     grim001
//## AIDS:          Jesus4Lyf
//## UnitIndexer:   Nestharus
//## TimerUtils:    Vexorian
//## GroupUtils:    Rising_Dusk
//##
//############################### DESCRIPTION ###################################//
//##
//## This System allows to  create  custom auras. It was  made, because ability
//## only auras arent very flexible and have bad filters. Also normal auras are 
//## limited to specific bonuses.
//##
//############################### HOW DOES IT WORK ##############################//
//## 
//## To use this system create an array struct and implement the AdvancedAura module.
//## You can optionally implement AdvancedAuraBuff and AdvancedAuraBonus. 
//## In the structs onInit  method you have to define the ability  for the  aura and  
//## the buffs ability if you use UnitAuraBuff. When a unit  acquires the ability the 
//## aura will be added automatically so you don't have to do it yourself. To  define 
//## the ability just use:
//##    
//##        static constant integer ability = 'AURA'
//##
//## The aura will be paused if the unit is a hero and it dies. If a unit leaves 
//## the map the aura will be removed, so you don't have to worry about leaking
//## struct instances.
//## 
//################################# METHODS #####################################//
//##   
//##    You can implement these functions into your UnitAura struct. They are 
//##    all optional. 
//##
//##    - happens when a new aura is created (define the bonuses here)
//##        method AuraInit takes nothing returns nothing
//## 
//##    - happens when a unit enters the aura     
//##        method onAffect takes unit u returns nothing
//##
//##    - happens when a unit leaves the aura   
//##        method onUnaffect takes unit u returns nothing
//##    
//##    - happens when a unit stayed in the aura
//##        method onLoop takes unit u returns nothing
//##
//##    - checks if the unit is a valid target for the aura
//##        method onFilter takes unit u returns boolean
//##
//##    - happens when the aura leveled up (increase the bonuses here)
//##        method onLevelUp takes nothing returns nothing
//##
//##    - define the AoE here
//##        method GetAuraAoE takes nothing returns real
//##
//################################# API & Variables ##############################//
//##
//##    - the unit owning the aura:
//##        .owner
//##
//##    - the level of the aura:
//##        .level
//##
//##    - the aura ability
//##        ability
//##       
//##    - the interval of the aura timer:
//##        INTERVAL
//##
//##    - the auras group with all currently affected units
//##        .InstanceGroup
//##
//################################# KNOWN BUGS ###################################//
//##
//## AutoIndex:
//## - when using AutoIndex auras will not be created for preplaced units.
//##   I don't know why if you know why tell me, please. I think its something 
//##   with TimerUtils and JassHelper's priorities.
//## 
//## AIDS:
//## - you need to make TimerUtils a requirement for AIDS or it will bug for 
//##   preplaced units with the ability
//## 
//## UnitIndexer
//## - none found yet, therefore i recommend you to use this indexer.
//##
//################################################################################//

native UnitAlive takes unit id returns boolean // may be removed if already declared.

library AdvancedAura requires TimerUtils, GroupUtils, AbilityEvent
        
    module AdvancedAura
        delegate AuraDelegate AuraDefault
        
        private static  thistype array   Instances
        private static  integer          InstancesTotal
                static  thistype         curr
                static  real             INTERVAL
        private static  timer            AuraTimer
        private         integer          Index
        readonly        group            InstanceGroup
        private         unit             InstanceUnit
        private         integer          Level
        private         boolean          pause
        readonly        integer          affectedCount
        
        method operator owner takes nothing returns unit
            return .InstanceUnit
        endmethod
        
        method operator level takes nothing returns integer
            return .Level
        endmethod
        
        method operator level= takes integer newlevel returns nothing
            loop
                exitwhen newlevel == .Level
                set .Level = .Level + 1
                call .onLevelUp()
            endloop
        endmethod
        
        static method operator [] takes unit u returns thistype
            static if LIBRARY_AIDS then
                return GetUnitIndex(u)
            else
                return GetUnitId(u)
            endif
        endmethod
        
        static method operator []= takes unit u, thistype this returns nothing
            set thistype[u] = this
        endmethod
        
        private method affect takes unit u returns nothing
            set .affectedCount = .affectedCount + 1
            
            static if thistype.BUFF_VERIFIER then
                call .addBuff(u)
            endif
            
            static if thistype.BONUS_VERIFIER then
                call .addBonuses(u)
            endif
            
            static if thistype.EFFECT_VERIFIER then
                call .addEffect(u)
            endif
            
            call curr.onAffectUnit(u)
        endmethod
        
        private method unaffect takes unit u returns nothing
            
            set .affectedCount = .affectedCount - 1
            
            static if thistype.BUFF_VERIFIER then
                call .removeBuff(u)
            endif
            
            static if thistype.BONUS_VERIFIER then
                call .removeBonuses(u)
            endif
            
            static if thistype.EFFECT_VERIFIER then
                call .removeEffect(u)
            endif
            
            call curr.onUnaffectUnit(u)
        endmethod
        
        private static method unaffectenum takes nothing returns nothing
            local unit u = GetEnumUnit()
            call curr.unaffect(u)
            call GroupRemoveUnit(curr.InstanceGroup, u)
        endmethod
        
        private static method GroupEnum takes nothing returns boolean
            local unit u = GetFilterUnit()
            local boolean b = curr.onFilter(u)
            
            if IsUnitInGroup(u, curr.InstanceGroup) and b then
                call curr.onLoopUnit(u)
            elseif b then
                call curr.affect(u)
            elseif IsUnitInGroup(u, curr.InstanceGroup) then
                call curr.unaffect(u)
            endif
            
            call GroupRemoveUnit(curr.InstanceGroup, u)
            
            set u = null
            return b
        endmethod
        
        private static method AuraLoop takes nothing returns nothing
            local integer i = 0
            local thistype this
            loop
                set this = .Instances[i]
                set curr = this
                
                if .pause == false then
                    if GetUnitAbilityLevel(.InstanceUnit, ability) == null then
                        call thistype.removeAura(.InstanceUnit)
                        set i = i - 1
                    elseif UnitAlive(.InstanceUnit) == false and IsUnitType(.InstanceUnit, UNIT_TYPE_DEAD) then
                        if IsUnitType(.InstanceUnit, UNIT_TYPE_HERO) then
                            set .pause = true
                            call ForGroup(.InstanceGroup, function thistype.unaffectenum)
                        else
                            call thistype.removeAura(.InstanceUnit)
                            set i = i - 1
                        endif
                    elseif UnitAlive(.InstanceUnit) and IsUnitType(.InstanceUnit, UNIT_TYPE_DEAD) == false and .pause then
                        set .pause = false
                    else
                        set .level = GetUnitAbilityLevel(.InstanceUnit, ability)
                        call GroupEnumUnitsInRange(ENUM_GROUP, GetUnitX(.InstanceUnit), GetUnitY(.InstanceUnit), .GetAuraAoE(), Filter(function thistype.GroupEnum))
                        
                        call ForGroup(.InstanceGroup, function thistype.unaffectenum)
                        call GroupAddGroup(ENUM_GROUP, .InstanceGroup)
                        call .onLoop()
                    endif
                endif
                
                set i = i + 1
                exitwhen i >= .InstancesTotal
            endloop
            
        endmethod
        
        private static method removeAura takes unit u returns nothing
            local thistype this             = thistype[u]
            if this != 0 then
                set .InstanceUnit               = null
                call ReleaseGroup(.InstanceGroup)
                set .Level                      = 0
                set .Instances[.Index]          = .Instances[.InstancesTotal]
                set .Instances[.InstancesTotal] = 0
                set .InstancesTotal             = .InstancesTotal - 1
                
                static if thistype.EFFECT_VERIFIER then
                    call .removeOwnerEffect()
                endif
                
                if .InstancesTotal <= 0 then
                    call PauseTimer(thistype.AuraTimer)
                    call ReleaseTimer(thistype.AuraTimer)
                endif
            endif
        endmethod
        
        private static method addAura takes unit u returns nothing
            local thistype this             = thistype[u]
            set .InstanceUnit               = u
            set .InstanceGroup              = NewGroup()
            set .Level                      = GetUnitAbilityLevel(u, ability)
            set .pause                      = false
            
            static if thistype.EFFECT_VERIFIER then
                call .addOwnerEffect()
            endif
            
            call .AuraInit()
            
            set .Instances[.InstancesTotal] = this
            set .Index                      = .InstancesTotal
            
            if .InstancesTotal == 0 then
                set thistype.AuraTimer = NewTimer()
                call TimerStart(thistype.AuraTimer, thistype.INTERVAL ,true, function thistype.AuraLoop)
            endif
            set .InstancesTotal = .InstancesTotal + 1
        endmethod
        
        private static method onInit takes nothing returns nothing
            set .InstancesTotal = 0
        endmethod 
            
        static method onIndexWithAbility takes unit u returns nothing
            call thistype.addAura(u)
        endmethod
    
        static method onDeindexWithAbility takes unit u returns nothing
            if thistype[u] != 0 then
                call thistype.removeAura(u)
            endif
        endmethod
        
        static method onSkillAbility takes unit u, integer id returns nothing
            if GetUnitAbilityLevel(u, ability) == 1 then
                call thistype.addAura(u)
            endif
        endmethod
        
        static method onAddAbility takes unit u, integer id returns nothing
            call thistype.addAura(u)
        endmethod
        
        static method onRemoveAbility takes unit u, integer id returns nothing
            call thistype.removeAura(u)
        endmethod
        
        implement AbilityEvent
    endmodule
    
    struct AuraDelegate
        method AuraInit takes nothing returns nothing
        endmethod
        method onAffectUnit takes unit u returns nothing
        endmethod
        method GetAuraAoE takes nothing returns real
            return 900.
        endmethod
        method onUnaffectUnit takes unit u returns nothing
        endmethod
        method onLoopUnit takes unit u returns nothing
        endmethod
        method onLoop takes nothing returns nothing
        endmethod
        method onFilter takes unit u returns boolean
            return true
        endmethod
        method onLevelUp takes nothing returns nothing
        endmethod
    endstruct

endlibrary

//TESH.scrollpos=0
//TESH.alwaysfold=0
//############################### CREDITS #######################################//
//##
//## Version:       1.0
//## System:        Axarion
//## IndexerUtils:  Axarion
//## AbilityEvent:  Axarion
//## AutoIndex:     grim001
//## AIDS:          Jesus4Lyf
//## UnitIndexer:   Nestharus
//## TimerUtils:    Vexorian
//## GroupUtils:    Rising_Dusk
//##
//############################### DESCRIPTION ###################################//
//##
//## This library enables you to add buffs to your aura. 
//##
//############################### HOW DOES IT WORK ##############################//
//## 
//## Just implement AdvancedAuraBuff before you implement AdvancedAura
//## and define the BUFF in the onInit method of your struct and your done.
//## The ability should be a modified Tornado Slow Aura with targets set as
//## only self and range of 0.01.
//## Also you should modify the buff/create a new one.
//## 
//##            set BUFF = 'Haxx'
//##
//################################################################################//

library AdvancedAuraBuff requires AdvancedAura

module AdvancedAuraBuff
    static integer BUFF
    private static integer array LOCK
    static constant boolean BUFF_VERIFIER = true // for checking if the module is implemented.
    
    method addBuff takes unit u returns nothing
        if BUFF != 0 then
            if LOCK[GetUnitId(u)] == 0 then
                call UnitAddAbility(u, thistype.BUFF)
                call UnitMakeAbilityPermanent(u, true, thistype.BUFF)
            endif    
            set LOCK[GetUnitId(u)] = LOCK[GetUnitId(u)] + 1
        endif
    endmethod
    
    method removeBuff takes unit u returns nothing
        if BUFF != 0 then
            set LOCK[GetUnitId(u)] = LOCK[GetUnitId(u)] - 1
            if LOCK[GetUnitId(u)] == 0 then
                call UnitRemoveAbility(u, thistype.BUFF)
            endif
        endif
    endmethod
endmodule

endlibrary

//TESH.scrollpos=18
//TESH.alwaysfold=0
//############################### CREDITS #######################################//
//##
//## Version:       1.0
//## System:        Axarion
//## IndexerUtils:  Axarion
//## AbilityEvent:  Axarion
//## AutoIndex:     grim001
//## AIDS:          Jesus4Lyf
//## UnitIndexer:   Nestharus
//## TimerUtils:    Vexorian
//## GroupUtils:    Rising_Dusk
//##
//############################### DESCRIPTION ###################################//
//##
//## This library enables you to add bonuses to your aura. 
//##
//############################### HOW DOES IT WORK ##############################//
//## 
//## Just implement AdvancedAuraBonus before you implement AdvancedAura and define 
//## the bonuses in the AuraInit method of your struct and increase/decrease them 
//## in the onLevelUp method if you want. (set .AURA_BONUS_DAMAGE = x * .level)
//## This library requires BonusMod and AbilityPreload to work.
//##
//##      ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//##      | Aura Bonus Type constants:       | Minimum bonus: | Maximum bonus: |
//##      ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//##      | AURA_BONUS_SIGHT_RANGE           |   -2048        |   +2047        |
//##      | AURA_BONUS_ATTACK_SPEED          |   -512         |   +511         |
//##      | AURA_BONUS_ARMOR                 |   -1024        |   +1023        |
//##      | AURA_BONUS_MANA_REGEN_PERCENT    |   -512%        |   +511%        |
//##      | AURA_BONUS_LIFE_REGEN            |   -256         |   +255         |
//##      | AURA_BONUS_DAMAGE                |   -1024        |   +1023        |
//##      | AURA_BONUS_STRENGTH              |   -256         |   +255         |
//##      | AURA_BONUS_AGILITY               |   -256         |   +255         |
//##      | AURA_BONUS_INTELLIGENCE          |   -256         |   +255         |
//##      ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//## 
//################################################################################//

library AdvancedAuraBonus requires AdvancedAura, BonusMod

module AdvancedAuraBonus
    static constant boolean BONUS_VERIFIER = true // for checking if the module is implemented.
    
    //! runtextmacro AuraBonusCreate("DAMAGE")
    //! runtextmacro AuraBonusCreate("ARMOR")
    //! runtextmacro AuraBonusCreate("ATTACK_SPEED")
    //! runtextmacro AuraBonusCreate("SIGHT_RANGE")
    //! runtextmacro AuraBonusCreate("LIFE_REGEN")
    //! runtextmacro AuraBonusCreate("MANA_REGEN_PERCENT")
    //! runtextmacro AuraBonusCreate("STRENGTH")
    //! runtextmacro AuraBonusCreate("AGILITY")
    //! runtextmacro AuraBonusCreate("INTELLIGENCE")

    method addBonuses takes unit u returns nothing
        //! runtextmacro AuraBonusAdd("DAMAGE", "")
        //! runtextmacro AuraBonusAdd("ARMOR", "")
        //! runtextmacro AuraBonusAdd("ATTACK_SPEED", "")
        //! runtextmacro AuraBonusAdd("SIGHT_RANGE", "")
        //! runtextmacro AuraBonusAdd("LIFE_REGEN", "")
        //! runtextmacro AuraBonusAdd("MANA_REGEN_PERCENT", "")
        //! runtextmacro AuraBonusAddHero("STRENGTH", "")
        //! runtextmacro AuraBonusAddHero("AGILITY", "")
        //! runtextmacro AuraBonusAddHero("INTELLIGENCE", "")
    endmethod

    method removeBonuses takes unit u returns nothing
        //! runtextmacro AuraBonusAdd("DAMAGE", "-")
        //! runtextmacro AuraBonusAdd("ARMOR", "-")
        //! runtextmacro AuraBonusAdd("ATTACK_SPEED", "-")
        //! runtextmacro AuraBonusAdd("SIGHT_RANGE", "-")
        //! runtextmacro AuraBonusAdd("LIFE_REGEN", "-")
        //! runtextmacro AuraBonusAdd("MANA_REGEN_PERCENT", "-")
        //! runtextmacro AuraBonusAddHero("STRENGTH", "-")
        //! runtextmacro AuraBonusAddHero("AGILITY", "-")
        //! runtextmacro AuraBonusAddHero("INTELLIGENCE", "-")
    endmethod
endmodule

//! textmacro AuraBonusCreate takes NAME 
    private integer AURA_BONUS_$NAME$_SAVER
    
    private static method $NAME$_UPDATE_REM takes nothing returns nothing
        local unit u = GetEnumUnit()
        local thistype this = curr
        
        call AddUnitBonus(u, BONUS_$NAME$, -.AURA_BONUS_$NAME$_SAVER)
        
        set u = null
    endmethod
    
    private static method $NAME$_UPDATE_ADD takes nothing returns nothing
        local unit u = GetEnumUnit()
        local thistype this = curr
        
        call AddUnitBonus(u, BONUS_$NAME$, .AURA_BONUS_$NAME$_SAVER)
        
        set u = null
    endmethod
    
    method operator AURA_BONUS_$NAME$= takes integer i returns nothing
        if .AURA_BONUS_$NAME$_SAVER != 0 then
            call ForGroup(.InstanceGroup, function thistype.$NAME$_UPDATE_REM)
        endif
        set .AURA_BONUS_$NAME$_SAVER = i
        if .AURA_BONUS_$NAME$_SAVER != 0 then
            call ForGroup(.InstanceGroup, function thistype.$NAME$_UPDATE_ADD)
        endif
    endmethod
    
    method operator AURA_BONUS_$NAME$ takes nothing returns integer
        return .AURA_BONUS_$NAME$_SAVER
    endmethod
//! endtextmacro

//! textmacro AuraBonusAdd takes NAME, plusorminus
    if .AURA_BONUS_$NAME$_SAVER != 0 then
        call AddUnitBonus(u, BONUS_$NAME$, $plusorminus$.AURA_BONUS_$NAME$_SAVER)
    endif
//! endtextmacro

//! textmacro AuraBonusAddHero takes NAME, plusorminus
    if IsUnitType(u, UNIT_TYPE_HERO) and .AURA_BONUS_$NAME$_SAVER != 0 then
        call AddUnitBonus(u, BONUS_$NAME$, $plusorminus$.AURA_BONUS_$NAME$_SAVER)
    endif
//! endtextmacro

endlibrary

//TESH.scrollpos=38
//TESH.alwaysfold=0
//############################### CREDITS #######################################//
//##
//## Version:       1.0
//## System:        Axarion
//## IndexerUtils:  Axarion
//## AbilityEvent:  Axarion
//## AutoIndex:     grim001
//## AIDS:          Jesus4Lyf
//## UnitIndexer:   Nestharus
//## TimerUtils:    Vexorian
//## GroupUtils:    Rising_Dusk
//##
//############################### DESCRIPTION ###################################//
//##
//## This library enables you to add effects to your aura. 
//##
//############################### HOW DOES IT WORK ##############################//
//## 
//## Just implement AdvancedAuraEffect before you implement AdvancedAura
//## and define the TARGET_SFX, OWNER_SFX in the onInit method of your struct and your done.
//##
//##            set TARGET_SFX      = "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
//##            set TARGET_ATTACH   = "origin"
//##            
//##            set OWNER_SFX       = ""
//##            set OWNER_ATTACH    = "origin"
//##
//################################################################################//

library AdvancedAuraEffect requires AdvancedAura

module AdvancedAuraEffect 
            static constant boolean         EFFECT_VERIFIER = true
    private static          integer array   LOCK
            static          string          TARGET_SFX      = "Abilities\\Spells\\Other\\GeneralAuraTarget\\GeneralAuraTarget.mdl"
            static          string          TARGET_ATTACH   = "origin"
            static          string          OWNER_SFX
            static          string          OWNER_ATTACH    = "origin"
    private static          effect  array   TARGET_EFFECT
    private                 effect          OWNER_EFFECT
            
    method addEffect takes unit u returns nothing
        if LOCK[GetUnitId(u)] == 0 then
            set TARGET_EFFECT[GetUnitId(u)] = AddSpecialEffectTarget(TARGET_SFX, u, TARGET_ATTACH)
        endif
        set LOCK[GetUnitId(u)] = LOCK[GetUnitId(u)] + 1
    endmethod
    
    method removeEffect takes unit u returns nothing
        set LOCK[GetUnitId(u)] = LOCK[GetUnitId(u)] - 1
        if LOCK[GetUnitId(u)] == 0 then
            call DestroyEffect(TARGET_EFFECT[GetUnitId(u)])
            set TARGET_EFFECT[GetUnitId(u)] = null
        endif
    endmethod
    
    method addOwnerEffect takes nothing returns nothing
        set .OWNER_EFFECT = AddSpecialEffectTarget(OWNER_SFX, .owner, OWNER_ATTACH)
    endmethod
    
    method removeOwnerEffect takes nothing returns nothing
        call DestroyEffect(.OWNER_EFFECT)
        set .OWNER_EFFECT = null
    endmethod
    
endmodule

endlibrary