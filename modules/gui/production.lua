---- Production Data
-- @gui Production

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Event = require 'utils.event' --- @dep utils.event
local Roles = require 'expcore.roles' --- @dep expcore.roles
local config = require 'config.production' --- @dep config.production

local elem_filter = {{filter='type', type='resource'}}

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

--- A vertical flow containing all the production data
-- @element production_data_set
local production_data_set =
Gui.element(function(_, parent, name)
    local production_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(production_set, 360, 3, 'disp')

    for i=1, config.row do
        disp.add{
            name = 'production_data_' .. i .. '_0',
            type = 'choose-elem-button',
            elem_type = 'entity',
            elem_filters = elem_filter,
            style = 'slot_button'
        }

        disp.add{
            name = 'production_data_' .. i .. '_11',
            type = 'label',
            caption = '+',
            style = 'heading_1_label'
        }

        disp.add{
            name = 'production_data_' .. i .. '_12',
            type = 'label',
            caption = '0',
            style = 'heading_1_label'
        }

        disp.add{
            name = 'production_data_' .. i .. '_21',
            type = 'label',
            caption = '-',
            style = 'heading_1_label'
        }

        disp.add{
            name = 'production_data_' .. i .. '_22',
            type = 'label',
            caption = '0',
            style = 'heading_1_label'
        }

        disp.add{
            name = 'production_data_' .. i .. '_31',
            type = 'label',
            caption = '=',
            style = 'heading_1_label'
        }

        disp.add{
            name = 'production_data_' .. i .. '_32',
            type = 'label',
            caption = '0',
            style = 'heading_1_label'
        }
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
