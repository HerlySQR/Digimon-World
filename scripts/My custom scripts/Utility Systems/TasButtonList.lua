--[[
TasButtonList11a by Tasyen
    TasButtonList is a higher Level UI-Component to search, filter and select data using a fixed amount of buttons.
    The UI-API part one has to do (as mapper using this system) is quite small.
    Provides a built in Tooltip-Box
    There can be many TasButtonList at the same Time.
    Each player can have a different dataPool inside a TasButtonList.
    Can differ between right click & left click (optional)
    Supports differnt Buttons (they have to be defined in fdf)
    ObjectEditor lists are handled with the default Actions, only need to define buttonAction in such a case.

function CreateTasButtonListEx(buttonName, cols, rows, parent, buttonAction[, rightClickAction, updateAction, searchAction, filterAction, asyncButtonAction, asyncRightClickAction, colGap, rowGap])
 create a new List
 parent is the container of this Frame it will attach itself to its TOP.
 buttonAction is the function that executes when an option is clicked. args: (clickedData, buttonListObject, dataIndex)
 rightClickAction is the function that executes when an option is rightClicked. args: (clickedData, buttonListObject, dataIndex)
 when your data are object Editor object-RawCodes (but not buffs) then updateAction & searchAction use a default one handling them.
 updateAction runs for each Button and is used to set the diplayed content. args:(frameObject, data)
    frameObject.Button
    frameObject.ToolTipFrame
    frameObject.ToolTipFrameIcon
    frameObject.ToolTipFrameName
    frameObject.ToolTipFrameSeperator
    frameObject.ToolTipFrameText

    frameObject.Icon
    frameObject.Text
    frameObject.IconGold
    frameObject.TextGold
    frameObject.IconLumber
    frameObject.TextLumber
    TasButtonList[frameObject] => buttonListObject

    data is one entry of the TasButtonLists Data-Array.

 searchAction is a function that returns true if the current data matches the searchText. Args: (data, searchedText, buttonListObject)
 filterAction is meant to be used when one wants an addtional non text based filtering, with returning true allowing data or false rejecting it. Args: (data, buttonListObject, isTextSearching)
 searchAction , udateAction & filterAction are async this functions should not do anything that alters the game state/flow.
function CreateTasButtonList(buttonCount, parent, buttonAction[, updateAction, searchAction, filterAction])
    wrapper for CreateTasButtonListEx, 1 col, buttonCount rows.
function CreateTasButtonListV2(rowCount, parent, buttonAction[, updateAction, searchAction, filterAction])
    wrapper for CreateTasButtonListEx, 2 Buttons each Row, takes more Height then the other Versions
function CreateTasButtonListV3(rowCount, parent, buttonAction[, updateAction, searchAction, filterAction])
    wrapper for CreateTasButtonListEx, 3 Buttons each Row, only Icon, and Costs

Wrapper Creator for Lists having only Text in a Box
Default update & search: exepect data to be either a number (object Editor rawCode), a string or a table(title, text, icon)
function CreateTasButtonBoxedTextList(rowCount, colCount, parent, buttonAction[, updateAction, searchAction, filterAction])
function CreateTasButtonBoxedTextListBig(rowCount, colCount, parent, buttonAction[, updateAction, searchAction, filterAction])

Wrapper Creator for Lists having only Text 
Default update & search: exepect data to be either a number (object Editor rawCode), a string or a table(title, text, icon)
function CreateTasButtonTextList(rowCount, colCount, parent, buttonAction[, updateAction, searchAction, filterAction])
function CreateTasButtonTextListBig(rowCount, colCount, parent, buttonAction[, updateAction, searchAction, filterAction])

function TasButtonListClearData(buttonListObject[, player])
    remove all data
function TasButtonListRemoveData(buttonListObject, data[, player])
    search for data and remove it
function TasButtonListAddData(buttonListObject, data[, player])
    add data for one Button
function TasButtonListAddDataBatch(buttonListObject, player, ...)
   calls TasButtonListAddData for each given arg after player
   nil for player will add it for all players
   you should not use FourCC in this, TasButtonList will do that for your
function TasButtonListAddDataBatchEx(buttonListObject, ...)
    TasButtonListAddDataBatch with player nil (all players)
function TasButtonListCopyData(writeObject, readObject[, player])
    writeObject uses the same data as readObject and calls UpdateButtonList.
    The copier writeObject still has an own filtering and searching.
function UpdateTasButtonList(buttonListObject)
    update the displayed Content should be done after Data was added or removed was used.
TasButtonListSearch(buttonListObject[, text])
    The buttonList will search it's data for the given text, if nil is given as text it will search for what the user currently has in its box.
    This will also update the buttonList
--]]

