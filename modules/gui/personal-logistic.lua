--[[-- Gui Module - Personal Logistics
    - Adds a gui to quickly set personal logistics
    @gui Personal Logistics
]]

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Event = require 'utils.event' --- @dep utils.event
local format_number = require('util').format_number --- @dep util
local config = require 'config.personal_logistic' --- @dep config.personal-logistic

--[[
stage I - VII
matching the science tech
to set the current requirements
make those as preset and further adjust later
]]

local pl_1a =
Gui.element{
    type = 'label',
    name = 'Group A - Belt',
    caption = '0',
    style = 'heading_1_label'
}

local pl_1b =
Gui.element{
    type = 'checkbox',
    name = Gui.unique_static_name,
    state = true
}

local pl_1c =
Gui.element{
    type = 'sprite-button',
    name = Gui.unique_static_name,
    sprite = 'item/express-transport-belt',
    number = 300
}

local pl_1d =
Gui.element{
    type = 'sprite-button',
    name = Gui.unique_static_name,
    sprite = 'item/express-transport-belt',
    number = 100
}

local pl_1e =
Gui.element{
    type = 'sprite-button',
    name = Gui.unique_static_name,
    sprite = 'item/express-transport-belt',
    number = 50
}

--- A vertical flow containing all the main control
-- @element pl_main_set
local pl_main_set =
Gui.element(function(_, parent, name)
    local pl_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(pl_set, 360, 5, 'disp')

    pl_1a(disp)
    pl_1b(disp)
    pl_1c(disp)
    pl_1d(disp)
    pl_1e(disp)

    return pl_set
end)

--- The main container for the personal logistics gui
-- @element pl_container
local pl_container =
Gui.element(function(definition, parent)
    local container = Gui.container(parent, definition.name, 320)

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
