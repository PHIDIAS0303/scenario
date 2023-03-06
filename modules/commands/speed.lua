--[[-- Commands Module - Set game speed
    - Adds a command that allows changing game speed
    @commands Set game speed
]]

local Commands = require 'expcore.commands' --- @dep expcore.commands
require 'config.expcore.command_general_parse'

Commands.new_command('speed', 'Set game speed')
:add_param('amount', 'number-range', 0.2, 1)
:set_flag('admin_only')
:register(function(_, amount)
    game.speed = string.format("%.3f", amount)
    game.print{'expcom-speed.result', string.format("%.3f", amount)}
    return Commands.success
end)
