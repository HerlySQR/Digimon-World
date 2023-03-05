if Debug then Debug.beginFile("PlayerUtils") end
OnInit("PlayerUtils", function ()

    --[[*************************************************************
    *
    *   based on PlayerUtils v1.2.9 by TriggerHappy
    *
    *   This library provides a table which caches data about players
    *   as well as provides functionality for manipulating player colors.
    *
    *   Constants
    *   ------------------
    *
    *       force FORCE_PLAYING - Player group of everyone who is playing.
    *
    *   API
    *   -------------------
    *     User
    *
    *       function User.fromIndex(integer i) returns User
    *       function User.fromLocal() returns User
    *       function User.fromPlaying(integer id) returns User
    *
    *       User[id] returns User
    *       User.count returns integer
    *
    *       Fields:
    *       string originalName
    *       boolean isPlaying
    *
    *       function User:colorUnits(playercolor c)
    *       function User:getName() returns string
    *       function User:setName(string name)
    *       function User:getColor() returns playercolor
    *       function User:setColor(playercolor c)
    *       function User:getDefaultColor() returns playercolor
    *       function User:getHex() returns string
    *       function User:getNameColored() returns string
    *
    *       player User.Local
    *       integer User.LocalId
    *       integer User.AmountPlaying
    *       playercolor[] User.Color
    *       player[] User.PlayingPlayer
    *
    *************************************************************]]--

    -- automatically change unit colors when changing player color
    local AUTO_COLOR_UNITS = true

    -- use an array for name / color lookups (instead of function calls)
    local ARRAY_LOOKUP     = false

    -- this only applies if ARRAY_LOOKUP is true
    local HOOK_SAFETY      = false -- disable for speed, but only use the struct to change name/color safely

    local ENUM_GROUP = CreateGroup()

    FORCE_PLAYING = CreateForce()

    local Name         = {} ---@type string[]
    local Hex          = {} ---@type string[]
    local OriginalHex  = {} ---@type string[]
    local CurrentColor = {} ---@type playercolor[]

    ---@class User
    ---@field handle player
    ---@field id integer
    ---@field next User
    ---@field prev User
    ---@field originalName string
    ---@field isPlaying boolean

    User = {}
    User.__index = User

    User.NULL = setmetatable({}, User)  ---@type User
    User.AmountPlaying = 0
    User.PlayingPlayer = {}             ---@type User[]
    User.PlayingPlayerIndex = {}        ---@type integer[]
    User.Color = {}                     ---@type playercolor[]

    ---similar to Player(#)
    ---@param i integer
    ---@return User
    function User.fromIndex(i)
        return User[i]
    end

    ---similar to GetLocalPlayer
    ---@return User
    function User.fromLocal()
        return User[User.LocalId]
    end

    ---access active players array
    ---@param i integer
    ---@return User
    function User.fromPlaying(i)
        return User.PlayingPlayer[i]
    end

    ---@return player
    function User:toPlayer()
        return self.handle
    end

    ---@return string
    function User:getName()
        if ARRAY_LOOKUP then
            return Name[self]
        else
            return GetPlayerName(self.handle)
        end
    end

    ---@param newName string
    function User:setName(newName)
        SetPlayerName(self.handle, newName)
        if ARRAY_LOOKUP and not HOOK_SAFETY then
            Name[self] = newName
        end
    end

    ---@return playercolor
    function User:getColor()
        if ARRAY_LOOKUP then
            return CurrentColor[self]
        else
            return GetPlayerColor(self.handle)
        end
    end

    ---@return string
    function User:getHex()
        return OriginalHex[GetHandleId(self:getColor())]
    end

    ---@param c playercolor
    function User:setColor(c)
        SetPlayerColor(self.handle, c)
        if ARRAY_LOOKUP then
            CurrentColor[self] = c
            if not HOOK_SAFETY and AUTO_COLOR_UNITS then
                self:colorUnits(c)
            end
        end
    end

    ---@return playercolor
    function User:getDefaultColor()
        return User.Color[self]
    end

    ---@return string
    function User:getNameColored()
        return self:getHex() .. self:getName() .. "|r"
    end

    local whatColor ---@type playercolor
    local filter = Filter(function () SetUnitColor(GetFilterUnit(), whatColor) end)

    ---@param c playercolor
    function User:colorUnits(c)
        whatColor = c
        GroupEnumUnitsOfPlayer(ENUM_GROUP, self.handle, filter)
    end

    OnInit.final(function ()
        local t = CreateTrigger()

        User.Local = GetLocalPlayer()
        User.LocalId = GetPlayerId(User.Local)

        OriginalHex[0]  = "|cffff0303"
        OriginalHex[1]  = "|cff0042ff"
        OriginalHex[2]  = "|cff1ce6b9"
        OriginalHex[3]  = "|cff540081"
        OriginalHex[4]  = "|cfffffc01"
        OriginalHex[5]  = "|cfffe8a0e"
        OriginalHex[6]  = "|cff20c000"
        OriginalHex[7]  = "|cffe55bb0"
        OriginalHex[8]  = "|cff959697"
        OriginalHex[9]  = "|cff7ebff1"
        OriginalHex[10] = "|cff106246"
        OriginalHex[11] = "|cff4e2a04"
        OriginalHex[12] = "|cff9B0000"
        OriginalHex[13] = "|cff0000C3"
        OriginalHex[14] = "|cff00EAFF"
        OriginalHex[15] = "|cffBE00FE"
        OriginalHex[16] = "|cffEBCD87"
        OriginalHex[17] = "|cffF8A48B"
        OriginalHex[18] = "|cffBFFF80"
        OriginalHex[19] = "|cffDCB9EB"
        OriginalHex[20] = "|cff282828"
        OriginalHex[21] = "|cffEBF0FF"
        OriginalHex[22] = "|cff00781E"
        OriginalHex[23] = "|cffA46F33"

        User.first = User.NULL

        for i = 0, bj_MAX_PLAYERS - 1 do
            local user = setmetatable({}, User) ---@type User

            user.handle = Player(i)
            user.id = i

            User[i] = user
            User[user.handle] = user

            User.Color[i] = GetPlayerColor(user.handle)
            CurrentColor[i] = User.Color[i]

            if (GetPlayerController(user.handle) == MAP_CONTROL_USER and GetPlayerSlotState(user.handle) == PLAYER_SLOT_STATE_PLAYING) then
                User.PlayingPlayer[User.AmountPlaying] = user
                User.PlayingPlayerIndex[i] = User.AmountPlaying

                User.last = user

                if User.first == User.NULL then
                    User.first = user
                    user.next = User.NULL
                    user.prev = User.NULL
                else
                    user.prev = User.PlayingPlayer[User.AmountPlaying - 1]
                    User.PlayingPlayer[User.AmountPlaying - 1].next = user
                    user.next = User.NULL
                end

                user.isPlaying = true

                TriggerRegisterPlayerEvent(t, user.handle, EVENT_PLAYER_LEAVE)
                ForceAddPlayer(FORCE_PLAYING, user.handle)
                Hex[user] = OriginalHex[GetHandleId(User.Color[i])]
                User.AmountPlaying = User.AmountPlaying + 1
            end

            Name[user] = GetPlayerName(user.handle)
            user.originalName = Name[user]
        end

        TriggerAddCondition(t, Condition(function ()
            local user = User[GetTriggerPlayer()] ---@type User
            local i = User.PlayingPlayerIndex[user.id]

            -- clean up
            ForceRemovePlayer(FORCE_PLAYING, user.handle)

            -- recycle index
            User.AmountPlaying = User.AmountPlaying - 1
            User.PlayingPlayerIndex[i] = User.PlayingPlayerIndex[User.AmountPlaying]
            User.PlayingPlayer[i] = User.PlayingPlayer[User.AmountPlaying]

            if User.AmountPlaying == 1 then
                user.prev.next = User.NULL
                user.next.prev = User.NULL
            else
                user.prev.next = user.next
                user.next.prev = user.prev
            end

            User.last = User.PlayingPlayer[User.AmountPlaying]
            user.isPlaying = false

            return false
        end))
    end)

    if ARRAY_LOOKUP and HOOK_SAFETY then
        Require "AddHook"

        AddHook("SetPlayerName", function (whichPlayer, name)
            Name[GetPlayerId(whichPlayer)] = name
        end)

        AddHook("SetPlayerColor", function (whichPlayer, color)
            local p = User[whichPlayer]

            Hex[p] = OriginalHex[GetHandleId(color)]
            CurrentColor[p] = color

            if AUTO_COLOR_UNITS then
                p:colorUnits(color)
            end
        end)
    end
end)
if Debug then Debug.endFile() end