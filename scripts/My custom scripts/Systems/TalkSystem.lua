Debug.beginFile("TalkSystem")
OnInit("TalkSystem", function ()
    Require "Transmission"
    Require "GlobalRemap"

    local TALK = FourCC('I04C')
    local SELECT_HERO = FourCC('A0EQ')
    local SELL_ITEMS = FourCC('Asid')

    ---@class Talk
    ---@field id integer
    ---@field talker unit
    ---@field lines string[]
    ---@field delays string[]

    local Talks = {} ---@type table<integer, Talk>
    local actualThread = nil ---@type thread
    local actualId = 0
    local added = __jarray(false) ---@type table<unit, boolean>

    ---@param talker unit
    ---@param lines string[]
    ---@param delays string[]
    local function Define(talker, lines, delays)
        assert(not Talks[actualId], "TalkSystem: You are overwritting the id: " .. actualId)
        Talks[actualId] = {
            id = actualId,
            talker = talker,
            lines = lines,
            delays = delays
        }
        if not added[talker] then
            added[talker] = true
            UnitAddAbility(talker, SELL_ITEMS)
            UnitAddAbility(talker, SELECT_HERO)
            AddItemToStock(talker, TALK, 1, 1)
        end
    end

    -- To prevent the unit portrait being replaced
    AddHook("SetCinematicScene", function (portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration)
        DisplayTextToPlayer(GetLocalPlayer(), 0, 0, "|cffccff00" .. speakerTitle .. ":|r " .. text)
    end)

    local talkRun = CreateTrigger()
    TriggerAddAction(talkRun, function ()
        local thr = actualThread
        actualThread = nil

        local talk = Talks[udg_TalkId]
        local receiver = udg_TalkTo
        local name = GetHeroProperName(talk.talker)

        if receiver then
            SetUnitFacing(receiver, math.deg(math.atan(GetUnitY(talk.talker) - GetUnitY(receiver), GetUnitX(talk.talker) - GetUnitX(receiver))))
            UnitAbortCurrentOrder(receiver)
            PauseUnit(receiver, true)
        end

        local transmission = Transmission.create(udg_TalkToForce)
        for i = 1, #talk.lines do
            transmission:AddLine(talk.talker, nil, name, nil, talk.lines[i], Transmission.SET, talk.delays[i], true)
        end
        transmission:AddEnd(function ()
            if receiver then
                PauseUnit(receiver, false)
            end
            coroutine.resume(thr)
        end)
        transmission:Start()

        udg_TalkTo = nil
        udg_TalkToForce = nil
    end)

    local dummyTrigger = CreateTrigger()

    GlobalRemap("udg_TalkRun", function ()
        actualThread = coroutine.running()
        TriggerExecute(talkRun)
        coroutine.yield()
        return dummyTrigger
    end)

    DestroyForce(udg_TalkToForce)
    udg_TalkToForce = nil

    udg_TalkDefine = CreateTrigger()
    TriggerAddAction(udg_TalkDefine, function ()
        Define(udg_TalkFrom, udg_TalkLines, udg_TalkDelays)
        udg_TalkId = actualId
        udg_TalkFrom = nil
        udg_TalkLines = __jarray("")
        udg_TalkDelays = __jarray(0)
        actualId = actualId + 1
    end)

end)
Debug.endFile()