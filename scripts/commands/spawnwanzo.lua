-----------------------------------
-- func: !spawnwanzo
-- desc: Spawn a dynamic mob exactly matching that of a normal mob.
-- note: Original code from zach2Good's Fafnir.lua
-----------------------------------

cmdprops =
{
    permission = 4,
    parameters = ""
}
function onTrigger(player)
    local zone = player:getZone()
    if zone == xi.zone.GARLAIGE_CITADEL then
        local wanzo = zone:insertDynamisEntity({
            objtype = xi.objType.MOB,
            allegiance = xi.allegiance.PLAYER,
            name = "Wanzo-Unzozo",
            x = -381.1,
            y = -12,
            z = 398,
            minLevel = 45,
            maxLevel = 45,
            rotation = 1,
            groupId = 49,
            groupZoneId = 200,
            look = 0x01000205111011201130034003507B6000700000,
            isAggroable = true,
            onTrigger = function() -- i think this is where im going to implement the logic?
            end,
            onMobDeath = function(mob, playerArg, optParams) -- use this to reset the AI
            end,
        })
        wanzo:spawn()
        player:PrintToPlayer(string.format("Spawning %s: (ID: %i) (Level: %i)", wanzo:getName(), wanzo:getID(), wanzo:getMainLvl(), xi.msg.channel.SYSTEM_3))
    else
        player:PrintToPlayer("Not in Garlaige Citadel. Use !zone.", xi.msg.channel.SYSTEM_3)
    end
end