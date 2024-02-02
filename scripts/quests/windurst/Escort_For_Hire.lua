-----------------------------------
-- Escort for Hire (Windurst)
-----------------------------------
-- Log ID: 2, Quest ID: 4
-- Dehn Harzhapan !pos -7, -6, 152
-----------------------------------
require('scripts/globals/interaction/quest')
require('scripts/globals/npc_util')
require('scripts/globals/quests')
-----------------------------------
local ID = zones[xi.zone.GARLAIGE_CITADEL]
-----------------------------------

local quest = Quest:new(xi.quest.log_id.WINDURST, xi.quest.id.windurst.ESCORT_FOR_HIRE)

quest.reward =
{
    gil = 10000,
    fame = 100,
    fameArea = xi.quest.fame_area.WINDURST,
    item = xi.items.MIRATETES_MEMOIRS,
}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == QUEST_AVAILABLE and
            player:getQuestStatus(xi.quest.log_id.BASTOK, xi.quest.id.windurst.ESCORT_FOR_HIRE) ~= QUEST_ACCEPTED and
            player:getQuestStatus(xi.quest.log_id.SANDORIA, xi.quest.id.windurst.ESCORT_FOR_HIRE) ~= QUEST_ACCEPTED and
            player:getFameLevel(xi.quest.fame_area.WINDURST) >= 6  -- Disables the quest
        end,
        -- and
        -- player:getCharVar("ESCORT_CONQUEST") < NextConquestTally() and false
        [xi.zone.PORT_WINDURST] =
        {
            ['Dehn_Harzhapan'] =
            {
                onTrigger = function(player, npc)
                    return quest:event(10014):oncePerZone() -- start
                end,
            },

            -- quest:progressEvent(10014),

            onEventFinish =
            {
                [10014] = function(player, csid, option, npc)
                    quest:begin(player)
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_ACCEPTED
        end,

        [xi.zone.GARLAIGE_CITADEL] =
        {
            onZoneIn =
            {
                function(player, prevZone)
                    local w = string.format('%i', player:getLocalVar('WanzoUnzozoId'))
                    player:printToPlayer(w)

                    -- If a party is already running quest, do not start event.
                    if player:getLocalVar('WanzoUnzozoId') == 0 then
                        player:printToPlayer(w)
                        if quest:getVar(player, 'Prog') == 0 then
                            for _, v in ipairs(player:getParty()) do
                                quest:setVar(v, 'Prog', 1)
                            end
                            return 60
                        -- Players are trying to redo escort
                        elseif quest:getVar(player, 'Prog') == 2 and player:getLocalVar('WanzoUnzozoId') == 0 then
                            for _, v in ipairs(player:getParty()) do
                                quest:setVar(v, 'Prog', 1)
                            end
                            return 60
                        end
                    end
                end,
            },

            onEventUpdate =
            {
                [60] = function(player, csid, option, npc)
                end,
            },

            onEventFinish =
            {
                [60] = function(player, csid, option, npc)
                    -- SpawnMob(17596834)

                    if player:getLocalVar('WanzoUnzozoId') == nil then
                        if quest:getVar(player, 'Prog') == 0 then
                            for _, v in ipairs(player:getParty()) do
                                quest:setVar(v, 'Prog', 1)
                            end

                        -- Players are trying to redo escort
                        elseif quest:getVar(player, 'Prog') == 2 and player:getLocalVar('WanzoUnzozoId') == nil then
                            for _, v in ipairs(player:getParty()) do
                                quest:setVar(v, 'Prog', 1)
                            end
                        end
                    end
                    -- GetNPCByID(ID.npc.WANZO_UNZOZO):setStatus(xi.status.NORMAL)
                    local zone = player:getZone()

                    local spawn = {
                        x = -379.420,
                        y = -10.749,
                        z = 383.312,
                        rot = 188,
                    }

                    local wanzo = zone:insertDynamicEntity({
                        objtype = xi.objType.MOB,
                        name = 'Wanzo-Unzozo',
                        groupId = 49,
                        groupZoneId = 200,
                        x = spawn.x,
                        y = spawn.y,
                        z = spawn.z,
                        rotation = spawn.rot,
                        -- look = 0x01000205111011201130034003507B6000700000,
                        allegiance = xi.allegiance.PLAYER,
                        isAggroable = true,
                        specialSpawnAnimation = true,
                        releaseIdOnDisappear = true,
                    })

                    if wanzo == nil then
                        return
                    end

                    zone:setLocalVar('WanzoUnzozoId', wanzo:getID())

                    wanzo:setSpawn(spawn.x, spawn.y, spawn.z, spawn.rot)
                    wanzo:spawn()
                    wanzo:setStatus(xi.status.NORMAL)

                    player:messageSpecial(ID.text.TIME_LIMIT, 30)
                    wanzo:setLocalVar('escort', wanzo:getID())
                    wanzo:setLocalVar('progress', 0)
                    wanzo:setLocalVar('expire', os.time() + utils.minutes(30))
                    wanzo:showText(wanzo, ID.text.LETS_GO)
                    player:getZone():setLocalVar("expire", os.time() + 1800)
                end,
            },
        },

        [xi.zone.PORT_WINDURST] =
        {
            ['Dehn_Harzhapan'] =
            {
                onTrigger = function(player, npc)
                    if player:hasKeyItem(xi.ki.COMPLETION_CERTIFICATE) then
                        return quest:progressEvent(10016)
                    else
                        return quest:progressEvent(10015)
                    end
                end,
            },

            onEventFinish =
            {
                [10016] = function(player, csid, option, npc)
                    player:setCharVar("ESCORT_CONQUEST", NextConquestTally())
                    player:delKeyItem(xi.ki.COMPLETION_CERTIFICATE)
                    quest:complete(player)
                end,
                [10015] = function(player, csid, option, npc)
                    if option == 0 then
                        player:delQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.ESCORT_FOR_HIRE)
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == QUEST_COMPLETED and
            player:getQuestStatus(xi.quest.log_id.BASTOK, xi.quest.id.windurst.ESCORT_FOR_HIRE) ~= QUEST_ACCEPTED and
            player:getQuestStatus(xi.quest.log_id.SANDORIA, xi.quest.id.windurst.ESCORT_FOR_HIRE) ~= QUEST_ACCEPTED
        end,

        [xi.zone.PORT_WINDURST] =
        {
            ['Dehn_Harzhapan'] =
            {
                onTrigger = function(player, npc)
                    if player:getCharVar("ESCORT_CONQUEST") < NextConquestTally() then
                        return quest:progressEvent(10014)
                    elseif player:getCharVar("ESCORT_CONQUEST") > NextConquestTally() then
                        return quest:progressEvent(10017)
                    end
                end,
            },

            onEventFinish =
            {
                [10014] = function(player, csid, option, npc)
                    player:delQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.ESCORT_FOR_HIRE)
                    quest:begin(player)
                end,
            },
        },
    },
}

return quest