TasButtonList = {
    -- TasButtonListAddData will FourCC given 4 digit strings?
    Interpret4DigitString = true
}
do
    local function reload()
        BlzLoadTOCFile("war3mapimported\\TasButtonList.toc")
    end
    local realFunc = InitBlizzard
    function InitBlizzard()
        realFunc()
        reload()
        -- fix a save&Load bug in 1.31.1 and upto 1.32.10 (currently) which does not save&load frame-API actions
        if FrameLoaderAdd then FrameLoaderAdd(reload) end

        TasButtonList.SyncTrigger = CreateTrigger()
        TasButtonList.SyncTriggerAction = TriggerAddAction(TasButtonList.SyncTrigger, function()
            xpcall(function()
            local buttonListObject = TasButtonList[BlzGetTriggerFrame()]
            local dataIndex = math.tointeger(BlzGetTriggerFrameValue())

            if buttonListObject.ButtonAction then
                -- call the wanted action, 1 the current Data
                buttonListObject.ButtonAction(buttonListObject.Data[GetTriggerPlayer()][dataIndex], buttonListObject, dataIndex)
            end
            UpdateTasButtonList(buttonListObject)
            end,print)
        end)

        -- do this only if the function IsRightClick exists
        if IsRightClick then
            TasButtonList.SyncTriggerRightClick = CreateTrigger()
            TasButtonList.SyncTriggerRightClickAction = TriggerAddAction(TasButtonList.SyncTriggerRightClick, function()
                xpcall(function()
                local buttonListObject = TasButtonList[BlzGetTriggerFrame()]
                local dataIndex = math.tointeger(BlzGetTriggerFrameValue())

                if buttonListObject.RightClickAction then
                    -- call the wanted action, 1 the current Data
                    buttonListObject.RightClickAction(buttonListObject.Data[GetTriggerPlayer()][dataIndex], buttonListObject, dataIndex)
                end
                UpdateTasButtonList(buttonListObject)
                end,print)
            end)
        end

        TasButtonList.RightClickSound = CreateSound("Sound\\Interface\\MouseClick1.wav", false, false, false, 10, 10, "")
        SetSoundParamsFromLabel(TasButtonList.RightClickSound, "InterfaceClick")
        SetSoundDuration(TasButtonList.RightClickSound, 239)

        -- handles the clicking
        TasButtonList.ButtonTrigger = CreateTrigger()
        TasButtonList.ButtonTriggerAction = TriggerAddAction(TasButtonList.ButtonTrigger, function()
            local frame = BlzGetTriggerFrame()
            local buttonIndex = TasButtonList[frame].Index
            local buttonListObject = TasButtonList[TasButtonList[frame]]
            local dataIndex = buttonListObject.DataFiltered[buttonListObject.ViewPoint + buttonIndex]
            BlzFrameSetEnable(frame, false)
            BlzFrameSetEnable(frame, true)
            if GetLocalPlayer() == GetTriggerPlayer() then
                if buttonListObject.AsyncButtonAction then
                    buttonListObject.AsyncButtonAction(buttonListObject, buttonListObject.Data[GetLocalPlayer()][R2I(dataIndex)], frame)
                end
                BlzFrameSetValue(buttonListObject.SyncFrame, dataIndex)
            end
        end)

        -- do this only if the function IsRightClick exists
        if IsRightClick then
            -- handles the clicking
            TasButtonList.ButtonTriggerRightClick = CreateTrigger()
            TasButtonList.ButtonTriggerRightClickAction = TriggerAddAction(TasButtonList.ButtonTriggerRightClick, function()
                
                local frame = BlzGetTriggerFrame()
                local buttonListObject = TasButtonList[TasButtonList[frame]]
                -- if there is no RightClick Action for this Buttonlist skip other actions
                if not buttonListObject.RightClickAction and not buttonListObject.AsyncRightClickAction then return end

                local buttonIndex = TasButtonList[frame].Index
                local dataIndex = buttonListObject.DataFiltered[buttonListObject.ViewPoint + buttonIndex]
                if IsRightClick(GetTriggerPlayer()) and GetLocalPlayer() == GetTriggerPlayer() then
                    if buttonListObject.AsyncRightClickAction then
                        buttonListObject.AsyncRightClickAction(buttonListObject, buttonListObject.Data[GetLocalPlayer()][R2I(dataIndex)], frame)
                    end
                    StartSound(TasButtonList.RightClickSound)
                    BlzFrameSetValue(buttonListObject.SyncFrameRightClick, dataIndex)
                end
            end)
        end

        TasButtonList.SearchTrigger = CreateTrigger()
        TasButtonList.SearchTriggerAction = TriggerAddAction(TasButtonList.SearchTrigger, function()
            TasButtonListSearch(TasButtonList[BlzGetTriggerFrame()], BlzFrameGetText(BlzGetTriggerFrame()))
        end)

        -- scrolling while pointing on Buttons
        TasButtonList.ButtonScrollTrigger = CreateTrigger()
        TasButtonList.ButtonScrollTriggerAction = TriggerAddAction(TasButtonList.ButtonScrollTrigger, function()
            local buttonListObject = TasButtonList[TasButtonList[BlzGetTriggerFrame()]]
            local frame = buttonListObject.Slider
            if GetLocalPlayer() == GetTriggerPlayer() then
                if BlzGetTriggerFrameValue() > 0 then
                    BlzFrameSetValue(frame, BlzFrameGetValue(frame) + buttonListObject.SliderStep)
                else
                    BlzFrameSetValue(frame, BlzFrameGetValue(frame) - buttonListObject.SliderStep)
                end
            end
        end)

        -- scrolling while pointing on slider aswell as calling
        TasButtonList.SliderTrigger = CreateTrigger()
        TasButtonList.SliderTriggerAction = TriggerAddAction(TasButtonList.SliderTrigger, function()
            local buttonListObject = TasButtonList[BlzGetTriggerFrame()]
            local frame = BlzGetTriggerFrame()
            if GetLocalPlayer() == GetTriggerPlayer() then
                if BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_WHEEL then
                    if BlzGetTriggerFrameValue() > 0 then
                        BlzFrameSetValue(frame, BlzFrameGetValue(frame) + buttonListObject.SliderStep)
                    else
                        BlzFrameSetValue(frame, BlzFrameGetValue(frame) - buttonListObject.SliderStep)
                    end
                else
                    -- when there is enough data use viewPoint. the Viewpoint is reduced from the data to make top being top.
                    if buttonListObject.DataFiltered.Count > buttonListObject.Frames.Count then
                        buttonListObject.ViewPoint = buttonListObject.DataFiltered.Count - math.tointeger(BlzGetTriggerFrameValue())
                    else
                        buttonListObject.ViewPoint = 0
                    end
                    UpdateTasButtonList(buttonListObject)
                end
                if buttonListObject.SliderText then
                    local min = math.tointeger(buttonListObject.DataFiltered.Count - BlzFrameGetValue(frame))
                    local max = math.tointeger(buttonListObject.DataFiltered.Count - buttonListObject.Frames.Count)
                    BlzFrameSetText(buttonListObject.SliderText, min .. "/" .. max )
                end
            end
        end)
    end
