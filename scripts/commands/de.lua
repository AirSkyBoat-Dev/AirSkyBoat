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
    local timeLimit = 30
    local spawnX = player:getXPos()
    local spawnY = player:getYPos()
    local spawnZ = player:getZPos()

    -- Create a dynamic entity for the in place of Escort start NPC
    local dummy = npc:getZone():insertDynamicEntity({
        objtype = xi.objType.TRUST,
        name = "Test-Dummy",
        groupId = 49,
        groupZoneId = 200,
        x = spawnX,
        y = spawnY,
        z = spawnZ,
        rotation = player:getRotPos(),
        allegiance = xi.allegiance.WINDURST,
        isAggroable = true,
        specialSpawnAnimation = false,
        releaseIdOnDisappear = true,
    })

    if dummy == nil then
        return
    end

    player:setCharVar("dummyId", dummy:getID()) -- don't do this once we get the quest working properly otherwise a dc might break the quest

    dummy:addListener("DESPAWN", "DESPAWN_dummy", function()
        player:setLocalVar("dummyId", 0)
    end)

    dummy:setSpawn(spawnX, spawnY, spawnZ, player:getRotPos())
    dummy:spawn()
    dummy:setStatus(xi.status.UPDATE)
end