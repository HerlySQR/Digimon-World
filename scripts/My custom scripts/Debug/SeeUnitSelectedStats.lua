Debug.beginFile("SeeUnitSelectedStats")
OnInit(function ()
    Require "Timed"
    Require "Digimon"

    local selected ---@type unit
    local stats = CreateTextTag()

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

    Timed.echo(0.02, function ()
        if not selected or not UnitAlive(selected) or IsUnitHidden(selected) then
            SetTextTagVisibility(stats, false)
            return
        end
        local d = Digimon.getInstance(selected)
        if not d then
            SetTextTagVisibility(stats, false)
            return
        end

        local text = ""

        text = text .. "Stamina: " .. GetHeroStr(selected, true) .. "\n"
        text = text .. "Dexterity: " .. GetHeroAgi(selected, true) .. "\n"
        text = text .. "Wisdom: " .. GetHeroInt(selected, true) .. "\n"

        text = text .. "Critical: " .. d.critcalChance .. "\x25 |  x" .. d.critcalAmount .. "\n"
        text = text .. "Block amount: " .. d.blockAmount .. "\x25\n"
        text = text .. "Evasion chance: " .. d.evasionChance .. "\x25\n"
        text = text .. "True attack: " .. d.trueAttack .. "\x25\n"

        text = text .. "Damage: " .. math.floor(BlzGetUnitWeaponIntegerField(selected, UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE, 0) + GetUnitBonus(selected, BONUS_DAMAGE))

        local typ = BlzGetUnitWeaponIntegerField(selected, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0)
        if typ == udg_WaterAsInt then
            text = text .. " (Water)\n"
        elseif typ == udg_MachineAsInt then
            text = text .. " (Machine)\n"
        elseif typ == udg_BeastAsInt then
            text = text .. " (Beast)\n"
        elseif typ == udg_FireAsInt then
            text = text .. " (Fire)\n"
        elseif typ == udg_NatureAsInt then
            text = text .. " (Nature)\n"
        elseif typ == udg_AirAsInt then
            text = text .. " (Air)\n"
        elseif typ == udg_DarkAsInt then
            text = text .. " (Dark)\n"
        elseif typ == udg_HolyAsInt then
            text = text .. " (Holy)\n"
        else
            text = text .. "\n"
        end

        text = text .. "Armor: " .. math.floor(BlzGetUnitArmor(selected))

        typ = armorEquiv[BlzGetUnitIntegerField(selected, UNIT_IF_DEFENSE_TYPE)]
        if typ == udg_WaterAsInt then
            text = text .. " (Water)\n"
        elseif typ == udg_MachineAsInt then
            text = text .. " (Machine)\n"
        elseif typ == udg_BeastAsInt then
            text = text .. " (Beast)\n"
        elseif typ == udg_FireAsInt then
            text = text .. " (Fire)\n"
        elseif typ == udg_NatureAsInt then
            text = text .. " (Nature)\n"
        elseif typ == udg_AirAsInt then
            text = text .. " (Air)\n"
        elseif typ == udg_DarkAsInt then
            text = text .. " (Dark)\n"
        elseif typ == udg_HolyAsInt then
            text = text .. " (Holy)\n"
        else
            text = text .. "\n"
        end

        text = text .. "Life: " .. math.floor(GetUnitState(selected, UNIT_STATE_LIFE)) .. " \\ " .. math.floor(GetUnitState(selected, UNIT_STATE_MAX_LIFE)) .. "\n"
        text = text .. "Mana: " .. math.floor(GetUnitState(selected, UNIT_STATE_MANA)) .. " \\ " .. math.floor(GetUnitState(selected, UNIT_STATE_MAX_MANA)) .. "\n"

        SetTextTagTextBJ(stats, text, 10.)
        SetTextTagPosUnitBJ(stats, selected, 50.)
        SetTextTagVisibility(stats, true)
    end)

    local t = CreateTrigger()
    ForForce(bj_FORCE_ALL_PLAYERS, function ()
        TriggerRegisterPlayerSelectionEventBJ(t, GetEnumPlayer(), true)
    end)
    TriggerAddAction(t, function ()
        if GetLocalPlayer() == GetTriggerPlayer() then
            selected = GetTriggerUnit()
        end
    end)
end)
Debug.endFile()