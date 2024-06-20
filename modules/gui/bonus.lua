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
    tooltip = {'bonus.display-cmms-tooltip'},
    style = 'heading_1_label'
}:style{
    width = 100
}

local bonus_gui_display_cmms_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_cmms_slider',
    caption = '0',
    value = config.player_bonus['character_mining_speed_modifier'].value,
    maximum_value = config.player_bonus['character_mining_speed_modifier'].max,
    value_step = 0.25,
    discrete_values = false,
    style = 'notched_slider'
}:style{
    width = 200
}

local bonus_gui_display_cmms_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_cmms_count',
    text = '0',
    numeric = true,
    allow_decimal = true,
    allow_negative = false
}:style{
    width = 60
}

--- Display label for the character, running speed
-- @element bonus_gui_display_crs
local bonus_gui_display_crs =
Gui.element{
    type = 'label',
    name = 'bonus_display_crs',
    caption = {'bonus.display-crs'},
    tooltip = {'bonus.display-crs-tooltip'},
    style = 'heading_1_label'
}:style{
    width = 100
}

local bonus_gui_display_crs_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_crs_slider',
    caption = '0',
    value = config.player_bonus['character_running_speed_modifier'].value,
    maximum_value = config.player_bonus['character_running_speed_modifier'].max,
    value_step = 0.25,
    discrete_values = false,
    style = 'notched_slider'
}:style{
    width = 200
}

local bonus_gui_display_crs_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_crs_count',
    text = '0',
    numeric = true,
    allow_decimal = true,
    allow_negative = false
}:style{
    width = 60
}

--- Display label for the character, crafting speed
-- @element bonus_gui_display_ccs
local bonus_gui_display_ccs =
Gui.element{
    type = 'label',
    name = 'bonus_display_ccs',
    caption = {'bonus.display-ccs'},
    tooltip = {'bonus.display-ccs-tooltip'},
    style = 'heading_1_label'
}:style{
    width = 100
}

local bonus_gui_display_ccs_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_ccs_slider',
    caption = '0',
    value = config.player_bonus['character_crafting_speed_modifier'].value,
    maximum_value = config.player_bonus['character_crafting_speed_modifier'].max,
    value_step = 0.5,
    discrete_values = false,
    style = 'notched_slider'
}:style{
    width = 200
}

local bonus_gui_display_ccs_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_ccs_count',
    text = '0',
    numeric = true,
    allow_decimal = true,
    allow_negative = false
}:style{
    width = 60
}

--- Display label for the character, inventory slots bonus
-- @element bonus_gui_display_cisb
local bonus_gui_display_cisb =
Gui.element{
    type = 'label',
    name = 'bonus_display_cisb',
    caption = {'bonus.display-cisb'},
    tooltip = {'bonus.display-cisb-tooltip'},
    style = 'heading_1_label'
}:style{
    width = 100
}

local bonus_gui_display_cisb_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_cisb_slider',
    caption = '0',
    value = config.player_bonus['character_inventory_slots_bonus'].value,
    maximum_value = config.player_bonus['character_inventory_slots_bonus'].max,
    value_step = 10,
    discrete_values = true,
    style = 'notched_slider'
}:style{
    width = 200
}

local bonus_gui_display_cisb_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_cisb_count',
    text = '0',
    numeric = true,
    allow_decimal = false,
    allow_negative = false
}:style{
    width = 60
}

--- Display label for the character, inventory slots bonus
-- @element bonus_gui_display_chb
local bonus_gui_display_chb =
Gui.element{
    type = 'label',
    name = 'bonus_display_chb',
    caption = {'bonus.display-chb'},
    tooltip = {'bonus.display-chb-tooltip'},
    style = 'heading_1_label'
}:style{
    width = 100
}

local bonus_gui_display_chb_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_chb_slider',
    caption = '0',
    value = config.player_bonus['character_health_bonus'].value,
    maximum_value = config.player_bonus['character_health_bonus'].max,
    value_step = 50,
    discrete_values = true,
    style = 'notched_slider'
}:style{
    width = 200
}

local bonus_gui_display_chb_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_chb_count',
    text = '0',
    numeric = true,
    allow_decimal = false,
    allow_negative = false
}:style{
    width = 60
}

--- The main container for the bonus gui
-- @element bonus_container
bonus_container =
Gui.element(function(definition, parent)
    -- local player = Gui.get_player_from_element(parent)
    local container = Gui.container(parent, definition.name, 320)
    local scroll = Gui.scroll_table(container, 480, 3, 'bonus_st_1')

    bonus_gui_display_cmms(scroll)
    bonus_gui_display_cmms_slider(scroll)
    bonus_gui_display_cmms_count(scroll)

    bonus_gui_display_crs(scroll)
    bonus_gui_display_crs_slider(scroll)
    bonus_gui_display_crs_count(scroll)

    bonus_gui_display_ccs(scroll)
    bonus_gui_display_ccs_slider(scroll)
    bonus_gui_display_ccs_count(scroll)

    bonus_gui_display_cisb(scroll)
    bonus_gui_display_cisb_slider(scroll)
    bonus_gui_display_cisb_count(scroll)

    bonus_gui_display_chb(scroll)
    bonus_gui_display_chb_slider(scroll)
    bonus_gui_display_chb_count(scroll)

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

--- Button on the top flow used to toggle the task list container
-- @element toggle_left_element
Gui.left_toolbar_button('item/exoskeleton-equipment', {'bonus.main-tooltip'}, bonus_container, function(player)
	return Roles.player_allowed(player, 'gui/bonus')
end)
