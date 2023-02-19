--- Adds a custom spawn area with chests and afk turrets
-- @addon Spawn-Area

local Global = require 'utils.global' --- @dep utils.global
local Event = require 'utils.event' --- @dep utils.event
local config = require 'config.spawn_area' --- @dep config.spawn_area

local turrets = config.turrets.locations
Global.register(turrets, function(tbl)
    turrets = tbl
end)

-- Apply an offset to a LuaPosition
local function apply_offset(position, offset)
    return { x = position.x + (offset.x or offset[1]), y = position.y + (offset.y or offset[2]) }
end

-- Apply the offset to the turrets default position
for _, turret in ipairs(turrets) do
    turret.position = apply_offset(turret.position, config.turrets.offset)
end

-- Get or create the force used for entities in spawn
local function get_spawn_force()
    local force = game.forces['Spawn']
    if force and force.valid then return force end
    force = game.create_force('Spawn')
    force.set_cease_fire('player', true)
    game.forces['player'].set_cease_fire('Spawn', true)
    return force
end

-- Protects an entity and sets its force to the spawn force
local function protect_entity(entity, set_force)
    if entity and entity.valid then
        entity.destructible = false
        entity.minable = false
        entity.rotatable = false
        entity.operable = false
        if not set_force then entity.health = 0 end
        if set_force then entity.force = get_spawn_force() end
    end
end

-- Will spawn all infinite ammo turrets and keep them refilled
local function spawn_turrets()
    for _, turret_pos in pairs(turrets) do
        local surface = game.surfaces[turret_pos.surface]
        local pos = turret_pos.position
        local turret = surface.find_entity('gun-turret', pos)

        -- Makes a new turret if it is not found
        if not turret or not turret.valid then
            turret = surface.create_entity{name='gun-turret', position=pos, force='Spawn'}
            protect_entity(turret, true)
        end

        -- Adds ammo to the turret
        local inv = turret.get_inventory(defines.inventory.turret_ammo)
        if inv.can_insert{name=config.turrets.ammo_type, count=10} then
            inv.insert{name=config.turrets.ammo_type, count=10}
        end
    end
end

-- Makes a 2x2 afk belt at the locations in the config
local function spawn_belts(surface, position)
    position = apply_offset(position, config.afk_belts.offset)
    local belt_type = config.afk_belts.belt_type
    local belt_details = {{-0.5, -0.5, 2}, {0.5, -0.5, 4}, {-0.5, 0.5, 0}, {0.5, 0.5, 6}} -- x, y,dir
    for _, belt_set in pairs(config.afk_belts.locations) do
        local set_position = apply_offset(position, belt_set)
        for _, belt in pairs(belt_details) do
            local pos = apply_offset(set_position, belt)
            local belt_entity = surface.create_entity{name=belt_type, position=pos, force='neutral', direction=belt[3]}
            if config.afk_belts.protected then protect_entity(belt_entity) end
        end
    end
end

-- Generates extra tiles in a set pattern as defined in the config
local function spawn_pattern(surface, position)
    position = apply_offset(position, config.pattern.offset)
    local tiles_to_make = {}
    local pattern_tile = config.pattern.pattern_tile
    for _, tile in pairs(config.pattern.locations) do
        table.insert(tiles_to_make, {name=pattern_tile, position=apply_offset(position, tile)})
    end
    surface.set_tiles(tiles_to_make)
end

-- Generates extra water as defined in the config
local function spawn_water(surface, position)
    position = apply_offset(position, config.water.offset)
    local tiles_to_make = {}
    local water_tile = config.water.water_tile
    for _, tile in pairs(config.water.locations) do
        table.insert(tiles_to_make, {name=water_tile, position=apply_offset(position, tile)})
    end
    surface.set_tiles(tiles_to_make)
end

-- Generates the entities that are in the config
local function spawn_entities(surface, position)
    position = apply_offset(position, config.entities.offset)
    for _, entity in pairs(config.entities.locations) do
        local pos = apply_offset(position, { x=entity[2], y=entity[3] })
        entity = surface.create_entity{name=entity[1], position=pos, force='neutral'}
        if config.entities.protected then protect_entity(entity) end
        entity.operable = config.entities.operable
    end
end

-- Generates an area with no water or entities, no water area is larger
local function spawn_area(surface, position)
    local dr = config.spawn_area.deconstruction_radius
    local tr = config.spawn_area.tile_radius
    local tr2 = tr^2
    local decon_tile = config.spawn_area.deconstruction_tile

    local fr = config.spawn_area.landfill_radius
    local fr2 = fr^2
    local fill_tile = surface.get_tile(position).name

    -- Make sure a non water tile is used for each tile
    if surface.get_tile(position).collides_with('player-layer') then fill_tile = 'landfill' end
    if decon_tile == nil then decon_tile = fill_tile end

    local tiles_to_make = {}
    for x = -fr, fr do -- loop over x
        local x2 = (x+0.5)^2
        for y = -fr, fr do -- loop over y
            local y2 = (y+0.5)^2
            local dst = x2+y2
            local pos = {x=position.x+x, y=position.y+y}
            if dst < tr2 then
                -- If it is inside the decon radius always set the tile
                table.insert(tiles_to_make, {name=decon_tile, position=pos})
            elseif dst < fr2 and surface.get_tile(pos).collides_with('player-layer') then
                -- If it is inside the fill radius only set the tile if it is water
                table.insert(tiles_to_make, {name=fill_tile, position=pos})
            end
        end
    end

    -- Remove entities then set the tiles
    local entities_to_remove = surface.find_entities_filtered{position=position, radius=dr, name='character', invert=true}
    for _, entity in pairs(entities_to_remove) do entity.destroy() end
    surface.set_tiles(tiles_to_make)