end
--runs once for each button shown
function UpdateTasButtonListDefaultObject(frameObject, data)
    BlzFrameSetTexture(frameObject.Icon, BlzGetAbilityIcon(data), 0, false)
    BlzFrameSetText(frameObject.Text, GetObjectName(data))

    BlzFrameSetTexture(frameObject.ToolTipFrameIcon, BlzGetAbilityIcon(data), 0, false)
    BlzFrameSetText(frameObject.ToolTipFrameName, GetObjectName(data))      
--        frameObject.ToolTipFrameSeperator
    BlzFrameSetText(frameObject.ToolTipFrameText, BlzGetAbilityExtendedTooltip(data, 0))

    if not IsUnitIdType(data, UNIT_TYPE_HERO) then
        local lumber = GetUnitWoodCost(data)
        local gold = GetUnitGoldCost(data)
        if GetPlayerState(GetLocalPlayer(), PLAYER_STATE_RESOURCE_GOLD) >= gold then
            BlzFrameSetText(frameObject.TextGold, GetUnitGoldCost(data))
        else
            BlzFrameSetText(frameObject.TextGold, "|cffff2010"..GetUnitGoldCost(data))
        end    
        
        if GetPlayerState(GetLocalPlayer(), PLAYER_STATE_RESOURCE_LUMBER) >= lumber then
            BlzFrameSetText(frameObject.TextLumber, GetUnitWoodCost(data))
        else
            BlzFrameSetText(frameObject.TextLumber, "|cffff2010"..GetUnitWoodCost(data))
        end
    else
        BlzFrameSetText(frameObject.TextLumber, 0)
        BlzFrameSetText(frameObject.TextGold, 0)
    end
