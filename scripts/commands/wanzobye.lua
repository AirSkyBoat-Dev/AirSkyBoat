-----------------------------------
-- func: speed
-- desc: Sets the players movement speed.
-----------------------------------
local commandObj = {}

commandObj.cmdprops =
{
    permission = 1,
    parameters = "i"
}

commandObj.onTrigger = function(player, npc)
    npc = GetNPCByID(17596834)
    npc:setStatus(xi.status.DISAPPEAR)
end

return commandObj
