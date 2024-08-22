Debug.beginFile("Stats")
OnInit("Stats", function ()
    Require "Digimon"
    Require "FrameLoader"
    Require "Menu"
    Require "Timed"
    Require "Color"

    local WATER_ICON = "war3mapImported\\ATTWater.blp"
    local MACHINE_ICON = "war3mapImported\\ATTMetal.blp"
    local BEAST_ICON = "war3mapImported\\ATTBEast.blp"
    local FIRE_ICON = "war3mapImported\\ATTFlame.blp"
    local NATURE_ICON = "war3mapImported\\ATTNature.blp"
    local AIR_ICON = "war3mapImported\\ATTAir.blp"
    local DARK_ICON = "war3mapImported\\ATTShadow.blp"
    local HOLY_ICON = "war3mapImported\\ATTHoly.blp"
    local HERO_ICON = "war3mapImported\\ATTSystemMed.blp"

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
    local StatsDigimonIcon = {} ---@type framehandle[]
    local StatsCriticalLabel = {} ---@type framehandle[]
    local StatsBlockLabel = {} ---@type framehandle[]
    local StatsEvasionLabel = {} ---@type framehandle[]
    local StatsCritical = {} ---@type framehandle[]
    local StatsBlock = {} ---@type framehandle[]
    local StatsEvasion = {} ---@type framehandle[]
    local StatsInventoryBackdrop = {} ---@type framehandle[]
    local StatsItemT = {} ---@type framehandle[][]
    local BackdropStatsItemT = {} ---@type framehandle[][]
    local StatsItemDrop = nil ---@type framehandle

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

    local allVisible = false
    local changeVisible = false
    local seeOnly = {} ---@type table<player, unit>
    local dropItemI = __jarray(0) ---@type table<player, integer>
    local dropItemJ = __jarray(0) ---@type table<player, integer>

    local show = FourCC('A0GL')

    -- Add the see stats ability to the new digimon
    Digimon.createEvent:register(function (new)
        if new:getOwner() ~= Digimon.CITY and new:getOwner() ~= Digimon.PASSIVE then
            new:addAbility(show)
        end
    end)

    -- Remove the see stats ability to destroyed digimon
    Digimon.destroyEvent:register(function (old)
        old:removeAbility(show)
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_SPELL_CAST)
        TriggerAddCondition(t, Condition(function () return GetSpellAbilityId() == show end))
        TriggerAddAction(t, function ()
            local u = GetSpellAbilityUnit()
            local p = GetOwningPlayer(u)
            if seeOnly[p] then
                if seeOnly[p] == u then
                    seeOnly[p] = nil
                    if p == LocalPlayer then
                        changeVisible = true
                    end
                else
                    seeOnly[p] = u
                end
            else
                seeOnly[p] = u
                if p == LocalPlayer then
                    changeVisible = true
                end
            end
            IssueImmediateOrderById(u, Orders.unimmolation)
        end)
    end

    local function StatsButtonFunc()
        local p = GetTriggerPlayer()
        if p == LocalPlayer then
            allVisible = not allVisible
            changeVisible = true
        end
        seeOnly[p] = nil
    end

    Timed.echo(0.1, function ()
        local list = GetUsedDigimons(LocalPlayer)
        for i = 0, 2 do
            if allVisible or seeOnly[LocalPlayer] then
                if changeVisible and not BlzFrameIsVisible(StatsBackdrop[i]) then
                    BlzFrameSetVisible(StatsBackdrop[i], true)
                end

                if not list[i+1] or (seeOnly[LocalPlayer] and i ~= 0) then
                    BlzFrameSetVisible(StatsBackdrop[i], false)
                else
                    local d = seeOnly[LocalPlayer] == nil and list[i+1] or Digimon.getInstance(seeOnly[LocalPlayer])
                    local u = d.root
                    local name = GetObjectName(GetUnitTypeId(u))
                    if IsUnitType(u, UNIT_TYPE_HERO) then
                        name = name .. " " .. GetHeroProperName(u)

                        BlzFrameSetVisible(StatsHeroIcon[i], true)
                        BlzFrameSetVisible(StatsStaminaLabel[i], true)
                        BlzFrameSetVisible(StatsStamina[i], true)
                        BlzFrameSetVisible(StatsDexterityLabel[i], true)
                        BlzFrameSetVisible(StatsDexterity[i], true)
                        BlzFrameSetVisible(StatsWisdomLabel[i], true)
                        BlzFrameSetVisible(StatsWisdom[i], true)

                        local base = GetHeroStr(u, false)
                        local bonus = GetHeroStr(u, true) - base
                        BlzFrameSetText(StatsStamina[i], base .. ((bonus > 0) and (" (+".. bonus .. ")") or ""))

                        base = GetHeroAgi(u, false)
                        bonus = GetHeroAgi(u, true) - base
                        BlzFrameSetText(StatsDexterity[i], base .. ((bonus > 0) and (" (+".. bonus .. ")") or ""))

                        base = GetHeroInt(u, false)
                        bonus = GetHeroInt(u, true) - base
                        BlzFrameSetText(StatsWisdom[i], base .. ((bonus > 0) and (" (+".. bonus .. ")") or ""))

                        BlzFrameSetText(StatsCritical[i], d.critcalChance .. "\x25 (x" .. d.critcalAmount .. ")")

                        BlzFrameSetText(StatsBlock[i], tostring(d.blockAmount))

                        BlzFrameSetText(StatsEvasion[i], d.evasionChance .. "\x25")
                    else
                        BlzFrameSetVisible(StatsHeroIcon[i], false)
                        BlzFrameSetVisible(StatsStaminaLabel[i], false)
                        BlzFrameSetVisible(StatsStamina[i], false)
                        BlzFrameSetVisible(StatsDexterityLabel[i], false)
                        BlzFrameSetVisible(StatsDexterity[i], false)
                        BlzFrameSetVisible(StatsWisdomLabel[i], false)
                        BlzFrameSetVisible(StatsWisdom[i], false)
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

                        local dice = BlzGetUnitWeaponIntegerField(u, UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE, 0)
                        local side = BlzGetUnitWeaponIntegerField(u, UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE, 0)
                        local bonus = GetUnitBonus(u, BONUS_DAMAGE)
                        BlzFrameSetText(StatsDamage[i], math.floor(base + dice + bonus) .. " - " .. math.floor(base + dice * side + bonus))
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
                        BlzFrameSetText(StatsLife[i], "|c" .. (red:lerp(green, GetUnitHPRatio(u))):toHexString() .. math.floor(GetUnitState(u, UNIT_STATE_LIFE)) .. " / " .. math.floor(GetUnitState(u, UNIT_STATE_MAX_LIFE)) .. "|r")
                    else
                        BlzFrameSetText(StatsArmor[i], "")
                        BlzFrameSetText(StatsLife[i], "")
                    end

                    if GetUnitState(u, UNIT_STATE_MAX_MANA) > 0 then
                        BlzFrameSetText(StatsMana[i], "|cff0000ff" .. math.floor(GetUnitState(u, UNIT_STATE_MANA)) .. " / " .. math.floor(GetUnitState(u, UNIT_STATE_MAX_MANA)) .. "|r")
                    else
                        BlzFrameSetText(StatsMana[i], "")
                    end

                    for j = 0, 5 do
                        local m = UnitItemInSlot(u, j)
                        if m then
                            BlzFrameSetEnable(StatsItemT[i][j], true)
                            BlzFrameSetTexture(BackdropStatsItemT[i][j], BlzGetAbilityIcon(GetItemTypeId(m)), 0, true)
                        else
                            BlzFrameSetEnable(StatsItemT[i][j], false)
                            BlzFrameSetTexture(BackdropStatsItemT[i][j], "", 0, true)
                        end
                    end
                end
            else
                if (changeVisible or (i == 0 and not seeOnly)) and BlzFrameIsVisible(StatsBackdrop[i]) then
                    BlzFrameSetVisible(StatsBackdrop[i], false)
                end
            end
        end
        if changeVisible then
            changeVisible = false
        end
    end)

    local function StatsItemFunc(i, j)
        local p = GetTriggerPlayer()
        dropItemI[p] = i
        dropItemJ[p] = j
        if p == LocalPlayer then
            BlzFrameSetParent(StatsItemDrop, StatsInventoryBackdrop[i])
            BlzFrameSetPoint(StatsItemDrop, FRAMEPOINT_TOPLEFT, StatsItemT[i][j], FRAMEPOINT_TOPLEFT, 0.014500, -0.010000)
            BlzFrameSetPoint(StatsItemDrop, FRAMEPOINT_BOTTOMRIGHT, StatsItemT[i][j], FRAMEPOINT_BOTTOMRIGHT, 0.029500, -0.0050000)
            BlzFrameSetVisible(StatsItemDrop, true)
        end
    end

    local function StatsItemDropFunc()
        local p = GetTriggerPlayer()
        local d = seeOnly[p] == nil and GetUsedDigimons(p)[dropItemI[p]+1] or Digimon.getInstance(seeOnly[p])
        UnitDropItemPoint(d.root, UnitItemInSlot(d.root, dropItemJ[p]), d:getPos())
        if p == LocalPlayer then
            BlzFrameSetVisible(StatsItemDrop, false)
        end
    end

    FrameLoaderAdd(function ()
        StatsButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(StatsButton, 0)
        BlzFrameSetVisible(StatsButton, false)
        AddFrameToMenu(StatsButton)
        AddDefaultTooltip(StatsButton, "Show/Hide stats", "Show/Hide the stats of the digimons you are using.")

        BackdropStatsButton = BlzCreateFrameByType("BACKDROP", "BackdropStatsButton", StatsButton, "", 0)
        BlzFrameSetAllPoints(BackdropStatsButton, StatsButton)
        BlzFrameSetTexture(BackdropStatsButton, "ReplaceableTextures\\CommandButtons\\BTNCrystalBall.blp", 0, true)
        local t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, StatsButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, StatsButtonFunc)

        for i = 0, 2 do
            StatsBackdrop[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 1)
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.435, 0.552500 - 0.105*i)
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.452500 - 0.105*i)
            BlzFrameSetTexture(StatsBackdrop[i], "war3mapImported\\EmptyBTN.blp", 0, true)
            BlzFrameSetVisible(StatsBackdrop[i], false)
            AddFrameToMenu(StatsBackdrop[i])

            StatsName[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsName[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetPoint(StatsName[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.30500, 0.060000)
            BlzFrameSetText(StatsName[i], "|cffFFCC00Rookie Digimon Agumon|r")
            BlzFrameSetEnable(StatsName[i], false)
            BlzFrameSetScale(StatsName[i], 1.00)
            BlzFrameSetTextAlignment(StatsName[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDamageLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDamageLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.082500, -0.00053000)
            BlzFrameSetPoint(StatsDamageLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.25250, 0.079470)
            BlzFrameSetText(StatsDamageLabel[i], "|cffFFCC00Damage:|r")
            BlzFrameSetEnable(StatsDamageLabel[i], false)
            BlzFrameSetScale(StatsDamageLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsDamageLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDamageIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsDamageIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.082500, -0.020000)
            BlzFrameSetPoint(StatsDamageIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.27250, 0.050000)
            BlzFrameSetTexture(StatsDamageIcon[i], "", 0, true)

            StatsArmorLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsArmorLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.082500, -0.050000)
            BlzFrameSetPoint(StatsArmorLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.25250, 0.030000)
            BlzFrameSetText(StatsArmorLabel[i], "|cffFFCC00Armor:|r")
            BlzFrameSetEnable(StatsArmorLabel[i], false)
            BlzFrameSetScale(StatsArmorLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsArmorLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsArmorIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsArmorIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.082500, -0.070000)
            BlzFrameSetPoint(StatsArmorIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.27250, 0.0000)
            BlzFrameSetTexture(StatsArmorIcon[i], "", 0, true)

            StatsDamage[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDamage[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.11250, -0.020000)
            BlzFrameSetPoint(StatsDamage[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.21250, 0.050000)
            BlzFrameSetText(StatsDamage[i], "|cffffffff1001-2001|r")
            BlzFrameSetEnable(StatsDamage[i], false)
            BlzFrameSetScale(StatsDamage[i], 1.00)
            BlzFrameSetTextAlignment(StatsDamage[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsArmor[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsArmor[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.11250, -0.070000)
            BlzFrameSetPoint(StatsArmor[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.21250, 0.0000)
            BlzFrameSetText(StatsArmor[i], "|cffffffff150\n|r")
            BlzFrameSetEnable(StatsArmor[i], false)
            BlzFrameSetScale(StatsArmor[i], 1.00)
            BlzFrameSetTextAlignment(StatsArmor[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsHeroIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsHeroIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.17250, -0.032500)
            BlzFrameSetPoint(StatsHeroIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.17250, 0.027500)
            BlzFrameSetTexture(StatsHeroIcon[i], HERO_ICON, 0, true)

            StatsStaminaLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsStaminaLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.21250, -0.0075000)
            BlzFrameSetPoint(StatsStaminaLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.11750, 0.077500)
            BlzFrameSetText(StatsStaminaLabel[i], "|cffff7d00Stamina:|r")
            BlzFrameSetEnable(StatsStaminaLabel[i], false)
            BlzFrameSetScale(StatsStaminaLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsStaminaLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsStamina[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsStamina[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.21750, -0.022500)
            BlzFrameSetPoint(StatsStamina[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.11750, 0.062500)
            BlzFrameSetText(StatsStamina[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsStamina[i], false)
            BlzFrameSetScale(StatsStamina[i], 1.00)
            BlzFrameSetTextAlignment(StatsStamina[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDexterityLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDexterityLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.21250, -0.037500)
            BlzFrameSetPoint(StatsDexterityLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.11750, 0.047500)
            BlzFrameSetText(StatsDexterityLabel[i], "|cff007d20Dexterity:|r")
            BlzFrameSetEnable(StatsDexterityLabel[i], false)
            BlzFrameSetScale(StatsDexterityLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsDexterityLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDexterity[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDexterity[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.21750, -0.052500)
            BlzFrameSetPoint(StatsDexterity[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.11750, 0.032500)
            BlzFrameSetText(StatsDexterity[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsDexterity[i], false)
            BlzFrameSetScale(StatsDexterity[i], 1.00)
            BlzFrameSetTextAlignment(StatsDexterity[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsWisdomLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsWisdomLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.21250, -0.067500)
            BlzFrameSetPoint(StatsWisdomLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.11750, 0.017500)
            BlzFrameSetText(StatsWisdomLabel[i], "|cff004ec8Wisdom:|r")
            BlzFrameSetEnable(StatsWisdomLabel[i], false)
            BlzFrameSetScale(StatsWisdomLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsWisdomLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsWisdom[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsWisdom[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.21750, -0.082500)
            BlzFrameSetPoint(StatsWisdom[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.11750, 0.0025000)
            BlzFrameSetText(StatsWisdom[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsWisdom[i], false)
            BlzFrameSetScale(StatsWisdom[i], 1.00)
            BlzFrameSetTextAlignment(StatsWisdom[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsLife[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsLife[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.010000, -0.070000)
            BlzFrameSetPoint(StatsLife[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.31500, 0.015000)
            BlzFrameSetText(StatsLife[i], "|cff00ff001000/1000\n|r")
            BlzFrameSetEnable(StatsLife[i], false)
            BlzFrameSetScale(StatsLife[i], 1.00)
            BlzFrameSetTextAlignment(StatsLife[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            StatsMana[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsMana[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.010000, -0.085000)
            BlzFrameSetPoint(StatsMana[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.31500, 0.0000)
            BlzFrameSetText(StatsMana[i], "|cff0000ff1000/1000|r")
            BlzFrameSetEnable(StatsMana[i], false)
            BlzFrameSetScale(StatsMana[i], 1.00)
            BlzFrameSetTextAlignment(StatsMana[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            StatsDigimonIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsDigimonIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.025000, -0.040000)
            BlzFrameSetPoint(StatsDigimonIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.33000, 0.030000)
            BlzFrameSetTexture(StatsDigimonIcon[i], "CustomFrame.png", 0, true)

            StatsCriticalLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsCriticalLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.27000, -0.0075000)
            BlzFrameSetPoint(StatsCriticalLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.060000, 0.077500)
            BlzFrameSetText(StatsCriticalLabel[i], "|cffa80000Critical:|r")
            BlzFrameSetEnable(StatsCriticalLabel[i], false)
            BlzFrameSetScale(StatsCriticalLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsCriticalLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsBlockLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsBlockLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.27000, -0.037500)
            BlzFrameSetPoint(StatsBlockLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.060000, 0.047500)
            BlzFrameSetText(StatsBlockLabel[i], "|cff8a8a8aBlock:|r")
            BlzFrameSetEnable(StatsBlockLabel[i], false)
            BlzFrameSetScale(StatsBlockLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsBlockLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsEvasionLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsEvasionLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.27000, -0.067500)
            BlzFrameSetPoint(StatsEvasionLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.060000, 0.017500)
            BlzFrameSetText(StatsEvasionLabel[i], "|cff42ffadEvasion:|r")
            BlzFrameSetEnable(StatsEvasionLabel[i], false)
            BlzFrameSetScale(StatsEvasionLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsEvasionLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsCritical[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsCritical[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.27500, -0.022500)
            BlzFrameSetPoint(StatsCritical[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.060000, 0.062500)
            BlzFrameSetText(StatsCritical[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsCritical[i], false)
            BlzFrameSetScale(StatsCritical[i], 1.00)
            BlzFrameSetTextAlignment(StatsCritical[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsBlock[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsBlock[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.27500, -0.052500)
            BlzFrameSetPoint(StatsBlock[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.060000, 0.032500)
            BlzFrameSetText(StatsBlock[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsBlock[i], false)
            BlzFrameSetScale(StatsBlock[i], 1.00)
            BlzFrameSetTextAlignment(StatsBlock[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsEvasion[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsEvasion[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.27500, -0.082500)
            BlzFrameSetPoint(StatsEvasion[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.060000, 0.0025000)
            BlzFrameSetText(StatsEvasion[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsEvasion[i], false)
            BlzFrameSetScale(StatsEvasion[i], 1.00)
            BlzFrameSetTextAlignment(StatsEvasion[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsInventoryBackdrop[i] = BlzCreateFrame("CheckListBox", StatsBackdrop[i], 0, 0)
            BlzFrameSetPoint(StatsInventoryBackdrop[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.32500, -0.0050000)
            BlzFrameSetPoint(StatsInventoryBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.00000, 0.0050000)

            StatsItemT[i] = {}
            BackdropStatsItemT[i] = {}
            local x1, x2, y1, y2 = {}, {}, {}, {}
            for j = 0, 1 do
                for k = 0, 2 do
                    local index = j*3+k
                    x1[index] = 0.0055000 + 0.025*j
                    y1[index] = -0.0075000 - 0.025*k
                    x2[index] = -0.029500 + 0.025*j
                    y2[index] = 0.057500 - 0.025*k
                end
            end
            for j = 0, 5 do
                StatsItemT[i][j] = BlzCreateFrame("IconButtonTemplate", StatsInventoryBackdrop[i], 0, 0)
                BlzFrameSetPoint(StatsItemT[i][j], FRAMEPOINT_TOPLEFT, StatsInventoryBackdrop[i], FRAMEPOINT_TOPLEFT, x1[j], y1[j])
                BlzFrameSetPoint(StatsItemT[i][j], FRAMEPOINT_BOTTOMRIGHT, StatsInventoryBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, x2[j], y2[j])

                BackdropStatsItemT[i][j] = BlzCreateFrameByType("BACKDROP", "BackdropStatsItemT[" .. i .. "][" .. j .. "]", StatsItemT[i][j], "", 0)
                BlzFrameSetAllPoints(BackdropStatsItemT[i][j], StatsItemT[i][j])
                BlzFrameSetTexture(BackdropStatsItemT[i][j], "CustomFrame.png", 0, true)
                t = CreateTrigger()
                BlzTriggerRegisterFrameEvent(t, StatsItemT[i][j], FRAMEEVENT_CONTROL_CLICK)
                TriggerAddAction(t, function ()
                    StatsItemFunc(i, j)
                end)
            end

            StatsItemDrop = BlzCreateFrame("ScriptDialogButton", StatsInventoryBackdrop[0], 0, 0)
            BlzFrameSetPoint(StatsItemDrop, FRAMEPOINT_TOPLEFT, StatsItemT[0][0], FRAMEPOINT_TOPLEFT, 0.014500, -0.010000)
            BlzFrameSetPoint(StatsItemDrop, FRAMEPOINT_BOTTOMRIGHT, StatsItemT[0][0], FRAMEPOINT_BOTTOMRIGHT, 0.029500, -0.0050000)
            BlzFrameSetText(StatsItemDrop, "|cffFCD20DDrop|r")
            BlzFrameSetScale(StatsItemDrop, 1.00)
            BlzFrameSetLevel(StatsItemDrop, 100)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, StatsItemDrop, FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, StatsItemDropFunc)
            BlzFrameSetVisible(StatsItemDrop, false)
        end
    end)

    OnChangeDimensions(function ()
        for i = 0, 2 do
            BlzFrameClearAllPoints(StatsBackdrop[i])
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.435, 0.552500 - 0.105*i)
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.452500 - 0.105*i)
        end
    end)

    OnLeaderboard(function ()
        for i = 0, 2 do
            BlzFrameSetParent(StatsBackdrop[i], BlzGetFrameByName("Leaderboard", 0))
        end
    end)

    ---@param p player
    function ShowStats(p)
        if p == GetLocalPlayer() then
            BlzFrameSetVisible(StatsButton, true)
        end
    end
end)
Debug.endFile()