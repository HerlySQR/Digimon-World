Debug.beginFile("FishingData")
OnInit("FishingData", function ()

    local FISHING_BUTTON = "ReplaceableTextures\\CommandButtons\\BTNFishN.blp"
    local CATCH_FISH_BUTTON = "ReplaceableTextures\\CommandButtons\\BTNFishing1.blp"

    local DIGI_ANCHOVY = FourCC('I07N')
    local DIGI_SEABASS = FourCC('I07P')
    local DIGI_SPEAR_FISH = FourCC('I07O')
    local DIGI_SNAPPER = FourCC('I07Q')
    local DIGI_TROUT = FourCC('I07S')
    local DIGI_CARP = FourCC('I07R')
    local DIGI_TUNA = FourCC('I07T')
    local DIGI_DRAGON_FISH = FourCC('I07U')
    local DIGI_DRAGON_FISH_OTHER = FourCC('I08K')
    local DIGI_AGOLD = FourCC('I08M')
    local DIGI_MESSAGE = FourCC('I080')
    local DIGI_SHARK = FourCC('I07Z')
    local DIGI_CLAWS = FourCC('I0A9')
    local DIGI_DUKE = FourCC('I0A2')
    local DIGI_KING = FourCC('I0A0')
    local DIGI_SHIELD = FourCC('I0BJ')
    local DIGI_TRID = FourCC('I0BK')
    local DIGI_BLADE = FourCC('I0AL')
    local DIGI_CATFISH = FourCC('I0BM')
    local DIGI_WHITE = FourCC('I0BN')
    local DIGI_BLACK = FourCC('I0BO')

    do
        local t = CreateTrigger()
        TriggerRegisterAnyUnitEventBJ(t, EVENT_PLAYER_UNIT_PICKUP_ITEM)
        TriggerAddCondition(t, Condition(function () return GetItemTypeId(GetManipulatedItem()) == DIGI_DRAGON_FISH_OTHER end))
        TriggerAddAction(t, function ()
            UnitAddItemById(GetManipulatingUnit(), DIGI_DRAGON_FISH)
            RemoveItem(GetManipulatedItem())
        end)
    end

    local ROD = {
        FourCC('I07W'),
        FourCC('I07M'),
        FourCC('I07Y'),
        FourCC('I07X')
    }
    local FISHES = {
        [1] = {
            [DIGI_ANCHOVY] = 1,
            [DIGI_SEABASS] = 1,
            [DIGI_SNAPPER] = 1,
            [DIGI_TROUT] = 1,
            [DIGI_TUNA] = 1,
            [DIGI_CATFISH] = 1
        },
        [2] = {
            [DIGI_ANCHOVY] = 0.95,
            [DIGI_SEABASS] = 0.95,
            [DIGI_SPEAR_FISH] = 0.10,
            [DIGI_SNAPPER] = 0.95,
            [DIGI_TROUT] = 0.95,
            [DIGI_CARP] = 0.10,
            [DIGI_TUNA] = 0.95,
            [DIGI_SHARK] = 0.10,
            [DIGI_DUKE] = 0.005,
            [DIGI_KING] = 0.005,
            [DIGI_CATFISH] = 0.95,
            [DIGI_WHITE] = 0.005,
            [DIGI_BLACK] = 0.005,
            [DIGI_CLAWS] = 0.03
        },
        [3] = {
            [DIGI_ANCHOVY] = 0.93,
            [DIGI_SEABASS] = 0.93,
            [DIGI_SPEAR_FISH] = 0.15,
            [DIGI_SNAPPER] = 0.93,
            [DIGI_TROUT] = 0.93,
            [DIGI_CARP] = 0.15,
            [DIGI_TUNA] = 0.93,
            [DIGI_SHARK] = 0.15,
            [DIGI_MESSAGE] = 0.005,
            [DIGI_CLAWS] = 0.06,
            [DIGI_DUKE] = 0.01,
            [DIGI_KING] = 0.01,
            [DIGI_SHIELD] = 0.005,
            [DIGI_TRID] = 0.005,
            [DIGI_BLADE] = 0.005,
            [DIGI_CATFISH] = 0.85,
            [DIGI_WHITE] = 0.01,
            [DIGI_BLACK] = 0.01,
            [DIGI_DRAGON_FISH_OTHER] = 0.005
        },
        [4] = {
            [DIGI_ANCHOVY] = 0.9,
            [DIGI_SEABASS] = 0.9,
            [DIGI_CATFISH] = 0.9,
            [DIGI_SPEAR_FISH] = 0.22,
            [DIGI_SNAPPER] = 0.9,
            [DIGI_TROUT] = 0.9,
            [DIGI_CARP] = 0.22,
            [DIGI_TUNA] = 0.7,
            [DIGI_SHARK] = 0.22,
            [DIGI_MESSAGE] = 0.012,
            [DIGI_AGOLD] = 0.005,
            [DIGI_CLAWS] = 0.15,
            [DIGI_DUKE] = 0.05,
            [DIGI_KING] = 0.05,
            [DIGI_SHIELD] = 0.01,
            [DIGI_TRID] = 0.01,
            [DIGI_BLADE] = 0.01,
            [DIGI_WHITE] = 0.015,
            [DIGI_BLACK] = 0.015,
            [DIGI_DRAGON_FISH_OTHER] = 0.01
        }
    }
    local PLACES = {
        ["All"] = {DIGI_AGOLD, DIGI_MESSAGE, DIGI_WHITE, DIGI_BLACK},
        ["File City"] = {DIGI_ANCHOVY, DIGI_CLAWS},
        ["Gear Savanna"] = {DIGI_ANCHOVY, DIGI_SPEAR_FISH, DIGI_SEABASS},
        ["Tropical Jungle"] = {DIGI_ANCHOVY, DIGI_SPEAR_FISH, DIGI_SEABASS},
        ["Ancient Dino Region"] = {DIGI_SEABASS, DIGI_SPEAR_FISH, DIGI_SNAPPER, DIGI_KING},
        ["Geko Swamp"] = {DIGI_SEABASS, DIGI_SPEAR_FISH, DIGI_SNAPPER, DIGI_KING},
        ["Freezeland"] = {DIGI_SNAPPER, DIGI_CARP, DIGI_TROUT, DIGI_SHIELD, DIGI_TRID},
        ["Bettleland"] = {DIGI_TUNA, DIGI_SHARK, DIGI_CARP, DIGI_TROUT, DIGI_BLADE, DIGI_DRAGON_FISH_OTHER, DIGI_DUKE},
        ["Factorial Town"] = {DIGI_TUNA, DIGI_SHARK, DIGI_CARP, DIGI_TROUT, DIGI_BLADE, DIGI_DRAGON_FISH_OTHER, DIGI_DUKE},
        ["Secret Beach Cave"] = {DIGI_TUNA, DIGI_SHARK, DIGI_CATFISH, DIGI_DRAGON_FISH_OTHER}
    }
    PLACES["Native Forest"] = PLACES["File City"]

    return {ROD, FISHES, PLACES, FISHING_BUTTON, CATCH_FISH_BUTTON}
end)
Debug.endFile()