Debug.beginFile("GymData")
OnInit("GymData", function ()

    local RANK_PRIZES =
    { ---@type {equips: integer?, damage: integer?, defense: number?, health: integer?, energy: integer?}[]
        [1] =   {equips = nil,    damage = 1,     defense = nil,      health = nil,   energy = nil},
        [2] =   {equips = nil,    damage = 1,     defense = 0.5,      health = nil,   energy = nil},
        [3] =   {equips = nil,    damage = 1,     defense = 0.5,      health = 10,    energy = nil},
        [4] =   {equips = nil,    damage = 1,     defense = 0.5,      health = 10,    energy = 8},
        [5] =   {equips = 3,      damage = 2,     defense = 1,        health = 20,    energy = 16},
        [6] =   {equips = nil,    damage = 3,     defense = 1,      health = 20,    energy = 16},
        [7] =   {equips = nil,    damage = 3,     defense = 1.5,      health = 20,    energy = 16},
        [8] =   {equips = nil,    damage = 3,     defense = 1.5,      health = 30,    energy = 16},
        [9] =   {equips = nil,    damage = 3,     defense = 1.5,      health = 30,    energy = 24},
        [10] =  {equips = 3,      damage = 4,     defense = 2,        health = 40,    energy = 32},
        [11] =  {equips = nil,    damage = 5,     defense = 2,      health = 40,    energy = 32},
        [12] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 40,    energy = 32},
        [13] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 50,    energy = 32},
        [14] =  {equips = nil,    damage = 5,     defense = 2.5,      health = 50,    energy = 40},
        [15] =  {equips = 3,      damage = 6,     defense = 3,        health = 70,    energy = 50},
        [16] =  {equips = nil,    damage = 7,     defense = 3,      health = 70,    energy = 50},
        [17] =  {equips = nil,    damage = 7,     defense = 3.5,      health = 70,    energy = 50},
        [18] =  {equips = nil,    damage = 7,     defense = 3.5,      health = 90,    energy = 50},
        [19] =  {equips = nil,    damage = 7,     defense = 3.5,      health = 90,    energy = 60},
        [20] =  {equips = 3,      damage = 8,     defense = 4,        health = 100,    energy = 70},
        [21] =  {equips = nil,    damage = 9,     defense = 4,      health = 100,    energy = 70},
        [22] =  {equips = nil,    damage = 9,     defense = 4.5,      health = 100,    energy = 70},
        [23] =  {equips = nil,    damage = 9,     defense = 4.5,      health = 110,    energy = 70},
        [24] =  {equips = nil,    damage = 9,     defense = 4.5,      health = 110,    energy = 80},
        [25] =  {equips = nil,    damage = 10,     defense = 5,       health = 150,   energy = 100}
    }

    return RANK_PRIZES
end)
Debug.endFile()