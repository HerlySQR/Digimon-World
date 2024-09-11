Debug.beginFile("BossFightUtils")
OnInit("BossFightUtils", function ()
    Require "AbilityUtils"
    Require "ZTS"
    Require "Pathfinder"

    local castDelay = 5. -- seconds
    local isCasting = {} ---@type boolean[]
    local LocalPlayer = GetLocalPlayer()
    local ignored = {} ---@type table<unit, table<unit, boolean>>
    local battlefield = {} ---@type table<unit, rect[]>
    local originalTargetsAllowed = {} ---@type table<unit, integer>
    local originalBaseDamage = {} ---@type table<unit, integer>

    local DASH_EFFECT = "war3mapImported\\Valiant Charge Royal.mdl"
    local TELEPORT_CASTER_EFFECT = "war3mapImported\\Blink Purple Caster.mdl"
    local TELEPORT_TARGET_EFFECT = "war3mapImported\\Blink Purple Target.mdl"
    local UNDERGOUND_EFFECT = "Objects\\Spawnmodels\\Undead\\ImpaleTargetDust\\ImpaleTargetDust.mdl"

    ---Don't cast timed duration spells when other timed duration spell is casted
    ---@param caster unit
    ---@param flag boolean
    function BossIsCasting(caster, flag)
        if flag then
            isCasting[caster] = true
        else
            Timed.call(castDelay, function () isCasting[caster] = false end)
        end
    end

    ---@param caster unit
    ---@return boolean
    function BossStillCasting(caster)
        return isCasting[caster]
    end

    ---@param boss unit
    ---@param u unit
    ---@param flag boolean
    function BossIgnoreUnit(boss, u, flag)
        if flag then
            ZTS_RemovePlayerUnit(u)
            ZTS_AddPlayerUnit(u)
        end
        ignored[boss][u] = flag
    end

    ---@param boss any
    ---@param index any
    function BossChangeAttack(boss, index)
        if index == 1 then
            BlzSetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED, 0, 33554432)
            BlzSetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, true)
            BlzSetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0, BlzGetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 1))
        elseif index == 0 then
            BlzSetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED, 0, originalTargetsAllowed[boss])
            BlzSetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, false)
            BlzSetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0, originalBaseDamage[boss])
        end
    end

    ---@param boss unit
    ---@param x number
    ---@param y number
    ---@return boolean
    local function IsPointInBattlefield(boss, x, y)
        for i = 1, #battlefield[boss] do
            if RectContainsCoords(battlefield[boss][i], x, y) then
                return true
            end
        end
        return false
    end

    ---@param boss unit
    ---@return number x, number y
    local function GetRandomPointInBattlefield(boss)
        local r = battlefield[boss][math.random(#battlefield[boss])]
        return GetRandomReal(GetRectMinX(r), GetRectMaxX(r)), GetRandomReal(GetRectMinY(r), GetRectMaxY(r))
    end

    ---@alias BossMoveType
    ---| 0 # Dash
    ---| 1 # Teleport
    ---| 2 # Underground
    ---| 3 # Jump

    ---@param a number
    ---@param b number
    ---@param greater boolean
    ---@return boolean
    local function compare(a, b, greater)
        if greater then
            return a >= b
        else
            return a <= b
        end
    end

    ---@param boss unit
    ---@param typ BossMoveType
    ---@param speed number
    ---@param dmg number
    ---@param offensive boolean
    function BossMove(boss, typ, speed, dmg, offensive)
        isCasting[boss] = true

        local xTarget, yTarget

        local checkAmount
        ForEachCellInRange(GetUnitX(boss), GetUnitY(boss), 640, function (x, y)
            for i = 1, #battlefield[boss] do
                if RectContainsCoords(battlefield[boss][i], x, y) and IsTerrainWalkable(x, y) then
                    local checkUnits = 0
                    ForUnitsInRange(x, y, 256, function (u)
                        if IsUnitEnemy(boss, GetOwningPlayer(u)) then
                            checkUnits = checkUnits + 1
                        end
                    end)
                    if not checkAmount or compare(checkUnits, checkAmount, offensive) then
                        checkAmount = checkUnits
                        xTarget, yTarget = x, y
                    end
                end
            end
        end)

        if not xTarget then
            return
        end

        local finder = Pathfinder.create(xTarget, yTarget, GetUnitX(boss), GetUnitY(boss))
        finder.outputPath = false
        finder.stepDelay = 0.04
        finder:setCond(function (x, y)
            return IsTerrainWalkable(x, y) and IsPointInBattlefield(boss, x, y)
        end)
        finder:search(function (sucess, _)
            if sucess then
                local angle = math.atan(yTarget - GetUnitY(boss), xTarget - GetUnitX(boss))
                SetUnitFacing(boss, math.deg(angle))
                local att = ConvertAttackType(BlzGetUnitWeaponIntegerField(boss, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0))

                Timed.call(0.5, function ()
                    if typ == 0 then
                        local eff = AddSpecialEffectTarget(DASH_EFFECT, boss, "origin")
                        local affected = CreateGroup()
                        local finish = Timed.echo(0.1, function ()
                            local actX, actY = GetUnitX(boss), GetUnitY(boss)
                            ForUnitsInRange(actX, actY, 256, function (u)
                                if not IsUnitInGroup(u, affected) and IsUnitEnemy(boss, GetOwningPlayer(u)) then
                                    Knockback(u, math.atan(GetUnitY(u) - actY, GetUnitX(u) - actX), 200., 700., "Abilities\\Spells\\Human\\Defend\\DefendCaster.mdl")
                                    GroupAddUnit(affected, u)
                                    Damage.apply(boss, u, dmg, false, false, att, DAMAGE_TYPE_DEFENSIVE, WEAPON_TYPE_WHOKNOWS)
                                end
                            end)
                        end)
                        Jump(boss, xTarget, yTarget, speed, 0, nil, nil, function ()
                            finish()
                            DestroyGroup(affected)
                            DestroyEffect(eff)
                            isCasting[boss] = false
                        end)
                    elseif typ == 1 then
                        local affected = CreateGroup()
                        local fun = function (u)
                            if not IsUnitInGroup(u, affected) and IsUnitEnemy(boss, GetOwningPlayer(u)) then
                                GroupAddUnit(affected, u)
                                Damage.apply(boss, u, dmg, false, false, att, DAMAGE_TYPE_DEFENSIVE, WEAPON_TYPE_WHOKNOWS)
                            end
                        end

                        DestroyEffect(AddSpecialEffect(TELEPORT_TARGET_EFFECT, xTarget, yTarget))
                        ForUnitsInRange(GetUnitX(boss), GetUnitY(boss), 256, fun)

                        DestroyEffect(AddSpecialEffect(TELEPORT_CASTER_EFFECT, GetUnitX(boss), GetUnitY(boss)))
                        ForUnitsInRange(xTarget, yTarget, 256, fun)

                        SetUnitPosition(boss, xTarget, yTarget)

                        DestroyGroup(affected)

                        isCasting[boss] = false
                    elseif typ == 2 then
                        local wasEnabled1 = BlzGetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0)
                        local wasEnabled2 = BlzGetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1)
                        BlzSetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, false)
                        BlzSetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, false)

                        local stopEffect = Timed.echo(0.5, function ()
                            DestroyEffect(AddSpecialEffect(UNDERGOUND_EFFECT, GetUnitX(boss), GetUnitY(boss)))
                        end)

                        local collision = BlzGetUnitCollisionSize(boss)
                        local crater = TerrainDeformCrater(GetUnitX(boss), GetUnitY(boss), collision*2.5, collision, 3000, false)
                        Timed.call(3., function ()
                            SetUnitInvulnerable(boss, true)
                            SetUnitPathing(boss, false)
                            TerrainDeformStop(crater, 3000)
                            ShowUnitHide(boss)

                            local n = 6
                            local m = 0
                            Timed.echo(0.5, function ()
                                if math.random(1, n) == 1 or m >= 10 then
                                    n = 1
                                    IssuePointOrderById(boss, Orders.smart, xTarget, yTarget)
                                else
                                    m = m + 1
                                    local newX, newY = GetRandomPointInBattlefield(boss)
                                    local finder2 = Pathfinder.create(newX, newY, GetUnitX(boss), GetUnitY(boss))
                                    finder2.outputPath = false
                                    finder2.stepDelay = 0.04
                                    finder2:setCond(function (x, y)
                                        return IsTerrainWalkable(x, y) and IsPointInBattlefield(boss, x, y)
                                    end)
                                    finder2:search(function (sucess2, _)
                                        if sucess2 then
                                            IssuePointOrderById(boss, Orders.smart, newX, newY)
                                        end
                                    end)
                                end
                                if math.random(1, 3) == 1 then
                                    ForUnitsInRange(GetUnitX(boss), GetUnitY(boss), 256, function (u)
                                        if IsUnitEnemy(boss, GetOwningPlayer(u)) then
                                            Damage.apply(boss, u, dmg, false, false, udg_Nature, DAMAGE_TYPE_DEFENSIVE, WEAPON_TYPE_WHOKNOWS)
                                        end
                                    end)
                                end
                                if DistanceBetweenCoords(GetUnitX(boss), GetUnitY(boss), xTarget, yTarget) <= collision then
                                    IssueImmediateOrderById(boss, Orders.stop)
                                    crater = TerrainDeformCrater(GetUnitX(boss), GetUnitY(boss), collision*2.5, collision, 3000, false)
                                    Timed.call(3., function ()
                                        TerrainDeformStop(crater, 3000)
                                        stopEffect()
                                        SetUnitPathing(boss, true)
                                        SetUnitInvulnerable(boss, false)
                                        ShowUnitShow(boss)
                                        BlzSetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0, wasEnabled1)
                                        BlzSetUnitWeaponBooleanField(boss, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1, wasEnabled2)
                                        isCasting[boss] = false
                                    end)
                                    return true
                                end
                            end)
                        end)
                    elseif typ == 3 then
                        local oldMove = BlzGetUnitMovementType(boss)
                        BlzSetUnitMovementType(boss, 2)
                        Jump(boss, xTarget, yTarget, speed, 50, nil, nil, function ()
                            BlzSetUnitMovementType(boss, oldMove)
                            local actX, actY = GetUnitX(boss), GetUnitY(boss)
                            ForUnitsInRange(actX, actY, 256, function (u)
                                if IsUnitEnemy(boss, GetOwningPlayer(u)) then
                                    Knockback(u, math.atan(GetUnitY(u) - actY, GetUnitX(u) - actX), 200., 700., "Abilities\\Spells\\Human\\FlakCannons\\FlakTarget.mdl")
                                    Damage.apply(boss, u, dmg, false, false, att, DAMAGE_TYPE_DEFENSIVE, WEAPON_TYPE_WHOKNOWS)
                                end
                            end)
                            isCasting[boss] = false
                        end)
                    end
                end)
            end
        end)
    end

    ---@param n integer
    ---@param half boolean?
    ---@return number
    local function getInterval(n, half)
        return 6 * math.exp(-0.5493061443341 * ((half and n/2 or n) - 1))
    end

    ---@param data {name: string, boss: unit, manualRevive: boolean, spells: table, castCondition: (fun():boolean)?, actions: fun(u?: unit, unitsInTheField?: Set), onStart: function?, onReset: function?, onDeath: function?, maxPlayers: integer?, entrance: rect, returnPlace: rect?, returnEnv: string?, inner: rect?, toTeleport: rect?, forceWall: destructable[]?}
    function InitBossFight(data)
        if type(data) ~= "table" then
            print("Bad data implemented in bossfight:", data)
            return
        end

        assert(_G["gg_rct_" .. data.name .. "_1"], "The regions of " .. data.name .. " are not set")
        assert(data.boss, "The boss is not set")

        originalTargetsAllowed[data.boss] = BlzGetUnitWeaponIntegerField(data.boss, UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED, 0)
        originalBaseDamage[data.boss] = BlzGetUnitWeaponIntegerField(data.boss, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)

        BlzSetUnitRealField(data.boss, UNIT_RF_HIT_POINTS_REGENERATION_RATE, 5.)
        BlzSetUnitRealField(data.boss, UNIT_RF_MANA_REGENERATION, 15.)
        ZTS_AddThreatUnit(data.boss, false)
        ignored[data.boss] = __jarray(false)

        local owner = GetOwningPlayer(data.boss)
        local interval = 3.
        battlefield[data.boss] = {}
        local playersOnField = Set.create()

        local spellsCasted
        local spells ---@type table<integer, {weight: number, order: integer, ttype: CastType}>
        if data.spells then
            spellsCasted = 0
            spells = {}
            for i = 1, #data.spells // 4 do
                spells[data.spells[4*(i-1)+1]] = {
                    weight = data.spells[4*(i-1)+2],
                    order = data.spells[4*(i-1)+3],
                    ttype = data.spells[4*(i-1)+4]
                }
            end
        end

        local initialPosX, initialPosY = GetUnitX(data.boss), GetUnitY(data.boss)

        local advice
        if not data.manualRevive then
            advice = CreateTextTagLocBJ("Revive in: ", GetUnitLoc(data.boss), 50, 10, 100, 100, 100, 0)
            SetTextTagPermanent(advice, true)
            SetTextTagVisibility(advice, false)
        end

        local numRect = 1
        while true do
            local r = rawget(_G, "gg_rct_" .. data.name .. "_" .. numRect) -- To not display the error message
            if r then
                battlefield[data.boss][numRect] = r
            else
                break
            end
            numRect = numRect + 1
        end
        numRect = numRect - 1

        local unitsInTheField = Set.create()
        local attacking = false
        local dead = false
        local returned = true

        if data.forceWall then
            for _, d in ipairs(data.forceWall) do
                ModifyGateBJ(bj_GATEOPERATION_OPEN, d)
            end
        end

        local function reset()
            if not returned then
                SetUnitState(data.boss, UNIT_STATE_LIFE, GetUnitState(data.boss, UNIT_STATE_MAX_LIFE))
                SetUnitState(data.boss, UNIT_STATE_MANA, GetUnitState(data.boss, UNIT_STATE_MAX_MANA))
                UnitResetCooldown(data.boss)
                interval = 3.
                attacking = false
                returned = true
                if data.forceWall then
                    for _, d in ipairs(data.forceWall) do
                        ModifyGateBJ(bj_GATEOPERATION_OPEN, d)
                    end
                end
                if data.onReset then
                    data.onReset()
                end
                ignored[data.boss] = __jarray(false)
            end
        end

        if data.onStart then
            data.onStart()
        end

        local function onFinish()
            dead = false
            SetTextTagVisibility(advice, false)
            SetUnitOwner(data.boss, owner, true)

            if not UnitAlive(data.boss) then
                ReviveHero(data.boss, initialPosX, initialPosY, true)
            else
                SetUnitPosition(data.boss, initialPosX, initialPosY)
            end

            ShowUnit(data.boss, true)

            returned = false
            reset()

            if data.onStart then
                data.onStart()
            end
        end

        local current = 0
        Timed.echo(0.5, function ()
            current = current + 0.5
            if UnitAlive(data.boss) then
                if dead then
                    dead = false
                end

                local whoAlreadyAre = playersOnField:toArray()
                local whoWereHere = unitsInTheField:copy()

                for p in playersOnField:elements() do
                    ResumeRevive(p)
                end

                unitsInTheField:clear()
                playersOnField:clear()

                local isInBattlefield = false
                -- Check if are units in the battlefield
                for i = 1, numRect do
                    ForUnitsInRect(battlefield[data.boss][i], function (u)
                        if u ~= data.boss and UnitAlive(u) and IsUnitEnemy(data.boss, GetOwningPlayer(u)) then
                            unitsInTheField:addSingle(u)
                            playersOnField:addSingle(GetOwningPlayer(u))
                        end
                    end)
                    isInBattlefield = isInBattlefield or RectContainsUnit(battlefield[data.boss][i], data.boss)
                end

                for p in playersOnField:elements() do
                    SuspendRevive(p)
                end

                if unitsInTheField:isEmpty() then
                    -- Reset the boss
                    reset()
                    IssuePointOrderById(data.boss, Orders.smart, initialPosX, initialPosY)
                else
                    if playersOnField:size() >= data.maxPlayers then
                        if playersOnField:size() > data.maxPlayers then
                            whoAlreadyAre = playersOnField:except(whoAlreadyAre)
                            for _ = 1, (playersOnField:size() - data.maxPlayers) do
                                local p = whoAlreadyAre:random()
                                if p then
                                    playersOnField:removeSingle(p)
                                    whoAlreadyAre:removeSingle(p)
                                    for u in unitsInTheField:elements() do
                                        if GetOwningPlayer(u) == p then
                                            SetUnitPosition(u, GetRectCenterX(data.entrance), GetRectCenterY(data.entrance))
                                        elseif whoAlreadyAre:contains(GetOwningPlayer(u)) then
                                            SetUnitPosition(u, GetRectCenterX(data.inner), GetRectCenterY(data.inner))
                                        end
                                        unitsInTheField:removeSingle(u)
                                    end
                                    ResumeRevive(p)
                                end
                            end
                        end
                        for _, d in ipairs(data.forceWall) do
                            ModifyGateBJ(bj_GATEOPERATION_CLOSE, d)
                        end
                    elseif playersOnField:size() < data.maxPlayers then
                        if IsDestructableAliveBJ(data.forceWall[1]) then
                            for _, d in ipairs(data.forceWall) do
                                ModifyGateBJ(bj_GATEOPERATION_OPEN, d)
                            end
                        end
                    end
                    -- Reset aggro for units that left the battlefield
                    for u in whoWereHere:except(unitsInTheField):elements() do
                        ZTS_RemovePlayerUnit(u)
                        ZTS_AddPlayerUnit(u)
                    end
                    -- The chances of casting increases when has low hp
                    interval = getInterval(playersOnField:size(), GetUnitHPRatio(data.boss) < 0.5)

                    if current >= interval then
                        returned = false
                        local u = nil
                        local maxThreat = -1
                        for u2 in unitsInTheField:elements() do
                            if ignored[data.boss][u2] then
                                ZTS_RemovePlayerUnit(u2)
                                ZTS_AddPlayerUnit(u2)
                            else
                                local threat = ZTS_GetThreatUnitAmount(data.boss, u2)
                                if threat > maxThreat then
                                    u = u2
                                    maxThreat = threat
                                end
                            end
                        end
                        if u then
                            if not attacking then
                                attacking = true
                                local x, y = GetUnitX(u), GetUnitY(u)
                                Timed.call(2., function ()
                                    if UnitCanAttack(data.boss) then
                                        IssuePointOrderById(data.boss, Orders.attack, x, y)
                                    end
                                end)
                            else
                                if data.spells then
                                    if spellsCasted >= 2 and not BossStillCasting(data.boss) and not BlzIsUnitInvulnerable(u) and (not data.castCondition or data.castCondition()) then
                                        spellsCasted = 0
                                        local chances = {}
                                        local options = {}
                                        for spell, stats in pairs(spells) do
                                            if GetUnitAbilityLevel(data.boss, spell) > 0
                                                and BlzGetUnitAbilityCooldownRemaining(data.boss, spell) <= 0
                                                and BlzGetUnitAbilityManaCost(data.boss, spell, GetUnitAbilityLevel(data.boss, spell) - 1) <= GetUnitState(data.boss, UNIT_STATE_MANA) then

                                                table.insert(options, spell)
                                                chances[#options] = (chances[#options-1] or 0) + stats.weight
                                            end
                                        end

                                        if options[1] then
                                            local r = chances[#chances] * math.random()
                                            for i = 1, #options do
                                                if r < chances[i] then
                                                    local stats = spells[options[i]]
                                                    if stats.ttype == CastType.IMMEDIATE then
                                                        IssueImmediateOrderById(data.boss, stats.order)
                                                    elseif stats.ttype == CastType.POINT then
                                                        IssuePointOrderById(data.boss, stats.order, GetUnitX(u), GetUnitY(u))
                                                    elseif stats.ttype == CastType.TARGET then
                                                        IssueTargetOrderById(data.boss, stats.order, u)
                                                    end
                                                    break
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            IssuePointOrderById(data.boss, Orders.move, initialPosX, initialPosY)
                        end

                        data.actions(u, unitsInTheField)
                    end
                end

                if not isInBattlefield then
                    reset()
                    IssuePointOrderById(data.boss, Orders.smart, initialPosX, initialPosY)

                    Timed.echo(0.5, 10., function ()
                        for i = 1, numRect do
                            isInBattlefield = RectContainsUnit(battlefield[data.boss][i], data.boss)
                            if isInBattlefield then
                                return true
                            end
                        end
                    end, function ()
                        reset()
                        SetUnitPosition(data.boss, initialPosX, initialPosY)
                        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", initialPosX, initialPosY))
                        DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", data.boss, "origin"))
                    end)
                end

                -- If the boss is not doing anything, set attacking state to false
                if GetUnitCurrentOrder(data.boss) == 0 then
                    attacking = false
                end
            else
                if not dead then
                    dead = true

                    isCasting[data.boss] = false

                    if data.returnPlace then
                        local tm = CreateTimer()
                        local window = CreateTimerDialog(tm)
                        TimerDialogSetTitle(window, "Digimons returning in:")
                        ForUnitsInRect(data.toTeleport, function (u)
                            TimerDialogDisplay(window, GetOwningPlayer(u) == LocalPlayer)
                        end)

                        TimerStart(tm, 15., false, function ()
                            TimerDialogDisplay(window, false)
                            DestroyTimerDialog(window)
                            PauseTimer(tm)
                            DestroyTimer(tm)

                            ForUnitsInRect(data.toTeleport, function (u)
                                local p = GetOwningPlayer(u)
                                if IsPlayerInGame(p) then
                                    local l = GetRandomLocInRect(data.returnPlace)
                                    DestroyEffect(AddSpecialEffectLoc("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdl", l))
                                    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", GetUnitX(u), GetUnitY(u)))
                                    SetUnitPositionLoc(u, l)
                                    RemoveLocation(l)
                                    if data.returnEnv then
                                        local d = Digimon.getInstance(u)
                                        if d then
                                            d.environment = Environment.get(data.returnEnv)
                                            coroutine.wrap(function ()
                                                SyncSelections()
                                                if IsUnitSelected(u, p) then
                                                    d.environment:apply(p, true)
                                                    if p == LocalPlayer then
                                                        PanCameraToTimed(GetUnitX(u), GetUnitY(u), 0.)
                                                    end
                                                end
                                            end)()
                                        end
                                    end
                                end
                            end)
                        end)
                    end

                    if data.forceWall then
                        for _, d in ipairs(data.forceWall) do
                            ModifyGateBJ(bj_GATEOPERATION_OPEN, d)
                        end
                    end

                    for p in playersOnField:elements() do
                        ResumeRevive(p)
                    end

                    unitsInTheField:clear()
                    playersOnField:clear()

                    SetTextTagVisibility(advice, IsVisibleToPlayer(initialPosX, initialPosY, LocalPlayer))

                    if not data.manualRevive then
                        local remaining = 360.
                        Timed.echo(0.02, 360., function ()
                            remaining = remaining - 0.02
                            SetTextTagText(advice, "Revive in: " .. R2I(remaining), 0.023)
                            SetTextTagVisibility(advice, dead and IsVisibleToPlayer(initialPosX, initialPosY, LocalPlayer))
                            -- In case the boss revived for another reason
                            if UnitAlive(data.boss) then
                                onFinish()
                                return true
                            end
                        end, onFinish)
                    else
                        Timed.echo(1., function ()
                            if UnitAlive(data.boss) then
                                onFinish()
                                return true
                            end
                        end)
                    end

                    if data.onDeath then
                        data.onDeath()
                    end
                end
            end
            if current >= interval then
                current = 0
            end
        end)

        do
            local t = CreateTrigger()
            TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ATTACKED)
            TriggerAddCondition(t, Condition(function () return GetTriggerUnit() == data.boss end))
            TriggerAddAction(t, function ()
                local u = GetAttacker()
                if IsUnitType(u, UNIT_TYPE_HERO) and u ~= data.boss and not unitsInTheField:contains(u) then
                    IssueTargetOrderById(u, Orders.attack, u)
                    ErrorMessage("You can't attack the boss from there", GetOwningPlayer(u))
                end
            end)
        end

        do
            local t = CreateTrigger()
            TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)
            TriggerAddCondition(t, Condition(function ()
                local u = GetSpellTargetUnit()
                if u then
                    return u == data.boss
                else
                    local x, y = GetSpellTargetX(), GetSpellTargetY()
                    for _, r in ipairs(battlefield[data.boss]) do
                        if RectContainsCoords(r, x, y) then
                            return true
                        end
                    end
                end
                return false
            end))
            TriggerAddAction(t, function ()
                local u = GetSpellAbilityUnit()
                if IsUnitType(u, UNIT_TYPE_HERO) and u ~= data.boss and not unitsInTheField:contains(u) then
                    IssueTargetOrderById(u, Orders.attack, u)
                    ErrorMessage("You can't attack the boss from there", GetOwningPlayer(u))
                end
            end)
        end

        if data.spells then
            local t = CreateTrigger()
            TriggerRegisterUnitEvent(t, data.boss, EVENT_UNIT_SPELL_EFFECT)
            TriggerAddAction(t, function ()
                if not spells[GetSpellAbilityId()] then
                    spellsCasted = spellsCasted + 1
                end
            end)
        end
    end
end)
Debug.endFile()