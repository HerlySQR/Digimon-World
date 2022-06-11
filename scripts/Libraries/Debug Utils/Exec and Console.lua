--[[

--------------------------
----| Ingame Console |----
--------------------------

/**********************************************
* Allows you to use the following ingame commands:
* "-exec <code>" to execute any code ingame.
* "-console" to start an ingame console interpreting any further chat input as code and showing both return values of function calls and error messages. Furthermore, the print function will print
*    directly to the console after it got started. You can still look up all print messages in the F12-log.
***********************
* -------------------
* |Using the console|
* -------------------
* Any (well, most) chat input by any player after starting the console is interpreted as code and directly executed. You can enter terms (like 4+5 or just any variable name), function calls (like print("bla"))
* and set-statements (like y = 5). If the code has any return values, all of them are printed to the console. Erraneous code will print an error message.
* Chat input starting with a hyphen is being ignored by the console, i.e. neither executed as code nor printed to the console. This allows you to still use other chat commands like "-exec" without prompting errors.
***********************
* ------------------
* |Multiline-Inputs|
* ------------------
* You can prevent a chat input from being immediately executed by preceeding it with the greater sign '>'. All lines entered this way are halted, until any line not starting with '>' is being entered.
* The first input without '>' will execute all halted lines (and itself) in one chunk.
* Example of a chat input (the console will add an additional '>' to every line):
* >function a(x)
* >return x
* end
***********************
* Note that multiline inputs don't accept pure term evaluations, e.g. the following input is not supported and will prompt an error, while the same lines would have worked as two single-line inputs:
* >x = 5
* x
***********************
* -------------------
* |Reserved Keywords|
* -------------------
* The following keywords have a reserved functionality, i.e. are direct commands for the console and will not be interpreted as code:
* - 'exit'          - will shut down the console
* - 'printtochat'   - will let the print function return to normal behaviour (i.e. print to the chat instead of the console).
* - 'printtoconsole'- will let the print function print to the console (which is default behaviour).
* - 'show'          - will show the console, after it was accidently hidden (you can accidently hide it by showing another multiboard, while the console functionality is still up and running).
* - 'help'          - will show a list of all reserved keywords along very short explanations.
* - 'clear'         - will clear all text from the console, except the word 'clear'
* - 'share'         - will share the players console with every other player, allowing others to read and write into it. Will force-close other players consoles, if they have one active.
* - 'autosize on'   - will enable automatic console resize depending on the longest string in the display. This is turned on by default.
* - 'autosize off'  - will disable automatic console resize and instead linebreak long strings into multiple lines.
* - 'textlang eng'  - lets the console use english Wc3 text language font size to compute linebreaks (look in your Blizzard launcher settings to find out)
* - 'textlang ger'  - lets the console use german Wc3 text language font size to compute linebreaks (look in your Blizzard launcher settings to find out)
*************************************************/
--]]

--1. Ingame Console

