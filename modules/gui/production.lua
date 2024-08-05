---- Production Data
-- @gui Production

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Event = require 'utils.event' --- @dep utils.event
local Roles = require 'expcore.roles' --- @dep expcore.roles
local config = require 'config.production' --- @dep config.production
local format_number = require('util').format_number --- @dep util

local elem_filter = {{filter='type', type='item'}}

local precision = {
    [1] = defines.flow_precision_index.five_seconds,
    [2] = defines.flow_precision_index.one_minute,
    [3] = defines.flow_precision_index.ten_minutes,
    [4] = defines.flow_precision_index.one_hour,
    [5] = defines.flow_precision_index.ten_hours
}

local font_color = {
    [1] = {
        r = 0.3,
        g = 1,
        b = 0.3
    },
    [2] = {
        r = 1,
        g = 0.3,
        b = 0.3
    }
}

local production_time_scale =
Gui.element{
    type = 'drop-down',
    name = Gui.unique_static_name,
    items = {'5s', '1m', '10m', '1h', '10h'},
    selected_index = 3
}:style{
    width = 96
}

--- A vertical flow containing all the production control
-- @element production_control_set
local production_control_set =
Gui.element(function(_, parent, name)
    local production_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(production_set, 208, 2, 'disp')

    production_time_scale(disp)

    return production_set
end)

--- Display group
-- @element production_data_group
local production_data_group =
Gui.element(function(_definition, parent, i)
    local item = parent.add{
        type = 'choose-elem-button',
        name = 'production_' .. i .. '_e',
        elem_type = 'item',
        elem_filters = elem_filter,
        style = 'slot_button'
    }
    item.style.width = 64

    local data_set = parent.add{type='flow', direction='vertical', name='production_' .. i .. '_0s'}
    local disp = Gui.scroll_table(data_set, 144, 2, 'disp')

    local data_1s = disp.add{
        type = 'label',
        name = 'production_' .. i .. '_1s',
        caption = '+',
        style = 'heading_1_label',
    }
    data_1s.style.width = 16
    data_1s.style.horizontal_align = 'left'
    data_1s.style.font_color = font_color[1]

    local data_1c = disp.add{
        type = 'label',
        name = 'production_' .. i .. '_1c',
        caption = '0',
        style = 'heading_1_label',
    }
    data_1c.style.width = 128
    data_1c.style.horizontal_align = 'right'
    data_1c.style.font_color = font_color[1]

    local data_2s = disp.add{
        type = 'label',
        name = 'production_' .. i .. '_2s',
        caption = '-',
        style = 'heading_1_label',
    }
    data_2s.style.width = 16
    data_2s.style.horizontal_align = 'left'
    data_2s.style.font_color = font_color[2]

    local data_2c = disp.add{
        type = 'label',
        name = 'production_' .. i .. '_2c',
        caption = '0',
        style = 'heading_1_label',
    }
    data_2c.style.width = 128
    data_2c.style.horizontal_align = 'right'
    data_2c.style.font_color = font_color[2]

    local data_3s = disp.add{
        type = 'label',
        name = 'production_' .. i .. '_3s',
        caption = '=',
        style = 'heading_1_label',
    }
    data_3s.style.width = 16
    data_3s.style.horizontal_align = 'left'

    local data_3c = disp.add{
        type = 'label',
        name = 'production_' .. i .. '_3c',
        caption = '0',
        style = 'heading_1_label',
    }
    data_3c.style.width = 128
    data_3c.style.horizontal_align = 'right'

    return data_set
end)

--- A vertical flow containing all the production data
-- @element production_data_set
local production_data_set =
Gui.element(function(_, parent, name)
    local production_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(production_set, 208, 2, 'disp')

    for i=1, config.row do
        production_data_group(disp, i)
    end

    return production_set
end)

local production_container =
Gui.element(function(definition, parent)
    local container = Gui.container(parent, definition.name, 208)
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

Event.on_nth_tick(60, function()
    for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, production_container)
        local stat = player.force.item_production_statistics
        local precision_value = precision[frame.container['production_st_1'].disp.table[production_time_scale.name].selected_index]
        local table = frame.container['production_st_2'].disp.table

        for i=1, config.row do
            local item = table['production_' .. i .. '_e'].elem_value

            if item then
                local add = math.floor(stat.get_flow_count{name=item, input=true, precision_index=precision_value, count=false} / 6) / 10
                local minus = math.floor(stat.get_flow_count{name=item, input=false, precision_index=precision_value, count=false} / 6) / 10
                local table_row = table['production_' .. i .. '_0s'].disp.table

                table_row['production_' .. i .. '_1c'].caption = format_number(add)
                table_row['production_' .. i .. '_2c'].caption = format_number(minus)
                table_row['production_' .. i .. '_3c'].caption = format_number(add - minus)
            end
        end
    end
end)
