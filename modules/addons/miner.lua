local Event = require 'utils.event_core' --- @dep utils.event_core
local Global = require 'utils.global' --- @dep utils.global
local config = require 'config.miner' --- @dep config.miner

local miner_data = {}

Global.register(miner_data, function(tbl)
    miner_data = tbl
end)

miner_data.queue = {}

local function drop_target(entity)
    if entity.drop_target then
        return entity.drop_target

    else
        local entities = entity.surface.find_entities_filtered{position=entity.drop_position}

        if #entities > 0 then
            return entities[1]
        end
    end
end

local function check_entity(e)
    if e.to_be_deconstructed(e.force) then
        -- if it is already waiting to be deconstruct
        return true
    end

    if next(e.circuit_connected_entities.red) ~= nil or next(e.circuit_connected_entities.green) ~= nil then
        -- connected to circuit network
        return true
    end

    if not e.minable then
        -- if it is minable
        return true
    end

    if not e.prototype.selectable_in_game then
        -- if it can select
        return true
    end

    if e.has_flag('not-deconstructable') then
        -- if it can deconstruct
        return true
    end

    return false
end

local function chest_check(e)
    local t = drop_target(e)

    if t.type ~= 'logistic-container' and t.type ~= 'container' then
        -- not a chest
        return
    end

    local r = 2

    for _, en in pairs(t.surface.find_entities_filtered{area={{t.position.x - r, t.position.y - r}, {t.position.x + r, t.position.y + r}}, type={'mining-drill', 'inserter'}}) do
        if drop_target(en) == t and (not en.to_be_deconstructed(e.force)) and en ~= e then
            return
        end
    end

    if check_entity(t) then
        table.insert(miner_data.queue, {t=game.tick + 60, e=t})
    end
end

local function beacon_check(e)
    local bs = e.get_beacons()

    if bs == nil then
        return
    end

    local bb = false

    for _, b in pairs(bs) do
        if not check_entity(b) then
            for _, r in pairs(b.get_beacon_effect_receivers()) do
                if b ~= e and (not check_entity(r)) then
                    bb = true
                    break
                end
            end

            if not bb then
                table.insert(miner_data.queue, {t=game.tick + 60, e=b})
            end
        end
    end
end

local function miner_check(entity)
    local ep = entity.position
    local es = entity.surface
    local ef = entity.force
    local er = entity.prototype.mining_drill_radius
    local ea = {{x=ep.x - er, y=ep.y - er}, {x=ep.x + er, y=ep.y + er}}

    if entity.mining_target and entity.mining_target.valid and entity.mining_target.amount and entity.mining_target.amount > 0 then
        return
    end

    for _, r in pairs(entity.surface.find_entities_filtered{area=ea, type='resource'}) do
        if r.amount > 0 then
            return
        end
    end

    if check_entity(entity) then
        return
    end

    local pipe_build = {}

    if config.fluid and entity.fluidbox and #entity.fluidbox > 0 then

        -- if require fluid to mine
        table.insert(pipe_build, {x=0, y=0})

        local half = math.floor(entity.get_radius())
        local r = er + 0.99
        ea = {{x=ep.x - r, y=ep.y - r}, {x=ep.x + r, y=ep.y + r}}

        local en = es.find_entities_filtered{area=ea, type={'mining-drill', 'pipe', 'pipe-to-ground'}}
        table.array_insert(en, es.find_entities_filtered{area=ea, ghost_type={'pipe', 'pipe-to-ground'}})

        for _, e in pairs(en) do
            if (e.position.x > ep.x) and (e.position.y == ep.y) then
                for h=1, half do
                    table.insert(pipe_build, {x=h, y=0})
                end

            elseif (e.position.x < ep.x) and (e.position.y == ep.y) then
                for h=1, half do
                    table.insert(pipe_build, {x=-h, y=0})
                end

            elseif (e.position.x == ep.x) and (e.position.y > ep.y) then
                for h=1, half do
                    table.insert(pipe_build, {x=0, y=h})
                end

            elseif (e.position.x == ep.x) and (e.position.y < ep.y) then
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

    table.insert(miner_data.queue, {t=game.tick + 30, e=entity})

    for _, e in ipairs(pipe_build) do
        es.create_entity{name='entity-ghost', position={x=ep.x + e.x, y=ep.y + e.y}, force=ef, inner_name='pipe', raise_built=true}
    end
end

Event.add(defines.events.on_resource_depleted, function(event)
    if event.entity.prototype.infinite_resource then
        return
    end

    local r = 2

    for _, e in pairs(event.entity.surface.find_entities_filtered{area={{event.entity.position.x - r, event.entity.position.y - r}, {event.entity.position.x + r, event.entity.position.y + r}}, type='mining-drill'}) do
        if math.abs(e.position.x - event.entity.position.x) < e.prototype.mining_drill_radius and math.abs(e.position.y - event.entity.position.y) < e.prototype.mining_drill_radius then
            miner_check(e)
        end
    end
end)

Event.on_nth_tick(60, function(event)
    for k, q in pairs(miner_data.queue) do
        if q.e and q.e.valid and event.tick >= q.t then
            q.e.order_deconstruction(q.e.force)
            table.remove(miner_data.queue, k)

        else
            table.remove(miner_data.queue, k)
        end
    end
end)