---@class IngameConsole
IngameConsole = {
    --Settings
        numRows = 20                    ---@type integer Number of Rows of the console (multiboard), excluding the title row. So putting 20 here will show 21 rows, first being the title row.
    ,   numCols = 2                     ---@type integer Number of Columns of the console (multiboard)
    ,   autosize = true                 ---@type boolean Defines, whether the width of the main Column automatically adjusts with the longest string in the display.
    ,   currentWidth = 0.5              ---@type real Current and starting Screen Share of the console main column.
    ,   mainColMinWidth = 0.3           ---@type real Minimum Screen share of the variable main console column.
    ,   mainColMaxWidth = 0.8           ---@type real Maximum Scren share of the variable main console column.
    ,   tsColumnWidth = 0.06            ---@type real Screen Share of the Timestamp Column
    ,   linebreakBuffer = 0.008         ---@type real Screen Share that is added to the multiboard text column to compensate for the small inaccuracy of the String Width function.
    ,   maxLinebreaks = 3               ---@type integer Defines the maximum amount of linebreaks, before the remaining output string will be cut and not further displayed.
    ,   printToConsole = true           ---@type boolean defines, if the print function should print to the console or to the chat
    ,   sharedConsole = false           ---@type boolean defines, if the console is displayed to each player at the same time (accepting all players input) or if all players much start their own console.
    ,   textLanguage = 'eng'            ---@type string text language of your Wc3 installation, which influences font size (look in the settings of your Blizzard launcher). Currently only supports 'eng' and 'ger'.
    ,   colors = {
            timestamp = "bbbbbb"        ---@type string Timestamp Color
        ,   singleLineInput = "ffffaa"  ---@type string Color to be applied to single line console inputs
        ,   multiLineInput = "ffcc55"   ---@type string Color to be applied to multi line console inputs
        ,   returnValue = "00ffff"      ---@type string Color applied to return values
        ,   error = "ff5555"            ---@type string Color to be applied to errors resulting of function calls
        ,   keywordInput = "ff00ff"     ---@type string Color to be applied to reserved keyword inputs (console reserved keywords)
        ,   info = "bbbbbb"             ---@type string Color to be applied to info messages from the console itself (for instance after creation or after printrestore)
        }                               ---@type table
    --Privates
    ,   player = nil                    ---@type player player for whom the console is being created
    ,   currentLine = 0                 ---@type integer Current Output Line of the console.
    ,   inputload = ''                  ---@type string Input Holder for multi-line-inputs
    ,   output = {}                     ---@type string[] Array of all output strings
    ,   outputTimestamps = {}           ---@type string[] Array of all output string timestamps
    ,   outputWidths = {}               ---@type real[] remembers all string widths to allow for multiboard resize
    ,   trigger = nil                   ---@type trigger trigger processing all inputs during console lifetime
    ,   multiboard = nil                ---@type multiboard
    ,   timer = nil                     ---@type timer gets started upon console creation to measure timestamps
    --Statics
    ,   keywords = {}                   ---@type table<string,function> saves functions to be executed for all reserved keywords
    ,   playerConsoles = {}             ---@type table<player,IngameConsole> Consoles currently being active. up to one per player.
    ,   originalPrint = print           ---@type function original print function to restore, after the console gets closed.
}
IngameConsole.__index = IngameConsole

------------------------
--| Console Creation |--
------------------------

---@param consolePlayer player player for whom the console is being created
---@return IngameConsole
function IngameConsole.create(consolePlayer)
    local new = {} ---@type IngameConsole
    setmetatable(new, IngameConsole)
    ---setup Object data
    new.player = consolePlayer
    new.output = {}
    new.outputTimestamps = {}
    new.outputWidths = {}
    --Timer
    new.timer = CreateTimer()
    TimerStart(new.timer, 3600., true, nil) --just to get TimeElapsed for printing Timestamps.
    --Trigger to be created after short delay, because otherwise it would fire on "-console" input immediately and lead to stack overflow.
    new:setupTrigger()
    --Multiboard
    new:setupMultiboard()
    --Share, if settings say so
    if IngameConsole.sharedConsole then
        new:makeShared() --we don't have to exit other players consoles, because we look for the setting directly in the class and there just logically can't be other active consoles.
    end
    --Welcome Message
    new:out('info', 0, false, "Console started. Any further chat input will be executed as code, except when beginning with \x22-\x22.")
    return new
end

function IngameConsole:setupMultiboard()
    self.multiboard = CreateMultiboard()
    MultiboardSetRowCount(self.multiboard, self.numRows + 1) --title row adds 1
    MultiboardSetColumnCount(self.multiboard, self.numCols)
    MultiboardSetTitleText(self.multiboard, "Console")
    local mbitem
    for col = 1, self.numCols do
        for row = 1, self.numRows + 1 do --Title row adds 1
            mbitem = MultiboardGetItem(self.multiboard, row -1, col -1)
            MultiboardSetItemStyle(mbitem, true, false)
            MultiboardSetItemValueColor(mbitem, 255, 255, 255, 255)	-- Colors get applied via text color code
            MultiboardSetItemWidth(mbitem, (col == 1 and self.tsColumnWidth) or self.currentWidth )
            MultiboardReleaseItem(mbitem)
        end
    end
    mbitem = MultiboardGetItem(self.multiboard, 0, 0)
    MultiboardSetItemValue(mbitem, "|cffffcc00Timestamp|r")
    MultiboardReleaseItem(mbitem)
    mbitem = MultiboardGetItem(self.multiboard, 0, 1)
    MultiboardSetItemValue(mbitem, "|cffffcc00Line|r")
    MultiboardReleaseItem(mbitem)
    self:showToOwners()
