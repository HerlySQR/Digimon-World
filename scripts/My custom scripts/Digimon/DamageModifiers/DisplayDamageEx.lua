Debug.beginFile("DisplayDamageEx")
OnInit(function ()
    Require "Timed"

    local SIZE_MIN        = 0.0018        -- Minimum size of text
    local SIZE_BONUS      = 0.0012        -- Text size increase
    local TIME_LIFE       = 1.0           -- How long the text lasts
    local TIME_FADE       = 0.8           -- When does the text start to fade
    local Z_OFFSET_BON    = 50            -- How much extra height the text gains
    local VELOCITY        = 2             -- How fast the text move in x/y plane

    local LocalPlayer = GetLocalPlayer()

    local texttags = {} ---@type {tt: texttag, as: number, ac: number, time: number, x: number, y: number, text: string, zOffset: number, size:number}[]

    Timed.echo(0.03125, function ()
        for i = #texttags, 1, -1 do
            local node = texttags[i]
            local p = math.sin(math.pi*node.time)
            node.time = node.time - 0.03125
            node.x = node.x + node.ac
            node.y = node.y + node.as
            SetTextTagPos(node.tt, node.x, node.y, node.zOffset + Z_OFFSET_BON*p)
            SetTextTagText(node.tt, node.text, (SIZE_MIN + SIZE_BONUS*p)*node.size)
            if node.time <= 0 then
                table.remove(texttags, i)
            end
        end
    end)

    ---@param u unit
    ---@param text string
    ---@param size number
    ---@param r number
    ---@param g number
    ---@param b number
    ---@param zOffset number
    local function start(u, text, size, r, g, b, zOffset)
        local angle = 2*math.pi*math.random() -- To prevent desync

        if IsUnitVisible(u, LocalPlayer) then
            local x = GetUnitX(u)
            local y = GetUnitY(u)

            local tt = CreateTextTag()
            SetTextTagLifespan(tt, TIME_LIFE)
            SetTextTagFadepoint(tt, TIME_FADE)
            SetTextTagText(tt, text, SIZE_MIN*size)
            SetTextTagPos(tt, x, y, zOffset)
            SetTextTagColorBJ(tt, r, g, b, 0)
            SetTextTagPermanent(tt, false)

            table.insert(texttags, {
                tt = tt,
                x = x,
                y = y,
                time = TIME_LIFE,
                as = math.sin(angle)*VELOCITY,
                ac = math.cos(angle)*VELOCITY,
                text = text,
                zOffset = zOffset,
                size = size
            })
        end
    end

    udg_DisplayDamageEx = CreateTrigger()
    TriggerAddAction(udg_DisplayDamageEx, function ()
        start(
            udg_PositionUnit,
            udg_Text,
            udg_Size,
            udg_Red,
            udg_Green,
            udg_Blue,
            udg_ZOffset
        )
        udg_ZOffset = 0
    end)
end)
Debug.endFile()