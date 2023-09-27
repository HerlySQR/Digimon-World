Debug.beginFile("BossFightUtils")
OnInit("BossFightUtils", function ()
    Require "AbilityUtils"
    Require "ZTS"

    local castDelay = 5. -- seconds
    local isCasting = {} ---@type boolean[]
    local LocalPlayer = GetLocalPlayer()
    local ignored = {} ---@type table<unit, table<unit, boolean>>

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
            ZTS_ModifyThreat(u, boss, 0, false)
        end
        ignored[boss][u] = flag
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
    ---@param actions fun(u: unit, unitsInTheField?: Set)
    ---@param onStart? function
    ---@param onReset? function
    function InitBossFight(name, boss, actions, onStart, onReset)
        local onlyOne = Require "BossFightUtils_OnlyOne" ---@type boolean

        assert(_G["gg_rct_" .. name .. "_1"], "The regions of " .. name .. " are not set")
        assert(boss, "The boss is not set")

        ZTS_AddThreatUnit(boss, false)
        ignored[boss] = __jarray(false)

        local owner = GetOwningPlayer(boss)
        local battlefield = {} ---@type rect[]
        local interval = onlyOne and 5. or 2. -- seconds

        local initialPosX, initialPosY = GetUnitX(boss), GetUnitY(boss)

        local advice = CreateTextTagLocBJ("Revive in: ", GetUnitLoc(boss), 50, 10, 100, 100, 100, 0)
        SetTextTagPermanent(advice, true)
        SetTextTagVisibility(advice, false)

        local numRect = 1
        while true do
            local r = rawget(_G, "gg_rct_" .. name .. "_" .. numRect) -- To not display the error message
            if r then
                battlefield[numRect] = r
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
                    ForUnitsInRect(battlefield[i], function (u)
                        if u ~= boss and UnitAlive(u) and IsUnitEnemy(boss, GetOwningPlayer(u)) then
                            unitsInTheField:addSingle(u)
                        end
                    end)
                    isInBattlefield = isInBattlefield or RectContainsUnit(battlefield[i], boss)
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
                            if not ignored[boss][u2] then
                                local threat = ZTS_GetThreatUnitAmount(boss, u2)
                                if threat > maxThreat then
                                    u = u2
                                    maxThreat = threat
                                end
                            end
                        end
                        if not attacking and u then
                            attacking = true
                            local x, y = GetUnitX(u), GetUnitY(u)
                            Timed.call(2., function ()
                                IssuePointOrderById(boss, Orders.attack, x, y)
                            end)
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
                            isInBattlefield = RectContainsUnit(battlefield[i], boss)
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