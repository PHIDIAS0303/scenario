--- Settings for shared spawn
-- @config shared spawn

return {
    deconstruction_radius = 80,
    base_radius = 72,
    deconstruction_tile = 'water',
    base_tile = 'landfill',
    resource_tiles = {
        enabled = true,
        resources = {
            {
                enabled = true,
                name = 'iron-ore',
                amount = 5000,
                size = {26, 27},
                offset = {-48,-32}
            },
            {
                enabled = true,
                name = 'copper-ore',
                amount = 5000,
                size = {26, 27},
                offset = {-48, 0}
            },
            {
                enabled = true,
                name = 'stone',
                amount = 5000,
                size = {26, 27},
                offset = {-48, 32}
            },
            {
                enabled = true,
                name = 'coal',
                amount = 5000,
                size = {26, 27},
                offset = {-48, -64}
            },
            {
                enabled = false,
                name = 'uranium-ore',
                amount = 5000,
                size = {26, 27},
                offset = {-48, -96}
            }
        }
    },
    resource_patches = {
        enabled = true,
        resources = {
            {
                enabled = true,
                name = 'crude-oil',
                num_patches = 4,
                amount = 5000000,
                offset = {-56, -12},
                offset_next = {0, 6}
            }
        }
    },
}
