--[[-- Gui Module - Personal Logistics
    - Adds a gui to quickly set personal logistics
    @gui Personal Logistics
]]

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Roles = require 'expcore.roles' --- @dep expcore.roles
local PlayerData = require 'expcore.player_data' --- @dep expcore.player_data
local config = require 'config.personal_logistic' --- @dep config.personal-logistic
-- local pl = require 'modules.data.personal-logistic'

--[[
local pl_data = PlayerData.Settings:combine('PersonalLogistic')
pl_data:set_metadata{
    permission = 'gui/personal-logistic',
    stringify = function(value)
        if not value then
            return 'No logitstics set'
        end

        local count = 0

        for _ in pairs(value) do
            count = count + 1
        end

        return count .. ' logitstics set'
    end
}

--- Loads your logistics preset
pl_data:on_load(function(player_name, pld)
    if not pld then
        pld = config[player_name]
    end

    if not pld then
        return
    end

    local player = game.players[player_name]
    local c = player.clear_personal_logistic_slot
    local s = player.set_personal_logistic_slot

    for k, v in pairs(pld) do
        if v then
            c(k)
            s()
        end
    end
end)
]]

--- A vertical flow containing all the main control
-- @element pl_main_set
local pl_main_set =
Gui.element(function(_, parent, name)
    local pl_set = parent.add{type='flow', direction='vertical', name=name}
    local disp = Gui.scroll_table(pl_set, 480, 2, 'disp')

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
