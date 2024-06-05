--- rate calc gui
-- @gui rate-calc

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Selection = require 'modules.control.selection' --- @dep modules.control.selection
local RateCalcArea = 'CalcArea'

--- Align an aabb to the grid by expanding it
local function aabb_align_expand(aabb)
    return {
        left_top = {x = math.floor(aabb.left_top.x), y = math.floor(aabb.left_top.y)},
        right_bottom = {x = math.ceil(aabb.right_bottom.x), y = math.ceil(aabb.right_bottom.y)}
    }
end

--- When an area is selected to add protection to the area
Selection.on_selection(RateCalcArea, function(event)
    local area = aabb_align_expand(event.area)
    local player = game.get_player(event.player_index)

    local entities = player.surface.find_entities_filtered{area=area}

    if #entities == 0 then
        player.print('No entity found')
        return
    end

end)


local lookup_button =
Gui.element{
    type = 'button',
    name = Gui.unique_static_name,
    caption = 'lookup'
}:on_click{function(player, _, _)
    if Selection.is_selecting(player, RateCalcArea) then
        Selection.stop(player)

    else
        Selection.start(player, RateCalcArea)
    end
end}

local rate_container =
Gui.element(function(definition, parent)
    local container = Gui.container(parent, definition.name, 200)
    local button_table = Gui.scroll_table(container, 400, 1)
    lookup_button(button_table)

	local disp_table = Gui.scroll_table(container, 400, 4)

	disp_table.add{
        name = Gui.unique_static_name,
        caption = 'Time:',
        type = 'label',
        style = 'heading_1_label'
    }

	disp_table.add{
        name = Gui.unique_static_name,
        caption = '',
        type = 'label',
        style = 'heading_1_label'
    }

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

Gui.left_toolbar_button('item/arithmetic-combinator', {'expcom-rate.main-tooltip'}, rate_container, function(player)
	return Roles.player_allowed(player, 'gui/rate')
end)
