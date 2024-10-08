--- This is the main config file for the role system; file includes defines for roles and role flags and default values
-- @config Roles

local Roles = require 'expcore.roles' --- @dep expcore.roles
local PlayerData = require 'expcore.player_data' --- @dep expcore.player_data
local Statistics = PlayerData.Statistics

--- Role flags that will run when a player changes roles
Roles.define_flag_trigger('is_admin',function(player,state)
    player.admin = state
end)

Roles.define_flag_trigger('is_spectator',function(player,state)
    player.spectator = state
end)

Roles.define_flag_trigger('is_jail',function(player,state)
    if player.character then
        player.character.active = not state
    end
end)

--- Admin Roles
Roles.new_role('System','SYS')
:set_permission_group('Default', true)
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_flag('deconlog-bypass')
:set_allow_all()

Roles.new_role('Senior Administrator','SAdmin')
:set_permission_group('Admin')
:set_custom_color{r=233,g=63,b=233}
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_flag('deconlog-bypass')
:set_parent('Administrator')
:set_allow_all()

Roles.new_role('Administrator','Admin')
:set_permission_group('Admin')
:set_custom_color{r=233,g=63,b=233}
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_flag('deconlog-bypass')
:set_parent('Senior Moderator')
:allow{
    'command/interface',
    'command/debug',
    'command/toggle-cheat-mode',
    'command/research-all',
    'command/connect-all',
	'command/collectdata'
}

Roles.new_role('Senior Moderator','SMod')
:set_permission_group('Mod')
:set_custom_color{r=0,g=170,b=0}
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_flag('deconlog-bypass')
:set_parent('Moderator')
:allow{
    'gui/warp-list/bypass-proximity',
    'gui/warp-list/bypass-cooldown',
    'command/connect-all',
    'command/collectdata'
}

Roles.new_role('Moderator','Mod')
:set_permission_group('Mod')
:set_custom_color{r=0,g=170,b=0}
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_flag('deconlog-bypass')
:set_parent('Trainee Moderator')
:allow{
}

Roles.new_role('Trainee Moderator','Trainee')
:set_permission_group('Mod')
:set_custom_color{r=0,g=170,b=0}
:set_flag('is_admin')
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('deconlog-bypass')
:set_parent('Board Member')
:allow{
    'command/assign-role',
    'command/unassign-role',
    'command/admin-chat',
    'command/admin-marker',
    'command/teleport',
    'command/bring',
    'command/give-warning',
    'command/get-warnings',
    'command/get-reports',
    'command/protect-entity',
    'command/protect-area',
    'command/kick',
    'command/ban',
    'command/search',
    'command/search-amount',
    'command/search-recent',
    'command/search-online',
    'command/pollution-off',
    'command/pollution-clear',
    'command/bot-queue-get',
    'command/bot-queue-set',
    'command/game-speed',
    'command/kill-biters',
    'command/remove-biters',
    'command/toggle-friendly-fire',
    'command/toggle-always-day',
    'gui/playerdata',
    'command/kill/always',
    -- 'command/clear-tag/always',
    'command/go-to-spawn/always',
    'command/clear-reports',
    'command/clear-warnings',
    'command/clear-inventory',
    'command/connect-player'
}

--- Trusted Roles
Roles.new_role('Board Member','Board')
:set_permission_group('Trusted')
:set_custom_color{r=247,g=246,b=54}
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_flag('deconlog-bypass')
:set_parent('Supporter')
:allow{
}

Roles.new_role('Supporter','Sup')
:set_permission_group('Trusted')
:set_custom_color{r=230,g=99,b=34}
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_flag('deconlog-bypass')
:set_parent('Partner')
:allow{
}

Roles.new_role('Partner','Part')
:set_permission_group('Trusted')
:set_custom_color{r=24,g=172,b=188}
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_flag('deconlog-bypass')
:set_parent('Senior Member')
:allow{
}

Roles.new_role('Senior Member','SMem')
:set_permission_group('Trusted')
:set_custom_color{r=24,g=172,b=188}
:set_flag('is_spectator')
:set_flag('report-immune')
:set_flag('instant-respawn')
:set_flag('deconlog-bypass')
:set_parent('Member')
:allow{
    'command/join-message',
    'command/join-message-clear',
    'command/goto',
    'command/jail',
    'command/unjail',
    'command/spectate',
    'command/follow',
    'command/repair'
}

--- Standard User Roles
Roles.new_role('Member','Mem')
:set_permission_group('Trusted')
:set_custom_color{r=24,g=172,b=188}
:set_flag('deconlog-bypass')
:set_parent('Veteran')
:allow{
    'gui/vlayer-edit',
    'gui/rocket-info/toggle-active',
    'gui/rocket-info/remote_launch',
    -- 'command/tag-color',
    'command/set-trains-to-automatic',
    'command/clear-item-on-ground',
    'command/clear-blueprint',
    'command/last-location',
    -- 'command/bonus',
    'gui/bonus',
    'gui/personal-logistic',
    'command/personal-logistic',
    'command/home',
    'command/home-set',
    'command/home-get',
    'command/return',
    'gui/tool/home',
    'command/auto-research',
    'fast-tree-decon'
}

