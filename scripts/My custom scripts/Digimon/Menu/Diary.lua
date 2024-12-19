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
    local DigimonAbilityT = {} ---@type framehandle[]
    local BackdropDigimonAbilityT = {} ---@type framehandle[]
    local DigimonAbilityTooltip = {} ---@type framehandle[]

    local MAX_DIGIMON_TYPE_PER_ROW = 10
    local REQUIRED_KILLS_1 = 50
    local REQUIRED_KILLS_2 = 100
    local REQUIRED_KILLS_3 = 150
    local REQUIRED_DEATHS = 5

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
    ---@field whereToBeFound rect
    ---@field abilities integer[]
    ---@field button framehandle
    ---@field backdrop framehandle
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
    ---@field whereToBeFound boolean
    local DigimonUnlockedInfo = setmetatable({}, Serializable)
    DigimonUnlockedInfo.__index = DigimonUnlockedInfo

    local unlockedInfos = {} ---@type table<player, table<integer, DigimonUnlockedInfo>>
    local kills = {} ---@type table<player, table<integer, integer>>
    local deaths = {} ---@type table<player, table<integer, integer>>
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        unlockedInfos[Player(i)] = {}
        kills[Player(i)] = __jarray(0)
        deaths[Player(i)] = __jarray(0)
    end

    ---@param p player
    ---@param id integer
    function DigimonUnlockedInfo.create(p, id)
        unlockedInfos[p][id] = unlockedInfos[p][id] or setmetatable({
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
    local UnlockedInfoData = setmetatable({}, Serializable)
    UnlockedInfoData.__index = UnlockedInfoData

    ---@param p player
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
            deathCount = {}
        }, UnlockedInfoData)

        for id, info in pairs(unlockedInfos[p]) do
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
    end

    function UnlockedInfoData:deserializeProperties()
        self.amount = self:getIntProperty("amount")
        for i = 1, self.amount do
            self.ids[i] = self:getIntProperty("id" .. i)
            self.infos[i] = DigimonUnlockedInfo.create(self.p, self.ids[i])
            self.infos[i]:deserialize(self:getStringProperty("info"..i))

            unlockedInfos[self.p][self.ids[i]] = self.infos[i]
        end
        self.killAmt = self:getIntProperty("killAmt")
        for i = 1, self.killAmt do
            self.killWho[i] = self:getIntProperty("kw" .. i)
            self.killCount[i] = self:getIntProperty("kc" .. i)

            kills[self.p][self.killWho[i]] = self.killCount[i]
        end
        self.deathAmt = self:getIntProperty("deathAmt")
        for i = 1, self.deathAmt do
            self.deathWho[i] = self:getIntProperty("dw" .. i)
            self.deathCount[i] = self:getIntProperty("dc" .. i)

            deaths[self.p][self.deathWho[i]] = self.deathCount[i]
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

            BlzFrameSetText(DigimonWhere, "|cffffcc00Can be found on: |r" .. (info.whereToBeFound and (unlockedInfo.whereToBeFound and rectNames[info.whereToBeFound] or "???") or "No specific"))

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
        else
            BlzFrameSetVisible(DigimonInformation, false)
        end
    end

    ---@param p player
    ---@param id integer
    local function UnlockButton(p, id)
        if p == LocalPlayer and infos[id] and not BlzFrameGetEnable(infos[id].button) then
            BlzFrameSetTexture(infos[id].backdrop, BlzGetAbilityIcon(id), 0, true)
            BlzFrameSetEnable(infos[id].button, true)
            BlzFrameSetVisible(infos[id].sprite, true)
        end
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

            infos[id] = {
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
                DigimonUnlockedInfo.create(p, id)

                if not infos[id].name then
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
                                infos[id].abilities[1] = spellId
                            elseif x == 1 then
                                infos[id].abilities[2] = spellId
                            elseif x == 2 then
                                infos[id].abilities[3] = spellId
                            end
                        end
                        index = index + 1
                    end

                    infos[id].name = GetHeroProperName(u)
                    infos[id].staPerLvl = BlzGetUnitRealField(u, UNIT_RF_STRENGTH_PER_LEVEL)
                    infos[id].dexPerLvl = BlzGetUnitRealField(u, UNIT_RF_AGILITY_PER_LEVEL)
                    infos[id].wisPerLvl = BlzGetUnitRealField(u, UNIT_RF_INTELLIGENCE_PER_LEVEL)
                    infos[id].evolveOptions = conds and {}

                    RemoveUnit(u)

                    if conds then
                        for i, cond in ipairs(conds) do
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
        BlzFrameSetPoint(DigimonInformation, FRAMEPOINT_TOPLEFT, Backdrop, FRAMEPOINT_TOPLEFT, 0.50978, -0.11000)
        BlzFrameSetPoint(DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, Backdrop, FRAMEPOINT_BOTTOMRIGHT, -0.030220, 0.21000)
        BlzFrameSetTexture(DigimonInformation, "war3mapImported\\EmptyBTN.blp", 0, true)
        BlzFrameSetVisible(DigimonInformation, false)

        DigimonName = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonName, 1.14)
        BlzFrameSetPoint(DigimonName, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.010000)
        BlzFrameSetPoint(DigimonName, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.25000)
        BlzFrameSetText(DigimonName, "|cffFFCC00Agumon|r")
        BlzFrameSetEnable(DigimonName, false)
        BlzFrameSetTextAlignment(DigimonName, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonStamina = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonStamina, 1.14)
        BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.030000)
        BlzFrameSetPoint(DigimonStamina, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.23000)
        BlzFrameSetText(DigimonStamina, "|cffff7d00Stamina per level: |r")
        BlzFrameSetEnable(DigimonStamina, false)
        BlzFrameSetTextAlignment(DigimonStamina, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonDexterity = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonDexterity, 1.14)
        BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.050000)
        BlzFrameSetPoint(DigimonDexterity, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.21000)
        BlzFrameSetText(DigimonDexterity, "|cff007d20Dexterity per level: |r")
        BlzFrameSetEnable(DigimonDexterity, false)
        BlzFrameSetTextAlignment(DigimonDexterity, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonWisdom = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonWisdom, 1.14)
        BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.070000)
        BlzFrameSetPoint(DigimonWisdom, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.19000)
        BlzFrameSetText(DigimonWisdom, "|cff004ec8Wisdom per level: |r")
        BlzFrameSetEnable(DigimonWisdom, false)
        BlzFrameSetTextAlignment(DigimonWisdom, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonEvolvesToLabel = BlzCreateFrameByType("TEXT", "name", DigimonInformation, "", 0)
        BlzFrameSetScale(DigimonEvolvesToLabel, 1.14)
        BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.090000)
        BlzFrameSetPoint(DigimonEvolvesToLabel, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.17000)
        BlzFrameSetText(DigimonEvolvesToLabel, "|cffffcc00Evolves to:|r")
        BlzFrameSetEnable(DigimonEvolvesToLabel, false)
        BlzFrameSetTextAlignment(DigimonEvolvesToLabel, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        DigimonEvolveOptions = BlzCreateFrameByType("BACKDROP", "BACKDROP", DigimonInformation, "", 1)
        BlzFrameSetPoint(DigimonEvolveOptions, FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.010000, -0.11000)
        BlzFrameSetPoint(DigimonEvolveOptions, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.10000)
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
        BlzFrameSetPoint(DigimonWhere, FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.070000)
        BlzFrameSetText(DigimonWhere, "|cffffcc00Can be found on: Native Forest, Acient Dino Region, Gear Savanna.|r")
        BlzFrameSetEnable(DigimonWhere, false)
        BlzFrameSetTextAlignment(DigimonWhere, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        for i = 1, 3 do
            DigimonAbilityT[i] = BlzCreateFrame("IconButtonTemplate", DigimonInformation, 0, 0)
            BlzFrameSetPoint(DigimonAbilityT[i], FRAMEPOINT_TOPLEFT, DigimonInformation, FRAMEPOINT_TOPLEFT, 0.020000, -0.22000)
            BlzFrameSetPoint(DigimonAbilityT[i], FRAMEPOINT_BOTTOMRIGHT, DigimonInformation, FRAMEPOINT_BOTTOMRIGHT, -0.19000, 0.010000)

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

    ---@param d Digimon
    local function register(d)
        local owner = d:getOwner()
        local id = d:getTypeId()
        if IsPlayerInGame(owner) and infos[id] then
            UnlockButton(owner, id)
        end
    end

    Digimon.createEvent:register(register)
    Digimon.capturedEvent:register(function (info)
        register(info.target)
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
            if infos[kId] then
                local killCount = kills[owner][kId] + 1
                kills[owner][kId] = killCount

                local show = false
                if killCount == REQUIRED_KILLS_1 then
                    unlockedInfos[owner][kId].evolveOptions[infos[kId].evolveOptions[1].toEvolve] = __jarray(true)
                    show = true
                elseif killCount == REQUIRED_KILLS_2 then
                    unlockedInfos[owner][kId].evolveOptions[infos[kId].evolveOptions[2].toEvolve] = __jarray(true)
                    show = true
                elseif killCount == REQUIRED_KILLS_3 then
                    unlockedInfos[owner][kId].evolveOptions[infos[kId].evolveOptions[3].toEvolve] = __jarray(true)
                    show = true
                end

                if show and owner == LocalPlayer then
                    BlzFrameSetVisible(infos[kId].sprite, true)
                    UpdateInformation()
                end
            end

            if infos[dId] then
                local deathCount = deaths[owner][dId] + 1
                deaths[owner][dId] = deathCount

                if deathCount == REQUIRED_DEATHS then
                    UnlockButton(owner, dId)
                end
            end
        end
    end)
end)
Debug.endFile()