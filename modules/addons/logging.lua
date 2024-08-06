--[[-- Addon Logging
    @addon Logging
]]

local Event = require 'utils.event' --- @dep utils.event
local config = require 'config.logging' --- @dep config.logging
local write_json = _C.write_json

Event.add(defines.events.on_rocket_launched, function(event)
    if config.rocket_launch_display[event.rocket.force.rockets_launched] then
        write_json(config.file_name, {type='rocket_launch', number=event.rocket.force.rockets_launched})
    end
end)

Event.add(defines.events.on_pre_player_died, function(event)
    if event.cause then
        if event.cause.type == 'character' then
            -- pvp
            write_json(config.file_name, {type='player_died', player=game.players[event.player_index].name, name=game.players[event.cause.player.index].name or 'no-cause'})

        else
            -- cause
            write_json(config.file_name, {type='player_died', player=game.players[event.player_index].name, name=event.cause.name or 'no-cause'})
        end

    else
        -- poison damage
        write_json(config.file_name, {type='player_died', player=game.players[event.player_index].name, name='no-cause'})
	end
end)

Event.add(defines.events.on_research_finished, function(event)
    write_json(config.file_name, {type='research', name=string.match(event.research.name, '^(.-)%-%d+$'):gsub('-', ' '), level=event.research.level or 1})
end)

Event.add(defines.events.on_player_joined_game, function(event)
	write_json(config.file_name, {type='join', player=game.players[event.player_index].name})
end)

Event.add(defines.events.on_player_left_game, function(event)
	write_json(config.file_name, {type='leave', player=game.players[event.player_index].name, reason=config.disconnect_reason[event.reason] or 'other'})
end)
