--[[
    /* -------------------- Missile Effect v2.6 by Chopinski -------------------- */
    Credits to Forsakn for the first translation of Missile Effect to LUA
]]--

do
    MissileEffect = setmetatable({}, {})
    ---@class MissileEffect
    ---@field x number
    ---@field y number
    ---@field z number
    ---@field yaw number
    ---@field pitch number
    ---@field roll number
    ---@field size number
    ---@field effect effect
    ---@field private array MissileEffect[]
    local mt = getmetatable(MissileEffect)
    mt.__index = mt

    function mt:destroy()
        local size = #self.array
        
        for i = 1, size do
            local this = self.array[i]
            DestroyEffect(this.effect)
            this = nil
        end
        DestroyEffect(self.effect)
        
        self = nil
    end

    ---@param effect effect
    ---@param scale number
    function mt:scale(effect, scale)
        self.size = scale
        BlzSetSpecialEffectScale(effect, scale)
    end

    ---@param yaw number
    ---@param pitch number
    ---@param roll number
    function mt:orient(yaw, pitch, roll)
        self.yaw   = yaw
        self.pitch = pitch
        self.roll  = roll
        BlzSetSpecialEffectOrientation(self.effect, yaw, pitch, roll)
        
        for i = 1, #self.array do
            local this = self.array[i]
            
            this.yaw   = yaw
            this.pitch = pitch
            this.roll  = roll
            BlzSetSpecialEffectOrientation(this.effect, yaw, pitch, roll)
        end
    end

    ---@param x number
    ---@param y number
    ---@param z number
    ---@return boolean
    function mt:move(x, y, z)
        if not (x > WorldBounds.maxX or x < WorldBounds.minX or y > WorldBounds.maxY or y < WorldBounds.minY) then
            BlzSetSpecialEffectPosition(self.effect, x, y, z)
            for i = 1, #self.array do
                local this = self.array[i]
                BlzSetSpecialEffectPosition(this.effect, x - this.x, y - this.y, z - this.z)
            end
            
            return true
        end
        return false
    end
    
    ---@param model string
    ---@param dx number
    ---@param dy number
    ---@param dz number
    ---@param scale number
    ---@return effect
    function mt:attach(model, dx, dy, dz, scale)
        local this = {}
        
        this.x = dx
        this.y = dy
        this.z = dz
        this.yaw = 0
        this.pitch = 0
        this.roll = 0
        this.path = model
        this.size = scale
        this.effect = AddSpecialEffect(model, dx, dy)
        BlzSetSpecialEffectZ(this.effect, dz)
        BlzSetSpecialEffectScale(this.effect, scale)
        BlzSetSpecialEffectPosition(this.effect, BlzGetLocalSpecialEffectX(this.effect) - dx, BlzGetLocalSpecialEffectY(this.effect) - dy, BlzGetLocalSpecialEffectZ(this.effect) - dz)
        
        table.insert(self.array, this)
        
        return this.effect
    end
    
    ---@param effect effect
    function mt:detach(effect)
        for i = 1, #self.array do
            local this = self.array[i]
            if this.effect == effect then
                table.remove(self.array, i)
                DestroyEffect(effect)
                this = nil
                break
            end
        end
    end
    
    ---@param red integer
    ---@param green integer
    ---@param blue integer
    function mt:setColor(red, green, blue)
        BlzSetSpecialEffectColor(self.effect, red, green, blue)
    end
    
    ---@param real number
    function mt:timeScale(real)
        BlzSetSpecialEffectTimeScale(self.effect, real)
    end
    
    ---@param integer integer
    function mt:alpha(integer)
        BlzSetSpecialEffectAlpha(self.effect, integer)
    end
    
    ---@param integer integer
    function mt:playerColor(integer)
        BlzSetSpecialEffectColorByPlayer(self.effect, Player(integer))
    end
    
    ---@param integer integer
    function mt:animation(integer)
        BlzPlaySpecialEffect(self.effect, ConvertAnimType(integer))
    end
    
    ---@param x number
    ---@param y number
    ---@param z number
    ---@return MissileEffect
    function mt:create(x, y, z)
        local this = {}
        setmetatable(this, mt)
        
        this.path = ""
        this.size = 1
        this.yaw = 0
        this.pitch = 0
        this.roll = 0
        this.array = {}
        this.effect = AddSpecialEffect("", x, y)
        BlzSetSpecialEffectZ(this.effect, z)
        
        return this
    end
end