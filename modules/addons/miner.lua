local Event = require 'utils.event_core' --- @dep utils.event_core
local Global = require 'utils.global' --- @dep utils.global
local config = require 'config.miner' --- @dep config.miner

local miner_data = {}

Global.register(miner_data, function(tbl)
    miner_data = tbl
end)

miner_data.queue = {}

local function check_entity(e)
    if e.to_be_deconstructed() then
        -- if it is already waiting to be deconstruct
        return false
    end

    if e.circuit_connected_entities and (next(e.circuit_connected_entities.red) ~= nil or next(e.circuit_connected_entities.green) ~= nil) then
        -- connected to circuit network
        return false
    end

    if not e.minable then
        -- if it is minable
        return false
    end

    if not e.prototype.selectable_in_game then
        -- if it can select
        return false
    end

    if e.has_flag('not-deconstructable') then
        -- if it can deconstruct
        return false
    end

    return true
end

local function drop_target(entity)
    if entity.drop_target then
        return entity.drop_target
    end

    local entities = entity.surface.find_entities_filtered{position=entity.drop_position}

    if #entities > 0 then
        return entities[1]

    else
        return nil
    end
end

local function chest_check(e)
    local t = drop_target(e)

    if not t then
        return
    end

    if t.type and t.type ~= 'logistic-container' and t.type ~= 'container' then
        -- not a chest
        return
    end

    if not check_entity(t) then
        return
    end

    for _, en in pairs(t.surface.find_entities_filtered{position=t.position, radius=2, force=t.force, type={'mining-drill', 'inserter'}}) do
        if drop_target(en) == t and en ~= e and (not check_entity(en)) then
            return
        end
    end

    table.insert(miner_data.queue, {t=game.tick + 10, e=t})
end

local function beacon_check(e)
    local bs = e.get_beacons()

    if not bs then
        return
    end

    local bw = true

    for _, b in pairs(bs) do
        if check_entity(b) then
            for _, r in pairs(b.get_beacon_effect_receivers()) do
                if r ~= e and (not check_entity(r)) then
                    bw = false
                    break
                end
            end

            if bw then
                table.insert(miner_data.queue, {t=game.tick + 10, e=b})
            end
        end
    end
end

local function miner_check(entity)
    if entity.mining_target and entity.mining_target.valid and entity.mining_target.amount and entity.mining_target.amount > 0 then
        return
    end

    for _, r in pairs(entity.surface.find_entities_filtered{position=entity.position, radius=entity.prototype.mining_drill_radius, force=entity.force, type='resource'}) do
        if entity.prototype.resource_categories[r.prototype.resource_category] and r.amount and r.amount > 0 then
            return
        end
    end

    if not check_entity(entity) then
        return
    end

    local pipe_build = {}

    if config.fluid and entity.fluidbox and #entity.fluidbox > 0 then
        -- if require fluid to mine
        table.insert(pipe_build, {x=0, y=0})

        local half = math.floor(entity.get_radius())
        local r = entity.prototype.mining_drill_radius + 0.99

        local en = entity.surface.find_entities_filtered{position=entity.position, radius=r, force=entity.force, type={'mining-drill', 'pipe', 'pipe-to-ground'}}
        table.array_insert(en, entity.surface.find_entities_filtered{position=entity.position, radius=r, force=entity.force, ghost_type={'pipe', 'pipe-to-ground'}})

        for _, e in pairs(en) do
            if (e.position.x > entity.position.x) and (e.position.y == entity.position.y) then
                for h=1, half do
                    table.insert(pipe_build, {x=h, y=0})
                end

            elseif (e.position.x < entity.position.x) and (e.position.y == entity.position.y) then
                for h=1, half do
                    table.insert(pipe_build, {x=-h, y=0})
                end

            elseif (e.position.x == entity.position.x) and (e.position.y > entity.position.y) then
                for h=1, half do
                    table.insert(pipe_build, {x=0, y=h})
                end

            elseif (e.position.x == entity.position.x) and (e.position.y < entity.position.y) then
                for h=1, half do
                    table.insert(pipe_build, {x=0, y=-h})
                end
            end
        end
    end

    if config.chest then
        chest_check(entity)
    end

    if config.beacon then
        beacon_check(entity)
    end

    local es = entity.surface
    local ef = entity.force
    local ep = entity.position

    table.insert(miner_data.queue, {t=game.tick + 5, e=entity})

    for _, e in pairs(pipe_build) do
        es.create_entity{name='entity-ghost', position={x=ep.x + e.x, y=ep.y + e.y}, force=ef, inner_name='pipe', raise_built=true}
    end
end

Event.add(defines.events.on_resource_depleted, function(event)
    if event.entity.prototype.infinite_resource then
        return
    end

    for _, e in pairs(event.entity.surface.find_entities_filtered{position=event.entity.position, radius=1, force=event.entity.force, type='mining-drill'}) do
        miner_check(e)
    end
end)

Event.on_nth_tick(10, function(event)
    for k, q in pairs(miner_data.queue) do
        if q.e and q.e.valid then
            if event.tick >= q.t then
                q.e.order_deconstruction(q.e.force)
                table.remove(miner_data.queue, k)
            end

        else
            table.remove(miner_data.queue, k)
        end
    end
end)
