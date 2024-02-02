-----------------------------------
-- Area: Garlaige Citadel
--  Mob: Wanzo-Unzozo
-- Type: Quest mob (Escort for Hire - Windurst)
-----------------------------------
local ID = zones[xi.zone.GARLAIGE_CITADEL]
-----------------------------------

local path =
{
    { -381.0000, -12.0000, 398.0000 },
    { -380.8830, -12.0000, 391.8802 },
    { -378.7068, -6.12510, 368.4137 },
    { -379.2549, -6.00000, 346.8558 },
    { -357.3971, -6.00000, 338.0250 },
    { -341.3876, -3.25000, 339.8453 },
    { -340.9149, 0.000000, 297.0475 },
    { -336.8979, 0.000000, 288.6178 },
    { -342.1649, 0.000000, 270.2281 },
    { -354.1182, 0.000000, 268.7367 },
    { -354.2867, 0.000000, 249.9196 },
    { -340.2825, 0.000000, 249.7256 },
    { -337.6853, 0.000000, 221.3183 },
    { -314.6676, 0.000000, 218.6108 },
    { -300.1329, 0.000000, 226.1669 },
    { -275.1773, 0.000000, 217.3463 },
    { -271.0707, 0.000000, 219.7949 }, -- Middle of holes
    { -237.1567, 0.000000, 218.0966 },
    { -180.1768, 0.000000, 221.7442 },
    { -178.3567, 0.000000, 259.3759 },
    { -143.2720, 0.000000, 262.7013 },
    { -138.2194, 0.000000, 230.2753 },
    { -125.7615, 0.000000, 229.9893 },
    { -126.1223, 0.000000, 217.9252 },
    { -133.0517, 0.000000, 204.5436 }, -- Dead End
    { -126.1223, 0.000000, 217.9252 },
    { -125.7615, 0.000000, 229.9893 },
    { -138.2194, 0.000000, 230.2753 },
    { -138.9951, 0.000000, 254.4034 },
    { -106.9740, 0.000000, 262.5682 },
    { -100.8588, 0.000000, 256.1013 },
    { -97.54940, 0.000000, 222.0876 },
    { -65.87720, 0.000000, 217.7562 },
    { -57.52250, 0.000000, 192.7869 },
    { -60.73950, 5.927000, 153.6628 }, -- Basement
    { -54.09130, 7.176200, 143.8619 },
    { -42.03350, 6.000000, 144.9311 },
    { -30.21860, 7.443100, 137.7087 },
    { -17.81050, 6.567400, 147.5737 },
    { -16.16890, 8.139700, 138.4585 },
    { -20.54190, 6.000000, 118.7473 },
    { -19.41390, 2.750000, 101.3711 },
    { -101.4705, 0.000000, 100.9095 },
    { -167.2571, 0.000000, 98.46240 },
    { -177.5856, 0.000000, 94.07690 },
    { -210.6050, 0.000000, 102.8821 },
    { -220.0769, 0.000000, 110.8499 },
    { -216.9912, 0.000000, 128.0300 },
    { -219.6814, 0.000000, 139.8317 }, -- Destination
}

local escortProgress =
{
    NONE     = 0, -- Have not started pathing at all yet
    ENROUTE  = 1, -- Started pathing and is continuing along path
    PAUSED   = 2, -- Has paused pathing and awaiting orders
    COMPLETE = 3, -- Has reached the end of the escort mission
}

local entity = {}

-- Reset Wazon to spawn point and reset AI
entity.resetWazon = function(mob)
    -- DespawnMob(mob:getID())
    -- GetNPCByID(ID.npc.WANZO_UNZOZO):setStatus(xi.status.NORMAL)
end


entity.shouldMove = function(mob, progress)
    return not mob:isFollowingPath() and mob:getStatus() == xi.status.NORMAL and progress ~= escortProgress.COMPLETE
end

entity.onMobInitialize = function(mob)
    -- GetNPCByID(ID.npc.WANZO_UNZOZO):setStatus(xi.status.INVISIBLE)
    mob:setMobMod(xi.mobMod.NO_MOVE, 1)
    mob:setMobMod(xi.mobMod.NO_DESPAWN, 1)
    mob:setAutoAttackEnabled(false)
end

entity.onMobRoam = function(mob)
    mob:setStatus(xi.status.NORMAL)
    local progress = mob:getLocalVar('progress')
    if progress == escortProgress.NONE then
        mob:setLocalVar('progress', escortProgress.ENROUTE)
        local point = 1
        mob:setLocalVar('point', point)
        mob:pathThrough(path[point], xi.path.flag.WALK)
    end

    local now = os.time()
    local expire = mob:getLocalVar('expire')
    if expire ~= 0 and expire <= now then
        if progress ~= escortProgress.COMPLETE then
            mob:showText(mob, ID.text.RAN_OUT_OF_TIME)
        end

        mob:setStatus(xi.status.INVISIBLE)
        DespawnMob(mob:getID())
        return
    end
