-----------------------------------
-- func: !spawnwanzo
-- desc: Spawn a dynamic mob exactly matching that of a normal mob.
-- note: Original code from zach2Good's Fafnir.lua
-----------------------------------

-- cmdprops =
-- {
--     permission = 4,
--     parameters = "ii"
-- }
-- function error(player, msg)
--     player:PrintToPlayer(msg)
--     player:PrintToPlayer("!spawndynamicmob <Mob's Group ID> <Mob's Zone ID> { Number of Mobs } { Name for the Mob } { dropsEnabled (1/0) } { Costume Finder (1/0) }")
-- end
-- function onTrigger(player)

--     local zone = player:getZone()
--     local wanzo = zone:insertDynamisEntity({
--         objtype = xi.objType.MOB,
--         allegiance = xi.allegiance.PLAYER,
--         name = "Wanzo-Unzozo",
--         x = -381.1,
--         y = -12,
--         z = 398,
--         rotation = 1,
--         groupId = 49,
--         groupZoneId = 200,
--         look = 0x01000205111011201130034003507B6000700000,
--         isAggroable = true,
--         -- onTrigger = function() -- i think this is where im going to implement the logic?
--         -- end,
--         onMobDeath = function(mob, playerArg, optParams) -- use this to reset the AI
--         end,
--     })
--     wanzo:spawn()
--     player:PrintToPlayer(string.format("Spawning %s: (ID: %i) (Level: %i)", wanzo:getName(), wanzo:getID(), wanzo:getMainLvl(), xi.msg.channel.SYSTEM_3))
-- end
cmdprops =
{
    permission = 4,
    parameters = ""
}

function onTrigger(player)
    local zone = player:getZone()

    local mob = zone:insertDynamicEntity({
        -- NPC or MOB
        objtype = xi.objType.MOB,

        -- The name visible to players
        -- NOTE: Even if you plan on making the name invisible, we're using it internally for lookups
        --     : So populate it with something unique-ish even if you aren't going to use it.
        --     : You can then hide the name with entity:hideName(true)
        -- NOTE: This name CAN include spaces and underscores.
        name = "Wanzo-Unzozo",

        -- Set the position using in-game x, y and z
        x = -381.1,
        y = -12,
        z = 398,
        rotation = player:getRotPos(),

        -- Fafnir's entry in mob_groups:
        -- INSERT INTO `mob_groups` VALUES (5, 1280, 154, 'Fafnir', 0, 128, 805, 70000, 0, 90, 90, 0)
        --                       groupId ---^        ^--- groupZoneId
        groupId = 49,
        groupZoneId = 200,

        -- You can provide an onMobDeath function if you want: if you don't
        -- add one, an empty one will be inserted for you behind the scenes.
        onMobDeath = function(mob, playerArg, optParams)
            -- Do stuff
        end,
        isAggroable = true,

        -- If set to true, the internal id assigned to this mob will be released for other dynamic entities to use
        -- after this mob has died. Defaults to false.
        releaseIdOnDisappear = true,

        -- You can apply mixins like you would with regular mobs. mixinOptions aren't supported yet.
        mixins =
        {
            -- require("scripts/mixins/rage"),
            -- require("scripts/mixins/job_special"),
        },

        -- The "whooshy" special animation that plays when Trusts or Dynamis mobs spawn
        specialSpawnAnimation = true,

        allegiance = xi.allegiance.PLAYER,

        onTrigger = function(player, mob)
            mob:showText("Hello!")
        end
    })

    -- Use the mob object as you normally would
    mob:setSpawn(player:getXPos(), player:getYPos(), player:getZPos(), player:getRotPos())

    mob:setMobMod(xi.mobMod.NO_DROPS, 1)

    mob:spawn()

    player:PrintToPlayer(string.format("Spawning Wanzo (Lv: %i, HP: %i)\n%s", mob:getMainLvl(), mob:getMaxHP(), mob), xi.msg.channel.SYSTEM_3)
end