--- research milestone gui
-- @gui Research

local Gui = require 'expcore.gui' --- @dep expcore.gui
local Global = require 'utils.global' --- @dep utils.global
local Event = require 'utils.event' --- @dep utils.event
local Roles = require 'expcore.roles' --- @dep expcore.roles
local config = require 'config.research' --- @dep config.research
local format_time = _C.format_time --- @dep expcore.common

local resf = {}
local research = {}
Global.register(research, function(tbl)
    research = tbl
end)

research.time = {}
research.res_queue_enable = false

local base_rate = 0
local mi = 1
local res = {}
local res_i = {}
local res_total = 0
local research_time_format = {
    hours=true,
    minutes=true,
    seconds=true,
    time=true,
    string=true
}
local empty_time = format_time(0, {
	hours=true,
	minutes=true,
	seconds=true,
	time=true,
	string=true,
	null=true
})

for k, v in pairs(config.milestone) do
	res_total = res_total + v * 60
	res_i[k] = mi
	research.time[mi] = 0
	res[mi] = {
		name = '[technology=' .. k .. '] ' .. k:gsub('-', ' '),
		prev = res_total,
		prev_disp = format_time(res_total, research_time_format),
	}
	mi = mi + 1
end

local function research_res_n(res_)
	local res_n = 1

	for k, _ in pairs(res_) do
		if research.time[k] == 0 then
			res_n = k - 1
			break
		end
	end

	if research.time[#res_] > 0 then
		if res_n == 1 then
			res_n = #res_
		end
	end

	if res_n < 3 then
		res_n = 3
	end

	return res_n
end

local function research_notification(event)
    local is_inf_res = false

    for k, v in pairs(config.inf_res) do
        if (event.research.name == k) and (event.research.level >= v) then
            is_inf_res = true
        end
    end

    if config.bonus_inventory.enabled then
        if (event.research.force.mining_drill_productivity_bonus * 10) <= (config.bonus_inventory.limit / config.bonus_inventory.rate) then
            event.research.force[config.bonus_inventory.name] = math.floor(event.research.force.mining_drill_productivity_bonus * 10) * config.bonus_inventory.rate
        end
    end

    if is_inf_res then
        if event.research.name == 'mining-productivity-4' and event.research.level > 4 then
            if config.bonus.enabled then
                event.research.force[config.bonus.name] = base_rate + event.research.level * config.bonus.rate
            end

            if config.pollution_ageing_by_research then
                game.map_settings.pollution.ageing = math.min(10, event.research.level / 5)
            end
        end

        if not (event.by_script) then
            game.print{'expcom-res.inf', format_time(game.tick, research_time_format), event.research.name, event.research.level - 1}
        end

    else
        if not (event.by_script) then
            game.print{'expcom-res.msg', format_time(game.tick, research_time_format), event.research.name}
        end
    end
end

function resf.res_queue(event)
    if event.research.force.rockets_launched == 0 or event.research.force.technologies['mining-productivity-4'].level <= 4 then
        return
    end

    local res_q = event.research.research_queue

    if #res_q < config.queue_amount then
        for i=1, config.queue_amount - #res_q do
            event.research.force.add_research(event.research.force.technologies['mining-productivity-4'])

            if not (event.by_script) then
                game.print{'expcom-res.inf-q', event.research.name, event.research.level + i}
            end
        end
    end
end

local function research_queue_logic(event)
    research_notification(event)

    if research.res_queue_enable then
        resf.res_queue(event)
    end
end

Event.add(defines.events.on_research_finished, research_queue_logic)
Event.add(defines.events.on_research_cancelled, research_queue_logic)

local research_container =
Gui.element(function(definition, parent)
    local container = Gui.container(parent, definition.name, 200)
	local scroll_table = Gui.scroll_table(container, 400, 4)

	scroll_table.add{
        name = 'clock_text',
        caption = 'Time:',
        type = 'label',
        style = 'heading_1_label'
    }

	scroll_table.add{
        name = 'clock_text_2',
        caption = '',
        type = 'label',
        style = 'heading_1_label'
    }

	scroll_table.add{
        name = 'clock_text_3',
        caption = '',
        type = 'label',
        style = 'heading_1_label'
    }

    scroll_table.add{
        name = 'clock_display',
        caption = empty_time,
        type = 'label',
        style = 'heading_1_label'
    }

	for i=1, 8 do
        scroll_table.add{
            name = 'research_display_n_' .. i,
            caption = '',
            type = 'label',
            style = 'heading_1_label'
        }

		scroll_table.add{
            name = 'research_display_d_' .. i,
            caption = empty_time,
            type = 'label',
            style = 'heading_1_label'
        }

		scroll_table.add{
            name = 'research_display_p_' .. i,
			caption = '',
            type = 'label',
            style = 'heading_1_label'
        }

		scroll_table.add{
            name = 'research_display_t_' .. i,
            caption = empty_time,
            type = 'label',
            style = 'heading_1_label'
        }
	end

	local res_n = research_res_n(res)

	for j=1, 8 do
		local res_j = res_n + j - 3

		if res[res_j] then
			local res_r = res[res_j]
			scroll_table['research_display_n_' .. j].caption = res_r.name

			if research.time[res_j] < res[res_j].prev then
				scroll_table['research_display_d_' .. j].caption = '-' .. format_time(res[res_j].prev - research.time[res_j], research_time_format)

			else
				scroll_table['research_display_d_' .. j].caption = format_time(research.time[res_j] - res[res_j].prev, research_time_format)
			end

			scroll_table['research_display_p_' .. j].caption = res_r.prev_disp
			scroll_table['research_display_t_' .. j].caption = format_time(research.time[res_j], research_time_format)

		else
			scroll_table['research_display_n_' .. j].caption = ''
			scroll_table['research_display_d_' .. j].caption = ''
			scroll_table['research_display_p_' .. j].caption = ''
			scroll_table['research_display_t_' .. j].caption = ''
		end
	end

    return container.parent
end)
:static_name(Gui.unique_static_name)
:add_to_left_flow()

Gui.left_toolbar_button('item/space-science-pack', {'expcom-res.main-tooltip'}, research_container, function(player)
	return Roles.player_allowed(player, 'gui/research')
end)

Event.add(defines.events.on_research_finished, function(event)
	if event.research.name == nil then
		return
	elseif res_i[event.research.name] == nil then
		return
	end

	local n_i = res_i[event.research.name]
	research.time[n_i] = game.tick

	local res_n = research_res_n(res)
	local res_disp = {}

	for j=1, 8 do
		local res_j = res_n + j - 3
		res_disp[j] = {}

		if res[res_j] then
			local res_r = res[res_j]
			res_disp[j]['n'] = res_r.name

			if research.time[res_j] < res[res_j].prev then
				res_disp[j]['d'] = '-' .. format_time(res[res_j].prev - research.time[res_j], research_time_format)

			else
				res_disp[j]['d'] = format_time(research.time[res_j] - res[res_j].prev, research_time_format)
			end

			res_disp[j]['p'] = res_r.prev_disp
			res_disp[j]['t'] = format_time(research.time[res_j], research_time_format)

		else
			res_disp[j]['n'] = ''
			res_disp[j]['d'] = ''
			res_disp[j]['p'] = ''
			res_disp[j]['t'] = ''
		end
	end

	for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, research_container)

		for j=1, 8 do
			frame.container.scroll.table['research_display_n_' .. j].caption = res_disp[j]['n']
			frame.container.scroll.table['research_display_d_' .. j].caption = res_disp[j]['d']
			frame.container.scroll.table['research_display_p_' .. j].caption = res_disp[j]['p']
			frame.container.scroll.table['research_display_t_' .. j].caption = res_disp[j]['t']
		end
    end
end)

Event.on_nth_tick(60, function()
	local current_time = format_time(game.tick, research_time_format)

	for _, player in pairs(game.connected_players) do
        local frame = Gui.get_left_element(player, research_container)
		frame.container.scroll.table['clock_display'].caption = current_time
    end
end)

return resf
