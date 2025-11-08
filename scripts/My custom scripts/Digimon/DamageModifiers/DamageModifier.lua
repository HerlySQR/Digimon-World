Debug.beginFile("DamageModifier")
OnInit("DamageModifier", function ()
    Require "Digimon"
    Require "MDTable"

    ---@class DamageModifier
    ---@field add boolean
    ---@field criticalChance number?
    ---@field critcalAmount number?
    ---@field blockAmount number?
    ---@field evasionChance number?
    ---@field trueAttack number?

    ---@class PrevData
    ---@field sta integer
    ---@field dex integer
    ---@field wis integer
    ---@field inv integer[]
    ---@field spells string[]

    local instances = {} ---@type Digimon[]
    local unitConds = {} ---@type table<integer, DamageModifier>
    local itemConds = {} ---@type table<integer, DamageModifier>
    local abilConds = MDTable.create(2) ---@type table<integer, DamageModifier[]>
    local prevDatas = {} ---@type table<Digimon, PrevData>

    ---@param d Digimon
    ---@param dmgMod DamageModifier
    ---@param sub boolean?
    local function modify(d, dmgMod, sub)
        local sc = sub and -1 or 1
        if dmgMod.criticalChance then
            d:addCriticalChance(sc * dmgMod.criticalChance, dmgMod.add)
        end
        if dmgMod.critcalAmount then
            d:addCriticalAmount(sc * dmgMod.critcalAmount, dmgMod.add)
        end
        if dmgMod.blockAmount then
            d:addBlockAmount(sc * dmgMod.blockAmount, dmgMod.add)
        end
        if dmgMod.evasionChance then
            d:addEvasionChance(sc * dmgMod.evasionChance, dmgMod.add)
        end
        if dmgMod.trueAttack then
            d:addTrueAttack(sc * dmgMod.trueAttack)
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
                local actSta = GetHeroStr(d.root, true)
                if prevData.sta ~= actSta then
                    d:addBlockAmount((actSta - prevData.sta)*0.03, true)
                    prevData.sta = actSta
                end
                local actDex = GetHeroAgi(d.root, true)
                if prevData.dex ~= actDex then
                    d:addCriticalChance((actDex - prevData.dex)*0.075, true)
                    d:addEvasionChance((actDex - prevData.dex)*0.06, true)
                    prevData.dex = actDex
                end
                local actWis = GetHeroInt(d.root, true)
                if prevData.wis ~= actWis then
                    d:addCriticalAmount((actWis - prevData.wis)*0.002, true)
                    prevData.wis = actWis
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
                for j = #prevData.spells, 1, -1 do
                    local line = prevData.spells[j]:find("-")
                    local id = math.tointeger(prevData.spells[j]:sub(line+1)) or 0
                    local lvl = math.tointeger(prevData.spells[j]:sub(1, line-1)) or 0
                    modify(d, abilConds[id][lvl], true)
                    table.remove(prevData.spells, j)
                end
                local index = 0
                while true do
                    local abil = BlzGetUnitAbilityByIndex(d.root, index)
                    if not abil then break end
                    local id = BlzGetAbilityId(abil)
                    local lvl = d:getAbilityLevel(id)
                    if abilConds[id][lvl] then
                        modify(d, abilConds[id][lvl])
                        table.insert(prevData.spells, lvl .. "-".. id)
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
                sta = 0,
                dex = 0,
                wis = 0,
                inv = __jarray(0),
                spells = __jarray("")
            }
            if unitConds[d:getTypeId()] then
                modify(d, unitConds[d:getTypeId()])
            end
            d:addCriticalChance(3, true)
            d:evasionChance(3, true)
            d:critcalAmount(0.15, true)
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
    ---@param abilLevelCond integer
    local function Create(amt, add, criticalChance, critcalAmount, blockAmount, evasionChance, trueAttack, unitCond, itemCond, abilCond, abilLevelCond)
        local dmgMod
        if unitCond ~= 0 then
            dmgMod = unitConds[unitCond] or {}
            unitConds[unitCond] = dmgMod
        end
        if itemCond ~= 0 then
            dmgMod = itemConds[itemCond] or {}
            itemConds[itemCond] = dmgMod
        end
        if abilCond ~= 0 then
            dmgMod = abilConds[abilCond][abilLevelCond] or {}
            abilConds[abilCond][abilLevelCond] = dmgMod
        end
        if not dmgMod then
            error("You didn't set a condition for the buff")
        end

        dmgMod.add = add
        if criticalChance then
            dmgMod.criticalChance = amt
        end
        if critcalAmount then
            dmgMod.critcalAmount = amt
        end
        if blockAmount then
            dmgMod.blockAmount = amt
        end
        if evasionChance then
            dmgMod.evasionChance = amt
        end
        if trueAttack then
            dmgMod.trueAttack = amt
        end
    end

    ---@param itm integer
    function GetItemDamageModifier(itm)
        return itemConds[itm]
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
            udg_DamageModifierAbilCond ~= 0 and udg_DamageModifierAbilCond or udg_DamageModifierBuffCond,
            udg_DamageModifierAbilLevelCond
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
        udg_DamageModifierAbilLevelCond = 1
    end)
end)
Debug.endFile()