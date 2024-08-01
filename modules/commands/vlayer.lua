--- Adds a virtual layer to store power to save space.
-- @commands Vlayer

local Commands = require 'expcore.commands' --- @dep expcore.commands
require 'config.expcore.command_general_parse'
local vlayer = require 'modules.control.vlayer'

local function personal_battery_recharge(player, amount)
    if vlayer.get_statistics()['energy_sustained'] == 0 then
        return Commands.error('vlayer need to be running to get this command work')
    end

    local armor = player.get_inventory(defines.inventory.character_armor)[1].grid

    for i=1, #armor.equipment do
        local target = math.floor(armor.equipment[i].max_energy * amount)

        if armor.equipment[i].energy < target then
            local energy_required = math.min(math.floor(target - armor.equipment[i].energy), vlayer.get_statistics()['energy_storage'])
            armor.equipment[i].energy = armor.equipment[i].energy + energy_required
            vlayer.energy_changed(- energy_required)
        end
    end
end

Commands.new_command('personal-battery-recharge', 'Recharge Player Battery upto a portion with vlayer')
:add_param('amount', 'number-range', 0.2, 1)
:register(function(player, amount)
    personal_battery_recharge(player, amount)

    return Commands.success
end)

Commands.new_command('vlayer-info', 'Vlayer Info')
:register(function(_)
    local c = vlayer.get_circuits()

    for k, v in pairs(c) do
        Commands.print(v .. ' : ' .. k)
    end
end)

return personal_battery_recharge
