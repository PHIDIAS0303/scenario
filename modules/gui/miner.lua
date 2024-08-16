---- Production Data
-- @gui Production

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Event = require 'utils.event' --- @dep utils.event
local Roles = require 'expcore.roles' --- @dep expcore.roles

local mining_container

local data_1 =
Gui.element{
    type = 'drop-down',
    name = 'mining_0_direction',
    items = {'img=hint_arrow_up', 'img=hint_arrow_down', 'img=hint_arrow_right', 'img=hint_arrow_left'},
    selected_index = 1
}:style{
    width = 160,
    horizontal_align = 'left'
}

local data_2 =
Gui.element{
    type = 'button',
    name = 'mining_0_apply',
    caption = {'mining.apply'},
    tooltip = {'mining.apply-tooltip'}
}:style{
    width = 160
}:on_click(function(player, _, _)
    if player.cursor_stack and player.cursor_stack.valid_for_read then
        if player.cursor_stack.type == 'blueprint' and player.cursor_stack.is_blueprint_setup() then
            -- do something
        end
    end
end)

--- A vertical flow containing all the control
-- @element production_control_set
local production_control_set =
Gui.element(function(_, parent, name)
    local production_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(production_set, 320, 2, 'disp')

    data_1(disp)
    data_2(disp)

    return production_set
end)

mining_container =
Gui.element(function(definition, parent)
    local container = Gui.container(parent, definition.name, 320)
    Gui.header(container, {'mining.main-tooltip'}, '', true)

    production_control_set(container, 'production_st_1')

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

Gui.left_toolbar_button('entity/assembling-machine-3', {'mining.main-tooltip'}, mining_container, function(player)
	return Roles.player_allowed(player, 'gui/mining')
end)