end

local function spawn_resource_tiles(surface)
    for k, v in ipairs(config.resource_tiles.resources) do
        if config.resource_tiles.resources[k].enabled then
            if config.resource_tiles.resources[k].natural_generation then
                local tiles  = config.resource_tiles.resources[k].size[1] * config.resource_tiles.resources[k].size[2]
                local amount = config.resource_tiles.resources[k].amount * tiles
                local total_bias = 0
                local biases = {[0] = {[0] = 1}}
                local t = 1

                local function grow(grid, t)
                    local old = {}
                    local new_count = 0
                    
                    for x,_  in pairs(grid) do
                        for y,__ in pairs(_) do
                            table.insert(old, {x, y})
                        end
                    end 
            
                    for _, pos in pairs(old) do
                        local x, y = pos[1], pos[2]
                        local bias = grid[x][y]
                            
                        for dx=-1, 1, 1 do
                            for dy=-1, 1, 1 do
                                local a, b = x + dx, y + dy
                                
                                if (math.random() > 0.9) and (math.abs(a) < config.resource_tiles.resources[k].size[1]) and (math.abs(b) < config.resource_tiles.resources[k].size[2]) then
                                    grid[a] = grid[a] or {}
                        
                                    if not grid[a][b] then
                                        grid[a][b] = 1 - (t / tiles)
                                        new_count = new_count + 1
                                        
                                        if (new_count + t) == tiles then 
                                            return new_count 
                                        end
                                    end
                                end
                            end
                        end
                        
                        return new_count
                    end
                end

                repeat 
                    t = t + grow(biases,t)
                until t >= tiles

                for x, _ in pairs(biases) do
                    for y, bias in pairs(_) do
                        total_bias = total_bias + bias
                    end
                end

                for x, _ in pairs(biases) do
                    for y, bias in pairs(_) do
                        surface.create_entity({name=config.resource_tiles.resources[k].name, amount=amount * (bias / total_bias), position = {config.resource_tiles.resources[k].offset[1] + x, config.resource_tiles.resources[k].offset[2] + y}})
                    end
                end

            else
                for x=config.resource_tiles.resources[k].offset[1], config.resource_tiles.resources[k].offset[1] + config.resource_tiles.resources[k].size[1] do
                    for y=config.resource_tiles.resources[k].offset[2], config.resource_tiles.resources[k].offset[2] + config.resource_tiles.resources[k].size[2] do
                        surface.create_entity({name=config.resource_tiles.resources[k].name, amount=config.resource_tiles.resources[k].amount, position={x, y}})
                    end
                end
            end
        end
    end
end

local function spawn_resource_patches(surface)
    for k, v in ipairs(config.resource_patches.resources) do
        if config.resource_patches.resources[k].enabled then
            for i=1, config.resource_patches.resources[k].num_patches do
                surface.create_entity({name=config.resource_patches.resources[k].name, amount=config.resource_patches.resources[k].amount, position={config.resource_patches.resources[k].offset[1] + config.resource_patches.resources[k].offset_next[1] * (i - 1), config.resource_patches.resources[k].offset[2] + config.resource_patches.resources[k].offset_next[2] * (i - 1)}})
            end
        end
    end
end

local function refill_resource_patches(surface)
    for k, v in ipairs(config.resource_patches.resources) do
        if config.resource_patches.resources[k].enabled then
            for i=1, config.resource_patches.resources[k].num_patches do
                surface.create_entity({name=config.resource_patches.resources[k].name, amount=config.resource_patches.resources[k].amount, position={config.resource_patches.resources[k].offset[1] + config.resource_patches.resources[k].offset_next[1] * (i - 1), config.resource_patches.resources[k].offset[2] + config.resource_patches.resources[k].offset_next[2] * (i - 1)}})
            end
        end
    end
end

-- Only add a event handler if the turrets are enabled
if config.turrets.enabled then
    Event.on_nth_tick(config.turrets.refill_time, function()
        if game.tick < 10 then return end
        spawn_turrets()
    end)
end

-- When the first player joins create the spawn area
Event.add(defines.events.on_player_created, function(event)
    if event.player_index ~= 1 then return end
    local player = game.players[event.player_index]
    local p = {x=0, y=0}
    local s = player.surface
    get_spawn_force()
    spawn_area(s, p)
    if config.pattern.enabled then spawn_pattern(s, p) end
    if config.water.enabled then spawn_water(s, p) end
    if config.afk_belts.enabled then spawn_belts(s, p) end
    if config.turrets.enabled then spawn_turrets() end
    if config.entities.enabled then spawn_entities(s, p) end
    if config.resource_tiles.enabled then spawn_resource_tiles(s) end
    if config.resource_patches.enabled then spawn_resource_patches(s) end
    if config.resource_refill.enabled then refill_resource_patches(s) end
    player.teleport(p, s)
end)

-- Way to access global table
return turrets