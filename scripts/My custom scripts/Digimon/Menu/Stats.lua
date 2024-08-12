Debug.beginFile("Stats")
OnInit("Stats", function ()
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

    local visible = true

    local function StatsButtonFunc()
        if GetTriggerPlayer() == GetLocalPlayer() then
            visible = not visible
        end
    end

    Timed.echo(0.1, function ()
        local list = GetUsedDigimons(LocalPlayer)
        for i = 0, 2 do
            if visible then
                if not BlzFrameIsVisible(StatsBackdrop[i]) then
                    BlzFrameSetVisible(StatsBackdrop[i], true)
                end

                if not list[i+1] then
                    BlzFrameSetVisible(StatsBackdrop[i], false)
                else
                    local u = list[i+1].root
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
                end
            else
                if BlzFrameIsVisible(StatsBackdrop[i]) then
                    BlzFrameSetVisible(StatsBackdrop[i], false)
                end
            end
        end
    end)

    FrameLoaderAdd(function ()
        StatsButton = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(StatsButton, 0)
        BlzFrameSetVisible(StatsButton, true)
        AddFrameToMenu(StatsButton)

        BackdropStatsButton = BlzCreateFrameByType("BACKDROP", "BackdropStatsButton", StatsButton, "", 0)
        BlzFrameSetAllPoints(BackdropStatsButton, StatsButton)
        BlzFrameSetTexture(BackdropStatsButton, "ReplaceableTextures\\CommandButtons\\BTNCrystalBall.blp", 0, true)
        TriggerStatsButton = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerStatsButton, StatsButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerStatsButton, StatsButtonFunc)

        for i = 0, 2 do
            StatsBackdrop[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetFrameByName("ConsoleUIBackdrop", 0), "", 1)
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.24, 0.520000 - 0.145*i)
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.38000 - 0.145*i)
            BlzFrameSetTexture(StatsBackdrop[i], "war3mapImported\\EmptyBTN.blp", 0, true)
            BlzFrameSetVisible(StatsBackdrop[i], true)
            AddFrameToMenu(StatsBackdrop[i])

            StatsName[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsName[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetPoint(StatsName[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.12000)
            BlzFrameSetText(StatsName[i], "|cffFFCC00Rookie Digimon Agumon|r")
            BlzFrameSetEnable(StatsName[i], false)
            BlzFrameSetScale(StatsName[i], 1.00)
            BlzFrameSetTextAlignment(StatsName[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDamageLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDamageLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.018030)
            BlzFrameSetPoint(StatsDamageLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.13500, 0.10197)
            BlzFrameSetText(StatsDamageLabel[i], "|cffFFCC00Damage:|r")
            BlzFrameSetEnable(StatsDamageLabel[i], false)
            BlzFrameSetScale(StatsDamageLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsDamageLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDamageIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsDamageIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.040000)
            BlzFrameSetPoint(StatsDamageIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.15500, 0.070000)
            BlzFrameSetTexture(StatsDamageIcon[i], "", 0, true)

            StatsArmorLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsArmorLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.070000)
            BlzFrameSetPoint(StatsArmorLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.13500, 0.050000)
            BlzFrameSetText(StatsArmorLabel[i], "|cffFFCC00Armor:|r")
            BlzFrameSetEnable(StatsArmorLabel[i], false)
            BlzFrameSetScale(StatsArmorLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsArmorLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsArmorIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsArmorIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.090000)
            BlzFrameSetPoint(StatsArmorIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.15500, 0.020000)
            BlzFrameSetTexture(StatsArmorIcon[i], "", 0, true)

            StatsDamage[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDamage[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.035000, -0.040000)
            BlzFrameSetPoint(StatsDamage[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.095000, 0.070000)
            BlzFrameSetText(StatsDamage[i], "|cffffffff1001-2001|r")
            BlzFrameSetEnable(StatsDamage[i], false)
            BlzFrameSetScale(StatsDamage[i], 1.00)
            BlzFrameSetTextAlignment(StatsDamage[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsArmor[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsArmor[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.035000, -0.090000)
            BlzFrameSetPoint(StatsArmor[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.095000, 0.020000)
            BlzFrameSetText(StatsArmor[i], "|cffffffff150\n|r")
            BlzFrameSetEnable(StatsArmor[i], false)
            BlzFrameSetScale(StatsArmor[i], 1.00)
            BlzFrameSetTextAlignment(StatsArmor[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsHeroIcon[i] = BlzCreateFrameByType("BACKDROP", "BACKDROP", StatsBackdrop[i], "", 1)
            BlzFrameSetPoint(StatsHeroIcon[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.095000, -0.050000)
            BlzFrameSetPoint(StatsHeroIcon[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.055000, 0.050000)
            BlzFrameSetTexture(StatsHeroIcon[i], HERO_ICON, 0, true)

            StatsStaminaLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsStaminaLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.13500, -0.025000)
            BlzFrameSetPoint(StatsStaminaLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.10000)
            BlzFrameSetText(StatsStaminaLabel[i], "|cffff7d00Stamina:|r")
            BlzFrameSetEnable(StatsStaminaLabel[i], false)
            BlzFrameSetScale(StatsStaminaLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsStaminaLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsStamina[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsStamina[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.14000, -0.040000)
            BlzFrameSetPoint(StatsStamina[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.085000)
            BlzFrameSetText(StatsStamina[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsStamina[i], false)
            BlzFrameSetScale(StatsStamina[i], 1.00)
            BlzFrameSetTextAlignment(StatsStamina[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDexterityLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDexterityLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.13500, -0.055000)
            BlzFrameSetPoint(StatsDexterityLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.070000)
            BlzFrameSetText(StatsDexterityLabel[i], "|cff007d20Dexterity:|r")
            BlzFrameSetEnable(StatsDexterityLabel[i], false)
            BlzFrameSetScale(StatsDexterityLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsDexterityLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsDexterity[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsDexterity[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.14000, -0.070000)
            BlzFrameSetPoint(StatsDexterity[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.055000)
            BlzFrameSetText(StatsDexterity[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsDexterity[i], false)
            BlzFrameSetScale(StatsDexterity[i], 1.00)
            BlzFrameSetTextAlignment(StatsDexterity[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsWisdomLabel[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsWisdomLabel[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.13500, -0.085000)
            BlzFrameSetPoint(StatsWisdomLabel[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 1.1102e-16, 0.040000)
            BlzFrameSetText(StatsWisdomLabel[i], "|cff004ec8Wisdom:|r")
            BlzFrameSetEnable(StatsWisdomLabel[i], false)
            BlzFrameSetScale(StatsWisdomLabel[i], 1.00)
            BlzFrameSetTextAlignment(StatsWisdomLabel[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsWisdom[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsWisdom[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.14000, -0.10000)
            BlzFrameSetPoint(StatsWisdom[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.025000)
            BlzFrameSetText(StatsWisdom[i], "|cffffffff999|r")
            BlzFrameSetEnable(StatsWisdom[i], false)
            BlzFrameSetScale(StatsWisdom[i], 1.00)
            BlzFrameSetTextAlignment(StatsWisdom[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            StatsLife[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsLife[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.0000, -0.12000)
            BlzFrameSetPoint(StatsLife[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, -0.095000, 0.0000)
            BlzFrameSetText(StatsLife[i], "|cff00ff001000/1000\n|r")
            BlzFrameSetEnable(StatsLife[i], false)
            BlzFrameSetScale(StatsLife[i], 1.00)
            BlzFrameSetTextAlignment(StatsLife[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            StatsMana[i] = BlzCreateFrameByType("TEXT", "name", StatsBackdrop[i], "", 0)
            BlzFrameSetPoint(StatsMana[i], FRAMEPOINT_TOPLEFT, StatsBackdrop[i], FRAMEPOINT_TOPLEFT, 0.095000, -0.12000)
            BlzFrameSetPoint(StatsMana[i], FRAMEPOINT_BOTTOMRIGHT, StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
            BlzFrameSetText(StatsMana[i], "|cff0000ff1000/1000|r")
            BlzFrameSetEnable(StatsMana[i], false)
            BlzFrameSetScale(StatsMana[i], 1.00)
            BlzFrameSetTextAlignment(StatsMana[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
        end
    end)

    OnChangeDimensions(function ()
        for i = 0, 2 do
            BlzFrameClearAllPoints(StatsBackdrop[i])
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_TOPLEFT, GetMaxScreenX() - 0.24, 0.520000 - 0.145*i)
            BlzFrameSetAbsPoint(StatsBackdrop[i], FRAMEPOINT_BOTTOMRIGHT, GetMaxScreenX() - 0.05, 0.38000 - 0.145*i)
        end
    end)

    OnInit.final(function ()
        Require "LeaderboardUI"

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