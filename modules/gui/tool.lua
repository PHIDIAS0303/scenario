--[[-- Gui Module - Tool
    @gui Tool
    @alias tool_container
]]

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Event = require 'utils.event' --- @dep utils.event
local Selection = require 'modules.control.selection' --- @dep modules.control.selection
local format_number = require('util').format_number

local tool_container

local SelectionArtyArea = 'ArtyArea'
local SelectionWaterfillArea = 'WaterfillArea'

--- Arty label
-- @element tool_gui_arty_l
local tool_gui_arty_l =
Gui.element{
    type = 'label',
    name = 'tool_arty_l',
    caption = {'tool.artillery'},
    tooltip = {'tool.artillery-tooltip'},
    style = 'heading_2_label'
}:style{
    width = 160
}

--- Arty button
-- @element tool_gui_arty_b
local tool_gui_arty_b =
Gui.element{
    type = 'button',
    name = 'tool_arty_b',
    caption = {'tool.apply'}
}:style{
    width = 80
}:on_click(function(player, _, _)
    if Selection.is_selecting(player, SelectionArtyArea) then
        Selection.stop(player)

    else
        Selection.start(player, SelectionArtyArea)
        player.print{'tool.entered-area-selection'}
    end
end)

--- Waterfill label
-- @element tool_gui_waterfill_l
local tool_gui_waterfill_l =
Gui.element{
    type = 'label',
    name = 'tool_waterfill_l',
    caption = {'tool.waterfill'},
    tooltip = {'tool.waterfill-tooltip'},
    style = 'heading_2_label'
}:style{
    width = 160
}

--- Waterfill button
-- @element tool_gui_waterfill_b
local tool_gui_waterfill_b =
Gui.element{
    type = 'button',
    name = 'tool_waterfill_b',
    caption = {'tool.apply'}
}:style{
    width = 80
}:on_click(function(player, _, _)
    local inv = player.get_main_inventory()

    if (inv.get_item_count('cliff-explosives')) == 0 then
        return player.print{'tool.waterfill-cliff'}
    end

    if Selection.is_selecting(player, SelectionWaterfillArea) then
        Selection.stop(player)
    else
        Selection.start(player, SelectionWaterfillArea)
        player.print{'tool.entered-area-selection'}
    end
end)

--- Train label
-- @element tool_gui_train_l
local tool_gui_train_l =
Gui.element{
    type = 'label',
    name = 'tool_train_l',
    caption = {'tool.train'},
    tooltip = {'tool.train-tooltip'},
    style = 'heading_2_label'
}:style{
    width = 160
}

--- Train button
-- @element tool_gui_train_b
local tool_gui_train_b =
Gui.element{
    type = 'button',
    name = 'tool_train_b',
    caption = {'tool.apply'}
}:style{
    width = 80
}:on_click(function(player, _, _)
    local count = 0

    for _, v in pairs(player.force.get_trains()) do
        if v.manual_mode then
            count = count + 1
            v.manual_mode = false
        end
    end

    game.print{'tool.train-manual-result', player.name, format_number(count)}
end)

local function tool_perm(player)
    local frame = Gui.get_left_element(player, tool_container)
    local disp = frame.container['tool_st'].disp.table

    if Roles.player_allowed(player, 'gui/tool/artillery-target-remote') then
        disp[tool_gui_arty_l.name].visible = true
        disp[tool_gui_arty_b.name].visible = true

    else
        disp[tool_gui_arty_l.name].visible = false
        disp[tool_gui_arty_b.name].visible = false
    end

    if Roles.player_allowed(player, 'gui/tool/waterfill') then
        disp[tool_gui_waterfill_l.name].visible = true
        disp[tool_gui_waterfill_b.name].visible = true

    else
        disp[tool_gui_waterfill_l.name].visible = false
        disp[tool_gui_waterfill_b.name].visible = false
    end

    if Roles.player_allowed(player, 'gui/tool/set-trains-to-automatic') then
        disp[tool_gui_train_l.name].visible = true
        disp[tool_gui_train_b.name].visible = true

    else
        disp[tool_gui_train_l.name].visible = false
        disp[tool_gui_train_b.name].visible = false
    end
end

--- A vertical flow containing all the tool
-- @element tool_set
local tool_set =
Gui.element(function(_, parent, name)
    local tool_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(tool_set, 240, 2, 'disp')

    tool_gui_arty_l(disp)
    tool_gui_arty_b(disp)
    tool_gui_waterfill_l(disp)
    tool_gui_waterfill_b(disp)
    tool_gui_train_l(disp)
    tool_gui_train_b(disp)

    return tool_set
end)

--- The main container for the tool gui
-- @element tool_container
tool_container =
Gui.element(function(definition, parent)
    local player = Gui.get_player_from_element(parent)
    local container = Gui.container(parent, definition.name, 240)

    tool_set(container, 'tool_st')

    tool_perm(player)

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

--- Button on the top flow used to toggle the tool container
-- @element toggle_left_element
Gui.left_toolbar_button('item/repair-pack', {'tool.main-tooltip'}, tool_container, function(player)
	return Roles.player_allowed(player, 'gui/tool')
end)

Event.add(Roles.events.on_role_assigned, function(event)
    tool_perm(game.players[event.player_index])
end)

Event.add(Roles.events.on_role_unassigned, function(event)
    tool_perm(game.players[event.player_index])
end)
