--[[-- Commands Module - Home
    - Adds a command that allows setting and teleporting to your home position
    @commands Home
]]

local Commands = require 'expcore.commands' --- @dep expcore.commands
local Global = require 'utils.global' --- @dep utils.global
require 'config.expcore.command_general_parse'

local home = {}

local homes = {}
Global.register(homes, function(tbl)
    homes = tbl
end)

local function teleport(player, position)
    local surface = player.surface
    local pos = surface.find_non_colliding_position('character', position, 32, 1)
    if not position then return false end
    if player.driving then player.driving = false end -- kicks a player out a vehicle if in one
    player.teleport(pos, surface)
    return true
end

local function floor_pos(position)
    return {
        x=math.floor(position.x),
        y=math.floor(position.y)
    }
end

function home.home(player)
    local h = homes[player.index]

    if not h or not h[1] then
        player.print{'expcom-home.no-home'}
        return
    end

    local rtn = floor_pos(player.position)
    teleport(player, h[1])
    h[2] = rtn

    player.print{'expcom-home.return-set', rtn.x, rtn.y}
end

function home.home_set(player)
    local h = homes[player.index]

    if not h then
        h = {}
        homes[player.index] = h
    end

    local pos = floor_pos(player.position)
    h[1] = pos

    player.print{'expcom-home.home-set', pos.x, pos.y}
end

function home.home_get(player)
    local h = homes[player.index]

    if not h or not h[1] then
        player.print{'expcom-home.no-home'}
        return
    end

    local pos = h[1]

    player.print{'expcom-home.home-get', pos.x, pos.y}
end

function home.home_return(player)
    local h = homes[player.index]

    if not h or not h[2] then
        player.print{'expcom-home.no-return'}
        return
    end

    local rtn = floor_pos(player.position)
    teleport(player, h[2])
    h[2] = rtn

    player.print{'expcom-home.return-set', rtn.x, rtn.y}
end

--- Teleports you to your home location
-- @command home
Commands.new_command('home', {'expcom-home.description-home'})
:register(function(player)
    home.home(player)
end)

--- Sets your home location to your current position
-- @command home-set
Commands.new_command('home-set', {'expcom-home.description-home-set'})
:register(function(player)
    home.home_set(player)
end)

--- Returns your current home location
-- @command home-get
Commands.new_command('home-get', {'expcom-home.description-home-get'})
:register(function(player)
    home.home_get(player)
end)

--- Teleports you to previous location
-- @command return
Commands.new_command('return', {'expcom-home.description-return'})
:register(function(player)
    home.home_return(player)
end)

return home