end

--runs once for each button shown
function UpdateTasButtonListDefaultText(frameObject, data)
    
    if type(data) == "string" then
        BlzFrameSetTexture(frameObject.ToolTipFrameIcon, "UI/Widgets/EscMenu/Human/blank-background", 0, true)
        BlzFrameSetText(frameObject.Text, GetLocalizedString(data))
    
        BlzFrameSetText(frameObject.ToolTipFrameName, GetLocalizedString(data))
--        frameObject.ToolTipFrameSeperator
        BlzFrameSetText(frameObject.ToolTipFrameText, GetLocalizedString(data))
    elseif type(data) == "number" then
        UpdateTasButtonListDefaultObject(frameObject, data)
    elseif type(data) == "table" then
        BlzFrameSetText(frameObject.Text, data[1])    
        BlzFrameSetText(frameObject.ToolTipFrameName, GetLocalizedString(data[1]))
--        frameObject.ToolTipFrameSeperator
        BlzFrameSetText(frameObject.ToolTipFrameText, GetLocalizedString(data[2]))

        -- have icon data?
        if data[3] then
            BlzFrameSetTexture(frameObject.ToolTipFrameIcon, data[3], 0, true)
        else
            BlzFrameSetTexture(frameObject.ToolTipFrameIcon, "UI/Widgets/EscMenu/Human/blank-background", 0, true)
        end

    end
end

function SearchTasButtonListDefaultObject(data, searchedText, buttonListObject)
    --return BlzGetAbilityTooltip(data, 0)
    --return GetObjectName(data, 0)
    --return string.find(GetObjectName(data), searchedText)
    return string.find(string.lower(GetObjectName(data)), string.lower(searchedText))
end

function SearchTasButtonListDefaultText(data, searchedText, buttonListObject)
    if type(data) == "number" then
        return string.find(string.lower(GetObjectName(data)), string.lower(searchedText))
    elseif type(data) == "string" then
        return string.find(string.lower(GetLocalizedString(data)), string.lower(searchedText))
    elseif type(data) == "table" then
        return string.find(string.lower(GetLocalizedString(data[1])), string.lower(searchedText)) or string.find(string.lower(GetLocalizedString(data[2])), string.lower(searchedText))
    else
        return true
    end
end

-- update the shown content
function UpdateTasButtonList(buttonListObject)
    xpcall(function()
    local data = buttonListObject.Data[GetLocalPlayer()]
    BlzFrameSetVisible(buttonListObject.Slider, buttonListObject.DataFiltered.Count > buttonListObject.Frames.Count)
    for int = 1, buttonListObject.Frames.Count do
        local frameObject = buttonListObject.Frames[int]
        if buttonListObject.DataFiltered.Count >= int  then
            buttonListObject.UpdateAction(frameObject, data[buttonListObject.DataFiltered[int + buttonListObject.ViewPoint]])
            BlzFrameSetVisible(frameObject.Button, true)
        else
            BlzFrameSetVisible(frameObject.Button, false)
        end
    end
end, print)
end

