--[[-- Gui Module - Personal Logistics
    - Adds a gui to quickly set personal logistics
    @gui Personal Logistics
]]

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local config = require 'config.personal_logistic' --- @dep config.personal-logistic

--- A vertical flow containing all the main control
-- @element pl_main_set
local pl_main_set =
Gui.element(function(_, parent, name)
    local pl_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(pl_set, 480, 2, 'disp')

    disp.add{
        type = 'label',
        name = 'pl_display_c_0',
        caption = 'category name',
        style = 'heading_1_label'
    }

    disp.add{
        type = 'label',
        name = 'pl_display_g_0',
        caption = 'group name',
        style = 'heading_1_label'
    }

    disp.add{
        type = 'label',
        name = 'pl_display_m_0',
        caption = 'multiplier',
        style = 'heading_1_label'
    }

    return pl_set
end)

--- The main container for the personal logistics gui
-- @element pl_container
local pl_container =
Gui.element(function(definition, parent)
    local container = Gui.container(parent, definition.name, 480)

    pl_main_set(container, 'pl_st_1')

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

--- Button on the top flow used to toggle the task list container
-- @element toggle_left_element
Gui.left_toolbar_button('entity/logistic-robot', 'Personal Logistics', pl_container, function(player)
	return Roles.player_allowed(player, 'gui/personal-logistic')
end)