end

function IngameConsole:setupTrigger()
    self.trigger = CreateTrigger()
    TriggerRegisterPlayerChatEvent(self.trigger, self.player, "", false) --triggers on any input of self.player
    TriggerAddCondition(self.trigger, Condition(function() return string.sub(GetEventPlayerChatString(),1,1) ~= '-' end)) --console will not react to entered stuff starting with '-'. This still allows to use other chat orders like "-exec".
    TriggerAddAction(self.trigger, function() self:processInput(GetEventPlayerChatString()) end)
end

function IngameConsole:makeShared()
    local player
    for i = 0, GetBJMaxPlayers() do
        player = Player(i)
        if (GetPlayerSlotState(player) == PLAYER_SLOT_STATE_PLAYING) and (IngameConsole.playerConsoles[player] ~= self) then --second condition ensures that the player chat event is not added twice for the same player.
            IngameConsole.playerConsoles[player] = self
            TriggerRegisterPlayerChatEvent(self.trigger, player, "", false) --triggers on any input
        end
    end
    self.sharedConsole = true
end

---------------------
--|      In       |--
---------------------

function IngameConsole:processInput(inputString)
    if IngameConsole.keywords[inputString] then --if the input string is a reserved keyword
        self:out('keywordInput', 1, false, inputString)
        IngameConsole.keywords[inputString](self) --then call the method with the same name. IngameConsole.keywords["exit"](self) is just self.keywords:exit().
        return
    end
    if string.sub(inputString, 1, 1) == '>' then --multiLineInput
        inputString = string.sub(inputString, 2, -1)
        self:out('multiLineInput',2, false, inputString)
        self.inputload = self.inputload .. inputString .. '\r' --carriage return
    else --singleLineInput OR last line of multiLineInput
        if self.inputload == '' then --singleLineInput
            self:out('singleLineInput', 1, false, inputString)
            self.inputload = self.inputload .. IngameConsole.preProcessInput(inputString, true) --slightly rewrites input to make it interpretable by the ingame console (and adds return statements, if sensible)
        else
            self:out('multiLineInput', 1, false, inputString) --end of multiline input gets only one '>'
            self.inputload = self.inputload .. IngameConsole.preProcessInput(inputString, false) --slightly rewrites input to make it interpretable by the ingame console (and adds return statements, if sensible)
        end
        local inputload = self.inputload
        self.inputload = '' --content of self.inputload written to local var. this allows us emptying it here and prevent it from keeping text even, when the pcall line below breaks (rare case, can for example be provoked with metatable.__tostring = {}).
        local loadfunc = load(inputload)
        local results = table.pack(pcall(loadfunc))
        --manually catch case, where the input did not define a proper Lua statement (i.e. loadfunc is nil)
        if loadfunc == nil then
            results[1], results[2] = false, "Input is not a valid Lua-statement"
        end
        --output error message (unsuccessful case) or return values (successful case)
        if not results[1] then --results[1] is the error status that pcall always returns. False stands for: error occured.
            self:out('error', 0, true, results[2]) -- second result of pcall is the error message in case an error occured
        elseif results.n > 1 then --Check, if there was at least one valid output argument. We check results.n instead of results[2], because we also get nil as a proper return value this way.
            self:out('returnValue', 0, true, select(2,table.unpack(results, 1, results.n)))
        end
    end
end

function IngameConsole.preProcessInput(inputString, singleLineInput)
    --Preceed the input with 'return ' to show term outputs in the console. A term t can be recognized by that "function() return t end" is a valid function, i.e. load('return ' .. t) is not nil.
    if singleLineInput and load("return " .. inputString) then --load(x) returns either a function or nil
        return "return " .. inputString
    end
    return inputString
end

----------------------
--|      Out       |--
----------------------


