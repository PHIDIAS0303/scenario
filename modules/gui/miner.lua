---- Production Data
-- @gui Production

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Event = require 'utils.event' --- @dep utils.event
local Roles = require 'expcore.roles' --- @dep expcore.roles
local Selection = require 'modules.control.selection' --- @dep modules.control.selection
local SelectionMiningArea = 'MiningArea'

--- align an aabb to the grid by expanding it
local function aabb_align_expand(aabb)
    return {
        left_top = {
            x = math.floor(aabb.left_top.x),
            y = math.floor(aabb.left_top.y)
        },
        right_bottom = {
            x = math.ceil(aabb.right_bottom.x),
            y = math.ceil(aabb.right_bottom.y)
        }
    }
end

local mining_container

--- when an area is selected to add protection to the area
Selection.on_selection(SelectionMiningArea, function(event)
    local area = aabb_align_expand(event.area)
    local player = game.get_player(event.player_index)
    local frame = Gui.get_left_element(player, mining_container)
    local disp = frame.container['mining_st_1'].disp.table
end)

local data_1 =
Gui.element{
    type = 'drop-down',
    name = 'mining_0_direction',
    items = {'[img=utility/hint_arrow_up]', '[img=utility/hint_arrow_down]', '[img=utility/hint_arrow_right]', '[img=utility/hint_arrow_left]'},
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
    if not player.cursor_stack then
        player.print({'mining.apply-error'})
        return
    end

    if not player.cursor_stack.valid_for_read then
        player.print({'mining.apply-error'})
        return
    end

    if player.cursor_stack.type ~= 'blueprint' then
        player.print({'mining.apply-error'})
        return
    end

    if not player.cursor_stack.is_blueprint_setup() then
        player.print({'mining.apply-error'})
        return
    end

    if not player.cursor_stack.blueprint_snap_to_grid then
        player.print({'mining.apply-error'})
        return
    end

    if Selection.is_selecting(player, SelectionMiningArea) then
        Selection.stop(player)
    else
        Selection.start(player, SelectionMiningArea)
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

    production_control_set(container, 'mining_st_1')

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

Gui.left_toolbar_button('entity/electric-mining-drill', {'mining.main-tooltip'}, mining_container, function(player)
	return Roles.player_allowed(player, 'gui/mining')
end)
