--- Lists all bonuses which can be used, name followed by min max
-- @config Bonuses

return {
    --[[
    Base point is equal to the amount of standard value in each parameter.

            CMMS    CRS     CCS     CISB    CHB     CRDB
    STD     20      60      20      20      12      10
    =       

    MAX     40      150     50      60      48      50
    =       398
    ]]
    pts = {
        base = 142
    },
    gui_display_width = {
        half = 180,
        label = 80,
        slider = 200,
        count = 80
    },
    player_bonus = {
        ['character_mining_speed_modifier'] = {
            value = 2,
            max = 4,
            scale = 0.5,
            cost_scale = 1,
            cost = 10,
            is_percentage = true
        },
        ['character_running_speed_modifier'] = {
            value = 1.5,
            max = 3,
            scale = 0.25,
            cost_scale = 1,
            cost = 40,
            is_percentage = true
        },
        ['character_crafting_speed_modifier'] = {
            value = 5,
            max = 10,
            scale = 0.5,
            cost_scale = 1,
            cost = 4,
            is_percentage = true
        },
        ['character_inventory_slots_bonus'] = {
            value = 100,
            max = 150,
            scale = 10,
            cost_scale = 10,
            cost = 2,
            is_percentage = false
        },
        ['character_health_bonus'] = {
            value = 200,
            max = 400,
            scale = 50,
            cost_scale = 50,
            cost = 3,
            is_percentage = false
        },
        ['character_reach_distance_bonus'] = {
            value = 10,
            max = 25,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false,
            combined_bonus = {
                'character_resource_reach_distance_bonus',
                'character_build_distance_bonus'
            }
        },
        --[[
        ['character_item_pickup_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['character_loot_pickup_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['character_item_drop_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        }
        ]]
    },
    force_bonus = {
        --[[
        ['character_mining_speed_modifier'] = {
            value = 0,
            max = 4,
            scale = 0.5,
            cost_scale = 1,
            cost = 10,
            is_percentage = true
        },
        ['character_running_speed_modifier'] = {
            value = 0,
            max = 3,
            scale = 0.25,
            cost_scale = 1,
            cost = 40,
            is_percentage = true
        },
        ['character_crafting_speed_modifier'] = {
            value = 0,
            max = 10,
            scale = 0.5,
            cost_scale = 1,
            cost = 4,
            is_percentage = true
        },
        ['character_inventory_slots_bonus'] = {
            value = 0,
            max = 150,
            scale = 10,
            cost_scale = 100,
            cost = 2,
            is_percentage = false
        },
        ['character_health_bonus'] = {
            value = 0,
            max = 400,
            scale = 50,
            cost = 3,
            is_percentage = false
        },
        ['character_reach_distance_bonus'] = {
            value = 0,
            max = 25,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false,
            combined_bonus = {
                'character_resource_reach_distance_bonus',
                'character_build_distance_bonus'
            }
        },
        ['worker_robots_speed_modifier'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ]]
        ['worker_robots_battery_modifier'] = {
            value = 1,
            max = 1,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['worker_robots_storage_bonus'] = {
            value = 1,
            max = 1,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['following_robots_lifetime_modifier'] = {
            value = 1,
            max = 1,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        --[[
        ['character_item_pickup_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['character_loot_pickup_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['character_item_drop_distance_bonus'] = {
            value = 0,
            max = 20,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['character_trash_slot_count'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['mining_drill_productivity_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['train_braking_force_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['laboratory_speed_modifier'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['laboratory_productivity_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['inserter_stack_size_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['stack_inserter_capacity_bonus'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        },
        ['artillery_range_modifier'] = {
            value = 0,
            max = 0,
            scale = 0,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        }
        ]]
    },
    surface_bonus = {
        --[[
        ['solar_power_multiplier'] = {
            value = 1,
            max = 1000,
            scale = 1,
            cost_scale = 1,
            cost = 1,
            is_percentage = false
        }
        ]]
    }
}