-- for backwards compatibility rightClickAction is the last argument
function InitTasButtonListObject(parent, buttonAction, updateAction, searchAction, filterAction, rightClickAction, asyncButtonAction, asyncRightClickAction)
    local object = {
        Data = {}, --an array each slot is the user data
        DataFiltered = {Count = 0}, -- indexes of Data fitting the current search
        ViewPoint = 0,
        Frames = {},
        Parent = parent
    }
    for index = 0, bj_MAX_PLAYER_SLOTS - 1 do
        object.Data[Player(index)] = {Count = 0}
    end
    object.ButtonAction = buttonAction --call this inside the SyncAction after a button is clicked
    object.RightClickAction = rightClickAction -- this inside a SyncAction when the button is right clicked.
    object.UpdateAction = updateAction --function defining how to display stuff (async)
    object.SearchAction = searchAction --function to return the searched Text (async)
    object.FilterAction = filterAction --
    object.AsyncButtonAction = asyncButtonAction -- happens in the clicking event inside a LocalPlayer Block
    object.AsyncRightClickAction = asyncRightClickAction -- happens in the clicking event inside a LocalPlayer Block
    if not updateAction then object.UpdateAction = UpdateTasButtonListDefaultObject end
    if not searchAction then object.SearchAction = SearchTasButtonListDefaultObject end
    table.insert(TasButtonList, object) --index to TasButtonList
    TasButtonList[object] = #TasButtonList -- TasButtonList to Index

    object.SyncFrame = BlzCreateFrameByType("SLIDER", "", parent, "", 0)
    BlzFrameSetMinMaxValue(object.SyncFrame, 0, 9999999)
    BlzFrameSetStepSize(object.SyncFrame, 1.0)
    BlzTriggerRegisterFrameEvent(TasButtonList.SyncTrigger, object.SyncFrame, FRAMEEVENT_SLIDER_VALUE_CHANGED)
    BlzFrameSetVisible(object.SyncFrame, false)
    TasButtonList[object.SyncFrame] = object

    -- do this only if the function IsRightClick exists
    if IsRightClick then
        object.SyncFrameRightClick = BlzCreateFrameByType("SLIDER", "", parent, "", 0)
        BlzFrameSetMinMaxValue(object.SyncFrameRightClick, 0, 9999999)
        BlzFrameSetStepSize(object.SyncFrameRightClick, 1.0)
        BlzTriggerRegisterFrameEvent(TasButtonList.SyncTriggerRightClick, object.SyncFrameRightClick, FRAMEEVENT_SLIDER_VALUE_CHANGED)
        BlzFrameSetVisible(object.SyncFrameRightClick, false)
        TasButtonList[object.SyncFrameRightClick] = object
    end

    object.InputFrame = BlzCreateFrame("TasEditBox", parent, 0, 0)
    BlzTriggerRegisterFrameEvent(TasButtonList.SearchTrigger, object.InputFrame, FRAMEEVENT_EDITBOX_TEXT_CHANGED)
    BlzFrameSetPoint(object.InputFrame, FRAMEPOINT_TOPRIGHT, parent, FRAMEPOINT_TOPRIGHT, 0, 0)
    TasButtonList[object.InputFrame] = object

    return object
end

function InitTasButtonListSlider(object, stepSize, rowCount, colGap, rowGap)
    if not colGap then colGap = 0 end
    if not rowGap then rowGap = 0 end
    object.Slider = BlzCreateFrameByType("SLIDER", "FrameListSlider", object.Parent, "QuestMainListScrollBar", 0)
    TasButtonList[object.Slider] = object -- the slider nows the TasButtonListobject
    object.SliderStep = stepSize
    BlzFrameSetStepSize(object.Slider, stepSize)
    BlzFrameClearAllPoints(object.Slider)
    BlzFrameSetVisible(object.Slider, true)
    BlzFrameSetMinMaxValue(object.Slider, 0, 0)
    --BlzFrameSetPoint(object.Slider, FRAMEPOINT_TOPLEFT, object.Frames[stepSize].Button, FRAMEPOINT_TOPRIGHT, 0, 0)
    BlzFrameSetPoint(object.Slider, FRAMEPOINT_TOPLEFT, object.InputFrame, FRAMEPOINT_BOTTOMRIGHT, 0, 0)
    BlzFrameSetSize(object.Slider, 0.012, BlzFrameGetHeight(object.Frames[1].Button) * rowCount +  rowGap * (rowCount - 1))
    BlzTriggerRegisterFrameEvent(TasButtonList.SliderTrigger, object.Slider , FRAMEEVENT_SLIDER_VALUE_CHANGED)
    BlzTriggerRegisterFrameEvent(TasButtonList.SliderTrigger, object.Slider , FRAMEEVENT_MOUSE_WHEEL)


    -- if the function CreateSimpleTooltip exists, create a Text displaying current Position in the list
    if CreateSimpleTooltip then
        object.SliderText = CreateSimpleTooltip(object.Slider, "1000/1000")
        BlzFrameClearAllPoints(object.SliderText)
        BlzFrameSetPoint(object.SliderText, FRAMEPOINT_BOTTOMRIGHT, object.Slider, FRAMEPOINT_TOPLEFT, 0, 0)
    end 
