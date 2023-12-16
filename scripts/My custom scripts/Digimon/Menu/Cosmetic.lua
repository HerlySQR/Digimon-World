Debug.beginFile("Cosmetic")
OnInit("Cosmetic", function ()
    Require "Savecode"
    Require "SaveFile"
    Require "PlayerDigimons"
    Require "PlayerUtils"
    Require "ErrorMessage"
    Require "FrameLoader"
    local FrameList = Require "FrameList" ---@type FrameList
    Require "Menu"
    Require "DigimonBank"

    local MAX_LENGTH_PASSWORD = 200
    local NO_SKIN = FourCC('n000')
    local DEFAULT_SKIN = FourCC('H002')
    local MAX_EFFECT_PER_ROW = 4
    local LocalPlayer = GetLocalPlayer()
    local ATTACH_SEUDONYM = {
        ["origin"] = "aura",
        ["chest"] = "chest"
    }

    local CosmeticOpen = nil ---@type framehandle
    local BackdropCosmeticOpen = nil ---@type framehandle
    local CosmeticMenu = nil ---@type framehandle
    local CosmeticText = nil ---@type framehandle
    local CosmeticAccept = nil ---@type framehandle
    local CosmeticExit = nil ---@type framehandle
    local CosmeticEffects = nil ---@type framehandle
    local CosmeticList = nil ---@type FrameList

    local CosmeticUnlock = nil ---@type framehandle
    local CosmeticUnlockText = nil ---@type framehandle
    local CosmeticUnlockCode = nil ---@type framehandle
    local CosmeticUnlockYes = nil ---@type framehandle

    local CosmeticPreviousDigimon = nil ---@type framehandle
    local CosmeticNextDigimon = nil ---@type framehandle

    local actualRow = MAX_EFFECT_PER_ROW
    local actualContainer = nil ---@type framehandle
    local camera = gg_cam_CosmeticModel ---@type camerasetup
    local model = CreateUnit(Digimon.PASSIVE, NO_SKIN, GetRectCenterX(gg_rct_CosmeticModel), GetRectCenterY(gg_rct_CosmeticModel), 0)
    local glow = AddSpecialEffect("war3mapImported\\GeneralHeroGlow.mdx", GetRectCenterX(gg_rct_CosmeticModel), GetRectCenterY(gg_rct_CosmeticModel))
    BlzSetSpecialEffectColorByPlayer(glow, Player(GetHandleId(PLAYER_COLOR_SNOW)))
    BlzSetSpecialEffectScale(glow, 2.)
    BlzSetSpecialEffectHeight(glow, BlzGetLocalSpecialEffectZ(glow) - 30.)
    BlzSetSpecialEffectAlpha(glow, 200)

    ---@class Cosmetic
    ---@field id integer
    ---@field icon string
    ---@field root string
    ---@field attachment string
    ---@field button framehandle
    ---@field unlockDesc string?
    ---@field lockFrame framehandle?

    ---@class CosmeticInstance
    ---@field id integer
    ---@field owner Digimon
    ---@field eff effect

    local Cosmetics = {} ---@type table<integer, Cosmetic>
    local LockedCosmetics = {} ---@type table<string, integer>
    local UnlockedCosmetics = {} ---@type table<player, table<integer, boolean>>
    local toUnlock = {} ---@type table<integer, boolean>

    local clickedEffect = __jarray(-1) ---@type table<player, integer>
    local lastEffect = {} ---@type table<player, effect>
    local selectedUnits = {} ---@type table<player, group>
    local inputCode = __jarray("") ---@type table<player, string>
    local digimonTypes = {} ---@type table<player, Digimon[]>
    local selectedDigimon = __jarray(1) ---@type table<player, integer>

    local modelEffects = {} ---@type table<player, table<string, effect>>

    local prevCamera = {} ---@type{targetX: number, targetY: number, targetZ: number, eyeX: number, eyeY: number, eyeZ: number, targetDistance: number, farZ: number, angleOfAttack: number, fieldOfView: number, roll: number, rotation: number, zOffset: number, nearZ: number, localPitch: number, localYaw: number, localRoll: number}
    local inMenu = false

    OnInit.final(function ()
        ForForce(FORCE_PLAYING, function ()
            UnlockedCosmetics[GetEnumPlayer()] = setmetatable({}, {__index = toUnlock})
            selectedUnits[GetEnumPlayer()] = CreateGroup()
            modelEffects[GetEnumPlayer()] = {}
        end)
        BlzFrameSetValue(CosmeticList.Slider, 99)
    end)

    Timed.echo(0.02, function ()
        if inMenu then
            CameraSetupApplyForceDuration(camera, false, 0)
        end
    end)

    ---@param p player
    local function UpdateModel(p)
        local d = digimonTypes[p][selectedDigimon[p]]

        for k, v in pairs(modelEffects[p]) do
            DestroyEffect(v)
            modelEffects[p][k] = nil
        end

        if p == LocalPlayer then
            if inMenu then
                BlzSetUnitSkin(model, d and d:getTypeId() or DEFAULT_SKIN)
            else
                BlzSetUnitSkin(model, NO_SKIN)
            end
        end

        local ignore = nil
        if clickedEffect[p] ~= -1 then
            local eff = ""
            if p == LocalPlayer then
                eff = Cosmetics[clickedEffect[p]].root
                BlzFrameSetEnable(CosmeticAccept, true)
            end
            if lastEffect[p] then
                BlzSetSpecialEffectAlpha(lastEffect[p], 0)
                DestroyEffect(lastEffect[p])
            end
            ignore = Cosmetics[clickedEffect[p]].attachment
            lastEffect[p] = AddSpecialEffectTarget(eff, model, ignore)
        end

        if d then
            for k, v in pairs(d.cosmetics) do
                if k ~= ignore then
                    local eff = ""
                    if p == LocalPlayer then
                        eff = Cosmetics[v.id].root
                    end
                    modelEffects[p][k] = AddSpecialEffectTarget(eff, model, k)
                end
            end
        end
    end

    ---@param id integer
    local function CosmeticActions(id)
        local p = GetTriggerPlayer()
        clickedEffect[p] = id
        UpdateModel(p)
    end

    local function CosmeticOpenFunc()
        local p = GetTriggerPlayer()

        if p == LocalPlayer then
            prevCamera.targetX = GetCameraTargetPositionX()
            prevCamera.targetY = GetCameraTargetPositionY()
            prevCamera.targetZ = GetCameraTargetPositionZ()
            prevCamera.targetDistance = GetCameraField(CAMERA_FIELD_TARGET_DISTANCE)
            prevCamera.farZ = GetCameraField(CAMERA_FIELD_FARZ)
            prevCamera.angleOfAttack = math.deg(GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK))
            --prevCamera.fieldOfView = GetCameraField(CAMERA_FIELD_FIELD_OF_VIEW)
            prevCamera.zOffset = GetCameraField(CAMERA_FIELD_ZOFFSET)
            prevCamera.nearZ = GetCameraField(CAMERA_FIELD_NEARZ)
        end

        local oldEnv = GetPlayerEnviroment(p)
        Environment.cosmeticModel:apply(p)
        LockEnvironment(p, true)
        oldEnv:apply(p)

        UnitShareVision(model, p, true)

        SyncSelections()
        GroupEnumUnitsSelected(selectedUnits[p], p)

        digimonTypes[p] = GetAllDigimons(p)

        if p == LocalPlayer then
            HideMenu(true)
            BlzFrameSetVisible(CosmeticMenu, true)
            BlzFrameSetEnable(CosmeticOpen, false)

            SetCameraTargetController(model, 0, 150, false)

            inMenu = true

            AddButtonToEscStack(CosmeticExit)
        end
        UpdateModel(p)
    end

    local function CosmeticAcceptFunc()
        local p = GetTriggerPlayer()
        if clickedEffect[p] == -1 then
            return
        end
        if p == LocalPlayer then
            BlzFrameSetText(CosmeticText, "|cff00FF00Effect applied|r")
        end

        ApplyCosmetic(p, clickedEffect[p], digimonTypes[p][selectedDigimon[p]])
        if lastEffect[p] then
            DestroyEffect(lastEffect[p])
            lastEffect[p] = nil
        end
        UpdateModel(p)

        Timed.call(3, function ()
            if p == LocalPlayer and BlzFrameGetText(CosmeticText) == "|cff00FF00Effect applied|r" then
                BlzFrameSetText(CosmeticText, "|cffFFCC00Choose an effect|r")
            end
        end)
    end

    local function CosmeticExitFunc()
        local p = GetTriggerPlayer()

        LockEnvironment(p, false)
        clickedEffect[p] = -1

        if lastEffect[p] then
            BlzSetSpecialEffectAlpha(lastEffect[p], 0)
            DestroyEffect(lastEffect[p])
            lastEffect[p] = nil
        end

        UnitShareVision(model, p, false)

        ForGroup(selectedUnits[p], function ()
            if p == LocalPlayer then
                SelectUnit(GetEnumUnit(), true)
            end
        end)
        GroupClear(selectedUnits[p])

        if p == LocalPlayer then
            ShowMenu(true)
            BlzFrameSetVisible(CosmeticMenu, false)

            ResetToGameCamera(0)
            PanCameraToTimedWithZ(prevCamera.targetX, prevCamera.targetY, prevCamera.targetZ, 0)
            SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, prevCamera.targetDistance, 0)
            SetCameraField(CAMERA_FIELD_FARZ, prevCamera.farZ, 0)
            SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, prevCamera.angleOfAttack, 0)
            --SetCameraField(CAMERA_FIELD_FIELD_OF_VIEW, prevCamera.fieldOfView, 0)
            SetCameraField(CAMERA_FIELD_ZOFFSET, prevCamera.zOffset, 0)
            SetCameraField(CAMERA_FIELD_NEARZ, prevCamera.nearZ, 0)

            BlzFrameSetEnable(CosmeticAccept, false)
            BlzFrameSetEnable(CosmeticOpen, true)

            inMenu = false

            RemoveButtonFromEscStack(CosmeticExit)

            BlzFrameSetText(CosmeticUnlockText, "|cffFFCC00Enter a code to unlock a cosmetic|r")
            BlzFrameSetText(CosmeticUnlockCode, "")
        end
        UpdateModel(p)
    end

    OnBankUpdated(function (p, d)
        if digimonTypes[p][selectedDigimon[p]] == d then
            selectedDigimon[p] = 1
        end
        digimonTypes[p] = GetAllDigimons(p)
        ClearCosmetics(d)
        if p == LocalPlayer then
            UpdateModel()
        end
    end)

    local function CosmeticUnlockCodeFunc()
        inputCode[GetTriggerPlayer()] = BlzGetTriggerFrameText()
    end

    local function CosmeticUnlockYesFunc()
        local p = GetTriggerPlayer()
        UnlockCosmetic(p, inputCode[p])
        if p == LocalPlayer then
            BlzFrameSetText(CosmeticUnlockCode, "")
        end
    end

    ---@param p player
    ---@param msg string
    local function EditUnlockMessage(p, msg)
        if p == LocalPlayer then
            BlzFrameSetText(CosmeticUnlockText, msg)
        end
        Timed.call(3., function ()
            if p == LocalPlayer then
                if BlzFrameGetText(CosmeticUnlockText) == msg then
                    BlzFrameSetText(CosmeticUnlockText, "|cffFFCC00Enter a code to unlock a cosmetic|r")
                end
            end
        end)
    end

    local function CosmeticPreviousDigimonFunc()
        local p = GetTriggerPlayer()
        local actDigi = selectedDigimon[p]
        selectedDigimon[p] = actDigi <= 1 and #digimonTypes[p] or actDigi - 1
        UpdateModel(p)
    end

    local function CosmeticNextDigimonFunc()
        local p = GetTriggerPlayer()
        local actDigi = selectedDigimon[p]
        selectedDigimon[p] = actDigi >= #digimonTypes[p] and 1 or actDigi + 1
        UpdateModel(p)
    end

    local function InitFrames()
        local t

        CosmeticOpen = BlzCreateFrame("IconButtonTemplate", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        BlzFrameSetAbsPoint(CosmeticOpen, FRAMEPOINT_TOPLEFT, 0.340000, 0.180000)
        BlzFrameSetAbsPoint(CosmeticOpen, FRAMEPOINT_BOTTOMRIGHT, 0.375000, 0.145000)
        BlzFrameSetVisible(CosmeticOpen, false)
        AddFrameToMenu(CosmeticOpen)
        AddDefaultTooltip(CosmeticOpen, "Cosmetics", "Look to the effects you can apply to your digimons.")

        BackdropCosmeticOpen = BlzCreateFrameByType("BACKDROP", "BackdropCosmeticOpen", CosmeticOpen, "", 0)
        BlzFrameSetAllPoints(BackdropCosmeticOpen, CosmeticOpen)
        BlzFrameSetTexture(BackdropCosmeticOpen, "ReplaceableTextures\\CommandButtons\\BTNCosmeticsIcon.blp", 0, true)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, CosmeticOpen, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, CosmeticOpenFunc)

        CosmeticMenu = BlzCreateFrame("EscMenuBackdrop", BlzGetFrameByName("ConsoleUIBackdrop", 0), 0, 0)
        BlzFrameSetAbsPoint(CosmeticMenu, FRAMEPOINT_TOPLEFT, 0.500000, 0.490000)
        BlzFrameSetAbsPoint(CosmeticMenu, FRAMEPOINT_BOTTOMRIGHT, 0.770000, 0.230000)
        BlzFrameSetVisible(CosmeticMenu, false)

        CosmeticText = BlzCreateFrameByType("TEXT", "name", CosmeticMenu, "", 0)
        BlzFrameSetPoint(CosmeticText, FRAMEPOINT_TOPLEFT, CosmeticMenu, FRAMEPOINT_TOPLEFT, 0.020000, -0.020000)
        BlzFrameSetPoint(CosmeticText, FRAMEPOINT_BOTTOMRIGHT, CosmeticMenu, FRAMEPOINT_BOTTOMRIGHT, -0.13000, 0.22000)
        BlzFrameSetText(CosmeticText, "|cffFFCC00Choose an effect|r")
        BlzFrameSetEnable(CosmeticText, false)
        BlzFrameSetScale(CosmeticText, 1.00)
        BlzFrameSetTextAlignment(CosmeticText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        CosmeticAccept = BlzCreateFrame("ScriptDialogButton", CosmeticMenu, 0, 0)
        BlzFrameSetPoint(CosmeticAccept, FRAMEPOINT_TOPLEFT, CosmeticMenu, FRAMEPOINT_TOPLEFT, 0.050000, -0.22000)
        BlzFrameSetPoint(CosmeticAccept, FRAMEPOINT_BOTTOMRIGHT, CosmeticMenu, FRAMEPOINT_BOTTOMRIGHT, -0.15000, 0.010000)
        BlzFrameSetText(CosmeticAccept, "|cffFCD20DAccept|r")
        BlzFrameSetScale(CosmeticAccept, 1.00)
        BlzFrameSetEnable(CosmeticAccept, false)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, CosmeticAccept, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, CosmeticAcceptFunc)

        CosmeticExit = BlzCreateFrame("ScriptDialogButton", CosmeticMenu, 0, 0)
        BlzFrameSetPoint(CosmeticExit, FRAMEPOINT_TOPLEFT, CosmeticMenu, FRAMEPOINT_TOPLEFT, 0.15000, -0.22000)
        BlzFrameSetPoint(CosmeticExit, FRAMEPOINT_BOTTOMRIGHT, CosmeticMenu, FRAMEPOINT_BOTTOMRIGHT, -0.050000, 0.010000)
        BlzFrameSetText(CosmeticExit, "|cffFCD20DExit|r")
        BlzFrameSetScale(CosmeticExit, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, CosmeticExit, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, CosmeticExitFunc)

        CosmeticEffects = BlzCreateFrameByType("BACKDROP", "BACKDROP", CosmeticMenu, "", 1)
        BlzFrameSetPoint(CosmeticEffects, FRAMEPOINT_TOPLEFT, CosmeticMenu, FRAMEPOINT_TOPLEFT, 0.020000, -0.050000)
        BlzFrameSetPoint(CosmeticEffects, FRAMEPOINT_BOTTOMRIGHT, CosmeticMenu, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.045000)
        BlzFrameSetTexture(CosmeticEffects, "war3mapImported\\EmptyBTN.blp", 0, true)

        CosmeticList = FrameList.create(false, CosmeticEffects)
        BlzFrameSetPoint(CosmeticList.Frame, FRAMEPOINT_TOPLEFT, CosmeticEffects, FRAMEPOINT_TOPLEFT, 0.0000000, -0.000000)
        BlzFrameSetPoint(CosmeticList.Frame, FRAMEPOINT_TOPRIGHT, CosmeticEffects, FRAMEPOINT_TOPRIGHT, 0.0060000, 0.000000)
        CosmeticList:setSize(BlzFrameGetWidth(CosmeticList.Frame), BlzFrameGetHeight(CosmeticList.Frame) + 0.05)

        CosmeticUnlock = BlzCreateFrame("EscMenuBackdrop", CosmeticMenu, 0, 0)
        BlzFrameSetAbsPoint(CosmeticUnlock, FRAMEPOINT_TOPLEFT, 0.500000, 0.210000)
        BlzFrameSetAbsPoint(CosmeticUnlock, FRAMEPOINT_BOTTOMRIGHT, 0.770000, 0.140000)

        CosmeticUnlockText = BlzCreateFrameByType("TEXT", "name", CosmeticUnlock, "", 0)
        BlzFrameSetPoint(CosmeticUnlockText, FRAMEPOINT_TOPLEFT, CosmeticUnlock, FRAMEPOINT_TOPLEFT, 0.020000, -0.015000)
        BlzFrameSetPoint(CosmeticUnlockText, FRAMEPOINT_BOTTOMRIGHT, CosmeticUnlock, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.035000)
        BlzFrameSetText(CosmeticUnlockText, "|cffFFCC00Enter a code to unlock a cosmetic|r")
        BlzFrameSetEnable(CosmeticUnlockText, false)
        BlzFrameSetScale(CosmeticUnlockText, 1.00)
        BlzFrameSetTextAlignment(CosmeticUnlockText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

        CosmeticUnlockCode = BlzCreateFrame("EscMenuEditBoxTemplate", CosmeticUnlock, 0, 0)
        BlzFrameSetPoint(CosmeticUnlockCode, FRAMEPOINT_TOPLEFT, CosmeticUnlock, FRAMEPOINT_TOPLEFT, 0.020000, -0.030000)
        BlzFrameSetPoint(CosmeticUnlockCode, FRAMEPOINT_BOTTOMRIGHT, CosmeticUnlock, FRAMEPOINT_BOTTOMRIGHT, -0.050000, 0.010000)
        BlzFrameSetText(CosmeticUnlockCode, "")
        BlzFrameSetTextSizeLimit(CosmeticUnlockCode, MAX_LENGTH_PASSWORD*4)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, CosmeticUnlockCode, FRAMEEVENT_EDITBOX_TEXT_CHANGED)
        TriggerAddAction(t, CosmeticUnlockCodeFunc)

        CosmeticUnlockYes = BlzCreateFrame("ScriptDialogButton", CosmeticUnlock, 0, 0)
        BlzFrameSetScale(CosmeticUnlockYes, 0.8)
        BlzFrameSetPoint(CosmeticUnlockYes, FRAMEPOINT_TOPLEFT, CosmeticUnlock, FRAMEPOINT_TOPLEFT, 0.22000, -0.030000)
        BlzFrameSetPoint(CosmeticUnlockYes, FRAMEPOINT_BOTTOMRIGHT, CosmeticUnlock, FRAMEPOINT_BOTTOMRIGHT, -0.020000, 0.010000)
        BlzFrameSetText(CosmeticUnlockYes, "|cffFCD20DYes|r")
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, CosmeticUnlockYes, FRAMEEVENT_CONTROL_CLICK) 
        TriggerAddAction(t, CosmeticUnlockYesFunc)

        CosmeticPreviousDigimon = BlzCreateFrame("ScriptDialogButton", CosmeticMenu, 0, 0)
        BlzFrameSetAbsPoint(CosmeticPreviousDigimon, FRAMEPOINT_TOPLEFT, 0.0800000, 0.420000)
        BlzFrameSetAbsPoint(CosmeticPreviousDigimon, FRAMEPOINT_BOTTOMRIGHT, 0.110000, 0.380000)
        BlzFrameSetText(CosmeticPreviousDigimon, "|cffFCD20D<|r")
        BlzFrameSetScale(CosmeticPreviousDigimon, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, CosmeticPreviousDigimon, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, CosmeticPreviousDigimonFunc)

        CosmeticNextDigimon = BlzCreateFrame("ScriptDialogButton", CosmeticMenu, 0, 0)
        BlzFrameSetAbsPoint(CosmeticNextDigimon, FRAMEPOINT_TOPLEFT, 0.370000, 0.420000)
        BlzFrameSetAbsPoint(CosmeticNextDigimon, FRAMEPOINT_BOTTOMRIGHT, 0.400000, 0.380000)
        BlzFrameSetText(CosmeticNextDigimon, "|cffFCD20D>|r")
        BlzFrameSetScale(CosmeticNextDigimon, 1.00)
        t = CreateTrigger()
        BlzTriggerRegisterFrameEvent(t, CosmeticNextDigimon, FRAMEEVENT_CONTROL_CLICK)
        TriggerAddAction(t, CosmeticNextDigimonFunc)
    end

    FrameLoaderAdd(InitFrames)

    OnInit.final(function ()
        -- I don't know why I should add this
        local buffer = BlzCreateFrameByType("BACKDROP", "BACKDROP", CosmeticEffects, "", 1)
        BlzFrameSetPoint(buffer, FRAMEPOINT_TOPLEFT, CosmeticEffects, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
        BlzFrameSetSize(buffer, 0.23000, 0.05750)
        BlzFrameSetTexture(buffer, "war3mapImported\\EmptyBTN.blp", 0, true)
        CosmeticList:add(buffer)

        ForForce(FORCE_PLAYING, function ()
            LoadUnlockedCosmetics(GetEnumPlayer())
        end)
    end)

    ---@param id integer
    ---@param password string
    ---@param unlockDesc string
    ---@param icon string
    ---@param root string
    ---@param attachment string
    local function Create(id, password, unlockDesc, icon, root, attachment)
        assert(password:len() <= MAX_LENGTH_PASSWORD, "The password is too long, max = " .. MAX_LENGTH_PASSWORD .. ", id = " .. id)
        unlockDesc = password ~= "" and unlockDesc
        Cosmetics[id] = {
            id = id,
            icon = icon,
            root = root,
            attachment = attachment,
            unlockDesc = unlockDesc
        }
        if password ~= "" then
            LockedCosmetics[password] = id
        else
            toUnlock[id] = true
        end

        if actualRow >= MAX_EFFECT_PER_ROW then
            actualRow = 0
            FrameLoaderAdd(function ()
                actualContainer = BlzCreateFrameByType("BACKDROP", "BACKDROP", CosmeticEffects, "", 1)
                BlzFrameSetPoint(actualContainer, FRAMEPOINT_TOPLEFT, CosmeticEffects, FRAMEPOINT_TOPLEFT, 0.0000, 0.0000)
                BlzFrameSetSize(actualContainer, 0.23000, 0.05750)
                BlzFrameSetTexture(actualContainer, "war3mapImported\\EmptyBTN.blp", 0, true)
            end)
        end

        FrameLoaderAdd(function ()
            local button = BlzCreateFrame("IconButtonTemplate", actualContainer, 0, 0)
            BlzFrameSetPoint(button, FRAMEPOINT_TOPLEFT, actualContainer, FRAMEPOINT_TOPLEFT, 0.06 * actualRow, 0.0000)
            BlzFrameSetPoint(button, FRAMEPOINT_BOTTOMRIGHT, actualContainer, FRAMEPOINT_BOTTOMRIGHT, -0.18000 + 0.06 * actualRow, 0.0075000)
            Cosmetics[id].button = button

            local backdrop = BlzCreateFrameByType("BACKDROP", "BackdropCosmeticEffect[" .. id .. "]", button, "", 0)
            BlzFrameSetAllPoints(backdrop, button)
            BlzFrameSetTexture(backdrop, icon, 0, true)
            local t = CreateTrigger()
            BlzTriggerRegisterFrameEvent(t, button, FRAMEEVENT_CONTROL_CLICK)
            TriggerAddAction(t, function () CosmeticActions(id) end)

            if unlockDesc then
                local lockButton = BlzCreateFrame("IconButtonTemplate", actualContainer, 0, 0)
                BlzFrameSetAllPoints(lockButton, button)
                BlzFrameSetEnable(lockButton, false)

                local lockFrame = BlzCreateFrameByType("BACKDROP", "BackdropLockCosmeticEffect[" .. id .. "]", lockButton, "", 0)
                BlzFrameSetAllPoints(lockFrame, button)
                BlzFrameSetTexture(lockFrame, "ReplaceableTextures\\CommandButtons\\BTNLock.blp", 0, true)

                local tooltip = BlzCreateFrame("QuestButtonBaseTemplate", lockButton, 0, 0)

                local tooltipText = BlzCreateFrameByType("TEXT", "name", tooltip, "", 0)
                BlzFrameSetPoint(tooltipText, FRAMEPOINT_BOTTOMLEFT, lockButton, FRAMEPOINT_CENTER, 0.0000, 0.0000)
                BlzFrameSetEnable(tooltipText, false)
                BlzFrameSetScale(tooltipText, 1.00)
                BlzFrameSetTextAlignment(tooltipText, TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

                BlzFrameSetText(tooltipText, unlockDesc)
                BlzFrameSetSize(tooltipText, 0.15, 0)
                BlzFrameSetPoint(tooltip, FRAMEPOINT_TOPLEFT, tooltipText, FRAMEPOINT_TOPLEFT, -0.015000, 0.015000)
                BlzFrameSetPoint(tooltip, FRAMEPOINT_BOTTOMRIGHT, tooltipText, FRAMEPOINT_BOTTOMRIGHT, 0.015000, -0.015000)

                BlzFrameSetTooltip(lockButton, tooltip)

                BlzFrameSetVisible(button, false)

                Cosmetics[id].lockFrame = lockButton
            end

            if actualRow == 0 then
                CosmeticList:add(actualContainer)
            end
        end)

        actualRow = actualRow + 1
    end

    ---@param p player
    function SaveUnlockedCosmetics(p)
        local path = SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\Cosmetics\\Unlocked.pld"
        local savecode = Savecode.create()
        local amount = 0
        for id, v in pairs(UnlockedCosmetics[p]) do
            if v then
                savecode:Encode(id, udg_MAX_COSMETICS) -- Save the id of the cosmetics
                amount = amount + 1
            end
        end
        savecode:Encode(amount, udg_MAX_COSMETICS) -- Save the amount of cosmetics

        local s = savecode:Save(p, 1)

        if p == LocalPlayer then
            FileIO.Write(path, s)
        end

        savecode:destroy()
    end

    ---@param p player
    function LoadUnlockedCosmetics(p)
        local list = __jarray(false)
        local path = SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\Cosmetics\\Unlocked.pld"
        local savecode = Savecode.create()
        if savecode:Load(p, GetSyncedData(p, FileIO.Read, path), 1) then
            local amount = savecode:Decode(udg_MAX_COSMETICS) -- Load the amount of cosmetics
            for _ = 1, amount do
                local unlocked = savecode:Decode(udg_MAX_COSMETICS) -- Load the id of the cosmetics
                list[unlocked] = true
            end

            DisplayTextToPlayer(p, 0, 0, "Cosmetics loaded")
        end

        savecode:destroy()

        UnlockedCosmetics[p] = setmetatable(list, {__index = toUnlock})
        if p == LocalPlayer then
            for id, v in pairs(list) do
                if v and Cosmetics[id].lockFrame then
                    BlzFrameSetVisible(Cosmetics[id].lockFrame, false)
                    BlzFrameSetVisible(Cosmetics[id].button, true)
                end
            end
        end
    end

    ---@param p player
    ---@param slot integer
    ---@return table<integer, integer[]>
    function SaveUsedCosmetics(p, slot)
        local path = SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\Cosmetics\\UsingSlot_" .. slot .. ".pld"
        local savecode = Savecode.create()
        local digis = GetAllDigimons(p)
        local result = {}

        for i, d in ipairs(digis) do
            local amount = 0
            result[i] = __jarray(0)
            for _, c in pairs(d.cosmetics) do
                savecode:Encode(c.id, udg_MAX_COSMETICS) -- Save the id of cosmetic of the digimon
                amount = amount + 1
                result[i][amount] = c.id
            end
            savecode:Encode(amount, udg_MAX_COSMETICS) -- Save the amount of effects has the digimon
            savecode:Encode(i, udg_MAX_DIGIMONS + udg_MAX_SAVED_DIGIMONS) -- Save the place the digimon is in the list
        end
        savecode:Encode(#digis, udg_MAX_DIGIMONS + udg_MAX_SAVED_DIGIMONS) -- Save the amount of digimons

        local s = savecode:Save(p, 1)

        if p == LocalPlayer then
            FileIO.Write(path, s)
        end

        savecode:destroy()

        return result
    end

    ---@param p player
    ---@param slot integer
    ---@return table<integer, integer[]>
    function LoadUsedCosmetics(p, slot)
        local path = SaveFile.getFolder() .. "\\" .. GetPlayerName(p) .. "\\Cosmetics\\UsingSlot_" .. slot .. ".pld"
        local result = {}
        local savecode = Savecode.create()
        if savecode:Load(p, GetSyncedData(p, FileIO.Read, path), 1) then
            local length = savecode:Decode(udg_MAX_DIGIMONS + udg_MAX_SAVED_DIGIMONS) -- Load the amount of digimons

            for _ = 1, length do
                local place = savecode:Decode(udg_MAX_DIGIMONS + udg_MAX_SAVED_DIGIMONS) -- Load the place the digimon is in the list
                local amount = savecode:Decode(udg_MAX_COSMETICS) -- Load the amount of effects has the digimon

                result[place] = __jarray(0)

                for j = amount, 1, -1 do
                    result[place][j] = savecode:Decode(udg_MAX_COSMETICS) -- Load the id of cosmetic of the digimon
                end
            end
        end

        savecode:destroy()

        return result
    end

    ---@param p player
    ---@param id integer
    ---@param d Digimon
    function ApplyCosmetic(p, id, d)
        if not d then
            ErrorMessage("Invalid digimon", p)
            return
        end
        if not UnlockedCosmetics[p][id] then
            ErrorMessage("This cosmetic is locked", p)
            return
        end

        local cosmetic = Cosmetics[id]
        local instance = d.cosmetics[cosmetic.attachment]
        if instance then
            DestroyEffect(instance.eff)
        else
            instance = {owner = d, id = id}
            d.cosmetics[cosmetic.attachment] = instance
        end
        instance.eff = AddSpecialEffectTarget(cosmetic.root, d.root, cosmetic.attachment)
    end

    ---@param d Digimon
    function ClearCosmetics(d)
        for k, v in pairs(d.cosmetics) do
            DestroyEffect(v.eff)
            d.cosmetics[k] = nil
        end
    end

    Digimon.preEvolutionEvent:register(function (d)
        DestroyEffect(d.cosmetic.eff)
    end)

    Digimon.evolutionEvent:register(function (d)
        d.cosmetic.eff = AddSpecialEffectTarget(Cosmetics[d.cosmetic.id].root, d.root, Cosmetics[d.cosmetic.id].attachment)
        UpdateModel(d.owner)
    end)

    ---@param p player
    ---@param id integer
    ---@return boolean
    function CosmeticIsLocked(p, id)
        return not UnlockedCosmetics[p][id]
    end

    ---@param p player
    ---@param key string
    function UnlockCosmetic(p, key)
        if key:sub(1, 7) == "unlock " then
            key = key:sub(8)
        end
        if key:sub(1, 8) == "-unlock " then
            key = key:sub(9)
        end

        local savecode = Savecode.create()

        if not savecode:Load(p, key, 2) then
            EditUnlockMessage(p, "|cffff0000Your passed an invalid code (can't be loaded).|r")
            savecode:destroy()
            return
        end

        local password = ""

        local length = savecode:Decode(MAX_LENGTH_PASSWORD)
        for _ = 1, length do
            password = string.char(savecode:Decode(256)) .. password
        end
        savecode:destroy()

        local id = LockedCosmetics[password]

        if not id then
            EditUnlockMessage(p, "|cffff0000Your passed an invalid code (this code doesn't work).|r")
            return
        end

        if UnlockedCosmetics[p][id] then
            EditUnlockMessage(p, "|cff00ffccYou already unlocked this cosmetic.|r")
            return
        end

        UnlockedCosmetics[p][id] = true

        if p == LocalPlayer then
            BlzFrameSetVisible(Cosmetics[id].lockFrame, false)
            BlzFrameSetVisible(Cosmetics[id].button, true)
        end

        EditUnlockMessage(p, "|cff00ff00Cosmetic unlocked successfully.|r")

        SaveUnlockedCosmetics(p)
    end

    ---@param p player
    ---@param flag boolean
    function ShowCosmetics(p, flag)
        if p == LocalPlayer then
            BlzFrameSetVisible(CosmeticOpen, flag)
        end
    end

    udg_CosmeticCreate = CreateTrigger()
    TriggerAddAction(udg_CosmeticCreate, function ()
        Create(udg_CosmeticId, udg_CosmeticPassword, udg_CosmeticUnlockDesc, udg_CosmeticIcon, udg_CosmeticRoot, udg_CosmeticAttachment)
        udg_CosmeticId = 0
        udg_CosmeticPassword = ""
        udg_CosmeticUnlockDesc = ""
        udg_CosmeticIcon = ""
        udg_CosmeticRoot = ""
        udg_CosmeticAttachment = "origin"
    end)
end)
Debug.endFile()