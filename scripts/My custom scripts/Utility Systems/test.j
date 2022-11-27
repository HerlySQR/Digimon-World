library ProgressBars requires TimerUtils optional BoundSentinel
/**************************************************************
*
*   ProgressBars v2.0.1 by TriggerHappy
*
*   This library allows you to easily create and modify progress bars.
*   It works by creating a dummy unit with a special model and changing
*   the animation speed to increase or reduce the bar speed. It is more than
*   just a wrapper as it recycles each progress bar, meaning it will avoid
*   costly CreateUnit calls whenever possible which also leak.
*
*   Options:
*       x            - set X coordinate
*       y            - set Y coordinate
*       xOffset      - offset of the target unit, if any.
*       yOffset      - offset of the target unit, if any.
*       zOffset      - how high the bar is from the ground.
*       color        - allows you to tint the bar or add transparency
*       targetUnit   - pick which unit the bar should hover over
*       size         - set model scale
*
*   Usage:
*       local ProgressBar bar = ProgressBar.create()
*       set bar.zOffset       = 150
*       set bar.color         = PLAYER_COLOR_RED
*       set bar.targetUnit    = CreateUnit(Player(0), 'hfoo', 0, 0, 0)
*       call bar.setPercentage(30)
*
*   Installation:
*       1. Copy the dummy unit over to your map
*       2. Change the DUMMY constant to fit the Raw code of the dummy.
*       3. Copy this and all required libraries over to your map.
*
*   Thanks to JesusHipster for the Progress Bar models
*   and to Vexorian for TimerUtils & BoundSentinel
*
**************************************************************/

    globals
        private constant integer PROGRESS_BAR_DUMMY     = 'pbar' // the default one
        private constant player  PROGRESS_BAR_OWNER     = Player(PLAYER_NEUTRAL_PASSIVE) // owner of the dummy
        private constant real    UPDATE_POSITION_PERIOD = 0.03 // the timer period used with .targetUnit
    endglobals
    
    struct ProgressBar
    
        unit bar
        unit target
        
        real xOffset = 0
        real yOffset = 0
        
        timer timer
        timer timer2
        
        private boolean t_enabled = false
        private real endVal
        private real curVal=0
        private real pspeed=0
        private boolean reverse
        private boolean done
        private boolean recycle
        
        readonly static unit array dummy
        readonly static integer lastDummyIndex = -1

        method operator x= takes real x returns nothing
            call SetUnitX(this.bar, x)
        endmethod
        
        method operator x takes nothing returns real
            return GetUnitX(this.bar)
        endmethod
        
        method operator y= takes real y returns nothing
            call SetUnitY(this.bar, y)
        endmethod
        
        method operator y takes nothing returns real
            return GetUnitY(this.bar)
        endmethod
        
        method operator zOffset= takes real offset returns nothing
            call SetUnitFlyHeight(this.bar, offset, 0)
        endmethod
        
        method operator zOffset takes nothing returns real
            return GetUnitFlyHeight(this.bar)
        endmethod
        
        method operator size= takes real size returns nothing
            call SetUnitScale(this.bar, size, size, size)
        endmethod
        
        method operator color= takes playercolor color returns nothing
            call SetUnitColor(this.bar, color)
        endmethod
        
        method show takes boolean flag returns nothing
            call UnitRemoveAbility(this.bar, 'Aloc')
            call ShowUnit(this.bar, flag)
            call UnitAddAbility(this.bar, 'Aloc')
        endmethod
        
        method reset takes nothing returns nothing
            call SetUnitAnimationByIndex(this.bar, 1)
        endmethod

        method RGB takes integer red, integer green, integer blue, integer alpha returns nothing
            call SetUnitVertexColor(this.bar, red, green, blue, alpha)
        endmethod
        
        method destroy takes nothing returns nothing
            if (recycle) then
                set lastDummyIndex = lastDummyIndex + 1
                set dummy[lastDummyIndex] = this.bar
                call SetUnitAnimationByIndex(this.bar, 0)
                call SetUnitTimeScale(this.bar, 1)
            endif
            
            set this.bar        = null
            set this.target     = null
            set this.t_enabled  = false
            set this.endVal     = 0
            set this.curVal     = 0
            
            if (this.timer != null) then
                call ReleaseTimer(this.timer)
                set this.timer = null
            endif
            
            if (this.timer2 != null) then
                call ReleaseTimer(this.timer2)
                set this.timer2 = null
            endif
        endmethod
        
        private static method updatePercentage takes nothing returns nothing
            local timer expired = GetExpiredTimer()
            local thistype this = GetTimerData(expired)
            
            if (this.reverse) then
            
                if (this.curVal > this.endVal) then
                    call SetUnitTimeScale(this.bar, -this.pspeed)
                    set this.curVal = (this.curVal - (this.pspeed))
                elseif (this.curVal <= this.endVal) then
                    call PauseTimer(this.timer2)
                    call SetUnitTimeScale(this.bar, 0)
                    set this.curVal = this.endVal
                    set this.done   = true
                endif
                
            else
            
                if (this.curVal < this.endVal) then
                    call SetUnitTimeScale(this.bar, this.pspeed)
                    set this.curVal = (this.curVal + (this.pspeed))
                elseif (this.curVal >= this.endVal) then
                    call PauseTimer(this.timer2)
                    call SetUnitTimeScale(this.bar, 0)
                    set this.curVal = this.endVal
                    set this.done   = true
                    
                endif
                
            endif
            
        endmethod
        
        private static method updatePosition takes nothing returns nothing
            local thistype this = GetTimerData(GetExpiredTimer())
            if (this.target != null) then
                call SetUnitX(this.bar, GetUnitX(this.target) + xOffset)
                call SetUnitY(this.bar, GetUnitY(this.target) + yOffset)
            else
                call ReleaseTimer(GetExpiredTimer())
            endif
        endmethod
        
        private static method getDummy takes nothing returns unit
            if (lastDummyIndex <= -1) then
                set bj_lastCreatedUnit = CreateUnit(PROGRESS_BAR_OWNER, PROGRESS_BAR_DUMMY, 0, 0, 270)
                call PauseUnit(bj_lastCreatedUnit, true)
                return bj_lastCreatedUnit
            endif
            call SetUnitAnimationByIndex(dummy[lastDummyIndex], 1)
            set lastDummyIndex = lastDummyIndex - 1
            return dummy[lastDummyIndex + 1]
        endmethod
        
        static method release takes integer count returns nothing
            if (count > thistype.lastDummyIndex) then
                set count = thistype.lastDummyIndex
            endif
                
            loop
                exitwhen count <= 0
                call RemoveUnit(dummy[count])
                set dummy[count] = null
                set count = count - 1
            endloop
                
            set thistype.lastDummyIndex = -1
        endmethod
        
        static method create takes nothing returns thistype
            local thistype this = thistype.allocate()
            
            set this.bar        = thistype.getDummy()
            set this.done       = true
            set this.recycle    = true
            
            call SetUnitAnimationByIndex(this.bar, 1)
            call SetUnitTimeScale(this.bar, 0)
            
            return this
        endmethod
        
        static method createEx takes integer unitId returns thistype
            local thistype this = thistype.allocate()
            
            set this.bar        = CreateUnit(PROGRESS_BAR_OWNER, unitId, 0, 0, 0)
            set this.done       = true
            set this.recycle    = false
            
            call SetUnitAnimationByIndex(this.bar, 1)
            call SetUnitTimeScale(this.bar, 0)
            
            return this
        endmethod
        
        method setPercentage takes real percent, real speed returns nothing
            set this.endVal = R2I(percent)
            set this.pspeed = speed
            
            set this.reverse = (curVal > endVal)
                
            if (this.done) then
                
                if (this.timer2 == null) then
                    set this.timer2 = NewTimerEx(this)
                endif
            
                call TimerStart(this.timer2, 0.01, true, function thistype.updatePercentage)
                set this.done=false
            endif
        endmethod
        
        method operator targetUnit= takes unit u returns nothing
            set this.target = u
            
            if (u != null) then
                if (this.timer == null) then
                    set this.timer = NewTimerEx(this)
                endif
                call TimerStart(this.timer, UPDATE_POSITION_PERIOD, true, function thistype.updatePosition)
                call SetUnitX(this.bar, GetUnitX(this.target) - xOffset)
                call SetUnitY(this.bar, GetUnitY(this.target) - yOffset)
                set this.t_enabled = true
            else
                if (this.timer != null) then
                    call ReleaseTimer(this.timer)
                endif
                set this.t_enabled = false
            endif
        endmethod
        
    endstruct
    
endlibrary