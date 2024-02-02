-----------------------------------
-- func: wanzoreset
-- desc: Resets the AI for wanzo
-----------------------------------
local commandObj = {}

commandObj.cmdprops =
{
    permission = 1,
    parameters = "i"
}

commandObj.onTrigger = function(player, npc)
    -- GetNPCByID(17596834):setStatus(xi.status.NORMAL)
    DespawnMob(player:getCharVar("WanzoUnzozoId"))
end

return commandObj
