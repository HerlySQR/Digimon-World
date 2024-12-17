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
    local DigimonEvolvesToOptionButton = {} ---@type framehandle[]
    local DigimonEvolveRequirementsText = {} ---@type framehandle[]

    local MAX_DIGIMON_TYPE_PER_ROW = 10

    local rectNames = __jarray("") ---@type table<rect, string>

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
    ---@field staPerLvl integer
    ---@field dexPerLvl integer
    ---@field wisPerLvl integer
    ---@field evolveOptions EvolveCond[]
    ---@field whereToBeFound Environment[]
    ---@field button framehandle
    ---@field sprite framehandle

    local infos = {} ---@type table<integer, DigimonInfo>

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
            evolveOptions = {},
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
        if digimonSelected ~= -1 and infos[digimonSelected] then
            local info = infos[digimonSelected]
            local unlockedInfo = unlockedInfos[LocalPlayer][digimonSelected]

            BlzFrameSetVisible(DigimonInformation, true)
            BlzFrameSetVisible(info.sprite, false)

            BlzFrameSetText(DigimonName, "|cffFFCC00" .. info.name .. "|r")
            BlzFrameSetText(DigimonStamina, "|cffff7d00Stamina per level: |r" .. (unlockedInfo.staPerLvl and info.staPerLvl or "???"))
            BlzFrameSetText(DigimonDexterity, "|cff007d20Dexterity per level: |r" .. (unlockedInfo.dexPerLvl and info.dexPerLvl or "???"))
            BlzFrameSetText(DigimonWisdom, "|cff004ec8Wisdom per level: |r" .. (unlockedInfo.wisPerLvl and info.wisPerLvl or "???"))

            local conds = info.evolveOptions
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
                        button = button,
                        sprite = sprite
                    }
                    RemoveUnit(u)

                    for i, cond in ipairs(GetEvolutionConditions(id)) do
                        local u2 = CreateUnit(Digimon.NEUTRAL, cond.toEvolve, WorldBounds.minX, WorldBounds.minY, 0)
                        infos[id].evolveOptions[i] = {
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
        BlzFrameSetSize(RookiesList.Slider, 0.012, 0.08)

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

        ChampionsList = FrameList.create(false, ChampionsContainer)
        BlzFrameSetPoint(ChampionsList.Frame, FRAMEPOINT_TOPLEFT, ChampionsContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        BlzFrameSetPoint(ChampionsList.Frame, FRAMEPOINT_TOPRIGHT, ChampionsContainer, FRAMEPOINT_TOPRIGHT, 0.0060000, 0.000000)
        ChampionsList:setSize(BlzFrameGetWidth(ChampionsList.Frame), BlzFrameGetHeight(ChampionsList.Frame))
        BlzFrameSetSize(ChampionsList.Slider, 0.012, 0.08)

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

        UltimatesList = FrameList.create(false, UltimatesContainer)
        BlzFrameSetPoint(UltimatesList.Frame, FRAMEPOINT_TOPLEFT, UltimatesContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        BlzFrameSetPoint(UltimatesList.Frame, FRAMEPOINT_TOPRIGHT, UltimatesContainer, FRAMEPOINT_TOPRIGHT, 0.0060000, 0.000000)
        UltimatesList:setSize(BlzFrameGetWidth(UltimatesList.Frame), BlzFrameGetHeight(UltimatesList.Frame))
        BlzFrameSetSize(UltimatesList.Slider, 0.012, 0.08)

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

        MegasList = FrameList.create(false, MegasContainer)
        BlzFrameSetPoint(MegasList.Frame, FRAMEPOINT_TOPLEFT, MegasContainer, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        BlzFrameSetPoint(MegasList.Frame, FRAMEPOINT_TOPRIGHT, MegasContainer, FRAMEPOINT_TOPRIGHT, 0.0060000, 0.000000)
        MegasList:setSize(BlzFrameGetWidth(MegasList.Frame), BlzFrameGetHeight(MegasList.Frame))
        BlzFrameSetSize(MegasList.Slider, 0.012, 0.08)

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

            DigimonEvolvesToOptionButton[i] = BlzCreateFrame("IconButtonTemplate", DigimonEvolvesToOption[i], 0, 0)
            BlzFrameSetAllPoints(DigimonEvolvesToOptionButton[i], DigimonEvolvesToOption[i])
            BlzFrameSetEnable(DigimonEvolvesToOptionButton[i], false)
            local t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, DigimonEvolvesToOptionButton[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function ()
                if GetTriggerPlayer() == LocalPlayer then
                    digimonSelected = infos[digimonSelected].evolveOptions[i].toEvolve
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

    Digimon.levelUpEvent:register(function (d)
        local id = d:getTypeId()
        if not infos[id] then
            return
        end
        local owner = d:getOwner()

        local unlockedInfo = unlockedInfos[owner][id]
        unlockedInfo.staPerLvl = true
        unlockedInfo.dexPerLvl = true
        unlockedInfo.wisPerLvl = true

        if owner == LocalPlayer then
            BlzFrameSetVisible(infos[id].sprite, true)
            UpdateInformation()
        end
    end)

    OnEvolveCond(function (d, toEvolve, condL)
        local id = d:getTypeId()
        if not infos[id] then
            return
        end

        local owner = d:getOwner()
        local unlockedInfo = unlockedInfos[owner][id]

        unlockedInfo.evolveOptions[toEvolve] = unlockedInfo.evolveOptions[toEvolve] or __jarray(false)
        unlockedInfo.evolveOptions[toEvolve][condL] = true

        if owner == LocalPlayer then
            BlzFrameSetVisible(infos[id].sprite, true)
            UpdateInformation()
        end
    end)
end)
Debug.endFile()