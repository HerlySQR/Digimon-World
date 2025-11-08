Debug.beginFile("SetNPCSpells")
OnInit(function ()
    Require "Threat System"
    Require "Orders"

    ---@param spell integer
    ---@param order string
    ---@param hasUnitTarget boolean
    ---@param hasPointTarget boolean
    ---@param hasNoTarget boolean
    ---@param enemyTarget boolean
    ---@param allyTarget boolean
    local function Create(spell, order, hasUnitTarget, hasPointTarget, hasNoTarget, enemyTarget, allyTarget)
        assert(hasUnitTarget or hasPointTarget or hasNoTarget, "SetNPCSpells: target-type wasn't set " .. GetObjectName(spell))
        assert(not ((hasUnitTarget and hasPointTarget) or (hasPointTarget and hasNoTarget) or (hasUnitTarget and hasNoTarget)), "SetNPCSpells: set more than 1 target-type " .. GetObjectName(spell))

        order = Orders[order]

        local castType, forAlly

        if hasUnitTarget then
            castType = CastType.TARGET
        elseif hasPointTarget then
            castType = CastType.POINT
        elseif hasNoTarget then
            castType = CastType.IMMEDIATE
        end

        assert(castType, "SetNPCSpells: not a valid target " .. GetObjectName(spell))

        if not (enemyTarget or allyTarget) then
            enemyTarget = true
            allyTarget = true
        end

        if enemyTarget then
            forAlly = false
        elseif allyTarget then
            forAlly = true
        end

        assert(forAlly ~= nil, "SetNPCSpells: not a valid ally-type " .. GetObjectName(spell))

        Threat.NPCAddOrder(spell, order, castType, forAlly)
    end

    udg_SpellAICreate = CreateTrigger()
    TriggerAddAction(udg_SpellAICreate, function ()
        xpcall(Create, print,
            udg_SpellAIAbility,
            udg_SpellAIOrder,
            udg_SpellAIHasUnitTarget,
            udg_SpellAIHasPointTarget,
            udg_SpellAIHasNoTarget,
            udg_SpellAIEnemyTarget,
            udg_SpellAIAllyTarget
        )
        udg_SpellAIAbility = 0
        udg_SpellAIOrder = ""
        udg_SpellAIHasUnitTarget = false
        udg_SpellAIHasPointTarget = false
        udg_SpellAIHasNoTarget = false
        udg_SpellAIEnemyTarget = false
        udg_SpellAIAllyTarget = false
    end)
end)
Debug.endFile()