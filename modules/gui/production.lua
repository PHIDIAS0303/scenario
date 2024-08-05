---- Production Data
-- @gui Production

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Event = require 'utils.event' --- @dep utils.event
local Roles = require 'expcore.roles' --- @dep expcore.roles
local config = require 'config.production' --- @dep config.production
local format_number = require('util').format_number --- @dep util

local elem_filter = {{filter='type', type='item'}}

local production_time_scale =
Gui.element{
    type = 'drop-down',
    name = Gui.unique_static_name,
    items = {'1m', '10m', '1h', '10h'},
    selected_index = 2
}:style{
    width = 64
}

--- A vertical flow containing all the production control
-- @element production_control_set
local production_control_set =
Gui.element(function(_, parent, name)
    local production_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(production_set, 360, 2, 'disp')

    production_time_scale(disp)

    return production_set
end)

--- Display group
-- @element production_data_group
local production_data_group =
Gui.element(function(_definition, parent, i)
    local item = parent.add{
        type = 'choose-elem-button',
        name=Gui.unique_static_name,
        elem_type = 'entity',
        elem_filters = elem_filter,
        style = 'slot_button'
    }
    item.style.width = 64

    local data_set = parent.add{type='flow', direction='vertical', name=Gui.unique_static_name}
    local disp = Gui.scroll_table(data_set, 360, 2, 'disp')

    local data_1s = disp.add{
        type = 'label',
        name = Gui.unique_static_name,
        caption = '+',
        style = 'heading_1_label',
    }
    data_1s.style.width = 64

    local data_1c = disp.add{
        type = 'label',
        name = 'production_' .. i .. '_1_count',
        caption = '+',
        style = 'heading_1_label',
    }
    data_1c.style.width = 192

    local data_2s = disp.add{
        type = 'label',
        name = Gui.unique_static_name,
        caption = '-',
        style = 'heading_1_label',
    }
    data_2s.style.width = 64

    local data_2c = disp.add{
        type = 'label',
        name = 'production_' .. i .. '_2_count',
        caption = '+',
        style = 'heading_1_label',
    }
    data_2c.style.width = 192

    local data_3s = disp.add{
        type = 'label',
        name = Gui.unique_static_name,
        caption = '=',
        style = 'heading_1_label',
    }
    data_3s.style.width = 64

    local data_3c = disp.add{
        type = 'label',
        name = 'production_' .. i .. '_3_count',
        caption = '+',
        style = 'heading_1_label',
    }
    data_3c.style.width = 192
end)

--- A vertical flow containing all the production data
-- @element production_data_set
local production_data_set =
Gui.element(function(_, parent, name)
    local production_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(production_set, 360, 2, 'disp')

    for i=1, config.row do
        production_data_group(disp, i)
    end

    return production_set
end)

local production_container =
Gui.element(function(definition, parent)
    local container = Gui.container(parent, definition.name, 320)
    Gui.header(container, {'production.main-tooltip'}, '', true)

    production_control_set(container, 'production_st_1')
    production_data_set(container, 'production_st_2')

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

Gui.left_toolbar_button('entity/assembling-machine-3', {'production.main-tooltip'}, production_container, function(player)
	return Roles.player_allowed(player, 'gui/production')
end)
