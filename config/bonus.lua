--- Lists all bonuses which can be used, name followed by min max
-- @config Bonuses

return {
    -- level of player bonus for lower roles, 1 level is 10 %
    --[[
    Total point is something like 200
    point is given by role.
    so below will be not able to see
    then do like crafting speed is 2:1 (1 = 0.5x speed)
    running speed is something like 1:10
    blah blah ...
    and limit maximum...

    work with vlayer, virtual power source blah blah...
    ]]
    player_bonus_level = 1,
    player_bonus = {
        {
            name = 'character_mining_speed_modifier',
            enabled = true,
            value = 2
        },
        {
            name = 'character_running_speed_modifier',
            enabled = true,
            value = 1.5
        },
        {
            name = 'character_crafting_speed_modifier',
            enabled = true,
            value = 5
        },
        {
            name = 'character_inventory_slots_bonus',
            enabled = true,
            value = 100
        },
        {
            name = 'character_health_bonus',
            enabled = true,
            value = 200
        },
        --[[
        {
            name = 'character_reach_distance_bonus',
            enabled = true,
            value = 10
        },
        {
            name = 'character_resource_reach_distance_bonus',
            enabled = true,
            value = 10
        },
        {
            name = 'character_build_distance_bonus',
            enabled = true,
            value = 10
        },
        {
            name = 'character_item_pickup_distance_bonus',
            enabled = false,
            value = 0
        },
        {
            name = 'character_loot_pickup_distance_bonus',
            enabled = false,
            value = 0
        },
        {
            name = 'character_item_drop_distance_bonus',
            enabled = false,
            value = 5
        }
        ]]
    },
    force_bonus = {
        {
            name = 'manual_mining_speed_modifier',
            enabled = false,
            value = 2
        },
        {
            name = 'character_running_speed_modifier',
            enabled = false,
            value = 1
        },
        {
            name = 'character_crafting_speed_modifier',
            enabled = false,
            value = 5
        },
        {
            name = 'character_inventory_slots_bonus',
            enabled = false,
            value = 100
        },
        {
            name = 'character_health_bonus',
            enabled = false,
            value = 200
        },
        --[[
        {
            name = 'character_reach_distance_bonus',
            enabled = false,
            value = 10
        },
        {
            name = 'character_resource_reach_distance_bonus',
            enabled = false,
            value = 10
        },
        {
            name = 'character_build_distance_bonus',
            enabled = false,
            value = 10
        },
        {
            name = 'character_item_pickup_distance_bonus',
            enabled = false,
            value = 0
        },
        {
            name = 'character_loot_pickup_distance_bonus',
            enabled = false,
            value = 0
        },
        {
            name = 'character_item_drop_distance_bonus',
            enabled = false,
            value = 5
        },
        ]]
        {
            name = 'worker_robots_speed_modifier',
            enabled = false,
            value = 1.3
        },
        {
            name = 'worker_robots_battery_modifier',
            enabled = true,
            value = 1
        },
        {
            name = 'worker_robots_storage_bonus',
            enabled = true,
            value = 1
        },
        {
            name = 'following_robots_lifetime_modifier',
            enabled = true,
            value = 1
        },
        {
            name = 'character_trash_slot_count',
            enabled = false,
            value = 20
        },
        {
            name = 'mining_drill_productivity_bonus',
            enabled = false,
            value = 0
        },
        {
            name = 'train_braking_force_bonus',
            enabled = false,
            value = 0
        },
        {
            name = 'laboratory_speed_modifier',
            enabled = false,
            value = 0
        },
        {
            name = 'laboratory_productivity_bonus',
            enabled = false,
            value = 0
        },
        {
            name = 'inserter_stack_size_bonus',
            enabled = false,
            value = 0
        },
        {
            name = 'stack_inserter_capacity_bonus',
            enabled = false,
            value = 0
        },
        {
            name = 'artillery_range_modifier',
            enabled = false,
            value = 0
        }
    },
    surface_bonus = {
        {
            name = 'solar_power_multiplier',
            enabled = false,
            value = 0
        }
    }
}
