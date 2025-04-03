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
    local FrameList = Require "FrameList" ---@type FrameList

    local LocalPlayer = GetLocalPlayer()
    local MAX_ARENAS = 4
    local MAX_FIGHTERS = 2
    local MAX_DIGIMONS = udg_MAX_DIGIMONS
    local MUSIC = "war3mapImported\\Out_in_the_Country.mp3"
    local MAX_RANK = 99
    local RANK_UPGRADE = FourCC('R005')
    local RANK_BONUS = FourCC('A0E5')
    local RANK_PRIZES =
    { ---@type {equips: integer?, damage: integer?, defense: number?, health: integer?, energy: integer?}[]
        [1] =   {equips = nil,    damage = 1,     defense = nil,      health = nil,   energy = nil},
        [2] =   {equips = nil,    damage = 1,     defense = 0.5,      health = nil,   energy = nil},
        [3] =   {equips = nil,    damage = 1,     defense = 0.5,      health = 10,    energy = nil},
        [4] =   {equips = nil,    damage = 1,     defense = 0.5,      health = 10,    energy = 8},
        [5] =   {equips = 3,      damage = 2,     defense = 1,        health = 20,    energy = 16},
        [6] =   {equips = nil,    damage = 3,     defense = 1,      health = 20,    energy = 16},
        [7] =   {equips = nil,    damage = 3,     defense = 1.5,      health = 20,    energy = 16},
        [8] =   {equips = nil,    damage = 3,     defense = 1.5,      health = 30,    energy = 16},
        [9] =   {equips = nil,    damage = 3,     defense = 1.5,      health = 30,    energy = 24},
        [10] =  {equips = 3,      damage = 4,     defense = 2,        health = 40,    energy = 32},
        [11] =  {equips = nil,    damage = 5,     defense = 2,      health = 40,    energy = 32},
        [12] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 40,    energy = 32},
        [13] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 50,    energy = 32},
        [14] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 50,    energy = 40},
        [15] =  {equips = 3,      damage = 6,     defense = 3,        health = 70,    energy = 50},
        [16] =  {equips = nil,    damage = 7,     defense = 3,      health = 70,    energy = 50},
        [17] =  {equips = nil,    damage = 7,     defense = 3.5,      health = 70,    energy = 50},
        [18] =  {equips = nil,    damage = 7,     defense = 3.5,      health = 90,    energy = 50},
        [19] =  {equips = nil,    damage = 7,     defense = 3.5,      health = 90,    energy = 60},
        [20] =  {equips = 3,      damage = 8,     defense = 4,        health = 100,    energy = 70},
        [21] =  {equips = nil,    damage = 9,     defense = 4,      health = 100,    energy = 70},
        [22] =  {equips = nil,    damage = 9,     defense = 4.5,      health = 100,    energy = 70},
        [23] =  {equips = nil,    damage = 9,     defense = 4.5,      health = 110,    energy = 70},
        [24] =  {equips = nil,    damage = 9,     defense = 4.5,      health = 110,    energy = 80},
        [25] =  {equips = nil,    damage = 10,     defense = 5,       health = 150,   energy = 100}
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

    local RankShopMenu = nil ---@type framehandle
    local RankShopItems = nil ---@type framehandle
    local RankShopText = nil ---@type framehandle
    local RankShopExit = nil ---@type framehandle
    local RankShopItemT = {} ---@type framehandle[]
    local BackdropRankShopItemT = {} ---@type framehandle[]
    local RankShopList = nil ---@type FrameList

    local DigimonTypes = {} ---@type integer[][]
    for i = 0, MAX_RANK do
        DigimonTypes[i] = {}
    end

    local PVP_TICKET = FourCC('I03A')
    local ARENA_TICKET = FourCC('I03B')
    local LOBBY = gg_rct_Gym_Lobby ---@type rect
    local VENDOR = gg_unit_N01O_0120 ---@type unit
    local OPEN_SHOP = FourCC('I05X')
    local MAX_ITEM_PER_COLUM = 3

    local actualColum = MAX_ITEM_PER_COLUM
    local actualContainer = nil ---@type framehandle
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

    ---@class RankItem
    ---@field id integer
    ---@field rank integer
    ---@field goldCost integer
    ---@field woodCost integer

    local RankItems = {} ---@type RankItem[]

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
                    if d and d:isAlive()
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
            if info.p == Digimon.VILLAIN then
                local list = DigimonTypes[self.rank]
                self.level = list[#list]
                for j = 1, 3 do
                    if list[j] then
                        local angle = math.pi*(j/4 + (i-1))
                        local d = Digimon.create(Digimon.VILLAIN, list[j],
                        centerX + 500*math.cos(angle), centerY + 500*math.sin(angle),
                        90 + 180*i)
                        DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Items\\AIem\\AIemTarget.mdl", d:getPos()))
                        info.digimonsInArena:addSingle(d)
                        d:setLevel(self.level)
                        local act = 0
                        for _ = 1, self.level do
                            act = act + 1
                            if act == 1 then
                                SelectHeroSkill(d.root, udg_STAMINA_TRAINING)
                            elseif act == 2 then
                                SelectHeroSkill(d.root, udg_DEXTERITY_TRAINING)
                            else
                                SelectHeroSkill(d.root, udg_WISDOM_TRAINING)
                                act = 0
                            end
                        end
                        d:pause()
                        table.insert(paused, d)
                        d:setIV(15, 15, 15)
                    end
                end
            else
                local n = info.selectedDigimons:size()
                local m = 0
                for j in info.selectedDigimons:elements() do
                    m = m + 1
                    SummonDigimon(info.p, j, true)
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
                if self.env:apply(info.p, true) and info.p == LocalPlayer then
                    PanCameraToTimed(GetRectCenterX(self.arena), GetRectCenterY(self.arena), 0)
                end
            end
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
                                ChangeMusic(MUSIC)
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
            PunishPlayer(info.p, false)
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
                    if IsPlayerInGame(info.p) then
                        StoreToBank(info.p, d, true)
                    else
                        d:destroy()
                    end
                end
            end
            Timed.call(4., function ()
                local reachedMax = false
                if loser.p == Digimon.VILLAIN then
                    reachedMax = GetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED) >= udg_MAX_RANK
                    SetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED, GetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED) + 1)
                    SetPlayerTechResearched(winner.p, RANK_UPGRADE, GetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED))
                end
                local notNeutral = true
                for i = 1, MAX_FIGHTERS do
                    local info = self.pi[i]
                    if IsPlayerInGame(info.p) then
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
                        if winner == info and loser.p == Digimon.VILLAIN and not reachedMax then
                            local prizes = RANK_PRIZES[GetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED)]
                            local message = "\nFor winning all your digimons will gain:"
                            if prizes.damage then
                                message = message .. "\n» " .. prizes.damage .. " damage attack"
                            end
                            if prizes.defense then
                                message = message .. "\n» " .. prizes.defense .. " defense"
                            end
                            if prizes.health then
                                message = message .. "\n» " .. prizes.health .. " health"
                            end
                            if prizes.energy then
                                message = message .. "\n» " .. prizes.energy .. " energy"
                            end
                            if prizes.equips then
                                message = message .. "\nAnd also " .. prizes.equips .. " items unlocked in the shop."
                            end
                            DisplayTextToPlayer(winner.p, 0, 0, message)
                            if GetPlayerState(winner.p, PLAYER_STATE_RESOURCE_FOOD_USED) >= udg_MAX_RANK then
                                DisplayTextToPlayer(winner.p, 0, 0, "\nYou reached the max rank, congratulations!")
                            end
                            if winner.p == LocalPlayer then
                                StartSound(bj_questItemAcquiredSound)
                            end
                        end
                    else
                        notNeutral = false
                    end
                    ShowBank(info.p, true)
                    ShowBackpack(info.p, true)
                end
                if notNeutral then
                    SetPlayerAllianceStateBJ(self.pi[1].p, self.pi[2].p, bj_ALLIANCE_ALLIED_VISION)
                    SetPlayerAllianceStateBJ(self.pi[2].p, self.pi[1].p, bj_ALLIANCE_ALLIED_VISION)
                    DisablePvP(self.pi[1].p, self.pi[2].p)
                end
                if self:localPlayerCond() then
                    RestartMusic()
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
                BlzSetAbilityRealLevelField(BlzGetUnitAbility(whichUnit, RANK_BONUS), ABILITY_RLF_ARMOR_BONUS_HAD1, 0, prizes.defense)
            end
            if prizes.health then
                AddUnitBonus(whichUnit, BONUS_HEALTH, -prizes.health)
            end
            if prizes.energy then
                AddUnitBonus(whichUnit, BONUS_MANA, -prizes.energy)
            end
        else
            UnitRemoveAbility(whichUnit, RANK_BONUS)
        end
        if newRank > 0 then
            if GetUnitAbilityLevel(whichUnit, RANK_BONUS) == 0 then
                UnitAddAbility(whichUnit, RANK_BONUS)
                BlzUnitHideAbility(whichUnit, RANK_BONUS, true)
            end

            local prizes = RANK_PRIZES[newRank]
            if prizes.damage then
                AddUnitBonus(whichUnit, BONUS_DAMAGE, prizes.damage)
            end
            if prizes.defense then
                BlzSetAbilityRealLevelField(BlzGetUnitAbility(whichUnit, RANK_BONUS), ABILITY_RLF_ARMOR_BONUS_HAD1, 0, prizes.defense)
                SetUnitAbilityLevel(whichUnit, RANK_BONUS, 2)
                SetUnitAbilityLevel(whichUnit, RANK_BONUS, 1)
            end
            if prizes.health then
                AddUnitBonus(whichUnit, BONUS_HEALTH, prizes.health)
            end
            if prizes.energy then
                AddUnitBonus(whichUnit, BONUS_MANA, prizes.energy)
            end
        end
    end)

    ---@param d Digimon
    local function assign(d)
        local rank = IsPlayerInForce(d:getOwner(), FORCE_PLAYING) and GetPlayerState(d:getOwner(), PLAYER_STATE_RESOURCE_FOOD_USED) or 0
        if rank > 0 then
            UnitAddAbility(d.root, RANK_BONUS)
            BlzUnitHideAbility(d.root, RANK_BONUS, true)

            local prizes = RANK_PRIZES[rank]
            if prizes.damage then
                AddUnitBonus(d.root, BONUS_DAMAGE, prizes.damage)
            end
            if prizes.defense then
                BlzSetAbilityRealLevelField(BlzGetUnitAbility(d.root, RANK_BONUS), ABILITY_RLF_ARMOR_BONUS_HAD1, 0, prizes.defense)
                SetUnitAbilityLevel(d.root, RANK_BONUS, 2)
                SetUnitAbilityLevel(d.root, RANK_BONUS, 1)
            end
            if prizes.health then
                AddUnitBonus(d.root, BONUS_HEALTH, prizes.health)
            end
            if prizes.energy then
                AddUnitBonus(d.root, BONUS_MANA, prizes.energy)
            end
        end
    end

    Digimon.createEvent:register(assign)
    Digimon.evolutionEvent:register(assign)

    OnRestart(function (p)
        BlzDecPlayerTechResearched(p, RANK_UPGRADE, GetPlayerTechCount(p, RANK_UPGRADE, true))
        ForForce(FORCE_PLAYING, function ()
            DisablePvP(p, GetEnumPlayer())
        end)
    end)

    OnLoad(function (p)
        SetPlayerTechResearched(p, RANK_UPGRADE, GetPlayerState(p, PLAYER_STATE_RESOURCE_FOOD_USED))
        ForForce(FORCE_PLAYING, function ()
            DisablePvP(p, GetEnumPlayer())
        end)
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
                BlzFrameSetEnable(Select, not info1.bannedDigimons:contains(i) and info1.aliveDigimons > 3 and (info1.selectedDigimons:contains(i) or info1.availableSelects > 0))
                BlzFrameSetEnable(Ban, false)
                BlzFrameSetText(Select, "|cffFCD20D" .. (info1.selectedDigimons:contains(i) and "Unselect" or "Select") .. "|r")
            elseif info1.clickedGroup == 2 then
                BlzFrameSetEnable(Select, false)
                BlzFrameSetEnable(Ban, not info2.selectedDigimons:contains(i) and info2.aliveDigimons > 3 and (info2.bannedDigimons:contains(i) or info1.availableBans > 0))
                BlzFrameSetText(Ban, "|cffFCD20D" .. (info2.bannedDigimons:contains(i) and "Unban" or "Ban") .. "|r")
            end
            BlzFrameSetEnable(Ready, info1.availableSelects == 0)
            BlzFrameSetText(Ready, "|cffFCD20D" .. (info1.votedStart and "I'm not ready" or "I'm ready") .. "|r")
        elseif info2.p == LocalPlayer then
            local i = info2.clicked
            if info2.clickedGroup == 2 then
                BlzFrameSetEnable(Select, not info2.bannedDigimons:contains(i) and info2.aliveDigimons > 3 and (info2.selectedDigimons:contains(i) or info2.availableSelects > 0))
                BlzFrameSetEnable(Ban, false)
                BlzFrameSetText(Select, "|cffFCD20D" .. (info2.selectedDigimons:contains(i) and "Unselect" or "Select") .. "|r")
            elseif info2.clickedGroup == 1 then
                BlzFrameSetEnable(Select, false)
                BlzFrameSetEnable(Ban, not info1.selectedDigimons:contains(i) and info1.aliveDigimons > 3 and (info1.bannedDigimons:contains(i) or info2.availableBans > 0))
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

    local function SelectFunc(p)
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

    local function BanFunc(p)
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

    local function ReadyFunc(p)
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

    local function UpdateItems()
        for i, itm in ipairs(RankItems) do
            local rank = GetPlayerState(LocalPlayer, PLAYER_STATE_RESOURCE_FOOD_USED)

            if rank >= itm.rank then
                BlzFrameSetTexture(BackdropRankShopItemT[i], BlzGetAbilityIcon(itm.id), 0, true)
                BlzFrameSetEnable(RankShopItemT[i], true)
            else
                BlzFrameSetTexture(BackdropRankShopItemT[i], BlzGetAbilityIcon(itm.id):gsub("Buttons\\BTN", "ButtonsDisabled\\DISBTN"), 0, true)
                BlzFrameSetEnable(RankShopItemT[i], false)
            end
        end
    end

    ---@param p player
    ---@param i integer
    ---@param j integer
    local function PlayerDigimonFunc(p, i, j)
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

    ---@param p player
    ---@param i integer
    local function RankBuyItem(p, i)
        local itm = RankItems[i]

        local actGold = GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD)
        local actWood = GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER)

        if actGold < itm.goldCost then
            ErrorMessage("Not enough digibits", p)
            return
        end

        if actWood < itm.woodCost then
            ErrorMessage("Not enough digicrystals", p)
            return
        end

        SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, actGold - itm.goldCost)
        SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, actWood - itm.woodCost)

        SetItemPlayer(CreateItem(itm.id, GetUnitX(VENDOR), GetUnitY(VENDOR)), p, true)
    end

    ---@param id integer
    ---@param rank integer
    ---@param goldCost integer
    ---@param woodCost integer
    local function DefineRankItem(id, rank, goldCost, woodCost)
        table.insert(RankItems, {
            id = id,
            rank = rank,
            goldCost = goldCost,
            woodCost = woodCost
        })

        local i = #RankItems

        if actualColum >= MAX_ITEM_PER_COLUM then
            actualColum = 0
            FrameLoaderAdd(function ()
                actualContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", RankShopItems, "", 1)
                BlzFrameSetPoint(actualContainer, FRAMEPOINT_TOPLEFT, RankShopItems, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
                BlzFrameSetSize(actualContainer, 0.06667, 0.20000)
                BlzFrameSetTexture(actualContainer, "war3mapImported\\EmptyBTN.blp", 0, true)
            end)
        end

        FrameLoaderAdd(function ()
            RankShopItemT[i] = BlzCreateFrame("IconButtonTemplate", actualContainer, 0, 0)
            BlzFrameSetPoint(RankShopItemT[i], FRAMEPOINT_TOPLEFT, actualContainer, FRAMEPOINT_TOPLEFT, 0.0000, -0.066667 * actualColum)
            BlzFrameSetPoint(RankShopItemT[i], FRAMEPOINT_BOTTOMRIGHT, actualContainer, FRAMEPOINT_BOTTOMRIGHT, -0.016667, 0.15000 - 0.06667 * actualColum)
            BlzFrameSetEnable(RankShopItemT[i], false)

            BackdropRankShopItemT[i] = BlzCreateFrameByType("BACKDROP", "BackdropRankShopItemT[" .. i .. "]", RankShopItemT[i], "", 0)
            BlzFrameSetAllPoints(BackdropRankShopItemT[i], RankShopItemT[i])
            BlzFrameSetTexture(BackdropRankShopItemT[i], BlzGetAbilityIcon(id):gsub("Buttons\\BTN", "ButtonsDisabled\\DISBTN"), 0, true)
            OnClickEvent(RankShopItemT[i], function (p)
                RankBuyItem(p, i)
                if p == LocalPlayer then
                    BlzFrameSetEnable(RankShopItemT[i], false)
                end
                Timed.call(1., function ()
                    if p == LocalPlayer then
                        BlzFrameSetEnable(RankShopItemT[i], true)
                    end
                end)
            end)

            local tooltip = BlzCreateFrame("QuestButtonBaseTemplate", RankShopItemT[i], 0, 0)

            local tooltipText = BlzCreateFrameByType("TEXT", "name", tooltip, "", 0)
            BlzFrameSetPoint(tooltipText, FRAMEPOINT_BOTTOMLEFT, RankShopItemT[i], FRAMEPOINT_CENTER, 0.0000, 0.0000)
            BlzFrameSetEnable(tooltipText, false)
            BlzFrameSetScale(tooltipText, 1.00)
            BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            local extraLength = 0
            if goldCost > 0 and woodCost > 0 then
                extraLength = GetStringFrameLength("     " .. goldCost)
            end

            BlzFrameSetText(tooltipText,
                "|cffffcc00" .. GetObjectName(id) .. "|r | |cffDAF7A6Rank level " .. rank .. "|r\n" ..
                (goldCost > 0 and ("     |cffffcc00" .. goldCost .. "|r") or "") ..
                (woodCost > 0 and ("     |cffffcc00" .. woodCost .. "|r") or "") ..
                "\n" ..
                BlzGetAbilityExtendedTooltip(id, 0))
            BlzFrameSetSize(tooltipText, 0.18, 0)
            BlzFrameSetPoint(tooltip, FRAMEPOINT_TOPLEFT, tooltipText, FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
            BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOMRIGHT, tooltipText, FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)

            if goldCost > 0 then
                local digibits = BlzCreateFrameByType("BACKDROP", "digibits", tooltipText, "", 0)
                BlzFrameSetPoint(digibits, FRAMEPOINT_TOPLEFT, tooltipText, FRAMEPOINT_TOPLEFT, 0.003, -0.0095)
                BlzFrameSetSize(digibits, 0.01, 0.01)
                BlzFrameSetTexture(digibits, "ReplaceableTextures\\CommandButtons\\BTNINV_Misc_Coin_04.blp", 0, true)
            end

            if woodCost > 0 then
                local digicrytals = BlzCreateFrameByType("BACKDROP", "digicrytals", tooltipText, "", 0)
                BlzFrameSetPoint(digicrytals, FRAMEPOINT_TOPLEFT, tooltipText, FRAMEPOINT_TOPLEFT, 0.0035 + extraLength, -0.0095)
                BlzFrameSetSize(digicrytals, 0.01, 0.01)
                BlzFrameSetTexture(digicrytals, "ReplaceableTextures\\CommandButtons\\BTNDraenei Crystals.blp", 0, true)
            end

            BlzFrameSetTooltip(RankShopItemT[i], tooltip)

            if actualColum == 0 then
                RankShopList:add(actualContainer)
            end
        end)

        actualColum = actualColum + 1
    end

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == OPEN_SHOP end))
        TriggerAddAction(t, function ()
            if GetOwningPlayer(GetManipulatingUnit()) == LocalPlayer and not BlzFrameIsVisible(RankShopMenu) then
                BlzFrameSetVisible(RankShopMenu, true)
                AddButtonToEscStack(RankShopExit)
                UpdateItems()
            end
        end)
    end

    local function RankShopExitFunc(p)
        if p == LocalPlayer then
            BlzFrameSetVisible(RankShopMenu, false)
            RemoveButtonFromEscStack(RankShopExit)
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
        OnClickEvent(Select, SelectFunc)

        Ban = BlzCreateFrame("ScriptDialogButton", GymMenu, 0, 0)
        BlzFrameSetPoint(Ban, FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.28500, -0.27500)
        BlzFrameSetPoint(Ban, FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.15500, 0.035000)
        BlzFrameSetText(Ban, "|cffFCD20DBan|r")
        BlzFrameSetScale(Ban, 1.29)
        OnClickEvent(Ban, BanFunc)

        Ready = BlzCreateFrame("ScriptDialogButton", GymMenu, 0, 0)
        BlzFrameSetPoint(Ready, FRAMEPOINT_TOPLEFT, GymMenu, FRAMEPOINT_TOPLEFT, 0.40500, -0.27500)
        BlzFrameSetPoint(Ready, FRAMEPOINT_BOTTOMRIGHT, GymMenu, FRAMEPOINT_BOTTOMRIGHT, -0.035000, 0.035000)
        BlzFrameSetText(Ready, "|cffFCD20DI'm ready|r")
        BlzFrameSetScale(Ready, 1.29)
        OnClickEvent(Ready, ReadyFunc)

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
                OnClickEvent(PlayerDigimonT[j][i], function (p) PlayerDigimonFunc(p, i, j) end)

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

        RankShopMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0), 0, 0)
        BlzFrameSetAbsPoint(RankShopMenu, FRAMEPOINT_TOPLEFT, 0.260000, 0.500000)
        BlzFrameSetAbsPoint(RankShopMenu, FRAMEPOINT_BOTTOMRIGHT, 0.560000, 0.190000)
        BlzFrameSetVisible(RankShopMenu, false)

        RankShopItems = BlzCreateFrameByType("BACKDROP", "BACKDROP", RankShopMenu, "", 1)
        BlzFrameSetPoint(RankShopItems, FRAMEPOINT_TOPLEFT, RankShopMenu, FRAMEPOINT_TOPLEFT, -0.008333, -0.055000)
        BlzFrameSetPoint(RankShopItems, FRAMEPOINT_BOTTOMRIGHT, RankShopMenu, FRAMEPOINT_BOTTOMRIGHT, -0.058333, 0.055000)
        BlzFrameSetTexture(RankShopItems, "war3mapImported\\EmptyBTN.blp", 0, true)

        RankShopList = FrameList.create(true, RankShopItems)
        BlzFrameSetPoint(RankShopList.Frame, FRAMEPOINT_TOPLEFT, RankShopItems, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
        RankShopList:setSize(0.283333, 0.20000)
        BlzFrameSetSize(RankShopList.Slider, 0.25, 0.012)

        RankShopText = BlzCreateFrameByType("TEXT", "name", RankShopMenu, "", 0)
        BlzFrameSetScale(RankShopText, 1.57)
        BlzFrameSetPoint(RankShopText, FRAMEPOINT_TOPLEFT, RankShopMenu, FRAMEPOINT_TOPLEFT, 0.040000, -0.020000)
        BlzFrameSetPoint(RankShopText, FRAMEPOINT_BOTTOMRIGHT, RankShopMenu, FRAMEPOINT_BOTTOMRIGHT, -0.040000, 0.26000)
        BlzFrameSetText(RankShopText, "|cffFFCC00Click to buy an item|r")
        BlzFrameSetEnable(RankShopText, false)
        BlzFrameSetTextAlignment(RankShopText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        RankShopExit = BlzCreateFrame("ScriptDialogButton", RankShopMenu, 0, 0)
        BlzFrameSetPoint(RankShopExit, FRAMEPOINT_TOPLEFT, RankShopMenu, FRAMEPOINT_TOPLEFT, 0.10000, -0.26500)
        BlzFrameSetPoint(RankShopExit, FRAMEPOINT_BOTTOMRIGHT, RankShopMenu, FRAMEPOINT_BOTTOMRIGHT, -0.10000, 0.015000)
        BlzFrameSetText(RankShopExit, "|cffFCD20DClose|r")
        BlzFrameSetScale(RankShopExit, 1.00)
        OnClickEvent(RankShopExit, RankShopExitFunc)
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
        -- I don't know why I should add this
        local buffer = BlzCreateFrameByType("BACKDROP", "BACKDROP", RankShopItems, "", 1)
        BlzFrameSetPoint(buffer, FRAMEPOINT_TOPLEFT, RankShopItems, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
        BlzFrameSetPoint(buffer, FRAMEPOINT_BOTTOMRIGHT, RankShopItems, FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.13000)
        BlzFrameSetTexture(buffer, "war3mapImported\\EmptyBTN.blp", 0, true)
        RankShopList:add(buffer)
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
                if IsPlayerInGame(GetOwningPlayer(u)) then
                    ForceAddPlayer(WannaPvP, GetOwningPlayer(u))
                end
            end)
        end)
    end)

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
        ShowBackpack(p1, false)
        ShowBackpack(p2, false)
        PunishPlayer(p1, false)
        PunishPlayer(p2, false)
        if p2 ~= Digimon.VILLAIN then
            DisplayTextToForce(WannaPvP, User[p1]:getNameColored() .. " and " .. User[p2]:getNameColored() .. " will fight.")
            PlayerSelected[p1] = nil
            PlayerSelected[p2] = nil

            ForceRemovePlayer(WannaPvP, p1)
            ForceRemovePlayer(WannaPvP, p2)
            ForForce(WannaPvP, function ()
                AddPlayers(GetEnumPlayer())
            end)

            StoreAllDigimons(p1, true)
            StoreAllDigimons(p2, true)

            SetPlayerAllianceStateBJ(p1, p2, bj_ALLIANCE_UNALLIED)
            SetPlayerAllianceStateBJ(p2, p1, bj_ALLIANCE_UNALLIED)
            EnablePvP(p1, p2)

            local available1 = 0
            local available2 = 0
            for i = 0, MAX_DIGIMONS - 1 do
                local d = GetBankDigimon(p1, i)
                if d and d:isAlive() then
                    available1 = available1 + 1
                end

                d = GetBankDigimon(p2, i)
                if d and d:isAlive() then
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
                    if d and d:isAlive() then
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
                    if d and d:isAlive() then
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
                ForceUICancel() -- In case another menu was opened
                HideMenu(true)

                BlzFrameSetText(Remaining, "Remain: " .. math.floor(fight.selectTime))

                BlzFrameSetText(PlayerName[1], User[p1]:getNameColored())
                BlzFrameSetText(PlayerName[2], User[p2]:getNameColored())

                for i = 0, MAX_DIGIMONS - 1 do
                    local d = GetBankDigimon(p1, i)
                    if d and d:isAlive() then
                        BlzFrameSetTexture(BackdropPlayerDigimonT[1][i], BlzGetAbilityIcon(d:getTypeId()), 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[1][i], true)
                    else
                        BlzFrameSetTexture(BackdropPlayerDigimonT[1][i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[1][i], false)
                    end
                    BlzFrameSetVisible(PlayerDigimonClicked[1][i], false)

                    d = GetBankDigimon(p2, i)
                    if d and d:isAlive() then
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

            StoreAllDigimons(p1, true)

            EnablePvP(p1, p2)

            local available = 0
            for i = 0, MAX_DIGIMONS - 1 do
                local d = GetBankDigimon(p1, i)
                if d and d:isAlive() then
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
                    if d and d:isAlive() then
                        info.selectedDigimons:addSingle(i)
                    end
                end
            end

            info = fight.pi[2]
            info.p = Digimon.VILLAIN
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
                ForceUICancel() -- In case another menu was opened
                HideMenu(true)

                BlzFrameSetText(Remaining, "Remain: " .. math.floor(fight.selectTime))

                BlzFrameSetText(PlayerName[1], User[p1]:getNameColored())
                BlzFrameSetText(PlayerName[2], User[p2]:getNameColored())

                local list = DigimonTypes[fight.rank]
                for i = 0, MAX_DIGIMONS - 1 do
                    local d = GetBankDigimon(p1, i)
                    if d and d:isAlive() then
                        BlzFrameSetTexture(BackdropPlayerDigimonT[1][i], BlzGetAbilityIcon(d:getTypeId()), 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[1][i], true)
                    else
                        BlzFrameSetTexture(BackdropPlayerDigimonT[1][i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                        BlzFrameSetEnable(PlayerDigimonT[1][i], false)
                    end
                    BlzFrameSetVisible(PlayerDigimonClicked[1][i], false)

                    if i+1 < #list then
                        BlzFrameSetTexture(BackdropPlayerDigimonT[2][i], BlzGetAbilityIcon(list[i+1]), 0, true)
                    else
                        BlzFrameSetTexture(BackdropPlayerDigimonT[2][i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                    end
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
                    StartFight(p, toFight, i)
                end
            end)
        end)
    end)

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == ARENA_TICKET or GetItemTypeId(GetManipulatedItem()) == PVP_TICKET end))
        TriggerAddAction(t, function ()
            local p = GetOwningPlayer(GetManipulatingUnit())
            if GetItemTypeId(GetManipulatedItem()) == ARENA_TICKET then
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
                StartFight(p, Digimon.VILLAIN, i)
            elseif GetItemTypeId(GetManipulatedItem()) == PVP_TICKET then
                if not RectContainsUnit(LOBBY, GetManipulatingUnit()) then
                    ErrorMessage("You can only use this ticket in the gym lobby.", p)
                    return
                end
                AddPlayers(p)
                if not PlayerOptions[p]:isEmpty() then
                    DialogDisplay(p, SelectPlayer[p], true)
                end
            end
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

        udg_RankVendorAdd = CreateTrigger()
        TriggerAddAction(udg_RankVendorAdd, function ()
            DefineRankItem(udg_RankVendorItem, udg_RankVendorRank, udg_RankVendorGoldCost, udg_RankVendorWoodCost)
            udg_RankVendorItem = 0
            udg_RankVendorRank = 0
            udg_RankVendorGoldCost = 0
            udg_RankVendorWoodCost = 0
        end)
    end)

end)
Debug.endFile()