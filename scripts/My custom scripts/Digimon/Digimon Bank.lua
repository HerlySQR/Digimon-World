do
    local MAX_STOCK = 6

    local Bank = {}
    local LocalPlayer = nil ---@type player

    OnMapInit(function ()
        LocalPlayer = GetLocalPlayer()
        for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
            Bank[i] = {
                stocked = {},
                inUse = {},
                pressed = -1,
                p = Player(i),
                main = nil,
                spawnPoint = {
                    x = GetRectCenterX(gg_rct_Player_1_Spawn),
                    y = GetRectCenterY(gg_rct_Player_1_Spawn)
                },
                allDead = false
            }
        end
    end)

    local onCombat = __jarray(0) ---@type real[]

    OnMapInit(function ()
        Digimon.postDamageEvent(function (info)
            onCombat[info.target] = 3.
            Timed.echo(function ()
                local cd = onCombat[info.target] - 1
                onCombat[info.target] = cd
                if cd <= 0 then
                    return true
                end
            end)
        end)
    end)

    -- Conditions

    local function UseDigimonConditions(bank)
        return GetDigimonCooldown(bank.stocked[bank.pressed]) <= 0
    end

    local function StoreDigimonConditions(bank)
        if onCombat[bank.stocked[bank.pressed]] > 0 then
            return false
        end
        local max = 0
        for i = 0, 5 do
            if bank.inUse[i] then
                max = max + 1
            end
        end
        if max <= 1 then
            return false
        end
        return true
    end

    local function FreeDigimonConditions(bank)
        return GetDigimonCount(bank.p) > 1
    end

    local function SearchMain(bank)
        for i = 0, MAX_STOCK - 1 do
            if bank.inUse[i] then
                bank.main = bank.inUse[i]
                return true
            end
        end
        bank.main = nil
        return false
    end

    -- Returns true if the player is using this Digimon
    local function StoreDigimon(bank, index, hide)
        local d = bank.inUse[index] ---@type Digimon
        if d then
            bank.inUse[index] = nil
            if bank.main == d then
                SearchMain(bank)
            end
            if hide then
                d:setOwner(Digimon.PASSIVE)
                d:hideInTheCorner()
            end
            return true
        end
        return false
    end

    -- Returns true if the slot has a digimon avaible to summon
    local function Avaible(bank, index)
        return index ~= -1 and bank.stocked[index] ~= nil and bank.inUse[index] == nil
    end

    local SummonADigimon = nil ---@type framehandle
    local StockedDigimonsMenu = nil ---@type framehandle
    local Exit = nil ---@type framehandle
    local TriggerExit = nil ---@type framehandle
    local DigimonT = {} ---@type framehandle[]
    local BackdropDigimonT = {} ---@type framehandle[]
    local DigimonTUsed = {} ---@type framehandle[]
    local DigimonTSelected = {} ---@type framehandle[]
    local DigimonTCooldownT = {} ---@type framehandle[]
    local DigimonTTooltip = {} ---@type framehandle[]
    local DigimonTTooltipTitle = {} ---@type framehandle[]
    local DigimonTTooltipDescription = {} ---@type framehandle[]
    local DigimonTTooltipStatus = {} ---@type framehandle[]
    local Text = nil ---@type framehandle
    local Summon = nil ---@type framehandle
    local Store = nil ---@type framehandle
    local Free = nil ---@type framehandle
    local Warning = nil ---@type framehandle
    local AreYouSure = nil ---@type framehandle
    local Yes = nil ---@type framehandle
    local No = nil ---@type framehandle

    -- Always use this function in a "if player == GetLocalPlayer() then" block
    local function UpdateMenu()
        local bank = Bank[GetPlayerId(LocalPlayer)]
        for i = 0, MAX_STOCK - 1 do
            local d = bank.stocked[i] ---@type Digimon
            if d then
                -- Button
                BlzFrameSetEnable(DigimonT[i], true)
                BlzFrameSetTexture(BackdropDigimonT[i], BlzGetAbilityIcon(d:getTypeId()), 0, true)
                -- Tooltip
                BlzFrameSetText(DigimonTTooltipTitle[i], GetUnitName(d.root))
                BlzFrameSetText(DigimonTTooltipDescription[i], BlzGetAbilityExtendedTooltip(d:getTypeId(), 0))
                if bank.inUse[i] then
                    BlzFrameSetText(DigimonTTooltipStatus[i], "|cff0000ffIn use|r")
                    BlzFrameSetVisible(DigimonTUsed[i], true)
                    BlzFrameSetAlpha(DigimonTUsed[i], 127)
                else
                    BlzFrameSetText(DigimonTTooltipStatus[i], "|cff00ff00Stored|r")
                    BlzFrameSetVisible(DigimonTUsed[i], false)
                end
            else
                -- Button
                BlzFrameSetEnable(DigimonT[i], false)
                BlzFrameSetTexture(BackdropDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
                -- Tooltip
                BlzFrameSetText(DigimonTTooltipTitle[i], "Empty slot")
                BlzFrameSetText(DigimonTTooltipDescription[i], "")
                BlzFrameSetText(DigimonTTooltipStatus[i], "")
            end
        end
    end

    -- When the digimon evolves
    OnTrigInit(function ()
        Digimon.evolutionEvent(function (evolve)
            if evolve:getOwner() == LocalPlayer then
                UpdateMenu()
            end
        end)
    end)

    local function PressedActions(i)
        local bank = Bank[GetPlayerId(GetTriggerPlayer())]
        if GetTriggerPlayer() == LocalPlayer then
            -- Refresh the last pressed button
            BlzFrameSetVisible(DigimonTSelected[bank.pressed], false)
            BlzFrameSetEnable(DigimonT[bank.pressed], true)
            -- Updates the new pressed button
            BlzFrameSetVisible(DigimonTSelected[i], true)
            BlzFrameSetEnable(DigimonT[i], false)
            -- Other changes
            if bank.inUse[i] then
                BlzFrameSetVisible(Summon, false)
                BlzFrameSetVisible(Store, true)
            else
                BlzFrameSetVisible(Summon, true)
                BlzFrameSetVisible(Store, false)
            end
        end
        bank.pressed = i
    end

    local function InitFrames()

        local t = nil ---@type trigger

        local x1 = {}
        local y1 = {}
        local x2 = {}
        local y2 = {}

        x1[0] = 0.030000
        y1[0] = -0.051428
        x2[0] = -0.15033
        y2[0] = 0.098960

        x1[1] = 0.089667
        y1[1] = -0.051428
        x2[1] = -0.090666
        y2[1] = 0.098960

        x1[2] = 0.14933
        y1[2] = -0.051428
        x2[2] = -0.030999
        y2[2] = 0.098960

        x1[3] = 0.030000
        y1[3] = -0.10104
        x2[3] = -0.15033
        y2[3] = 0.049348

        x1[4] = 0.089667
        y1[4] = -0.10104
        x2[4] = -0.090666
        y2[4] = 0.049348

        x1[5] = 0.14933
        y1[5] = -0.10104
        x2[5] = -0.030999
        y2[5] = 0.049348

        SummonADigimon = BlzCreateFrame("ScriptDialogButton", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(SummonADigimon, FRAMEPOINT_TOPLEFT, 0.0100000, 0.205000)
        BlzFrameSetAbsPoint(SummonADigimon, FRAMEPOINT_BOTTOMRIGHT, 0.140000, 0.170000)
        BlzFrameSetText(SummonADigimon, "|cffFCD20DSummon/Store a Digimon|r")
        BlzFrameSetScale(SummonADigimon, 0.90)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, SummonADigimon, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, function ()
            local p = GetTriggerPlayer()
            if p == LocalPlayer then
                BlzFrameSetVisible(SummonADigimon, false)
                BlzFrameSetVisible(StockedDigimonsMenu, true)
                UpdateMenu()
            end
        end)

        StockedDigimonsMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0),0,0)
        BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.00000, 0.340000)
        BlzFrameSetAbsPoint(StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, 0.220000, 0.150000)
        BlzFrameSetVisible(StockedDigimonsMenu, false)

        Exit = BlzCreateFrame("BrowserButton", StockedDigimonsMenu,0,0)
        BlzFrameSetAbsPoint(Exit, FRAMEPOINT_TOPLEFT, 0.190000, 0.330000)
        BlzFrameSetAbsPoint(Exit, FRAMEPOINT_BOTTOMRIGHT, 0.210000, 0.310000)
        BlzFrameSetText(Exit, "|cffFCD20DX|r")
        BlzFrameSetScale(Exit, 1.00)
        TriggerExit = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerExit, Exit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerExit, function ()
            local bank = Bank[GetPlayerId(GetTriggerPlayer())]
            if GetTriggerPlayer() == LocalPlayer then
                BlzFrameSetVisible(SummonADigimon, true)
                BlzFrameSetVisible(StockedDigimonsMenu, false)
                BlzFrameSetVisible(DigimonTUsed[bank.pressed], false)
                BlzFrameSetVisible(DigimonTSelected[bank.pressed], false)
            end
            bank.pressed = -1
        end)

        for i = 0, 5 do
            DigimonT[i] = BlzCreateFrame("ScriptDialogButton", StockedDigimonsMenu, 0, 0)
            BlzFrameSetPoint(DigimonT[i], FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, x1[i], y1[i])
            BlzFrameSetPoint(DigimonT[i], FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, x2[i], y2[i])
            BackdropDigimonT[i] = BlzCreateFrameByType("BACKDROP", "BackdropDigimonT[" .. i .. "]", DigimonT[i], "", 1)
            BlzFrameSetAllPoints(BackdropDigimonT[i], DigimonT[i])
            BlzFrameSetTexture(BackdropDigimonT[i], "ReplaceableTextures\\CommandButtons\\BTNCancel.blp", 0, true)
            BlzFrameSetLevel(BackdropDigimonT[i], 1)
            t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, DigimonT[i], FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () PressedActions(i) end) -- :D

            DigimonTUsed[i] = BlzCreateFrameByType("BACKDROP", "Used", DigimonT[i], "", 1)
            BlzFrameSetPoint(DigimonTUsed[i], FRAMEPOINT_TOPLEFT, DigimonT[i], FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetPoint(DigimonTUsed[i], FRAMEPOINT_BOTTOMRIGHT, DigimonT[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
            BlzFrameSetTexture(DigimonTUsed[i], "UI\\Widgets\\Console\\Human\\human-console-button-highlight.blp", 0, true)
            BlzFrameSetAlpha(DigimonTUsed[i], 127)
            BlzFrameSetLevel(DigimonTUsed[i], 2)
            BlzFrameSetVisible(DigimonTUsed[i], false)

            DigimonTSelected[i] = BlzCreateFrameByType("BACKDROP", "Selected", DigimonT[i], "", 1)
            BlzFrameSetPoint(DigimonTSelected[i], FRAMEPOINT_TOPLEFT, DigimonT[i], FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetPoint(DigimonTSelected[i], FRAMEPOINT_BOTTOMRIGHT, DigimonT[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
            BlzFrameSetTexture(DigimonTSelected[i], "UI\\Widgets\\EscMenu\\Human\\checkbox-background.blp", 0, true)
            BlzFrameSetLevel(DigimonTSelected[i], 3)
            BlzFrameSetVisible(DigimonTSelected[i], false)

            DigimonTCooldownT[i] = BlzCreateFrameByType("TEXT", "name", DigimonT[i], "", 0)
            BlzFrameSetPoint(DigimonTCooldownT[i], FRAMEPOINT_TOPLEFT, DigimonT[i], FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
            BlzFrameSetPoint(DigimonTCooldownT[i], FRAMEPOINT_BOTTOMRIGHT, DigimonT[i], FRAMEPOINT_BOTTOMRIGHT, 0.0000, 0.0000)
            BlzFrameSetText(DigimonTCooldownT[i], "60")
            BlzFrameSetEnable(DigimonTCooldownT[i], false)
            BlzFrameSetScale(DigimonTCooldownT[i], 2.14)
            BlzFrameSetTextAlignment(DigimonTCooldownT[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)
            BlzFrameSetLevel(DigimonTCooldownT[i], 4)
            BlzFrameSetVisible(DigimonTCooldownT[i], false)

            DigimonTTooltip[i] = BlzCreateFrame("QuestButtonDisabledBackdropTemplate", DigimonT[i],0,0)
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_TOPLEFT, DigimonT[i], FRAMEPOINT_TOPLEFT, 0.022437, 0.088828)
            BlzFrameSetPoint(DigimonTTooltip[i], FRAMEPOINT_BOTTOMRIGHT, DigimonT[i], FRAMEPOINT_BOTTOMRIGHT, 0.12277, 0.018440)
            BlzFrameSetTooltip(DigimonT[i], DigimonTTooltip[i])

            DigimonTTooltipTitle[i] = BlzCreateFrameByType("TEXT", "name", DigimonTTooltip[i], "", 0)
            BlzFrameSetPoint(DigimonTTooltipTitle[i], FRAMEPOINT_TOPLEFT, DigimonTTooltip[i], FRAMEPOINT_TOPLEFT, 0.0075630, -0.012400)
            BlzFrameSetPoint(DigimonTTooltipTitle[i], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltip[i], FRAMEPOINT_BOTTOMRIGHT, -0.012437, 0.077600)
            BlzFrameSetText(DigimonTTooltipTitle[i], "|cffFFCC00Title|r")
            BlzFrameSetEnable(DigimonTTooltipTitle[i], false)
            BlzFrameSetScale(DigimonTTooltipTitle[i], 1.14)
            BlzFrameSetTextAlignment(DigimonTTooltipTitle[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)

            DigimonTTooltipDescription[i] = BlzCreateFrameByType("TEXT", "name", DigimonTTooltip[i], "", 0)
            BlzFrameSetPoint(DigimonTTooltipDescription[i], FRAMEPOINT_TOPLEFT, DigimonTTooltip[i], FRAMEPOINT_TOPLEFT, 0.0075630, -0.027400)
            BlzFrameSetPoint(DigimonTTooltipDescription[i], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltip[i], FRAMEPOINT_BOTTOMRIGHT, -0.012437, 0.032600)
            BlzFrameSetText(DigimonTTooltipDescription[i], "|cffFFCC00Description|r")
            BlzFrameSetEnable(DigimonTTooltipDescription[i], false)
            BlzFrameSetScale(DigimonTTooltipDescription[i], 1.14)
            BlzFrameSetTextAlignment(DigimonTTooltipDescription[i], TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

            DigimonTTooltipStatus[i] = BlzCreateFrameByType("TEXT", "name", DigimonTTooltip[i], "", 0)
            BlzFrameSetPoint(DigimonTTooltipStatus[i], FRAMEPOINT_TOPLEFT, DigimonTTooltip[i], FRAMEPOINT_TOPLEFT, 0.0075630, -0.077400)
            BlzFrameSetPoint(DigimonTTooltipStatus[i], FRAMEPOINT_BOTTOMRIGHT, DigimonTTooltip[i], FRAMEPOINT_BOTTOMRIGHT, -0.012437, 0.012600)
            BlzFrameSetText(DigimonTTooltipStatus[i], "|cffFFCC00Status|r")
            BlzFrameSetEnable(DigimonTTooltipStatus[i], false)
            BlzFrameSetScale(DigimonTTooltipStatus[i], 1.14)
            BlzFrameSetTextAlignment(DigimonTTooltipStatus[i], TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_LEFT)
        end

        Text = BlzCreateFrameByType("TEXT", "name", StockedDigimonsMenu, "", 0)
        BlzFrameSetAbsPoint(Text, FRAMEPOINT_TOPLEFT, 0.0500000, 0.320000)
        BlzFrameSetAbsPoint(Text, FRAMEPOINT_BOTTOMRIGHT, 0.170000, 0.290000)
        BlzFrameSetText(Text, "|cffFFCC00Choose a Digimon|r")
        BlzFrameSetEnable(Text, false)
        BlzFrameSetScale(Text, 1.00)
        BlzFrameSetTextAlignment(Text, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        Summon = BlzCreateFrame("BrowserButton", StockedDigimonsMenu,0,0)
        BlzFrameSetPoint(Summon, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.14500)
        BlzFrameSetPoint(Summon, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.11000, 0.02000)
        BlzFrameSetText(Summon, "|cffFCD20DSummon|r")
        BlzFrameSetScale(Summon, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, Summon, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, function ()
            local p = GetTriggerPlayer()
            if p == LocalPlayer then
                BlzFrameSetVisible(Summon, false)
                BlzFrameSetVisible(Store, true)
            end
            SummonDigimon(p, Bank[GetPlayerId(p)].pressed)
        end)

        Store = BlzCreateFrame("BrowserButton", StockedDigimonsMenu,0,0)
        BlzFrameSetPoint(Store, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.030000, -0.14500)
        BlzFrameSetPoint(Store, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.11000, 0.02000)
        BlzFrameSetText(Store, "|cffFCD20DStore|r")
        BlzFrameSetScale(Store, 1.00)
        BlzFrameSetVisible(Store, false)
        TriggerStore = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerStore, Store, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerStore, function ()
            local p = GetTriggerPlayer()
            local bank = Bank[GetPlayerId(p)]
            StoreDigimon(bank, bank.pressed, true)
            if p == LocalPlayer then
                BlzFrameSetVisible(Summon, true)
                BlzFrameSetVisible(Store, false)
                UpdateMenu()
            end
        end)

        Free = BlzCreateFrame("BrowserButton", StockedDigimonsMenu,0,0)
        BlzFrameSetPoint(Free, FRAMEPOINT_TOPLEFT, StockedDigimonsMenu, FRAMEPOINT_TOPLEFT, 0.11000, -0.14500)
        BlzFrameSetPoint(Free, FRAMEPOINT_BOTTOMRIGHT, StockedDigimonsMenu, FRAMEPOINT_BOTTOMRIGHT, -0.030000, 0.02000)
        BlzFrameSetText(Free, "|cffFCD20DFree|r")
        BlzFrameSetScale(Free, 1.00)
        BlzFrameSetEnable(Free, false)
        TriggerFree = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerFree, Free, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerFree, function ()
            if GetTriggerPlayer() == LocalPlayer then
                BlzFrameSetFocus(StockedDigimonsMenu, false)
                BlzFrameSetFocus(Warning, true)
                BlzFrameSetVisible(Warning, true)
                BlzFrameCageMouse(Warning, true)
            end
        end)

        Warning = BlzCreateFrame("QuestButtonBaseTemplate", Free,0,0)
        BlzFrameSetPoint(Warning, FRAMEPOINT_TOPLEFT, Free, FRAMEPOINT_TOPLEFT, -0.020000, 0.025000)
        BlzFrameSetPoint(Warning, FRAMEPOINT_BOTTOMRIGHT, Free, FRAMEPOINT_BOTTOMRIGHT, 0.030000, -0.010000)
        BlzFrameSetVisible(Warning, false)

        AreYouSure = BlzCreateFrameByType("TEXT", "name", Warning, "", 0)
        BlzFrameSetPoint(AreYouSure, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.0050000, -0.0050000)
        BlzFrameSetPoint(AreYouSure, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.0050000, 0.025000)
        BlzFrameSetText(AreYouSure, "|cffFFCC00Are you sure you wanna free this digimon?|r")
        BlzFrameSetEnable(AreYouSure, false)
        BlzFrameSetScale(AreYouSure, 1.00)
        BlzFrameSetTextAlignment(AreYouSure, TEXT_JUSTIFY_CENTER, TEXT_JUSTIFY_MIDDLE)

        Yes = BlzCreateFrame("BrowserButton", Warning,0,0)
        BlzFrameSetPoint(Yes, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.010000, -0.035000)
        BlzFrameSetPoint(Yes, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.070000, 0.0050000)
        BlzFrameSetText(Yes, "|cffFCD20DYes|r")
        BlzFrameSetScale(Yes, 1.00)
        TriggerYes = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerYes, Yes, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerYes, function ()
            local p = GetTriggerPlayer()
            local bank = Bank[GetPlayerId(p)]
            if p == LocalPlayer then
                BlzFrameSetEnable(Free, false)
                BlzFrameSetEnable(Summon, false)
                UpdateMenu()
                BlzFrameCageMouse(Warning, false)
                BlzFrameSetVisible(Warning, false)
                BlzFrameSetFocus(StockedDigimonsMenu, true)
                BlzFrameSetVisible(DigimonTUsed[bank.pressed], false)
                BlzFrameSetVisible(DigimonTSelected[bank.pressed], false)
            end
            RemoveFromBank(p, bank.pressed)
        end)

        No = BlzCreateFrame("BrowserButton", Warning,0,0)
        BlzFrameSetPoint(No, FRAMEPOINT_TOPLEFT, Warning, FRAMEPOINT_TOPLEFT, 0.070000, -0.035000)
        BlzFrameSetPoint(No, FRAMEPOINT_BOTTOMRIGHT, Warning, FRAMEPOINT_BOTTOMRIGHT, -0.010000, 0.0050000)
        BlzFrameSetText(No, "|cffFCD20DNo|r")
        BlzFrameSetScale(No, 1.00)
        TriggerNo = CreateTrigger()
        BlzTriggerRegisterFrameEvent(TriggerNo, No, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(TriggerNo, function ()
            if GetTriggerPlayer() == LocalPlayer then
                BlzFrameCageMouse(Warning, false)
                BlzFrameSetVisible(Warning, false)
                BlzFrameSetFocus(StockedDigimonsMenu, true)
            end
        end)

    end

    OnMapInit(function ()
        InitFrames()
        FrameLoaderAdd(InitFrames)
        -- Update frames
        Timed.echo(function ()
            for i = 0, PLAYER_NEUTRAL_AGGRESSIVE do
                local bank = Bank[i]
                if bank.p == LocalPlayer then
                    BlzFrameSetEnable(Summon, UseDigimonConditions(bank) and Avaible(bank, bank.pressed))
                    BlzFrameSetEnable(Store, StoreDigimonConditions(bank) and bank.inUse[bank.pressed] ~= nil)
                    BlzFrameSetEnable(Free, FreeDigimonConditions(bank) and bank.inUse[bank.pressed] ~= nil)
                end
            end
        end, 0.03125)
    end)

    -- Functions to use

    ---@param p player
    ---@param d Digimon
    ---@return boolean
    function IsMainDigimon(p, d)
        return Bank[GetPlayerId(p)].main == d
    end

    ---@param p player
    ---@param d Digimon
    ---@return boolean
    function SendToBank(p, d)
        local bank = Bank[GetPlayerId(p)]
        local index = -1
        for i = 0, MAX_STOCK - 1 do
            if not bank.stocked[i] then
                bank.stocked[i] = d
                d:setOwner(Digimon.PASSIVE)
                d:hideInTheCorner()
                if bank.main == d then
                    SearchMain(bank)
                end
                index = i
                break
            end
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
        return index
    end

    ---@param p player
    ---@param index integer
    ---@return boolean
    function SummonDigimon(p, index)
        local bank = Bank[GetPlayerId(p)]
        local d = bank.stocked[index] ---@type Digimon
        local b = false
        if d then
            bank.inUse[index] = d
            d:setOwner(p)
            if not bank.main then
                bank.main = d
                d:showFromTheCorner(bank.spawnPoint.x, bank.spawnPoint.y)
                d.environment:apply(p, false)
                if p == LocalPlayer then
                    PanCameraToTimed(bank.spawnPoint.x, bank.spawnPoint.y, 0)
                end
            else
                d:showFromTheCorner(bank.main:getX(), bank.main:getY())
                d.environment = bank.main.environment
            end
            b = true
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
        return b
    end

    ---@param p player
    ---@param index integer
    ---@return Digimon
    function RemoveFromBank(p, index)
        local bank = Bank[GetPlayerId(p)]
        local d = bank.stocked[index] ---@type Digimon
        if d then
            bank.stocked[index] = nil
            ReleaseDigimon(d:getOwner(), d)
            d:setOwner(Digimon.PASSIVE)
            if bank.inUse[index] then
                bank.inUse[index] = nil
            else
                d:showFromTheCorner(bank.main:getX(), bank.main:getY())
            end
            if bank.main == d then
                SearchMain(bank)
            end
        end
        if p == LocalPlayer then
            UpdateMenu()
        end
        return d
    end

    ---@param p player
    ---@param d Digimon
    ---@return integer
    function GetBankIndex(p, d)
        local bank = Bank[GetPlayerId(p)]
        for i = 0, 5 do
            if bank.stocked[i] == d then
                return i
            end
        end
        return -1
    end

    ---@param p player
    ---@param index integer
    ---@return Digimon
    function GetBankDigimon(p, index)
        return Bank[GetPlayerId(p)].stocked[index]
    end

    -- When dies
    local respawnTime = 60
    local cooldowns = __jarray(0) ---@type real[]

    OnMapInit(function ()
        Digimon.killEvent(function (_, dead)
            local p = dead:getOwner()
            if p ~= Digimon.NEUTRAL and p ~= Digimon.PASSIVE then
                local bank = Bank[GetPlayerId(p)]
                local allDead = true
                local index = -1
                for i = 0, 5 do
                    local d = bank.stocked[i]
                    if d then
                        if dead == d then
                            index = i
                        end
                        allDead = allDead and not d:isAlive()
                    end
                end
                -- If all the digimons died then the spawnpoint will be the clinic
                if allDead then
                    DisplayTextToPlayer(p, 0, 0, "All your digimons are death, they will respawn in the clinic")
                    bank.spawnPoint.x = GetRectCenterX(gg_rct_Hospital)
                    bank.spawnPoint.y = GetRectCenterY(gg_rct_Hospital)
                    -- The player can see all the map if all their digimons are dead
                    Environment.allMap:apply(p, false)
                else
                    bank.spawnPoint.x = GetRectCenterX(gg_rct_Player_1_Spawn)
                    bank.spawnPoint.y = GetRectCenterY(gg_rct_Player_1_Spawn)
                end
                bank.allDead = allDead

                StoreDigimon(bank, index, false)
                Timed.call(function () dead:setOwner(Digimon.PASSIVE) end) -- Just to not be detected by the auto-recycler
                -- Hide after 2 seconds to not do it automatically
                Timed.call(2., function ()
                    dead:hideInTheCorner()
                end)

                -- Cooldown
                cooldowns[dead] = respawnTime
                if p == LocalPlayer then
                    UpdateMenu()
                    BlzFrameSetVisible(DigimonTCooldownT[index], true)
                end
                Timed.echo(function ()
                    -- In case the digimon revived by another method
                    if dead:isAlive() then
                        cooldowns[dead] = 0
                        if p == LocalPlayer then
                            BlzFrameSetVisible(DigimonTCooldownT[index], false)
                        end
                        bank.allDead = false
                        return true
                    end

                    local cd = cooldowns[dead] - 1
                    cooldowns[dead] = cd
                    if p == LocalPlayer then
                        BlzFrameSetText(DigimonTCooldownT[index], tostring(math.floor(cd)))
                    end
                    if cd <= 0 then
                        ReviveHero(dead.root, dead:getX(), dead:getY(), false)
                        SetUnitLifePercentBJ(dead.root, 5)
                        if bank.allDead then
                            dead.environment = Environment.hospital
                            SummonDigimon(p, index)
                        end
                        if p == LocalPlayer then
                            BlzFrameSetVisible(DigimonTCooldownT[index], false)
                        end
                        bank.allDead = false
                        return true
                    end
                end, 1)
            end
        end)
    end)

    ---@param d Digimon
    ---@return real
    function GetDigimonCooldown(d)
        return cooldowns[d]
    end
end