local hours6, hours250 = 6*216000, 250*60
Roles.new_role('Veteran','Vet')
:set_permission_group('Trusted')
:set_custom_color{r=140,g=120,b=200}
:set_flag('deconlog-bypass')
:set_parent('Regular')
:allow{
    'gui/warp-list/add',
    'gui/warp-list/edit',
    'command/artillery-target-remote',
    'command/waterfill',
    'command/save-quickbar',
    'gui/surveillance'
}
:set_auto_assign_condition(function(player)
    if player.online_time >= hours6 then
        return true
    else
        local stats = Statistics:get(player, {})
        local playTime, afkTime, mapCount = stats.Playtime or 0, stats.AfkTime or 0, stats.MapsPlayed or 0
        return playTime - afkTime >= hours250 and mapCount >= 25
    end
end)

local hours1, hours15 = 1*216000, 15*60
Roles.new_role('Regular','Reg')
:set_permission_group('Standard')
:set_custom_color{r=79,g=155,b=163}
:set_flag('deconlog-bypass')
:set_parent('Guest')
:allow{
    'command/kill',
    'command/rainbow',
    'command/go-to-spawn',
    'command/me',
    'command/lawnmower',
    'standard-decon',
    'bypass-entity-protection',
	'bypass-nukeprotect',
    'gui/task-list/add',
    'gui/task-list/edit',
    'command/chat-bot'
}
:set_auto_assign_condition(function(player)
    if player.online_time >= hours1 then
        return true
    else
        local stats = Statistics:get(player, {})
        local playTime, afkTime, mapCount = stats.Playtime or 0, stats.AfkTime or 0, stats.MapsPlayed or 0
        return playTime - afkTime >= hours15 and mapCount >= 5
    end
end)

--- Guest/Default role
local default = Roles.new_role('Guest','')
:set_permission_group('Guest')
:set_custom_color{r=185,g=187,b=160}
:allow{
    -- 'command/tag',
    -- 'command/tag-clear',
    'command/search-help',
    'command/list-roles',
    'command/find-on-map',
    'command/report',
    'command/ratio',
    'command/vlayer-info',
    'command/server-ups',
    'command/save-data',
    'command/preference',
    'command/set-preference',
    'command/connect',
    'gui/player-list',
    'gui/rocket-info',
    'gui/science-info',
    'gui/task-list',
    'gui/warp-list',
    'gui/readme',
    'gui/vlayer',
    'gui/research',
    'gui/autofill',
    'gui/module',
    'gui/landfill',
    'gui/mining',
    'gui/production',
    'gui/tool'
}

--- Jail role
Roles.new_role('Jail')
:set_permission_group('Restricted')
:set_custom_color{r=50,g=50,b=50}
:set_block_auto_assign(true)
:set_flag('defer_role_changes')
:disallow(default.allowed)

--- System defaults which are required to be set
Roles.set_root('System')
Roles.set_default('Guest')

Roles.define_role_order{
    'System', -- Best to keep root at top
    'Senior Administrator',
    'Administrator',
    'Senior Moderator',
    'Moderator',
    'Trainee Moderator',
    'Board Member',
    'Supporter',
    'Partner',
    'Senior Member',
    'Member',
    'Veteran',
    'Regular',
    'Jail',
    'Guest' -- Default must be last if you want to apply restrictions to other roles
}

Roles.override_player_roles{
    ['PHIDIAS0303']={'Senior Administrator'},
    ['majoro']={'Trainee Moderator'},
    ['konohaScarlet_']={'Trainee Moderator'},
    ['hihicome3']={'Trainee Moderator'},
    ['Athenaa']={'Trainee Moderator'},
    ['rongli']={'Trainee Moderator'},
    ['JamesJung']={'Trainee Moderator'},
    ['aldldl']={'Moderator'},
    ['arty714']={'Moderator'},
    ['Cooldude2606']={'Moderator'},
    ['Drahc_pro']={'Moderator'},
    ['mark9064']={'Moderator'},
    ['7h3w1z4rd']={'Moderator'},
    ['FlipHalfling90']={'Moderator'},
    ['hamsterbryan']={'Moderator'},
    ['HunterOfGames']={'Moderator'},
    ['NextIdea']={'Moderator'},
    ['TheKernel32']={'Moderator'},
    ['TheKernel64']={'Moderator'},
    ['tovernaar123']={'Moderator'},
    ['UUBlueFire']={'Moderator'},
    ['AssemblyStorm']={'Moderator'},
    ['banakeg']={'Moderator'},
    ['connormkii']={'Moderator'},
    ['cydes']={'Moderator'},
    ['darklich14']={'Moderator'},
    ['facere']={'Moderator'},
    ['freek18']={'Moderator'},
    ['Gizan']={'Moderator'},
    ['LoicB']={'Moderator'},
    ['M74132']={'Moderator'},
    ['mafisch3']={'Moderator'},
    ['maplesyrup01']={'Moderator'},
    ['ookl']={'Moderator'},
    ['Phoenix27833']={'Moderator'},
    ['porelos']={'Moderator'},
    ['Ruuyji']={'Moderator'},
    ['samy115']={'Moderator'},
    ['SilentLog']={'Moderator'},
    ['Tcheko']={'Moderator'},
    ['thadius856']={'Moderator'},
    ['whoami32']={'Moderator'},
    ['Windbomb']={'Moderator'},
    ['XenoCyber']={'Moderator'}
}