end

function TasButtonListAddDataEx(buttonListObject, data, player)
    local oData = buttonListObject.Data[player]
    local oDataFil = buttonListObject.DataFiltered

    -- convert 'Hpal' into the number
--    print(TasButtonList.Interpret4DigitString) print( data) print(type(data)) print(string.len(data))
    if TasButtonList.Interpret4DigitString and type(data) == "string" and string.len(data) == 4 then data = FourCC(data) end
    
    oData.Count = oData.Count + 1
    oData[oData.Count] = data
    if GetLocalPlayer() == player then
        -- filterData is a local thing
        oDataFil.Count = oDataFil.Count + 1
        oDataFil[oDataFil.Count] = oData.Count
        BlzFrameSetMinMaxValue(buttonListObject.Slider, buttonListObject.Frames.Count, oDataFil.Count)
    end
end

function TasButtonListAddData(buttonListObject, data, player)
    -- only add for one player?
    if player and type(player) == "userdata" then
        TasButtonListAddDataEx(buttonListObject, data, player)
    else
        -- no player -> add for all Players
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            TasButtonListAddDataEx(buttonListObject, data, Player(i))
        end
    end
end

function TasButtonListAddDataBatch(buttonListObject, player, ...)
    for _, k in ipairs({...}) do
        print(k)
        TasButtonListAddData(buttonListObject, k, player)
    end
end
function TasButtonListAddDataBatchEx(buttonListObject, ...)
    TasButtonListAddDataBatch(buttonListObject, nil, ...)
end

function TasButtonListRemoveDataEx(buttonListObject, data, player)
    local oData = buttonListObject.Data[player]
    for index = 1, oData.Count do 
        value = oData[index]
        if value == data then
            oData[index] = oData[oData.Count]
            oData.Count = oData.Count - 1
            break
        end
    end
    if GetLocalPlayer() == player then
        BlzFrameSetMinMaxValue(buttonListObject.Slider, buttonListObject.Frames.Count, oData.Count)
    end
end

function TasButtonListRemoveData(buttonListObject, data, player)
    if player and type(player) == "userdata" then
        TasButtonListRemoveDataEx(buttonListObject, data, player)
    else
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            TasButtonListRemoveDataEx(buttonListObject, data, Player(i))
        end
    end
end

function TasButtonListClearDataEx(buttonListObject, player)
    buttonListObject.Data[player].Count = 0
    if GetLocalPlayer() == player then
        buttonListObject.DataFiltered.Count = 0
        BlzFrameSetMinMaxValue(buttonListObject.Slider, 0, 0)
    end
end

function TasButtonListClearData(buttonListObject, player)
    if player and type(player) == "userdata" then
        TasButtonListClearDataEx(buttonListObject, player)
    else
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            TasButtonListClearDataEx(buttonListObject, Player(i))
        end
    end
end

function TasButtonListCopyDataEx(writeObject, readObject, player)
    writeObject.Data[player] = readObject.Data[player]
    for index = 1, readObject.DataFiltered.Count do writeObject.DataFiltered[index] = readObject.DataFiltered[index] end
    writeObject.DataFiltered.Count = readObject.DataFiltered.Count
    if GetLocalPlayer() == player then
        BlzFrameSetMinMaxValue(writeObject.Slider, writeObject.Frames.Count, writeObject.Data[player].Count)
        BlzFrameSetValue(writeObject.Slider,999999)
    end
    
end

function TasButtonListCopyData(writeObject, readObject, player)
    if player and type(player) == "userdata" then
        TasButtonListCopyDataEx(writeObject, readObject, player)
    else
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            TasButtonListCopyDataEx(writeObject, readObject, Player(i))
        end
    end
end

