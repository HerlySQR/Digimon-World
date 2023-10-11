Debug.beginFile("Cosmetic")
OnInit("Cosmetic", function ()
    Require "Savecode"
    Require "SaveFile"
    Require "PlayerDigimons"
    Require "PlayerUtils"
    Require "ErrorMessage"

    local MAX_LENGTH_PASSWORD = 200

    ---@class Cosmetic
    ---@field id integer
    ---@field icon string
    ---@field root string
    ---@field attachment string
    ---@field unlockDesc string?

    ---@class CosmeticInstance
    ---@field id integer
    ---@field owner Digimon
    ---@field eff effect

    local Cosmetics = {} ---@type table<integer, Cosmetic>
    local LockedCosmetics = {} ---@type table<string, integer>
    local UnlockedCosmetics = {} ---@type table<player, table<integer, boolean>>
    local toUnlock = {} ---@type table<integer, boolean>

    OnInit.final(function ()
        ForForce(FORCE_PLAYING, function ()
            UnlockedCosmetics[GetEnumPlayer()] = setmetatable({}, {__index = toUnlock})
        end)
    end)

    ---@param id integer
    ---@param password string
    ---@param unlockDesc string
    ---@param icon string
    ---@param root string
    ---@param attachment string
    local function Create(id, password, unlockDesc, icon, root, attachment)
        assert(password:len() <= MAX_LENGTH_PASSWORD, "The password is too long, max = " .. MAX_LENGTH_PASSWORD .. ", id = " .. id)
        Cosmetics[id] = {
            id = id,
            icon = icon,
            root = root,
            attachment = attachment,
            unlockDesc = password ~= "" and unlockDesc
        }
        if password ~= "" then
            LockedCosmetics[password] = id
        else
            toUnlock[id] = true
        end
    end

    ---@param p player
    ---@param slot integer
    function SaveCosmetics(p, slot)
        local path = SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\Cosmetics\\Slot_" .. slot .. ".pld"
        local savecode = Savecode.create()
        local amount = 0
        for id, v in pairs(UnlockedCosmetics[p]) do
            if v then
                savecode:Encode(id, udg_MAX_COSMETICS) -- Save the id of the cosmetics
                amount = amount + 1
            end
        end
        savecode:Encode(amount, udg_MAX_COSMETICS) -- Save the amount of cosmetics

        local s = savecode:Save(p, 1)

        if p == GetLocalPlayer() then
            FileIO.Write(path, s)
        end

        savecode:destroy()
    end

    ---@param p player
    ---@param slot integer
    ---@return table<integer, boolean>
    function LoadCosmetics(p, slot)
        local list = {}
        local path = SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\Cosmetics\\Slot_" .. slot .. ".pld"
        local savecode = Savecode.create()
        if savecode:Load(p, GetSyncedData(p, FileIO.Read, path), 1) then
            local amount = savecode:Decode(udg_MAX_COSMETICS) -- Load the amount of cosmetics
            for _ = 1, amount do
                local id = savecode:Decode(udg_MAX_COSMETICS) -- Load the id of the cosmetics
                list[id] = true
            end

            DisplayTextToPlayer(p, 0, 0, "Cosmetics loaded")
        end

        savecode:destroy()

        return list
    end

    ---@param p player
    ---@param list? table<integer, boolean>
    function SetUnlockedCosmetics(p, list)
        UnlockedCosmetics[p] = list or setmetatable({}, {__index = toUnlock})
    end

    ---@param p player
    ---@param id integer
    function ApplyCosmetic(p, id)
        if not UnlockedCosmetics[p][id] then
            ErrorMessage("This cosmetic is locked", p)
            return
        end

        for _, d in ipairs(GetAllDigimons(p)) do
            if d.cosmetic then
                DestroyEffect(d.cosmetic.eff)
            else
                d.cosmetic = {owner = d}
            end

            d.cosmetic.id = id
            d.cosmetic.eff = AddSpecialEffectTarget(Cosmetics[id].root, d.root, Cosmetics[id].attachment)
        end
    end

    Digimon.preEvolutionEvent:register(function (d)
        DestroyEffect(d.cosmetic.eff)
    end)

    Digimon.evolutionEvent:register(function (d)
        d.cosmetic.eff = AddSpecialEffectTarget(Cosmetics[d.cosmetic.id].root, d.root, Cosmetics[d.cosmetic.id].attachment)
    end)

    ---@param p player
    ---@param id integer
    ---@return boolean
    function CosmeticIsLocked(p, id)
        return not UnlockedCosmetics[p][id]
    end

    ---@param p player
    ---@param key string
    function UnlockCosmetic(p, key)
        if key:sub(1, 7) == "unlock " then
            key = key:sub(8)
        end
        if key:sub(1, 8) == "-unlock " then
            key = key:sub(9)
        end

        local savecode = Savecode.create()

        if not savecode:Load(p, key, 2) then
            DisplayTextToPlayer(p, 0, 0, "Your passed an invalid code (can't be loaded).")
            savecode:destroy()
            return
        end

        local password = ""

        local length = savecode:Decode(MAX_LENGTH_PASSWORD)
        for _ = 1, length do
            password = string.char(savecode:Decode(256)) .. password
        end
        savecode:destroy()

        local id = LockedCosmetics[password]

        if not id then
            DisplayTextToPlayer(p, 0, 0, "Your passed an invalid code (this code doesn't work).")
            return
        end

        if UnlockedCosmetics[p][id] then
            DisplayTextToPlayer(p, 0, 0, "You already unlocked this cosmetic.")
            return
        end

        UnlockedCosmetics[p][id] = true
        DisplayTextToPlayer(p, 0, 0, "Cosmetic unlocked successfully.")
    end

    ---@param p player
    ---@param password string
    function GenerateKeyToCosmetic(p, password)
        assert(LockedCosmetics[password], "There is no cosmetic with the password " .. password)

        local savecode = Savecode.create()

        for i = 1, password:len() do
            savecode:Encode(password:byte(i), 256)
        end
        savecode:Encode(password:len(), MAX_LENGTH_PASSWORD)

        local key = savecode:Save(p, 2)
        savecode:destroy()

        if p == GetLocalPlayer() then
            FileIO.Write("DigimonWorldCode.pld", "unlock " .. key)
            print(colorize(key))
        end
    end

    udg_CosmeticCreate = CreateTrigger()
    TriggerAddAction(udg_CosmeticCreate, function ()
        Create(udg_CosmeticId, udg_CosmeticPassword, udg_CosmeticEffect, udg_CosmeticAttachment)
        udg_CosmeticId = 0
        udg_CosmeticPassword = ""
        udg_CosmeticEffect = ""
        udg_CosmeticAttachment = "origin"
    end)
end)
Debug.endFile()