if Debug then Debug.beginFile("FrameList") end
--[[
    FrameList V1.0 by Tasyen
    A Frame that contains 1 Row or Col of Frames, a fraction of the added Frames is displayed at once. The user can change the shown frames by scrolling a slider.
    FrameLists can also contain a FrameList.
    The displayed amount of Frames depends on the FrameList size, this Size only changes when changed with BlzFrameSetSize or better the special version added into this.
--]]
OnInit("FrameList", function ()
    BlzLoadTOCFile("war3mapimported\\FrameList.toc")

    ---@class FrameList
    ---@field public Frame framehandle
    ---@field public Slider framehandle
    ---@field public Mode FrameListMode
    ---@field public Horizontal FrameListMode
    ---@field public Vertical FrameListMode
    ---@field private Content framehandle[]
    local FrameList = {}
    FrameList.__index = FrameList

    ---@class FrameListMode
    ---@field public FirstActivePoint framepointtype
    ---@field public FirstPassivePoint framepointtype
    ---@field public FirstOffsetX number
    ---@field public FirstOffsetY number
    ---@field public SecondActivePoint framepointtype
    ---@field public SecondPassivePoint framepointtype
    ---@field public SecondOffsetX number
    ---@field public SecondOffsetY number
    ---@field protected GetSize fun(frame: framehandle): number

    FrameList.Horizontal = {
        --1. to slider
        FirstActivePoint = FRAMEPOINT_BOTTOMLEFT,
        FirstPassivePoint = FRAMEPOINT_TOPLEFT,
        FirstOffsetX = 0,
        FirstOffsetY = 0,
        --2. to 1.
        SecondActivePoint = FRAMEPOINT_BOTTOMLEFT,
        SecondPassivePoint = FRAMEPOINT_BOTTOMRIGHT,
        SecondOffsetX = 0,
        SecondOffsetY = 0,
        --function to get size
        GetSize = BlzFrameGetWidth,
    }

    FrameList.Vertical = {
        FirstActivePoint = FRAMEPOINT_TOPRIGHT,
        FirstPassivePoint = FRAMEPOINT_TOPLEFT,
        FirstOffsetX = 0,
        FirstOffsetY = 0,
        SecondActivePoint = FRAMEPOINT_TOPRIGHT,
        SecondPassivePoint = FRAMEPOINT_BOTTOMRIGHT,
        SecondOffsetX = 0,
        SecondOffsetY = 0,
        GetSize = BlzFrameGetHeight,
    }

    local SliderTrigger = CreateTrigger()
    TriggerAddAction(SliderTrigger, function ()
        local frame = BlzGetTriggerFrame()
        if GetLocalPlayer() == GetTriggerPlayer() then
            if BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_WHEEL then
                if BlzGetTriggerFrameValue() > 0 then
                    BlzFrameSetValue(frame, BlzFrameGetValue(frame) - 1)
                else
                    BlzFrameSetValue(frame, BlzFrameGetValue(frame) + 1)
                end
            end
            FrameList[frame]:setContentPoints()
        end
    end)

    ---Creates a new FrameList horizontal (true) <-> (false/nil) ^v
    ---@param horizontal? boolean
    ---@param parent? framehandle
    ---@param createContext? integer
    ---@return FrameList
    function FrameList.create(horizontal, parent, createContext)
        local frameListTable = setmetatable({}, FrameList) ---@type FrameList
        createContext = createContext or 0
        parent = parent or BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
        if not horizontal then
            frameListTable.Frame = BlzCreateFrame("FrameListV", parent, 0, createContext)
            frameListTable.Slider = BlzGetFrameByName("FrameListSliderV", createContext)
            frameListTable.Mode = FrameList.Vertical
        else
            frameListTable.Frame = BlzCreateFrame("FrameListH", parent, 0, createContext)
            frameListTable.Slider = BlzGetFrameByName("FrameListSliderH", createContext)
            frameListTable.Mode = FrameList.Horizontal
        end
        BlzFrameSetParent(frameListTable.Slider, parent)
        frameListTable.Content = {}
        FrameList[frameListTable.Slider] = frameListTable
        FrameList[frameListTable.Frame] = frameListTable
        BlzTriggerRegisterFrameEvent(SliderTrigger, frameListTable.Slider , FRAMEEVENT_SLIDER_VALUE_CHANGED)
        BlzTriggerRegisterFrameEvent(SliderTrigger, frameListTable.Slider , FRAMEEVENT_MOUSE_WHEEL)
        return frameListTable
    end

    ---Update the shown content, should be done automatic
    function FrameList:setContentPoints()
        local sizeFrameList = self.Mode.GetSize(self.Frame)
        local contentCount = #self.Content
        local sliderValue = contentCount - math.tointeger(BlzFrameGetValue(self.Slider))

        for index = 1, contentCount, 1 do
            local frame = self.Content[index]
            if index < sliderValue then
                --print("Hide Prev", index)
                BlzFrameSetVisible(frame, false)
            else
                local sizeFrame = self.Mode.GetSize(frame)
                sizeFrameList = sizeFrameList - sizeFrame
                BlzFrameClearAllPoints(frame)
                if index == sliderValue then
                    BlzFrameSetVisible(frame, true)
                    BlzFrameSetPoint(frame, self.Mode.FirstActivePoint, self.Slider, self.Mode.FirstPassivePoint, self.Mode.FirstOffsetX, self.Mode.FirstOffsetY)
                else
                    BlzFrameSetVisible(frame, sizeFrameList >= 0)
                    BlzFrameSetPoint(frame, self.Mode.SecondActivePoint, self.Content[index - 1], self.Mode.SecondPassivePoint, self.Mode.SecondOffsetX, self.Mode.SecondOffsetY)
                end
            end
        end
    end

    ---A custom Width seter, it makes the slider more accurate without the slider can not be clicked correctly.
    ---@param xSize number
    ---@param ySize number
    function FrameList:setSize(xSize, ySize)
        BlzFrameSetSize(self.Frame, xSize, ySize)
        if self.Mode == FrameList.Horizontal then
            BlzFrameSetSize(self.Slider, xSize, 0.012) -- ySize of slider is constant in horizontal mode
        else
            BlzFrameSetSize(self.Slider, 0.012, ySize)
        end
    end

    ---Adds frame to as last element of frameListTable
    ---@param frame framehandle
    function FrameList:add(frame)
        table.insert(self.Content, frame)
        --BlzFrameSetParent(frame, self.Frame)
        BlzFrameSetMinMaxValue(self.Slider, 1, #self.Content)
        BlzFrameSetValue(frame, 1)
        self:setContentPoints()
    end

    ---Removes frame (can be a number) from frameListTable, skip noUpdate that is only used from FrameList.destory
    ---@param frame framehandle | integer
    ---@param noUpdate? boolean
    ---@return number | boolean
    function FrameList:remove(frame, noUpdate)
        local removed ---@type framehandle
        if #self.Content == 0 then return false end
        if not frame then
            removed = table.remove(self.Content)
        elseif type(frame) == "number" then
            removed = table.remove(self.Content, frame)
        else
            for index, value in ipairs(self.Content) do
                if frame == value then
                    removed = table.remove(self.Content, index)
                    break
                end
            end
        end

        if removed then
            BlzFrameClearAllPoints(removed)
            BlzFrameSetVisible(removed, false)
            if not noUpdate then
                BlzFrameSetMinMaxValue(self.Slider, 1, #self.Content)
                BlzFrameSetValue(self.Slider, #self.Content)
                self:setContentPoints()
            end
        end
        return #self.Content
    end

    ---Destroys the frameListTable control Frames and hides and clears all points Frames in the FrameList
    function FrameList:destroy()
        FrameList[self.Slider] = nil
        FrameList[self.Frame] = nil
        BlzDestroyFrame(self.Frame)
        BlzDestroyFrame(self.Slider)
        self.Mode = nil
        self.Frame = nil
        repeat until not FrameList:remove(nil, true)
        self.Content = nil
    end

    return FrameList
end)
if Debug then Debug.endFile() end