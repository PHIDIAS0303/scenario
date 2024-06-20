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
    gui_display_width = {
        label = 80,
        slider = 200,
        count = 80
    },
    player_bonus = {
        ['character_mining_speed_modifier'] = {
            value = 2,
            max = 4,
            scale = 0.25,
            cost = 10
        },
        ['character_running_speed_modifier'] = {
            value = 1.5,
            max = 3,
            scale = 0.25,
            cost = 20
        },
        ['character_crafting_speed_modifier'] = {
            value = 5,
            max = 10,
            scale = 0.5,
            cost = 10
        },
        ['character_inventory_slots_bonus'] = {
            value = 80,
            max = 120,
            scale = 10,
            cost = 1
        },
        ['character_health_bonus'] = {
            value = 200,
            max = 500,
            scale = 50,
            cost = 0.01
        },
        ['character_reach_distance_bonus'] = {
            value = 10,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['character_resource_reach_distance_bonus'] = {
            value = 10,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['character_build_distance_bonus'] = {
            value = 10,
            max = 20,
            scale = 1,
            cost = 1
        },
        --[[
        ['character_item_pickup_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['character_loot_pickup_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['character_item_drop_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost = 1
        }
        ]]
    },
    force_bonus = {
        ['character_mining_speed_modifier'] = {
            value = 2,
            max = 4,
            scale = 0.25,
            cost = 10
        },
        ['character_running_speed_modifier'] = {
            value = 1.5,
            max = 3,
            scale = 0.25,
            cost = 20
        },
        ['character_crafting_speed_modifier'] = {
            value = 5,
            max = 10,
            scale = 0.5,
            cost = 10
        },
        ['character_inventory_slots_bonus'] = {
            value = 80,
            max = 120,
            scale = 10,
            cost = 1
        },
        ['character_health_bonus'] = {
            value = 200,
            max = 500,
            scale = 50,
            cost = 0.01
        },
        ['character_reach_distance_bonus'] = {
            value = 10,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['character_resource_reach_distance_bonus'] = {
            value = 10,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['character_build_distance_bonus'] = {
            value = 10,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['worker_robots_speed_modifier'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost = 1
        },
        ['worker_robots_battery_modifier'] = {
            value = 1,
            max = 1,
            scale = 1,
            cost = 1
        },
        ['worker_robots_storage_bonus'] = {
            value = 1,
            max = 1,
            scale = 1,
            cost = 1
        },
        ['following_robots_lifetime_modifier'] = {
            value = 1,
            max = 1,
            scale = 1,
            cost = 1
        },
        --[[
        ['character_item_pickup_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['character_loot_pickup_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['character_item_drop_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost = 1
        },
        ['character_trash_slot_count'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost = 1
        },
        ['mining_drill_productivity_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost = 1
        },
        ['train_braking_force_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost = 1
        },
        ['laboratory_speed_modifier'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost = 1
        },
        ['laboratory_productivity_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost = 1
        },
        ['inserter_stack_size_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost = 1
        },
        ['stack_inserter_capacity_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost = 1
        },
        ['artillery_range_modifier'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost = 1
        }
        ]]
    },
    surface_bonus = {
        ['solar_power_multiplier'] = {
            value = 0,
            max = 1000,
            scale = 1,
            cost = 1
        }
    }
}
