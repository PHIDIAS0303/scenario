--[[-- Commands Module - Set Automatic Train
    - Adds a command that set all train back to automatic
    @commands Set Automatic Train
]]

local Commands = require 'expcore.commands' --- @dep expcore.commands
require 'config.expcore.command_general_parse'
local format_number = require('util').format_number

local train = {}

function train.manual(player)
    local count = 0

    for _, v in pairs(player.force.get_trains()) do
        if v.manual_mode then
            count = count + 1
            v.manual_mode = false
        end
    end

    game.print{'expcom-train.manual-result', player.name, format_number(count)}
end

Commands.new_command('set-trains-to-automatic', {'expcom-train.description'}, 'Set All Trains to Automatic')
:register(function(player)
    train.manual(player)

    return Commands.success
end)

return train
