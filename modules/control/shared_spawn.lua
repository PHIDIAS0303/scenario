--[[-- Control Module - shared spawn
    - a shared base of individual spawn
    @control shared spawn
]]

local Global = require 'utils.global' --- @dep utils.global
local Event = require 'utils.event' --- @dep utils.event
local Commands = require 'expcore.commands' --- @dep expcore.commands
local config = require 'config.shared_spawn' --- @dep config.vlayer

local shared_spawn = {}
local shared_spawn_data = {
    base = {},
    shared_base = {}
}

Global.register(shared_spawn_data, function(tbl)
    shared_spawn_data = tbl
end)

function shared_spawn.base_create(player, location)
    for _, v in pairs(shared_spawn_data.shared_base) do
        if v.player[player.name] then
            return
        end
    end

    table.insert(shared_spawn_data.base, {location = location, player = {player.name}})

    local tiles_to_make = {}

    for x=-config.deconstruction_radius, config.deconstruction_radius do
        for y=-config.deconstruction_radius, config.deconstruction_radius do
            if math.max(math.abs(x), math.abs(y)) > config.base_radius then
                table.insert(tiles_to_make, {name=config.deconstruction_tile, position={x=location.x + x, y=location.y + y}})

            else
                table.insert(tiles_to_make, {name=config.base_tile, position={x=location.x + x, y=location.y + y}})
            end
        end
    end

    for x=-4, 4 do
        for y=config.base_radius, config.deconstruction_radius do
            table.insert(tiles_to_make, {name=config.base_tile, position={x=location.x + x, y=location.y + y}})
        end

        for y=-config.deconstruction_radius, -config.base_radius do
            table.insert(tiles_to_make, {name=config.base_tile, position={x=location.x + x, y=location.y + y}})
        end
    end

    -- Remove entities then set the tiles
    local entities_to_remove = player.surface.find_entities_filtered{position=location, radius=config.deconstruction_radius, name='character', invert=true}

    for _, entity in pairs(entities_to_remove) do
        entity.destroy()
    end

    player.surface.set_tiles(tiles_to_make)

    if config.resource_tiles.enabled then
        for _, v in ipairs(config.resource_tiles.resources) do
            if v.enabled then
                local pos_x = location.x + v.offset[1]
                local pos_y = location.y + v.offset[2]

                for x=pos_x, pos_x + v.size[1] do
                    for y=pos_y, pos_y + v.size[2] do
                        player.surface.create_entity({name=v.name, amount=v.amount, position={x=x, y=y}})
                    end
                end
            end
        end
    end

    if config.resource_patches.enabled then
        for _, v in ipairs(config.resource_patches.resources) do
            if v.enabled then
                local pos_x = location.x + v.offset[1] - math.floor(v.offset_next[1] / 2)
                local pos_y = location.y + v.offset[2] - math.floor(v.offset_next[2] / 2)

                for i=1, v.num_patches do
                    player.surface.create_entity({name=v.name, amount=v.amount, position={x=pos_x + v.offset_next[1] * (i - 1), y=pos_y + v.offset_next[2] * (i - 1)}})
                end
            end
        end
    end

    player.force.chart(player.surface, {{x=location.x - config.deconstruction_radius - 64, y=location.y - config.deconstruction_radius - 64}, {x=location.x + config.deconstruction_radius + 64, y=location.y + config.deconstruction_radius + 64}})
    player.teleport(location)
end

Commands.new_command('create-base-individual-spawn', 'Create a individual spawn for the shared base')
:register(function(player)
    if #shared_spawn_data.shared_base == 0 then
        shared_spawn.base_create(player, {x=-480, y=-480})

    else
        local pos_x
        local pos_y
        local x_pos = {32, -32, 32, -32}
        local y_pos = {32, 32, -32, -32}

        for _, v in pairs(shared_spawn_data.shared_base) do
            local base = shared_spawn_data.shared_base[math.floor(math.random(1, #shared_spawn_data.shared_base))]

            for _, v2 in pairs(shared_spawn_data.shared_base) do
                for i=1, 4 do
                    pos_x = math.ceil((base.location.x + math.random(15, 20) * x_pos[i]) / 32) * 32
                    pos_y = math.ceil((base.location.y + math.random(15, 20) * y_pos[i]) / 32) * 32

                    if (v2.location.x < base.location.x) and (pos_x < v2.location.x) then
                        if (v2.location.y < base.location.y) and (pos_y < v2.location.y) then
                            shared_spawn.base_create(player, {x=pos_x, y=pos_y})
                            return
                        end
                    end
                end
            end
        end
    end
end)

return shared_spawn
