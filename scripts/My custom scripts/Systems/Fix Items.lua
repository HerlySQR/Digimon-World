Debug.beginFile("Fix Items")
OnInit("Fix Items", function ()
    Require "Timed"
    Require "UnitEnterEvent"
    Require "DamageBonusSystem"

    --- Clear
    local DEFAULT_LIFE = 300. -- seconds

    local lifeSpans = __jarray(DEFAULT_LIFE) ---@type table<item, number>

    local callback = Filter(function ()
        local m = GetFilterItem()
        lifeSpans[m] = lifeSpans[m] - 1
        if lifeSpans[m] <= 0 then
            RemoveItem(m)
        end
    end)

    Timed.echo(1., function ()
        EnumItemsInRect(WorldBounds.rect, callback)
    end)

    ---@param m item
    ---@param life number?
    function SetItemLifeSpan(m, life)
        lifeSpans[m] = life or DEFAULT_LIFE
    end

    -- Fix bonuses on tooltips

    local done = {}
    local dummy = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC('H002'), WorldBounds.maxX, WorldBounds.maxY, 0)
    ShowUnitHide(dummy)

    OnItemCreate(function (itm)
        local typ = GetItemTypeId(itm)

        local tooltip = BlzGetAbilityExtendedTooltip(typ, 0)
        local description = BlzGetItemDescription(itm)

        local damage = GetItemDamageBonus(typ)
        local mod = GetItemDamageModifier(typ)
        local defense, attackSpeed, health, healthregen, mana, manaregen, stamina, dexterity, wisdom = 0, 0, 0, 0, 0, 0, 0, 0, 0

        local x, y
        if not IsItemOwned(itm) then
            x, y = GetItemX(itm), GetItemY(itm)
            UnitAddItem(dummy, itm)
        end

        local abil = nil
        local j = 0
        while true do
            abil = BlzGetItemAbilityByIndex(itm, j)
            if not abil then break end

            defense = defense + BlzGetAbilityIntegerLevelField(abil, ABILITY_ILF_DEFENSE_BONUS_IDEF, 0)
            attackSpeed = attackSpeed + BlzGetAbilityRealLevelField(abil, ABILITY_RLF_ATTACK_SPEED_BONUS_PERCENT, 0)/100
            attackSpeed = attackSpeed + BlzGetAbilityRealLevelField(abil, ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1, 0)
            health = health + BlzGetAbilityIntegerLevelField(abil, ABILITY_ILF_MAX_LIFE_GAINED, 0)
            healthregen = healthregen + BlzGetAbilityIntegerLevelField(abil, ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND, 0)
            mana = mana + BlzGetAbilityIntegerLevelField(abil, ABILITY_ILF_MAX_MANA_GAINED, 0)
            manaregen = manaregen + BlzGetAbilityRealLevelField(abil, ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL, 0)
            stamina = stamina + BlzGetAbilityIntegerLevelField(abil, ABILITY_ILF_STRENGTH_BONUS_ISTR, 0)
            dexterity = dexterity + BlzGetAbilityIntegerLevelField(abil, ABILITY_ILF_AGILITY_BONUS, 0)
            wisdom = wisdom + BlzGetAbilityIntegerLevelField(abil, ABILITY_ILF_INTELLIGENCE_BONUS, 0)

            j = j + 1
        end

        local match = function (num, percent, stat)
            stat = stat:match("^\x25s*(.-)\x25s*$")

            local new_valor
            if stat == GetLocalizedString("TOOLTIP_ATTACK_PATTERN") or stat == GetLocalizedString("TOOLTIP_DAMAGE_PATTERN") then
                new_valor = damage
            elseif stat == GetLocalizedString("TOOLTIP_ARMOR_PATTERN") or stat == GetLocalizedString("TOOLTIP_DEFENSE_PATTERN") then
                new_valor = defense
            elseif stat == GetLocalizedString("TOOLTIP_ATTACK_SPEED_PATTERN") then
                new_valor = attackSpeed
            elseif stat == GetLocalizedString("TOOLTIP_HEALTH_PATTERN") then
                new_valor = health
            elseif stat == GetLocalizedString("TOOLTIP_HEALTH_REGEN_PATTERN") then
                new_valor = healthregen
            elseif stat == GetLocalizedString("TOOLTIP_ENERGY_PATTERN") then
                new_valor = mana
            elseif stat == GetLocalizedString("TOOLTIP_ENERGY_REGEN_PATTERN") then
                new_valor = manaregen
            elseif stat == GetLocalizedString("TOOLTIP_STAMINA_PATTERN") then
                new_valor = stamina
            elseif stat == GetLocalizedString("TOOLTIP_DEXTERITY_PATTERN") then
                new_valor = dexterity
            elseif stat == GetLocalizedString("TOOLTIP_WISDOM_PATTERN") then
                new_valor = wisdom
            elseif stat == GetLocalizedString("TOOLTIP_CRITICAL_CHANCE_PATTERN") then
                new_valor = mod.criticalChance
            elseif stat == GetLocalizedString("TOOLTIP_CRITICAL_IMPACT_PATTERN") then
                new_valor = mod.critcalAmount
            elseif stat == GetLocalizedString("TOOLTIP_EVASION_CHANCE_PATTERN") then
                new_valor = mod.evasionChance
            elseif stat == GetLocalizedString("TOOLTIP_BLOCK_PATTERN") then
                new_valor = mod.blockAmount
            end

            if not new_valor then
                return "+ " .. num .. percent .. " " .. stat
            end

            local simbol = (percent == "\x25") and "\x25" or ""

            return "+ " .. new_valor .. simbol .. " " .. stat
        end

        tooltip = tooltip:gsub("\x25+\x25s*(\x25d+)(\x25\x25?)(\x25s+[\x25a\x25s]+)", match)
        if not done[typ] then
            description = description:gsub("\x25+\x25s*(\x25d+)(\x25\x25?)(\x25s+[\x25a\x25s]+)", match)
        end

        if x and y then
            UnitRemoveItem(dummy, itm)
            SetItemPosition(itm, x, y)
        end

        BlzSetItemDescription(itm, description)
        if not done[typ] then
            BlzSetAbilityExtendedTooltip(typ, tooltip, 0)
        end

        done[typ] = true
    end)
end)
Debug.endFile()