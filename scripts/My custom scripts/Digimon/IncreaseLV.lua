Debug.beginFile("IncreaseIV")
OnInit(function ()
    Require "Backpack"
    Require "Rare Data"

    local STA_TRAINING = FourCC('I09S')
    local DEX_TRAINING = FourCC('I09R')
    local WIS_TRAINING = FourCC('I09T')

    OnRareDataItemGot(function (u, itm)
        if itm ~= STA_TRAINING and itm ~= DEX_TRAINING and itm ~= WIS_TRAINING then
            return
        end

        local d = Digimon.getInstance(u)
        if d then
            local max = 20
            local refund = false
            local whatIV
            if itm == STA_TRAINING then
                if d.IVsta < max then
                    d:setIV(d.IVsta + 1, d.IVdex, d.IVwis)
                else
                    refund = true
                    whatIV = GetLocalizedString("STAMINA")
                end
            elseif itm == DEX_TRAINING then
                if d.IVdex < max then
                    d:setIV(d.IVsta, d.IVdex + 1, d.IVwis)
                else
                    refund = true
                    whatIV = GetLocalizedString("DEXTERITY")
                end
            elseif itm == WIS_TRAINING then
                if d.IVwis < max then
                    d:setIV(d.IVsta, d.IVdex, d.IVwis + 1)
                else
                    refund = true
                    whatIV = GetLocalizedString("WISDOM")
                end
            end
            if refund then
                local p = GetOwningPlayer(u)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(p, PLAYER_STATE_RESOURCE_GOLD) + 5000)
                SetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER, GetPlayerState(p, PLAYER_STATE_RESOURCE_LUMBER) + 20)
                SetBackpackItemCharges(p, udg_RARE_DATA, GetBackpackItemCharges(p, udg_RARE_DATA) + 25)
                ErrorMessage(GetLocalizedString("IV_MAXED_OUT"):format(whatIV), p)
            end
        end
    end)
end)
Debug.endFile()