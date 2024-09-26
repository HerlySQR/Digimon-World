Debug.beginFile("EXP")
OnInit(function ()
    Require "Digimon"
    Require "Wc3Type"

    local AREA = 512.

    local function round(r)
        if r > 0 then
            return R2I(r + 0.5)
        end
        return R2I(r - 0.5)
    end

    local function ConvertEXP(lvl)
        return round(1.08*lvl+(7-(lvl))/(5/4)+6)
    end

    local LocalPlayer = GetLocalPlayer()

    Digimon.expEvent = EventListener.create()

    ---@param d Digimon
    ---@param exp integer
    function AddExp(d, exp)
        local data = {receiver = d, exp = exp}

        Digimon.expEvent:run(data)

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
Debug.endFile()