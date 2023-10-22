Debug.beginFile("GenerateCosmeticCode")
OnInit("GenerateCosmeticCode", function ()
    Require "Savecode"
    Require "FileIO"

    local MAX_LENGTH_PASSWORD = 200

    ---@param p player
    ---@param password string
    function GenerateKeyToCosmetic(p, password)
        local savecode = Savecode.create()

        for i = 1, password:len() do
            savecode:Encode(password:byte(i), 256)
        end
        savecode:Encode(password:len(), MAX_LENGTH_PASSWORD)

        local key = savecode:Save(p, 2)
        savecode:destroy()

        if p == GetLocalPlayer() then
            FileIO.Write("DigimonWorldCode.pld", "\n\n"
                      .. "\tThe player " .. GetPlayerName(p) .. " should use the command:\n"
                      .. "\t\t-unlock " .. key .. "\n"
                      .. "\tTo unlock a cosmetic.\n\n")
            print("The player " .. GetPlayerName(p) .. " should use the command:\n"
               .. "\t-unlock " .. colorize(key) .. "\n"
               .. "To unlock a cosmetic.")
        end
    end
end)
Debug.endFile()