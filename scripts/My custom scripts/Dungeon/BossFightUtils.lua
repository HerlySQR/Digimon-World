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

    local DASH_EFFECT = "war3mapImported\\Valiant Charge Royal.mdx"
    local TELEPORT_CASTER_EFFECT = "war3mapImported\\Blink Purple Caster.mdx"
    local TELEPORT_TARGET_EFFECT = "war3mapImported\\Blink Purple Target.mdx"
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

    local function UnitCanAttack(u)
        return BlzGetUnitWeaponBooleanField(u, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0) or
               BlzGetUnitWeaponBooleanField(u, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1)
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

                if typ == 0 then
                    local eff = AddSpecialEffectTarget(DASH_EFFECT, boss, "origin")
                    local affected = CreateGroup()
                    local finish = Timed.echo(0.1, function ()
                        ForUnitsInRange(GetUnitX(boss), GetUnitY(boss), 256, function (u)
                            if not IsUnitInGroup(u, affected) and IsUnitEnemy(boss, GetOwningPlayer(u)) then
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
                        ForUnitsInRange(GetUnitX(boss), GetUnitY(boss), 256, function (u)
                            if IsUnitEnemy(boss, GetOwningPlayer(u)) then
                                Damage.apply(boss, u, dmg, false, false, att, DAMAGE_TYPE_DEFENSIVE, WEAPON_TYPE_WHOKNOWS)
                            end
                        end)
                        isCasting[boss] = false
                    end)
                end
            end
        end)
    end

    OnInit.final("BossFightUtils_OnlyOne", function ()
        Require "PlayerUtils"
        local count = 0
        ForForce(FORCE_PLAYING, function ()
            count = count + 1
        end)
        return count == 1
    end)

    ---@param name string
    ---@param boss unit
    ---@param actions fun(u?: unit, unitsInTheField?: Set)
    ---@param onStart? function
    ---@param onReset? function
    function InitBossFight(name, boss, actions, onStart, onReset)
        local onlyOne = Require "BossFightUtils_OnlyOne" ---@type boolean

        assert(_G["gg_rct_" .. name .. "_1"], "The regions of " .. name .. " are not set")
        assert(boss, "The boss is not set")

        ZTS_AddThreatUnit(boss, false)
        ignored[boss] = __jarray(false)

        local owner = GetOwningPlayer(boss)
        local interval = onlyOne and 5. or 2. -- seconds
        battlefield[boss] = {}

        local initialPosX, initialPosY = GetUnitX(boss), GetUnitY(boss)

        local advice = CreateTextTagLocBJ("Revive in: ", GetUnitLoc(boss), 50, 10, 100, 100, 100, 0)
        SetTextTagPermanent(advice, true)
        SetTextTagVisibility(advice, false)

        local numRect = 1
        while true do
            local r = rawget(_G, "gg_rct_" .. name .. "_" .. numRect) -- To not display the error message
            if r then
                battlefield[boss][numRect] = r
            else
                break
            end
            numRect = numRect + 1
        end
        numRect = numRect - 1

        local unitsInTheField = Set.create()
        local attacking = false
        local reduced = false
        local dead = false
        local returned = true

        local function reset()
            if not returned then
                SetUnitState(boss, UNIT_STATE_LIFE, GetUnitState(boss, UNIT_STATE_MAX_LIFE))
                SetUnitState(boss, UNIT_STATE_MANA, GetUnitState(boss, UNIT_STATE_MAX_MANA))
                UnitResetCooldown(boss)
                interval = onlyOne and 5. or 2. -- seconds
                attacking = false
                reduced = false
                returned = true
                if onReset then
                    onReset()
                end
                ignored[boss] = __jarray(false)
            end
        end

        if onStart then
            onStart()
        end

        local current = 0
        Timed.echo(1., function ()
            current = current + 1.
            if UnitAlive(boss) then
                if dead then
                    dead = false
                end

                unitsInTheField:clear()

                local isInBattlefield = false
                -- Check if are units in the battlefield
                for i = 1, numRect do
                    ForUnitsInRect(battlefield[boss][i], function (u)
                        if u ~= boss and UnitAlive(u) and IsUnitEnemy(boss, GetOwningPlayer(u)) then
                            unitsInTheField:addSingle(u)
                        end
                    end)
                    isInBattlefield = isInBattlefield or RectContainsUnit(battlefield[boss][i], boss)
                end

                if unitsInTheField:isEmpty() then
                    -- Reset the boss
                    reset()
                    IssuePointOrderById(boss, Orders.smart, initialPosX, initialPosY)
                else
                    if current >= interval then
                        returned = false
                        local u = nil
                        local maxThreat = -1
                        for u2 in unitsInTheField:elements() do
                            if ignored[boss][u2] then
                                ZTS_RemovePlayerUnit(u2)
                                ZTS_AddPlayerUnit(u2)
                            else
                                local threat = ZTS_GetThreatUnitAmount(boss, u2)
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
                                    if UnitCanAttack(boss) then
                                        IssuePointOrderById(boss, Orders.attack, x, y)
                                    end
                                end)
                            end
                        else
                            IssuePointOrderById(boss, Orders.move, initialPosX, initialPosY)
                        end
                        -- Spells
                        actions(u, unitsInTheField)
                    end
                end

                if not isInBattlefield then
                    reset()
                    IssuePointOrderById(boss, Orders.smart, initialPosX, initialPosY)

                    Timed.echo(0.5, 10., function ()
                        for i = 1, numRect do
                            isInBattlefield = RectContainsUnit(battlefield[boss][i], boss)
                            if isInBattlefield then
                                return true
                            end
                        end
                    end, function ()
                        reset()
                        SetUnitPosition(boss, initialPosX, initialPosY)
                        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportTarget.mdx", initialPosX, initialPosY))
                        DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdx", boss, "origin"))
                    end)
                end

                -- The chances of casting increases when has low hp
                if not reduced then
                    if GetUnitState(boss, UNIT_STATE_LIFE) / GetUnitState(boss, UNIT_STATE_MAX_LIFE) < 0.5 then
                        reduced = true
                        interval = onlyOne and 3. or 1.
                    end
                end

                -- If the boss is not doing anything, set attacking state to false
                if GetUnitCurrentOrder(boss) == 0 then
                    attacking = false
                end
            else
                if not dead then
                    dead = true

                    isCasting[boss] = false
                    unitsInTheField:clear()

                    SetTextTagVisibility(advice, IsVisibleToPlayer(initialPosX, initialPosY, LocalPlayer))

                    local remaining = 360.

                    Timed.echo(0.02, 360., function ()
                        remaining = remaining - 0.02
                        SetTextTagText(advice, "Revive in: " .. R2I(remaining), 0.023)
                        SetTextTagVisibility(advice, dead and IsVisibleToPlayer(initialPosX, initialPosY, LocalPlayer))
                    end, function ()
                        dead = false
                        SetTextTagVisibility(advice, false)
                        SetUnitOwner(boss, owner, true)
                        ReviveHero(boss, initialPosX, initialPosY, true)
                        ShowUnit(boss, true)

                        returned = false
                        reset()

                        if onStart then
                            onStart()
                        end
                    end)
                end
            end
            if current >= interval then
                current = 0
            end
        end)

        do
            local t = CreateTrigger()
            TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_ATTACKED)
            TriggerAddCondition(t, Condition(function () return GetTriggerUnit() == boss end))
            TriggerAddAction(t, function ()
                local u = GetAttacker()
                if IsUnitType(u, UNIT_TYPE_HERO) and u ~= boss and not unitsInTheField:contains(u) then
                    IssueTargetOrderById(u, Orders.attack, u)
                    ErrorMessage("You can't attack the boss from there", GetOwningPlayer(u))
                end
            end)
        end

        do
            local t = CreateTrigger()
            TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)
            TriggerAddCondition(t, Condition(function () return GetSpellTargetUnit() == boss end))
            TriggerAddAction(t, function ()
                local u = GetSpellAbilityUnit()
                if IsUnitType(u, UNIT_TYPE_HERO) and u ~= boss and not unitsInTheField:contains(u) then
                    IssueTargetOrderById(u, Orders.attack, u)
                    ErrorMessage("You can't attack the boss from there", GetOwningPlayer(u))
                end
            end)
        end

    end
end)
Debug.endFile()