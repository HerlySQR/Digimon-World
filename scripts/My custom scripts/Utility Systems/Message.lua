if Debug then Debug.beginFile("Message") end
do
    -- Error message

    local errorSound

    ---@param message string
    ---@param whatPlayer player
    function ErrorMessage(message, whatPlayer)
        if not errorSound then
            errorSound = CreateSoundFromLabel("InterfaceError", false, false, false, 10, 10)
        end

        if GetLocalPlayer() == whatPlayer then
            ClearTextMessages()
            DisplayTimedTextToPlayer(whatPlayer, 0.52, 0.96, 2, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n|cffffcc00" .. message .. "|r")
            StartSound(errorSound)
        end
    end
end
if Debug then Debug.endFile() end