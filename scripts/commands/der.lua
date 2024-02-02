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
    GetNPCByID(17596834):setStatus(xi.status.NORMAL)
    -- DespawnMob(player:getCharVar("dummyId"))
end

return commandObj
