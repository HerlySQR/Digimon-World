OnLibraryInit({name = "EXP", "Digimon"}, function ()
    local AREA = 512.
    local COLOR_R = 43.529
    local COLOR_G = 43.529
    local COLOR_B = 100.
    local SIZE = 10
    local ZOFSSET = 0.
    local REDUCTION = {[0] = 1., 0.98, 0.95, 0.91, 0.86, 0.8}

    local function round(r)
        if r > 0 then
            return R2I(r + 0.5)
        end
        return R2I(r - 0.5)
    end

    -- This will give XP to the nearby allies of the killing digimon
    -- and if the difference levels of them and the dying digimon is less or equal to 5
    -- level of the unit*5 + ((5-level of the unit)/4) * Reduction
    local function ConvertEXP(lvl, diff)
        return round((5. * lvl + (5 - lvl)/4) * REDUCTION[diff] + 0.5)
    end

    OnMapInit(function ()
        local LocalPlayer = GetLocalPlayer()
        Digimon.killEvent(function (killer, dead)
            local owner = Wc3Type(killer) == "unit" and GetOwningPlayer(killer) or killer:getOwner()
            if owner ~= Digimon.NEUTRAL then
                Digimon.enumInRange(dead:getX(), dead:getY(), AREA, function (picked)
                    local diff = math.abs(picked:getLevel() - dead:getLevel())
                    if IsPlayerAlly(owner, picked:getOwner()) and diff <= 5 then
                        local XP = ConvertEXP(dead:getLevel(), diff)
                        picked:setExp(picked:getExp() + XP)
                        local tt = CreateTextTagUnitBJ("+" .. XP .. " exp", picked.root, ZOFSSET, SIZE, COLOR_R, COLOR_G, COLOR_B, 0.)
                        SetTextTagVelocityBJ(tt, 64, 90)
                        SetTextTagPermanent(tt, false)
                        SetTextTagLifespan(tt, 1.00)
                        SetTextTagFadepoint(tt, 0.50)
                        SetTextTagVisibility(tt, IsPlayerAlly(LocalPlayer, picked:getOwner()))
                    end
                end)
            end
        end)
    end)
end)