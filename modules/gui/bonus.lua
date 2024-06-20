--[[-- Gui Module - Bonus
    @gui Bonus
    @alias bonus_container
]]

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Event = require 'utils.event' --- @dep utils.event
local config = require 'config.bonus' --- @dep config.bonus

local bonus_container

--- Control label for the bonus points available
-- @element bonus_gui_control_pts_a
local bonus_gui_control_pts_a =
Gui.element{
    type = 'label',
    name = 'bonus_control_pts_a',
    caption = {'bonus.control-pts-a'},
    style = 'heading_1_label'
}:style{
    width = config.gui_display_width['label'] * 2
}

local bonus_gui_control_pts_a_count =
Gui.element{
    type = 'label',
    name = 'bonus_control_pts_a_count',
    caption = config.pts.base,
    style = 'heading_1_label'
}:style{
    width = config.gui_display_width['label'] * 2
}

--- Control label for the bonus points needed
-- @element bonus_gui_control_pts_n
local bonus_gui_control_pts_n =
Gui.element{
    type = 'label',
    name = 'bonus_control_pts_n',
    caption = {'bonus.control-pts-n'},
    style = 'heading_1_label'
}:style{
    width = config.gui_display_width['label'] * 2
}

local bonus_gui_control_pts_n_count =
Gui.element{
    type = 'label',
    name = 'bonus_control_pts_n_count',
    caption = config.pts.base,
    style = 'heading_1_label'
}:style{
    width = config.gui_display_width['label'] * 2
}

--- Control label for the bonus points remaining
-- @element bonus_gui_control_pts_r
local bonus_gui_control_pts_r =
Gui.element{
    type = 'label',
    name = 'bonus_control_pts_r',
    caption = {'bonus.control-pts-r'},
    style = 'heading_1_label'
}:style{
    width = config.gui_display_width['label'] * 2
}

local bonus_gui_control_pts_r_count =
Gui.element{
    type = 'label',
    name = 'bonus_control_pts_r_count',
    caption = '0',
    style = 'heading_1_label'
}:style{
    width = config.gui_display_width['label'] * 2
}

--- A button used for pts calculations
-- @element bonus_gui_control_refresh
local bonus_gui_control_refresh =
Gui.element{
    type = 'button',
    name = Gui.unique_static_name,
    caption = {'bonus.control-refresh'}
}:style{
    width = config.gui_display_width['label'] * 2
}:on_click(function(player, element, _)
    --[[
    ]]
end)

--- A button used for pts apply
-- @element bonus_gui_control_apply
local bonus_gui_control_apply =
Gui.element{
    type = 'button',
    name = Gui.unique_static_name,
    caption = {'bonus.control-apply'}
}:style{
    width = config.gui_display_width['label'] * 2
}:on_click(function(player, element, _)
    --[[
    ]]
end)

--- A vertical flow containing all the bonus control
-- @element bonus_control_set
local bonus_control_set =
Gui.element(function(_, parent, name)
    local bonus_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(bonus_set, 360, 2, 'disp')

    bonus_gui_control_pts_a(disp)
    bonus_gui_control_pts_a_count(disp)

    bonus_gui_control_pts_n(disp)
    bonus_gui_control_pts_n_count(disp)

    bonus_gui_control_pts_r(disp)
    bonus_gui_control_pts_r_count(disp)

    bonus_gui_control_refresh(disp)
    bonus_gui_control_apply(disp)

    return bonus_set
end)

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
    width = config.gui_display_width['label']
}

local bonus_gui_display_cmms_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_cmms_slider',
    value = config.player_bonus['character_mining_speed_modifier'].value,
    maximum_value = config.player_bonus['character_mining_speed_modifier'].max,
    value_step = config.player_bonus['character_mining_speed_modifier'].scale,
    discrete_values = true,
    style = 'notched_slider'
}:style{
    width = config.gui_display_width['slider']
}

local bonus_gui_display_cmms_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_cmms_count',
    text = config.player_bonus['character_mining_speed_modifier'].value,
    numeric = true,
    allow_decimal = true,
    allow_negative = false
}:style{
    width = config.gui_display_width['count']
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
    width = config.gui_display_width['label']
}

local bonus_gui_display_crs_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_crs_slider',
    value = config.player_bonus['character_running_speed_modifier'].value,
    maximum_value = config.player_bonus['character_running_speed_modifier'].max,
    value_step = config.player_bonus['character_running_speed_modifier'].scale,
    discrete_values = true,
    style = 'notched_slider'
}:style{
    width = config.gui_display_width['slider']
}

local bonus_gui_display_crs_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_crs_count',
    text = config.player_bonus['character_running_speed_modifier'].value,
    numeric = true,
    allow_decimal = true,
    allow_negative = false
}:style{
    width = config.gui_display_width['count']
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
    width = config.gui_display_width['label']
}

local bonus_gui_display_ccs_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_ccs_slider',
    value = config.player_bonus['character_crafting_speed_modifier'].value,
    maximum_value = config.player_bonus['character_crafting_speed_modifier'].max,
    value_step = config.player_bonus['character_crafting_speed_modifier'].scale,
    discrete_values = true,
    style = 'notched_slider'
}:style{
    width = config.gui_display_width['slider']
}

local bonus_gui_display_ccs_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_ccs_count',
    text = config.player_bonus['character_crafting_speed_modifier'].value,
    numeric = true,
    allow_decimal = true,
    allow_negative = false
}:style{
    width = config.gui_display_width['count']
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
    width = config.gui_display_width['label']
}