function TasButtonListSearch(buttonListObject, text)
    if not text then text = BlzFrameGetText(buttonListObject.InputFrame) end
    local filteredData = buttonListObject.DataFiltered
    local oData = buttonListObject.Data[GetLocalPlayer()]
    local value
    if GetLocalPlayer() == GetTriggerPlayer() then
        filteredData.Count = 0
        if text ~= "" then
            for index = 1, oData.Count do 
                value = oData[index]
                if buttonListObject.SearchAction(value, text, buttonListObject) and (not buttonListObject.FilterAction or buttonListObject.FilterAction(value, buttonListObject, true)) then
                    filteredData.Count = filteredData.Count + 1
                    filteredData[filteredData.Count] = index
                end
            end
            
        else
            for index = 1, oData.Count do 
                value = oData[index]
                if not buttonListObject.FilterAction or buttonListObject.FilterAction(value, buttonListObject, false) then
                    filteredData.Count = filteredData.Count + 1
                    filteredData[filteredData.Count] = index
                end
            end
        end
        --table.sort(filteredData, function(a, b) return GetObjectName(buttonListObject.Data[a]) < GetObjectName(buttonListObject.Data[b]) end  )
        --update Slider, with that also update
        BlzFrameSetMinMaxValue(buttonListObject.Slider, buttonListObject.Frames.Count, math.max(filteredData.Count,0))
        BlzFrameSetValue(buttonListObject.Slider, 999999)
        
    end
end

-- demo Creators
function CreateTasButtonTooltip(frameObject, parent)
    -- create an empty FRAME parent for the box BACKDROP, otherwise it can happen that it gets limited to the 4:3 Screen.
    frameObject.ToolTipFrameFrame = BlzCreateFrame("TasButtonListTooltipBoxFrame", frameObject.Button, 0, 0)
    if GetHandleId(frameObject.ToolTipFrameFrame) == 0 then print("Error function CreateTasButtonTooltip Creating TasButtonListTooltipBoxFrame") end
    frameObject.ToolTipFrame = BlzGetFrameByName("TasButtonListTooltipBox", 0)
    frameObject.ToolTipFrameIcon = BlzGetFrameByName("TasButtonListTooltipIcon", 0)
    frameObject.ToolTipFrameName = BlzGetFrameByName("TasButtonListTooltipName", 0)
    frameObject.ToolTipFrameSeperator = BlzGetFrameByName("TasButtonListTooltipSeperator", 0)
    frameObject.ToolTipFrameText = BlzGetFrameByName("TasButtonListTooltipText", 0)    
    BlzFrameSetPoint(frameObject.ToolTipFrameText, FRAMEPOINT_TOPRIGHT, parent, FRAMEPOINT_TOPLEFT, -0.001, -0.052)
    BlzFrameSetPoint(frameObject.ToolTipFrame, FRAMEPOINT_TOPLEFT, frameObject.ToolTipFrameIcon, FRAMEPOINT_TOPLEFT, -0.005, 0.005)
    BlzFrameSetPoint(frameObject.ToolTipFrame, FRAMEPOINT_BOTTOMRIGHT, frameObject.ToolTipFrameText, FRAMEPOINT_BOTTOMRIGHT, 0.005, -0.005)
    BlzFrameSetTooltip(frameObject.Button, frameObject.ToolTipFrameFrame)
end

