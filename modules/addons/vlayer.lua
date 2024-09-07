--- Adds a virtual layer to store power to save space.
-- @commands Vlayer

local Commands = require 'expcore.commands' --- @dep expcore.commands
require 'config.expcore.command_general_parse'
local vlayer = require 'modules.control.vlayer'

local v = {}

function v.pbr(player)
    if vlayer.get_statistics()['energy_sustained'] == 0 then
        player.print({'vlayer.pbr-not-running'})
        return
    end

    local armor = player.get_inventory(defines.inventory.character_armor)[1].grid

    for i=1, #armor.equipment do
        local target = math.floor(armor.equipment[i].max_energy)

        if armor.equipment[i].energy < target then
            local energy_required = math.min(math.floor(target - armor.equipment[i].energy), vlayer.get_statistics()['energy_storage'])
            armor.equipment[i].energy = armor.equipment[i].energy + energy_required
            vlayer.energy_changed(- energy_required)
        end
    end
end

Commands.new_command('personal-battery-recharge', {'vlayer.description-pbr'})
:register(function(player)
    v.pbr(player)

    return Commands.success
end)

Commands.new_command('vlayer-info', {'vlayer.description-vi'})
:register(function(_)
    local c = vlayer.get_circuits()

    for ck, cv in pairs(c) do
        Commands.print(cv .. ' : ' .. ck)
    end
end)

return v
