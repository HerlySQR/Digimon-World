Debug.beginFile("Stats")
OnInit("Stats", function ()
    Require "DigimonBank"
    Require "FrameLoader"
    Require "Menu"
    Require "Timed"
    Require "Color"
    Require "GetMainSelectedUnit"
    Require "Hotkeys"

    local WATER_ICON = udg_WATER_ICON
    local MACHINE_ICON = udg_MACHINE_ICON
    local BEAST_ICON = udg_BEAST_ICON
    local FIRE_ICON = udg_FIRE_ICON
    local NATURE_ICON = udg_NATURE_ICON
    local AIR_ICON = udg_AIR_ICON
    local DARK_ICON = udg_DARK_ICON
    local HOLY_ICON = udg_HOLY_ICON
    local HERO_ICON = udg_HERO_ICON

    local SHIELD_ICON = udg_SHIELD_ICON
    local WEAPON_ICON = udg_WEAPON_ICON
    local ACCESORY_ICON = udg_ACCESORY_ICON
    local DIGIVICE_ICON = udg_DIGIVICE_ICON
    local CREST_ICON = udg_CREST_ICON

    local icons = {
        [0] = SHIELD_ICON,
        [1] = WEAPON_ICON,
        [2] = ACCESORY_ICON,
        [3] = ACCESORY_ICON,
        [4] = DIGIVICE_ICON,
        [5] = CREST_ICON
    }

    local names = {
        [0] = GetLocalizedString("STATS_EQUIP_NAME_1"), -- "Shield"
        [1] = GetLocalizedString("STATS_EQUIP_NAME_2"), -- "Weapon"
        [2] = GetLocalizedString("STATS_EQUIP_NAME_3"), -- "Accesory"
        [3] = GetLocalizedString("STATS_EQUIP_NAME_3"), -- "Accesory"
        [4] = GetLocalizedString("STATS_EQUIP_NAME_4"), -- "Digivice"
        [5] = GetLocalizedString("STATS_EQUIP_NAME_5")  -- "Crest"
    }

    local StatsButton = nil ---@type framehandle
    local BackdropStatsButton = nil ---@type framehandle
    local StatsBackdrop = {} ---@type framehandle[]
    local StatsName = {} ---@type framehandle[]
    local StatsDamageLabel = {} ---@type framehandle[]
    local StatsDamageIcon = {} ---@type framehandle[]
    local StatsArmorLabel = {} ---@type framehandle[]
    local StatsArmorIcon = {}  ---@type framehandle[]
    local StatsDamage = {} ---@type framehandle[]
    local StatsArmor = {} ---@type framehandle[]
    local StatsHeroIcon = {} ---@type framehandle[]
    local StatsStaminaLabel = {} ---@type framehandle[]
    local StatsStamina = {} ---@type framehandle[]
    local StatsDexterityLabel = {} ---@type framehandle[]
    local StatsDexterity = {} ---@type framehandle[]
    local StatsWisdomLabel = {} ---@type framehandle[]
    local StatsWisdom = {} ---@type framehandle[]
    local StatsLife = {} ---@type framehandle[]
    local StatsMana = {} ---@type framehandle[]
    local StatsExp = {} ---@type framehandle[]
    local StatsExpSlash = {} ---@type framehandle[]
    local StatsLifeSlash = {} ---@type framehandle[]
    local StatsManaSlash = {} ---@type framehandle[]
    local StatsMaxExp = {} ---@type framehandle[]
    local StatsMaxLife = {} ---@type framehandle[]
    local StatsMaxMana = {} ---@type framehandle[]
    local StatsDigimonIcon = {} ---@type framehandle[]
    local StatsDigimonLevelBackdrop = {} ---@type framehandle[]
    local StatsDigimonLevel = {} ---@type framehandle[]
    local StatsCriticalLabel = {} ---@type framehandle[]
    local StatsBlockLabel = {} ---@type framehandle[]
    local StatsEvasionLabel = {} ---@type framehandle[]
    local StatsImpactLabel = {} ---@type framehandle[]
    local StatsCritical = {} ---@type framehandle[]
    local StatsBlock = {} ---@type framehandle[]
    local StatsEvasion = {} ---@type framehandle[]
    local StatsImpact = {} ---@type framehandle[]
    local StatsInventoryBackdrop = {} ---@type framehandle[]
    local StatsItemT = {} ---@type framehandle[][]
    local BackdropStatsItemT = {} ---@type framehandle[][]
    local StatsItemTooltip = {} ---@type framehandle[][]
    local StatsItemTooltipText = {} ---@type framehandle[][]
    local StatsItemDrop = nil ---@type framehandle
    --local FocusedUnit = nil ---@type framehandle
    local SelectedHero = {} ---@type framehandle[]
    local HeroButtons = {} ---@type framehandle[]
    local HeroBuffs = {} ---@type framehandle[][]
    local OtherStats = nil ---@type framehandle
    local OtherStatsBackdrop = nil ---@type framehandle
    local SelectedDigimonIcon = nil ---@type framehandle
    local SelectedDigimonName = nil ---@type framehandle
    local OtherStatsDmgLabel = nil ---@type framehandle
    local OtherStatsDmgIcon = nil ---@type framehandle
    local OtherStatsDefIcon = nil ---@type framehandle
    local OtherStatsDefLabel = nil ---@type framehandle
    local OtherStatsDefAmount = nil ---@type framehandle
    local OtherStatsDmgAmount = nil ---@type framehandle

    local LocalPlayer = GetLocalPlayer()

    local armorEquiv = {
        [0] = GetHandleId(udg_Holy),
        [1] = GetHandleId(udg_Water),
        [2] = GetHandleId(udg_Machine),
        [3] = GetHandleId(udg_Beast),
        [4] = GetHandleId(udg_Nature),
        [5] = GetHandleId(udg_Air),
        [6] = GetHandleId(udg_Dark),
        [7] = GetHandleId(udg_Fire)
    }
    local red = Color.new(0xFF0000)
    local green = Color.new(0x00FF00)
    local exps = __jarray(0) ---@type integer[]
    local reqExps = __jarray(0) ---@type integer[]
    exps[1] = 50
    local prevValFactor = 1
    local lvlFactor = 10
    local constFactor = 45

    for i = 2, 98 do
        exps[i] = exps[i-1]*prevValFactor + (i+1)*lvlFactor + constFactor
    end
    exps[99] = exps[98]

    for i = 1, 98 do
        reqExps[i] = exps[i] - exps[i-1]
    end

    ---@param xp integer
    ---@return integer
    function GetLevelFromXP(xp)
        for i = 1, 99 do
            if xp < exps[i] then
                return i
            end
        end
        return 99
    end

    local allVisible = false
    local changeVisible = false
    local dropItemI = __jarray(0) ---@type table<player, integer>
    local dropItemJ = __jarray(0) ---@type table<player, integer>
    local buffIcons = __jarray("") ---@type table<integer, string>

    local function StatsButtonFunc(p)
        if not GetUsedDigimons(p)[1] then
            return
        end
        if p == LocalPlayer then
            allVisible = not allVisible
            changeVisible = true
        end
    end

    Timed.echo(0.08, function ()
        local list = GetUsedDigimons(LocalPlayer)
        for i = 0, 2 do
            if allVisible then
                if changeVisible and not BlzFrameIsVisible(StatsBackdrop[i]) then
                    BlzFrameSetVisible(StatsBackdrop[i], true)
                end

                if not list[i+1] then
                    BlzFrameSetVisible(StatsBackdrop[i], false)
                else
                    local d = list[i+1]
                    if not d then
                        break
                    end
                    local u = d.root
                    local name
                    if IsUnitType(u, UNIT_TYPE_HERO) then
                        name = GetHeroProperName(u)

                        BlzFrameSetVisible(StatsHeroIcon[i], true)
                        BlzFrameSetVisible(StatsStaminaLabel[i], true)
                        BlzFrameSetVisible(StatsStamina[i], true)
                        BlzFrameSetVisible(StatsDexterityLabel[i], true)
                        BlzFrameSetVisible(StatsDexterity[i], true)
                        BlzFrameSetVisible(StatsWisdomLabel[i], true)
                        BlzFrameSetVisible(StatsWisdom[i], true)
                        BlzFrameSetVisible(StatsDigimonLevel[i], true)

                        local base = GetHeroStr(u, false)
                        local bonus = GetHeroStr(u, true) - base
                        BlzFrameSetText(StatsStamina[i], base .. ((bonus > 0) and (" (+".. bonus .. ")") or ""))

                        base = GetHeroAgi(u, false)
                        bonus = GetHeroAgi(u, true) - base
                        BlzFrameSetText(StatsDexterity[i], base .. ((bonus > 0) and (" (+".. bonus .. ")") or ""))

                        base = GetHeroInt(u, false)
                        bonus = GetHeroInt(u, true) - base
                        BlzFrameSetText(StatsWisdom[i], base .. ((bonus > 0) and (" (+".. bonus .. ")") or ""))

                        BlzFrameSetText(StatsCritical[i], d.critcalChance .. "\x25")

                        BlzFrameSetText(StatsImpact[i], "x" .. d.critcalAmount)

                        BlzFrameSetText(StatsBlock[i], d.blockAmount .. "\x25")

                        BlzFrameSetText(StatsEvasion[i], d.evasionChance .. "\x25")

                        local l = GetHeroLevel(u)

                        if (d.rank == Rank.ROOKIE and l >= udg_MAX_ROOKIE_LVL)
                            or (d.rank == Rank.CHAMPION and l >= udg_MAX_CHAMPION_LVL)
                            or (d.rank == Rank.ULTIMATE and l >= udg_MAX_ULTIMATE_LVL)
                            or (d.rank == Rank.MEGA and l >= udg_MAX_MEGA_LVL) then

                            BlzFrameSetVisible(StatsExp[i], false)
                        else
                            BlzFrameSetVisible(StatsExp[i], true)
                            BlzFrameSetText(StatsExp[i], "|cff7fb0b0" .. (GetHeroXP(u) - exps[l-1]) .."|r")
                            BlzFrameSetText(StatsMaxExp[i], "|cff7fb0b0" .. reqExps[l] .."|r")
                        end

                        BlzFrameSetText(StatsDigimonLevel[i], "|cffFFCC00" .. l .. "|r")
                    else
                        name = GetObjectName(GetUnitTypeId(u))
                        BlzFrameSetVisible(StatsHeroIcon[i], false)
                        BlzFrameSetVisible(StatsStaminaLabel[i], false)
                        BlzFrameSetVisible(StatsStamina[i], false)
                        BlzFrameSetVisible(StatsDexterityLabel[i], false)
                        BlzFrameSetVisible(StatsDexterity[i], false)
                        BlzFrameSetVisible(StatsWisdomLabel[i], false)
                        BlzFrameSetVisible(StatsWisdom[i], false)
                        BlzFrameSetVisible(StatsExp[i], false)
                        BlzFrameSetVisible(StatsDigimonLevel[i], false)
                    end
                    BlzFrameSetText(StatsName[i], "|cffFFCC00" .. name .. "|r")

                    BlzFrameSetTexture(StatsDigimonIcon[i], BlzGetAbilityIcon(GetUnitTypeId(u)), 0, true)

                    local base = BlzGetUnitWeaponIntegerField(u, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
                    if base == 0 then
                        BlzFrameSetTexture(StatsDamageIcon[i], "war3mapImported\\EmptyBTN.blp", 0, true)
                        BlzFrameSetText(StatsDamage[i], "")
                    else
                        local typ = BlzGetUnitWeaponIntegerField(u, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0)
                        local root
                        if typ == udg_WaterAsInt then
                            root = WATER_ICON
                        elseif typ == udg_MachineAsInt then
                            root = MACHINE_ICON
                        elseif typ == udg_BeastAsInt then
                            root = BEAST_ICON
                        elseif typ == udg_FireAsInt then
                            root = FIRE_ICON
                        elseif typ == udg_NatureAsInt then
                            root = NATURE_ICON
                        elseif typ == udg_AirAsInt then
                            root = AIR_ICON
                        elseif typ == udg_DarkAsInt then
                            root = DARK_ICON
                        elseif typ == udg_HolyAsInt then
                            root = HOLY_ICON
                        else
                            root = "war3mapImported\\EmptyBTN.blp"
                        end
                        BlzFrameSetTexture(StatsDamageIcon[i], root, 0, true)

                        BlzFrameSetText(StatsDamage[i], tostring(math.floor(GetAvarageAttack(u))))
                    end

                    local typ = armorEquiv[BlzGetUnitIntegerField(u, UNIT_IF_DEFENSE_TYPE)]
                    local root
                    if typ == udg_WaterAsInt then
                        root = WATER_ICON
                    elseif typ == udg_MachineAsInt then
                        root = MACHINE_ICON
                    elseif typ == udg_BeastAsInt then
                        root = BEAST_ICON
                    elseif typ == udg_FireAsInt then
                        root = FIRE_ICON
                    elseif typ == udg_NatureAsInt then
                        root = NATURE_ICON
                    elseif typ == udg_AirAsInt then
                        root = AIR_ICON
                    elseif typ == udg_DarkAsInt then
                        root = DARK_ICON
                    elseif typ == udg_HolyAsInt then
                        root = HOLY_ICON
                    else
                        root = "war3mapImported\\EmptyBTN.blp"
                    end
                    BlzFrameSetTexture(StatsArmorIcon[i], root, 0, true)


                    if not BlzIsUnitInvulnerable(u) then
                        BlzFrameSetText(StatsArmor[i], tostring(math.floor(BlzGetUnitArmor(u))))
                        BlzFrameSetVisible(StatsArmor[i], true)
                        local col = LerpColors(red, GetUnitHPRatio(u), green)
                        BlzFrameSetText(StatsLife[i], "|c" .. col .. math.floor(GetUnitState(u, UNIT_STATE_LIFE)) .. "|r")
                        BlzFrameSetText(StatsLifeSlash[i], "|c" .. col .. "/" .. "|r")
                        BlzFrameSetText(StatsMaxLife[i], "|c" .. col .. math.floor(GetUnitState(u, UNIT_STATE_MAX_LIFE)) .. "|r")
                        BlzFrameSetVisible(StatsLife[i], true)
                    else
                        BlzFrameSetVisible(StatsArmor[i], false)
                        BlzFrameSetVisible(StatsLife[i], false)
                    end

                    if GetUnitState(u, UNIT_STATE_MAX_MANA) > 0 then
                        BlzFrameSetText(StatsMana[i], "|cff007fff" .. math.floor(GetUnitState(u, UNIT_STATE_MANA)) .. "|r")
                        BlzFrameSetText(StatsMaxMana[i], "|cff007fff" .. math.floor(GetUnitState(u, UNIT_STATE_MAX_MANA)) .. "|r")
                        BlzFrameSetVisible(StatsMana[i], true)
                    else
                        BlzFrameSetVisible(StatsMana[i], false)
                    end

                    for j = 0, 5 do
                        local m = UnitItemInSlot(u, j)
                        if m then
                            BlzFrameSetEnable(StatsItemT[i][j], true)
                            BlzFrameSetTexture(BackdropStatsItemT[i][j], BlzGetAbilityIcon(GetItemTypeId(m)), 0, true)
                            local desc = BlzGetItemDescription(m)
                            local _, final = desc:find(GetLocalizedString("STATS_DESC_STRIP"))
                            if final then
                                desc = desc:sub(final+1)
                            end
                            BlzFrameSetText(StatsItemTooltipText[i][j], GetItemName(m) .. "\n" .. desc)
                            BlzFrameSetSize(StatsItemTooltipText[i][j], 0.15, 0)
                        else
                            BlzFrameSetEnable(StatsItemT[i][j], false)
                            BlzFrameSetTexture(BackdropStatsItemT[i][j], icons[j], 0, true)
                            BlzFrameSetText(StatsItemTooltipText[i][j], names[j])
                            BlzFrameSetSize(StatsItemTooltipText[i][j], 0, 0.01)
                        end
                        BlzFrameClearAllPoints(StatsItemTooltip[i][j])
                        BlzFrameSetPoint(StatsItemTooltip[i][j], FRAMEPOINT_TOPLEFT, StatsItemTooltipText[i][j], FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
                        BlzFrameSetPoint(StatsItemTooltip[i][j], FRAMEPOINT_BOTTOMRIGHT, StatsItemTooltipText[i][j], FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)
                    end
                end
            else
                if (changeVisible) and BlzFrameIsVisible(StatsBackdrop[i]) then
                    BlzFrameSetVisible(StatsBackdrop[i], false)
                end
            end
        end

        if changeVisible then
            changeVisible = false
            BlzFrameSetVisible(StatsItemDrop, false)
        end

        for i = 0, 2 do
            local d = list[i+1]
            if d then
                local j = 0
                local index = 0
                while j <= 7 do
                    local abil = BlzGetUnitAbilityByIndex(d.root, index)
                    if not abil then
                        BlzFrameSetVisible(HeroBuffs[i][j], false)
                        j = j + 1
                    else
                        local id = BlzGetAbilityId(abil)
                        if id // 0x1000000 == 66 and buffIcons[id] ~= "" then -- The first character of the four-char id is 'B'
                            BlzFrameSetVisible(HeroBuffs[i][j], true)--BlzFrameIsVisible(HeroButtons[i]))
                            BlzFrameSetTexture(HeroBuffs[i][j], buffIcons[id], 0, true)
                            j = j + 1
                        end
                    end
                    index = index + 1
                end
                BlzFrameSetVisible(SelectedHero[i], true)--BlzFrameIsVisible(HeroButtons[i]) and u ~= d.root and IsUnitSelected(d.root, LocalPlayer))
            else
                for j = 0, 7 do
                    BlzFrameSetVisible(HeroBuffs[i][j], false)
                end
                BlzFrameSetVisible(SelectedHero[i], false)
            end
        end

        BlzFrameSetVisible(OtherStatsBackdrop, false)
        BlzFrameSetVisible(SelectedDigimonIcon, false)
        BlzFrameSetVisible(SelectedDigimonName, false)

        local selected = GetMainSelectedUnitEx()
        if not selected
            or not UnitAlive(selected)
            or IsCommandButtonIgnore(GetUnitTypeId(selected))
            or IsUnitHidden(selected) then

            return
        end

        BlzFrameSetTexture(SelectedDigimonIcon, BlzGetAbilityIcon(GetUnitTypeId(selected)), 0, true)
        BlzFrameSetVisible(SelectedDigimonIcon, true)

        BlzFrameSetText(SelectedDigimonName, "|cffFFCC00" .. (IsUnitType(selected, UNIT_TYPE_HERO) and GetHeroProperName(selected) or GetUnitName(selected)) .. "|r")
        BlzFrameSetVisible(SelectedDigimonName, true)

        local d = Digimon.getInstance(selected)
        if not d then
            return
        end

        if GetOwningPlayer(selected) == LocalPlayer
            or GetOwningPlayer(selected) == Digimon.CITY
            or GetOwningPlayer(selected) == Digimon.PASSIVE then

            return
        end

        local text = ""

        text = text .. GetLocalizedString("STATS_ENEMY_HP") .. " " .. math.floor(GetUnitState(selected, UNIT_STATE_LIFE)) .. " \\ " .. math.floor(GetUnitState(selected, UNIT_STATE_MAX_LIFE)) .. "\n"
        text = text .. GetLocalizedString("STATS_ENEMY_MP") .. " " .. math.floor(GetUnitState(selected, UNIT_STATE_MANA)) .. " \\ " .. math.floor(GetUnitState(selected, UNIT_STATE_MAX_MANA)) .. "\n"


        local base = GetHeroStr(selected, false)
        local bonus = GetHeroStr(selected, true) - base
        text = text .. GetLocalizedString("STATS_ENEMY_STA") .. " " .. base .. ((bonus > 0) and (" (+".. bonus .. ")") or "") .. "\n"

        base = GetHeroAgi(selected, false)
        bonus = GetHeroAgi(selected, true) - base
        text = text .. GetLocalizedString("STATS_ENEMY_DEX") .. " " .. base .. ((bonus > 0) and (" (+".. bonus .. ")") or "") .. "\n"

        base = GetHeroInt(selected, false)
        bonus = GetHeroInt(selected, true) - base
        text = text .. GetLocalizedString("STATS_ENEMY_WIS") .. " " .. base .. ((bonus > 0) and (" (+".. bonus .. ")") or "")

        BlzFrameSetText(OtherStats, text)

        base = BlzGetUnitWeaponIntegerField(selected, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
        if base == 0 then
            BlzFrameSetTexture(OtherStatsDmgIcon, "war3mapImported\\EmptyBTN.blp", 0, true)
            BlzFrameSetText(OtherStatsDmgAmount, "")
        else
            local typ = BlzGetUnitWeaponIntegerField(selected, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0)
            local root
            if typ == udg_WaterAsInt then
                root = WATER_ICON
            elseif typ == udg_MachineAsInt then
                root = MACHINE_ICON
            elseif typ == udg_BeastAsInt then
                root = BEAST_ICON
            elseif typ == udg_FireAsInt then
                root = FIRE_ICON
            elseif typ == udg_NatureAsInt then
                root = NATURE_ICON
            elseif typ == udg_AirAsInt then
                root = AIR_ICON
            elseif typ == udg_DarkAsInt then
                root = DARK_ICON
            elseif typ == udg_HolyAsInt then
                root = HOLY_ICON
            else
                root = "war3mapImported\\EmptyBTN.blp"
            end
            BlzFrameSetTexture(OtherStatsDmgIcon, root, 0, true)

            BlzFrameSetText(OtherStatsDmgAmount, tostring(math.floor(GetAvarageAttack(selected))))
        end

        local typ = armorEquiv[BlzGetUnitIntegerField(selected, UNIT_IF_DEFENSE_TYPE)]
        local root
        if typ == udg_WaterAsInt then
            root = WATER_ICON
        elseif typ == udg_MachineAsInt then
            root = MACHINE_ICON
        elseif typ == udg_BeastAsInt then
            root = BEAST_ICON
        elseif typ == udg_FireAsInt then
            root = FIRE_ICON
        elseif typ == udg_NatureAsInt then
            root = NATURE_ICON
        elseif typ == udg_AirAsInt then
            root = AIR_ICON
        elseif typ == udg_DarkAsInt then
            root = DARK_ICON
        elseif typ == udg_HolyAsInt then
            root = HOLY_ICON
        else
            root = "war3mapImported\\EmptyBTN.blp"
        end
        BlzFrameSetTexture(OtherStatsDefIcon, root, 0, true)

        if not BlzIsUnitInvulnerable(selected) then
            BlzFrameSetText(OtherStatsDefAmount, tostring(math.floor(BlzGetUnitArmor(selected))))
        else
            BlzFrameSetText(OtherStatsDefAmount, "")
        end

        BlzFrameSetVisible(OtherStatsBackdrop, true)
    end)
    do
        local t = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            TriggerRegisterPlayerSelectionEventBJ(t, GetEnumPlayer(), false)
        end)
        TriggerAddAction(t, function ()
            if GetLocalPlayer() == GetTriggerPlayer() then
                BlzFrameSetVisible(OtherStatsBackdrop, false)
            end
        end)
    end
    function BlzFourCC2S(value)
        local result = ""
        for _=1,4 do
            result = string.char(ModuloInteger(value, 256)) .. result
            value = value // 256
        end
        return result
    end
    OnBankUpdated(function (p, _)
        if p == LocalPlayer and BlzFrameIsVisible(StatsBackdrop[0])--[[ and not seeOnly[p] ]] then
            changeVisible = true
        end
    end)

    local function StatsItemFunc(p, i, j)
        dropItemI[p] = i
        dropItemJ[p] = j
        if p == LocalPlayer then
            BlzFrameSetParent(StatsItemDrop, StatsInventoryBackdrop[i])
            BlzFrameSetPoint(StatsItemDrop, FRAMEPOINT_TOPLEFT, StatsItemT[i][j], FRAMEPOINT_TOPLEFT, 0.014500, -0.010000)
            BlzFrameSetPoint(StatsItemDrop, FRAMEPOINT_BOTTOMRIGHT, StatsItemT[i][j], FRAMEPOINT_BOTTOMRIGHT, 0.029500, -0.0050000)
            BlzFrameSetVisible(StatsItemDrop, true)
        end
    end

    local function StatsItemDropFunc(p)
        local d = --[[seeOnly[p] == nil and]] GetUsedDigimons(p)[dropItemI[p]+1] --or Digimon.getInstance(seeOnly[p])
        UnitDropItemPoint(d.root, UnitItemInSlot(d.root, dropItemJ[p]), d:getPos())
        if p == LocalPlayer then
            BlzFrameSetVisible(StatsItemDrop, false)
        end
    end

    FrameLoaderAdd(function ()
        StatsButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(StatsButton, 1)
        BlzFrameSetVisible(StatsButton, false)
        AddFrameToMenu(StatsButton)
        SetFrameHotkey(StatsButton, udg_STATS_HOTKEY)
        AddDefaultTooltip(StatsButton, GetLocalizedString("STATS"), GetLocalizedString("STATS_TOOLTIP"))

        BackdropStatsButton = BlzCreateFrameByType("BACKDROP", "BackdropStatsButton", StatsButton, "", 0)
        BlzFrameSetAllPoints(BackdropStatsButton, StatsButton)
        BlzFrameSetTexture(BackdropStatsButton, udg_STATS_BUTTON, 0, true)
        OnClickEvent(StatsButton, StatsButtonFunc)

        for i = 0, 2 do
            StatsBackdrop[i] = BlzCreateFrameByType("BACKDROP", "StatsBackdrop[" .. i .. "]", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.4175, 0.552500 - 0.105*i)
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.452500 - 0.105*i)
            BlzFrameSetTexture(StatsBackdrop[i], "war3mapImported\\EmptyBTN.blp", 0, true)
            BlzFrameSetVisible(StatsBackdrop[i], false)
            AddFrameToMenu(StatsBackdrop[i])

            local backdrop = BlzCreateFrame("EscMenuBackdrop", StatsBackdrop[i], 0, 0)
            BlzFrameSetPoint(backdrop, FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, -0.0100, 0.0100)
            BlzFrameSetPoint(backdrop, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0100, -0.0100)
            BlzFrameSetLevel(backdrop, -1)

            StatsName[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsName[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0000, -0.0075000)
            BlzFrameSetPoint(StatsName[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.28750, 0.077500)
            BlzFrameSetText(StatsName[i], "|cffFFCC00Rookie Digimon Agumon|r")
            BlzFrameSetEnable(StatsName[i], false)
            BlzFrameSetTextAlignment(StatsName[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

            StatsDamageLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDamageLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.15250, -0.0050000)
            BlzFrameSetPoint(StatsDamageLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.16500, 0.080000)
            BlzFrameSetText(StatsDamageLabel[i], GetLocalizedString("STATS_DAMAGE_LABEL"))
            BlzFrameSetEnable(StatsDamageLabel[i], false)
            BlzFrameSetTextAlignment(StatsDamageLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDamageIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsDamageIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.15250, -0.020000)
            BlzFrameSetPoint(StatsDamageIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.18500, 0.050000)
            BlzFrameSetTexture(StatsDamageIcon[i], "", 0, true)

            StatsArmorLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsArmorLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.15250, -0.050000)
            BlzFrameSetPoint(StatsArmorLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.16500, 0.035000)
            BlzFrameSetText(StatsArmorLabel[i], GetLocalizedString("STATS_ARMOR_LABEL"))
            BlzFrameSetEnable(StatsArmorLabel[i], false)
            BlzFrameSetTextAlignment(StatsArmorLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsArmorIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsArmorIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.15250, -0.065000)
            BlzFrameSetPoint(StatsArmorIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.18500, 0.0050000)
            BlzFrameSetTexture(StatsArmorIcon[i], "", 0, true)

            StatsDamage[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDamage[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.18250, -0.020000)
            BlzFrameSetPoint(StatsDamage[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.15250, 0.050000)
            BlzFrameSetText(StatsDamage[i], "|cffffffff9999|r")
            BlzFrameSetEnable(StatsDamage[i], false)
            BlzFrameSetTextAlignment(StatsDamage[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsArmor[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsArmor[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.18250, -0.065000)
            BlzFrameSetPoint(StatsArmor[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.15250, 0.0050000)
            BlzFrameSetText(StatsArmor[i], "|cffffffff150|r")
            BlzFrameSetEnable(StatsArmor[i], false)
            BlzFrameSetTextAlignment(StatsArmor[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsHeroIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsHeroIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.21500, -0.032500)
            BlzFrameSetPoint(StatsHeroIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.11250, 0.027500)
            BlzFrameSetTexture(StatsHeroIcon[i], HERO_ICON, 0, true)

            StatsStaminaLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsStaminaLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.25500, -0.0050000)
            BlzFrameSetPoint(StatsStaminaLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.057500, 0.080000)
            BlzFrameSetText(StatsStaminaLabel[i], GetLocalizedString("STATS_STAMINA_LABEL"))
            BlzFrameSetEnable(StatsStaminaLabel[i], false)
            BlzFrameSetScale(StatsStaminaLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsStaminaLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsStamina[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsStamina[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.26000, -0.020000)
            BlzFrameSetPoint(StatsStamina[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.057500, 0.065000)
            BlzFrameSetText(StatsStamina[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsStamina[i], false)
            BlzFrameSetTextAlignment(StatsStamina[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDexterityLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDexterityLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.25500, -0.035000)
            BlzFrameSetPoint(StatsDexterityLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.057500, 0.050000)
            BlzFrameSetText(StatsDexterityLabel[i], GetLocalizedString("STATS_DEXTERITY_LABEL"))
            BlzFrameSetEnable(StatsDexterityLabel[i], false)
            BlzFrameSetTextAlignment(StatsDexterityLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDexterity[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDexterity[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.26000, -0.050000)
            BlzFrameSetPoint(StatsDexterity[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.057500, 0.035000)
            BlzFrameSetText(StatsDexterity[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsDexterity[i], false)
            BlzFrameSetTextAlignment(StatsDexterity[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsWisdomLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsWisdomLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.25500, -0.065000)
            BlzFrameSetPoint(StatsWisdomLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.057500, 0.020000)
            BlzFrameSetText(StatsWisdomLabel[i], GetLocalizedString("STATS_WISDOM_LABEL"))
            BlzFrameSetEnable(StatsWisdomLabel[i], false)
            BlzFrameSetScale(StatsWisdomLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsWisdomLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsWisdom[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsWisdom[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.26000, -0.080000)
            BlzFrameSetPoint(StatsWisdom[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.057500, 0.0050000)
            BlzFrameSetText(StatsWisdom[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsWisdom[i], false)
            BlzFrameSetScale(StatsWisdom[i], 1.00)
            BlzFrameSetTextAlignment(StatsWisdom[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsLife[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsLife[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0000, -0.067500)
            BlzFrameSetPoint(StatsLife[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.33250, 0.017500)
            BlzFrameSetText(StatsLife[i], "|cff00ff001000|r")
            BlzFrameSetEnable(StatsLife[i], false)
            BlzFrameSetTextAlignment(StatsLife[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)

            StatsMana[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsMana[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0000, -0.082500)
            BlzFrameSetPoint(StatsMana[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.33250, 0.0025000)
            BlzFrameSetText(StatsMana[i], "|cff007fff1000|r")
            BlzFrameSetEnable(StatsMana[i], false)
            BlzFrameSetTextAlignment(StatsMana[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)

            StatsExp[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsExp[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0000, -0.052500)
            BlzFrameSetPoint(StatsExp[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.33250, 0.032500)
            BlzFrameSetText(StatsExp[i], "|cff7fb0b01000|r")
            BlzFrameSetEnable(StatsExp[i], false)
            BlzFrameSetTextAlignment(StatsExp[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_RIGHT)

            StatsExpSlash[i] = BlzCreateFrameByType("TEXT", "name", StatsExp[i], "", 0)
            BlzFrameSetPoint(StatsExpSlash[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.035000, -0.052500)
            BlzFrameSetPoint(StatsExpSlash[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.32250, 0.032500)
            BlzFrameSetText(StatsExpSlash[i], "|cff7fb0b0/|r")
            BlzFrameSetEnable(StatsExpSlash[i], false)
            BlzFrameSetTextAlignment(StatsExpSlash[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

            StatsLifeSlash[i] = BlzCreateFrameByType("TEXT", "name", StatsLife[i], "", 0)
            BlzFrameSetPoint(StatsLifeSlash[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.035000, -0.067500)
            BlzFrameSetPoint(StatsLifeSlash[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.32250, 0.017500)
            BlzFrameSetText(StatsLifeSlash[i], "|cff00ff00/|r")
            BlzFrameSetEnable(StatsLifeSlash[i], false)
            BlzFrameSetTextAlignment(StatsLifeSlash[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

            StatsManaSlash[i] = BlzCreateFrameByType("TEXT", "name", StatsMana[i], "", 0)
            BlzFrameSetPoint(StatsManaSlash[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.035000, -0.082500)
            BlzFrameSetPoint(StatsManaSlash[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.32250, 0.0025000)
            BlzFrameSetText(StatsManaSlash[i], "|cff007fff/|r")
            BlzFrameSetEnable(StatsManaSlash[i], false)
            BlzFrameSetTextAlignment(StatsManaSlash[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

            StatsMaxExp[i] = BlzCreateFrameByType("TEXT", "name", StatsExp[i], "", 0)
            BlzFrameSetPoint(StatsMaxExp[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.045000, -0.052500)
            BlzFrameSetPoint(StatsMaxExp[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.28750, 0.032500)
            BlzFrameSetText(StatsMaxExp[i], "|cff7fb0b01000|r")
            BlzFrameSetEnable(StatsMaxExp[i], false)
            BlzFrameSetTextAlignment(StatsMaxExp[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsMaxLife[i] = BlzCreateFrameByType("TEXT", "name", StatsLife[i], "", 0)
            BlzFrameSetPoint(StatsMaxLife[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.045000, -0.067500)
            BlzFrameSetPoint(StatsMaxLife[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.28750, 0.017500)
            BlzFrameSetText(StatsMaxLife[i], "|cff00ff001000|r")
            BlzFrameSetEnable(StatsMaxLife[i], false)
            BlzFrameSetTextAlignment(StatsMaxLife[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsMaxMana[i] = BlzCreateFrameByType("TEXT", "name", StatsMana[i], "", 0)
            BlzFrameSetPoint(StatsMaxMana[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.045000, -0.082500)
            BlzFrameSetPoint(StatsMaxMana[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.28750, 0.0025000)
            BlzFrameSetText(StatsMaxMana[i], "|cff007fff1000|r")
            BlzFrameSetEnable(StatsMaxMana[i], false)
            BlzFrameSetTextAlignment(StatsMaxMana[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDigimonIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsDigimonIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.025000, -0.022500)
            BlzFrameSetPoint(StatsDigimonIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.31250, 0.047500)
            BlzFrameSetTexture(StatsDigimonIcon[i], "CustomFrame.png", 0, true)

            StatsDigimonLevelBackdrop[i] = BlzCreateFrame("OptionsPopupMenuBackdropTemplate", StatsDigimonIcon[i], 0, 0)
            BlzFrameSetPoint(StatsDigimonLevelBackdrop[i], FRAMEPOINT_TOPLEFT, StatsDigimonIcon[i], FRAMEPOINT_TOPLEFT, 0.00050000, -0.00050000)
            BlzFrameSetPoint(StatsDigimonLevelBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, StatsDigimonIcon[i], FRAMEPOINT_BOTTOMRIGHT, -0.0095000, 0.019500)

            StatsDigimonLevel[i] = BlzCreateFrameByType("TEXT", "name", StatsDigimonIcon[i], "", 0)
            BlzFrameSetAllPoints(StatsDigimonLevel[i], StatsDigimonLevelBackdrop[i])
            BlzFrameSetText(StatsDigimonLevel[i], "|cffFFCC0099\n|r")
            BlzFrameSetEnable(StatsDigimonLevel[i], false)
            BlzFrameSetScale(StatsDigimonLevel[i], 1.00)
            BlzFrameSetTextAlignment(StatsDigimonLevel[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            StatsCriticalLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsCriticalLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.31250, -0.0055000)
            BlzFrameSetPoint(StatsCriticalLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.085000)
            BlzFrameSetText(StatsCriticalLabel[i], GetLocalizedString("STATS_CRITICAL_LABEL"))
            BlzFrameSetEnable(StatsCriticalLabel[i], false)
            BlzFrameSetScale(StatsCriticalLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsCriticalLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsBlockLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsBlockLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.31250, -0.051500)
            BlzFrameSetPoint(StatsBlockLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.039000)
            BlzFrameSetText(StatsBlockLabel[i], GetLocalizedString("STATS_BLOCK_LABEL"))
            BlzFrameSetEnable(StatsBlockLabel[i], false)
            BlzFrameSetScale(StatsBlockLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsBlockLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsEvasionLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsEvasionLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.31250, -0.074500)
            BlzFrameSetPoint(StatsEvasionLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.016000)
            BlzFrameSetText(StatsEvasionLabel[i], GetLocalizedString("STATS_EVASION_LABEL"))
            BlzFrameSetEnable(StatsEvasionLabel[i], false)
            BlzFrameSetScale(StatsEvasionLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsEvasionLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsImpactLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsImpactLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.31250, -0.028500)
            BlzFrameSetPoint(StatsImpactLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.062000)
            BlzFrameSetText(StatsImpactLabel[i], GetLocalizedString("STATS_IMPACT_LABEL"))
            BlzFrameSetEnable(StatsImpactLabel[i], false)
            BlzFrameSetScale(StatsImpactLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsImpactLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsCritical[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsCritical[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.31750, -0.017000)
            BlzFrameSetPoint(StatsCritical[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.073500)
            BlzFrameSetText(StatsCritical[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsCritical[i], false)
            BlzFrameSetScale(StatsCritical[i], 1.00)
            BlzFrameSetTextAlignment(StatsCritical[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsBlock[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsBlock[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.31750, -0.063000)
            BlzFrameSetPoint(StatsBlock[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.027500)
            BlzFrameSetText(StatsBlock[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsBlock[i], false)
            BlzFrameSetScale(StatsBlock[i], 1.00)
            BlzFrameSetTextAlignment(StatsBlock[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsEvasion[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsEvasion[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.31750, -0.086000)
            BlzFrameSetPoint(StatsEvasion[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0045000)
            BlzFrameSetText(StatsEvasion[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsEvasion[i], false)
            BlzFrameSetScale(StatsEvasion[i], 1.00)
            BlzFrameSetTextAlignment(StatsEvasion[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsImpact[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsImpact[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.31750, -0.040000)
            BlzFrameSetPoint(StatsImpact[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.050500)
            BlzFrameSetText(StatsImpact[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsImpact[i], false)
            BlzFrameSetScale(StatsImpact[i], 1.00)
            BlzFrameSetTextAlignment(StatsImpact[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsInventoryBackdrop[i] = BlzCreateFrame("CheckListBox", StatsBackdrop[i], 0, 0)
            BlzFrameSetPoint(StatsInventoryBackdrop[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.080000, 0.0000)
            BlzFrameSetPoint(StatsInventoryBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.21750, 0.0000)

            StatsItemT[i] = {}
            BackdropStatsItemT[i] = {}
            StatsItemTooltip[i] = {}
            StatsItemTooltipText[i] = {}
            local x1, x2, y1, y2 = {}, {}, {}, {}
            for j = 0, 1 do
                for k = 0, 2 do
                    local index = j+k*2
                    x1[index] = 0.0050000 + 0.03*j
                    y1[index] = -0.0050000 - 0.03*k
                    x2[index] = -0.035000 + 0.03*j
                    y2[index] = 0.065000 - 0.03*k
                end
            end
            for j = 0, 5 do
                StatsItemT[i][j] = BlzCreateFrame("IconButtonTemplate", StatsInventoryBackdrop[i], 0, 0)
                BlzFrameSetPoint(StatsItemT[i][j], FRAMEPOINT_TOPLEFT, StatsInventoryBackdrop[i], FRAMEPOINT_TOPLEFT, x1[j], y1[j])
                BlzFrameSetPoint(StatsItemT[i][j], FRAMEPOINT_BOTTOMRIGHT, StatsInventoryBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, x2[j], y2[j])

                BackdropStatsItemT[i][j] = BlzCreateFrameByType("BACKDROP", "BackdropStatsItemT[" .. i .. "][" .. j .. "]", StatsItemT[i][j], "", 0)
                BlzFrameSetAllPoints(BackdropStatsItemT[i][j], StatsItemT[i][j])
                BlzFrameSetTexture(BackdropStatsItemT[i][j], icons[j], 0, true)
                OnClickEvent(StatsItemT[i][j], function (p)
                    StatsItemFunc(p, i, j)
                end)

                StatsItemTooltip[i][j] = BlzCreateFrame("QuestButtonBaseTemplate", StatsItemT[i][j], 0, 0)

                StatsItemTooltipText[i][j] = BlzCreateFrameByType("TEXT", "name", StatsItemTooltip[i][j], "", 0)
                BlzFrameSetPoint(StatsItemTooltipText[i][j], FRAMEPOINT_TOPRIGHT, StatsItemT[i][j], FRAMEPOINT_TOPRIGHT, -0.025000, -0.025000)
                BlzFrameSetText(StatsItemTooltipText[i][j], names[j])
                BlzFrameSetEnable(StatsItemTooltipText[i][j], false)
                BlzFrameSetScale(StatsItemTooltipText[i][j], 1.00)
                BlzFrameSetTextAlignment(StatsItemTooltipText[i][j], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

                BlzFrameSetPoint(StatsItemTooltip[i][j], FRAMEPOINT_TOPLEFT, StatsItemTooltipText[i][j], FRAMEPOINT_TOPLEFT, -0.0150000, 0.0150000)
                BlzFrameSetPoint(StatsItemTooltip[i][j], FRAMEPOINT_BOTTOMRIGHT, StatsItemTooltipText[i][j], FRAMEPOINT_BOTTOMRIGHT, 0.0150000, -0.0150000)
                BlzFrameSetTooltip(StatsItemT[i][j], StatsItemTooltip[i][j])
            end

            StatsItemDrop = BlzCreateFrame("ScriptDialogButton", StatsInventoryBackdrop[0], 0, 0)
            BlzFrameSetPoint(StatsItemDrop, FRAMEPOINT_TOPLEFT, StatsItemT[0][0], FRAMEPOINT_TOPLEFT, 0.014500, -0.010000)
            BlzFrameSetPoint(StatsItemDrop, FRAMEPOINT_BOTTOMRIGHT, StatsItemT[0][0], FRAMEPOINT_BOTTOMRIGHT, 0.029500, -0.0050000)
            BlzFrameSetText(StatsItemDrop, GetLocalizedString("STATS_ITEM_DROP"))
            BlzFrameSetLevel(StatsItemDrop, 100)
            OnClickEvent(StatsItemDrop, StatsItemDropFunc)
            BlzFrameSetVisible(StatsItemDrop, false)
        end

        for i = 0, 2 do
            HeroButtons[i] = BlzGetOriginFrame(ORIGIN_FRAME_HERO_BUTTON, i)

            HeroBuffs[i] = {}
            for j = 0, 7 do
                --HeroBuffs[i][j] = BlzCreateFrameByType("BACKDROP", "HeroBuffs[" .. i .. "][" .. j .. "]", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 0)
                --BlzFrameSetPoint(HeroBuffs[i][j], FRAMEPOINT_BOTTOMLEFT, HeroButtons[i], FRAMEPOINT_BOTTOMRIGHT, 0.01 + j*0.0125, 0)
                HeroBuffs[i][j] = BlzCreateFrameByType("BACKDROP", "HeroBuffs[" .. i .. "][" .. j .. "]", StatsBackdrop[i], "", 0)
                BlzFrameSetPoint(HeroBuffs[i][j], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, -0.017500, 0.0000 - j*0.0125)
                BlzFrameSetPoint(HeroBuffs[i][j], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.37250, 0.087500 - j*0.0125)
                BlzFrameSetVisible(HeroBuffs[i][j], false)
            end

            SelectedHero[i] = BlzCreateFrameByType("SPRITE", "SelectedHero[" .. i .. "]", CommandButtonBackDrop--[[BlzGetFrameByName("ConsoleUIBackdrop", 0)]], "", 0)
            --BlzFrameSetModel(SelectedHero[i], "war3mapImported\\cyber_call_sprite.mdx", 0)
            BlzFrameSetModel(SelectedHero[i], "war3mapImported\\crystallid_sprite.mdx", 0)
            BlzFrameClearAllPoints(SelectedHero[i])
            BlzFrameSetPoint(SelectedHero[i], FRAMEPOINT_BOTTOMLEFT, HeroButtons[i], FRAMEPOINT_BOTTOMLEFT, -0.005, -0.005)
            BlzFrameSetSize(SelectedHero[i], 0.00001, 0.00001)
            BlzFrameSetScale(SelectedHero[i], 0.75)
            BlzFrameSetLevel(SelectedHero[i], 10)
            BlzFrameSetVisible(SelectedHero[i], false)
        end

        --[[FocusedUnit = BlzCreateFrameByType("SPRITE", "FocusedUnit", HeroButtons[0], "", 0)
        BlzFrameSetModel(FocusedUnit, "war3mapImported\\crystallid_sprite.mdx", 0)
        BlzFrameClearAllPoints(FocusedUnit)
        BlzFrameSetPoint(FocusedUnit, FRAMEPOINT_BOTTOMLEFT, HeroButtons[0], FRAMEPOINT_BOTTOMLEFT, -0.005, -0.005)
        BlzFrameSetSize(FocusedUnit, 0.00001, 0.00001)
        BlzFrameSetScale(FocusedUnit, 0.75)
        BlzFrameSetLevel(FocusedUnit, 5)
        BlzFrameSetVisible(FocusedUnit, false)]]

        OtherStatsBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", CommandButtonBackDrop, "", 1)
        BlzFrameSetTexture(OtherStatsDmgIcon, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(OtherStatsBackdrop, false)

        OtherStats = BlzCreateFrameByType("TEXT", "name", OtherStatsBackdrop, "", 0)
        BlzFrameSetScale(OtherStats, 1.43)
        BlzFrameSetPoint(OtherStats, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.035000)
        BlzFrameSetPoint(OtherStats, FRAMEPOINT_BOTTOMRIGHT, CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.060000)
        BlzFrameSetText(OtherStats, "|cffFFCC00HP: 999/999\nMP: 999/999\nSTA: 999 (+999)\nDEX: 999 (+999)\nWIS: 999 (+999)|r")
        BlzFrameSetTextAlignment(OtherStats, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        SelectedDigimonIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", CommandButtonBackDrop, "", 1)
        BlzFrameSetPoint(SelectedDigimonIcon, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.015000)
        BlzFrameSetPoint(SelectedDigimonIcon, FRAMEPOINT_BOTTOMRIGHT, CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, -0.19000, 0.17000)
        BlzFrameSetTexture(SelectedDigimonIcon, "", 0, true)
        BlzFrameSetVisible(SelectedDigimonIcon, false)

        SelectedDigimonName = BlzCreateFrameByType("TEXT", "name", CommandButtonBackDrop, "", 0)
        BlzFrameSetScale(SelectedDigimonName, 1.29)
        BlzFrameSetPoint(SelectedDigimonName, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.040000, -0.015000)
        BlzFrameSetPoint(SelectedDigimonName, FRAMEPOINT_BOTTOMRIGHT, CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.17000)
        BlzFrameSetText(SelectedDigimonName, "|cffFFCC00Agumon|r")
        BlzFrameSetTextAlignment(SelectedDigimonName, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
        BlzFrameSetVisible(SelectedDigimonName, false)

        OtherStatsDmgIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", OtherStatsBackdrop, "", 1)
        BlzFrameSetPoint(OtherStatsDmgIcon, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.025000, -0.15000)
        BlzFrameSetPoint(OtherStatsDmgIcon, FRAMEPOINT_BOTTOMRIGHT, CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, -0.17500, 0.025000)
        BlzFrameSetTexture(OtherStatsDmgIcon, "CustomFrame.png", 0, true)

        OtherStatsDefIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", OtherStatsBackdrop, "", 1)
        BlzFrameSetPoint(OtherStatsDefIcon, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.12000, -0.15000)
        BlzFrameSetPoint(OtherStatsDefIcon, FRAMEPOINT_BOTTOMRIGHT, CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, -0.080000, 0.025000)
        BlzFrameSetTexture(OtherStatsDefIcon, "CustomFrame.png", 0, true)

        OtherStatsDmgLabel = BlzCreateFrameByType("TEXT", "name", OtherStatsBackdrop, "", 0)
        BlzFrameSetScale(OtherStatsDmgLabel, 1.43)
        BlzFrameSetPoint(OtherStatsDmgLabel, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.060000, -0.15000)
        BlzFrameSetPoint(OtherStatsDmgLabel, FRAMEPOINT_BOTTOMRIGHT, CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.040000)
        BlzFrameSetText(OtherStatsDmgLabel, GetLocalizedString("STATS_DAMAGE_LABEL"))
        BlzFrameSetTextAlignment(OtherStatsDmgLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        OtherStatsDefLabel = BlzCreateFrameByType("TEXT", "name", OtherStatsBackdrop, "", 0)
        BlzFrameSetScale(OtherStatsDefLabel, 1.43)
        BlzFrameSetPoint(OtherStatsDefLabel, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.15500, -0.15000)
        BlzFrameSetPoint(OtherStatsDefLabel, FRAMEPOINT_BOTTOMRIGHT, CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, -0.025000, 0.040000)
        BlzFrameSetText(OtherStatsDefLabel, GetLocalizedString("STATS_ARMOR_LABEL"))
        BlzFrameSetTextAlignment(OtherStatsDefLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        OtherStatsDefAmount = BlzCreateFrameByType("TEXT", "name", OtherStatsBackdrop, "", 0)
        BlzFrameSetScale(OtherStatsDefAmount, 1.43)
        BlzFrameSetPoint(OtherStatsDefAmount, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.15500, -0.16550)
        BlzFrameSetPoint(OtherStatsDefAmount, FRAMEPOINT_BOTTOMRIGHT, CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, -0.025000, 0.025000)
        BlzFrameSetText(OtherStatsDefAmount, "|cffffffff9999|r")
        BlzFrameSetTextAlignment(OtherStatsDefAmount, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        OtherStatsDmgAmount = BlzCreateFrameByType("TEXT", "name", OtherStatsBackdrop, "", 0)
        BlzFrameSetScale(OtherStatsDmgAmount, 1.43)
        BlzFrameSetPoint(OtherStatsDmgAmount, FRAMEPOINT_TOPLEFT, CommandButtonBackDrop, FRAMEPOINT_TOPLEFT, 0.060000, -0.16550)
        BlzFrameSetPoint(OtherStatsDmgAmount, FRAMEPOINT_BOTTOMRIGHT, CommandButtonBackDrop, FRAMEPOINT_BOTTOMRIGHT, -0.12000, 0.025000)
        BlzFrameSetText(OtherStatsDmgAmount, "|cffffffff9999|r")
        BlzFrameSetTextAlignment(OtherStatsDmgAmount, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
    end)

    OnChangeDimensions(function ()
        for i = 0, 2 do
            BlzFrameClearAllPoints(StatsBackdrop[i])
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.4175, 0.552500 - 0.105*i)
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.452500 - 0.105*i)
        end
    end)

    OnLeaderboard(function ()
        for i = 0, 2 do
            BlzFrameSetParent(StatsBackdrop[i], BlzGetFrameByName("Leaderboard", 0))
            BlzFrameSetParent(SelectedHero[i], BlzGetFrameByName("Leaderboard", 0))
        end
        --BlzFrameSetParent(FocusedUnit, BlzGetFrameByName("Leaderboard", 0))
    end)

    ---@param p player
    function ShowStats(p)
        if p == GetLocalPlayer() then
            BlzFrameSetVisible(StatsButton, true)
        end
    end

    udg_StatsBuffAdd = CreateTrigger()
    TriggerAddAction(udg_StatsBuffAdd, function ()
        buffIcons[udg_StatsBuff] = udg_StatsBuffIcon
        udg_StatsBuff = 0
        udg_StatsBuffIcon = ""
    end)

    local holyDamages = {}

    local oldBlzGetUnitWeaponIntegerField
    oldBlzGetUnitWeaponIntegerField = AddHook("BlzGetUnitWeaponIntegerField", function (u, field, index)
        if field == UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE and holyDamages[GetUnitTypeId(u)] then
            return udg_HolyAsInt
        end
        return oldBlzGetUnitWeaponIntegerField(u, field, index)
    end)

    local t = CreateTrigger()
    TriggerRegisterVariableEvent(t, "udg_PreDamageEvent", EQUAL, 1)
    TriggerAddAction(t, function ()
        if udg_IsDamageAttack and holyDamages[GetUnitTypeId(udg_DamageEventSource)] then
            udg_DamageEventAttackT = udg_HolyAsInt
        end
        -- Holy vs Fire
        if udg_DamageEventAttackT == udg_HolyAsInt and BlzGetUnitIntegerField(udg_DamageEventTarget, UNIT_IF_DEFENSE_TYPE) == 7 then
            udg_ByPass = true
            udg_DamageByPass = udg_DamageEventAmount
        end
    end)

    GlobalRemap("udg_SetHolyAttack", nil, function (value)
        holyDamages[value] = true
    end)
end)
Debug.endFile()