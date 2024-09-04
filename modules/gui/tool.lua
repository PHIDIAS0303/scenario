--[[-- Gui Module - Tool
    @gui Tool
    @alias tool_container
]]

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles

--- The main container for the tool gui
-- @element tool_container
local tool_container =
Gui.element(function(definition, parent)
    local player = Gui.get_player_from_element(parent)
    local container = Gui.container(parent, definition.name, 320)

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

--- Button on the top flow used to toggle the tool container
-- @element toggle_left_element
Gui.left_toolbar_button('item/repair-pack', {'bonus.main-tooltip'}, tool_container, function(player)
	return Roles.player_allowed(player, 'gui/tool')
end)