local bonus_gui_display_cisb_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_cisb_slider',
    value = config.player_bonus['character_inventory_slots_bonus'].value,
    maximum_value = config.player_bonus['character_inventory_slots_bonus'].max,
    value_step = config.player_bonus['character_inventory_slots_bonus'].scale,
    discrete_values = true,
    style = 'notched_slider'
}:style{
    width = config.gui_display_width['slider']
}

local bonus_gui_display_cisb_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_cisb_count',
    text = config.player_bonus['character_inventory_slots_bonus'].value,
    numeric = true,
    allow_decimal = false,
    allow_negative = false
}:style{
    width = config.gui_display_width['count']
}

--- Display label for the character, health bonus
-- @element bonus_gui_display_chb
local bonus_gui_display_chb =
Gui.element{
    type = 'label',
    name = 'bonus_display_chb',
    caption = {'bonus.display-chb'},
    tooltip = {'bonus.display-chb-tooltip'},
    style = 'heading_1_label'
}:style{
    width = config.gui_display_width['label']
}

local bonus_gui_display_chb_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_chb_slider',
    value = config.player_bonus['character_health_bonus'].value,
    maximum_value = config.player_bonus['character_health_bonus'].max,
    value_step = config.player_bonus['character_health_bonus'].scale,
    discrete_values = true,
    style = 'notched_slider'
}:style{
    width = config.gui_display_width['slider']
}

local bonus_gui_display_chb_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_chb_count',
    text = config.player_bonus['character_health_bonus'].value,
    numeric = true,
    allow_decimal = false,
    allow_negative = false
}:style{
    width = config.gui_display_width['count']
}

--- Display label for the character, reach distance bonus
-- @element bonus_gui_display_crdb
local bonus_gui_display_crdb =
Gui.element{
    type = 'label',
    name = 'bonus_display_crdb',
    caption = {'bonus.display-crdb'},
    tooltip = {'bonus.display-crdb-tooltip'},
    style = 'heading_1_label'
}:style{
    width = config.gui_display_width['label']
}

local bonus_gui_display_crdb_slider =
Gui.element{
    type = 'slider',
    name = 'bonus_display_crdb_slider',
    value = config.player_bonus['character_reach_distance_bonus'].value,
    maximum_value = config.player_bonus['character_reach_distance_bonus'].max,
    value_step = config.player_bonus['character_reach_distance_bonus'].scale,
    discrete_values = true,
    style = 'notched_slider'
}:style{
    width = config.gui_display_width['slider']
}

local bonus_gui_display_crdb_count =
Gui.element{
    type = 'textfield',
    name = 'bonus_display_crdb_count',
    text = config.player_bonus['character_reach_distance_bonus'].value,
    numeric = true,
    allow_decimal = false,
    allow_negative = false
}:style{
    width = config.gui_display_width['count']
}

--- A vertical flow containing all the bonus data
-- @element bonus_data_set
local bonus_data_set =
Gui.element(function(_, parent, name)
    local bonus_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(bonus_set, 360, 3, 'disp')

    bonus_gui_display_cmms(disp)
    bonus_gui_display_cmms_slider(disp)
    bonus_gui_display_cmms_count(disp)

    bonus_gui_display_crs(disp)
    bonus_gui_display_crs_slider(disp)
    bonus_gui_display_crs_count(disp)

    bonus_gui_display_ccs(disp)
    bonus_gui_display_ccs_slider(disp)
    bonus_gui_display_ccs_count(disp)

    bonus_gui_display_cisb(disp)
    bonus_gui_display_cisb_slider(disp)
    bonus_gui_display_cisb_count(disp)

    bonus_gui_display_chb(disp)
    bonus_gui_display_chb_slider(disp)
    bonus_gui_display_chb_count(disp)

    bonus_gui_display_crdb(disp)
    bonus_gui_display_crdb_slider(disp)
    bonus_gui_display_crdb_count(disp)

    return bonus_set
end)

--- The main container for the bonus gui
-- @element bonus_container
bonus_container =
Gui.element(function(definition, parent)
    local player = Gui.get_player_from_element(parent)
    local container = Gui.container(parent, definition.name, 320)

    bonus_control_set(container, 'bonus_st_1')
    bonus_data_set(container, 'bonus_st_2')

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

--- Button on the top flow used to toggle the task list container
-- @element toggle_left_element
Gui.left_toolbar_button('item/exoskeleton-equipment', {'bonus.main-tooltip'}, bonus_container, function(player)
	return Roles.player_allowed(player, 'gui/bonus')
end)

Event.add(Roles.events.on_gui_value_changed, function(event)
    local player = game.get_player(event.player_index)
    local frame = Gui.get_left_element(player, bonus_container)
    local table = frame.container['bonus_st_1'].disp.table

    if event.element.name == bonus_gui_display_cmms_slider.name then
        table[bonus_gui_display_cmms_count.name].text = event.element.slider_value
    end
end)

--[[
Event.add(Roles.events.on_gui_text_changed, function(event)
    local player = game.get_player(event.player_index)
    local frame = Gui.get_left_element(player, bonus_container)
    local table = frame.container['bonus_st_1'].table

    if event.element.name == bonus_gui_display_cmms_count.name then
        local nearby = math.floor((tonumber(event.element.text) or 0) / table[bonus_gui_display_cmms_slider.name].value_step)

        if nearby < table[bonus_gui_display_cmms_slider.name].minimum_value then
            table[bonus_gui_display_cmms_slider.name].value = table[bonus_gui_display_cmms_slider.name].minimum_value
            event.element.text = table[bonus_gui_display_cmms_slider.name].minimum_value

        else
            table[bonus_gui_display_cmms_slider.name].value = nearby
        end
    end
end)
]]
