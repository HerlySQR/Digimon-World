OnInit(function ()
    Require "Digimon"
    Require "Wc3Type"

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

    local LocalPlayer = GetLocalPlayer()

    Digimon.expEvent = EventListener.create()

    ---@param d Digimon
    ---@param exp integer
    function AddExp(d, exp)
        local data = {receiver = d, exp = exp}

        Digimon.expEvent:run(data)

        --[[local tt = CreateTextTagUnitBJ("+" .. data.exp .. " exp", data.receiver.root, ZOFSSET, SIZE, COLOR_R, COLOR_G, COLOR_B, 0.)
        SetTextTagVelocityBJ(tt, 64, 90)
        SetTextTagPermanent(tt, false)
        SetTextTagLifespan(tt, 1.00)
        SetTextTagFadepoint(tt, 0.50)
        SetTextTagVisibility(tt, IsPlayerAlly(LocalPlayer, data.receiver:getOwner()))]]
        data.receiver:setExp(data.receiver:getExp() + data.exp)
    end

    Digimon.killEvent:register(function (info)
        local killer = info.killer
        local dead = info.target
        local owner = Wc3Type(killer) == "unit" and GetOwningPlayer(killer) or killer:getOwner()
        if IsPlayerInForce(owner, FORCE_PLAYING) and IsPlayerEnemy(owner, dead:getOwner()) and dead:getOwner() == Digimon.NEUTRAL then
            Digimon.enumInRange(dead:getX(), dead:getY(), AREA, function (picked)
                local diff = math.abs(picked:getLevel() - dead:getLevel())
                if IsPlayerAlly(owner, picked:getOwner()) and diff <= 5 then
                    AddExp(picked, ConvertEXP(dead:getLevel(), diff))
                end
            end)
        end
    end)
end)