function CreateTasButtonListEx(buttonName, cols, rows, parent, buttonAction, rightClickAction, updateAction, searchAction, filterAction, asyncButtonAction, asyncRightClickAction, colGap, rowGap)
    if not rowGap then rowGap = 0.0 end
    if not colGap then colGap = 0.0 end
    local buttonCount = rows*cols
    local object = InitTasButtonListObject(parent, buttonAction, updateAction, searchAction, filterAction, rightClickAction, asyncButtonAction, asyncRightClickAction)
    object.Frames.Count = buttonCount
    local rowRemain = cols
    for int = 1, buttonCount do
        local frameObject = {}
        frameObject.Index = int
        frameObject.Button = BlzCreateFrame(buttonName, parent, 0, 0)
        if GetHandleId(frameObject.Button) == 0 then print("TasButtonList - Error - can't create:", buttonName) end
        CreateTasButtonTooltip(frameObject, parent)

        frameObject.Icon = BlzGetFrameByName("TasButtonIcon", 0)
        frameObject.Text = BlzGetFrameByName("TasButtonText", 0)
        frameObject.IconGold = BlzGetFrameByName("TasButtonIconGold", 0)
        frameObject.TextGold = BlzGetFrameByName("TasButtonTextGold", 0)
        frameObject.IconLumber = BlzGetFrameByName("TasButtonIconLumber", 0)
        frameObject.TextLumber = BlzGetFrameByName("TasButtonTextLumber", 0)
        TasButtonList[frameObject.Button] = frameObject
        TasButtonList[frameObject] = object
        object.Frames[int] = frameObject
        BlzTriggerRegisterFrameEvent(TasButtonList.ButtonTrigger, frameObject.Button, FRAMEEVENT_CONTROL_CLICK)
        -- do this only if the function IsRightClick exists
        if IsRightClick then
            BlzTriggerRegisterFrameEvent(TasButtonList.ButtonTriggerRightClick, frameObject.Button, FRAMEEVENT_MOUSE_UP)
        end
        BlzTriggerRegisterFrameEvent(TasButtonList.ButtonScrollTrigger, frameObject.Button, FRAMEEVENT_MOUSE_WHEEL)
        
        if int > 1 then 
            if rowRemain == 0 then
                BlzFrameSetPoint(frameObject.Button, FRAMEPOINT_TOP, object.Frames[int - cols].Button, FRAMEPOINT_BOTTOM, 0, -rowGap)
                rowRemain = cols
            else
                BlzFrameSetPoint(frameObject.Button, FRAMEPOINT_LEFT, object.Frames[int - 1].Button, FRAMEPOINT_RIGHT, colGap, 0)
            end
        else
            --print(-BlzFrameGetWidth(frameObject.Button)*cols - colGap*(cols-1))
            if cols > 1 then
                BlzFrameSetPoint(frameObject.Button, FRAMEPOINT_TOPRIGHT, object.InputFrame, FRAMEPOINT_BOTTOMRIGHT, -BlzFrameGetWidth(frameObject.Button)*(cols-1) - colGap*(cols-1), 0)
            else
                BlzFrameSetPoint(frameObject.Button, FRAMEPOINT_TOPRIGHT, object.InputFrame, FRAMEPOINT_BOTTOMRIGHT, 0, 0)
            end
        end
        rowRemain = rowRemain - 1
    end
    InitTasButtonListSlider(object, cols, rows, colGap, rowGap)

    return object
end

-- wrapper creators, they dont have async stuff
function CreateTasButtonList(buttonCount, parent, buttonAction, updateAction, searchAction, filterAction)
    return CreateTasButtonListEx("TasButton", 1, buttonCount, parent, buttonAction, nil, updateAction, searchAction, filterAction)
end

function CreateTasButtonListV2(rowCount, parent, buttonAction, updateAction, searchAction, filterAction)
    return CreateTasButtonListEx("TasButtonSmall", 2, rowCount, parent, buttonAction, nil, updateAction, searchAction, filterAction)
end

function CreateTasButtonListV3(rowCount, parent, buttonAction, updateAction, searchAction, filterAction)
    return CreateTasButtonListEx("TasButtonGrid", 3, rowCount, parent, buttonAction, nil, updateAction, searchAction, filterAction)
end

function CreateTasButtonBoxedTextList(rowCount, colCount, parent, buttonAction, updateAction, searchAction, filterAction)
    return CreateTasButtonListEx("TasBoxedTextButtonSmall", colCount, rowCount, parent, buttonAction, nil, updateAction or UpdateTasButtonListDefaultText, searchAction or SearchTasButtonListDefaultText, filterAction)
end
function CreateTasButtonBoxedTextListBig(rowCount, colCount, parent, buttonAction, updateAction, searchAction, filterAction)
    return CreateTasButtonListEx("TasBoxedTextButton", colCount, rowCount, parent, buttonAction, nil, updateAction or UpdateTasButtonListDefaultText, searchAction or SearchTasButtonListDefaultText, filterAction)
end

function CreateTasButtonTextList(rowCount, colCount, parent, buttonAction, updateAction, searchAction, filterAction)
    return CreateTasButtonListEx("TasTextButtonSmall", colCount, rowCount, parent, buttonAction, nil, updateAction or UpdateTasButtonListDefaultText, searchAction or SearchTasButtonListDefaultText, filterAction)
end
function CreateTasButtonTextListBig(rowCount, colCount, parent, buttonAction, updateAction, searchAction, filterAction)
    return CreateTasButtonListEx("TasTextButton", colCount, rowCount, parent, buttonAction, nil, updateAction or UpdateTasButtonListDefaultText, searchAction or SearchTasButtonListDefaultText, filterAction)
end
