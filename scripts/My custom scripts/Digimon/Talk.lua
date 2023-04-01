Debug.beginFile("Talk")
OnInit("Talk", function ()
    Require "Timed"

    ---@class Talk
    ---@field talkers unit[]
    ---@field dialogues string[]
    ---@field autoContinue boolean

    local ActualTalking = {} ---@type table<player, Talk>

    ---@param talkers unit[]
    ---@param dialogues string[]
    ---@param autoContinue boolean
    function Talk(talkers, dialogues, autoContinue)
        
    end
end)
Debug.endFile()