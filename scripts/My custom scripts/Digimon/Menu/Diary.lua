Debug.beginFile("Diary")
OnInit("Diary", function ()
    local FrameList = Require "FrameList" ---@type FrameList
    Require "DigimonEvolution"
    Require "Environment"
    Require "Serializable"
    Require "FoodBonus"
    Require "BitSet"

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
    local ItemTypes = {} ---@type table<integer, framehandle>
    local BackdropItemTypes = {} ---@type table<integer, framehandle>
    local ItemsSprite = {} ---@type table<integer, framehandle>
    local ConsumablesText = nil ---@type framehandle
    local MiscText = nil ---@type framehandle
    local MiscsContainer = nil ---@type framehandle
    local MiscsList = nil ---@type FrameList
    local FoodText = nil ---@type framehandle
    local FoodsContainer = nil ---@type framehandle
    local FoodsList = nil ---@type FrameList
    local DrinkText = nil ---@type framehandle
    local DrinksContainer = nil ---@type framehandle
    local DrinksList = nil ---@type FrameList
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

    -- Diary
    local RecipesBackdrop = nil ---@type framehandle
    local MaterialsLabel = nil ---@type framehandle
    local RecipeMaterialInformation = nil ---@type framehandle
    local MaterialsContainer = nil ---@type framehandle
    local RecipesLabel = nil ---@type framehandle
    local RecipesContainer = nil ---@type framehandle
    local RecipesButton = nil ---@type framehandle
    local RecipeMaterialName = nil ---@type framehandle
    local RecipeMaterialDescription = nil ---@type framehandle
    local RecipeResultButton = nil ---@type framehandle
    local RecipeRequimentsContainer = nil ---@type framehandle
    local RecipeRequirmentT = {} ---@type framehandle[]
    local RecipeRequirmentButton = {} ---@type framehandle[]

    -- Map
    local MapBackdrop = nil ---@type framehandle
    local DigimonIcons = {} ---@type framehandle[]

    local actMenu = 0

    local MAX_DIGIMON_TYPE_PER_ROW = 14
    local MAX_ITEM_TYPE_PER_ROW = 4
    local REQUIRED_KILLS_1 = 50
    local REQUIRED_KILLS_2 = 101
    local REQUIRED_KILLS_3 = 152
    local REQUIRED_DEATHS = 5

    local MAX_REGIONS = 30

    local WATER_ICON = "war3mapImported\\ATTAqua.blp"
    local MACHINE_ICON = "war3mapImported\\ATTOre.blp"
    local BEAST_ICON = "war3mapImported\\ATTBeastN.blp"
    local FIRE_ICON = "war3mapImported\\ATTFlame2.blp"
    local NATURE_ICON = "war3mapImported\\ATTNatureN.blp"
    local AIR_ICON = "war3mapImported\\ATTAirN.blp"
    local DARK_ICON = "war3mapImported\\ATTDark.blp"
    local HOLY_ICON = "war3mapImported\\ATTLight.blp"
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
    BlzSetSpecialEffectAlpha(glow, 0)

    local sourceModel = CreateUnit(Digimon.PASSIVE, NO_SKIN, GetRectCenterX(gg_rct_DiaryRecipeSourceModel), GetRectCenterY(gg_rct_DiaryRecipeSourceModel), 270)
    local sourceGlow = AddSpecialEffect("war3mapImported\\GeneralHeroGlow.mdx", GetRectCenterX(gg_rct_DiaryRecipeSourceModel), GetRectCenterY(gg_rct_DiaryRecipeSourceModel))
    BlzSetSpecialEffectColorByPlayer(sourceGlow, Player(GetHandleId(PLAYER_COLOR_SNOW)))
    BlzSetSpecialEffectScale(sourceGlow, 0.4)
    BlzSetSpecialEffectHeight(sourceGlow, BlzGetLocalSpecialEffectZ(sourceGlow) - 6)
    BlzSetSpecialEffectAlpha(sourceGlow, 0)

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
    -----@field whereToBeFound rect
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
    -----@field whereToBeFound boolean
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
    -----@field whereToBeFound rect
    ---@field abilities integer[]
    ---@field button framehandle
    ---@field backdrop framehandle
    ---@field sprite framehandle

    local MAX_DIST = 0.08

    local xVals = __jarray(0)
    local yVals = __jarray(0)
    local rows = __jarray(0)

    ---@param quantity integer
    ---@param dist number
    ---@param center location
    local function createDistribution(quantity, dist, center)
        if quantity == 0 then
            error("You are distributing 0 elements")
        end

        if quantity == 1 then
            table.insert(xVals, GetLocationX(center))
            table.insert(yVals, GetLocationY(center))
            return
        end
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
            rows[row] = nil
        end
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
            Environment.get(name).iconPos = glowOffset
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
                createDistribution(#digimons, 0.02, pos)
                for i = 1, #digimons do
                    j = j + 1
                    BlzFrameSetAbsPoint(DigimonIcons[j], FRAMEPOINT_CENTER, xVals[i], yVals[i])
                    BlzFrameSetTexture(DigimonIcons[j], BlzGetAbilityIcon(digimons[i]:getTypeId()), 0, true)
                    BlzFrameSetVisible(DigimonIcons[j], true)
                    xVals[i] = nil
                    yVals[i] = nil
                end
            end
        end
    end

    Timed.echo(1.46, UpdateDigimons)

    ---@return DigimonUnlockedInfo
    function DigimonUnlockedInfo.create()
        return setmetatable({
            staPerLvl = false,
            dexPerLvl = false,
            wisPerLvl = false,
            evolveOptions = {}--,
            --whereToBeFound = false
        }, DigimonUnlockedInfo)
    end

    function DigimonUnlockedInfo:serializeProperties()
        self:addProperty("hstats", self.staPerLvl)

        local evoAmt = 0
        for id, unlocked in pairs(self.evolveOptions) do
            evoAmt = evoAmt + 1
            self:addProperty("eid" .. evoAmt, id)

            local bitSet = BitSet.create(0)
            if unlocked.level then
                bitSet:set(0)
            end
            if unlocked.place then
                bitSet:set(1)
            end
            if unlocked.stone then
                bitSet:set(2)
            end
            if unlocked.str then
                bitSet:set(3)
            end
            if unlocked.agi then
                bitSet:set(4)
            end
            if unlocked.int then
                bitSet:set(5)
            end
            if unlocked.onlyDay then
                bitSet:set(6)
            end
            if unlocked.onlyNight then
                bitSet:set(7)
            end
            self:addProperty("edata" .. evoAmt, bitSet:toInt())
        end
        self:addProperty("evoAmt", evoAmt)
        --self:addProperty("uenid", self.whereToBeFound)
    end

    function DigimonUnlockedInfo:deserializeProperties()
        if self:getBoolProperty("hstats") then
            self.staPerLvl = self:getBoolProperty("hstats")
            self.dexPerLvl = self:getBoolProperty("hstats")
            self.wisPerLvl = self:getBoolProperty("hstats")
            local evoAmt = self:getIntProperty("evoAmt")
            for i = 1, evoAmt do
                local id = self:getIntProperty("eid" .. i)
                local bitSet = BitSet.create(self:getIntProperty("edata" .. i))
                self.evolveOptions[id] = __jarray(false)
                self.evolveOptions[id].level = bitSet:get(0)
                self.evolveOptions[id].place = bitSet:get(1)
                self.evolveOptions[id].stone = bitSet:get(2)
                self.evolveOptions[id].str = bitSet:get(3)
                self.evolveOptions[id].agi = bitSet:get(4)
                self.evolveOptions[id].int = bitSet:get(5)
                self.evolveOptions[id].onlyDay = bitSet:get(6)
                self.evolveOptions[id].onlyNight = bitSet:get(7)
            end
        else -- Backwards compatibility
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
        end
        --self.whereToBeFound = self:getBoolProperty("uenid")
    end

    ---@class UnlockedInfoData : Serializable
    ---@field p player
    ---@field amount integer
    ---@field ids integer[]
    ---@field infos DigimonUnlockedInfo[]
    ---@field killCount integer[]
    ---@field deathCount integer[]
    ---@field itemsUnlocked integer
    ---@field items integer[]
    ---@field slot integer
    ---@field id string
    UnlockedInfoData = setmetatable({}, Serializable)
    UnlockedInfoData.__index = UnlockedInfoData

    ---@overload fun(slot: integer): UnlockedInfoData
    ---@param p player
    ---@param slot integer
    ---@param ind string
    ---@return UnlockedInfoData
    function UnlockedInfoData.create(p, slot, ind)
        local self = setmetatable({
            p = p,
            amount = 0,
            ids = {},
            infos = {},
            killCount = {},
            deathCount = {},
            itemsUnlocked = 0,
            items = {},
        }, UnlockedInfoData)

        if type(p) == "number" then
            ind = slot
            slot = p
            p = nil
        end
        self.slot = slot
        self.id = ind or ""

        if p then
            for id, info in pairs(unlockedDigiInfos[p]) do
                self.amount = self.amount + 1
                self.ids[self.amount] = id
                self.infos[self.amount] = info
                self.killCount[self.amount] = kills[p][id]
                self.deathCount[self.amount] = deaths[p][id]
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
            if self.killCount[i] > 0 then
                self:addProperty("kc" .. i, self.killCount[i])
            end
            if self.deathCount[i] > 0 then
                self:addProperty("dc" .. i, self.deathCount[i])
            end
        end
        self:addProperty("iU", self.itemsUnlocked)
        for i = 1, self.itemsUnlocked do
            self:addProperty("itms" .. i, self.items[i])
        end
        self:addProperty("slot", self.slot)
        self:addProperty("id", self.id)
    end

    function UnlockedInfoData:deserializeProperties()
        if self.slot ~= self:getIntProperty("slot") then
            error("The slot is not the same.")
            return
        end
        self.amount = self:getIntProperty("amount")
        for i = 1, self.amount do
            self.ids[i] = self:getIntProperty("id" .. i)
            self.infos[i] = DigimonUnlockedInfo.create()
            self.infos[i]:deserialize(self:getStringProperty("info"..i))
            self.killCount[i] = self:getIntProperty("kc" .. i)
            self.deathCount[i] = self:getIntProperty("dc" .. i)
        end
        self.itemsUnlocked = self:getIntProperty("iU")
        for i = 1, self.itemsUnlocked do
            self.items[i] = self:getIntProperty("itms" .. i)
        end
        self.id = self:getStringProperty("id")
    end

    function UnlockedInfoData:apply()
        for i = 1, self.amount do
            unlockedDigiInfos[self.p][self.ids[i]] = self.infos[i]
            if self.p == LocalPlayer then
                BlzFrameSetTexture(digiInfos[self.ids[i]].backdrop, BlzGetAbilityIcon(self.ids[i]), 0, true)
                BlzFrameSetEnable(digiInfos[self.ids[i]].button, true)
            end
            kills[self.p][self.ids[i]] = self.killCount[i]
            deaths[self.p][self.ids[i]] = self.deathCount[i]
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
            BlzFrameSetText(DigimonStamina, GetLocalizedString("DIARY_STAMINA_PER_LEVEL") .. (unlockedInfo.staPerLvl and info.staPerLvl or GetLocalizedString("DIARY_UNKNOWN")))
            BlzFrameSetText(DigimonDexterity, GetLocalizedString("DIARY_DEXTERITY_PER_LEVEL") .. (unlockedInfo.dexPerLvl and info.dexPerLvl or GetLocalizedString("DIARY_UNKNOWN")))
            BlzFrameSetText(DigimonWisdom, GetLocalizedString("DIARY_WISDOM_PER_LEVEL") .. (unlockedInfo.wisPerLvl and info.wisPerLvl or GetLocalizedString("DIARY_UNKNOWN")))

            local conds = info.evolveOptions
            if conds then
                local unlockedConds = unlockedInfo.evolveOptions
                for i = 1, 7 do
                    if conds[i] then
                        local cond = conds[i]
                        local unlockedCond = unlockedConds[cond.toEvolve]
                        if unlockedCond then
                            BlzFrameSetText(DigimonEvolvesToOption[i], cond.label)
                            local result = "- " .. (unlockedCond.level and (GetLocalizedString("DIARY_LEVEL_COND"):format(unlockedCond.level)) or GetLocalizedString("DIARY_UNKNOWN"))
                            if cond.stone then
                                result = result .. "\n- " .. (unlockedCond.stone and (GetLocalizedString("DIARY_STONE_COND"):format(GetObjectName(cond.stone))) or GetLocalizedString("DIARY_UNKNOWN"))
                            end
                            if cond.place then
                                result = result .. "\n- " .. (unlockedCond.place and (GetLocalizedString("DIARY_PLACE_COND"):format(rectNames[cond.place])) or GetLocalizedString("DIARY_UNKNOWN"))
                            end
                            if cond.str then
                                result = result .. "\n- " .. (unlockedCond.str and (GetLocalizedString("DIARY_STA_COND"):format(cond.str)) or GetLocalizedString("DIARY_UNKNOWN"))
                            end
                            if cond.agi then
                                result = result .. "\n- " .. (unlockedCond.agi and (GetLocalizedString("DIARY_AGI_COND"):format(cond.agi)) or GetLocalizedString("DIARY_UNKNOWN"))
                            end
                            if cond.int then
                                result = result .. "\n- " .. (unlockedCond.int and (GetLocalizedString("DIARY_INT_COND"):format(cond.int)) or GetLocalizedString("DIARY_UNKNOWN"))
                            end
                            if cond.onlyDay then
                                result = result .. "\n- " .. (unlockedCond.onlyDay and (GetLocalizedString("DIARY_DAY_COND")) or GetLocalizedString("DIARY_UNKNOWN"))
                            elseif cond.onlyNight then
                                result = result .. "\n- " .. (unlockedCond.onlyNight and (GetLocalizedString("DIARY_NIGHT_COND")) or GetLocalizedString("DIARY_UNKNOWN"))
                            end
                            BlzFrameSetText(DigimonEvolveRequirementsText[i], result)
                            BlzFrameSetEnable(DigimonEvolvesToOptionButton[i], unlockedDigiInfos[LocalPlayer][digimonSelected] ~= nil)
                        else
                            BlzFrameSetText(DigimonEvolvesToOption[i], GetLocalizedString("DIARY_UNKNOWN"))
                            BlzFrameSetText(DigimonEvolveRequirementsText[i], GetLocalizedString("DIARY_UNKNOWN"))
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
    local actualItemContainer = {} ---@type table<FrameList, framehandle>
    local actualItemRow = __jarray(MAX_ITEM_TYPE_PER_ROW) ---@type table<FrameList, integer>

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

    local recipeMaterialSelected = -1
    local isRecipe = __jarray(false)
    local requirementList = {}

    local function UpdateRecipe()
        BlzSetItemSkin(itemModel, NO_SKIN_ITEM) -- To reset the scale
        if recipeMaterialSelected ~= -1 then
            BlzFrameSetVisible(ItemsSprite[recipeMaterialSelected], false)
            BlzFrameSetText(RecipeMaterialName, "|cffFFCC00" .. GetObjectName(recipeMaterialSelected) .. "|r")
            if isRecipe[recipeMaterialSelected] then
                local recipe = GetRecipe(recipeMaterialSelected)

                BlzFrameSetEnable(RecipeResultButton, unlockedItems[LocalPlayer][recipe.resultItm])

                BlzFrameSetText(RecipeMaterialDescription, GetLocalizedString("DIARY_TO_CREATE_RECIPE"):format(GetObjectName(recipe.resultItm)))

                for i = #requirementList, 1, -1 do
                    table.remove(requirementList, i)
                end
                if recipe.itmToUpgrade then
                    table.insert(requirementList, recipe.itmToUpgrade)
                end
                for req, _ in pairs(recipe.requirements) do
                    table.insert(requirementList, req)
                end

                for i = 1, 15 do
                    if requirementList[i] then
                        if recipe.itmToUpgrade and requirementList[i] == recipe.itmToUpgrade then
                            BlzFrameSetText(RecipeRequirmentT[i-1], "- " .. GetLocalizedString("DIARY_TO_UPGRADE_ITEM"):format(GetObjectName(recipe.itmToUpgrade)))
                            BlzFrameSetEnable(RecipeRequirmentButton[i-1], unlockedItems[LocalPlayer][recipe.itmToUpgrade])
                        else
                            BlzFrameSetText(RecipeRequirmentT[i-1], "- " .. recipe.requirements[requirementList[i]] .. " " .. GetObjectName(requirementList[i]) .. ".")
                            BlzFrameSetEnable(RecipeRequirmentButton[i-1], unlockedItems[LocalPlayer][requirementList[i]])
                        end
                        BlzFrameSetVisible(RecipeRequirmentT[i-1], true)
                    else
                        BlzFrameSetText(RecipeRequirmentT[i-1], "")
                        BlzFrameSetVisible(RecipeRequirmentT[i-1], false)
                        BlzFrameSetEnable(RecipeRequirmentButton[i-1], false)
                    end
                end
                BlzSetUnitSkin(sourceModel, NO_SKIN)
                BlzSetSpecialEffectAlpha(sourceGlow, 0)

                BlzFrameSetVisible(RecipeRequimentsContainer, true)
            else
                BlzFrameSetEnable(RecipeResultButton, false)
                BlzFrameSetText(RecipeMaterialDescription, GetLocalizedString("DIARY_IT_COMES_FROM"):format(GetObjectName(recipeMaterialSelected)))
                BlzFrameSetVisible(RecipeRequimentsContainer, false)

                BlzSetUnitSkin(sourceModel, GetMaterialFromItem(recipeMaterialSelected).source)
                SetUnitScale(sourceModel, 0.15*BlzGetUnitRealField(sourceModel, UNIT_RF_SCALING_VALUE), 0, 0)
                BlzSetSpecialEffectAlpha(sourceGlow, 200)
            end
            BlzFrameSetVisible(RecipeMaterialInformation, true)

            BlzSetItemSkin(itemModel, recipeMaterialSelected)
            BlzSetItemRealField(itemModel, ITEM_RF_SCALING_VALUE, 0.5*BlzGetItemRealField(itemModel, ITEM_RF_SCALING_VALUE))
            BlzSetSpecialEffectAlpha(glow, 200)
        else
            BlzFrameSetVisible(RecipeMaterialInformation, false)
            BlzSetSpecialEffectAlpha(glow, 0)
        end
    end

    ---@param p player
    ---@param id integer
    local function UnlockButton(p, id)
        if digiInfos[id] and not unlockedDigiInfos[p][id] then
            if p == LocalPlayer then
                spriteRemain = 8
                BlzFrameSetTexture(digiInfos[id].backdrop, BlzGetAbilityIcon(id), 0, true)
                BlzFrameSetEnable(digiInfos[id].button, true)
                BlzFrameSetVisible(digiInfos[id].sprite, true)
            end
            unlockedDigiInfos[p][id] = DigimonUnlockedInfo.create()
        end
    end

    ---@param id integer
    ---@param whereToBeFound rect
    local function AddDigimonToList(id, whereToBeFound)
        local list
        local container
        local which = GetObjectName(id)
        if which == GetLocalizedString("ROOKIE_DIGIMON") then
            list = RookiesList
            container = RookiesContainer
        elseif which == GetLocalizedString("CHAMPION_DIGIMON") then
            list = ChampionsList
            container = ChampionsContainer
        elseif which == GetLocalizedString("ULTIMATE_DIGIMON") then
            list = UltimatesList
            container = UltimatesContainer
        elseif which == GetLocalizedString("MEGA_DIGIMON") then
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

            OnClickEvent(button, function (p)
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
        local list
        local container

        udg_BackpackItem = id
        if udg_GoesToBackpack or IsItemFood(id) or IsItemDrink(id) then
            if udg_GoesToBackpack then
                list = MiscsList
                container = MiscsContainer
            elseif IsItemFood(id) then
                list = FoodsList
                container = FoodsContainer
            else
                list = DrinksList
                container = DrinksContainer
            end
            if actualItemRow[list] >= MAX_ITEM_TYPE_PER_ROW then
                actualItemRow[list] = 0
                FrameLoaderAdd(function ()
                    actualItemContainer[list] = BlzCreateFrameByType("BACKDROP", "BACKDROP", container, "", 1)
                    BlzFrameSetPoint(actualItemContainer[list], FRAMEPOINT_TOPLEFT, container, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
                    BlzFrameSetSize(actualItemContainer[list], 0.04*MAX_ITEM_TYPE_PER_ROW, 0.04)
                    BlzFrameSetTexture(actualItemContainer[list], "war3mapImported\\EmptyBTN.blp", 0, true)
                end)
            end

            FrameLoaderAdd(function ()
                ItemTypes[id] = BlzCreateFrame("IconButtonTemplate", actualItemContainer[list], 0, 0)
                BlzFrameSetPoint(ItemTypes[id], FRAMEPOINT_TOPLEFT, actualItemContainer[list], FRAMEPOINT_TOPLEFT, 0.04 * actualItemRow[list], 0.0000)
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

                OnClickEvent(ItemTypes[id], function (p)
                    unlockedItems[p][id] = true

                    if p == LocalPlayer then
                        itemSelected = id
                        UpdateItemInfo()
                    end
                end)

                if actualItemRow[list] == 0 then
                    list:add(actualItemContainer[list])
                end
            end)
            actualItemRow[list] = actualItemRow[list] + 1
        else
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

                OnClickEvent(ItemTypes[id], function (p)
                    if p == LocalPlayer then
                        itemSelected = id
                        UpdateItemInfo()
                    end
                end)

                list:add(ItemTypes[id])
            end)
        end
    end

    local actMaterialIndex = 0

    ---@param id integer
    local function AddMaterial(id)
        isRecipe[id] = false
        local i, j = ModuloInteger(actMaterialIndex, 14), math.floor(actMaterialIndex / 14)
        FrameLoaderAdd(function ()
            ItemTypes[id] = BlzCreateFrame("IconButtonTemplate", MaterialsContainer, 0, 0)
            BlzFrameSetPoint(ItemTypes[id], FRAMEPOINT_TOPLEFT, MaterialsContainer, FRAMEPOINT_TOPLEFT, 0.0000 + i*0.04, 0.0000 - j*0.04)
            BlzFrameSetPoint(ItemTypes[id], FRAMEPOINT_BOTTOMRIGHT, MaterialsContainer, FRAMEPOINT_BOTTOMRIGHT, -0.52000 + i*0.04, 0.080000 - j*0.04)
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

            OnClickEvent(ItemTypes[id], function (p)
                unlockedItems[p][id] = true

                if p == LocalPlayer then
                    recipeMaterialSelected = id
                    UpdateRecipe()
                end
            end)
        end)
        actMaterialIndex = actMaterialIndex + 1
    end

    local actRecipeIndex = 0

    ---@param id integer
    local function AddRecipe(id)
        isRecipe[id] = true
        local i, j = ModuloInteger(actRecipeIndex, 14), math.floor(actRecipeIndex / 14)
        FrameLoaderAdd(function ()
            ItemTypes[id] = BlzCreateFrame("IconButtonTemplate", RecipesContainer, 0, 0)
            BlzFrameSetPoint(ItemTypes[id], FRAMEPOINT_TOPLEFT, RecipesContainer, FRAMEPOINT_TOPLEFT, 0.0000 + i*0.04, 0.0000 - j*0.04)
            BlzFrameSetPoint(ItemTypes[id], FRAMEPOINT_BOTTOMRIGHT, RecipesContainer, FRAMEPOINT_BOTTOMRIGHT, -0.52000 + i*0.04, 0.280000 - j*0.04)
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

            OnClickEvent(ItemTypes[id], function (p)
                unlockedItems[p][id] = true

                if p == LocalPlayer then
                    recipeMaterialSelected = id
                    UpdateRecipe()
                end
            end)
        end)
        actRecipeIndex = actRecipeIndex + 1
    end

    local function OpenMenu()
        if actMenu ~= 0 then
            BlzFrameSetVisible(DigimonsBackdrop, false)
            BlzSetUnitSkin(model, NO_SKIN)
        end
        if actMenu ~= 1 then
            BlzFrameSetVisible(ItemsBackdrop, false)
            BlzSetItemSkin(itemModel, NO_SKIN_ITEM)
        end
        if actMenu ~= 2 then
            BlzFrameSetVisible(RecipesBackdrop, false)
            BlzSetItemSkin(itemModel, NO_SKIN_ITEM)
            BlzSetUnitSkin(sourceModel, NO_SKIN)
            BlzSetSpecialEffectAlpha(sourceGlow, 0)
        end
        if actMenu ~= 3 then
            BlzFrameSetVisible(MapBackdrop, false)
        end

        if actMenu == 0 then
            BlzFrameSetVisible(DigimonsBackdrop, true)
            UpdateInformation()
        elseif actMenu == 1 then
            BlzFrameSetVisible(ItemsBackdrop, true)
            UpdateItemInfo()
        elseif actMenu == 2 then
            BlzFrameSetVisible(RecipesBackdrop, true)
            UpdateRecipe()
        elseif actMenu == 3 then
            BlzSetSpecialEffectAlpha(glow, 0)
            BlzFrameSetVisible(MapBackdrop, true)
            UpdateDigimons()
        end
    end

    local function DigimonsButtonFunc(p)
        if p == LocalPlayer then
            actMenu = 0
            OpenMenu()
        end
    end

    local function ItemsButtonFunc(p)
        if p == LocalPlayer then
            actMenu = 1
            OpenMenu()
        end
    end

    local function RecipesButtonFunc(p)
        if p == LocalPlayer then
            actMenu = 2
            OpenMenu()
        end
    end

    local function MapButtonFunc(p)
        if p == LocalPlayer then
            actMenu = 3
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
                        actMenu = 3
                    end
                else
                    actMenu = actMenu + 1
                    if actMenu > 3 then
                        actMenu = 0
                    end
                end
                OpenMenu()
            end
        end)
    end

    local function RecipeRequirmentButtonFunc(p, i)
        if p == LocalPlayer then
            if unlockedItems[p][requirementList[i]] then
                if isRecipe[recipeMaterialSelected] and GetRecipe(recipeMaterialSelected).itmToUpgrade == requirementList[i] then
                    actMenu = 1
                    OpenMenu()
                    itemSelected = requirementList[i]
                    UpdateItemInfo()
                else
                    recipeMaterialSelected = requirementList[i]
                    UpdateRecipe()
                end
            end
        end
    end

    local function RecipeResultButtonFunc(p)
        if p == LocalPlayer then
            local resultItm = GetRecipe(recipeMaterialSelected).resultItm
            if unlockedItems[p][resultItm] then
                actMenu = 1
                OpenMenu()
                itemSelected = resultItm
                UpdateItemInfo()
            end
        end
    end

    local function DiaryFunc(p)
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

            if MenuWasHidden() then
                ForceUICancel()
            end
        end
    end

    local function ExitFunc(p)
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
        AddDefaultTooltip(Diary, GetLocalizedString("DIARY"), GetLocalizedString("DIARY_TOOLTIP"))
        BlzFrameSetVisible(Diary, false)

        BackdropDiary = BlzCreateFrameByType("BACKDROP", "BackdropSeeMap", Diary, "", 0)
        BlzFrameSetAllPoints(BackdropDiary, Diary)
        BlzFrameSetTexture(BackdropDiary, "ReplaceableTextures\\CommandButtons\\BTNDigiWikiIcon.blp", 0, true)
        OnClickEvent(Diary, DiaryFunc)

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
        BlzFrameSetText(Exit, GetLocalizedString("DIARY_EXIT"))
        BlzFrameSetLevel(Exit, 3)
        OnClickEvent(Exit, ExitFunc)

        -- Digimons

        DigimonsBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetAllPoints(DigimonsBackdrop, Backdrop)
        BlzFrameSetTexture(DigimonsBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetLevel(DigimonsBackdrop, 2)

        DigimonsButton = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.030000)
        BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.71000, 0.54000)
        BlzFrameSetText(DigimonsButton, GetLocalizedString("DIARY_DIGIMONS"))
        BlzFrameSetLevel(DigimonsButton, 3)
        OnClickEvent(DigimonsButton, DigimonsButtonFunc)

        RookiesText = BlzCreateFrameByType("TEXT", "name", DigimonsBackdrop, "", 0)
        BlzFrameSetScale(RookiesText, 2.00)
        BlzFrameSetPoint(RookiesText, FRAMEPOINT_TOPLEFT, DigimonsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.080000)
        BlzFrameSetPoint(RookiesText, FRAMEPOINT_BOTTOMRIGHT, DigimonsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.50000)
        BlzFrameSetText(RookiesText, GetLocalizedString("DIARY_ROOKIES"))
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
        BlzFrameSetText(ChampionsText, GetLocalizedString("DIARY_CHAMPIONS"))
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
        BlzFrameSetText(UltimatesText, GetLocalizedString("DIARY_ULTIMATES"))
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
        BlzFrameSetText(MegasText, GetLocalizedString("DIARY_MEGAS"))
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
        BlzFrameSetText(DigimonAttackTypeLabel, GetLocalizedString("DIARY_ATTACK_TYPE"))
        BlzFrameSetEnable(DigimonAttackTypeLabel, false)
        BlzFrameSetTextAlignment(DigimonAttackTypeLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        DigimonDefenseTypeLabel = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetPoint(DigimonDefenseTypeLabel, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.14000, -0.060000)
        BlzFrameSetPoint(DigimonDefenseTypeLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.45000)
        BlzFrameSetText(DigimonDefenseTypeLabel, GetLocalizedString("DIARY_DEFENSE_TYPE"))
        BlzFrameSetEnable(DigimonDefenseTypeLabel, false)
        BlzFrameSetTextAlignment(DigimonDefenseTypeLabel, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        DigimonStamina = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonStamina, 1.43)
        BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.35000)
        BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.15000)
        BlzFrameSetText(DigimonStamina, GetLocalizedString("DIARY_STAMINA_PER_LEVEL"))
        BlzFrameSetEnable(DigimonStamina, false)
        BlzFrameSetTextAlignment(DigimonStamina, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonDexterity = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonDexterity, 1.43)
        BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.37000)
        BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.13000)
        BlzFrameSetText(DigimonDexterity, GetLocalizedString("DIARY_DEXTERITY_PER_LEVEL"))
        BlzFrameSetEnable(DigimonDexterity, false)
        BlzFrameSetTextAlignment(DigimonDexterity, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonWisdom = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonWisdom, 1.43)
        BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.39000)
        BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.11000)
        BlzFrameSetText(DigimonWisdom, GetLocalizedString("DIARY_WISDOM_PER_LEVEL"))
        BlzFrameSetEnable(DigimonWisdom, false)
        BlzFrameSetTextAlignment(DigimonWisdom, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonEvolvesToLabel = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonEvolvesToLabel, 1.57)
        BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.42000)
        BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.080000)
        BlzFrameSetText(DigimonEvolvesToLabel, GetLocalizedString("DIARY_EVOLVES_TO"))
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
            OnClickEvent(DigimonEvolvesToOptionButton[i], function (p)
                if p == LocalPlayer then
                    local id = digiInfos[digimonSelected].evolveOptions[i].toEvolve
                    if digiInfos[id].name then
                        digimonSelected = id
                        UpdateInformation()
                    else
                        if BlzFrameGetEnable(digiInfos[id].button) and BlzFrameIsVisible(digiInfos[id].button) then
                            BlzFrameClick(digiInfos[id].button)
                        end
                    end
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
        BlzFrameSetText(ItemsButton, GetLocalizedString("DIARY_ITEMS"))
        BlzFrameSetLevel(ItemsButton, 3)
        OnClickEvent(ItemsButton, ItemsButtonFunc)

        ItemsBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetAllPoints(ItemsBackdrop, Backdrop)
        BlzFrameSetTexture(ItemsBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(ItemsBackdrop, false)
        BlzFrameSetLevel(ItemsBackdrop, 2)

        ConsumablesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(ConsumablesText, 2.00)
        BlzFrameSetPoint(ConsumablesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.070000)
        BlzFrameSetPoint(ConsumablesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.51000)
        BlzFrameSetText(ConsumablesText, GetLocalizedString("DIARY_CONSUMABLES"))
        BlzFrameSetEnable(ConsumablesText, false)
        BlzFrameSetTextAlignment(ConsumablesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        MiscText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(MiscText, 1.43)
        BlzFrameSetPoint(MiscText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.10000)
        BlzFrameSetPoint(MiscText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.48500)
        BlzFrameSetText(MiscText, GetLocalizedString("DIARY_MISCELLANEOUS"))
        BlzFrameSetEnable(MiscText, false)
        BlzFrameSetTextAlignment(MiscText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        MiscsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(MiscsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.10000)
        BlzFrameSetPoint(MiscsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.42000)
        BlzFrameSetTexture(MiscsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        MiscsList = FrameList.create(false, MiscsContainer)
        BlzFrameSetPoint(MiscsList.Frame, FRAMEPOINT_TOPLEFT, MiscsContainer, FRAMEPOINT_TOPLEFT, 0.0100000, -0.0200000)
        MiscsList:setSize(0.16, 0.086)
        BlzFrameSetSize(MiscsList.Slider, 0.012, 0.08)

        FoodText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(FoodText, 1.43)
        BlzFrameSetPoint(FoodText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.10000)
        BlzFrameSetPoint(FoodText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.46000, 0.48500)
        BlzFrameSetText(FoodText, GetLocalizedString("DIARY_FOODS"))
        BlzFrameSetEnable(FoodText, false)
        BlzFrameSetTextAlignment(FoodText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        FoodsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(FoodsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.20000, -0.10000)
        BlzFrameSetPoint(FoodsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.44000, 0.42000)
        BlzFrameSetTexture(FoodsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        FoodsList = FrameList.create(false, FoodsContainer)
        BlzFrameSetPoint(FoodsList.Frame, FRAMEPOINT_TOPLEFT, FoodsContainer, FRAMEPOINT_TOPLEFT, 0.0100000, -0.0200000)
        FoodsList:setSize(0.16, 0.086)
        BlzFrameSetSize(FoodsList.Slider, 0.012, 0.08)

        DrinkText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(DrinkText, 1.43)
        BlzFrameSetPoint(DrinkText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.39000, -0.10000)
        BlzFrameSetPoint(DrinkText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.27000, 0.48500)
        BlzFrameSetText(DrinkText, GetLocalizedString("DIARY_DRINKS"))
        BlzFrameSetEnable(DrinkText, false)
        BlzFrameSetTextAlignment(DrinkText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DrinksContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(DrinksContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.39000, -0.10000)
        BlzFrameSetPoint(DrinksContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.25000, 0.42000)
        BlzFrameSetTexture(DrinksContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        DrinksList = FrameList.create(false, DrinksContainer)
        BlzFrameSetPoint(DrinksList.Frame, FRAMEPOINT_TOPLEFT, DrinksContainer, FRAMEPOINT_TOPLEFT, 0.0100000, -0.0200000)
        DrinksList:setSize(0.16, 0.086)
        BlzFrameSetSize(DrinksList.Slider, 0.012, 0.08)

        EquipmentsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(EquipmentsText, 2.00)
        BlzFrameSetPoint(EquipmentsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.21500)
        BlzFrameSetPoint(EquipmentsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.36500)
        BlzFrameSetText(EquipmentsText, GetLocalizedString("DIARY_EQUIPMENTS"))
        BlzFrameSetEnable(EquipmentsText, false)
        BlzFrameSetTextAlignment(EquipmentsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        ShieldsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(ShieldsText, 1.43)
        BlzFrameSetPoint(ShieldsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.24500)
        BlzFrameSetPoint(ShieldsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.34000)
        BlzFrameSetText(ShieldsText, GetLocalizedString("DIARY_SHIELDS"))
        BlzFrameSetEnable(ShieldsText, false)
        BlzFrameSetTextAlignment(ShieldsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        ShieldsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(ShieldsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.26000)
        BlzFrameSetPoint(ShieldsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.30000)
        BlzFrameSetTexture(ShieldsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        ShieldsList = FrameList.create(true, ShieldsContainer)
        BlzFrameSetPoint(ShieldsList.Frame, FRAMEPOINT_TOPLEFT, ShieldsContainer, FRAMEPOINT_TOPLEFT, -0.0400000, -0.000000)
        ShieldsList:setSize(0.6, 0.052)
        BlzFrameSetSize(ShieldsList.Slider, 0.56, 0.012)

        WeaponsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(WeaponsText, 1.43)
        BlzFrameSetPoint(WeaponsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.31550)
        BlzFrameSetPoint(WeaponsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.26950)
        BlzFrameSetText(WeaponsText, GetLocalizedString("DIARY_WEAPONS"))
        BlzFrameSetEnable(WeaponsText, false)
        BlzFrameSetTextAlignment(WeaponsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        WeaponsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(WeaponsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.33000)
        BlzFrameSetPoint(WeaponsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.23000)
        BlzFrameSetTexture(WeaponsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        WeaponsList = FrameList.create(true, WeaponsContainer)
        BlzFrameSetPoint(WeaponsList.Frame, FRAMEPOINT_TOPLEFT, WeaponsContainer, FRAMEPOINT_TOPLEFT, -0.0400000, -0.000000)
        WeaponsList:setSize(0.6, 0.052)
        BlzFrameSetSize(WeaponsList.Slider, 0.56, 0.012)

        AccesoriesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(AccesoriesText, 1.43)
        BlzFrameSetPoint(AccesoriesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.38600)
        BlzFrameSetPoint(AccesoriesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.19900)
        BlzFrameSetText(AccesoriesText, GetLocalizedString("DIARY_ACCESORIES"))
        BlzFrameSetEnable(AccesoriesText, false)
        BlzFrameSetTextAlignment(AccesoriesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        AccesoriesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(AccesoriesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.40000)
        BlzFrameSetPoint(AccesoriesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.16000)
        BlzFrameSetTexture(AccesoriesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        AccesoriesList = FrameList.create(true, AccesoriesContainer)
        BlzFrameSetPoint(AccesoriesList.Frame, FRAMEPOINT_TOPLEFT, AccesoriesContainer, FRAMEPOINT_TOPLEFT, -0.0400000, -0.000000)
        AccesoriesList:setSize(0.6, 0.052)
        BlzFrameSetSize(AccesoriesList.Slider, 0.56, 0.012)

        DigivicesText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(DigivicesText, 1.43)
        BlzFrameSetPoint(DigivicesText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.45650)
        BlzFrameSetPoint(DigivicesText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.12850)
        BlzFrameSetText(DigivicesText, GetLocalizedString("DIARY_DIGIVICES"))
        BlzFrameSetEnable(DigivicesText, false)
        BlzFrameSetTextAlignment(DigivicesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigivicesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(DigivicesContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.47000)
        BlzFrameSetPoint(DigivicesContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.090000)
        BlzFrameSetTexture(DigivicesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        DigivicesList = FrameList.create(true, DigivicesContainer)
        BlzFrameSetPoint(DigivicesList.Frame, FRAMEPOINT_TOPLEFT, DigivicesContainer, FRAMEPOINT_TOPLEFT, -0.0400000, -0.000000)
        DigivicesList:setSize(0.6, 0.052)
        BlzFrameSetSize(DigivicesList.Slider, 0.56, 0.012)

        CrestsText = BlzCreateFrameByType("TEXT", "name", ItemsBackdrop, "", 0)
        BlzFrameSetScale(CrestsText, 1.43)
        BlzFrameSetPoint(CrestsText, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.52700)
        BlzFrameSetPoint(CrestsText, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.058000)
        BlzFrameSetText(CrestsText, GetLocalizedString("DIARY_CRESTS"))
        BlzFrameSetEnable(CrestsText, false)
        BlzFrameSetTextAlignment(CrestsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        CrestsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", ItemsBackdrop, "", 1)
        BlzFrameSetPoint(CrestsContainer, FRAMEPOINT_TOPLEFT, ItemsBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.54000)
        BlzFrameSetPoint(CrestsContainer, FRAMEPOINT_BOTTOMRIGHT, ItemsBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.020000)
        BlzFrameSetTexture(CrestsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        CrestsList = FrameList.create(true, CrestsContainer)
        BlzFrameSetPoint(CrestsList.Frame, FRAMEPOINT_TOPLEFT, CrestsContainer, FRAMEPOINT_TOPLEFT, -0.0400000, -0.000000)
        CrestsList:setSize(0.6, 0.052)
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

        -- Recipes

        RecipesButton = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(RecipesButton, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.18000, -0.030000)
        BlzFrameSetPoint(RecipesButton, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.55000, 0.54000)
        BlzFrameSetText(RecipesButton, GetLocalizedString("DIARY_RECIPES"))
        OnClickEvent(RecipesButton, RecipesButtonFunc)

        RecipesBackdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetAllPoints(RecipesBackdrop, Backdrop)
        BlzFrameSetTexture(RecipesBackdrop, "war3mapImported\\EmptyBTN.blp", 0, true)

        MaterialsLabel = BlzCreateFrameByType("TEXT", "name", RecipesBackdrop, "", 0)
        BlzFrameSetScale(MaterialsLabel, 2.00)
        BlzFrameSetPoint(MaterialsLabel, FRAMEPOINT_TOPLEFT, RecipesBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.070000)
        BlzFrameSetPoint(MaterialsLabel, FRAMEPOINT_BOTTOMRIGHT, RecipesBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.51000)
        BlzFrameSetText(MaterialsLabel, GetLocalizedString("DIARY_MATERIALS_LABEL"))
        BlzFrameSetTextAlignment(MaterialsLabel, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        MaterialsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", RecipesBackdrop, "", 1)
        BlzFrameSetPoint(MaterialsContainer, FRAMEPOINT_TOPLEFT, RecipesBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.10000)
        BlzFrameSetPoint(MaterialsContainer, FRAMEPOINT_BOTTOMRIGHT, RecipesBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.38000)
        BlzFrameSetTexture(MaterialsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        RecipesLabel = BlzCreateFrameByType("TEXT", "name", RecipesBackdrop, "", 0)
        BlzFrameSetScale(RecipesLabel, 2.00)
        BlzFrameSetPoint(RecipesLabel, FRAMEPOINT_TOPLEFT, RecipesBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.23000)
        BlzFrameSetPoint(RecipesLabel, FRAMEPOINT_BOTTOMRIGHT, RecipesBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.65000, 0.35000)
        BlzFrameSetText(RecipesLabel, GetLocalizedString("DIARY_RECIPES_LABEL"))
        BlzFrameSetTextAlignment(RecipesLabel, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        RecipesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", RecipesBackdrop, "", 1)
        BlzFrameSetPoint(RecipesContainer, FRAMEPOINT_TOPLEFT, RecipesBackdrop, FRAMEPOINT_TOPLEFT, 0.010000, -0.26000)
        BlzFrameSetPoint(RecipesContainer, FRAMEPOINT_BOTTOMRIGHT, RecipesBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.23000, 0.020000)
        BlzFrameSetTexture(RecipesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        RecipeMaterialInformation = BlzCreateFrameByType("BACKDROP", "BACKDROP", RecipesBackdrop, "", 1)
        BlzFrameSetPoint(RecipeMaterialInformation, FRAMEPOINT_TOPLEFT, RecipesBackdrop, FRAMEPOINT_TOPLEFT, 0.61000, -0.11000)
        BlzFrameSetPoint(RecipeMaterialInformation, FRAMEPOINT_BOTTOMRIGHT, RecipesBackdrop, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.020000)
        BlzFrameSetTexture(RecipeMaterialInformation, "war3mapImported\\EmptyBTN.blp", 0, true)

        RecipeMaterialName = BlzCreateFrameByType("TEXT", "name", RecipeMaterialInformation, "", 0)
        BlzFrameSetScale(RecipeMaterialName, 1.71)
        BlzFrameSetPoint(RecipeMaterialName, FRAMEPOINT_TOPLEFT, RecipeMaterialInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(RecipeMaterialName, FRAMEPOINT_BOTTOMRIGHT, RecipeMaterialInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.42000)
        BlzFrameSetText(RecipeMaterialName, "|cffFFCC00Agumon|r")
        BlzFrameSetEnable(RecipeMaterialName, false)
        BlzFrameSetTextAlignment(RecipeMaterialName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        RecipeMaterialDescription = BlzCreateFrameByType("TEXT", "name", RecipeMaterialInformation, "", 0)
        BlzFrameSetScale(RecipeMaterialDescription, 1.43)
        BlzFrameSetPoint(RecipeMaterialDescription, FRAMEPOINT_TOPLEFT, RecipeMaterialInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.24000)
        BlzFrameSetPoint(RecipeMaterialDescription, FRAMEPOINT_BOTTOMRIGHT, RecipeMaterialInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetText(RecipeMaterialDescription, "|cffffffffStamina per level: |r")
        BlzFrameSetEnable(RecipeMaterialDescription, false)
        BlzFrameSetTextAlignment(RecipeMaterialDescription, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
        BlzFrameSetLevel(RecipeMaterialDescription, 1)

        RecipeResultButton = BlzCreateFrame("IconButtonTemplate", RecipeMaterialInformation, 0, 0)
        BlzFrameSetPoint(RecipeResultButton, FRAMEPOINT_TOPLEFT, RecipeMaterialInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.24000)
        BlzFrameSetPoint(RecipeResultButton, FRAMEPOINT_BOTTOMRIGHT, RecipeMaterialInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.21700)
        OnClickEvent(RecipeResultButton, RecipeResultButtonFunc)
        BlzFrameSetLevel(RecipeResultButton, 2)

        RecipeRequimentsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", RecipeMaterialInformation, "", 1)
        BlzFrameSetPoint(RecipeRequimentsContainer, FRAMEPOINT_TOPLEFT, RecipeMaterialInformation, FRAMEPOINT_TOPLEFT, 0.020000, -0.27000)
        BlzFrameSetPoint(RecipeRequimentsContainer, FRAMEPOINT_BOTTOMRIGHT, RecipeMaterialInformation, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.020000)
        BlzFrameSetTexture(RecipeRequimentsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetLevel(RecipeRequimentsContainer, 2)

        for i = 0, 14 do
            RecipeRequirmentT[i] = BlzCreateFrameByType("TEXT", "name", RecipeRequimentsContainer, "", 0)
            BlzFrameSetPoint(RecipeRequirmentT[i], FRAMEPOINT_TOPLEFT, RecipeRequimentsContainer, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000 - i*0.012000)
            BlzFrameSetPoint(RecipeRequirmentT[i], FRAMEPOINT_BOTTOMRIGHT, RecipeRequimentsContainer, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.16800 - i*0.012000)
            BlzFrameSetText(RecipeRequirmentT[i], "|cffffffff- A requirment|r")
            BlzFrameSetTextAlignment(RecipeRequirmentT[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            RecipeRequirmentButton[i] = BlzCreateFrame("IconButtonTemplate", RecipeRequirmentT[i], 0, 0)
            BlzFrameSetAllPoints(RecipeRequirmentButton[i], RecipeRequirmentT[i])
            BlzFrameSetEnable(RecipeRequirmentButton[i], false)
            OnClickEvent(RecipeRequirmentButton[i], function (p) RecipeRequirmentButtonFunc(p, i+1) end)
        end

        -- Map

        MapButton = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(MapButton, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.26000, -0.030000)
        BlzFrameSetPoint(MapButton, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.47000, 0.54000)
        BlzFrameSetText(MapButton, GetLocalizedString("DIARY_MAP"))
        BlzFrameSetLevel(MapButton, 3)
        OnClickEvent(MapButton, MapButtonFunc)

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
            for _, list in ipairs({MiscsList, FoodsList, DrinksList}) do
                local buffer = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzFrameGetParent(list.Frame), "", 1)
                BlzFrameSetPoint(buffer, FRAMEPOINT_TOPLEFT, BlzFrameGetParent(list.Frame), FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
                BlzFrameSetSize(buffer, 0.16000, 0.05750)
                BlzFrameSetTexture(buffer, "war3mapImported\\EmptyBTN.blp", 0, true)
                list:add(buffer)
            end
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
        end
        if not unlockedInfo.evolveOptions[toEvolve][condL] then
            unlockedInfo.evolveOptions[toEvolve][condL] = true

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
                local killCount = math.min(kills[owner][kId] + 1, REQUIRED_KILLS_3)
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
                local deathCount = math.min(deaths[owner][dId] + 1, REQUIRED_DEATHS)
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
    ---@param id string
    ---@return UnlockedInfoData
    function SaveDiary(p, slot, id)
        local fileRoot = SaveFile.getPath2(p, slot, udg_DIARY_ROOT)
        local data = UnlockedInfoData.create(p, slot, id)
        local code = EncodeString(p, data:serialize())

        if p == LocalPlayer then
            FileIO.Write(fileRoot, code)
        end

        return data
    end

    ---@param p player
    ---@param slot integer
    ---@return UnlockedInfoData?
    function LoadDiary(p, slot)
        local fileRoot = SaveFile.getPath2(p, slot, udg_DIARY_ROOT)
        local data = UnlockedInfoData.create(slot)
        data.p = p
        local code = GetSyncedData(p, FileIO.Read, fileRoot)

        if code ~= "" then
            local success, decode = xpcall(DecodeString, print, p, code)
            if not success or not decode or not xpcall(data.deserialize, print, data, decode) then
                DisplayTextToPlayer(p, 0, 0, GetLocalizedString("INVALID_FILE"):format(fileRoot))
                return
            end
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

    udg_AddMaterial = CreateTrigger()
    TriggerAddAction(udg_AddMaterial, function ()
        AddMaterial(udg_DigimonItemType)
        udg_DigimonItemType = 0
    end)

    udg_AddRecipe = CreateTrigger()
    TriggerAddAction(udg_AddRecipe, function ()
        AddRecipe(udg_DigimonItemType)
        udg_DigimonItemType = 0
    end)
end)
Debug.endFile()