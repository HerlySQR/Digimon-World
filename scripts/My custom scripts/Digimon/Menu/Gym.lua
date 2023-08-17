Debug.beginFile("Gym")
OnInit(function ()
    Require "PvP"
    Require "FrameLoader"
    Require "PlayerUtils"
    Require "Set"
    Require "AbilityUtils"
    Require "Timed"
    Require "DigimonBank"
    Require "ErrorMessage"
    Require "NewBonus"
    Require "AddHook"

    local LocalPlayer = GetLocalPlayer()
    local MAX_ARENAS = 4
    local MAX_FIGHTERS = 2
    local MAX_DIGIMONS = udg_MAX_DIGIMONS
    local MAX_RANK = 99
    local RANK_UPGRADE = FourCC('R005')
    local RANK_PRIZES =
    { ---@type {equips: integer?, damage: integer?, defense: number?, health: integer?, energy: integer?}[]
        [1] =   {equips = nil,    damage = 1,     defense = nil,      health = nil,   energy = nil},
        [2] =   {equips = nil,    damage = 1,     defense = 0.5,      health = nil,   energy = nil},
        [3] =   {equips = 2,      damage = 1,     defense = 0.5,      health = 10,    energy = nil},
        [4] =   {equips = nil,    damage = 2,     defense = 0.5,      health = 10,    energy = 5},
        [5] =   {equips = nil,    damage = 2,     defense = 0.5,      health = 10,    energy = 5},
        [6] =   {equips = nil,    damage = 2,     defense = 0.5,      health = 10,    energy = 5},
        [7] =   {equips = 2,      damage = 2,     defense = 0.5,      health = 10,    energy = 5},
        [8] =   {equips = nil,    damage = 3,     defense = 1.5,      health = 20,    energy = 10},
        [9] =   {equips = nil,    damage = 3,     defense = 1.5,      health = 20,    energy = 10},
        [10] =  {equips = nil,    damage = 3,     defense = 1.5,      health = 20,    energy = 10},
        [11] =  {equips = nil,    damage = 3,     defense = 1.5,      health = 20,    energy = 10},
        [12] =  {equips = 2,      damage = 3,     defense = 1.5,      health = 20,    energy = 10},
        [13] =  {equips = nil,    damage = 4,     defense = 2,        health = 30,    energy = 15},
        [14] =  {equips = nil,    damage = 4,     defense = 2,        health = 30,    energy = 15},
        [15] =  {equips = nil,    damage = 4,     defense = 2,        health = 30,    energy = 15},
        [16] =  {equips = nil,    damage = 4,     defense = 2,        health = 30,    energy = 15},
        [17] =  {equips = nil,    damage = 4,     defense = 2,        health = 30,    energy = 15},
        [18] =  {equips = 2,      damage = 4,     defense = 2,        health = 30,    energy = 15},
        [19] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 40,    energy = 20},
        [21] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 40,    energy = 20},
        [22] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 40,    energy = 20},
        [23] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 40,    energy = 20},
        [24] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 40,    energy = 20},
        [25] =  {equips = 3,      damage = 6,     defense = 3,        health = 50,    energy = 25}
    }

    local GymMenu = nil ---@type framehandle
    local Select = nil ---@type framehandle
    local Ban = nil ---@type framehandle
    local Ready = nil ---@type framehandle
    local Remaining = nil ---@type framehandle
    local PlayerName = {} ---@type framehandle[]
    local PlayerSelections = {} ---@type framehandle[]
    local PlayerBans = {} ---@type framehandle[]
    local PlayerDigimonT = {} ---@type framehandle[][]
    local BackdropPlayerDigimonT = {} ---@type framehandle[][]
    local PlayerDigimonClicked = {} ---@type framehandle[][]
    local PlayerDigimonSelected = {} ---@type framehandle[][]
    local PlayerDigimonBanned = {} ---@type framehandle[][]
    local FIGHT = nil ---@type framehandle

    local DigimonTypes = {} ---@type integer[][]
    for i = 0, MAX_RANK do
        DigimonTypes[i] = {}
    end

    local PVP_TICKET = FourCC('I03A')
    local ARENA_TICKET = FourCC('I03B')
    local LOBBY = gg_rct_Gym_Lobby ---@type rect

    local UsedArena = __jarray(false) ---@type boolean[]

    ---@alias playerIndex
    ---| 0 # None
    ---| 1
    ---| 2

    ---@class PlayerInfo
    ---@field p player
    ---@field index playerIndex
    ---@field clicked integer
    ---@field clickedGroup playerIndex
    ---@field selectedDigimons Set
    ---@field bannedDigimons Set
    ---@field aliveDigimons integer
    ---@field availableSelects integer
    ---@field availableBans integer
    ---@field votedStart boolean
    ---@field digimonsInArena Set

    ---@class FightInfo
    ---@field index integer
    ---@field pi PlayerInfo[]
    ---@field arena rect
    ---@field selectTime number
    ---@field fightTime integer
    ---@field votedStart integer
    ---@field rank integer
    ---@field level integer
    ---@field env Environment
    ---@field clock timer
    ---@field clockWindow timerdialog
    local FightInfo = {}
    FightInfo.__index = FightInfo

    ---@return boolean
    function FightInfo:localPlayerCond()
        for i = 1, MAX_FIGHTERS do
            if self.pi[i].p == LocalPlayer then
                return true
            end
        end
        return false
    end

    ---@param p player
    ---@return PlayerInfo?
    function FightInfo:getPlayerInfo(p)
        for i = 1, MAX_FIGHTERS do
            if self.pi[i].p == p then
                return self.pi[i]
            end
        end
    end

    function FightInfo:clear()
        for i = 1, MAX_FIGHTERS do
            local info = self.pi[i]
            info.p = nil
            info.selectedDigimons:clear()
            info.bannedDigimons:clear()
            info.clicked = -1
            info.clickedGroup = 0
            info.availableSelects = 0
            info.availableBans = 0
            info.votedStart = false
            info.digimonsInArena:clear()
        end
        self.selectTime = 0
        self.fightTime = 0
        self.votedStart = 0
        self.rank = 0
    end

    function FightInfo:autoSelect()
        for i = 1, MAX_FIGHTERS do
            local info = self.pi[i]
            if info.availableSelects > 0 then
                for j = 0, MAX_DIGIMONS do
                    local d = GetBankDigimon(info.p, j)
                    if d and GetDigimonCooldown(d) <= 0
                        and not info.selectedDigimons:contains(j)
                        and not info.bannedDigimons:contains(j) then

                        info.selectedDigimons:addSingle(j)
                        info.availableSelects = info.availableSelects - 1
                        if info.availableSelects <= 0 then break end
                    end
                end
            end
        end
    end

    function FightInfo:start()
        local centerX, centerY = GetRectCenterX(self.arena), GetRectCenterY(self.arena)
        local paused = {} ---@type Digimon[]
        for i = 1, MAX_FIGHTERS do
            local info = self.pi[i]
            if info.p == Digimon.NEUTRAL then
                local list = DigimonTypes[self.rank]
                self.level = list[#list]
                for j = 1, 3 do
                    if list[j] then
                        local angle = math.pi*(j/4 + (i-1))
                        local d = Digimon.create(Digimon.NEUTRAL, list[j],
                        centerX + 500*math.cos(angle), centerY + 500*math.sin(angle),
                        90 + 180*i)
                        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", d:getPos()))
                        info.digimonsInArena:addSingle(d)
                        d:setLevel(self.level)
                        d:pause()
                        table.insert(paused, d)
                    end
                end
            else
                local n = info.selectedDigimons:size()
                local m = 0
                for j in info.selectedDigimons:elements() do
                    m = m + 1
                    SummonDigimon(info.p, j)
                    local d = GetBankDigimon(info.p, j)
                    local angle = math.pi*(m/(n+1) + (i-1))
                    d:setPos(centerX + 500*math.cos(angle), centerY + 500*math.sin(angle))
                    d:setFacing(90 + 180*i)
                    DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", d:getPos()))
                    info.digimonsInArena:addSingle(d)
                    d.environment = self.env
                    d:pause()
                    table.insert(paused, d)
                end
                self.env:apply(info.p, true)
            end
        end
        if self:localPlayerCond() then
            PanCameraToTimed(GetRectCenterX(self.arena), GetRectCenterY(self.arena), 0)
        end
        Timed.call(function ()
            if self:localPlayerCond() then
                PanCameraTo(GetRectCenterX(self.arena), GetRectCenterY(self.arena))
            end
        end)
        Timed.call(2., function ()
            if self:localPlayerCond() then
                BlzFrameSetScale(FIGHT, 12.5)
                BlzFrameSetText(FIGHT, "|cff00ff003|r")
                BlzFrameSetVisible(FIGHT, true)
            end
            Timed.call(1., function ()
                if self:localPlayerCond() then
                    BlzFrameSetScale(FIGHT, 13.9)
                    BlzFrameSetText(FIGHT, "|cffffff002|r")
                end
                Timed.call(1., function ()
                    if self:localPlayerCond() then
                        BlzFrameSetScale(FIGHT, 15.3)
                        BlzFrameSetText(FIGHT, "|cffff00001|r")
                    end
                    Timed.call(1., function ()
                        if self:localPlayerCond() then
                            BlzFrameSetText(FIGHT, "|cffff0000FIGHT!|r")
                        end
                        Timed.call(1., function ()
                            if self:localPlayerCond() then
                                BlzFrameSetVisible(FIGHT, false)
                                TimerDialogDisplay(self.clockWindow, true)
                                ShowMenu(true)
                            end
                            for _, d in ipairs(paused) do
                                d:unpause()
                            end
                            TimerStart(self.clock, 300., false, function ()
                                self:finish()
                            end)
                        end)
                    end)
                end)
            end)
        end)
    end

    function FightInfo:finish()
        local winner ---@type PlayerInfo
        local loser ---@type PlayerInfo
        for i = 1, MAX_FIGHTERS do
            local info = self.pi[i]
            if info.digimonsInArena:isEmpty() then
                loser = info
            else
                winner = info
            end
            for d in info.digimonsInArena:elements() do
                d:setInvulnerable(true)
            end
        end

        if not loser then
            if self:localPlayerCond() then
                DisplayTextToPlayer(LocalPlayer, 0, 0, "Draw")
            end
        else
            if self:localPlayerCond() then
                DisplayTextToPlayer(LocalPlayer, 0, 0, "The winner is " .. User[winner.p]:getNameColored() .. ".")
            end
        end

        if self:localPlayerCond() then
            TimerDialogDisplay(self.clockWindow, false)
        end
        PauseTimer(self.clock)

        Timed.call(2., function ()
            for i = 1, MAX_FIGHTERS do
                local info = self.pi[i]
                for d in info.digimonsInArena:elements() do
                    d:setInvulnerable(false)
                    if not d:isHidden() then
                        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", d:getPos()))
                    end
                    if info.p ~= Digimon.NEUTRAL then
                        StoreToBank(info.p, d, true)
                    else
                        d:destroy()
                    end
                end
            end
            Timed.call(4., function ()
                if loser.p == Digimon.NEUTRAL then
                    SetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED, GetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED) + 1)
                    SetPlayerTechResearched(winner.p, RANK_UPGRADE, GetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED))
                end
                local notNeutral = true
                for i = 1, MAX_FIGHTERS do
                    local info = self.pi[i]
                    if info.p ~= Digimon.NEUTRAL then
                        ResumeRevive(info.p)
                        for j = 0, MAX_DIGIMONS - 1 do
                            local d = GetBankDigimon(info.p, j)
                            if d then
                                d:revive(0, 0)
                                d.environment = Environment.gymLobby
                                SetSpawnPoint(info.p, GetRectCenterX(LOBBY), GetRectCenterY(LOBBY))
                                SummonDigimon(info.p, j)
                                break
                            end
                        end
                        if winner == info and loser.p == Digimon.NEUTRAL then
                            local prizes = RANK_PRIZES[GetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED)]
                            local message = "\nFor winning all your digimons will gain: \n"
                            if prizes.damage then
                                message = message .. "» " .. prizes.damage .. " damage attack\n"
                            end
                            if prizes.defense then
                                message = message .. "» " .. prizes.defense .. " defense\n"
                            end
                            if prizes.health then
                                message = message .. "» " .. prizes.health .. " health\n"
                            end
                            if prizes.energy then
                                message = message .. "» " .. prizes.energy .. " energy"
                            end
                            if prizes.equips then
                                message = message .. "\nAnd also " .. prizes.equips .. " items unlocked in the shop."
                            end
                            DisplayTextToPlayer(winner.p, 0, 0, message)
                            if winner.p == LocalPlayer then
                                StartSound(bj_questItemAcquiredSound)
                            end
                        end
                    else
                        notNeutral = false
                    end
                    ShowBank(info.p, true)
                    if i > 1 then
                        DisablePvP(info.p, self.pi[i-1].p)
                    end
                end
                if notNeutral then
                    SetPlayerAllianceStateBJ(self.pi[1].p, self.pi[2].p, bj_ALLIANCE_ALLIED_VISION)
                    SetPlayerAllianceStateBJ(self.pi[2].p, self.pi[1].p, bj_ALLIANCE_ALLIED_VISION)
                end
                self:clear()
                UsedArena[self.index] = false
            end)
        end)
    end

    local oldSetUnitOwner
    oldSetUnitOwner = AddHook("SetUnitOwner", function (whichUnit, whichPlayer, changeColor)
        local prevOwner = GetOwningPlayer(whichUnit)

        oldSetUnitOwner(whichUnit, whichPlayer, changeColor)

        local oldRank = IsPlayerInForce(prevOwner, FORCE_PLAYING) and GetPlayerState(prevOwner, PLAYER_STATE_RESOURCE_FOOD_USED) or 0
        local newRank = IsPlayerInForce(whichPlayer, FORCE_PLAYING) and GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_FOOD_USED) or 0

        if oldRank > 0 then
            local prizes = RANK_PRIZES[oldRank]
            if prizes.damage then
                AddUnitBonus(whichUnit, BONUS_DAMAGE, -prizes.damage)
            end
            if prizes.defense then
                AddUnitBonus(whichUnit, BONUS_ARMOR, -prizes.defense)
            end
            if prizes.health then
                AddUnitBonus(whichUnit, BONUS_HEALTH, -prizes.health)
            end
            if prizes.energy then
                AddUnitBonus(whichUnit, BONUS_MANA, -prizes.energy)
            end
        end
        if newRank > 0 then
            local prizes = RANK_PRIZES[newRank]
            if prizes.damage then
                AddUnitBonus(whichUnit, BONUS_DAMAGE, prizes.damage)
            end
            if prizes.defense then
                AddUnitBonus(whichUnit, BONUS_ARMOR, prizes.defense)
            end
            if prizes.health then
                AddUnitBonus(whichUnit, BONUS_HEALTH, prizes.health)
            end
            if prizes.energy then
                AddUnitBonus(whichUnit, BONUS_MANA, prizes.energy)
            end
        end
    end)

    local oldCreateUnit
    oldCreateUnit = AddHook("CreateUnit", function (owningPlayer, unitid, x, y, face)
        local u = oldCreateUnit(owningPlayer, unitid, x, y, face)

        if u then
            local rank = IsPlayerInForce(owningPlayer, FORCE_PLAYING) and GetPlayerState(owningPlayer, PLAYER_STATE_RESOURCE_FOOD_USED) or 0
            if rank > 0 then
                local prizes = RANK_PRIZES[rank]
                if prizes.damage then
                    AddUnitBonus(u, BONUS_DAMAGE, prizes.damage)
                end
                if prizes.defense then
                    AddUnitBonus(u, BONUS_ARMOR, prizes.defense)
                end
                if prizes.health then
                    AddUnitBonus(u, BONUS_HEALTH, prizes.health)
                end
                if prizes.energy then
                    AddUnitBonus(u, BONUS_MANA, prizes.energy)
                end
            end
        end

        return u
    end)

    local FightInfos = {} ---@type FightInfo[]

    OnInit.final(function ()
        for i = 1, MAX_ARENAS do
            local fight = setmetatable({
                index = i,
                pi = {},
                arena = _G["gg_rct_Gym_Arena_" .. i],
                selectTime = 0,
                fightTime = 0,
                votedStart = 0,
                rank = 0,
                env = Environment.gymArena[i],
                clock = CreateTimer()
            }, FightInfo)

            fight.clockWindow = CreateTimerDialog(fight.clock)
            TimerDialogDisplay(fight.clockWindow, false)

            for j = 1, MAX_FIGHTERS do
                fight.pi[j] = {
                    p = nil,
                    aliveDigimons = 0,
                    index = j,
                    selectedDigimons = Set.create(),
                    bannedDigimons = Set.create(),
                    clicked = -1,
                    clickedGroup = 0,
                    availableSelects = 0,
                    availableBans = 0,
                    votedStart = false,
                    digimonsInArena = Set.create()
                }
            end

            local t = CreateTrigger()
            TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_DEATH)
            TriggerAddAction(t, function ()
                local u = GetDyingUnit()
                if RectContainsUnit(fight.arena, u) then
                    local d = Digimon.getInstance(u)
                    local p = GetOwningPlayer(u)
                    local info = fight:getPlayerInfo(p)
                    if info then
                        info.digimonsInArena:removeSingle(d)
                        if info.digimonsInArena:isEmpty() then
                            fight:finish()
                        end
                    end
                end
            end)

            FightInfos[i] = fight
        end
    end)

    ---@return integer?
    local function GetFreeArena()
        for i = 1, MAX_ARENAS do
            if not UsedArena[i] then
                UsedArena[i] = true
                return i
            end
        end
    end

    -- Player vs Player

    local function UpdateMenu()
        local fight = FightInfos[LocalPlayer]
        local info1 = fight.pi[1]
        local info2 = fight.pi[2]

        for i = 0, MAX_DIGIMONS - 1 do
            BlzFrameSetVisible(PlayerDigimonSelected[1][i], info1.selectedDigimons:contains(i))
            BlzFrameSetVisible(PlayerDigimonBanned[1][i], info1.bannedDigimons:contains(i))

            BlzFrameSetVisible(PlayerDigimonSelected[2][i], info2.selectedDigimons:contains(i))
            BlzFrameSetVisible(PlayerDigimonBanned[2][i], info2.bannedDigimons:contains(i))
        end

        if info1.p == LocalPlayer then
            local i = info1.clicked
            if info1.clickedGroup == 1 then
                BlzFrameSetEnable(Select, not info1.bannedDigimons:contains(i) and info1.aliveDigimons > 3)
                BlzFrameSetEnable(Ban, false)
                BlzFrameSetText(Select, "|cffFCD20D" .. (info1.selectedDigimons:contains(i) and "Unselect" or "Select") .. "|r")
            elseif info1.clickedGroup == 2 then
                BlzFrameSetEnable(Select, false)
                BlzFrameSetEnable(Ban, not info2.selectedDigimons:contains(i) and info2.aliveDigimons > 3)
                BlzFrameSetText(Ban, "|cffFCD20D" .. (info2.bannedDigimons:contains(i) and "Unban" or "Ban") .. "|r")
            end
            BlzFrameSetEnable(Ready, info1.availableSelects == 0)
            BlzFrameSetText(Ready, "|cffFCD20D" .. (info1.votedStart and "I'm not ready" or "I'm ready") .. "|r")
        elseif info2.p == LocalPlayer then
            local i = info2.clicked
            if info2.clickedGroup == 2 then
                BlzFrameSetEnable(Select, not info2.bannedDigimons:contains(i) and info2.aliveDigimons > 3)
                BlzFrameSetEnable(Ban, false)
                BlzFrameSetText(Select, "|cffFCD20D" .. (info2.selectedDigimons:contains(i) and "Unselect" or "Select") .. "|r")
            elseif info2.clickedGroup == 1 then
                BlzFrameSetEnable(Select, false)
                BlzFrameSetEnable(Ban, not info1.selectedDigimons:contains(i) and info1.aliveDigimons > 3)
                BlzFrameSetText(Ban, "|cffFCD20D" .. (info1.bannedDigimons:contains(i) and "Unban" or "Ban") .. "|r")
            end
            BlzFrameSetEnable(Ready, info2.availableSelects == 0)
            BlzFrameSetText(Ready, "|cffFCD20D" .. (info2.votedStart and "I'm not ready" or "I'm ready") .. "|r")
        end

        BlzFrameSetText(PlayerSelections[1], "Selections: " .. info1.availableSelects)
        BlzFrameSetText(PlayerBans[1], "Bans: " .. info1.availableBans)

        BlzFrameSetText(PlayerSelections[2], "Selections: " .. info2.availableSelects)
        BlzFrameSetText(PlayerBans[2], "Bans: " .. info2.availableBans)
    end

    local function SelectFunc()
        local p = GetTriggerPlayer()
        local fight = FightInfos[p]
        local info = fight:getPlayerInfo(p)

        if info then
            if info.selectedDigimons:contains(info.clicked) then
                info.selectedDigimons:removeSingle(info.clicked)
                info.availableSelects = info.availableSelects + 1
            else
                info.selectedDigimons:addSingle(info.clicked)
                info.availableSelects = info.availableSelects - 1
            end

            if fight:localPlayerCond() then
                UpdateMenu()
            end
        end
    end

    local function BanFunc()
        local p = GetTriggerPlayer()
        local fight = FightInfos[p]
        local info = fight:getPlayerInfo(p)

        if info then
            local otherInfo = fight.pi[info.clickedGroup]
            if otherInfo.bannedDigimons:contains(info.clicked) then
                otherInfo.bannedDigimons:removeSingle(info.clicked)
                info.availableBans = info.availableBans + 1
            else
                otherInfo.bannedDigimons:addSingle(info.clicked)
                info.availableBans = info.availableBans - 1
            end

            if fight:localPlayerCond() then
                UpdateMenu()
            end
        end
    end

    local function ReadyFunc()
        local p = GetTriggerPlayer()
        local fight = FightInfos[p]
        local info = fight:getPlayerInfo(p)

        if info then
            info.votedStart = not info.votedStart
            if info.votedStart then
                fight.votedStart = fight.votedStart + 1
            else
                fight.votedStart = fight.votedStart - 1
            end

            if fight:localPlayerCond() then
                UpdateMenu()
            end

            if fight.votedStart == MAX_FIGHTERS then
                Timed.call(2., function ()
                    if fight.votedStart == MAX_FIGHTERS then
                        fight.selectTime = math.min(fight.selectTime, 3)
                    end
                end)
            end
        end
    end

    ---@param i integer
    ---@param j integer
    local function PlayerDigimonFunc(i, j)
        local p = GetTriggerPlayer()
        local fight = FightInfos[p]
        local info = fight:getPlayerInfo(p)

        if info then
            if p == LocalPlayer then
                if info.clicked ~= -1 then
                    BlzFrameSetVisible(PlayerDigimonSelected[info.clickedGroup][info.clicked], false)
                    BlzFrameSetVisible(PlayerDigimonSelected[j][i], true)
                end
            end

            info.clicked = i
            info.clickedGroup = j

            if fight:localPlayerCond() then
                UpdateMenu()
            end
        end
    end

    local function InitFrames()
        GymMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        BlzFrameSetAbsPoint(GymMenu, FRAMEPOINT_TOPLEFT, 0.070000, 0.56000)
        BlzFrameSetAbsPoint(GymMenu, FRAMEPOINT_BOTTOMRIGHT, 0.730000, 0.130000)
        BlzFrameSetVisible(GymMenu, false)

        Select = BlzCreateFrame("ScriptDialogButton", GymMenu, 0, 0)
        BlzFrameSetPoint(Select, FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.16500, -0.27500)
        BlzFrameSetPoint(Select, FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.27500, 0.035000)
        BlzFrameSetText(Select, "|cffFCD20DSelect|r")
        BlzFrameSetScale(Select, 1.29)
        local t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Select, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, SelectFunc)

        Ban = BlzCreateFrame("ScriptDialogButton", GymMenu, 0, 0)
        BlzFrameSetPoint(Ban, FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.28500, -0.27500)
        BlzFrameSetPoint(Ban, FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.15500, 0.035000)
        BlzFrameSetText(Ban, "|cffFCD20DBan|r")
        BlzFrameSetScale(Ban, 1.29)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Ban, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, BanFunc)

        Ready = BlzCreateFrame("ScriptDialogButton", GymMenu, 0, 0)
        BlzFrameSetPoint(Ready, FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.40500, -0.27500)
        BlzFrameSetPoint(Ready, FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.035000, 0.035000)
        BlzFrameSetText(Ready, "|cffFCD20DI'm ready|r")
        BlzFrameSetScale(Ready, 1.29)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Ready, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, ReadyFunc)

        Remaining = BlzCreateFrameByType("TEXT", "name", GymMenu, "", 0)
        BlzFrameSetPoint(Remaining, FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.040000, -0.27500)
        BlzFrameSetPoint(Remaining, FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.40000, 0.035000)
        BlzFrameSetText(Remaining, "|cffffffffReamain: 0|r")
        BlzFrameSetEnable(Remaining, false)
        BlzFrameSetScale(Remaining, 1.29)
        BlzFrameSetTextAlignment(Remaining, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
        BlzFrameSetTextAlignment(Remaining, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

        for j = 1, MAX_FIGHTERS do
            PlayerName[j] = BlzCreateFrameByType("TEXT", "name", GymMenu, "", 0)
            BlzFrameSetPoint(PlayerName[j], FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.040000, -0.040000 - (j-1) * 0.12)
            BlzFrameSetPoint(PlayerName[j], FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.38000, 0.28000 - (j-1) * 0.12)
            BlzFrameSetText(PlayerName[j], "|cffFFCC00Name|r")
            BlzFrameSetEnable(PlayerName[j], false)
            BlzFrameSetScale(PlayerName[j], 1.29)
            BlzFrameSetTextAlignment(PlayerName[j], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            PlayerSelections[j] = BlzCreateFrameByType("TEXT", "name", GymMenu, "", 0)
            BlzFrameSetPoint(PlayerSelections[j], FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.21500, -0.040000 - (j-1) * 0.12)
            BlzFrameSetPoint(PlayerSelections[j], FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.20500, 0.28000 - (j-1) * 0.12)
            BlzFrameSetText(PlayerSelections[j], "|cffffffffSelections: 0|r")
            BlzFrameSetEnable(PlayerSelections[j], false)
            BlzFrameSetScale(PlayerSelections[j], 1.29)
            BlzFrameSetTextAlignment(PlayerSelections[j], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            PlayerBans[j] = BlzCreateFrameByType("TEXT", "name", GymMenu, "", 0)
            BlzFrameSetPoint(PlayerBans[j], FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.39000, -0.040000 - (j-1) * 0.125)
            BlzFrameSetPoint(PlayerBans[j], FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.28000 - (j-1) * 0.125)
            BlzFrameSetText(PlayerBans[j], "|cffffffffBans: 0|r")
            BlzFrameSetEnable(PlayerBans[j], false)
            BlzFrameSetScale(PlayerBans[j], 1.29)
            BlzFrameSetTextAlignment(PlayerBans[j], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            PlayerDigimonT[j] = {}
            BackdropPlayerDigimonT[j] = {}
            PlayerDigimonClicked[j] = {}
            PlayerDigimonSelected[j] = {}
            PlayerDigimonBanned[j] = {}

            for i = 0, MAX_DIGIMONS - 1 do
                PlayerDigimonT[j][i] = BlzCreateFrame("IconButtonTemplate", GymMenu, 0, 0)
                BlzFrameSetPoint(PlayerDigimonT[j][i], FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.03500 + i * 0.075, -0.10000 - (j-1) * 0.165)
                BlzFrameSetPoint(PlayerDigimonT[j][i], FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.555 + i * 0.075, 0.2700 - (j-1) * 0.165)

                BackdropPlayerDigimonT[j][i] = BlzCreateFrameByType("BACKDROP", "BackdropPlayerDigimonT[" .. j .. "][" .. i .. "]", PlayerDigimonT[j][i], "", 0)
                BlzFrameSetAllPoints(BackdropPlayerDigimonT[j][i], PlayerDigimonT[j][i])
                BlzFrameSetTexture(BackdropPlayerDigimonT[j][i], "CustomFrame.png", 0, true)
                t = CreateTrigger()
                BlzTriggerRegisterFrameEvent(t, PlayerDigimonT[j][i], FRAMEEVENT_CONTROL_CLICK)
                TriggerAddAction(t, function () PlayerDigimonFunc(i, j) end)

                PlayerDigimonClicked[j][i] = BlzCreateFrameByType("BACKDROP", "PlayerDigimonClicked[" .. j .. "][" .. i .. "]", PlayerDigimonT[j][i], "", 1)
                BlzFrameSetAllPoints(PlayerDigimonClicked[j][i], PlayerDigimonT[j][i])
                BlzFrameSetTexture(PlayerDigimonClicked[j][i], "UI\\Widgets\\EscMenu\\Human\\checkbox-background.blp", 0, true)
                BlzFrameSetLevel(PlayerDigimonClicked[j][i], 3)
                BlzFrameSetVisible(PlayerDigimonClicked[j][i], false)

                PlayerDigimonSelected[j][i] = BlzCreateFrameByType("BACKDROP", "PlayerDigimonSelected[" .. j .. "][" .. i .. "]", PlayerDigimonT[j][i], "", 1)
                BlzFrameSetAllPoints(PlayerDigimonSelected[j][i], PlayerDigimonT[j][i])
                BlzFrameSetTexture(PlayerDigimonSelected[j][i], "war3mapImported\\check.blp", 0, true)
                BlzFrameSetLevel(PlayerDigimonSelected[j][i], 2)
                BlzFrameSetVisible(PlayerDigimonSelected[j][i], false)

                PlayerDigimonBanned[j][i] = BlzCreateFrameByType("BACKDROP", "PlayerDigimonBanned[" .. j .. "][" .. i .. "]", PlayerDigimonT[j][i], "", 1)
                BlzFrameSetAllPoints(PlayerDigimonBanned[j][i], PlayerDigimonT[j][i])
                BlzFrameSetTexture(PlayerDigimonBanned[j][i], "war3mapImported\\cross.blp", 0, true)
                BlzFrameSetLevel(PlayerDigimonBanned[j][i], 2)
                BlzFrameSetVisible(PlayerDigimonBanned[j][i], false)
            end
        end

        FIGHT = BlzCreateFrameByType("TEXT", "FIGHT", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), "", 0)
        BlzFrameSetAbsPoint(FIGHT, FRAMEPOINT_TOPLEFT, 0.160000, 0.480000)
        BlzFrameSetAbsPoint(FIGHT, FRAMEPOINT_BOTTOMRIGHT, 0.640000, 0.280000)
        BlzFrameSetText(FIGHT, "|cff00ff003|r")
        BlzFrameSetEnable(FIGHT, false)
        BlzFrameSetScale(FIGHT, 12.5)
        BlzFrameSetTextAlignment(FIGHT, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_MIDDLE)
        BlzFrameSetVisible(FIGHT, false)
    end

    FrameLoaderAdd(InitFrames)

    local SelectPlayer = {} ---@type table<player, dialog>
    local PlayerOptions = {} ---@type table<player, Set>
    local PlayerClicked = {} ---@type table<player, button[]>
    local PlayerSelected = {} ---@type table<player, player>
    local WannaPvP = CreateForce()

    OnInit.final(function ()
        ForForce(FORCE_PLAYING, function ()
            SelectPlayer[GetEnumPlayer()] = DialogCreate()
            PlayerOptions[GetEnumPlayer()] = Set.create()
        end)
    end)

    ---@param p player
    local function UpdateDialog(p)
        DialogClear(SelectPlayer[p])
        DialogSetMessage(SelectPlayer[p], "Who do you want to fight?")
        PlayerClicked[p] = {}

        local index = 0
        for v in PlayerOptions[p]:elements() do
            index = index + 1
            PlayerClicked[p][index] = DialogAddButton(SelectPlayer[p], User[v]:getNameColored() .. " (" .. (PlayerSelected[v] == p and "Accept" or "Challenge") .. ")", 0)
        end

        DialogAddButton(SelectPlayer[p], "Cancel", 0)
    end

    ---@param p1 player
    local function AddPlayers(p1)
        ForForce(FORCE_PLAYING, function ()
            local p2 = GetEnumPlayer()
            if p1 ~= p2 then
                if BlzForceHasPlayer(WannaPvP, p2) then
                    if not PlayerOptions[p1]:contains(p2) then
                        PlayerOptions[p1]:addSingle(p2)
                    end
                else
                    if PlayerOptions[p1]:contains(p2) then
                        PlayerOptions[p1]:removeSingle(p2)
                        if PlayerSelected[p1] == p2 then
                            PlayerSelected[p1] = nil
                        end
                    end
                end
            end
        end)
        UpdateDialog(p1)
    end

    OnInit.final(function ()
        -- Check players in lobby
        Timed.echo(0.5, function ()
            ForceClear(WannaPvP)
            ForUnitsInRect(LOBBY, function (u)
                if UnitHasItemOfTypeBJ(u, PVP_TICKET) then
                    ForceAddPlayer(WannaPvP, GetOwningPlayer(u))
                end
            end)
        end)
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_USE_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == PVP_TICKET end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetManipulatingUnit())
            if not RectContainsUnit(LOBBY, GetManipulatingUnit()) then
                ErrorMessage("You can only use this ticket in the gym lobby.", p)
                return
            end
            AddPlayers(p)
            if not PlayerOptions[p]:isEmpty() then
                DialogDisplay(p, SelectPlayer[p], true)
            end
        end)
    end

    do
        local t = CreateTrigger()
        TriggerRegisterLeaveRectSimple(t, LOBBY)
        TriggerAddAction(t, function ()
            ForForce(WannaPvP, function ()
                AddPlayers(GetEnumPlayer())
            end)
        end)
    end

    ---@param p1 player
    ---@param p2 player
    ---@param arena integer
    local function StartFight(p1, p2, arena)
        ShowBank(p1, false)
        ShowBank(p2, false)
        if p2 ~= Digimon.NEUTRAL then
            DisplayTextToForce(WannaPvP, User[p1]:getNameColored() .. " and " .. User[p2]:getNameColored() .. " will fight.")
            PlayerSelected[p1] = nil
            PlayerSelected[p2] = nil

            ForceRemovePlayer(WannaPvP, p1)
            ForceRemovePlayer(WannaPvP, p2)
            ForForce(WannaPvP, function ()
                AddPlayers(GetEnumPlayer())
            end)

            for _, d in ipairs(GetUsedDigimons(p1)) do
                StoreToBank(p1, d, true)
            end

            for _, d in ipairs(GetUsedDigimons(p2)) do
                StoreToBank(p2, d, true)
            end

            SetPlayerAllianceStateBJ(p1, p2, bj_ALLIANCE_UNALLIED)
            SetPlayerAllianceStateBJ(p2, p1, bj_ALLIANCE_UNALLIED)
            EnablePvP(p1, p2)
            SuspendRevive(p1)
            SuspendRevive(p2)

            local available1 = 0
            local available2 = 0
            for i = 0, MAX_DIGIMONS - 1 do
                local d = GetBankDigimon(p1, i)
                if d and GetDigimonCooldown(d) <= 0 then
                    available1 = available1 + 1
                end

                d = GetBankDigimon(p2, i)
                if d and GetDigimonCooldown(d) <= 0 then
                    available2 = available2 + 1
                end
            end

            local canSelect1 = available1 > 3 and 3 or 0
            local canBan1 = math.max(math.min(available2 - 3), 0)
            local canSelect2 = available2 > 3 and 3 or 0
            local canBan2 = math.max(math.min(available1 - 3, 3), 0)
            local fight = FightInfos[arena]

            local info = fight.pi[1]
            info.p = p1
            info.aliveDigimons = available1
            info.availableSelects = canSelect1
            info.availableBans = canBan1
            FightInfos[p1] = fight
            if info.availableSelects == 0 then
                for i = 0, MAX_DIGIMONS - 1 do
                    local d = GetBankDigimon(p1, i)
                    if d and GetDigimonCooldown(d) <= 0 then
                        info.selectedDigimons:addSingle(i)
                    end
                end
            end

            info = fight.pi[2]
            info.p = p2
            info.aliveDigimons = available2
            info.availableSelects = canSelect2
            info.availableBans = canBan2
            FightInfos[p2] = fight
            if info.availableSelects == 0 then
                for i = 0, MAX_DIGIMONS - 1 do
                    local d = GetBankDigimon(p2, i)
                    if d and GetDigimonCooldown(d) <= 0 then
                        info.selectedDigimons:addSingle(i)
                    end
                end
            end

            fight.selectTime = 60.
            Timed.echo(1., function ()
                fight.selectTime = fight.selectTime - 1
                if fight:localPlayerCond() then
                    BlzFrameSetText(Remaining, "Remain: " .. math.floor(fight.selectTime))
                end
                if fight.selectTime <= 0 then
                    fight:autoSelect()
                    if fight:localPlayerCond() then
                        UpdateMenu()
                    end
                    Timed.call(2., function ()
                        if fight:localPlayerCond() then
                            ShowMenu(true)
                            BlzFrameSetVisible(GymMenu, false)
                        end
                        fight:start()
                    end)
                    return true
                end
            end)

            if p1 == LocalPlayer or p2 == LocalPlayer then
                HideMenu(true)

                BlzFrameSetText(Remaining, "Remain: " .. math.floor(fight.selectTime))

                BlzFrameSetText(PlayerName[1], User[p1]:getNameColored())
                BlzFrameSetText(PlayerName[2], User[p2]:getNameColored())

                for i = 0, MAX_DIGIMONS - 1 do
                    local d = GetBankDigimon(p1, i)
                    if d and GetDigimonCooldown(d) <= 0 then
                        BlzFrameSetTexture(BackdropPlayerDigimonT[1][i], BlzGetAbilityIcon(d:getTypeId()), 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[1][i], true)
                    else
                        BlzFrameSetTexture(BackdropPlayerDigimonT[1][i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[1][i], false)
                    end
                    BlzFrameSetVisible(PlayerDigimonClicked[1][i], false)

                    d = GetBankDigimon(p2, i)
                    if d and GetDigimonCooldown(d) <= 0 then
                        BlzFrameSetTexture(BackdropPlayerDigimonT[2][i], BlzGetAbilityIcon(d:getTypeId()), 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[2][i], true)
                    else
                        BlzFrameSetTexture(BackdropPlayerDigimonT[2][i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[2][i], false)
                    end
                    BlzFrameSetVisible(PlayerDigimonClicked[2][i], false)
                end

                UpdateMenu()

                BlzFrameSetVisible(GymMenu, true)
            end
        else
            DisplayTextToForce(WannaPvP, User[p1]:getNameColored() .. " accepted challenge the gym.")

            ForceRemovePlayer(WannaPvP, p1)
            ForForce(WannaPvP, function ()
                AddPlayers(GetEnumPlayer())
            end)

            for _, d in ipairs(GetUsedDigimons(p1)) do
                StoreToBank(p1, d, true)
            end

            EnablePvP(p1, p2)
            SuspendRevive(p1)

            local available = 0
            for i = 0, MAX_DIGIMONS - 1 do
                local d = GetBankDigimon(p1, i)
                if d and GetDigimonCooldown(d) <= 0 then
                    available = available + 1
                end
            end

            local fight = FightInfos[arena]

            local info = fight.pi[1]
            info.p = p1
            info.aliveDigimons = available
            info.availableSelects = available > 3 and 3 or 0
            info.availableBans = 0
            FightInfos[p1] = fight

            if info.availableSelects == 0 then
                for i = 0, MAX_DIGIMONS - 1 do
                    local d = GetBankDigimon(p1, i)
                    if d and GetDigimonCooldown(d) <= 0 then
                        info.selectedDigimons:addSingle(i)
                    end
                end
            end

            info = fight.pi[2]
            info.p = Digimon.NEUTRAL
            info.aliveDigimons = 0
            info.availableSelects = 0
            info.availableBans = 0
            info.votedStart = true
            FightInfos[p2] = fight
            fight.votedStart = 1
            fight.rank = GetPlayerState(p1, PLAYER_STATE_RESOURCE_FOOD_USED)

            fight.selectTime = 60.
            Timed.echo(1., function ()
                fight.selectTime = fight.selectTime - 1
                if p1 == LocalPlayer then
                    BlzFrameSetText(Remaining, "Remain: " .. math.floor(fight.selectTime))
                end
                if fight.selectTime <= 0 then
                    fight:autoSelect()
                    if p1 == LocalPlayer then
                        UpdateMenu()
                    end
                    Timed.call(2., function ()
                        if p1 == LocalPlayer then
                            BlzFrameSetVisible(GymMenu, false)
                        end
                        fight:start()
                    end)
                    return true
                end
            end)

            if p1 == LocalPlayer then
                HideMenu(true)

                BlzFrameSetText(Remaining, "Remain: " .. math.floor(fight.selectTime))

                BlzFrameSetText(PlayerName[1], User[p1]:getNameColored())
                BlzFrameSetText(PlayerName[2], User[p2]:getNameColored())

                for i = 0, MAX_DIGIMONS - 1 do
                    local d = GetBankDigimon(p1, i)
                    if d and GetDigimonCooldown(d) <= 0 then
                        BlzFrameSetTexture(BackdropPlayerDigimonT[1][i], BlzGetAbilityIcon(d:getTypeId()), 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[1][i], true)
                    else
                        BlzFrameSetTexture(BackdropPlayerDigimonT[1][i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[1][i], false)
                    end
                    BlzFrameSetVisible(PlayerDigimonClicked[1][i], false)

                    BlzFrameSetTexture(BackdropPlayerDigimonT[2][i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    BlzFrameSetEnable(PlayerDigimonT[2][i], false)
                    BlzFrameSetVisible(PlayerDigimonClicked[2][i], false)
                    BlzFrameSetVisible(PlayerDigimonSelected[2][i], false)
                    BlzFrameSetVisible(PlayerDigimonBanned[2][i], false)
                end

                UpdateMenu()

                BlzFrameSetVisible(GymMenu, true)
            end
        end
    end

    OnInit.final(function ()
        ForForce(FORCE_PLAYING, function ()
            local p = GetEnumPlayer()
            local t = CreateTrigger()
            TriggerRegisterDialogEvent(t, SelectPlayer[p])
            TriggerAddAction(t, function ()
                -- Get clicked button
                local index = 0
                local toFight = nil ---@type player
                for v in PlayerOptions[p]:elements() do
                    index = index + 1
                    if GetClickedButton() == PlayerClicked[p][index] then
                        toFight = v
                        break
                    end
                end

                if not toFight then
                    return
                end

                if PlayerSelected[toFight] ~= p then
                    PlayerSelected[p] = toFight
                else
                    local i = GetFreeArena()
                    if not i then
                        if LocalPlayer == p or LocalPlayer == toFight then
                            DisplayTextToPlayer(LocalPlayer, 0, 0, "All the arenas are being used, you have to wait until they are free.")
                        end
                        return
                    end
                    for _, d in ipairs(GetDigimons(p)) do
                        if UnitHasItemOfTypeBJ(d.root, PVP_TICKET) then
                            RemoveItem(GetItemOfTypeFromUnitBJ(d.root, PVP_TICKET))
                            break
                        end
                    end
                    for _, d in ipairs(GetDigimons(toFight)) do
                        if UnitHasItemOfTypeBJ(d.root, PVP_TICKET) then
                            RemoveItem(GetItemOfTypeFromUnitBJ(d.root, PVP_TICKET))
                            break
                        end
                    end
                    StartFight(p, toFight, i)
                end
            end)
        end)
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == ARENA_TICKET end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetManipulatingUnit())
            local gold = GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD)
            local requiredGold = 50 + 50 * GetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED)
            if requiredGold > gold then
                ErrorMessage("You don't have enough digibits.", p)
                return
            end
            SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, gold - requiredGold)
            if not RectContainsUnit(LOBBY, GetManipulatingUnit()) then
                ErrorMessage("You can only use this ticket in the gym lobby.", p)
                return
            end
            local i = GetFreeArena()
            if not i then
                DisplayTextToPlayer(p, 0, 0, "All the arenas are being used, you have to wait until they are free.")
                return
            end
            StartFight(p, Digimon.NEUTRAL, i)
        end)
    end

    OnInit.trig(function ()
        udg_GymAdd = CreateTrigger()
        TriggerAddAction(udg_GymAdd, function ()
            DigimonTypes[udg_GymRank] = udg_GymDigimonType
            DigimonTypes[udg_GymRank][#udg_GymDigimonType + 1] = udg_GymLevel
            udg_GymRank = 0
            udg_GymDigimonType = __jarray(0)
            udg_GymLevel = 1
        end)
    end)

end)
Debug.endFile()