---@param colorTheme? string Decides about the color to be applied. Currently accepted: 'timestamp', 'singleLineInput', 'multiLineInput', 'result', nil. (nil leadsto no colorTheme, i.e. white color)
---@param numIndentations integer Number of greater signs '>' that shall preceed the output
---@param hideTimestamp boolean Set to false to hide the timestamp column and instead show a "->" symbol.
---@vararg any the things to be printed in the console.
---@return boolean hasPrintedEverything returns true, if everything could be printed. Returns false otherwise (can happen for very long strings).
function IngameConsole:out(colorTheme, numIndentations, hideTimestamp, ...)
    local outputs = table.pack(...) --we need the entry "n" to be able to for-loop and deal with nil values. Just writing {...} would force us to use ipairs (stops on first nil) or pairs(doesn't retain order and ignores nil).
    --Replace all outputs by their tostring instances
    for i = 1, outputs.n do
        outputs[i] = tostring(outputs[i])
    end
    local printOutput = table.concat(outputs, '    ')
    --add preceeding greater signs
    for i = 1, numIndentations do
        printOutput = '>' .. printOutput
    end
    --Print a space instead of the empty string. This allows the console to identify, if the string has already been fully printed (see while-loop below).
    if printOutput == '' then
        printOutput = ' '
    end
    --Compute Linebreaks.
    local linebreakWidth = ((self.autosize and self.mainColMaxWidth) or self.currentWidth )
    local numLinebreaks = 0
    local partialOutput = nil
    local maxPrintableCharPosition
    local printWidth
    while string.len(printOutput) > 0  and numLinebreaks <= self.maxLinebreaks do --break, if the input string has reached length 0 OR when the maximum number of linebreaks would be surpassed.
        --compute max printable substring (in one multiboard line)
        maxPrintableCharPosition, printWidth = IngameConsole.getLinebreakData(printOutput, linebreakWidth - self.linebreakBuffer, self.textLanguage)
        --adds timestamp to the first line of any output
        if numLinebreaks == 0 then
            partialOutput = printOutput:sub(1, numIndentations) .. ((IngameConsole.colors[colorTheme] and "|cff" .. IngameConsole.colors[colorTheme] .. printOutput:sub(numIndentations + 1, maxPrintableCharPosition) .. "|r") or printOutput:sub(numIndentations + 1, maxPrintableCharPosition)) --Colorize the output string, if a color theme was specified. IngameConsole.colors[colorTheme] can be nil.
            table.insert(self.outputTimestamps, "|cff" .. IngameConsole.colors['timestamp'] .. ((hideTimestamp and '            ->') or IngameConsole.formatTimerElapsed(TimerGetElapsed(self.timer))) .. "|r")
        else
            partialOutput = (IngameConsole.colors[colorTheme] and "|cff" .. IngameConsole.colors[colorTheme] .. printOutput:sub(1, maxPrintableCharPosition) .. "|r") or printOutput:sub(1, maxPrintableCharPosition) --Colorize the output string, if a color theme was specified. IngameConsole.colors[colorTheme] can be nil.
            table.insert(self.outputTimestamps, '            ..') --need a dummy entry in the timestamp list to make it line-progress with the normal output.
        end
        numLinebreaks = numLinebreaks + 1
        --writes output string and width to the console tables.
        table.insert(self.output, partialOutput)
        table.insert(self.outputWidths, printWidth + self.linebreakBuffer) --remember the Width of this printed string to adjust the multiboard size in case. 0.5 percent is added to avoid the case, where the multiboard width is too small by a tiny bit, thus not showing some string without spaces.
        --compute remaining string to print
        printOutput = string.sub(printOutput, maxPrintableCharPosition + 1, -1) --remaining string until the end. Returns empty string, if there is nothing left
    end
    self.currentLine = #self.output
    self:updateMultiboard()
    if string.len(printOutput) > 0 then
        self:out('info', 0, false, "The previous value could not be entirely printed, because the maximum number of linebreaks was exceeded.") --recursive call of this function, should be fine.
    end
    return string.len(printOutput) == 0 --printOutput is the empty string, if and only if everything has been printed
end

function IngameConsole:updateMultiboard()
    local startIndex = math.max(self.currentLine - self.numRows, 0) --to be added to loop counter to get to the index of output table to print
    local outputIndex = 0
    local maxWidth = 0.
    local mbitem
    for i = 1, self.numRows do --doesn't include title row (index 0)
        outputIndex = i + startIndex
        mbitem = MultiboardGetItem(self.multiboard, i, 0)
        MultiboardSetItemValue(mbitem, self.outputTimestamps[outputIndex] or '')
        MultiboardReleaseItem(mbitem)
        mbitem = MultiboardGetItem(self.multiboard, i, 1)
        MultiboardSetItemValue(mbitem, self.output[outputIndex] or '')
        MultiboardReleaseItem(mbitem)
        maxWidth = math.max(maxWidth, self.outputWidths[outputIndex] or 0.) --looping through non-defined widths, so need to coalesce with 0
    end
    --Adjust Multiboard Width, if necessary.
    maxWidth = math.min(math.max(maxWidth, self.mainColMinWidth), self.mainColMaxWidth)
    if self.autosize and self.currentWidth ~= maxWidth then
        self.currentWidth = maxWidth
        for i = 1, self.numRows +1 do
            mbitem = MultiboardGetItem(self.multiboard, i-1, 1)
            MultiboardSetItemWidth(mbitem, maxWidth)
            MultiboardReleaseItem(mbitem)
        end
        self:showToOwners() --reshow multiboard to update item widths on the frontend
    end
end

function IngameConsole:showToOwners()
    if self.sharedConsole or GetLocalPlayer() == self.player then
        MultiboardDisplay(self.multiboard, true)
        MultiboardMinimize(self.multiboard, false)
    end
end


function IngameConsole.numberToTwoDigitString(inputNumber)
    local result = tostring(math.floor(inputNumber))
    return (string.len(result) == 1 and '0'.. result) or result
end

function IngameConsole.formatTimerElapsed(elapsedInSeconds)
    return IngameConsole.numberToTwoDigitString(elapsedInSeconds / 60) .. ': ' .. IngameConsole.numberToTwoDigitString(math.fmod(elapsedInSeconds, 60.)) .. '. ' .. IngameConsole.numberToTwoDigitString(math.fmod(elapsedInSeconds, 1) * 100)
end

---Computes the max printable substring for a given string and a given linebreakWidth (regarding a single line of console).
---Returns both the substrings last char position and its total width in the multiboard.
---@param stringToPrint string the string supposed to be printed in the multiboard console.
---@param linebreakWidth real the maximum allowed width in one line of the console, before a string must linebreak
---@param textLanguage string 'ger' or 'eng'
---@return integer maxPrintableCharPosition, real printWidth
function IngameConsole.getLinebreakData(stringToPrint, linebreakWidth, textLanguage)
    local loopWidth = 0.
    local bytecodes = table.pack(string.byte(stringToPrint, 1, -1))
    for i = 1, bytecodes.n do
        loopWidth = loopWidth + string.charMultiboardWidth(bytecodes[i], textLanguage)
        if loopWidth > linebreakWidth then
            return i-1, loopWidth - string.charMultiboardWidth(bytecodes[i], textLanguage)
        end
    end
    return bytecodes.n, loopWidth
end

-------------------------
--| Reserved Keywords |--
-------------------------

function IngameConsole.keywords:exit()
    DestroyMultiboard(self.multiboard)
    DestroyTrigger(self.trigger)
    DestroyTimer(self.timer)
    IngameConsole.playerConsoles[self.player] = nil
    if table.isEmpty(IngameConsole.playerConsoles) then --set print function back to original, when no one has an active console left.
        print = IngameConsole.originalPrint
    end
end

function IngameConsole.keywords:printtochat()
    self.printToConsole = false
    self:out('info', 0, false, "The print function will print to the normal chat.")
end

function IngameConsole.keywords:printtoconsole()
    self.printToConsole = true
    self:out('info', 0, false, "The print function will print to the console.")
end

function IngameConsole.keywords:show()
    self:showToOwners() --might be necessary to do, if another multiboard has shown up and thereby hidden the console.
    self:out('info', 0, false, "Console is showing.")
end

function IngameConsole.keywords:help()
    self:out('info', 0, false, "The Console currently reserves the following keywords:")
    self:out('info', 0, false, "'exit' closes the console.")
    self:out('info', 0, false, "'printtochat' lets Wc3 print text to normal chat again.")
    self:out('info', 0, false, "'show' shows the console. Sensible to use, when displaced by another multiboard.")
    self:out('info', 0, false, "'help' shows the text you are currently reading.")
    self:out('info', 0, false, "'clear' clears all text from the console.")
    self:out('info', 0, false, "'share' allows other players to read and write into your console, but also force-closes their own consoles.")
    self:out('info', 0, false, "'autosize on' enables automatic console resize depending on the longest line in the display.")
    self:out('info', 0, false, "'autosize off' retains the current console size.")
    self:out('info', 0, false, "'textlang eng' will use english text installation font size to compute linebreaks (default).")
    self:out('info', 0, false, "'textlang ger' will use german text installation font size to compute linebreaks.")
    self:out('info', 0, false, "Preceeding a line with '>' prevents immediate execution, until a line not starting with '>' has been entered.")
end

function IngameConsole.keywords:clear()
    self.output = {}
    self.outputTimestamps = {}
    self.outputWidths = {}
    self.currentLine = 0
    self:out('keywordInput', 1, false, 'clear') --we print 'clear' again. The keyword was already printed by self:processInput, but cleared immediately after.
end

function IngameConsole.keywords:share()
    for _, console in pairs(IngameConsole.playerConsoles) do
        if console ~= self then
            IngameConsole.keywords['exit'](console) --share was triggered during console runtime, so there potentially are active consoles of others players that need to exit.
        end
    end
    self:makeShared()
    self:showToOwners() --showing it to the other players.
    self:out('info', 0,false, "The console of player " .. GetConvertedPlayerId(self.player) .. " is now shared with all players.")
end

IngameConsole.keywords["autosize on"] = function(self)
    self.autosize = true
    self:out('info', 0,false, "The console will now change size depending on its content.")
end

IngameConsole.keywords["autosize off"] = function(self)
    self.autosize = false
    self:out('info', 0,false, "The console will retain the width that it currently has.")
end

IngameConsole.keywords["textlang ger"] = function(self)
    self.textLanguage = 'ger'
    self:out('info', 0,false, "Linebreaks will now compute with respect to german text installation font size.")
end

IngameConsole.keywords["textlang eng"] = function(self)
    self.textLanguage = 'eng'
    self:out('info', 0,false, "Linebreaks will now compute with respect to english text installation font size.")
end

--------------------
--| Main Trigger |--
--------------------

do
    local function ExecCommand_Actions()
        print("Executing input.")
        local errorStatus, errorMessage = pcall(load(string.sub(GetEventPlayerChatString(),7,-1)))
        if not errorStatus then
            error(errorMessage)
        end
    end

    local function ExecCommand_Conditions()
        return string.sub(GetEventPlayerChatString(), 1, 6) == "-exec "
    end

    local function IngameConsole_Actions()
        --if the triggering player already has a console, show that console and stop executing further actions
        if IngameConsole.playerConsoles[GetTriggerPlayer()] then
            IngameConsole.playerConsoles[GetTriggerPlayer()]:showToOwners()
            return
        end
        --create Ingame Console object
        IngameConsole.playerConsoles[GetTriggerPlayer()] = IngameConsole.create(GetTriggerPlayer())
        --overwrite print function
        print = function(...)
            IngameConsole.originalPrint(...) --the new print function will also print "normally", but clear the text immediately after. This is to add the message to the F12-log.
            if IngameConsole.playerConsoles[GetLocalPlayer()] and IngameConsole.playerConsoles[GetLocalPlayer()].printToConsole then
                ClearTextMessages() --clear text messages for all players having an active console
            end
            for player, console in pairs(IngameConsole.playerConsoles) do
                if console.printToConsole and (player == console.player) then --player == console.player ensures that the console only prints once, even if the console was shared among all players
                    console:out(nil, 0, false, ...)
                end
            end
        end
    end

    function IngameConsole.createTriggers()
        --Exec
        local execTrigger = CreateTrigger()
        TriggerAddCondition(execTrigger, Condition(ExecCommand_Conditions))
        TriggerAddAction(execTrigger, ExecCommand_Actions)
        --Real Console
        local consoleTrigger = CreateTrigger()
        TriggerAddAction(consoleTrigger, IngameConsole_Actions)
        --Events
        for i = 0, GetBJMaxPlayers() do
            TriggerRegisterPlayerChatEvent(execTrigger, Player(i), "-exec ", false)
            TriggerRegisterPlayerChatEvent(consoleTrigger, Player(i), "-console", true)
        end
    end

    OnMapInit(IngameConsole.createTriggers)
end