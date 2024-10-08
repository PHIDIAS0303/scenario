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
        return false
    end

    local r = 2

    for _, en in pairs(t.surface.find_entities_filtered{area={{t.position.x - r, t.position.y - r}, {t.position.x + r, t.position.y + r}}, type={'mining-drill', 'inserter'}}) do
        if drop_target(en) == t then
            if not en.to_be_deconstructed(e.force) and en ~= e then
                return false
            end
        end
    end

    if check_entity(t) then
        table.insert(miner_data.queue, {t=game.tick + 60, e=t})
    end
end

local function beacon_check(entity)
    local b = entity.get_beacons()

    if b == nil then
        return false
    end

    for _, e in pairs(b) do
        if not check_entity(e) then
            local bb = false

            for _, r in pairs(e.get_beacon_effect_receivers()) do
                if e ~= entity and not check_entity(r) then
                    bb = true
                    break
                end
            end

            if bb then
                table.insert(miner_data.queue, {t=game.tick + 60, e=e})
            end
        end
    end
end

local function miner_check(entity)
    local ep = entity.position
    local es = entity.surface
    local ef = entity.force
    local er = entity.prototype.mining_drill_radius

    if entity.mining_target and entity.mining_target.valid and entity.mining_target.amount and entity.mining_target.amount > 0 then
        return false
    end

    for _, r in pairs(entity.surface.find_entities_filtered{area={{x=ep.x - er, y=ep.y - er}, {x=ep.x + er, y=ep.y + er}}, type='resource'}) do
        if r.amount > 0 then
            return false
        end
    end

    if check_entity(entity) then
        return false
    end

    local pipe_build = {}

    if config.fluid and entity.fluidbox and #entity.fluidbox > 0 then
        -- if require fluid to mine
        table.insert(pipe_build, {x=0, y=0})

        local half = math.floor(entity.get_radius())
        local r = 0.99 + er

        local entities = es.find_entities_filtered{area={{ep.x - r, ep.y - r}, {ep.x + r, ep.y + r}}, type={'mining-drill', 'pipe', 'pipe-to-ground'}}
        local entities_t = es.find_entities_filtered{area={{ep.x - r, ep.y - r}, {ep.x + r, ep.y + r}}, ghost_type={'pipe', 'pipe-to-ground'}}

        table.array_insert(entities, entities_t)

        for _, e in pairs(entities) do
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

    game.print(6)

    table.insert(miner_data.queue, {t=game.tick + 30, e=entity})

    for _, pos in ipairs(pipe_build) do
        es.create_entity{name='entity-ghost', position={x=ep.x + pos.x, y=ep.y + pos.y}, force=ef, inner_name='pipe', raise_built=true}
    end
end

Event.add(defines.events.on_resource_depleted, function(event)
    local en = event.entity

    if en.prototype.infinite_resource then
        return
    end

    local p = en.position
    local r = 2

    for _, e in pairs(en.surface.find_entities_filtered{area={{p.x - r, p.y - r}, {p.x + r, p.y + r}}, type='mining-drill'}) do
        r = e.prototype.mining_drill_radius

        if ((math.abs(e.position.x - p.x) < r) and (math.abs(e.position.y - p.y) < r)) then
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
