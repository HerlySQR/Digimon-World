OnInit(function () -- https://www.hiveworkshop.com/threads/global-initialization.317099/
    local AddHook = Require.optional "AddHook"

    --This library is to store the actual color of a unit and also if is changed.
    --Also add a constant PLAYER_COLOR_BLACK that you can use and a function GetUnitColor to have the saved unit color.

    PLAYER_COLOR_BLACK = ConvertPlayerColor(PLAYER_NEUTRAL_AGGRESSIVE)

    local UnitColor = {}

    local re = CreateRegion()
    local r = GetWorldBounds()
    RegionAddRect(re, r)
    local b = Filter(function()
        UnitColor[GetFilterUnit()] = GetPlayerColor(GetOwningPlayer(GetFilterUnit()))
        return false
    end)
    TriggerRegisterEnterRegion(CreateTrigger(), re, b)
    for i = 0, bj_MAX_PLAYER_SLOTS do
        GroupEnumUnitsOfPlayer(bj_lastCreatedGroup, Player(i), b)
    end
    RemoveRect(r)

    --I just had to change these 2 functions.

    if AddHook then
        AddHook("SetUnitColor", function (whichUnit, color)
            UnitColor[whichUnit] = color
            SetUnitColor.old(whichUnit, color)
        end)
        AddHook("SetUnitOwner", function (whichUnit, whichPlayer, changeColor)
            if changeColor then
                UnitColor[whichUnit] = GetPlayerColor(whichPlayer)
            end
            SetUnitOwner.old(whichUnit, whichPlayer, changeColor)
        end)
    else
        local OldSetUnitColor = SetUnitColor
        function SetUnitColor(whichUnit, color)
            UnitColor[whichUnit] = color
            OldSetUnitColor(whichUnit, color)
        end

        local OldSetUnitOwner = SetUnitOwner
        function SetUnitOwner(whichUnit, whichPlayer, changeColor)
            if changeColor then
                UnitColor[whichUnit] = GetPlayerColor(whichPlayer)
            end
            OldSetUnitOwner(whichUnit, whichPlayer, changeColor)
        end
    end

    function GetUnitColor(whichUnit)
        return UnitColor[whichUnit]
    end
end)