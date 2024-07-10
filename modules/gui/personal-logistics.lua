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

--- The main container for the personal logistics gui
-- @element pl_container
local pl_container =
Gui.element(function(definition, parent)
    local player = Gui.get_player_from_element(parent)
    local container = Gui.container(parent, definition.name, 320)

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

--- Button on the top flow used to toggle the task list container
-- @element toggle_left_element
Gui.left_toolbar_button('entity/solar-panel', 'Personal Logistics', pl_container, function(player)
	return Roles.player_allowed(player, 'gui/vlayer')
end)
