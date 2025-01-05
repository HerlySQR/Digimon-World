Debug.beginFile("Diary")
OnInit("Diary", function ()
    local FrameList = Require "FrameList" ---@type FrameList
    Require "DigimonEvolution"
    Require "Environment"
    Require "Serializable"

    local LocalPlayer = GetLocalPlayer()

    local Diary = nil ---@type framehandle
    local BackdropDiary = nil ---@type framehandle
    local Exit = nil ---@type framehandle
    local Backdrop = nil ---@type framehandle
    local Sprite = nil ---@type framehandle

    -- Digimons
    local DigimonsBackdrop = nil ---@type framehandle
    local DigimonsButton = nil ---@type framehandle
    local MapButton = nil ---@type framehandle
    local RookiesText = nil ---@type framehandle
    local RookiesContainer = nil ---@type framehandle
    local RookiesList = nil ---@type FrameList
    local ChampionsText = nil ---@type framehandle
    local ChampionsContainer = nil ---@type framehandle
    local ChampionsList = nil ---@type FrameList
    local UltimatesText = nil ---@type framehandle
    local UltimatesContainer = nil ---@type framehandle
    local UltimatesList = nil ---@type FrameList
    local MegasText = nil ---@type framehandle
    local MegasContainer = nil ---@type framehandle
    local MegasList = nil ---@type FrameList
    local DigimonInformation = nil ---@type framehandle
    local DigimonName = nil ---@type framehandle
    local DigimonAttackTypeIcon = nil ---@type framehandle
    local DigimonDefenseTypeIcon = nil ---@type framehandle
    local DigimonAttackTypeLabel = nil ---@type framehandle
    local DigimonDefenseTypeLabel = nil ---@type framehandle
    local DigimonStamina = nil ---@type framehandle
    local DigimonDexterity = nil ---@type framehandle
    local DigimonWisdom = nil ---@type framehandle
    local DigimonEvolvesToLabel = nil ---@type framehandle
    local DigimonEvolveOptions = nil ---@type framehandle
    --local DigimonWhere = nil ---@type framehandle
    local DigimonEvolvesToOption = {} ---@type framehandle[]
    local DigimonEvolvesToOptionButton = {} ---@type framehandle[]
    local DigimonEvolveRequirementsText = {} ---@type framehandle[]
    local DigimonAbilityT = {} ---@type framehandle[]
    local BackdropDigimonAbilityT = {} ---@type framehandle[]
    local DigimonAbilityTooltip = {} ---@type framehandle[]

    -- Items
    local ItemsButton = nil ---@type framehandle
    local ItemsBackdrop = nil ---@type framehandle
    local ItemTypes = {} ---@type framehandle[]
    local BackdropItemTypes= {} ---@type framehandle[]
    local ItemsSprite = {} ---@type framehandle[]
    local ConsumablesText = nil ---@type framehandle
    local ConsumablesContainer = nil ---@type framehandle
    local ConsumablesList = nil ---@type FrameList
    local EquipmentsText = nil ---@type framehandle
    local ShieldsText = nil ---@type framehandle
    local ShieldsContainer = nil ---@type framehandle
    local ShieldsList = nil ---@type FrameList
    local WeaponsText = nil ---@type framehandle
    local WeaponsContainer = nil ---@type framehandle
    local WeaponsList = nil ---@type FrameList
    local AccesoriesText = nil ---@type framehandle
    local AccesoriesContainer = nil ---@type framehandle
    local AccesoriesList = nil ---@type FrameList
    local DigivicesText = nil ---@type framehandle
    local DigivicesContainer = nil ---@type framehandle
    local DigivicesList = nil ---@type FrameList
    local CrestsText = nil ---@type framehandle
    local CrestsContainer = nil ---@type framehandle
    local CrestsList = nil ---@type FrameList
    local ItemInformation = nil ---@type framehandle
    local ItemName = nil ---@type framehandle
    local ItemDescription = nil ---@type framehandle

    -- Map
    local MapBackdrop = nil ---@type framehandle
    local DigimonIcons = {} ---@type framehandle[]

    local actMenu = 0

    local MAX_DIGIMON_TYPE_PER_ROW = 14
    local REQUIRED_KILLS_1 = 50
    local REQUIRED_KILLS_2 = 101
    local REQUIRED_KILLS_3 = 152
    local REQUIRED_DEATHS = 5

    local MAX_REGIONS = 30

    local WATER_ICON = "war3mapImported\\ATTWater.blp"
    local MACHINE_ICON = "war3mapImported\\ATTMetal.blp"
    local BEAST_ICON = "war3mapImported\\ATTBEast.blp"
    local FIRE_ICON = "war3mapImported\\ATTFlame.blp"
    local NATURE_ICON = "war3mapImported\\ATTNature.blp"
    local AIR_ICON = "war3mapImported\\ATTAir.blp"
    local DARK_ICON = "war3mapImported\\ATTShadow.blp"
    local HOLY_ICON = "war3mapImported\\ATTHoly.blp"
    local HERO_ICON = "war3mapImported\\ATTSystemMed.blp"

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

    local rectNames = __jarray("") ---@type table<rect, string>
    local NO_SKIN = FourCC('n000')
    local model = CreateUnit(Digimon.PASSIVE, NO_SKIN, GetRectCenterX(gg_rct_DiaryModel), GetRectCenterY(gg_rct_DiaryModel), 270)
    local glow = AddSpecialEffect("war3mapImported\\GeneralHeroGlow.mdx", GetRectCenterX(gg_rct_DiaryModel), GetRectCenterY(gg_rct_DiaryModel))
    BlzSetSpecialEffectColorByPlayer(glow, Player(GetHandleId(PLAYER_COLOR_SNOW)))
    BlzSetSpecialEffectScale(glow, 0.5)
    BlzSetSpecialEffectHeight(glow, BlzGetLocalSpecialEffectZ(glow) - 7.5)
    BlzSetSpecialEffectAlpha(glow, 200)

    local NO_SKIN_ITEM = FourCC('I07L')
    local itemModel = CreateItem(NO_SKIN_ITEM, GetRectCenterX(gg_rct_DiaryModel), GetRectCenterY(gg_rct_DiaryModel))

    ---@class EvolveCond
    ---@field label string
    ---@field toEvolve integer
    ---@field level integer
    ---@field place rect?
    ---@field stone integer?
    ---@field onlyDay boolean
    ---@field onlyNight boolean
    ---@field str integer?
    ---@field agi integer?
    ---@field int integer?

    ---@class DigimonInfo
    ---@field name string
    ---@field attackIcon string
    ---@field defenseIcon string
    ---@field staPerLvl integer
    ---@field dexPerLvl integer
    ---@field wisPerLvl integer
    ---@field evolveOptions EvolveCond[]
    ---@field whereToBeFound rect
    ---@field abilities integer[]
    ---@field button framehandle
    ---@field backdrop framehandle
    ---@field sprite framehandle

    local digiInfos = {} ---@type table<integer, DigimonInfo>

    ---@class EvolveUnlockedCond
    ---@field level boolean
    ---@field place boolean
    ---@field stone boolean
    ---@field onlyDay boolean
    ---@field onlyNight boolean
    ---@field str boolean
    ---@field agi boolean
    ---@field int boolean

    ---@class DigimonUnlockedInfo : Serializable
    ---@field staPerLvl boolean
    ---@field dexPerLvl boolean
    ---@field wisPerLvl boolean
    ---@field evolveOptions table<integer, EvolveUnlockedCond>
    ---@field whereToBeFound boolean
    local DigimonUnlockedInfo = setmetatable({}, Serializable)
    DigimonUnlockedInfo.__index = DigimonUnlockedInfo

    local unlockedDigiInfos = {} ---@type table<player, table<integer, DigimonUnlockedInfo>>
    local kills = {} ---@type table<player, table<integer, integer>>
    local deaths = {} ---@type table<player, table<integer, integer>>
    local unlockedItems = {} ---@type table<player, table<integer, boolean>>

    ---@class MapPortion
    ---@field root string
    ---@field map framehandle
    ---@field id integer
    ---@field iconPos location

    local mapPortions = {} ---@type table<string, MapPortion>
    local vistedPlaces = {} ---@type table<player, table<integer, framehandle>>
    local canBeVisted = {} ---@type table<integer, framehandle>
    local camera = gg_cam_SeeTheMap ---@type camerasetup
    local inMenu = false
    local onSeeMapClicked = EventListener.create()
    local onSeeMapClosed = EventListener.create()

    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        unlockedDigiInfos[Player(i)] = {}
        kills[Player(i)] = __jarray(0)
        deaths[Player(i)] = __jarray(0)
        vistedPlaces[Player(i)] = {}
        unlockedItems[Player(i)] = {}
    end

    Timed.echo(0.02, function ()
        if inMenu then
            CameraSetupApplyForceDuration(camera, true, 0)
        end
    end)

    ---@class ItemInfo
    ---@field name string
    ---@field staPerLvl integer
    ---@field dexPerLvl integer
    ---@field wisPerLvl integer
    ---@field evolveOptions EvolveCond[]
    ---@field whereToBeFound rect
    ---@field abilities integer[]
    ---@field button framehandle
    ---@field backdrop framehandle
    ---@field sprite framehandle

    local MAX_DIST = 0.08

    ---@param quantity integer
    ---@param dist number
    ---@param center location
    ---@return number[] xVals, number[] yVals
    local function createDistribution(quantity, dist, center)
        if quantity == 0 then
            error("You are distributing 0 elements")
        end

        local xVals = __jarray(0)
        local yVals = __jarray(0)

        if quantity == 1 then
            table.insert(xVals, GetLocationX(center))
            table.insert(yVals, GetLocationY(center))
            return xVals, yVals
        end

        local rows = __jarray(0)
        local maxSize = math.floor(MAX_DIST/dist) + 1

        local remain = quantity

        rows[0] = 1
        remain = remain - 1

        -- Create the distribution

        local rowsNumber = 0

        while remain > 0 do
            if rows[0] < maxSize then
                local isSpace = false
                for i = 0, rowsNumber - 1 do
                    local nextRow = i+1
                    if rows[nextRow] < rows[i] - nextRow then
                        isSpace = true
                        rows[nextRow] = rows[nextRow] + 1
                        remain = remain - 1
                        break
                    elseif rows[-nextRow] < rows[i] - nextRow then
                        isSpace = true
                        rows[-nextRow] = rows[-nextRow] + 1
                        remain = remain - 1
                        break
                    end
                end
                if not isSpace then
                    if rows[rowsNumber + 1] < rows[rowsNumber] - (rowsNumber + 1) then
                        rowsNumber = rowsNumber + 1
                    else
                        rows[0] = rows[0] + 1
                        remain = remain - 1
                    end
                end
            else
                for i = 1, rowsNumber do
                    if rows[i] < rows[i-1] then
                        rows[i] = rows[i] + 1
                        remain = remain - 1
                    elseif rows[-i] < rows[i+1] then
                        rows[-i] = rows[-i] + 1
                        remain = remain - 1
                    else
                        rowsNumber = rowsNumber + 1
                    end
                end
            end
        end

        -- Place the locations

        for row = rowsNumber, -rowsNumber, -1 do
            local size = rows[row]
            if size ~= 0 then
                local width = (size - 1) / 2
                local j = -width - 1.
                while j < width do
                    j = j + 1.
                    table.insert(xVals, dist * j + GetLocationX(center))
                    table.insert(yVals, dist * row + GetLocationY(center))
                end
            end
        end

        return xVals, yVals
    end

    Timed.echo(0.02, function ()
        if inMenu then
            CameraSetupApplyForceDuration(camera, false, 0)
        end
    end)

    local spriteRemain = 0

    Timed.echo(1., function ()
        BlzFrameSetVisible(Sprite, spriteRemain > 0)
        spriteRemain = spriteRemain - 1
    end)

    ---@param name string
    ---@param mapPortion string
    ---@param id integer
    ---@param glowOffset location
    local function CreateMapPortion(name, mapPortion, id, glowOffset)
        local self = {} ---@type MapPortion

        for _, env in pairs(mapPortions) do
            if env.iconPos then
                if DistanceBetweenPoints(env.iconPos, glowOffset) < 0.01 then
                    self.iconPos = env.iconPos
                    break
                end
            end
        end
        if self.iconPos then
            RemoveLocation(glowOffset)
        else
            self.iconPos = glowOffset
        end

        if mapPortion then
            FrameLoaderAdd(function ()
                if not mapPortions[mapPortion] then
                    self.map = BlzCreateFrameByType("BACKDROP", "BACKDROP", MapBackdrop, "", 1)
                    BlzFrameSetPoint(self.map, FRAMEPOINT_TOPLEFT, MapBackdrop, FRAMEPOINT_TOPLEFT, 0.10000, 0.0000)
                    BlzFrameSetPoint(self.map, FRAMEPOINT_BOTTOMRIGHT, MapBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.10000, 0.0000)
                    BlzFrameSetTexture(self.map, mapPortion, 0, true)
                    BlzFrameSetVisible(self.map, false)

                    mapPortions[mapPortion] = self

                    self.id = id

                    if canBeVisted[id] then
                        error("You are re-using the id: " .. id .. " in " .. name)
                    end
                    canBeVisted[id] = self.map
                else
                    self.map = mapPortions[mapPortion].map
                    self.id = mapPortions[mapPortion].id
                end
            end)
        end

        OnEnvApplied(name, function (p, _spect)
            if not _spect and self.map then
                if not vistedPlaces[p][id] then
                    vistedPlaces[p][id] = self.map
                    if p == LocalPlayer then
                        spriteRemain = 8
                        BlzFrameSetVisible(self.map, true)
                    end
                end
            end
        end)
    end

    local function UpdateDigimons()
        if inMenu and BlzFrameIsVisible(MapBackdrop) then
            for i = 1, udg_MAX_USED_DIGIMONS do
                BlzFrameSetVisible(DigimonIcons[i], false)
            end

            local list = GetUsedDigimons(LocalPlayer)
            local groups = SyncedTable.create() ---@type table<location, Digimon[]>

            for i = 1, #list do
                local pos = list[i].environment.iconPos
                if pos then
                    groups[pos] = groups[pos] or {}
                    table.insert(groups[pos], list[i])
                end
            end

            local j = 0
            for pos, digimons in pairs(groups) do
                local xVals, yVals = createDistribution(#digimons, 0.02, pos)
                for i = 1, #digimons do
                    j = j + 1
                    BlzFrameSetAbsPoint(DigimonIcons[j], FRAMEPOINT_CENTER, xVals[i], yVals[i])
                    BlzFrameSetTexture(DigimonIcons[j], BlzGetAbilityIcon(digimons[i]:getTypeId()), 0, true)
                    BlzFrameSetVisible(DigimonIcons[j], true)
                end
            end
        end
    end

    Timed.echo(1., UpdateDigimons)

    ---@param p player
    ---@param id integer
    function DigimonUnlockedInfo.create(p, id)
        unlockedDigiInfos[p][id] = unlockedDigiInfos[p][id] or setmetatable({
            staPerLvl = false,
            dexPerLvl = false,
            wisPerLvl = false,
            evolveOptions = {},
            whereToBeFound = false
        }, DigimonUnlockedInfo)
    end

    function DigimonUnlockedInfo:serializeProperties()
        self:addProperty("sPL", self.staPerLvl)
        self:addProperty("dPL", self.dexPerLvl)
        self:addProperty("wPL", self.wisPerLvl)
        local evoAmt = 0
        for id, unlocked in pairs(self.evolveOptions) do
            evoAmt = evoAmt + 1
            self:addProperty("eid" .. evoAmt, id)
            self:addProperty("ueidl" .. evoAmt, unlocked.level)
            self:addProperty("ueidp" .. evoAmt, unlocked.place)
            self:addProperty("ueids" .. evoAmt, unlocked.stone)
            self:addProperty("ueidstr" .. evoAmt, unlocked.str)
            self:addProperty("ueidagi" .. evoAmt, unlocked.agi)
            self:addProperty("ueidint" .. evoAmt, unlocked.int)
            self:addProperty("ueidod" .. evoAmt, unlocked.onlyDay)
            self:addProperty("ueidon" .. evoAmt, unlocked.onlyNight)
        end
        self:addProperty("evoAmt", evoAmt)
        self:addProperty("uenid", self.whereToBeFound)
    end

    function DigimonUnlockedInfo:deserializeProperties()
        self.staPerLvl = self:getBoolProperty("sPL")
        self.dexPerLvl = self:getBoolProperty("dPL")
        self.wisPerLvl = self:getBoolProperty("wPL")
        local evoAmt = self:getIntProperty("evoAmt")
        for i = 1, evoAmt do
            local id = self:getIntProperty("eid" .. i)
            self.evolveOptions[id] = __jarray(false)
            self.evolveOptions[id].level = self:getBoolProperty("ueidl" .. i)
            self.evolveOptions[id].place = self:getBoolProperty("ueidp" .. i)
            self.evolveOptions[id].stone = self:getBoolProperty("ueids" .. i)
            self.evolveOptions[id].str = self:getBoolProperty("ueidstr" .. i)
            self.evolveOptions[id].agi = self:getBoolProperty("ueidagi" .. i)
            self.evolveOptions[id].int = self:getBoolProperty("ueidint" .. i)
            self.evolveOptions[id].onlyDay = self:getBoolProperty("ueidod" .. i)
            self.evolveOptions[id].onlyNight = self:getBoolProperty("ueidon" .. i)
        end
        self.whereToBeFound = self:getBoolProperty("uenid")
    end

    ---@class UnlockedInfoData : Serializable
    ---@field p player
    ---@field amount integer
    ---@field ids integer[]
    ---@field infos DigimonUnlockedInfo[]
    ---@field killAmt integer
    ---@field killWho integer[]
    ---@field killCount integer[]
    ---@field deathAmt integer
    ---@field deathWho integer[]
    ---@field deathCount integer[]
    ---@field itemsUnlocked integer
    ---@field items integer[]
    UnlockedInfoData = setmetatable({}, Serializable)
    UnlockedInfoData.__index = UnlockedInfoData

    ---@param p player?
    ---@return UnlockedInfoData
    function UnlockedInfoData.create(p)
        local self = setmetatable({
            p = p,
            amount = 0,
            ids = {},
            infos = {},
            killAmt = 0,
            killWho = {},
            killCount = {},
            deathAmt = 0,
            deathWho = {},
            deathCount = {},
            itemsUnlocked = 0,
            items = {},
        }, UnlockedInfoData)

        if p then
            for id, info in pairs(unlockedDigiInfos[p]) do
                self.amount = self.amount + 1
                self.ids[self.amount] = id
                self.infos[self.amount] = info
            end
            for id, count in pairs(kills[p]) do
                self.killAmt = self.killAmt + 1
                self.killWho[self.killAmt] = id
                self.killCount[self.killAmt] = count
            end
            for id, count in pairs(deaths[p]) do
                self.deathAmt = self.deathAmt + 1
                self.deathWho[self.deathAmt] = id
                self.deathCount[self.deathAmt] = count
            end
            for id, _ in pairs(unlockedItems[p]) do
                self.itemsUnlocked = self.itemsUnlocked + 1
                self.items[self.itemsUnlocked] = id
            end
        end

        return self
    end

    function UnlockedInfoData:serializeProperties()
        self:addProperty("amount", self.amount)
        for i = 1, self.amount do
            self:addProperty("id" .. i, self.ids[i])
            self:addProperty("info"..i, self.infos[i]:serialize())
        end
        self:addProperty("killAmt", self.killAmt)
        for i = 1, self.killAmt do
            self:addProperty("kw" .. i, self.killWho[i])
            self:addProperty("kc" .. i, self.killCount[i])
        end
        self:addProperty("deathAmt", self.deathAmt)
        for i = 1, self.deathAmt do
            self:addProperty("dw" .. i, self.deathWho[i])
            self:addProperty("dc" .. i, self.deathCount[i])
        end
        self:addProperty("iU", self.itemsUnlocked)
        for i = 1, self.itemsUnlocked do
            self:addProperty("itms" .. i, self.items[i])
        end
    end

    function UnlockedInfoData:deserializeProperties()
        self.amount = self:getIntProperty("amount")
        for i = 1, self.amount do
            self.ids[i] = self:getIntProperty("id" .. i)
            DigimonUnlockedInfo.create(self.p, self.ids[i])
            self.infos[i] = unlockedDigiInfos[self.p][self.ids[i]]
            self.infos[i]:deserialize(self:getStringProperty("info"..i))
        end
        self.killAmt = self:getIntProperty("killAmt")
        for i = 1, self.killAmt do
            self.killWho[i] = self:getIntProperty("kw" .. i)
            self.killCount[i] = self:getIntProperty("kc" .. i)
        end
        self.deathAmt = self:getIntProperty("deathAmt")
        for i = 1, self.deathAmt do
            self.deathWho[i] = self:getIntProperty("dw" .. i)
            self.deathCount[i] = self:getIntProperty("dc" .. i)
        end
        self.itemsUnlocked = self:getIntProperty("iU")
        for i = 1, self.itemsUnlocked do
            self.items[i] = self:getIntProperty("itms" .. i)
        end
    end

    function UnlockedInfoData:apply()
        for i = 1, self.amount do
            unlockedDigiInfos[self.p][self.ids[i]] = self.infos[i]
            if self.p == LocalPlayer then
                BlzFrameSetTexture(digiInfos[self.ids[i]].backdrop, BlzGetAbilityIcon(self.ids[i]), 0, true)
                BlzFrameSetEnable(digiInfos[self.ids[i]].button, true)
            end
        end
        for i = 1, self.killAmt do
            kills[self.p][self.killWho[i]] = self.killCount[i]
        end
        for i = 1, self.deathAmt do
            deaths[self.p][self.deathWho[i]] = self.deathCount[i]
        end
        for i = 1, self.itemsUnlocked do
            unlockedItems[self.p][self.items[i]] = true
            if self.p == LocalPlayer then
                BlzFrameSetTexture(BackdropItemTypes[self.items[i]], BlzGetAbilityIcon(self.items[i]), 0, true)
                BlzFrameSetEnable(ItemTypes[self.items[i]], true)
            end
        end
    end

    local digimonSelected = -1
    local actualContainer = {} ---@type table<FrameList, framehandle>
    local actualRow = __jarray(MAX_DIGIMON_TYPE_PER_ROW) ---@type table<FrameList, integer>

    local function UpdateInformation()
        if digimonSelected ~= -1 and digiInfos[digimonSelected] then
            local info = digiInfos[digimonSelected]
            local unlockedInfo = unlockedDigiInfos[LocalPlayer][digimonSelected]

            BlzFrameSetVisible(DigimonInformation, true)
            BlzFrameSetVisible(info.sprite, false)

            BlzFrameSetText(DigimonName, "|cffFFCC00" .. info.name .. "|r")
            BlzFrameSetTexture(DigimonAttackTypeIcon, info.attackIcon, 0, true)
            BlzFrameSetTexture(DigimonDefenseTypeIcon, info.defenseIcon, 0, true)
            BlzFrameSetText(DigimonStamina, "|cffff7d00Stamina per level: |r" .. (unlockedInfo.staPerLvl and info.staPerLvl or "???"))
            BlzFrameSetText(DigimonDexterity, "|cff007d20Dexterity per level: |r" .. (unlockedInfo.dexPerLvl and info.dexPerLvl or "???"))
            BlzFrameSetText(DigimonWisdom, "|cff004ec8Wisdom per level: |r" .. (unlockedInfo.wisPerLvl and info.wisPerLvl or "???"))

            local conds = info.evolveOptions
            if conds then
                local unlockedConds = unlockedInfo.evolveOptions
                for i = 1, 7 do
                    if conds[i] then
                        local cond = conds[i]
                        local unlockedCond = unlockedConds[cond.toEvolve]
                        if unlockedCond then
                            BlzFrameSetText(DigimonEvolvesToOption[i], cond.label)
                            local result = "- " .. (unlockedCond.level and ("Have level " .. cond.level) or "???")
                            if cond.stone then
                                result = result .. "\n- " .. (unlockedCond.stone and ("Hold the " .. GetObjectName(cond.stone) .. " item.") or "???")
                            end
                            if cond.place then
                                result = result .. "\n- " .. (unlockedCond.place and ("Stay on " .. rectNames[cond.place] .. ".") or "???")
                            end
                            if cond.str then
                                result = result .. "\n- " .. (unlockedCond.str and ("Get " .. cond.str .. " stamina.") or "???")
                            end
                            if cond.agi then
                                result = result .. "\n- " .. (unlockedCond.agi and ("Get " .. cond.agi .. " dexterity.") or "???")
                            end
                            if cond.int then
                                result = result .. "\n- " .. (unlockedCond.int and ("Get " .. cond.int .. " wisdom.") or "???")
                            end
                            if cond.onlyDay then
                                result = result .. "\n- " .. (unlockedCond.onlyDay and ("Only during day.") or "???")
                            elseif cond.onlyNight then
                                result = result .. "\n- " .. (unlockedCond.onlyNight and ("Only during night.") or "???")
                            end
                            BlzFrameSetText(DigimonEvolveRequirementsText[i], result)
                            BlzFrameSetEnable(DigimonEvolvesToOptionButton[i], true)
                        else
                            BlzFrameSetText(DigimonEvolvesToOption[i], "???")
                            BlzFrameSetText(DigimonEvolveRequirementsText[i], "???")
                            BlzFrameSetEnable(DigimonEvolvesToOptionButton[i], false)
                        end
                        BlzFrameSetSize(DigimonEvolveRequirementsText[i], 0.17, 0)
                        BlzFrameSetVisible(DigimonEvolvesToOption[i], true)
                    else
                        BlzFrameSetVisible(DigimonEvolvesToOption[i], false)
                        BlzFrameSetEnable(DigimonEvolvesToOptionButton[i], false)
                    end
                end
                BlzFrameSetVisible(DigimonEvolvesToLabel, true)
                BlzFrameSetVisible(DigimonEvolveOptions, true)
            else
                BlzFrameSetVisible(DigimonEvolvesToLabel, false)
                BlzFrameSetVisible(DigimonEvolveOptions, false)
            end

            --BlzFrameSetText(DigimonWhere, "|cffffcc00Can be found on: |r" .. (info.whereToBeFound and (unlockedInfo.whereToBeFound and rectNames[info.whereToBeFound] or "???") or "No specific"))

            for i = 1, 3 do
                if info.abilities[i] then
                    BlzFrameSetTexture(BackdropDigimonAbilityT[i], BlzGetAbilityIcon(info.abilities[i]), 0, true)
                    BlzFrameSetText(DigimonAbilityTooltip[i], BlzGetAbilityTooltip(info.abilities[i], 0) .. "\n" .. BlzGetAbilityExtendedTooltip(info.abilities[i], 0))
                    BlzFrameSetSize(DigimonAbilityTooltip[i], 0.1, 0)
                    BlzFrameSetVisible(DigimonAbilityT[i], true)
                else
                    BlzFrameSetVisible(DigimonAbilityT[i], false)
                end
            end

            BlzSetUnitSkin(model, digimonSelected)
            SetUnitScale(model, 0.5*BlzGetUnitRealField(model, UNIT_RF_SCALING_VALUE), 0, 0)
            BlzSetSpecialEffectAlpha(glow, 200)
        else
            BlzFrameSetVisible(DigimonInformation, false)
            BlzSetUnitSkin(model, NO_SKIN)
            BlzSetSpecialEffectAlpha(glow, 0)
        end
    end

    local itemSelected = -1
    local actualItemContainer ---@type framehandle
    local actualItemRow = MAX_DIGIMON_TYPE_PER_ROW

    local function UpdateItemInfo()
        BlzSetItemSkin(itemModel, NO_SKIN_ITEM) -- To reset the scale
        if itemSelected ~= -1 then
            BlzFrameSetVisible(ItemsSprite[itemSelected], false)
            BlzFrameSetText(ItemName, "|cffFFCC00" .. GetObjectName(itemSelected) .. "|r")
            BlzFrameSetText(ItemDescription, BlzGetAbilityExtendedTooltip(itemSelected, 0))
            BlzFrameSetVisible(ItemInformation, true)

            BlzSetItemSkin(itemModel, itemSelected)
            BlzSetItemRealField(itemModel, ITEM_RF_SCALING_VALUE, 0.5*BlzGetItemRealField(itemModel, ITEM_RF_SCALING_VALUE))
            BlzSetSpecialEffectAlpha(glow, 200)
        else
            BlzFrameSetVisible(ItemInformation, false)
            BlzSetSpecialEffectAlpha(glow, 0)
        end
    end

    ---@param p player
    ---@param id integer
    local function UnlockButton(p, id)
        if p == LocalPlayer and digiInfos[id] and not unlockedDigiInfos[p][id] then
            spriteRemain = 8
            BlzFrameSetTexture(digiInfos[id].backdrop, BlzGetAbilityIcon(id), 0, true)
            BlzFrameSetEnable(digiInfos[id].button, true)
            BlzFrameSetVisible(digiInfos[id].sprite, true)
        end
        DigimonUnlockedInfo.create(p, id)
    end

    ---@param id integer
    ---@param whereToBeFound rect
    local function AddDigimonToList(id, whereToBeFound)
        local list
        local container
        local s = GetObjectName(id)
        local space = s:find(" ")
        local which = space and s:sub(1, space - 1) or s
        if which == "Rookie" then
            list = RookiesList
            container = RookiesContainer
        elseif which == "Champion" then
            list = ChampionsList
            container = ChampionsContainer
        elseif which == "Ultimate" then
            list = UltimatesList
            container = UltimatesContainer
        elseif which == "Mega" then
            list = MegasList
            container = MegasContainer
        else
            error("Not valid name")
        end

        local actContainer = actualContainer[list]

        if actualRow[list] >= MAX_DIGIMON_TYPE_PER_ROW then
            actualRow[list] = 0
            FrameLoaderAdd(function ()
                actContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", container, "", 1)
                BlzFrameSetPoint(actContainer, FRAMEPOINT_TOPLEFT, container, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
                BlzFrameSetSize(actContainer, 0.04*MAX_DIGIMON_TYPE_PER_ROW, 0.04)
                BlzFrameSetTexture(actContainer, "war3mapImported\\EmptyBTN.blp", 0, true)
                actualContainer[list] = actContainer
            end)
        end

        FrameLoaderAdd(function ()
            local button = BlzCreateFrame("IconButtonTemplate", actContainer, 0, 0)
            BlzFrameSetPoint(button, FRAMEPOINT_TOPLEFT, actContainer, FRAMEPOINT_TOPLEFT, 0.04 * actualRow[list], 0.0000)
            BlzFrameSetSize(button, 0.04, 0.04)
            BlzFrameSetEnable(button, false)

            local sprite =  BlzCreateFrameByType("SPRITE", "sprite", button, "", 0)
            BlzFrameSetModel(sprite, "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl", 0)
            BlzFrameClearAllPoints(sprite)
            BlzFrameSetPoint(sprite, FRAMEPOINT_BOTTOMLEFT, button, FRAMEPOINT_BOTTOMLEFT, -0.001, -0.00175)
            BlzFrameSetSize(sprite, 0.00001, 0.00001)
            BlzFrameSetScale(sprite, 1.1)
            BlzFrameSetLevel(sprite, 10)
            BlzFrameSetVisible(sprite, false)

            local backdrop = BlzCreateFrameByType("BACKDROP", "DigimonType[" .. id .. "]", button, "", 0)
            BlzFrameSetAllPoints(backdrop, button)
            BlzFrameSetTexture(backdrop, "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

            digiInfos[id] = {
                whereToBeFound = whereToBeFound,
                abilities = {},
                button = button,
                backdrop = backdrop,
                sprite = sprite
            }

            local t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, button, FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function ()
                local p = GetTriggerPlayer()

                if not digiInfos[id].name then
                    local conds = GetEvolutionConditions(id)
                    local u = CreateUnit(Digimon.NEUTRAL, id, WorldBounds.minX, WorldBounds.minY, 0)
                    local index = 0
                    while true do
                        local abil = BlzGetUnitAbilityByIndex(u, index)
                        if not abil then break end
                        local spellId = BlzGetAbilityId(abil)
                        local x = BlzGetAbilityPosX(spellId)
                        local y = BlzGetAbilityPosY(spellId)
                        if y == 2 then
                            if x == 0 then
                                digiInfos[id].abilities[1] = spellId
                            elseif x == 1 then
                                digiInfos[id].abilities[2] = spellId
                            elseif x == 2 then
                                digiInfos[id].abilities[3] = spellId
                            end
                        elseif x == 1 and y == 1 then
                            digiInfos[id].abilities[4] = spellId
                        end
                        index = index + 1
                    end

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

                    digiInfos[id].attackIcon = root

                    typ = armorEquiv[BlzGetUnitIntegerField(u, UNIT_IF_DEFENSE_TYPE)]
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

                    digiInfos[id].defenseIcon = root

                    digiInfos[id].name = GetHeroProperName(u)
                    digiInfos[id].staPerLvl = BlzGetUnitRealField(u, UNIT_RF_STRENGTH_PER_LEVEL)
                    digiInfos[id].dexPerLvl = BlzGetUnitRealField(u, UNIT_RF_AGILITY_PER_LEVEL)
                    digiInfos[id].wisPerLvl = BlzGetUnitRealField(u, UNIT_RF_INTELLIGENCE_PER_LEVEL)
                    digiInfos[id].evolveOptions = conds and {}

                    RemoveUnit(u)

                    if conds then
                        for i, cond in ipairs(conds) do
                            local u2 = CreateUnit(Digimon.NEUTRAL, cond.toEvolve, WorldBounds.minX, WorldBounds.minY, 0)
                            digiInfos[id].evolveOptions[i] = {
                                label = GetHeroProperName(u2),
                                toEvolve = cond.toEvolve,
                                level = cond.level,
                                stone = cond.stone,
                                place = cond.place,
                                str = cond.str,
                                agi = cond.agi,
                                int = cond.int,
                                onlyDay = cond.onlyDay,
                                onlyNight = cond.onlyNight
                            }
                            RemoveUnit(u2)
                        end
                    end
                end
                if p == LocalPlayer then
                    digimonSelected = id
                    UpdateInformation()
                end
            end)

            if actualRow[list] == 0 then
                list:add(actContainer)
            end
        end)

        actualRow[list] = actualRow[list] + 1
    end

    ---@param id integer
    local function AddItemToList(id)
        udg_BackpackItem = id
        if udg_GoesToBackpack then
            if actualItemRow >= MAX_DIGIMON_TYPE_PER_ROW then
                actualItemRow = 0
                FrameLoaderAdd(function ()
                    actualItemContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ConsumablesContainer, "", 1)
                    BlzFrameSetPoint(actualItemContainer, FRAMEPOINT_TOPLEFT, ConsumablesContainer, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
                    BlzFrameSetSize(actualItemContainer, 0.04*MAX_DIGIMON_TYPE_PER_ROW, 0.04)
                    BlzFrameSetTexture(actualItemContainer, "war3mapImported\\EmptyBTN.blp", 0, true)
                end)
            end

            FrameLoaderAdd(function ()
                ItemTypes[id] = BlzCreateFrame("IconButtonTemplate", actualItemContainer, 0, 0)
                BlzFrameSetPoint(ItemTypes[id], FRAMEPOINT_TOPLEFT, actualItemContainer, FRAMEPOINT_TOPLEFT, 0.04 * actualItemRow, 0.0000)
                BlzFrameSetSize(ItemTypes[id], 0.04, 0.04)
                BlzFrameSetEnable(ItemTypes[id], false)

                ItemsSprite[id] =  BlzCreateFrameByType("SPRITE", "sprite", ItemTypes[id], "", 0)
                BlzFrameSetModel(ItemsSprite[id], "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl", 0)
                BlzFrameClearAllPoints(ItemsSprite[id])
                BlzFrameSetPoint(ItemsSprite[id], FRAMEPOINT_BOTTOMLEFT, ItemTypes[id], FRAMEPOINT_BOTTOMLEFT, -0.001, -0.00175)
                BlzFrameSetSize(ItemsSprite[id], 0.00001, 0.00001)
                BlzFrameSetScale(ItemsSprite[id], 1.1)
                BlzFrameSetLevel(ItemsSprite[id], 10)
                BlzFrameSetVisible(ItemsSprite[id], false)

                BackdropItemTypes[id] = BlzCreateFrameByType("BACKDROP", "BackdropItemTypes[" .. id .. "]", ItemTypes[id], "", 0)
                BlzFrameSetAllPoints(BackdropItemTypes[id], ItemTypes[id])
                BlzFrameSetTexture(BackdropItemTypes[id], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

                local t = CreateTrigger()
                BlzTriggerRegisterFrameEvent(t, ItemTypes[id], FRAMEEVENT_CONTROL_CLICK)
                TriggerAddAction(t, function ()
                    local p = GetTriggerPlayer()
                    unlockedItems[p][id] = true

                    if p == LocalPlayer then
                        itemSelected = id
                        UpdateInformation()
                    end
                end)

                if actualItemRow == 0 then
                    ConsumablesList:add(actualItemContainer)
                end
            end)
            actualItemRow = actualItemRow + 1
        else
            local list
            local container
            local itm = CreateItem(id, 0, 0)
            local which = GetItemType(itm)
            RemoveItem(itm)
            if which == ITEM_TYPE_PERMANENT then
                list = ShieldsList
                container = ShieldsContainer
            elseif which == ITEM_TYPE_ARTIFACT then
                list = WeaponsList
                container = WeaponsContainer
            elseif which == ITEM_TYPE_CAMPAIGN then
                list = AccesoriesList
                container = AccesoriesContainer
            elseif which == ITEM_TYPE_CHARGED then
                list = CrestsList
                container = CrestsContainer
            else
                list = DigivicesList
                container = DigivicesContainer
            end

            FrameLoaderAdd(function ()
                ItemTypes[id] = BlzCreateFrame("IconButtonTemplate", container, 0, 0)
                BlzFrameSetSize(ItemTypes[id], 0.04, 0.04)
                BlzFrameSetEnable(ItemTypes[id], false)

                ItemsSprite[id] =  BlzCreateFrameByType("SPRITE", "sprite", ItemTypes[id], "", 0)
                BlzFrameSetModel(ItemsSprite[id], "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl", 0)
                BlzFrameClearAllPoints(ItemsSprite[id])
                BlzFrameSetPoint(ItemsSprite[id], FRAMEPOINT_BOTTOMLEFT, ItemTypes[id], FRAMEPOINT_BOTTOMLEFT, -0.001, -0.00175)
                BlzFrameSetSize(ItemsSprite[id], 0.00001, 0.00001)
                BlzFrameSetScale(ItemsSprite[id], 1.1)
                BlzFrameSetLevel(ItemsSprite[id], 10)
                BlzFrameSetVisible(ItemsSprite[id], false)

                BackdropItemTypes[id] = BlzCreateFrameByType("BACKDROP", "BackdropItemTypes[" .. id .. "]", ItemTypes[id], "", 0)
                BlzFrameSetAllPoints(BackdropItemTypes[id], ItemTypes[id])
                BlzFrameSetTexture(BackdropItemTypes[id], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)

                local t = CreateTrigger()
                BlzTriggerRegisterFrameEvent(t, ItemTypes[id], FRAMEEVENT_CONTROL_CLICK)
                TriggerAddAction(t, function ()
                    local p = GetTriggerPlayer()

                    if p == LocalPlayer then
                        itemSelected = id
                        UpdateItemInfo()
                    end
                end)

                list:add(ItemTypes[id])
            end)
        end
    end

    local function OpenMenu()
        if actMenu == 0 then
            BlzFrameSetVisible(DigimonsBackdrop, true)
            BlzFrameSetVisible(ItemsBackdrop, false)
            BlzSetItemSkin(itemModel, NO_SKIN_ITEM)
            BlzFrameSetVisible(MapBackdrop, false)
            UpdateInformation()
        elseif actMenu == 1 then
            BlzFrameSetVisible(DigimonsBackdrop, false)
            BlzSetUnitSkin(model, NO_SKIN)
            BlzFrameSetVisible(ItemsBackdrop, true)
            BlzFrameSetVisible(MapBackdrop, false)
            UpdateItemInfo()
        elseif actMenu == 2 then
            BlzFrameSetVisible(DigimonsBackdrop, false)
            BlzSetUnitSkin(model, NO_SKIN)
            BlzSetItemSkin(itemModel, NO_SKIN_ITEM)
            BlzSetSpecialEffectAlpha(glow, 0)
            BlzFrameSetVisible(ItemsBackdrop, false)
            BlzFrameSetVisible(MapBackdrop, true)
            UpdateDigimons()
        end
    end

    local function DigimonsButtonFunc()
        local p = GetTriggerPlayer()
        if p == LocalPlayer then
            actMenu = 0
            OpenMenu()
        end
    end

    local function ItemsButtonFunc()
        local p = GetTriggerPlayer()
        if p == LocalPlayer then
            actMenu = 1
            OpenMenu()
        end
    end

    local function MapButtonFunc()
        local p = GetTriggerPlayer()
        if p == LocalPlayer then
            actMenu = 2
            OpenMenu()
        end
        onSeeMapClicked:run(p)
    end

    do
        local t = CreateTrigger()
        ForForce(bj_FORCE_ALL_PLAYERS, function ()
            BlzTriggerRegisterPlayerKeyEvent(t, GetEnumPlayer(), OSKEY_TAB, 0, true)
            BlzTriggerRegisterPlayerKeyEvent(t, GetEnumPlayer(), OSKEY_TAB, 1, true)
        end)
        TriggerAddAction(t, function ()
            if GetTriggerPlayer() == LocalPlayer and inMenu then
                if BlzGetTriggerPlayerMetaKey() == 1 then
                    actMenu = actMenu - 1
                    if actMenu < 0 then
                        actMenu = 2
                    end
                else
                    actMenu = actMenu + 1
                    if actMenu > 2 then
                        actMenu = 0
                    end
                end
                OpenMenu()
            end
        end)
    end

    local function DiaryFunc()
        local p = GetTriggerPlayer()
        if p == LocalPlayer then
            SaveCameraSetup()
        end
        UnitShareVision(model, p, true)
        local oldEnv = GetPlayerEnviroment(p)
        Environment.map:apply(p)
        LockEnvironment(p, true)
        oldEnv:apply(p)
        SaveSelectedUnits(p)
        if p == LocalPlayer then
            AddButtonToEscStack(Exit)
            HideMenu(true)
            BlzFrameSetVisible(Backdrop, true)
            OpenMenu()
            inMenu = true
            spriteRemain = 0
        end
    end

    local function ExitFunc()
        local p = GetTriggerPlayer()
        UnitShareVision(model, p, false)
        LockEnvironment(p, false)
        if p == LocalPlayer then
            RemoveButtonFromEscStack(Exit)
            ShowMenu(true)
            RestartToPreviousCamera()
            inMenu = false
            BlzFrameSetVisible(Backdrop, false)
            spriteRemain = 0
        end
        RestartSelectedUnits(p)
        onSeeMapClosed:run(p)
    end

    FrameLoaderAdd(function ()
        Diary = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        AddButtonToTheRight(Diary, 7)
        AddFrameToMenu(Diary)
        SetFrameHotkey(Diary, "V")
        AddDefaultTooltip(Diary, "DigiWiki", "Look at your recopilated information about the digimons, items and the world.")
        BlzFrameSetVisible(Diary, false)

        BackdropDiary = BlzCreateFrameByType("BACKDROP", "BackdropSeeMap", Diary, "", 0)
        BlzFrameSetAllPoints(BackdropDiary, Diary)
        BlzFrameSetTexture(BackdropDiary, "ReplaceableTextures\\CommandButtons\\BTNMap.blp", 0, true)
        local t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Diary, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, DiaryFunc)

        Sprite = BlzCreateFrameByType("SPRITE", "Sprite", Diary, "", 0)
        BlzFrameSetModel(Sprite, "UI\\Feedback\\Autocast\\UI-ModalButtonOn.mdl", 0)
        BlzFrameClearAllPoints(Sprite)
        BlzFrameSetPoint(Sprite, FRAMEPOINT_BOTTOMLEFT, Diary, FRAMEPOINT_BOTTOMLEFT, -0.00125, -0.00375)
        BlzFrameSetSize(Sprite, 0.00001, 0.00001)
        BlzFrameSetScale(Sprite, 1.25)
        BlzFrameSetVisible(Sprite, false)

        Backdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 1)
        BlzFrameSetAbsPoint(Backdrop, FRAMEPOINT_TOPLEFT, 0.00000, 0.600000)
        BlzFrameSetAbsPoint(Backdrop, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.00000)
        BlzFrameSetTexture(Backdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(Backdrop, false)

        Exit = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.71000, -0.030000)
        BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.54000)
        BlzFrameSetText(Exit, "|cffFCD20DExit|r")
        BlzFrameSetLevel(Exit, 3)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Exit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ExitFunc)

        -- Digimons

        DigimonsBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetAllPoints(DigimonsBackdrop, Backdrop)
        BlzFrameSetTexture(DigimonsBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetLevel(DigimonsBackdrop, 2)

        DigimonsButton = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.030000)
        BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.71000, 0.54000)
        BlzFrameSetText(DigimonsButton, "|cffFCD20DDigimons|r")
        BlzFrameSetLevel(DigimonsButton, 3)
        TriggerDigimonsButton = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerDigimonsButton, DigimonsButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerDigimonsButton, DigimonsButtonFunc)

        RookiesText = BlzCreateFrameByType("TEXT", "name", DigimonsBackdrop, "", 0)
        BlzFrameSetScale(RookiesText, 2.00)
        BlzFrameSetPoint(RookiesText, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.080000)
        BlzFrameSetPoint(RookiesText, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.50000)
        BlzFrameSetText(RookiesText, "|cffFFCC00Rookies|r")
        BlzFrameSetEnable(RookiesText, false)
        BlzFrameSetTextAlignment(RookiesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        RookiesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
        BlzFrameSetPoint(RookiesContainer, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.11000)
        BlzFrameSetPoint(RookiesContainer, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.41000)
        BlzFrameSetTexture(RookiesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        RookiesList = FrameList.create(false, RookiesContainer)
        BlzFrameSetPoint(RookiesList.Frame, FRAMEPOINT_TOPLEFT, RookiesContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        RookiesList:setSize(0.56, 0.086)
        BlzFrameSetSize(RookiesList.Slider, 0.012, 0.08)

        ChampionsText = BlzCreateFrameByType("TEXT", "name", DigimonsBackdrop, "", 0)
        BlzFrameSetScale(ChampionsText, 2.00)
        BlzFrameSetPoint(ChampionsText, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.20000)
        BlzFrameSetPoint(ChampionsText, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.38000)
        BlzFrameSetText(ChampionsText, "|cffFFCC00Champions|r")
        BlzFrameSetEnable(ChampionsText, false)
        BlzFrameSetTextAlignment(ChampionsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        ChampionsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
        BlzFrameSetPoint(ChampionsContainer, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.23000)
        BlzFrameSetPoint(ChampionsContainer, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.29000)
        BlzFrameSetTexture(ChampionsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        ChampionsList = FrameList.create(false, ChampionsContainer)
        BlzFrameSetPoint(ChampionsList.Frame, FRAMEPOINT_TOPLEFT, ChampionsContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        ChampionsList:setSize(0.56, 0.086)
        BlzFrameSetSize(ChampionsList.Slider, 0.012, 0.08)

        UltimatesText = BlzCreateFrameByType("TEXT", "name", DigimonsBackdrop, "", 0)
        BlzFrameSetScale(UltimatesText, 2.00)
        BlzFrameSetPoint(UltimatesText, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.32000)
        BlzFrameSetPoint(UltimatesText, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.26000)
        BlzFrameSetText(UltimatesText, "|cffFFCC00Ultimates|r")
        BlzFrameSetEnable(UltimatesText, false)
        BlzFrameSetTextAlignment(UltimatesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        UltimatesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
        BlzFrameSetPoint(UltimatesContainer, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.35000)
        BlzFrameSetPoint(UltimatesContainer, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.17000)
        BlzFrameSetTexture(UltimatesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        UltimatesList = FrameList.create(false, UltimatesContainer)
        BlzFrameSetPoint(UltimatesList.Frame, FRAMEPOINT_TOPLEFT, UltimatesContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        UltimatesList:setSize(0.56, 0.086)
        BlzFrameSetSize(UltimatesList.Slider, 0.012, 0.08)

        MegasText = BlzCreateFrameByType("TEXT", "name", DigimonsBackdrop, "", 0)
        BlzFrameSetScale(MegasText, 2.00)
        BlzFrameSetPoint(MegasText, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.44000)
        BlzFrameSetPoint(MegasText, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.14000)
        BlzFrameSetText(MegasText, "|cffFFCC00Megas|r")
        BlzFrameSetEnable(MegasText, false)
        BlzFrameSetTextAlignment(MegasText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        MegasContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
        BlzFrameSetPoint(MegasContainer, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.47000)
        BlzFrameSetPoint(MegasContainer, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.050000)
        BlzFrameSetTexture(MegasContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        MegasList = FrameList.create(false, MegasContainer)
        BlzFrameSetPoint(MegasList.Frame, FRAMEPOINT_TOPLEFT, MegasContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        MegasList:setSize(0.56, 0.086)
        BlzFrameSetSize(MegasList.Slider, 0.012, 0.08)

        DigimonInformation = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonsBackdrop, "", 1)
        BlzFrameSetPoint(DigimonInformation, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.61000, -0.070000)
        BlzFrameSetPoint(DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetTexture(DigimonInformation, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(DigimonInformation, false)

        DigimonName = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonName, 1.57)
        BlzFrameSetPoint(DigimonName, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(DigimonName, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.49000)
        BlzFrameSetText(DigimonName, "|cffFFCC00Agumon|r")
        BlzFrameSetEnable(DigimonName, false)
        BlzFrameSetTextAlignment(DigimonName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonAttackTypeIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonInformation, "", 1)
        BlzFrameSetPoint(DigimonAttackTypeIcon, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.11000, -0.030000)
        BlzFrameSetPoint(DigimonAttackTypeIcon, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.46000)
        BlzFrameSetTexture(DigimonAttackTypeIcon, "", 0, true)

        DigimonDefenseTypeIcon = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonInformation, "", 1)
        BlzFrameSetPoint(DigimonDefenseTypeIcon, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.14000, -0.030000)
        BlzFrameSetPoint(DigimonDefenseTypeIcon, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.46000)
        BlzFrameSetTexture(DigimonDefenseTypeIcon, "", 0, true)

        DigimonAttackTypeLabel = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetPoint(DigimonAttackTypeLabel, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.11000, -0.060000)
        BlzFrameSetPoint(DigimonAttackTypeLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.45000)
        BlzFrameSetText(DigimonAttackTypeLabel, "|cffffcc00Att|r")
        BlzFrameSetEnable(DigimonAttackTypeLabel, false)
        BlzFrameSetTextAlignment(DigimonAttackTypeLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        DigimonDefenseTypeLabel = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetPoint(DigimonDefenseTypeLabel, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.14000, -0.060000)
        BlzFrameSetPoint(DigimonDefenseTypeLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.45000)
        BlzFrameSetText(DigimonDefenseTypeLabel, "|cffffcc00Def|r")
        BlzFrameSetEnable(DigimonDefenseTypeLabel, false)
        BlzFrameSetTextAlignment(DigimonDefenseTypeLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        DigimonStamina = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonStamina, 1.43)
        BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.35000)
        BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.15000)
        BlzFrameSetText(DigimonStamina, "|cffff7d00Stamina per level: |r")
        BlzFrameSetEnable(DigimonStamina, false)
        BlzFrameSetTextAlignment(DigimonStamina, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonDexterity = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonDexterity, 1.43)
        BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.37000)
        BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.13000)
        BlzFrameSetText(DigimonDexterity, "|cff007d20Dexterity per level: |r")
        BlzFrameSetEnable(DigimonDexterity, false)
        BlzFrameSetTextAlignment(DigimonDexterity, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonWisdom = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonWisdom, 1.43)
        BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.39000)
        BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.11000)
        BlzFrameSetText(DigimonWisdom, "|cff004ec8Wisdom per level: |r")
        BlzFrameSetEnable(DigimonWisdom, false)
        BlzFrameSetTextAlignment(DigimonWisdom, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonEvolvesToLabel = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonEvolvesToLabel, 1.57)
        BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.42000)
        BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.080000)
        BlzFrameSetText(DigimonEvolvesToLabel, "|cffffcc00Evolves to:|r")
        BlzFrameSetEnable(DigimonEvolvesToLabel, false)
        BlzFrameSetTextAlignment(DigimonEvolvesToLabel, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonEvolveOptions = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonInformation, "", 1)
        BlzFrameSetPoint(DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.44000)
        BlzFrameSetPoint(DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetTexture(DigimonEvolveOptions, "war3mapImported\\EmptyBTN.blp", 0, true)

        for i = 1, 7 do
            DigimonEvolvesToOption[i] = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
            BlzFrameSetPoint(DigimonEvolvesToOption[i], FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.0000, -0.010000*(i-1))
            BlzFrameSetPoint(DigimonEvolvesToOption[i], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.060000 - 0.010000*(i-1))
            BlzFrameSetText(DigimonEvolvesToOption[i], "|cffffffff- Greymon|r")
            BlzFrameSetEnable(DigimonEvolvesToOption[i], false)
            BlzFrameSetTextAlignment(DigimonEvolvesToOption[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            DigimonEvolvesToOptionButton[i] = BlzCreateFrame("IconButtonTemplate", DigimonEvolvesToOption[i], 0, 0)
            BlzFrameSetAllPoints(DigimonEvolvesToOptionButton[i], DigimonEvolvesToOption[i])
            BlzFrameSetEnable(DigimonEvolvesToOptionButton[i], false)
            local t2 = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t2, DigimonEvolvesToOptionButton[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t2, function ()
                if GetTriggerPlayer() == LocalPlayer then
                    digimonSelected = digiInfos[digimonSelected].evolveOptions[i].toEvolve
                    UpdateInformation()
                end
            end)

            local tooltip = BlzCreateFrame("QuestButtonBaseTemplate", DigimonEvolvesToOption[i], 0, 0)

            DigimonEvolveRequirementsText[i] = BlzCreateFrameByType("TEXT", "name", tooltip, "", 0)
            BlzFrameSetPoint(DigimonEvolveRequirementsText[i], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolvesToOption[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
            BlzFrameSetText(DigimonEvolveRequirementsText[i], "|cffFFCC00Requires:\n- Level 20\n- Common Digivice\n- Stay on Acient Dino Region|r")
            BlzFrameSetEnable(DigimonEvolveRequirementsText[i], false)
            BlzFrameSetTextAlignment(DigimonEvolveRequirementsText[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
            BlzFrameSetSize(DigimonEvolveRequirementsText[i], 0.17, 0)

            BlzFrameSetPoint(tooltip, FRAMEPOINT_TOPLEFT, DigimonEvolveRequirementsText[i], FRAMEPOINT_TOPLEFT, -0.0150000, 0.0150000)
            BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveRequirementsText[i], FRAMEPOINT_BOTTOMRIGHT, 0.0150000, -0.0150000)

            BlzFrameSetTooltip(DigimonEvolvesToOptionButton[i], tooltip)
        end

        --[[DigimonWhere = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonWhere, 1.14)
        BlzFrameSetPoint(DigimonWhere, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.19000)
        BlzFrameSetPoint(DigimonWhere, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.070000)
        BlzFrameSetText(DigimonWhere, "|cffffcc00Can be found on: Native Forest, Acient Dino Region, Gear Savanna.|r")
        BlzFrameSetEnable(DigimonWhere, false)
        BlzFrameSetTextAlignment(DigimonWhere, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)]]

        for i = 1, 4 do
            DigimonAbilityT[i] = BlzCreateFrame("IconButtonTemplate", DigimonInformation, 0, 0)
            BlzFrameSetPoint(DigimonAbilityT[i], FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000 + (i-1)*0.04, -0.30000)
            BlzFrameSetPoint(DigimonAbilityT[i], FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.13000 + (i-1)*0.04, 0.18000)

            BackdropDigimonAbilityT[i] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonAbilityT[" .. i .. "]", DigimonAbilityT[i], "", 0)
            BlzFrameSetAllPoints(BackdropDigimonAbilityT[i], DigimonAbilityT[i])
            BlzFrameSetTexture(BackdropDigimonAbilityT[i], "", 0, true)
            BlzFrameSetEnable(DigimonAbilityT[i], false)
            BlzFrameSetVisible(DigimonAbilityT[i], false)

            local tooltip = BlzCreateFrame("QuestButtonBaseTemplate", DigimonEvolvesToOption[i], 0, 0)

            DigimonAbilityTooltip[i] = BlzCreateFrameByType("TEXT", "name", tooltip, "", 0)
            BlzFrameSetPoint(DigimonAbilityTooltip[i], FRAMEPOINT_BOTTOMRIGHT, BackdropDigimonAbilityT[i], FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
            BlzFrameSetText(DigimonAbilityTooltip[i], "")
            BlzFrameSetEnable(DigimonAbilityTooltip[i], false)
            BlzFrameSetTextAlignment(DigimonAbilityTooltip[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
            BlzFrameSetSize(DigimonAbilityTooltip[i], 0.2, 0)

            BlzFrameSetPoint(tooltip, FRAMEPOINT_TOPLEFT, DigimonAbilityTooltip[i], FRAMEPOINT_TOPLEFT, -0.0150000, 0.0150000)
            BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOMRIGHT, DigimonAbilityTooltip[i], FRAMEPOINT_BOTTOMRIGHT, 0.0150000, -0.0150000)

            BlzFrameSetTooltip(DigimonAbilityT[i], tooltip)
        end

        -- Items

        ItemsButton = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(ItemsButton, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.10000, -0.030000)
        BlzFrameSetPoint(ItemsButton, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.63000, 0.54000)
        BlzFrameSetText(ItemsButton, "|cffFCD20DItems|r")
        BlzFrameSetLevel(ItemsButton, 3)
        TriggerItemsButton = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerItemsButton, ItemsButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerItemsButton, ItemsButtonFunc)

        ItemsBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetAllPoints(ItemsBackdrop, Backdrop)
        BlzFrameSetTexture(ItemsBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(ItemsBackdrop, false)
        BlzFrameSetLevel(ItemsBackdrop, 2)

        ConsumablesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(ConsumablesText, 2.00)
        BlzFrameSetPoint(ConsumablesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.070000)
        BlzFrameSetPoint(ConsumablesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.51000)
        BlzFrameSetText(ConsumablesText, "|cffFFCC00Consumables|r")
        BlzFrameSetEnable(ConsumablesText, false)
        BlzFrameSetTextAlignment(ConsumablesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        ConsumablesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(ConsumablesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.10000)
        BlzFrameSetPoint(ConsumablesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.42000)
        BlzFrameSetTexture(ConsumablesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        ConsumablesList = FrameList.create(false, ConsumablesContainer)
        BlzFrameSetPoint(ConsumablesList.Frame, FRAMEPOINT_TOPLEFT, ConsumablesContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        ConsumablesList:setSize(0.56, 0.086)
        BlzFrameSetSize(ConsumablesList.Slider, 0.012, 0.08)

        EquipmentsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(EquipmentsText, 2.00)
        BlzFrameSetPoint(EquipmentsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.19000)
        BlzFrameSetPoint(EquipmentsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.39000)
        BlzFrameSetText(EquipmentsText, "|cffFFCC00Equipments|r")
        BlzFrameSetEnable(EquipmentsText, false)
        BlzFrameSetTextAlignment(EquipmentsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        ShieldsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(ShieldsText, 1.86)
        BlzFrameSetPoint(ShieldsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.22000)
        BlzFrameSetPoint(ShieldsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.36000)
        BlzFrameSetText(ShieldsText, "|cff00ffffShields|r")
        BlzFrameSetEnable(ShieldsText, false)
        BlzFrameSetTextAlignment(ShieldsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        ShieldsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(ShieldsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.24000)
        BlzFrameSetPoint(ShieldsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.32000)
        BlzFrameSetTexture(ShieldsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        ShieldsList = FrameList.create(true, ShieldsContainer)
        BlzFrameSetPoint(ShieldsList.Frame, FRAMEPOINT_TOPLEFT, ShieldsContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        ShieldsList:setSize(0.56, 0.04)
        BlzFrameSetSize(ShieldsList.Slider, 0.56, 0.012)

        WeaponsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(WeaponsText, 1.86)
        BlzFrameSetPoint(WeaponsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.29550)
        BlzFrameSetPoint(WeaponsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.28450)
        BlzFrameSetText(WeaponsText, "|cff00ffffWeapons|r")
        BlzFrameSetEnable(WeaponsText, false)
        BlzFrameSetTextAlignment(WeaponsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        WeaponsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(WeaponsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.31500)
        BlzFrameSetPoint(WeaponsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.24500)
        BlzFrameSetTexture(WeaponsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        WeaponsList = FrameList.create(true, WeaponsContainer)
        BlzFrameSetPoint(WeaponsList.Frame, FRAMEPOINT_TOPLEFT, WeaponsContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        WeaponsList:setSize(0.56, 0.04)
        BlzFrameSetSize(WeaponsList.Slider, 0.56, 0.012)

        AccesoriesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(AccesoriesText, 1.86)
        BlzFrameSetPoint(AccesoriesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.37100)
        BlzFrameSetPoint(AccesoriesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.20900)
        BlzFrameSetText(AccesoriesText, "|cff00ffffAccesories|r")
        BlzFrameSetEnable(AccesoriesText, false)
        BlzFrameSetTextAlignment(AccesoriesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        AccesoriesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(AccesoriesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.39000)
        BlzFrameSetPoint(AccesoriesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.17000)
        BlzFrameSetTexture(AccesoriesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        AccesoriesList = FrameList.create(true, AccesoriesContainer)
        BlzFrameSetPoint(AccesoriesList.Frame, FRAMEPOINT_TOPLEFT, AccesoriesContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        AccesoriesList:setSize(0.56, 0.04)
        BlzFrameSetSize(AccesoriesList.Slider, 0.56, 0.012)

        DigivicesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(DigivicesText, 1.86)
        BlzFrameSetPoint(DigivicesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.44650)
        BlzFrameSetPoint(DigivicesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.13350)
        BlzFrameSetText(DigivicesText, "|cff00ffffDigivices|r")
        BlzFrameSetEnable(DigivicesText, false)
        BlzFrameSetTextAlignment(DigivicesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigivicesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(DigivicesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.46500)
        BlzFrameSetPoint(DigivicesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.095000)
        BlzFrameSetTexture(DigivicesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        DigivicesList = FrameList.create(true, DigivicesContainer)
        BlzFrameSetPoint(DigivicesList.Frame, FRAMEPOINT_TOPLEFT, DigivicesContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        DigivicesList:setSize(0.56, 0.04)
        BlzFrameSetSize(DigivicesList.Slider, 0.56, 0.012)

        CrestsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(CrestsText, 1.86)
        BlzFrameSetPoint(CrestsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.52200)
        BlzFrameSetPoint(CrestsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.058000)
        BlzFrameSetText(CrestsText, "|cff00ffffCrests|r")
        BlzFrameSetEnable(CrestsText, false)
        BlzFrameSetTextAlignment(CrestsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        CrestsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(CrestsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.54000)
        BlzFrameSetPoint(CrestsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.020000)
        BlzFrameSetTexture(CrestsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        CrestsList = FrameList.create(true, CrestsContainer)
        BlzFrameSetPoint(CrestsList.Frame, FRAMEPOINT_TOPLEFT, CrestsContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        CrestsList:setSize(0.56, 0.04)
        BlzFrameSetSize(CrestsList.Slider, 0.56, 0.012)

        ItemInformation = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(ItemInformation, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.61000, -0.11000)
        BlzFrameSetPoint(ItemInformation, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.17000)
        BlzFrameSetTexture(ItemInformation, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(ItemInformation, false)

        ItemName = BlzCreateFrameByType("TEXT", "name", ItemInformation, "", 0)
        BlzFrameSetScale(ItemName, 1.71)
        BlzFrameSetPoint(ItemName, FRAMEPOINT_TOPLEFT, ItemInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(ItemName, FRAMEPOINT_BOTTOMRIGHT, ItemInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.29000)
        BlzFrameSetText(ItemName, "|cffFFCC00Agumon|r")
        BlzFrameSetEnable(ItemName, false)
        BlzFrameSetTextAlignment(ItemName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        ItemDescription = BlzCreateFrameByType("TEXT", "name", ItemInformation, "", 0)
        BlzFrameSetScale(ItemDescription, 1.43)
        BlzFrameSetPoint(ItemDescription, FRAMEPOINT_TOPLEFT, ItemInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.22000)
        BlzFrameSetPoint(ItemDescription, FRAMEPOINT_BOTTOMRIGHT, ItemInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetText(ItemDescription, "|cffffffffStamina per level: |r")
        BlzFrameSetEnable(ItemDescription, false)
        BlzFrameSetTextAlignment(ItemDescription, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        -- Map

        MapButton = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(MapButton, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.18000, -0.030000)
        BlzFrameSetPoint(MapButton, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.55000, 0.54000)
        BlzFrameSetText(MapButton, "|cffFCD20DMap|r")
        BlzFrameSetLevel(MapButton, 3)
        TriggerMapButton = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerMapButton, MapButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerMapButton, MapButtonFunc)

        MapBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetAllPoints(MapBackdrop, Backdrop)
        BlzFrameSetTexture(MapBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(MapBackdrop, false)
        BlzFrameSetLevel(MapBackdrop, 2)

        for i = 1, udg_MAX_USED_DIGIMONS do
            DigimonIcons[i] = BlzCreateFrameByType("BACKDROP", "DigimonIcons[" .. i .. "]", MapBackdrop, "", 1)
            BlzFrameSetTexture(DigimonIcons[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            BlzFrameSetLevel(DigimonIcons[i], 10)
            BlzFrameSetVisible(DigimonIcons[i], false)
            BlzFrameSetSize(DigimonIcons[i], 0.02, 0.02)
        end
    end)

    udg_AddDigimonToList = CreateTrigger()
    TriggerAddAction(udg_AddDigimonToList, function ()
        AddDigimonToList(
            udg_DigimonType,
            udg_DigimonWhereToFind
        )
        udg_DigimonType = 0
        udg_DigimonWhereToFind = nil
    end)

    OnInit.final(function ()
        -- I don't know why I should add this
        for _, list in ipairs({RookiesList, ChampionsList, UltimatesList, MegasList}) do
            local buffer = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzFrameGetParent(list.Frame), "", 1)
            BlzFrameSetPoint(buffer, FRAMEPOINT_TOPLEFT, BlzFrameGetParent(list.Frame), FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetSize(buffer, 0.23000, 0.05750)
            BlzFrameSetTexture(buffer, "war3mapImported\\EmptyBTN.blp", 0, true)
            list:add(buffer)
        end
        Timed.call(0.01, function ()
            for _, list in ipairs({ShieldsList, WeaponsList, AccesoriesList, DigivicesList, CrestsList}) do
                local buffer = BlzCreateFrameByType("BACKDROP", "buffer", BlzFrameGetParent(list.Frame), "", 0)
                BlzFrameSetSize(buffer, 0.04, 0.04)
                BlzFrameSetTexture(buffer, "war3mapImported\\EmptyBTN.blp", 0, true)
                list:add(buffer)
            end
            local buffer = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzFrameGetParent(ConsumablesList.Frame), "", 1)
            BlzFrameSetPoint(buffer, FRAMEPOINT_TOPLEFT, BlzFrameGetParent(ConsumablesList.Frame), FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetSize(buffer, 0.23000, 0.05750)
            BlzFrameSetTexture(buffer, "war3mapImported\\EmptyBTN.blp", 0, true)
            ConsumablesList:add(buffer)
        end)
    end)

    udg_DigimonSetRectName = CreateTrigger()
    TriggerAddAction(udg_DigimonSetRectName, function ()
        rectNames[udg_DigimonRect] = udg_DigimonRectName
        udg_DigimonRect = nil
        udg_DigimonRectName = ""
    end)

    ---@param d Digimon
    local function register(d)
        local owner = d.owner
        local id = d:getTypeId()
        if IsPlayerInGame(owner) and digiInfos[id] then
            UnlockButton(owner, id)
        end
    end

    Digimon.createEvent:register(register)
    Digimon.capturedEvent:register(function (info)
        register(info.target)
    end)

    Digimon.levelUpEvent:register(function (d)
        local id = d:getTypeId()
        if not digiInfos[id] then
            return
        end
        local owner = d:getOwner()

        local unlockedInfo = unlockedDigiInfos[owner][id]
        if not unlockedInfo.staPerLvl then
            unlockedInfo.staPerLvl = true
            unlockedInfo.dexPerLvl = true
            unlockedInfo.wisPerLvl = true

            if owner == LocalPlayer then
                spriteRemain = 8
                BlzFrameSetVisible(digiInfos[id].sprite, true)
                UpdateInformation()
            end
        end
    end)

    OnEvolveCond(function (d, toEvolve, condL)
        local id = d:getTypeId()
        if not digiInfos[id] then
            return
        end

        local owner = d:getOwner()
        local unlockedInfo = unlockedDigiInfos[owner][id]

        if not unlockedInfo.evolveOptions[toEvolve] then
            unlockedInfo.evolveOptions[toEvolve] = __jarray(false)
            unlockedInfo.evolveOptions[toEvolve][condL] = true

            UnlockButton(owner, toEvolve)

            if owner == LocalPlayer then
                spriteRemain = 8
                BlzFrameSetVisible(digiInfos[id].sprite, true)
                UpdateInformation()
            end
        end
    end)

    Digimon.evolutionEvent:register(function (d)
        local id = d:getTypeId()
        if not digiInfos[id] then
            return
        end

        UnlockButton(d:getOwner(), id)
    end)

    Digimon.killEvent:register(function (info)
        local killer = info.killer
        local target = info.target
        local owner
        local kId
        local dId
        if Debug.wc3Type(killer) == "unit" then
            owner = GetOwningPlayer(killer)
            kId = GetUnitTypeId(killer)
        else
            owner = killer:getOwner()
            kId = killer:getTypeId()
        end
        dId = target:getTypeId()

        if IsPlayerInGame(owner) then
            if digiInfos[kId] then
                local killCount = kills[owner][kId] + 1
                kills[owner][kId] = killCount

                local show = false
                if killCount == REQUIRED_KILLS_1 then
                    unlockedDigiInfos[owner][kId].evolveOptions[digiInfos[kId].evolveOptions[1].toEvolve] = __jarray(true)
                    show = true
                elseif killCount == REQUIRED_KILLS_2 then
                    unlockedDigiInfos[owner][kId].evolveOptions[digiInfos[kId].evolveOptions[2].toEvolve] = __jarray(true)
                    show = true
                elseif killCount == REQUIRED_KILLS_3 then
                    unlockedDigiInfos[owner][kId].evolveOptions[digiInfos[kId].evolveOptions[3].toEvolve] = __jarray(true)
                    show = true
                end

                if show then
                    kills[owner][kId] = kills[owner][kId] + 1
                    if owner == LocalPlayer then
                        spriteRemain = 8
                        BlzFrameSetVisible(digiInfos[kId].sprite, true)
                        UpdateInformation()
                    end
                end
            end

            if digiInfos[dId] then
                local deathCount = deaths[owner][dId] + 1
                deaths[owner][dId] = deathCount

                if deathCount >= REQUIRED_DEATHS then
                    UnlockButton(owner, dId)
                end
            end
        end
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddAction(t, function ()
            local id = GetItemTypeId(GetManipulatedItem())
            if ItemTypes[id] then
                local p = GetOwningPlayer(GetManipulatingUnit())
                if not unlockedItems[p][id] then
                    unlockedItems[p][id] = true
                    if p == LocalPlayer and ItemTypes[id] and not BlzFrameGetEnable(ItemTypes[id]) then
                        BlzFrameSetTexture(BackdropItemTypes[id], BlzGetAbilityIcon(id), 0, true)
                        BlzFrameSetEnable(ItemTypes[id], true)
                        BlzFrameSetVisible(ItemsSprite[id], true)
                        spriteRemain = 8
                    end
                end
            end
        end)
    end

    ---@param p player
    ---@param flag boolean
    function ShowMapButton(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(Diary, flag)
        end
    end

    ---@param p player
    ---@return boolean[]
    function GetVisitedPlaces(p)
        local list = {}
        for i = 1, MAX_REGIONS do
            list[i] = vistedPlaces[p][i] ~= nil
        end
        return list
    end

    ---@param p player
    ---@param list boolean[]
    function ApplyVisitedPlaces(p, list)
        for i = 1, MAX_REGIONS do
            if list[i] then
                vistedPlaces[p][i] = canBeVisted[i]
                BlzFrameSetVisible(canBeVisted[i], true)
            else
                BlzFrameSetVisible(canBeVisted[i], false)
            end
        end
    end

    ---@param p player
    ---@param slot integer
    ---@return UnlockedInfoData
    function SaveDiary(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, "Diary")
        local data = UnlockedInfoData.create(p)
        local code = EncodeString(p, data:serialize())

        if p == LocalPlayer then
            FileIO.Write(fileRoot, code)
        end

        return data
    end

    ---@param p player
    ---@param slot integer
    ---@return UnlockedInfoData
    function LoadDiary(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, "Diary")
        local data = UnlockedInfoData.create()
        data.p = p
        local code = GetSyncedData(p, FileIO.Read, fileRoot)

        if code ~= "" then
            local success, decode = xpcall(DecodeString, print, p, code)
            if not success or not decode then
                DisplayTextToPlayer(p, 0, 0, "The file " .. fileRoot .. " has invalid data.")
                return data
            end
            data:deserialize(decode)
        end

        return data
    end

    function ClearDiary(p)
        unlockedDigiInfos[p] = {}
        kills[p] = __jarray(0)
        deaths[p] = __jarray(0)
        unlockedItems[p] = {}

        if p == LocalPlayer then
            digimonSelected = -1
            itemSelected = -1
            UpdateDigimons()
            UpdateInformation()
            UpdateItemInfo()
        end
    end

    ---@param func fun(p: player)
    function OnSeeMapClicked(func)
        onSeeMapClicked:register(func)
    end

    ---@param func fun(p: player)
    function OnSeeMapClosed(func)
        onSeeMapClosed:register(func)
    end

    udg_DigimonMapAdd = CreateTrigger()
    TriggerAddAction(udg_DigimonMapAdd, function ()
        CreateMapPortion(udg_DigimonRectName, udg_MapPortion, udg_MapId, udg_MapPortionGlowOffset)
        udg_DigimonRectName = ""
        udg_MapPortion = nil
        udg_MapId = nil
        udg_MapPortionGlowOffset = nil
    end)

    udg_AddItemToList = CreateTrigger()
    TriggerAddAction(udg_AddItemToList, function ()
        AddItemToList(udg_DigimonItemType)
        udg_DigimonItemType = 0
    end)
end)
Debug.endFile()