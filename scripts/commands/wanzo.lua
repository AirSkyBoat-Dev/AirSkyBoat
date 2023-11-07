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
    local spawnX = -381.0000
    local spawnY = -12.0000
    local spawnZ = 398.0000

    -- Create a dynamic entity for the in place of Escort start NPC
    local wanzo = npc:getZone():insertDynamicEntity({
        objtype = xi.objType.MOB,
        name = "Wanzo-Unzozo",
        groupId = 49,
        groupZoneId = 200,
        x = spawnX,
        y = spawnY,
        z = spawnZ,
        rotation = npc:getRotPos(),
        allegiance = xi.allegiance.PLAYER,
        -- isAggroable = true,
        specialSpawnAnimation = true,
        releaseIdOnDisappear = true,
    })

    if wanzo == nil then
        return
    end

    player:setCharVar("WanzoUnzozoId", wanzo:getID()) -- don't do this once we get the quest working properly otherwise a dc might break the quest

    wanzo:addListener("DESPAWN", "DESPAWN_WANZO", function()
        npc:setLocalVar("WanzoUnzozoId", 0)
    end)

    wanzo:setSpawn(spawnX, spawnY, spawnZ, npc:getRotPos())
    wanzo:spawn()
    npc:setStatus(xi.status.DISAPPEAR)
    wanzo:setStatus(xi.status.NORMAL)

    -- player:messageSpecial(ID.text.TIME_LIMIT, timeLimit)
    wanzo:setLocalVar("escort", npc:getID())
    wanzo:setLocalVar("progress", 0)
    -- wanzo:setLocalVar("timer", os.time() + utils.minutes(timeLimit))
    wanzo:setLocalVar("timer", os.time() + 10)
    -- wanzo:showText(wanzo, ID.text.LETS_GO)
end