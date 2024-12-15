Debug.beginFile("Diary")
OnInit("Diary", function ()
    local FrameList = Require "FrameList" ---@type FrameList
    Require "DigimonEvolution"
    Require "Environment"
    Require "Serializable"

    local Backdrop = nil ---@type framehandle
    local Exit = nil ---@type framehandle
    local DigimonsButton = nil ---@type framehandle
    local ItemsButton = nil ---@type framehandle
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
    local DigimonStamina = nil ---@type framehandle
    local DigimonDexterity = nil ---@type framehandle
    local DigimonWisdom = nil ---@type framehandle
    local DigimonEvolvesToLabel = nil ---@type framehandle
    local DigimonEvolveOptions = nil ---@type framehandle
    local DigimonWhere = nil ---@type framehandle
    local DigimonEvolvesToOption = {} ---@type framehandle[]
    local DigimonEvolveRequirementsText = {} ---@type framehandle[]

    local MAX_DIGIMON_TYPE_PER_ROW = 10

    local rectNames = __jarray("") ---@type table<rect, string>

    ---@class EvolveCond
    ---@field label string
    ---@field tooltip string

    ---@class DigimonInfo
    ---@field name string
    ---@field staPerLvl integer
    ---@field dexPerLvl integer
    ---@field wisPerLvl integer
    ---@field evolveOptions EvolveCond[]
    ---@field whereToBeFound Environment[]
    ---@field button framehandle

    local infos = {} ---@type table<integer, DigimonInfo>

    ---@class DigimonUnlockedInfo : Serializable
    ---@field staPerLvl boolean
    ---@field dexPerLvl boolean
    ---@field wisPerLvl boolean
    ---@field evolveOptions table<integer, boolean>
    ---@field whereToBeFound table<string, boolean>
    local DigimonUnlockedInfo = setmetatable({}, Serializable)
    DigimonUnlockedInfo.__index = DigimonUnlockedInfo

    local unlockedInfos = {} ---@type table<player, table<integer, DigimonUnlockedInfo>>
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        unlockedInfos[Player(i)] = {}
    end

    function DigimonUnlockedInfo.create(p, id)
        unlockedInfos[p][id] = unlockedInfos[p][id] or setmetatable({
            staPerLvl = false,
            dexPerLvl = false,
            wisPerLvl = false,
            evolveOptions = __jarray(false),
            whereToBeFound = __jarray(false)
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
            self:addProperty("ueid" .. evoAmt, unlocked)
        end
        self:addProperty("evoAmt", evoAmt)
        local envAmt = 0
        for name, unlocked in pairs(self.whereToBeFound) do
            envAmt = envAmt + 1
            self:addProperty("enid" .. envAmt, name)
            self:addProperty("uenid" .. envAmt, unlocked)
        end
        self:addProperty("envAmt", envAmt)
    end

    function DigimonUnlockedInfo:deserializeProperties()
        self.staPerLvl = self:getBoolProperty("sPL")
        self.dexPerLvl = self:getBoolProperty("dPL")
        self.wisPerLvl = self:getBoolProperty("wPL")
        local evoAmt = self:getIntProperty("evoAmt")
        for i = 1, evoAmt do
            self.evolveOptions[self:getIntProperty("eid" .. i)] = self:getBoolProperty("ueid" .. i)
        end
        local envAmt = self:getIntProperty("envAmt")
        for i = 1, envAmt do
            self.whereToBeFound[self:getStringProperty("enid" .. i)] = self:getBoolProperty("uenid" .. i)
        end
    end

    ---@class UnlockedInfoData : Serializable
    ---@field p player
    ---@field amount integer
    ---@field ids integer[]
    ---@field infos DigimonUnlockedInfo[]
    local UnlockedInfoData = setmetatable({}, Serializable)
    UnlockedInfoData.__index = UnlockedInfoData

    ---@param p player
    function UnlockedInfoData.create(p)
        local self = setmetatable({
            p = p,
            amount = 0,
            ids = {},
            infos = {}
        }, UnlockedInfoData)

        for id, info in pairs(unlockedInfos[p]) do
            self.amount = self.amount + 1
            self.ids[self.amount] = id
            self.infos[self.amount] = info
        end
    end

    function UnlockedInfoData:serializeProperties()
        self:addProperty("amount", self.amount)
        for i = 1, self.amount do
            self:addProperty("id" .. i, self.ids[i])
            self:addProperty("info"..i, self.infos[i]:serialize())
        end
    end

    function UnlockedInfoData:deserializeProperties()
        self.amount = self:getIntProperty("amount")
        for i = 1, self.amount do
            self.ids[i] = self:getIntProperty("id" .. i)
            self.infos[i] = DigimonUnlockedInfo.create(self.p)
            self.infos[i]:deserialize(self:getStringProperty("info"..i))
        end
    end

    local LocalPlayer = GetLocalPlayer()
    local digimonSelected = -1
    local actualContainer = {} ---@type table<FrameList, framehandle>
    local actualRow = __jarray(MAX_DIGIMON_TYPE_PER_ROW) ---@type table<FrameList, integer>

    local function UpdateInformation()
        if digimonSelected ~= -1 then
            local info = infos[digimonSelected]
            local unlockedInfo = unlockedInfos[LocalPlayer][digimonSelected]

            BlzFrameSetVisible(DigimonInformation, true)

            BlzFrameSetText(DigimonName, "|cffFFCC00" .. info.name .. "|r")
            BlzFrameSetText(DigimonStamina, "|cffff7d00Stamina per level: |r" .. (unlockedInfo.staPerLvl and info.staPerLvl or "???"))
            BlzFrameSetText(DigimonDexterity, "|cff007d20Dexterity per level: |r" .. (unlockedInfo.dexPerLvl and info.dexPerLvl or "???"))
            BlzFrameSetText(DigimonWisdom, "|cff004ec8Wisdom per level: |r" .. (unlockedInfo.wisPerLvl and info.wisPerLvl or "???"))

            local conds = info.evolveOptions
            for i = 1, 7 do
                if conds[i] then
                    BlzFrameSetText(DigimonEvolvesToOption[i], conds[i].label)
                    BlzFrameSetText(DigimonEvolveRequirementsText[i], conds[i].tooltip)
                    BlzFrameSetSize(DigimonEvolveRequirementsText[i], 0.17, 0)
                    BlzFrameSetVisible(DigimonEvolvesToOption[i], true)
                else
                    BlzFrameSetVisible(DigimonEvolvesToOption[i], false)
                end
            end

            local result
            if #info.whereToBeFound > 1 then
                result = ""
                for i = 1, #info.whereToBeFound do
                    local env = info.whereToBeFound[i]
                    result = ", " .. (unlockedInfo[env.name] and env.displayName or "???")
                end
                result = result:sub(3)
            else
                result = "No specific"
            end
            BlzFrameSetText(DigimonWhere, "|cffffcc00Can be found on: |r" .. result)
        else
            BlzFrameSetVisible(DigimonInformation, false)
        end
    end

    ---@param id integer
    ---@param whereToBeFound string[]
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

            local backdrop = BlzCreateFrameByType("BACKDROP", "DigimonType[" .. id .. "]", button, "", 0)
            BlzFrameSetAllPoints(backdrop, button)
            BlzFrameSetTexture(backdrop, BlzGetAbilityIcon(id), 0, true)
            local t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, button, FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function ()
                local p = GetTriggerPlayer()
                DigimonUnlockedInfo.create(p, id)

                if not infos[id] then
                    local u = CreateUnit(Digimon.NEUTRAL, id, WorldBounds.minX, WorldBounds.minY, 0)
                    infos[id] = {
                        name = GetHeroProperName(u),
                        staPerLvl = BlzGetUnitRealField(u, UNIT_RF_STRENGTH_PER_LEVEL),
                        dexPerLvl = BlzGetUnitRealField(u, UNIT_RF_AGILITY_PER_LEVEL),
                        wisPerLvl = BlzGetUnitRealField(u, UNIT_RF_INTELLIGENCE_PER_LEVEL),
                        evolveOptions = {},
                        whereToBeFound = {},
                        button = button
                    }
                    RemoveUnit(u)

                    for i, cond in ipairs(GetEvolutionConditions(id)) do
                        local u2 = CreateUnit(Digimon.NEUTRAL, cond.toEvolve, WorldBounds.minX, WorldBounds.minY, 0)
                        infos[id].evolveOptions[i] = {
                            label = GetHeroProperName(u2),
                            tooltip = "- Have level " .. cond.level
                        }
                        RemoveUnit(u2)

                        local result = infos[id].evolveOptions[i].tooltip
                        if cond.stone then
                            result = result .. "\n- Hold the " .. GetObjectName(cond.stone) .. " item."
                        end
                        if cond.place then
                            result = result .. "\n- Stay on " .. rectNames[cond.place] .. "."
                        end
                        if cond.str then
                            result = result .. "\n- Get " .. cond.str .. " stamina."
                        end
                        if cond.agi then
                            result = result .. "\n- Get " .. cond.agi .. " dexterity."
                        end
                        if cond.int then
                            result = result .. "\n- Get " .. cond.int .. " wisdom."
                        end
                        if cond.onlyDay then
                            result = result .. "\n- Only during day."
                        elseif cond.onlyNight then
                            result = result .. "\n- Only during night."
                        end
                        infos[id].evolveOptions[i].tooltip = result
                    end
                    for i = 1, #whereToBeFound do
                        infos[id].whereToBeFound[i] = Environment.get(whereToBeFound[i])
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

    local function ExitFunc()
        
    end

    local function DigimonsButtonFunc()
        
    end

    local function ItemsButtonFunc()
        
    end

    local function MapButtonFunc()
        
    end

    FrameLoaderAdd(function ()
        Backdrop = BlzCreateFrameByType("BACKDROP", "BACKDROP", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 1)
        BlzFrameSetAbsPoint(Backdrop, FRAMEPOINT_TOPLEFT, 0.00000, 0.600000)
        BlzFrameSetAbsPoint(Backdrop, FRAMEPOINT_BOTTOMRIGHT, 0.800000, 0.00000)
        BlzFrameSetTexture(Backdrop, "war3mapImported\\EmptyBTN.blp", 0, true)

        Exit = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(Exit, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.71000, -0.030000)
        BlzFrameSetPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.54000)
        BlzFrameSetText(Exit, "|cffFCD20DExit|r")
        BlzFrameSetScale(Exit, 1.00)
        TriggerExit = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerExit, Exit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerExit, ExitFunc)

        DigimonsButton = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.030000)
        BlzFrameSetPoint(DigimonsButton, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.71000, 0.54000)
        BlzFrameSetText(DigimonsButton, "|cffFCD20DDigimons|r")
        BlzFrameSetScale(DigimonsButton, 1.00)
        TriggerDigimonsButton = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerDigimonsButton, DigimonsButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerDigimonsButton, DigimonsButtonFunc)

        ItemsButton = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(ItemsButton, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.10000, -0.030000)
        BlzFrameSetPoint(ItemsButton, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.63000, 0.54000)
        BlzFrameSetText(ItemsButton, "|cffFCD20DItems|r")
        BlzFrameSetScale(ItemsButton, 1.00)
        TriggerItemsButton = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerItemsButton, ItemsButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerItemsButton, ItemsButtonFunc)

        MapButton = BlzCreateFrame("ScriptDialogButton", Backdrop, 0, 0)
        BlzFrameSetPoint(MapButton, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.18000, -0.030000)
        BlzFrameSetPoint(MapButton, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.55000, 0.54000)
        BlzFrameSetText(MapButton, "|cffFCD20DMap|r")
        BlzFrameSetScale(MapButton, 1.00)
        TriggerMapButton = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerMapButton, MapButton, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerMapButton, MapButtonFunc)

        RookiesText = BlzCreateFrameByType("TEXT", "name", Backdrop, "", 0)
        BlzFrameSetScale(RookiesText, 2.00)
        BlzFrameSetPoint(RookiesText, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.080000)
        BlzFrameSetPoint(RookiesText, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.64000, 0.50000)
        BlzFrameSetText(RookiesText, "|cffFFCC00Rookies|r")
        BlzFrameSetEnable(RookiesText, false)
        BlzFrameSetTextAlignment(RookiesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        RookiesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetPoint(RookiesContainer, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.11000)
        BlzFrameSetPoint(RookiesContainer, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.38000, 0.41000)
        BlzFrameSetTexture(RookiesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        RookiesList = FrameList.create(false, RookiesContainer)
        BlzFrameSetPoint(RookiesList.Frame, FRAMEPOINT_TOPLEFT, RookiesContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        BlzFrameSetPoint(RookiesList.Frame, FRAMEPOINT_TOPRIGHT, RookiesContainer, FRAMEPOINT_TOPRIGHT, 0.0060000, 0.000000)
        RookiesList:setSize(BlzFrameGetWidth(RookiesList.Frame), BlzFrameGetHeight(RookiesList.Frame))

        ChampionsText = BlzCreateFrameByType("TEXT", "name", Backdrop, "", 0)
        BlzFrameSetScale(ChampionsText, 2.00)
        BlzFrameSetPoint(ChampionsText, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.20000)
        BlzFrameSetPoint(ChampionsText, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.64000, 0.38000)
        BlzFrameSetText(ChampionsText, "|cffFFCC00Champions|r")
        BlzFrameSetEnable(ChampionsText, false)
        BlzFrameSetTextAlignment(ChampionsText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        ChampionsContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetPoint(ChampionsContainer, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.23000)
        BlzFrameSetPoint(ChampionsContainer, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.38000, 0.29000)
        BlzFrameSetTexture(ChampionsContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        UltimatesText = BlzCreateFrameByType("TEXT", "name", Backdrop, "", 0)
        BlzFrameSetScale(UltimatesText, 2.00)
        BlzFrameSetPoint(UltimatesText, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.32000)
        BlzFrameSetPoint(UltimatesText, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.64000, 0.26000)
        BlzFrameSetText(UltimatesText, "|cffFFCC00Ultimates|r")
        BlzFrameSetEnable(UltimatesText, false)
        BlzFrameSetTextAlignment(UltimatesText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        UltimatesContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetPoint(UltimatesContainer, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.35000)
        BlzFrameSetPoint(UltimatesContainer, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.38000, 0.17000)
        BlzFrameSetTexture(UltimatesContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        MegasText = BlzCreateFrameByType("TEXT", "name", Backdrop, "", 0)
        BlzFrameSetScale(MegasText, 2.00)
        BlzFrameSetPoint(MegasText, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020320, -0.43948)
        BlzFrameSetPoint(MegasText, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.63968, 0.14052)
        BlzFrameSetText(MegasText, "|cffFFCC00Megas|r")
        BlzFrameSetEnable(MegasText, false)
        BlzFrameSetTextAlignment(MegasText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        MegasContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetPoint(MegasContainer, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.020000, -0.47000)
        BlzFrameSetPoint(MegasContainer, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.38000, 0.050000)
        BlzFrameSetTexture(MegasContainer, "war3mapImported\\EmptyBTN.blp", 0, true)

        DigimonInformation = BlzCreateFrameByType("BACKDROP", "BACKDROP", Backdrop, "", 1)
        BlzFrameSetAbsPoint(DigimonInformation, FRAMEPOINT_TOPLEFT, 0.510000, 0.490000)
        BlzFrameSetAbsPoint(DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, 0.770000, 0.250000)
        BlzFrameSetTexture(DigimonInformation, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(DigimonInformation, false)

        DigimonName = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonName, 1.14)
        BlzFrameSetPoint(DigimonName, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(DigimonName, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.21000)
        BlzFrameSetText(DigimonName, "|cffFFCC00Agumon|r")
        BlzFrameSetEnable(DigimonName, false)
        BlzFrameSetTextAlignment(DigimonName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonStamina = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonStamina, 1.14)
        BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.19000)
        BlzFrameSetText(DigimonStamina, "|cffff7d00Stamina per level: |r")
        BlzFrameSetEnable(DigimonStamina, false)
        BlzFrameSetTextAlignment(DigimonStamina, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonDexterity = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonDexterity, 1.14)
        BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.050000)
        BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.17000)
        BlzFrameSetText(DigimonDexterity, "|cff007d20Dexterity per level: |r")
        BlzFrameSetEnable(DigimonDexterity, false)
        BlzFrameSetTextAlignment(DigimonDexterity, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonWisdom = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonWisdom, 1.14)
        BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.070000)
        BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.15000)
        BlzFrameSetText(DigimonWisdom, "|cff004ec8Wisdom per level: |r")
        BlzFrameSetEnable(DigimonWisdom, false)
        BlzFrameSetTextAlignment(DigimonWisdom, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonEvolvesToLabel = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonEvolvesToLabel, 1.14)
        BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.090000)
        BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.13000)
        BlzFrameSetText(DigimonEvolvesToLabel, "|cffffcc00Evolves to:|r")
        BlzFrameSetEnable(DigimonEvolvesToLabel, false)
        BlzFrameSetTextAlignment(DigimonEvolvesToLabel, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonEvolveOptions = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonInformation, "", 1)
        BlzFrameSetPoint(DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.11000)
        BlzFrameSetPoint(DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.060000)
        BlzFrameSetTexture(DigimonEvolveOptions, "war3mapImported\\EmptyBTN.blp", 0, true)

        for i = 1, 7 do
            DigimonEvolvesToOption[i] = BlzCreateFrameByType("TEXT", "name", DigimonEvolveOptions, "", 0)
            BlzFrameSetPoint(DigimonEvolvesToOption[i], FRAMEPOINT_TOPLEFT, DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, 0.0000, -0.010000*(i-1))
            BlzFrameSetPoint(DigimonEvolvesToOption[i], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.060000 - 0.010000*(i-1))
            BlzFrameSetText(DigimonEvolvesToOption[i], "|cffffffff- Greymon|r")
            BlzFrameSetEnable(DigimonEvolvesToOption[i], false)
            BlzFrameSetTextAlignment(DigimonEvolvesToOption[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            local dummyButton = BlzCreateFrame("IconButtonTemplate", DigimonEvolvesToOption[i], 0, 0)
            BlzFrameSetAllPoints(dummyButton, DigimonEvolvesToOption[i])
            BlzFrameSetEnable(dummyButton, false)

            local tooltip = BlzCreateFrame("QuestButtonBaseTemplate", DigimonEvolvesToOption[i], 0, 0)

            DigimonEvolveRequirementsText[i] = BlzCreateFrameByType("TEXT", "name", tooltip, "", 0)
            BlzFrameSetPoint(DigimonEvolveRequirementsText[i], FRAMEPOINT_BOTTOMRIGHT, DigimonEvolvesToOption[i], FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
            BlzFrameSetText(DigimonEvolveRequirementsText[i], "|cffFFCC00Requires:\n- Level 20\n- Common Digivice\n- Stay on Acient Dino Region|r")
            BlzFrameSetEnable(DigimonEvolveRequirementsText[i], false)
            BlzFrameSetTextAlignment(DigimonEvolveRequirementsText[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
            BlzFrameSetSize(DigimonEvolveRequirementsText[i], 0.17, 0)

            BlzFrameSetPoint(tooltip, FRAMEPOINT_TOPLEFT, DigimonEvolveRequirementsText[i], FRAMEPOINT_TOPLEFT, -0.0150000, 0.0150000)
            BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOMRIGHT, DigimonEvolveRequirementsText[i], FRAMEPOINT_BOTTOMRIGHT, 0.0150000, -0.0150000)

            BlzFrameSetTooltip(dummyButton, tooltip)
        end

        DigimonWhere = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonWhere, 1.14)
        BlzFrameSetPoint(DigimonWhere, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.19000)
        BlzFrameSetPoint(DigimonWhere, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.010000)
        BlzFrameSetText(DigimonWhere, "|cffffcc00Can be found on: Native Forest, Acient Dino Region, Gear Savanna.|r")
        BlzFrameSetEnable(DigimonWhere, false)
        BlzFrameSetTextAlignment(DigimonWhere, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)
    end)

    udg_AddDigimonToList = CreateTrigger()
    TriggerAddAction(udg_AddDigimonToList, function ()
        AddDigimonToList(
            udg_DigimonType,
            udg_DigimonWhereToFind
        )
        udg_DigimonType = 0
        udg_DigimonWhereToFind = __jarray("")
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
    end)

    udg_DigimonSetRectName = CreateTrigger()
    TriggerAddAction(udg_DigimonSetRectName, function ()
        rectNames[udg_DigimonRect] = udg_DigimonRectName
        udg_DigimonRect = nil
        udg_DigimonRectName = ""
    end)
end)
Debug.endFile()