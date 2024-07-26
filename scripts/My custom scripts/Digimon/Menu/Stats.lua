Debug.beginFile("Stats")
OnInit(function ()
    Require "FrameLoader"
    Require "Menu"
    Require "Timed"
    Require "GetMainSelectedUnit"
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
    local TriggerStatsButton = nil ---@type trigger
    local StatsBackdrop = nil ---@type framehandle
    local StatsName = nil ---@type framehandle
    local StatsDamageLabel = nil ---@type framehandle
    local StatsDamageIcon = nil ---@type framehandle
    local StatsArmorLabel = nil ---@type framehandle
    local StatsArmorIcon = nil  ---@type framehandle
    local StatsDamage = nil ---@type framehandle
    local StatsArmor = nil ---@type framehandle
    local StatsHeroIcon = nil ---@type framehandle
    local StatsStaminaLabel = nil ---@type framehandle
    local StatsStamina = nil ---@type framehandle
    local StatsDexterityLabel = nil ---@type framehandle
    local StatsDexterity = nil ---@type framehandle
    local StatsWisdomLabel = nil ---@type framehandle
    local StatsWisdom = nil ---@type framehandle
    local StatsLife = nil ---@type framehandle
    local StatsMana = nil ---@type framehandle

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

    local visible = true

    local function StatsButtonFunc()
        if GetTriggerPlayer() == GetLocalPlayer() then
            visible = not visible
        end
    end

    Timed.echo(0.1, function ()
        if visible then
            if not BlzFrameIsVisible(StatsBackdrop) then
                BlzFrameSetVisible(StatsBackdrop, true)
            end

            local u = GetMainSelectedUnitEx()
            if not u then
                BlzFrameSetVisible(StatsBackdrop, false)
            else
                local name = GetObjectName(GetUnitTypeId(u))
                if IsUnitType(u, UNIT_TYPE_HERO) then
                    name = name .. " " .. GetHeroProperName(u)

                    BlzFrameSetVisible(StatsHeroIcon, true)
                    BlzFrameSetVisible(StatsStaminaLabel, true)
                    BlzFrameSetVisible(StatsStamina, true)
                    BlzFrameSetVisible(StatsDexterityLabel, true)
                    BlzFrameSetVisible(StatsDexterity, true)
                    BlzFrameSetVisible(StatsWisdomLabel, true)
                    BlzFrameSetVisible(StatsWisdom, true)

                    local base = GetHeroStr(u, false)
                    local bonus = GetHeroStr(u, true) - base
                    BlzFrameSetText(StatsStamina, base .. ((bonus > 0) and (" (+".. bonus .. ")") or ""))

                    base = GetHeroAgi(u, false)
                    bonus = GetHeroAgi(u, true) - base
                    BlzFrameSetText(StatsDexterity, base .. ((bonus > 0) and (" (+".. bonus .. ")") or ""))

                    base = GetHeroInt(u, false)
                    bonus = GetHeroInt(u, true) - base
                    BlzFrameSetText(StatsWisdom, base .. ((bonus > 0) and (" (+".. bonus .. ")") or ""))
                else
                    BlzFrameSetVisible(StatsHeroIcon, false)
                    BlzFrameSetVisible(StatsStaminaLabel, false)
                    BlzFrameSetVisible(StatsStamina, false)
                    BlzFrameSetVisible(StatsDexterityLabel, false)
                    BlzFrameSetVisible(StatsDexterity, false)
                    BlzFrameSetVisible(StatsWisdomLabel, false)
                    BlzFrameSetVisible(StatsWisdom, false)
                end
                BlzFrameSetText(StatsName, "|cffFFCC00" .. name .. "|r")

                local base = BlzGetUnitWeaponIntegerField(u, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0)
                if base == 0 then
                    BlzFrameSetText(StatsDamage, "")
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
                    BlzFrameSetTexture(StatsDamageIcon, root, 0, true)

                    local dice = BlzGetUnitWeaponIntegerField(u, UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE, 0)
                    local side = BlzGetUnitWeaponIntegerField(u, UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE, 0)
                    local bonus = GetUnitBonus(u, BONUS_DAMAGE)
                    BlzFrameSetText(StatsDamage, math.floor(base + dice + bonus) .. " - " .. math.floor(base + dice * side + bonus))
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
                BlzFrameSetTexture(StatsArmorIcon, root, 0, true)


                if not BlzIsUnitInvulnerable(u) then
                    BlzFrameSetText(StatsArmor, tostring(math.floor(BlzGetUnitArmor(u))))
                    BlzFrameSetText(StatsLife, "|c" .. (red:lerp(green, GetUnitHPRatio(u))):toHexString() .. math.floor(GetUnitState(u, UNIT_STATE_LIFE)) .. " / " .. math.floor(GetUnitState(u, UNIT_STATE_MAX_LIFE)) .. "|r")
                else
                    BlzFrameSetText(StatsArmor, "")
                    BlzFrameSetText(StatsLife, "")
                end

                if GetUnitState(u, UNIT_STATE_MAX_MANA) > 0 then
                    BlzFrameSetText(StatsMana, "|cff0000ff" .. math.floor(GetUnitState(u, UNIT_STATE_MANA)) .. " / " .. math.floor(GetUnitState(u, UNIT_STATE_MAX_MANA)) .. "|r")
                else
                    BlzFrameSetText(StatsMana, "")
                end
            end
        else
            if BlzFrameIsVisible(StatsBackdrop) then
                BlzFrameSetVisible(StatsBackdrop, false)
            end
        end
    end)

    FrameLoaderAdd(function ()
        StatsButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        BlzFrameSetAbsPoint(StatsButton, FRAMEPOINT_TOPLEFT, 0.84000, 0.5300)
        BlzFrameSetAbsPoint(StatsButton, FRAMEPOINT_BOTTOMRIGHT, 0.88000, 0.4900)
        BlzFrameSetVisible(StatsButton, true)
        AddFrameToMenu(StatsButton)

        BackdropStatsButton = BlzCreateFrameByType("BACKDROP", "BackdropStatsButton", StatsButton, "", 0)
        BlzFrameSetAllPoints(BackdropStatsButton, StatsButton)
        BlzFrameSetTexture(BackdropStatsButton, "ReplaceableTextures\\CommandButtons\\BTNCrystalBall.blp", 0, true)
        TriggerStatsButton = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerStatsButton, StatsButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerStatsButton, StatsButtonFunc)

        StatsBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 1)
        BlzFrameSetAbsPoint(StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.640000, 0.520000)
        BlzFrameSetAbsPoint(StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.830000, 0.38000)
        BlzFrameSetTexture(StatsBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(StatsBackdrop, true)
        AddFrameToMenu(StatsBackdrop)

        StatsName = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsName, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
        BlzFrameSetPoint(StatsName, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.12000)
        BlzFrameSetText(StatsName, "|cffFFCC00Rookie Digimon Agumon|r")
        BlzFrameSetEnable(StatsName, false)
        BlzFrameSetScale(StatsName, 1.00)
        BlzFrameSetTextAlignment(StatsName, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsDamageLabel = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsDamageLabel, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.0050000, -0.018030)
        BlzFrameSetPoint(StatsDamageLabel, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.13500, 0.10197)
        BlzFrameSetText(StatsDamageLabel, "|cffFFCC00Damage:|r")
        BlzFrameSetEnable(StatsDamageLabel, false)
        BlzFrameSetScale(StatsDamageLabel, 1.00)
        BlzFrameSetTextAlignment(StatsDamageLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsDamageIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop, "", 1)
        BlzFrameSetPoint(StatsDamageIcon, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.0050000, -0.040000)
        BlzFrameSetPoint(StatsDamageIcon, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.15500, 0.070000)
        BlzFrameSetTexture(StatsDamageIcon, "", 0, true)

        StatsArmorLabel = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsArmorLabel, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.0050000, -0.070000)
        BlzFrameSetPoint(StatsArmorLabel, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.13500, 0.050000)
        BlzFrameSetText(StatsArmorLabel, "|cffFFCC00Armor:|r")
        BlzFrameSetEnable(StatsArmorLabel, false)
        BlzFrameSetScale(StatsArmorLabel, 1.00)
        BlzFrameSetTextAlignment(StatsArmorLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsArmorIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop, "", 1)
        BlzFrameSetPoint(StatsArmorIcon, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.0050000, -0.090000)
        BlzFrameSetPoint(StatsArmorIcon, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.15500, 0.020000)
        BlzFrameSetTexture(StatsArmorIcon, "", 0, true)

        StatsDamage = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsDamage, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.035000, -0.040000)
        BlzFrameSetPoint(StatsDamage, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.095000, 0.070000)
        BlzFrameSetText(StatsDamage, "|cffffffff1001-2001|r")
        BlzFrameSetEnable(StatsDamage, false)
        BlzFrameSetScale(StatsDamage, 1.00)
        BlzFrameSetTextAlignment(StatsDamage, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsArmor = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsArmor, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.035000, -0.090000)
        BlzFrameSetPoint(StatsArmor, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.095000, 0.020000)
        BlzFrameSetText(StatsArmor, "|cffffffff150\n|r")
        BlzFrameSetEnable(StatsArmor, false)
        BlzFrameSetScale(StatsArmor, 1.00)
        BlzFrameSetTextAlignment(StatsArmor, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsHeroIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop, "", 1)
        BlzFrameSetPoint(StatsHeroIcon, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.095000, -0.050000)
        BlzFrameSetPoint(StatsHeroIcon, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.055000, 0.050000)
        BlzFrameSetTexture(StatsHeroIcon, HERO_ICON, 0, true)

        StatsStaminaLabel = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsStaminaLabel, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.13500, -0.025000)
        BlzFrameSetPoint(StatsStaminaLabel, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.10000)
        BlzFrameSetText(StatsStaminaLabel, "|cffff7d00Stamina:|r")
        BlzFrameSetEnable(StatsStaminaLabel, false)
        BlzFrameSetScale(StatsStaminaLabel, 1.00)
        BlzFrameSetTextAlignment(StatsStaminaLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsStamina = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsStamina, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.14000, -0.040000)
        BlzFrameSetPoint(StatsStamina, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.085000)
        BlzFrameSetText(StatsStamina, "|cffffffff999|r")
        BlzFrameSetEnable(StatsStamina, false)
        BlzFrameSetScale(StatsStamina, 1.00)
        BlzFrameSetTextAlignment(StatsStamina, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsDexterityLabel = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsDexterityLabel, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.13500, -0.055000)
        BlzFrameSetPoint(StatsDexterityLabel, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.070000)
        BlzFrameSetText(StatsDexterityLabel, "|cff007d20Dexterity:|r")
        BlzFrameSetEnable(StatsDexterityLabel, false)
        BlzFrameSetScale(StatsDexterityLabel, 1.00)
        BlzFrameSetTextAlignment(StatsDexterityLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsDexterity = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsDexterity, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.14000, -0.070000)
        BlzFrameSetPoint(StatsDexterity, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.055000)
        BlzFrameSetText(StatsDexterity, "|cffffffff999|r")
        BlzFrameSetEnable(StatsDexterity, false)
        BlzFrameSetScale(StatsDexterity, 1.00)
        BlzFrameSetTextAlignment(StatsDexterity, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsWisdomLabel = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsWisdomLabel, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.13500, -0.085000)
        BlzFrameSetPoint(StatsWisdomLabel, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.040000)
        BlzFrameSetText(StatsWisdomLabel, "|cff004ec8Wisdom:|r")
        BlzFrameSetEnable(StatsWisdomLabel, false)
        BlzFrameSetScale(StatsWisdomLabel, 1.00)
        BlzFrameSetTextAlignment(StatsWisdomLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsWisdom = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsWisdom, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.14000, -0.10000)
        BlzFrameSetPoint(StatsWisdom, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.025000)
        BlzFrameSetText(StatsWisdom, "|cffffffff999|r")
        BlzFrameSetEnable(StatsWisdom, false)
        BlzFrameSetScale(StatsWisdom, 1.00)
        BlzFrameSetTextAlignment(StatsWisdom, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        StatsLife = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsLife, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.0000, -0.12000)
        BlzFrameSetPoint(StatsLife, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.095000, 0.0000)
        BlzFrameSetText(StatsLife, "|cff00ff001000/1000\n|r")
        BlzFrameSetEnable(StatsLife, false)
        BlzFrameSetScale(StatsLife, 1.00)
        BlzFrameSetTextAlignment(StatsLife, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        StatsMana = BlzCreateFrameByType("TEXT", "name", StatsBackdrop, "", 0)
        BlzFrameSetPoint(StatsMana, FRAMEPOINT_TOPLEFT, StatsBackdrop, FRAMEPOINT_TOPLEFT, 0.095000, -0.12000)
        BlzFrameSetPoint(StatsMana, FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop, FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.0000)
        BlzFrameSetText(StatsMana, "|cff0000ff1000/1000|r")
        BlzFrameSetEnable(StatsMana, false)
        BlzFrameSetScale(StatsMana, 1.00)
        BlzFrameSetTextAlignment(StatsMana, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
    end)

    function ShowStats(p)
        if p == GetLocalPlayer() then
            BlzFrameSetVisible(StatsButton, true)
        end
    end
end)
Debug.endFile()