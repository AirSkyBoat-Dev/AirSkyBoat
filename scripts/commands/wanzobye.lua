-----------------------------------
-- func: speed
-- desc: Sets the players movement speed.
-----------------------------------
cmdprops =
{
    permission = 1,
    parameters = "i"
}

function onTrigger(player, npc)
    npc = GetNPCByID(17596834)
    npc:setStatus(xi.status.DISAPPEAR)
end