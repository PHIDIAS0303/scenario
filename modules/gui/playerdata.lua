---- module pd
-- @addon pd

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Event = require 'utils.event' --- @dep utils.event
local PlayerData = require 'expcore.player_data' --- @dep expcore.player_data
local format_time = _C.format_time --- @dep expcore.common
local format_number = require('util').format_number --- @dep util

local pd_container
local pd_disp_n = {

}

pd_container =
Gui.element(function(event_trigger, parent)
    local container = Gui.container(parent, event_trigger, 400)
    local scroll_table_1 = Gui.scroll_table(container, 400, 2, 'pd_st_1')
    local player_list = {}

    for _, player in pairs(game.connected_players) do
        table.insert(player_list, player.name)
    end

    scroll_table_1.add{
        type = 'drop-down',
        name = 'pd_display_1p',
        items = player_list,
        selected_index = 0
    }

    scroll_table_1.add{
        type = 'button',
        name = 'pd_display_1b',
        caption = 'Update',
        style = 'button'
    }

    local scroll_table_2 = Gui.scroll_table(container, 400, 4, 'pd_st_2')
    local label

    for _, name in pairs(PlayerData.Statistics.metadata.display_order) do
        label =
        Gui.element{
            name = 'pd_display_' .. name .. '_t',
            type = 'label',
            caption = {'exp-statistics.' .. name}
        }:style{
            maximal_width = 150
        }

        label(scroll_table_2)

        if name == 'Playtime' or name == 'AfkTime' then
            label =
            Gui.element{
                name = 'pd_display_' .. name .. '_d',
                type = 'label',
                caption = '0 m'
            }:style{
                maximal_width = 120
            }
        else
            label =
            Gui.element{
                name = 'pd_display_' .. name .. '_d',
                type = 'label',
                caption = '0'
            }:style{
                maximal_width = 120
            }
        end

        label(scroll_table_2)
    end

    return container.parent
end)
:add_to_left_flow()

Gui.left_toolbar_button('item/power-armor-mk2', 'Player Data GUI', pd_container, function(player)
	return Roles.player_allowed(player, 'gui/playerdata')
end)

local function gui_player_list_update()
    local player_list = {}

    for _, player in pairs(game.connected_players) do
        table.insert(player_list, player.name)
    end

    for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, pd_container)
        frame.container['pd_st_1'].table['pd_display_1p'].items = player_list
    end
end

local function gui_player_data_update(player)
    local frame = Gui.get_left_element(player, pd_container)

    for _, name in pairs(PlayerData.Statistics.metadata.display_order) do
        if name == 'Playtime' or name == 'AfkTime' then
            frame.container['pd_st_2'].table['pd_display_' .. name .. '_d'].caption = format_time((PlayerData.Statistics[name]:get(player.name) or 0) * 3600, {hours=true, minutes=true, seconds=true, time=true, string=true})
        else
            frame.container['pd_st_2'].table['pd_display_' .. name .. '_d'].caption = format_number(PlayerData.Statistics[name]:get(player.name) or 0)
        end
    end
end

Event.add(defines.events.on_player_joined_game, function(_)
    gui_player_list_update()
end)

Event.add(defines.events.on_player_left_game, function(_)
    gui_player_list_update()
end)

Event.add(defines.events.on_gui_elem_changed, function(event)
    if event.element.name == 'pd_display_1p' then
        gui_player_data_update(game.players[event.player_index])
    end
end)

Event.add(defines.events.on_gui_click, function(event)
    if event.element.name == 'pd_display_1b' then
        gui_player_data_update(game.players[event.player_index])
    end
end)
