Debug.beginFile("DamageModifier")
OnInit("DamageModifier", function ()
    Require "Digimon"
    Require "AddHook"

    ---@class DamageModifier
    ---@field amt number
    ---@field add boolean
    ---@field criticalChance boolean
    ---@field critcalAmount boolean
    ---@field blockAmount boolean
    ---@field evasionChance boolean
    ---@field trueAttack boolean

    ---@class PrevData
    ---@field dex integer
    ---@field wis integer
    ---@field inv integer[]
    ---@field spells integer[]

    local instances = {} ---@type Digimon[]
    local unitConds = {} ---@type table<integer, DamageModifier>
    local itemConds = {} ---@type table<integer, DamageModifier>
    local abilConds = {} ---@type table<integer, DamageModifier>
    local prevDatas = {} ---@type table<Digimon, PrevData>

    ---@param d Digimon
    ---@param dmgMod DamageModifier
    ---@param sub boolean?
    local function modify(d, dmgMod, sub)
        local amt = sub and -dmgMod.amt or dmgMod.amt
        if dmgMod.criticalChance then
            d:addCriticalChance(amt, dmgMod.add)
        elseif dmgMod.critcalAmount then
            d:addCriticalAmount(amt, dmgMod.add)
        elseif dmgMod.blockAmount then
            d:addBlockAmount(amt, dmgMod.add)
        elseif dmgMod.evasionChance then
            d:addEvasionChance(amt, dmgMod.add)
        elseif dmgMod.trueAttack then
            d:addTrueAttack(amt)
        end
    end

    Timed.echo(0.1, function ()
        for i = #instances, 1, -1 do
            local d = instances[i]
            if d:getTypeId() == 0 then
                table.remove(instances, i)
                prevDatas[d] = nil
            else
                local prevData = prevDatas[d]
                -- Hero stats
                local actDex = GetHeroAgi(d.root, true)
                if prevData.dex ~= actDex then
                    d:addCriticalChance((actDex - prevData.dex)*0.075, true)
                    d:addEvasionChance((actDex - prevData.dex)*0.065, true)
                    prevData.dex = actDex
                end
                local actInt = GetHeroInt(d.root, true)
                if prevData.wis ~= actInt then
                    d:addCriticalAmount((actInt - prevData.wis)*0.002, true)
                    prevData.wis = actInt
                end
                -- Items
                for j = 0, 5 do
                    local actItm = GetItemTypeId(UnitItemInSlot(d.root, j))
                    if prevData.inv[j] ~= actItm then
                        if itemConds[prevData.inv[j]] then
                            modify(d, itemConds[prevData.inv[j]], true)
                        end
                        if itemConds[actItm] then
                            modify(d, itemConds[actItm])
                        end
                        prevData.inv[j] = actItm
                    end
                end
                -- Abilities
                local index = 0
                local n = #prevData.spells
                while true do
                    local abil = BlzGetUnitAbilityByIndex(d.root, index)
                    if not abil and index >= n then break end
                    local id = BlzGetAbilityId(abil)
                    if prevData.spells[index] ~= id then
                        if abilConds[prevData.spells[index]] then
                            modify(d, abilConds[prevData.spells[index]], true)
                        end
                        if abilConds[id] then
                            modify(d, abilConds[id])
                        end
                        if abil then
                            prevData.spells[index] = id
                        else
                            prevData.spells[index] = nil
                        end
                    end
                    index = index + 1
                end
            end
        end
    end)

    Digimon.createEvent:register(function (d)
        if UnitCanAttack(d.root) then
            table.insert(instances, d)
            prevDatas[d] = {
                dex = 0,
                wis = 0,
                inv = __jarray(0),
                spells = __jarray(0)
            }
            if unitConds[d:getTypeId()] then
                modify(d, unitConds[d:getTypeId()])
            end
        end
    end)

    ---@param amt number
    ---@param add boolean
    ---@param criticalChance boolean
    ---@param critcalAmount boolean
    ---@param blockAmount boolean
    ---@param evasionChance boolean
    ---@param trueAttack boolean
    ---@param unitCond integer
    ---@param itemCond integer
    ---@param abilCond integer
    local function Create(amt, add, criticalChance, critcalAmount, blockAmount, evasionChance, trueAttack, unitCond, itemCond, abilCond)
        local dmgMod = {
            amt = amt,
            add = add,
            criticalChance = criticalChance,
            critcalAmount = critcalAmount,
            blockAmount = blockAmount,
            evasionChance = evasionChance,
            trueAttack = trueAttack
        }
        if unitCond ~= 0 then
            unitConds[unitCond] = dmgMod
        end
        if itemCond ~= 0 then
            itemConds[itemCond] = dmgMod
        end
        if abilCond ~= 0 then
            abilConds[abilCond] = dmgMod
        end
    end

    udg_DamageModifierCreate = CreateTrigger()
    TriggerAddAction(udg_DamageModifierCreate, function ()
        Create(
            udg_DamageModifierAmount,
            udg_DamageModifierAdd,
            udg_DamageModifierCriticalChance,
            udg_DamageModifierCriticalAmount,
            udg_DamageModifierBlockAmount,
            udg_DamageModifierEvasionChance,
            udg_DamageModifierTrueAttack,
            udg_DamageModifierUnitCond,
            udg_DamageModifierItemCond,
            udg_DamageModifierAbilCond ~= 0 and udg_DamageModifierAbilCond or udg_DamageModifierBuffCond
        )
        udg_DamageModifierAmount = 0
        udg_DamageModifierAdd = false
        udg_DamageModifierCriticalChance = false
        udg_DamageModifierCriticalAmount = false
        udg_DamageModifierBlockAmount = false
        udg_DamageModifierEvasionChance = false
        udg_DamageModifierTrueAttack = false
        udg_DamageModifierUnitCond = 0
        udg_DamageModifierItemCond = 0
        udg_DamageModifierAbilCond = 0
        udg_DamageModifierBuffCond = 0
    end)
end)
Debug.endFile()