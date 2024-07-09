local Global = require 'utils.global' --- @dep utils.global
local Commands = require 'expcore.commands' --- @dep expcore.commands
local res = require 'modules.gui.research' --- @dep expcore.commands

local research = {}
Global.register(research, function(tbl)
    research = tbl
end)

Commands.new_command('auto-research', 'Automatically queue up research')
:add_alias('ares')
:register(function(player)
    research.res_queue_enable = not research.res_queue_enable

    if research.res_queue_enable then
        res.res_queue(player.force)
    end

    game.print{'expcom-res.res', player.name, research.res_queue_enable}
    return Commands.success
end)
