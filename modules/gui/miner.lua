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

local direction = {
    [1] = 'defines.direction.north',
    [2] = 'defines.direction.south',
    [3] = 'defines.direction.east',
    [4] = 'defines.direction.west'
}

local blueprint_cache
local mining_container

local function mining_placement(player, position, direction_index)
    blueprint_cache.build_blueprint{surface=player.surface, force=player.force, position=position, direction=direction[direction_index], skip_fog_of_war=true, by_player=player}
end

local function mining_apply(area, direction_index, player)
    local grid = blueprint_cache.blueprint_snap_to_grid
    local entities = blueprint_cache.get_blueprint_entities()

    -- so the starting side is the opposite of the direction

    if direction_index == 1 then
        -- area.right_bottom.y

    elseif direction_index == 2 then
        -- area.left_top.y

    elseif direction_index == 3 then
        for x=area.left_top.x, area.right_bottom.x, grid.x do
            for y=area.left_top.y, area.right_bottom.y, -grid.y do
                mining_placement(player, {x=x, y=y}, direction_index)
            end
        end

    elseif direction_index == 4 then
        for x=area.right_bottom.x, area.left_top.x, -grid.x do
            for y=area.left_top.y, area.right_bottom.y, -grid.y do
                mining_placement(player, {x=x, y=y}, direction_index)
            end
        end
    end
end

local data_1 =
Gui.element{
    type = 'drop-down',
    name = 'mining_direction',
    items = {'[img=utility/hint_arrow_up]', '[img=utility/hint_arrow_down]', '[img=utility/hint_arrow_right]', '[img=utility/hint_arrow_left]'},
    selected_index = 1
}:style{
    width = 240
}

local data_3

local data_2 =
Gui.element{
    type = 'button',
    name = 'mining_cache',
    caption = {'mining.blueprint'},
    tooltip = {'mining.blueprint-tooltip'}
}:style{
    width = 240
}:on_click(function(player, element, _)
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

    blueprint_cache = player.cursor_stack
    element.parent[data_3.name].caption = player.cursor_stack.label
end)

data_3 =
Gui.element{
    type = 'label',
    name = 'mining_cache_name',
    caption = '',
    style = 'heading_1_label'
}:style{
    width = 240
}

--- when an area is selected to add miner to the area
Selection.on_selection(SelectionMiningArea, function(event)
    local area = aabb_align_expand(event.area)
    local player = game.get_player(event.player_index)
    local frame = Gui.get_left_element(player, mining_container)
    local disp = frame.container['mining_st_1'].disp.table
    mining_apply(area, disp[data_1.name].selected_index, player)
end)

local data_4 =
Gui.element{
    type = 'button',
    name = 'mining_apply',
    caption = {'mining.apply'}
}:style{
    width = 240
}:on_click(function(player, _, _)
    if not blueprint_cache then
        player.print({'mining.apply-error'})
        return
    end

    if Selection.is_selecting(player, SelectionMiningArea) then
        Selection.stop(player)

    else
        Selection.start(player, SelectionMiningArea)
    end
end)

--- A vertical flow containing the blueprint
-- @element mining_blueprint_set
local mining_blueprint_set =
Gui.element(function(_, parent, name)
    local mining_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(mining_set, 240, 1, 'disp')

    data_1(disp)
    data_2(disp)
    data_3(disp)

    return mining_set
end)

--- A vertical flow containing the control
-- @element mining_control_set
local mining_control_set =
Gui.element(function(_, parent, name)
    local mining_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(mining_set, 240, 1, 'disp')

    data_4(disp)

    return mining_set
end)

mining_container =
Gui.element(function(definition, parent)
    local container = Gui.container(parent, definition.name, 240)
    Gui.header(container, {'mining.main-tooltip'}, '', true)

    mining_blueprint_set(container, 'mining_st_1')
    mining_control_set(container, 'mining_st_2')

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

Gui.left_toolbar_button('entity/electric-mining-drill', {'mining.main-tooltip'}, mining_container, function(player)
	return Roles.player_allowed(player, 'gui/mining')
end)
