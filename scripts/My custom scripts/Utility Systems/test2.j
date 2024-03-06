globals
    unit Bloodseeker = null
    real BloodX = 0
    real BloodY = 0
    real ThirstX = 0
    real ThirstY = 0
    real BSx = 0
    real BSy = 0
endglobals

function BSBlood takes nothing returns nothing
    local real BSdistance = SquareRoot(Pow(ThirstX - BloodX, 2) + Pow(ThirstY - BloodY, 2))
    local real BSx
    local real BSy
    if BSdistance > =  125 and not IsUnitPaused(Bloodseeker) and not IsUnitHidden(Bloodseeker) and not IsUnitStunned(Bloodseeker) and CEIROB() > 0 then
        set BSx = BloodX + 50. * Cos(GetUnitFacing(Bloodseeker) * bj_DEGTORAD)
        set BSy = BloodY + 50. * Sin(GetUnitFacing(Bloodseeker) * bj_DEGTORAD)
        if IsTerrainPathable(BSx, BSy, PATHING_TYPE_WALKABILITY) then
            set BSx = BloodX + 20. * GetUnitAbilityLevel(Bloodseeker, 'A0I8') * Cos(GetUnitFacing(Bloodseeker) * bj_DEGTORAD) * CEIROB() * .03
            set BSy = BloodY + 20. * GetUnitAbilityLevel(Bloodseeker, 'A0I8') * Sin(GetUnitFacing(Bloodseeker) * bj_DEGTORAD) * CEIROB() * .03
            call SetUnitX(Bloodseeker, BSx)
            call SetUnitY(Bloodseeker, BSy)
        endif
    endif
endfunction

function CEIROB takes nothing returns integer
    local group g = OG8()
    local integer countBS = 0
    local real HPBSThreshold = 0.7
    local unit TVS
    call GroupEnumUnitsInRange(g, BloodX, BloodY, 99999, null)
    loop
        set TVS = FirstOfGroup(g)
        exitwhen TVS == null
        if IsUnitType(TVS, UNIT_TYPE_HERO) and not IsUnitIllusion(TVS) and IsUnitEnemy(TVS, GetOwningPlayer(Bloodseeker)) and GetWidgetLife(TVS)/GetWidgetMaxLife(TVS)< = HPBSThreshold then
            set countBS = countBS + 1
        endif
        call GroupRemoveUnit(g, TVS)
    endloop
    call OF8(g)
    return countBS
endfunction

function STPOS takes nothing returns nothing
    if (Bloodseeker == GetTriggerUnit()) then
        set ThirstX = GetUnitX(GetOrderTargetUnit())
        set ThirstY = GetUnitY(GetOrderTargetUnit())
    endif
endfunction

function SPPBS takes nothing returns nothing
    if (Bloodseeker == GetTriggerUnit()) then
        set ThirstX = GetOrderPointX()
        set ThirstY = GetOrderPointY()
    endif
endfunction

function SHPBS takes nothing returns nothing
    if (Bloodseeker == GetTriggerUnit()) then
        if GetTriggerEventId() == EVENT_PLAYER_UNIT_SPELL_CAST_START then
            set ThirstX = GetUnitX(Bloodseeker)
            set ThirstY = GetUnitY(Bloodseeker)
        elseif GetTriggerEventId() == EVENT_PLAYER_UNIT_ISSUED_ORDER then
            local integer orderR = GetIssuedOrderId()
            if orderR == 8519857 or orderR == 8519859 then
                set ThirstX = GetUnitX(Bloodseeker)
                set ThirstY = GetUnitY(Bloodseeker)
            endif
        endif
    endif
endfunction

function UHPBS takes nothing returns nothing
    set BloodX = GetUnitX(Bloodseeker)
    set BloodY = GetUnitY(Bloodseeker)
endfunction

function NTE takes nothing returns nothing
    local trigger t = CreateTrigger()
    local trigger t2 = CreateTrigger()
    local trigger t3 = CreateTrigger()
    local trigger t4 = CreateTrigger()
    local trigger t5 = CreateTrigger()
    local trigger t8 = CreateTrigger()
    local trigger t9 = CreateTrigger()
    local integer W57 = GetHandleId(t)
    local unit Z77 = GetTriggerUnit()
    set Bloodseeker = GetTriggerUnit()
    call TriggerRegisterTimerEvent(t, .25, true)
    call TriggerAddCondition(t, Condition(function NRE))
    call QQ8(t2, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER)
    call TriggerAddAction(t2, function STPOS)
    call QQ8(t3, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER)
    call TriggerAddAction(t3, function SPPBS)
    call QQ8(t8, EVENT_PLAYER_UNIT_SPELL_CAST_START)
    call QQ8(t8, EVENT_PLAYER_UNIT_ISSUED_ORDER)
    call TriggerAddAction(t8, function SHPBS)
    call TriggerRegisterTimerEvent(t4, .03, true)
    call TriggerAddAction(t4, function UHPBS)
    call TriggerRegisterTimerEvent(t9, .25, true)
    call TriggerAddAction(t9, function CEIROB)
    call TriggerRegisterTimerEvent(t5, .03, true)
    call TriggerAddAction(t5, function BSBlood)
    call SaveUnitHandle(R8, (W57), (2), (Z77))
    call SaveGroupHandle(R8, (W57), (22), (OG8()))
    set t = null
    set t2 = null
    set t3 = null
    set t4 = null
    set t5 = null
    set t8 = null
    set t9 = null
    set Z77 = null
endfunction

function NUE takes nothing returns boolean
    if GetLearnedSkill() == 'A0I8' and IsUnitIllusion(GetTriggerUnit()) == false and GetUnitAbilityLevel(GetTriggerUnit(), 'A0I8') == 1 then
        call NTE()
    endif
    return false
endfunction