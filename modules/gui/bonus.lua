--[[-- Gui Module - Bonus
    @gui Bonus
    @alias bonus_container
]]

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Event = require 'utils.event' --- @dep utils.event
local config = require 'config.bonus' --- @dep config.bonus

local bonus_container

--- Display label for the character, manual mining speed
-- @element bonus_gui_display_cmms
local bonus_gui_display_cmms =
Gui.element{
    type = 'label',
    name = 'bonus_display_cmms',
    caption = {'bonus.display-cmms'},
    style = 'heading_1_label'
}:style{
    width = 200
}

local bonus_gui_display_cmms_count =
Gui.element{
    type = 'slider',
    name = 'bonus_display_cmms_count',
    caption = '0'
}:style{
    width = 120
}


--- Display label for the character, running speed
-- @element bonus_gui_display_crs
local bonus_gui_display_crs =
Gui.element{
    type = 'label',
    name = 'bonus_display_crs',
    caption = {'bonus.display-crs'},
    style = 'heading_1_label'
}:style{
    width = 200
}

local bonus_gui_display_crs_count =
Gui.element{
    type = 'slider',
    name = 'bonus_display_crs_count',
    caption = '0'
}:style{
    width = 120
}

--- Display label for the character, crafting speed
-- @element bonus_gui_display_ccs
local bonus_gui_display_ccs =
Gui.element{
    type = 'label',
    name = 'bonus_display_ccs',
    caption = {'bonus.display-ccs'},
    style = 'heading_1_label'
}:style{
    width = 200
}

local bonus_gui_display_ccs_count =
Gui.element{
    type = 'slider',
    name = 'bonus_display_ccs_count',
    caption = '0'
}:style{
    width = 120
}


--- The main container for the bonus gui
-- @element bonus_container
bonus_container =
Gui.element(function(definition, parent)
    local player = Gui.get_player_from_element(parent)
    local container = Gui.container(parent, definition.name, 320)
    local scroll = Gui.scroll_table(container, 480, 2, 'bonus_st_1')

    bonus_gui_display_cmms(scroll)
    bonus_gui_display_cmms_count(scroll)
    bonus_gui_display_crs(scroll)
    bonus_gui_display_crs_count(scroll)
    bonus_gui_display_ccs(scroll)
    bonus_gui_display_ccs_count(scroll)

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

--- Button on the top flow used to toggle the task list container
-- @element toggle_left_element
Gui.left_toolbar_button('item/exoskeleton-equipment', {'bonus.main-tooltip'}, bonus_container, function(player)
	return Roles.player_allowed(player, 'gui/bonus')
end)
