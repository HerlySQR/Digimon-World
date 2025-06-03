Debug.beginFile("AbilityUtils")
OnInit("AbilityUtils", function ()
    --Require "Digimon"
    Require "RegisterSpellEvent"
    Require "Missiles"
    Require "Knockback"
    local MCT = Require "MCT" ---@type MCT
    Require "NewBonus"
    Require "MDTable"
    Require "Color"

    LOCUST_ID = FourCC('Aloc')
    CROW_FORM_ID = FourCC('Arav')

    ARMOR_REDUCE_SPELL = FourCC('A01R')
    ARMOR_REDUCE_ORDER = Orders.innerfire

    ICE_SPELL = FourCC('A01J')
    ICE_ORDER = Orders.frostnova

    FREEZE_SPELL = FourCC('A01L')
    FREEZE_ORDER = Orders.entanglingroots

    STUN_SPELL = FourCC('A01S')
    STUN_ORDER = Orders.thunderbolt

    POISON_SPELL = FourCC('A01U')
    POISON_ORDER = Orders.shadowstrike
    POISON_BUFF = FourCC('B002')

    CURSE_SPELL = FourCC('A01Y')
    CURSE_ORDER = Orders.curse

    SLEEP_SPELL = FourCC('A021')
    SLEEP_ORDER = Orders.thunderbolt

    SLOW_SPELL = FourCC('A02G')
    SLOW_ORDER = Orders.slow

    PURGE_SPELL = FourCC('A034')
    PURGE_ORDER = Orders.purge

    -- Remove sleep when is attacked
    local SLEEP_BUFF = FourCC('B005')
    --[[Digimon.postDamageEvent:register(function (info)
        if info.target:hasAbility(SLEEP_BUFF) and not udg_IsDamageCode then
            info.target:removeAbility(SLEEP_BUFF)
        end
    end)]]

    ---Return a damage based in the hero attributes
    ---@param caster unit
    ---@param strFactor number
    ---@param agiFactor number
    ---@param intFactor number
    ---@return number
    function GetAttributeDamage(caster, strFactor, agiFactor, intFactor)
        return GetHeroStr(caster, true) * strFactor +
               GetHeroAgi(caster, true) * agiFactor +
               GetHeroInt(caster, true) * intFactor
    end

    ---Returns the base attack damage of the unit
    ---@param caster unit
    ---@return number
    function GetBaseAttack(caster)
        local base = BlzGetUnitWeaponIntegerField(caster, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
        local dice = BlzGetUnitWeaponIntegerField(caster, UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE, 0)
        local side = BlzGetUnitWeaponIntegerField(caster, UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE, 0)
        return base + (dice * (side + 1)) / 2
    end

    ---Returns the avarage attack damage of the unit
    ---@param caster unit
    ---@return number
    function GetAvarageAttack(caster)
        return GetBaseAttack(caster) + GetUnitBonus(caster, BONUS_DAMAGE)
    end

    ---Returns the distance between the given coords
    ---@param x1 number
    ---@param y1 number
    ---@param x2 number
    ---@param y2 number
    ---@return number
    function DistanceBetweenCoords(x1, y1, x2, y2)
        return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
    end

    ---Returns the squared distance between the given coords
    ---@param x1 number
    ---@param y1 number
    ---@param x2 number
    ---@param y2 number
    ---@return number
    function DistanceBetweenCoordsSq(x1, y1, x2, y2)
        return (x1 - x2)^2 + (y1 - y2)^2
    end

    local MAX_RANGE = 100.
    local DUMMY_ITEM = CreateItem(FourCC('wolg'), 0, 0)
    SetItemVisible(DUMMY_ITEM, false)
    local SEARCH_RECT = Rect(0, 0, 128, 128)
    local hiddenItems = {} ---@type item[]

    ---@param x number
    ---@param y number
    ---@return boolean
    function IsTerrainWalkable(x, y)
        -- Hide any items in the area to avoid conflicts with our item
        MoveRectTo(SEARCH_RECT, x, y)
        EnumItemsInRect(SEARCH_RECT, nil, function ()
            if IsItemVisible(GetEnumItem()) then
                table.insert(hiddenItems, GetEnumItem())
                SetItemVisible(GetEnumItem(), false)
            end
        end)

        -- Try to move the test item and get its coords
        SetItemPosition(DUMMY_ITEM, x, y) -- Unhides the item
        local tempX, tempY = GetItemX(DUMMY_ITEM), GetItemY(DUMMY_ITEM)
        SetItemVisible(DUMMY_ITEM, false) -- Hide it again

        -- Unhide any items hidden at the start
        for i = 1, #hiddenItems do
            SetItemVisible(hiddenItems[i], true)
        end
        hiddenItems = {}

        return DistanceBetweenCoordsSq(x, y, tempX, tempY) <= MAX_RANGE and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
    end

    local pos = Location(0, 0)

    ---@param x number
    ---@param y number
    ---@return number
    function GetPosZ(x, y)
        MoveLocation(pos, x, y)
        return GetLocationZ(pos)
    end

    ---@param u unit
    ---@param withFly? boolean
    ---@return number
    function GetUnitZ(u, withFly)
        return GetPosZ(GetUnitX(u), GetUnitY(u)) + (withFly and GetUnitFlyHeight(u) or 0)
    end

    ---@param x number
    ---@param y number
    ---@param range number
    ---@param owner player
    ---@param area number
    ---@param countEnemy boolean
    ---@param countAlly boolean
    ---@return nil | number posX, number posY
    function GetConcentration(x, y, range, owner, area, countEnemy, countAlly)
        local xVals, yVals = {}, {} ---@type number[]

        ForUnitsInRange(x, y, range, function (u)
            if UnitAlive(u) and not BlzIsUnitInvulnerable(u) then
                if countEnemy and not IsUnitEnemy(u, owner) then
                    return
                end
                if countAlly and not IsUnitAlly(u, owner) then
                    return
                end
                table.insert(xVals, GetUnitX(u))
                table.insert(yVals, GetUnitY(u))
            end
        end)

        if #xVals >= 3 then
            local posX, posY = MCT.mode(xVals, true), MCT.mode(yVals, true)

            local count = 0
            ForUnitsInRange(posX, posY, area, function (u)
                if UnitAlive(u) and not BlzIsUnitInvulnerable(u) then
                    if countEnemy and not IsUnitEnemy(u, owner) then
                        return
                    end
                    if countAlly and not IsUnitAlly(u, owner) then
                        return
                    end
                    count = count + 1
                end
            end)

            if count >= 3 then
                return posX, posY
            end
        end
    end

    ---@param u unit
    function UnitAbortCurrentOrder(u)
        PauseUnit(u, true)
        IssueImmediateOrderById(u, Orders.stop)
        PauseUnit(u, false)
    end

    ---@param u unit
    ---@return number
    function GetUnitHPRatio(u)
        return GetUnitState(u, UNIT_STATE_LIFE) / GetUnitState(u, UNIT_STATE_MAX_LIFE)
    end

    ---Linear interpolation
    ---@param n1 number
    ---@param alpha number
    ---@param n2 number
    ---@return number
    function Lerp(n1, alpha, n2)
        return n1 * (1 - alpha) + (n2 * alpha)
    end

    ---Integer linear interpolation
    ---@param n1 integer
    ---@param alpha number
    ---@param n2 integer
    ---@return integer
    function ILerp(n1, alpha, n2)
        return math.round(Lerp(n1, alpha, n2))
    end

    ---Color linear interpolation
    ---@param col1 Color
    ---@param alpha number
    ---@param col2 Color
    ---@return string
    function LerpColors(col1, alpha, col2)
        return Hex2Str(
            BlzConvertColor(
                ILerp(col1.alpha, alpha, col2.alpha),
                ILerp(col1.red, alpha, col2.red),
                ILerp(col1.green, alpha, col2.green),
                ILerp(col1.blue, alpha, col2.blue)
            )
        )
    end

    ---Return if all the units in the group are alive
    ---@param g group
    ---@return boolean
    function GroupAlive(g)
        local isAlive = true
        ForGroup(g, function ()
            isAlive = isAlive and UnitAlive(GetEnumUnit())
        end)
        return isAlive
    end

    ---Return if all the units in the group are dead
    ---@param g group
    ---@return boolean
    function GroupDead(g)
        local dead = true
        ForGroup(g, function ()
            dead = dead and not UnitAlive(GetEnumUnit())
        end)
        return dead
    end

    ---@param num number
    ---@param div number?
    ---@return number
    function RoundUp(num, div)
        div = div or bj_CELLWIDTH
        local remainder = ModuloReal(math.abs(num), div)
        if remainder == 0. then
            return num
        end

        if num < 0 then
            return -(math.abs(num) - remainder);
        else
            return num + div - remainder;
        end
    end

    ---@param centerX number
    ---@param centerY number
    ---@param range number
    ---@param callback fun(x: number, y: number): boolean?
    ---@param scalar number?
    function ForEachCellInRange(centerX, centerY, range, callback, scalar)
        local cellWidth = scalar and scalar * bj_CELLWIDTH or bj_CELLWIDTH
        centerX = RoundUp(centerX, cellWidth)
        centerY = RoundUp(centerY, cellWidth)

        -- Iterate over the center
        if callback(centerX, centerY) then return end

        local n = math.ceil(range / cellWidth)

        for i = 1, n do
            -- Iterate over the axis
            local xOffset = i * cellWidth
            if callback(centerX + xOffset, centerY) then return end
            if callback(centerX, centerY + xOffset) then return end
            if callback(centerX - xOffset, centerY) then return end
            if callback(centerX, centerY - xOffset) then return end
            -- Iterate over each quadrant
            for j = 1, n do
                local yOffset = j * cellWidth
                if DistanceBetweenCoords(centerX, centerY, centerX + xOffset, centerY + yOffset) <= range then
                    if callback(centerX + xOffset, centerY + yOffset) then return end
                    if callback(centerX + xOffset, centerY - yOffset) then return end
                    if callback(centerX - xOffset, centerY + yOffset) then return end
                    if callback(centerX - xOffset, centerY - yOffset) then return end
                end
            end
        end
    end

    ---@param centerX number
    ---@param centerY number
    ---@param side number
    ---@param callback fun(x: number, y: number): boolean?
    ---@param scalar number?
    function ForEachCellInArea(centerX, centerY, side, callback, scalar)
        local cellWidth = scalar and scalar * bj_CELLWIDTH or bj_CELLWIDTH
        local firstX = RoundUp(centerX - side * 1.5, cellWidth)
        local firstY = RoundUp(centerY - side * 1.5, cellWidth)
        local n = math.ceil(2 * side / cellWidth)

        for i = 1, n do
            local xOffset = i * cellWidth
            for j = 1, n do
                local yOffset = j * cellWidth
                if callback(firstX + xOffset, firstY + yOffset) then return end
            end
        end
    end

    ---Determins if point P is in rectangle ABCD
    ---@param ax number
    ---@param ay number
    ---@param bx number
    ---@param by number
    ---@param cx number
    ---@param cy number
    ---@param dx number
    ---@param dy number
    ---@param px number
    ---@param py number
    ---@return boolean
    function IsPointInRectangle(ax, ay, bx, by, cx, cy, dx, dy, px, py)
        local cross0 = (py-ay)*(bx-ax)-(px-ax)*(by-ay)
        local cross1 = (py-cy)*(ax-cx)-(px-cx)*(ay-cy)
        local cross4 = (py-dy)*(ax-dx)-(px-dx)*(ay-dy)
        return ((cross0*cross1 >= 0) and (((py-by)*(cx-bx)-(px-bx)*(cy-by))*cross1 >= 0)) or ((cross0*cross4 >= 0) and (((py-by)*(dx-bx)-(px-bx)*(dy-by))*cross4 >= 0))
    end

    ---Checks whether the point is in a polygon defined by a sequence of connected points.
    ---@param px number
    ---@param py number
    ---@param ... number
    ---@return boolean
    function IsPointInPolygon(px, py, ...)
        local points = {...}
        local count = #points
        assert(count > 0 and count & 2 == 0, "Wrong number of parameters")
        local result = false
        count = #points // 2
        points[2*count+1] = points[1]
        points[2*count+2] = points[2]
        -- Winding number test. Simplified by quadrant checking.
        local test = 0
        for i = 1, count do
            local px1 = points[2*i-1]
            local py1 = points[2*i]
            local px2 = points[2*i+1]
            local py2 = points[2*i+2]
            local side = (px2 - px1) * (py - py1) - (px - px1) * (py2 - py1)
            if py >= py1 then
                if py < py2 and side >= 0 then
                    test = test + 1
                end
            elseif py >= py2 then
                if side <= 0 then
                    test = test - 1
                end
            end
        end
        result = test ~= 0
        return result
    end

    ---@param u unit
    ---@return boolean
    function UnitCanAttack(u)
        return BlzGetUnitWeaponBooleanField(u, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0) or
               BlzGetUnitWeaponBooleanField(u, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1)
    end

    local POISON_DURATION = 5.
    local POISON_DAMAGE = 3.
    local timers = __jarray(0) ---@type table<unit, integer>
    local counters = MDTable.create(2, 0) ---@type table<unit, table<unit, integer>>

    ---@param source unit
    ---@param target unit
    function PoisonUnit(source, target)
        if not UnitAlive(target) then
            return
        end

        if timers[target] <= 0 then
            DummyCast(GetOwningPlayer(source),
                      GetUnitX(source), GetUnitY(source),
                      POISON_SPELL,
                      POISON_ORDER,
                      1,
                      CastType.TARGET,
                      target)
            Timed.echo(1., function ()
                if timers[target] <= 0 then
                    timers[target] = 0
                    UnitRemoveAbility(target, POISON_BUFF)
                    return true
                end
            end)
        end

        if counters[source][target] <= 0 then
            timers[target] = timers[target] + 1
            Timed.echo(1., function ()
                Damage.apply(source, target, POISON_DAMAGE, true, false, udg_Nature, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS)
                counters[source][target] = counters[source][target] - 1
                if counters[source][target] <= 0 or not UnitAlive(target) then
                    timers[target] = timers[target] - 1
                    return true
                end
            end)
        end
        counters[source][target] = POISON_DURATION
    end

end)
Debug.endFile()