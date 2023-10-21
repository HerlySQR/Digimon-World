Debug.beginFile("GenerateCosmeticCode")
OnInit("GenerateCosmeticCode", function ()
    Require "Savecode"
    Require "FileIO"

    local MAX_LENGTH_PASSWORD = 200

    ---@param p player
    ---@param password string
    function GenerateKeyToCosmetic(p, password)
        assert(LockedCosmetics[password], "There is no cosmetic with the password " .. password)

        local savecode = Savecode.create()

        for i = 1, password:len() do
            savecode:Encode(password:byte(i), 256)
        end
        savecode:Encode(password:len(), MAX_LENGTH_PASSWORD)

        local key = savecode:Save(p, 2)
        savecode:destroy()

        if p == GetLocalPlayer() then
            FileIO.Write("DigimonWorldCode.pld", "unlock " .. key)
            print(colorize(key))
        end
    end
end)
Debug.endFile()