OnLibraryInit({name = "ChangeEnviroment", "Digimon"}, function ()
    ---@param passage rect
    ---@param entrance1 rect
    ---@param envName1 string
    ---@param entrance2 rect
    ---@param envName2 string
    ---@param fadeOut boolean
    local function CreatePassage(passage, entrance1, envName1, entrance2, envName2, fadeOut)
        local t = CreateTrigger()
        TriggerRegisterLeaveRectSimple(t, passage)
        TriggerAddAction(t, function ()
            local u = GetLeavingUnit()
            local d = Digimon.getInstance(u)
            if d then
                local env ---@type Environment
                if RectContainsUnit(entrance1, u) then
                    env = Environment.get(envName1)
                elseif RectContainsUnit(entrance2, u) then
                    env = Environment.get(envName2)
                else
                    return
                end
                if d.environment ~= env then
                    d.environment = env
                    if IsUnitSelected(u, d:getOwner()) then
                        env:apply(d:getOwner(), fadeOut)
                    end
                end
            end
        end)
    end

    ---@param passages rect[]
    ---@param entrances1 rect[]
    ---@param envName1 string
    ---@param entrances2 rect[]
    ---@param envName2 string
    ---@param fadeOut boolean
    local function CreatePassages(passages, entrances1, envName1, entrances2, envName2, fadeOut)
        local t = CreateTrigger()
        for i = 1, #passages do
            TriggerRegisterLeaveRectSimple(t, passages[i])
        end
        TriggerAddAction(t, function ()
            local u = GetLeavingUnit()
            local d = Digimon.getInstance(u)
            if d then
                local env ---@type Environment
                local check = false
                for i = 1, #entrances1 do
                    if RectContainsUnit(entrances1[i], u) then
                        env = Environment.get(envName1)
                        check = true
                        break
                    end
                end
                if not check then
                    for i = 1, #entrances2 do
                        if RectContainsUnit(entrances2[i], u) then
                            env = Environment.get(envName2)
                            check = true
                            break
                        end
                    end
                end
                if not check then
                    return
                end
                if d.environment ~= env then
                    d.environment = env
                    if IsUnitSelected(u, d:getOwner()) then
                        env:apply(d:getOwner(), fadeOut)
                    end
                end
            end
        end)
    end

    -- For GUI

    OnTrigInit(function ()
        udg_CreatePassage = CreateTrigger()
        TriggerAddAction(udg_CreatePassage, function ()
            CreatePassage(udg_Passage, udg_Entrance1, udg_EnvName1, udg_Entrance2, udg_EnvName2, udg_FadeOut)
            udg_Passage = nil
            udg_Entrance1 = nil
            udg_EnvName1 = ""
            udg_Entrance2 = nil
            udg_EnvName2 = ""
            udg_FadeOut = false
        end)
        udg_CreatePassages = CreateTrigger()
        TriggerAddAction(udg_CreatePassages, function ()
            CreatePassages(udg_Passages, udg_Entrances1, udg_EnvName1, udg_Entrances2, udg_EnvName2, udg_FadeOut)
            udg_Passages = {}
            udg_Entrances1 = {}
            udg_EnvName1 = ""
            udg_Entrances2 = {}
            udg_EnvName2 = ""
            udg_FadeOut = false
        end)
    end)

end)