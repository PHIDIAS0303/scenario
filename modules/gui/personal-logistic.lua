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

--- A vertical flow containing all the main control
-- @element pl_main_set
local pl_main_set =
Gui.element(function(_, parent, name)
    local pl_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(pl_set, 480, 6, 'disp')
    local i = 0

    --[[
    local player = Gui.get_player_from_element(parent)
    local stats = player.force.item_production_statistics
    local research = {}

    for k, v in pairs(config.sci) do
        if stats.get_input_count(k) > 100 then
            research[v] = true
        end
    end
    ]]

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

    for j=1, 3, 1 do
        disp.add{
            type = 'label',
            name = 'pl_display_m_0_' .. j,
            caption = 'item ' .. j,
            style = 'heading_1_label'
        }
    end

    for k, v in pairs(config.pl) do
        disp.add{
            type = 'label',
            name = 'pl_display_c_' .. i,
            caption = 'group ' .. i .. ' - ' .. k,
            style = 'heading_1_label'
        }

        local gn = {}

        for l=1, #v['group'], 1 do
            gn[i] = i
        end

        disp.add{
            type = 'drop-down',
            name = 'pl_display_g_' .. i,
            items = gn,
            selected_index = 1
        }

        disp.add{
            type = 'drop-down',
            name = 'pl_display_m_' .. i,
            items = {0, 1, 2, 3, 4, 5, 6},
            selected_index = 1
        }

        for j=1, math.min(3, #v['group'][1]), 1 do
            local nj = v['group'][1][j]
            local vnj = v['item'][nj]

            disp.add{
                type = 'sprite-button',
                name = 'pl_display_m_' .. i .. '_' .. j,
                sprite = 'item/' .. vnj['name'],
                number = vnj['stack'] * vnj['ratio']
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
