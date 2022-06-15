if OnGlobalInit then
    PlayerUtils = true

--[[*************************************************************
*
*   Based on PlayerUtils v1.2.9 by TriggerHappy
*
*   This library provides a struct which caches data about players
*   as well as provides functionality for manipulating player colors.
*
*   Constants
*   ------------------
*
*       force FORCE_PLAYING - Player group of everyone who is playing.
*
*   API
*   -------------------
*     class User
*
*       function User.fromIndex(i) returns User
*       function User.fromLocal()
*       function User.fromPlaying(id) returns User
*
*       User[player p] returns User
*       function User.getCount() returns integer
*
*       function User:getName() returns string
*       function User:setName(string name)
*       function User:getColor() return playercolor
*       function User:setColor(playercolor c)
*       function User:getDefaultColor() returns playercolor
*       function User:getHex() returns string
*       function User:getNameColored() returns string
*
*       function User:toPlayer() returns player
*       function User:setColorUnits(playercolor c)
*
*       string originalName
*       boolean isPlaying
*
*       player User.Local
*       integer User.LocalId
*       integer User.AmountPlaying
*       playercolor[] User.Color
*
*************************************************************]]


    -- automatically change unit colors when changing player color
    local AUTO_COLOR_UNITS = true

    -- use an array for name / color lookups (instead of function calls)
    local ARRAY_LOOKUP = false

    -- this only applies if ARRAY_LOOKUP is true
    local HOOK_SAFETY = false -- disable for speed, but only use the class to change name/color safely

    FORCE_PLAYING  = CreateForce()

    local Name = {} ---@type string[]
    local Hex = {} ---@type string[]
    local OriginalHex = {} ---@type string[]
    local CurrentColor = {} ---@type playercolor[]

    ---@class User
    ---@field handle player
    ---@field id integer
    ---@field next User
    ---@field prev User
    ---@field originalName string
    ---@field isPlaying boolean
    User = {} ---@type User[]
    User.__index = User

    User.first = nil ---@type User
    User.last = nil ---@type User
    User.Local = nil ---@type player
    User.LocalId = 0 ---@type integer
    User.AmountPlaying = 0 ---@type integer
    User.Color = {} ---@type playercolor[]

    User._PlayingPlayer = {} ---@type User[]
    User._PlayingPlayerIndex = {} ---@type integer[]

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
    ---@param index integer
    ---@return User
    function User.fromPlaying(index)
        return User._PlayingPlayer[index]
    end

    ---@return player
    function User:toPlayer()
        return self.handle
    end

    ---@return string
    function User:getName()
        return ARRAY_LOOKUP and Name[self] or GetPlayerName(self.handle)
    end

    ---@param newName string
    function User:setName(newName)
        SetPlayerName(self.handle, newName)
        if ARRAY_LOOKUP then
            if not HOOK_SAFETY then
                Name[self] = newName
            end
        end
    end

    ---@return playercolor
    function User:getColor()
        return ARRAY_LOOKUP and CurrentColor[self] or GetPlayerColor(self.handle)
    end

    ---@param c playercolor
    function User:setColor(c)
        SetPlayerColor(self.handle, c)
        if ARRAY_LOOKUP then
            CurrentColor[self] = c
            if not HOOK_SAFETY then
                if AUTO_COLOR_UNITS then
                    self:setColorUnits(c)
                end
            end
        end
    end

    ---@return string
    function User:getHex()
        return OriginalHex[GetHandleId(self:getColor())]
    end

    ---@return playercolor
    function User:getDefaultColor()
        return User.Color[self]
    end

    ---@return string
    function User:getNameColored()
        return self:getHex() .. self:getName() .. "|r"
    end

    local ENUM_GROUP = nil ---@type group
    if not UnitEnum then
        ENUM_GROUP = CreateGroup()
    end

    ---@param c playercolor
    function User:setColorUnits(c)
        if UnitEnum then
            ForUnitsOfPlayer(self.handle, function (u)
                SetUnitColor(u, c)
            end)
        else
            GroupEnumUnitsOfPlayer(ENUM_GROUP, self.handle, nil)
            while true do
                local u = FirstOfGroup(ENUM_GROUP)
                if not u then break end
                SetUnitColor(u, c)
                GroupRemoveUnit(ENUM_GROUP, u)
            end
        end
    end

    ---@param backward? boolean
    function User.loop(backward)
        local user = User.NULL
        local direction = backward and "prev" or "next"
        return function ()
            user = user[direction]
            return user ~= User.NULL and user or nil
        end
    end

    OnGlobalInit(function ()
        local t = CreateTrigger()

        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            User[i] = setmetatable({}, User)
            User[Player(i)] = User[i]
        end
        User[bj_MAX_PLAYER_SLOTS] = setmetatable({}, User)
        User.NULL = User[bj_MAX_PLAYER_SLOTS]

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

        if bj_MAX_PLAYERS > 12 then
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
        end

        User.first = User.NULL

        for i = 0, bj_MAX_PLAYERS - 1 do
            local p = User[i]
            p.handle = Player(i)
            p.id = i

            User.Color[i] = GetPlayerColor(p.handle)
            CurrentColor[i] = User.Color[i]

            if GetPlayerController(p.handle) == MAP_CONTROL_USER and GetPlayerSlotState(p.handle) == PLAYER_SLOT_STATE_PLAYING then
                User._PlayingPlayer[User.AmountPlaying] = p
                User._PlayingPlayerIndex[User.AmountPlaying] = User.AmountPlaying

                User.last = p

                if User.first == User.NULL then
                    User.first = p
                    p.next = User.NULL
                    p.prev = User.NULL
                else
                    p.prev = User._PlayingPlayer[User.AmountPlaying - 1]
                    User._PlayingPlayer[User.AmountPlaying - 1].next = p
                    p.next = User.NULL
                end

                p.isPlaying = true

                TriggerRegisterPlayerEvent(t, p.handle, EVENT_PLAYER_LEAVE)
                ForceAddPlayer(FORCE_PLAYING, p.handle)

                Hex[p] = OriginalHex[GetHandleId(User.Color[i])]

                User.AmountPlaying = User.AmountPlaying + 1
            end

            -- Remove the hash
            local original = GetPlayerName(p.handle)
            for j = 1, string.len(original) do
                if string.sub(original, j, j) == "#" then
                    SetPlayerName(p.handle, string.sub(original, 1, j - 1))
                    break
                end
            end

            Name[p] = GetPlayerName(p.handle)
            p.originalName = original
        end

        TriggerAddCondition(t, Condition(function ()
            local p = User[GetTriggerPlayer()]
            local i = User._PlayingPlayerIndex[p.id]

            -- clean up
            ForceRemovePlayer(FORCE_PLAYING, p:toPlayer())

            -- recycle index
            User.AmountPlaying = User.AmountPlaying - 1
            User._PlayingPlayerIndex[i] = User._PlayingPlayerIndex[User.AmountPlaying]
            User._PlayingPlayer[i] = User._PlayingPlayer[User.AmountPlaying]

            if (User.AmountPlaying == 1) then
                p.prev.next = User.NULL
                p.next.prev = User.NULL
            else
                p.prev.next = p.next
                p.next.prev = p.prev
            end

            User.last = User._PlayingPlayer[User.AmountPlaying]

            p.isPlaying = false
        end))
    end)

    --===========================================================================


    if ARRAY_LOOKUP then
        if HOOK_SAFETY then
            local oldSetPlayerName = SetPlayerName
            function SetPlayerName(whichPlayer, name)
                Name[whichPlayer] = name
                oldSetPlayerName(whichPlayer, name)
            end

            local oldSetPlayerColor = SetPlayerColor
            function SetPlayerColor(whichPlayer, color)
                local p = User[whichPlayer]

                Hex[p] = OriginalHex[GetHandleId(color)]
                CurrentColor[p] = color

                if AUTO_COLOR_UNITS then
                    p:setColorUnits(color)
                end
                oldSetPlayerColor(whichPlayer, color)
            end
        end
    end

end