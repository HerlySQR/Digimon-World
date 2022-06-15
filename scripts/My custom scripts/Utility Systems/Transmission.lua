if LinkedList and
    Timed and
    OnGlobalInit and
    Wc3Type then

    -- See the API here https://www.hiveworkshop.com/threads/vjass-lua-unit-transmission.332814/

    -- A functions to use
    local AllInstances = {}
    local WhatForce = {}
    local InGame = nil
    local LocalPlayer = nil

    ---@param force force
    ---@return boolean
    function IsForceEmpty(force)
        if force then
            local count = 0
            ForForce(force, function ()
                count = count + 1
            end)
            return count == 0
        end
        return true
    end

    ---@param principal force
    ---@param other force
    function ForceAddForce(principal, other)
        if principal and other then
            ForForce(other, function ()
                ForceAddPlayer(principal, GetEnumPlayer())
            end)
        end
    end

    ---@param principal force
    ---@param other force
    function ForceRemoveForce(principal, other)
        if principal and other then
            ForForce(other, function ()
                ForceRemovePlayer(principal, GetEnumPlayer())
            end)
        end
    end

    ---@param player player
    ---@return force
    function Force(player)
        return WhatForce[player]
    end

    -- To have compatibility with Reforged
    local getType = BlzGetUnitSkin or GetUnitTypeId

    ---@class Transmission
    ---@field toPlayer player
    ---@field toForce force
    ---@field OriginalTargetForce force
    ---@field isSkippable boolean
    ---@field DefUnit unit
    ---@field DefUnitType integer
    ---@field DefColor playercolor
    ---@field DefName string
    ---@field DefSound sound
    ---@field DefText string
    ---@field DefTimeType integer
    ---@field DefDuration real
    ---@field DefWillWait boolean
    Transmission = {}
    Transmission.__index = Transmission

    local All = LinkedList.create()

    -- These are to make it more elegant than just put integers, but you can use the integers if you want
    Transmission.ADD = bj_TIMETYPE_ADD  -- 0
    Transmission.SET = bj_TIMETYPE_SET  -- 1
    Transmission.SUB = bj_TIMETYPE_SUB  -- 2

    -- Where the magic happens

    function Transmission:_finish()
        self._Steps = nil
        self._ended = true
        DestroyTimer(self._t)
        if self._final then
            self._final(self)
            self._final = nil
        end
        ForForce(self.toForce, function ()
            local list = AllInstances[GetEnumPlayer()]
            for i, v in ipairs(list) do
                if v == self then
                    table.remove(list, i)
                    break
                end
            end
        end)
        DestroyForce(self.toForce)
        DestroyForce(self.OriginalTargetForce)
        self._elements = nil
        self._played = nil
        self.toForce = nil
        self.OriginalTargetForce = nil
        self._t = nil
        LinkedList.remove(All, self)
    end

    function Transmission:_what_call()
        self._current = self._current + 1
        self._elements = self._Steps[self._current]
        if not self._elements or IsForceEmpty(self.toForce) then
            -- If the cinematic was skipped just in the last line it won't be counted as skipped
            self._skipped = IsForceEmpty(self.toForce) and self._elements ~= nil
            self:_finish()
        else
            if self._elements._isline then
                self:_cinematic_line()
            else
                self:_cinematic_actions()
            end
        end
    end

    function Transmission:_cinematic_line()
        local alpha = 0
        local delay = 0
        local what = self._elements

        self._played = what.Sound
        local duration = GetTransmissionDuration(self._played, what.TimeType, what.Duration)
        what.UnitType = what.UnitType or getType(what.Unit)
        if IsPlayerInForce(LocalPlayer, self.toForce) then
            if self._played ~= nil then
                StartSound(self._played)
            end
            SetCinematicScene(what.UnitType, what.Color, what.Name, what.Text, duration + bj_TRANSMISSION_PORT_HANGTIME, duration)
            alpha = 255
        end
        if what.Unit then
            UnitAddIndicator(what.Unit, 255, 255, 255, alpha)
        end

        if what.WillWait then
            delay = duration
        end

        TimerStart(self._t, delay, false, function () self:_what_call() end)
    end

    function Transmission:_cinematic_actions()
        local what = self._elements

        if what.Actions then
            what.Actions(self)
        end

        TimerStart(self._t, what.Delay, false, function () self:_what_call() end)
        if self._paused then
            PauseTimer(self._t) -- In case you paused the transmission in an actions callback
        end
    end

    ---Stores a value
    ---@param data any
    function Transmission:SetData(data)
        self._data = data
    end

    ---Returns the stored data
    ---@return any
    function Transmission:GetData()
        return self._data
    end

    ---Returns if the transmission is paused
    ---@return boolean
    function Transmission:IsPaused()
        return self._paused
    end

    ---(Use it in the end callback).
    ---Returns if all the players in the target force skipped the transmission.
    ---If was skipped in the last line or action it won't be counted as skipped
    ---@return boolean
    function Transmission:WasSkipped()
        return self._skipped
    end

    ---Returns an array (table) that stores all the lines and actions in
    ---the order you set them
    ---@return table<integer, table>
    function Transmission:GetElements()
        return self._Steps
    end

    ---Returns the current line or actions
    ---@return table
    function Transmission:GetActualElement()
        return self._elements
    end

    ---Resumes the transmission
    function Transmission:Resume()
        self._paused = false
        ResumeTimer(self._t)
        --[[ This don't work correctly for some reason
        if self._played then
            if IsPlayerInForce(LocalPlayer, self.toForce) then
                StartSound(self._played)
            end
            SetSoundOffsetBJ(TimerGetElapsed(self._t), self._played) -- In case of desync
        end
        ]]
    end

    ---Pauses the transmission and maybe resume it after an asigned seconds
    ---the boolean is to stop the sound with a fade out
    ---@param fadeOut real
    ---@param delay? boolean
    function Transmission:Pause(fadeOut, delay)
        self._paused = true
        PauseTimer(self._t)
        StopSound(self._played, false, fadeOut)
        if delay and delay > 0 then
            Timed.call(delay, function () self:Resume() end)
        end
    end

    ---Runs the transmission
    function Transmission:Start()
        -- The default force is all the in-game players
        if IsForceEmpty(self.toForce) then
            self:SetTargetForce(InGame)
        end
        self._current = 0
        self._elements = nil
        self:_what_call()
    end

    ---Adds action that will run when the transmission ends.
    ---They will run even if the transmission was skipped.
    ---@param func fun(t?: Transmission)
    function Transmission:AddEnd(func)
        -- I can store functions :D
        self._final = func
    end

    ---Adds a line, the expected values are:
    --- - `(unit whichUnit or integer unittype), playercolor whichColor, string unitName, sound soundHandle, string message, integer timeType, real timeVal, boolean wait`
    --- - `table line`
    --- - nothing
    ---
    ---In case of the table, it should have the fields:
    ---   - `unit Unit`
    ---   - `integer UnitType` (if the value is `nil` then it will be automatically detected per line)
    ---   - `playercolor Color`
    ---   - `string Name` (`nil` value `""`)
    ---   - `string Text` (`nil` value `""`)
    ---   - `integer TimeType` : valid values `Transmission.ADD, Transmission.SET, Transmission.SUB` (`nil` value `-1`)
    ---   - `real Duration` (`nil` value 0)
    ---   - `boolean WillWait` (`nil` value false)
    ---
    ---In case you didn't add a parameter, the default values will be asign.
    ---The returned value is a table with the fields previously explained
    ---@return table
    function Transmission:AddLine(...)
        local line = nil
        if ... then
            local args = {...}
            if type(args[1]) == "table" then
                line = args[1]
                -- In case the passed table has this values as nil
                line.Name = line.Name or ""
                line.Text = line.Text or ""
                line.TimeType = line.TimeType or -1
                line.Duration = line.Duration or 0
                line.WillWait = line.WillWait or false
            else
                line = {
                    Color = args[2],
                    Name = args[3] or "",
                    Sound = args[4],
                    Text = args[5] or "",
                    TimeType = args[6] or -1,
                    Duration = args[7] or 0,
                    WillWait = args[8] or false
                }
                local unit = args[1]
                local typ = Wc3Type(unit)
                if typ == "unit" or typ == "nil" then
                    line.Unit = unit
                    if not unit then
                        if not line.Color then
                            if rawget(_G, "LIBRARY_StoreUnitColor") then
                                line.Color = PLAYER_COLOR_BLACK
                            else
                                line.Color = ConvertPlayerColor(PLAYER_NEUTRAL_AGGRESSIVE)
                            end
                        end
                    else
                        if not line.Color then
                            if rawget(_G, "LIBRARY_StoreUnitColor") then
                                line.Color = GetUnitColor(line.Unit)
                            else
                                line.Color = GetPlayerColor(GetOwningPlayer(line.Unit))
                            end
                        end
                    end
                elseif typ == "integer" then
                    line.Unit = nil
                    line.UnitType = unit
                    if not line.Color then
                        if rawget(_G, "LIBRARY_StoreUnitColor") then
                            line.Color = PLAYER_COLOR_BLACK
                        else
                            line.Color = ConvertPlayerColor(PLAYER_NEUTRAL_AGGRESSIVE)
                        end
                    end
                else
                    error("Invalid first argument", 2)
                end
            end
        else
            line = {
                Unit = self.DefUnit,
                UnitType = self.DefUnitType or 0,
                Color = self.DefColor,
                Name = self.DefName or "",
                Sound = self.DefSound,
                Text = self.DefText or "",
                TimeType = self.DefTimeType or -1,
                Duration = self.DefDuration or 0,
                WillWait = self.DefWillWait or false
            }
        end
        line._isline = true
        table.insert(self._Steps, line)
        return line
    end

    ---Adds an actions, you can just add a delay or an actions.
    ---The returned value is a table with the fields:
    ---   - real Delay
    ---   - fun(t: Transmission) Actions
    ---@param delay real|fun(t?: Transmission)
    ---@param func? fun(t?: Transmission)
    ---@return table
    function Transmission:AddActions(delay, func)
        local actions = nil
        local typ = type(delay)
        if typ == "table" then
            actions = delay
        elseif typ ~= "nil" then
            if typ == "function" then
                func, delay = delay, 0
            end
            actions = {
                Delay = delay,
                Actions = func
            }
        else
            error("You are entering a nil value", 2)
        end
        actions._isline = false
        table.insert(self._Steps, actions)
        return actions
    end

    ---Asign the target force
    ---@param toForce force
    function Transmission:SetTargetForce(toForce)
        if toForce and not IsForceEmpty(toForce) then
            ForForce(toForce, function()
                local player = GetEnumPlayer()
                self.toPlayer = player
                ForceAddPlayer(self.toForce, player)
                ForceAddPlayer(self.OriginalTargetForce, player)
                table.insert(AllInstances[player], self)
            end)
        end
    end

    ---Creates the transmission and directly asign a target force and
    ---maybe store a value to use it later
    ---@param toForce? force
    ---@param data? any
    ---@return Transmission
    function Transmission.create(toForce, data)
        local self = {}
        LinkedList.insert(All, self)
        setmetatable(self, Transmission) -- Sorry, but I don't wanna have LinkedList as its metatable

        self._skipped = false
        self._paused = false
        self._played = nil
        self.toForce = CreateForce()
        self.OriginalTargetForce = CreateForce()
        self._t = CreateTimer()
        self._ended = false
        self._Steps = {}
        self.isSkippable = true
        if toForce then
            self:SetTargetForce(toForce)
        end
        self._data = data

        return self
    end

    ---Pause all the started transmissions, ideal for time-stop events
    ---the boolean is to stop the sound with a fade out
    ---@param fadeOut boolean
    function Transmission.PauseAll(fadeOut)
        for node in All:loop() do
            node:Pause(fadeOut)
        end
    end

    ---Resume all the paused transmissions
    function Transmission.ResumeAll()
        for node in All:loop() do
            node:Resume()
        end
    end

    ---Creates and runs a transmission with just 1 line, the expected values are:
    ---
    ---`[player toPlayer or force toForce], (unit whichUnit or integer unittype), playercolor whichColor, string unitName, sound soundHandle, string message, integer timeType, real timeVal`
    ---@param ... unknown
    ---@return Transmission?
    function Transmission.Simple(...)
        local new = nil
        local args = {...}
        if #args == 7 then
            new = Transmission.create(InGame)
            table.insert(args, true)
            new:AddLine(table.unpack(args))
        elseif #args == 8 then
            local typ = Wc3Type(args[1])
            if typ == "force" then
                new = Transmission.create(args[1])
            elseif typ == "player" then
                new = Transmission.create(Force(args[1]))
            else
                error("Invalid first argument", 2)
            end
            table.insert(args, true)
            new:AddLine(table.unpack(args, 2, 9))
        else
            error("Invalid number of arguments", 2)
        end
        new:Start()
        return new
    end

    OnMapInit(function ()
        Timed.call(function ()
            InGame = CreateForce()
            for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
                local player = Player(i)
                if GetPlayerController(player) == MAP_CONTROL_USER and GetPlayerSlotState(player) == PLAYER_SLOT_STATE_PLAYING then
                    ForceAddPlayer(InGame, player)
                end
            end
        end)

        local t = CreateTrigger()

        for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
            local player = Player(i)
            WhatForce[player] = GetForceOfPlayer(player)
            AllInstances[player] = {}
            TriggerRegisterPlayerEvent(t, player, EVENT_PLAYER_END_CINEMATIC)
            TriggerRegisterPlayerEvent(t, player, EVENT_PLAYER_LEAVE)
        end
        TriggerAddAction(t, function ()
            local player = GetTriggerPlayer()
            for i = #AllInstances[player], 1, -1 do
                local curr = AllInstances[player][i]
                if curr.isSkippable and GetTriggerEventId() ~= EVENT_PLAYER_LEAVE then
                    ForceRemovePlayer(curr.toForce, player)
                    if player == LocalPlayer then
                        -- I don't know if this is free of desync (I checked and there is not desync yet)
                        EndCinematicScene()
                        if curr._played then
                            StopSound(curr._played, false, true)
                        end
                    end
                    if IsForceEmpty(curr.toForce) then
                        PauseTimer(curr._t)
                        TimerStart(curr._t, RMinBJ(bj_TRANSMISSION_PORT_HANGTIME, TimerGetRemaining(curr._t)), false, function () curr:_what_call() end)
                    end
                    table.remove(AllInstances[player], i)
                end
            end

            if GetTriggerEventId() == EVENT_PLAYER_LEAVE then
                ForceRemovePlayer(InGame, player)
            end
        end)
        -- --
        LocalPlayer = GetLocalPlayer()
        ForceCinematicSubtitles(true)
    end)

    -- Error message

    local errorSound

    ---@param message string
    ---@param whatPlayer player
    function ErrorMessage(message, whatPlayer)
        if not errorSound then
            errorSound = CreateSoundFromLabel("InterfaceError", false, false, false, 10, 10)
        end

        if LocalPlayer == whatPlayer then
            ClearTextMessages()
            DisplayTimedTextToPlayer(whatPlayer, 0.52, 0.96, 2, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n|cffffcc00" .. message .. "|r")
            StartSound(errorSound)
        end
    end

end