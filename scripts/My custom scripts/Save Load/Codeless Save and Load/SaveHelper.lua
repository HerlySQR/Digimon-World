do

    -- Uses GUI variables from the "Save Init" trigger. You can modify these functions to use your own variables.

    SaveHelper = {
        Hashtable = {},
        KEY_ITEMS = 1,
        KEY_UNITS = 2,
        KEY_NAMES = 3,
    }

    ---@return integer
    function SaveHelper.MaxCodeSyncLength()
        return udg_SaveLoadMaxLength
    end

    ---@param user User
    ---@return unit
    function SaveHelper.GetUserHero(user)
        return udg_SavePlayerHero[user.id]
    end

    ---@param user User
    function SaveHelper.RemoveUserHero(user)
        RemoveUnit(udg_SavePlayerHero[user.id])
        udg_SavePlayerHero[user.id] = nil
    end

    ---@param user User
    ---@param u unit
    function SaveHelper.SetUserHero(user, u)
        udg_SavePlayerHero[user.id] = u
    end

    ---@param user User
    ---@return boolean
    function SaveHelper.IsUserLoading(user)
        return udg_SavePlayerLoading[user.id]
    end

    ---@param user User
    ---@param flag boolean
    function SaveHelper.SetUserLoading(user, flag)
        udg_SavePlayerLoading[user.id] = flag
    end

    ---@param user User
    ---@param slot integer
    function SaveHelper.SetSaveSlot(user, slot)
        udg_SaveCurrentSlot[user.id] = slot
    end

    ---@param user User
    ---@return integer
    function SaveHelper.GetSaveSlot(user)
        return udg_SaveCurrentSlot[user.id]
    end

    ---@param u unit
    ---@return string
    function SaveHelper.GetUnitTitle(u)
        return GetObjectName(GetUnitTypeId(u)) .. " (" .. GetHeroProperName(u) .. ")"
    end

    ---@return string
    function SaveHelper.GetMapName()
        return udg_MapName
    end

    ---@return integer
    function SaveHelper.MaxAbilityLevel()
        return 10
    end

    ---@return integer
    function SaveHelper.MaxAbilities()
        return udg_SaveAbilityTypeMax
    end

    ---@return integer
    function SaveHelper.MaxItems()
        return udg_SaveItemTypeMax
    end

    ---@return integer
    function SaveHelper.MaxUnits()
        return udg_SaveUnitTypeMax
    end

    ---@return integer
    function SaveHelper.MaxNames()
        return udg_SaveNameMax
    end

    ---@return integer
    function SaveHelper.MaxHeroStat()
        return udg_SaveUnitMaxStat
    end

    ---@param index integer
    ---@return integer
    function SaveHelper.GetAbility(index)
        return udg_SaveAbilityType[index]
    end

    ---@param index integer
    ---@return integer
    function SaveHelper.GetItem(index)
        return udg_SaveItemType[index]
    end

    ---@param index integer
    ---@return integer
    function SaveHelper.GetUnit(index)
        return udg_SaveUnitType[index]
    end

    ---@param itemId integer
    ---@return integer
    function SaveHelper.ConvertItemId(itemId)
        return SaveHelper.Hashtable[SaveHelper.KEY_ITEMS][itemId]
    end

    ---@param unitId integer
    ---@return integer
    function SaveHelper.ConvertUnitId(unitId)
        return SaveHelper.Hashtable[SaveHelper.KEY_UNITS][unitId]
    end

    ---@param id integer
    ---@return integer
    function SaveHelper.GetHeroNameFromID(id)
        return udg_SaveNameList[id]
    end

    ---@param name string
    ---@return integer
    function SaveHelper.GetHeroNameID(name)
        return SaveHelper.Hashtable[SaveHelper.KEY_NAMES][name]
    end

    ---@param name string
    ---@return integer
    function SaveHelper.ConvertHeroName(name)
        return udg_SaveNameList[SaveHelper.GetHeroNameID(name)]
    end

    function SaveHelper.GUILoadNext()
        udg_SaveValue[udg_SaveCount] = udg_SaveTempInt:Decode(udg_SaveMaxValue[udg_SaveCount])
    end

    ---@param level integer
    ---@return integer
    function SaveHelper.GetLevelXP(level)
        local xp = udg_HeroXPLevelFactor -- level 1
        for i = 1, level do
            xp = (xp*udg_HeroXPPrevLevelFactor) + (i+1) * udg_HeroXPLevelFactor
        end
        return xp - udg_HeroXPLevelFactor
    end

    -- Called at the end of "Save Init" trigger
    function SaveHelper.Init()
        SaveHelper.Hashtable[SaveHelper.KEY_ITEMS] = {}
        for i = 0, SaveHelper.MaxItems() do
            SaveHelper.Hashtable[SaveHelper.KEY_ITEMS][udg_SaveItemType[i]] = i
        end
        SaveHelper.Hashtable[SaveHelper.KEY_UNITS] = {}
        for i = 0, SaveHelper.MaxUnits() do
            SaveHelper.Hashtable[SaveHelper.KEY_UNITS][udg_SaveUnitType[i]] = i
        end
        SaveHelper.Hashtable[SaveHelper.KEY_NAMES] = {}
        for i = 0, SaveHelper.MaxNames() do
            SaveHelper.Hashtable[SaveHelper.KEY_NAMES][udg_SaveNameList[i]] = i
        end
    end

    ---@param u unit
    ---@return unknown
    function GetHeroSaveCode(u)
        if udg_SaveUseGUI then
            TriggerExecute(gg_trg_Save_GUI)
            return udg_SaveTempString
        end
        return ""
    end

    local function LoadSaveSlot_OnLoad()
        local p = GetTriggerPlayer()
        local prefix = BlzGetTriggerSyncPrefix()
        local data = BlzGetTriggerSyncData()
        local user = User[p]

        SaveHelper.SetUserLoading(user, false)

        if (udg_SaveUseGUI) then
            udg_SaveLoadEvent_Code = data
            udg_SaveLoadEvent_Player = p
            globals.udg_SaveLoadEvent = 1.
            globals.udg_SaveLoadEvent = -1
        end
    end

    ---@param p player
    ---@param slot integer
    function LoadSaveSlot(p, slot)
        local s
        local user = User[p]

        if not SaveFile.exists(slot) then
            DisplayTextToPlayer(p, 0, 0, "Did not find any save data.")
            return
        elseif (SaveHelper.IsUserLoading(user)) then
            DisplayTextToPlayer(p, 0, 0, "Please wait while your character synchronizes.")
        else
            s = SaveFile.getData(slot)
            if GetLocalPlayer() == p then
                SyncString(s)
            end
            ClearTextMessages()
            DisplayTimedTextToPlayer(p, 0, 0, 15, "Synchronzing with other players...")
            SaveHelper.SetSaveSlot(user, slot)
        end
    end

    ---@param p player
    ---@param slot integer
    function DeleteCharSlot(p, slot)
        if GetLocalPlayer() == p then
            SaveFile.clear(p, slot)
        end
    end

    ---@param u unit
    ---@param slot integer
    ---@param s string
    function SaveCharToSlot(u, slot, s)
        local p = GetOwningPlayer(u)
        if GetLocalPlayer() == p then
            SaveFile.create(p, SaveHelper.GetUnitTitle(u), slot, s)
        end
        SaveHelper.SetSaveSlot(User[p], slot)
    end

    OnMapInit(function ()
        OnSyncString(LoadSaveSlot_OnLoad)
    end)
end