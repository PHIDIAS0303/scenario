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

for _, v in pairs(config.pl) do
    v['technology'] = {}

    for k2, v2 in pairs(v['item']) do
        local max = math.max(table.unpack(v2['technology']))

        if v['technology'][max] then
            table.insert(v['technology'][max], k2)

        else
            v['technology'][max] = {}
            table.insert(v['technology'][max], k2)
        end
    end
end

--- A vertical flow containing all the main control
-- @element pl_main_set
local pl_main_set =
Gui.element(function(_, parent, name)
    local player = Gui.get_player_from_element(parent)
    local pl_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(pl_set, 400, 6, 'disp')
    local i = 0
    local stats = player.force.item_production_statistics
    local research = {}
    local max_research = 1

    for k, v in pairs(config.sci) do
        if stats.get_input_count(k) > 100 then
            research[v] = true
            max_research = v
        end
    end

    for k, v in pairs(config.pl) do
        disp.add{
            type = 'label',
            name = Gui.unique_static_name,
            caption = 'group ' .. i .. ' - ' .. k,
            style = 'heading_1_label'
        }

		disp.add{
            type = 'checkbox',
            name = Gui.unique_static_name,
            state = false
        }

        disp.add{
            type = 'drop-down',
            name = Gui.unique_static_name,
            items = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
            selected_index = 1
        }

        for j=#v['technology'], 1, -1 do
            if v['technology'][max_research] then
                for l=1, math.min(3, v['technology'][max_research]), 1 do
                    local item = v['item'][v['technology'][max_research][l]]

                    disp.add{
                        type = 'sprite-button',
                        name = Gui.unique_static_name,
                        sprite = 'item/' .. v['technology'][max_research][l],
                        number = item['stack'] * item['ratio']
                    }
                end
            end
        end

        i = i + 1
	end

    return pl_set
end)

--- The main container for the personal logistics gui
-- @element pl_container
local pl_container =
Gui.element(function(definition, parent)
    local container = Gui.container(parent, definition.name, 400)

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
