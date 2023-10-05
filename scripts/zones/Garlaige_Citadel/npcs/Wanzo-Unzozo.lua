-----------------------------------
-- Area: Garlaige Citadel
--  NPC: Wanzo-Unzozo
-- Type: Quest NPC (Escort for Hire - Windurst)
-- !pos -381 -12 398
-----------------------------------
require("scripts/globals/pathfind")
require("scripts/globals/quests")
-----------------------------------
local ID = require('scripts/zones/Garlaige_Citadel/IDs')
-----------------------------------
local entity = {}

entity.onTrigger = function(player, npc)

    local timeLimit = 30
    -- i need to add some logic here that gives a dialog box asking if ready or not
    -- but for testign we can skip this for speed.

    -- Create a dynamic entity for the in place of Escort start NPC
    local wanzo = npc:getZone():insertDynamicEntity({
        objtype = xi.objType.MOB,
        name = "Wanzo-Unzozo",
        groupId = 49,
        groupZoneId = 200,
        x = npc:getXPos(),
        y = npc:getYPos(),
        z = npc:getZPos(),
        rotation = npc:getRotPos(),
        allegiance = xi.allegiance.PLAYER,
        isAggroable = true,
        specialSpawnAnimation = true,
        releaseIdOnDisappear = true,
    })

    if wanzo == nil then
        return
    end

    npc:setLocalVar("WanzoUnzozoId", wanzo:getID())

    wanzo:addListener("DESPAWN", "DESPAWN_WANZO", function()
        npc:setLocalVar("WanzoUnzozoId", 0)
    end)

    wanzo:setSpawn(npc:getXPos(), npc:getYPos(), npc:getZPos(), npc:getRotPos())
    wanzo:spawn()
    npc:setStatus(xi.status.DISAPPEAR) -- Hiding the NPC version of Wanzo, should be able to gt id still?
    wanzo:setStatus(xi.status.NORMAL)

    player:messageSpecial(ID.text.TIME_LIMIT, data.limit)
    wanzo:setLocalVar("escort", npc:getID())
    wanzo:setLocalVar("progress", 0)
    wanzo:setLocalVar("timer", os.time() + utils.minutes(timeLimit))
    wanzo:showText(wanzo, ID.text.LETS_GO)
end

entity.onDeath = function(npc)
end

return entity
