Debug.beginFile("IncreaseIV.lua")
OnInit(function ()
    Require "Backpack"
    Require "Rare Data"

    local CARBS = FourCC('I09R')
    local PROTEIN = FourCC('I09S')
    local FIBER = FourCC('I09T')

    OnRareDataItemGot(function (u, itm)
        local d = Digimon.getInstance(u)
        if d then
            local refund = false
            local whatIV
            if itm == CARBS then
                if d.IVsta < 15 then
                    d:setIV(d.IVsta + 1, d.IVdex, d.IVwis)
                else
                    refund = true
                    whatIV = "stamina"
                end
            elseif itm == PROTEIN then
                if d.IVdex < 15 then
                    d:setIV(d.IVsta, d.IVdex + 1, d.IVwis)
                else
                    refund = true
                    whatIV = "dexterity"
                end
            elseif itm == FIBER then
                if d.IVwis < 15 then
                    d:setIV(d.IVsta, d.IVdex, d.IVwis + 1)
                else
                    refund = true
                    whatIV = "wisdom"
                end
            end
            if refund then
                local p = GetOwningPlayer(u)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) + 1500)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER) + 10)
                SetBackpackItemCharges(p, udg_RARE_DATA, GetBackpackItemCharges(p, udg_RARE_DATA) + 27)
                ErrorMessage("You IV " .. whatIV .. " is maxed out.", p)
            end
        end
    end)
end)
Debug.endFile()