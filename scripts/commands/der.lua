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
    -- GetNPCByID(17596834):setStatus(xi.status.NORMAL)
    DespawnMob(player:getCharVar("dummyId"))
end