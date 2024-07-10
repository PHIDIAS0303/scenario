--[[-- Gui Module - Personal Logistics
    - Adds a gui to quickly set personal logistics
    @gui Personal Logistics
]]

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local config = require 'config.personal_logistic' --- @dep config.personal-logistic

--[[
stage I - VII
matching the science tech
to set the current requirements
make those as preset and further adjust later
]]

for _, v in pairs(config.pl) do
    v['list'] = {}

    for k2, _ in pairs(v['item']) do
        table.insert(v['list'], k2)
    end
end

--- A vertical flow containing all the main control
-- @element pl_main_set
local pl_main_set =
Gui.element(function(_, parent, name)
    local player = Gui.get_player_from_element(parent)
    local pl_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(pl_set, 480, 6, 'disp')
    local i = 0

    --[[
    local stats = player.force.item_production_statistics
    local research = {}

    for k, v in pairs(config.sci) do
        if stats.get_input_count(k) > 100 then
            research[v] = true
        end
    end
    ]]

    for k, v in pairs(config.pl) do
        disp.add{
            type = 'label',
            name = 'pl_display_g_' .. i,
            caption = 'group ' .. i .. ' - ' .. k,
            style = 'heading_1_label'
        }

		disp.add{
            type = 'checkbox',
            name = 'pl_display_c_' .. i,
            state = false
        }

        disp.add{
            type = 'drop-down',
            name = 'pl_display_m_' .. i,
            items = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
            selected_index = 1
        }

        for j=1, math.min(#v['list'], 3), 1 do
            disp.add{
                type = 'sprite-button',
                name = 'pl_display_m_' .. i .. '_' .. j,
                sprite = 'item/' .. v['item'][v['list'][j] ],
                number = v['item'][v['list'][j] ]['stack'] * v['item'][v['list'][j] ]['ratio']
            }
        end

        i = i + 1
	end

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