end

entity.onPath = function(mob)
    local progress = mob:getLocalVar('progress')
    local escort = mob:getLocalVar('escort')

    if escort ~= nil and entity.shouldMove(mob, progress) then
        local point = mob:getLocalVar('point')
        if point == #path then
            mob:showText(mob, ID.text.I_THANK_YOU)
            mob:setLocalVar('progress', escortProgress.COMPLETE)
            mob:setLocalVar('expire', os.time() + 60)
        elseif progress ~= escortProgress.COMPLETE then
            point = point + 1
            mob:setLocalVar('point', point)
            mob:pathThrough(path[point], xi.path.flag.WALK)
        end
    end
end

entity.onTrigger = function(player, mob)
    local progress = mob:getLocalVar('progress')
    local point = mob:getLocalVar('point')
    local escort = mob:getLocalVar('escort')

    if escort ~= nil then
        if progress == escortProgress.ENROUTE then
            mob:pathThrough(mob:getPos(), xi.path.flag.NONE)
            mob:showText(mob, ID.text.WHATS_WRONG)
            mob:setLocalVar('progress', escortProgress.PAUSED)
        elseif progress == escortProgress.PAUSED then
            mob:showText(mob, ID.text.LETS_GO)
            mob:setLocalVar('progress', escortProgress.ENROUTE)
            mob:pathThrough(path[point], xi.path.flag.WALK)
        elseif progress == escortProgress.COMPLETE then
            mob:timer(30000, function(mobArg)
                mob:showText(mob, ID.text.BYE_BYE)
                mob:setStatus(xi.status.INVISIBLE)
                -- DespawnMob(wanzo:getID())
            end)
        end
    end
end

entity.onMobEngaged = function(mob, target)
    mob:setLocalVar('progress', escortProgress.PAUSED)
end

entity.onMobDeath = function(mob, player, optParams)
    player:messageText(mob, ID.text.LOST_SIGHT)
    mob:setStatus(xi.status.INVISIBLE)
    entity.resetWazon(mob)
end

return entity

-- entity.onMobRoam = function(mob)
--     if mob:atPoint(xi.path.last(route)) and mob:getLocalVar("win") == 0 then
--         mob:setLocalVar("run", 3)
--         mob:setLocalVar("win", 1)
--         mob:timer(30000, function(mobArg)
--             mob:messageText(mob, ID.text.BYE_BYE)
--             -- mob:setStatus(xi.status.INVISIBLE)
--             DespawnMob(mob:getID())
--         end)

--         -- Time up case
--         elseif mob:getLocalVar("timer") < os.time() then
--             resetWazon(mob)

--         -- Run case
--         elseif mob:getLocalVar("run") == 1 then
--             mob:pathThrough(route, xi.path.flag.PATROL)
--         end
-- end


-- -- Reset Wazon to spawn point and reset AI
-- local resetWazon = function(mob)
--     DespawnMob(mob:getID())
--     -- GetNPCByID(ID.npc.WANZO_UNZOZO):setStatus(xi.status.NORMAL)
-- end

-- entity.onTrigger = function(player, mob)
--     -- Begin, Wazon!
--     if player:getCharVar("quest[2][88]Prog") == 1 then
--         local partplayer:getParty()

--         for _, v in ipairs(party) do
--             if v:getZone() == player:getZone() then
--                 v:setCharVar("quest[2][88]Prog", 2)
--             end
--         end
--         mob:messageText(mob, ID.text.TIME_LIMIT, 30)
--         mob:setLocalVar("run", 1)
--     end

--     if player:getCharVar("quest[2][88]Prog") == 2 then
--         -- Stop, Wazon!
--         if mob:getLocalVar("run") == 1 then
--             mob:setLocalVar("run", 0)
--             mob:messageText(mob, ID.text.WHATS_WRONG)

--         -- Run, Wazon!
--         elseif mob:getLocalVar("run") == 0 then
--             mob:setLocalVar("run", 1)
--             mob:messageText(mob, ID.text.LETS_GO)

--         -- We won, Wazon!
--         elseif mob:getLocalVar("win") == 1 then
--             mob:messageText(mob, ID.text.I_THANK_YOU)
--             if not player:hasKeyItem(xi.ki.COMPLETION_CERTIFICATE) then
--                 -- Setting var to 3 disallows player from interacting with this quest any further
--                 player:setCharVar("quest[2][88]Prog", 3)
--                 player:addKeyItem(player, xi.ki.COMPLETION_CERTIFICATE)
--             end
--         end
--     end
-- end