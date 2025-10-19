Debug.beginFile("Recipes")
OnInit(function ()
    Require "Backpack"
    Require "SyncedTable"
    Require "AddHook"

    ---@class Recipe
    ---@field itm integer
    ---@field itmToUpgrade integer?
    ---@field spell integer
    ---@field requirements table<integer, integer>
    ---@field resultItm integer

    local RecipeFromItm = {} ---@type table<integer, Recipe>

    ---@param itm integer
    ---@return Recipe
    function GetRecipe(itm)
        return RecipeFromItm[itm]
    end

    ---@param recipe Recipe
    ---@param tooltip string
    ---@return string
    local function fixTooltip(recipe, tooltip)
        local _, start = tooltip:find("|cffd45e19Requires:|r|n")
        if start then
            local tooltipStart = tooltip:sub(1, start)
            local _, finish = tooltip:reverse():find("n|")
            if finish then
                finish = tooltip:len() - finish
            else
                finish = tooltip:len()
            end
            local tooltipEnd = tooltip:sub(finish + 1, tooltip:len())

            local requirements = ""
            if recipe.itmToUpgrade then
                requirements = requirements .. "- " .. GetObjectName(recipe.itmToUpgrade) .. "|n"
            end
            for matReq, amtReq in pairs(recipe.requirements) do
                requirements = requirements .. "- " .. amtReq .. " " .. GetObjectName(matReq) .. "|n"
            end

            tooltip = tooltipStart .. requirements .. tooltipEnd
        end
        return tooltip
    end

    local function hook(func)
        local oldfunc
        oldfunc = AddHook(func, function (...)
            local itm = oldfunc(...)
            if RecipeFromItm[GetItemTypeId(itm)] then
                BlzSetItemDescription(itm, fixTooltip(RecipeFromItm[GetItemTypeId(itm)], BlzGetItemDescription(itm)))
                --BlzSetItemExtendedTooltip(itm, fixTooltip(RecipeFromItm[GetItemTypeId(itm)], BlzGetItemExtendedTooltip(itm)))
            end
            return itm
        end)
    end

    hook("CreateItem")
    hook("BlzCreateItemWithSkin")
    hook("UnitAddItemById")
    hook("PlaceRandomItem")

    OnInit.final(function ()
        EnumItemsInRect(bj_mapInitialPlayableArea, nil, function ()
            local itm = GetEnumItem()
            if RecipeFromItm[GetItemTypeId(itm)] then
                BlzSetItemDescription(itm, fixTooltip(RecipeFromItm[GetItemTypeId(itm)], BlzGetItemDescription(itm)))
                --BlzSetItemExtendedTooltip(itm, fixTooltip(RecipeFromItm[GetItemTypeId(itm)], BlzGetItemExtendedTooltip(itm)))
            end
        end)
    end)

    ---@param itm integer
    ---@param itmToUpgrade integer?
    ---@param spell integer
    ---@param materialReq integer[]
    ---@param amountReq integer[]
    ---@param resultItm integer
    local function Create(itm, itmToUpgrade, spell, materialReq, amountReq, resultItm)
        assert(#materialReq == #amountReq, "The number of material requirements does not match with the number of amounts for the recipe " .. GetObjectName(itm))

        local self = {
            itm = itm,
            itmToUpgrade = itmToUpgrade,
            spell = spell,
            requirements = SyncedTable.create(),
            resultItm = resultItm
        }

        for i = 1, #materialReq do
            self.requirements[materialReq[i]] = amountReq[i]
        end

        RecipeFromItm[itm] = self

        BlzSetAbilityExtendedTooltip(itm, fixTooltip(RecipeFromItm[itm], BlzGetAbilityExtendedTooltip(itm, 0)), 0)

        udg_BackpackItem = itm
        udg_BackpackAbility = spell
        TriggerExecute(udg_BackpackRun)

        RegisterSpellCastEvent(spell, function ()
            local caster = GetSpellAbilityUnit()
            local p = GetOwningPlayer(caster)

            if self.itmToUpgrade then
                local m = GetSpellTargetItem()
                if GetItemTypeId(m) ~= itmToUpgrade then
                    UnitAbortCurrentOrder(caster)
                    ErrorMessage("Wrong item for this recipe", p)
                    return
                end

                local iOwner = GetItemPlayer(m)
                if IsPlayerInGame(iOwner) and p ~= iOwner then
                    UnitAbortCurrentOrder(caster)
                    ErrorMessage("This item belongs to another player", p)
                    return
                end
            end

            local has = true
            for itmReq, amtReq in pairs(self.requirements) do
                if GetMaterialAmount(p, itmReq) < amtReq then
                    has = false
                    break
                end
            end

            if not has then
                UnitAbortCurrentOrder(caster)
                ErrorMessage("You don't have the necessary materials", p)
            end
        end)

        RegisterSpellEffectEvent(spell, function ()
            local caster = GetSpellAbilityUnit()
            if not caster then
                return
            end

            local p = GetOwningPlayer(caster)
            for itmReq, amtReq in pairs(self.requirements) do
                SubMaterialAmount(p, itmReq, amtReq)
            end

            local x, y
            if self.itmToUpgrade then
                local m = GetSpellTargetItem()
                x, y = GetItemX(m), GetItemY(m)
                RemoveItem(m)
            else
                x, y = GetSpellTargetX(), GetSpellTargetY()
            end

            SetItemPlayer(CreateItem(resultItm, x, y), p, true)
            DestroyEffect(AddSpecialEffect(udg_RECIPE_EFFECT, x, y))
        end)
    end

    udg_RecipeItemToUpgrade = nil

    udg_RecipeInit = CreateTrigger()
    TriggerAddAction(udg_RecipeInit, function ()
        Create(
            udg_RecipeItem,
            udg_RecipeItemToUpgrade,
            udg_RecipeSpell,
            udg_RecipeMaterialReq,
            udg_RecipeAmountReq,
            udg_RecipeResultItem
        )
        udg_RecipeItem = 0
        udg_RecipeItemToUpgrade = nil
        udg_RecipeSpell = 0
        udg_RecipeMaterialReq = __jarray(0)
        udg_RecipeAmountReq = __jarray(0)
        udg_RecipeResultItem = 0
    end)
end)
Debug.endFile()