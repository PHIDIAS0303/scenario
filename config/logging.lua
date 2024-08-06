--- Settings for logging
-- @config logging

return {
    file_name = 'ext/logging.out',
    rocket_launch_display = {
        [1] = true,
        [2] = true,
        [5] = true,
        [10] = true,
        [20] = true,
        [50] = true,
        [100] = true,
        [200] = true,
        [500] = true,
        [1000] = true,
        [2000] = true,
        [5000] = true,
        [10000] = true,
        [20000] = true,
        [50000] = true,
        [100000] = true,
        [200000] = true,
        [500000] = true,
        [1000000] = true,
        [2000000] = true,
        [5000000] = true,
        [10000000] = true
    },
    disconnect_reason = {
        [defines.disconnect_reason.quit] = 'quit',
        [defines.disconnect_reason.dropped] = 'dropped',
        [defines.disconnect_reason.reconnect] = 'reconnect',
        [defines.disconnect_reason.wrong_input] = 'wrong input',
        [defines.disconnect_reason.desync_limit_reached] = 'desync limit reached',
        [defines.disconnect_reason.cannot_keep_up] = 'cannot keep up',
        [defines.disconnect_reason.afk] = 'afk',
        [defines.disconnect_reason.kicked] = 'kicked',
        [defines.disconnect_reason.kicked_and_deleted] = 'kicked and deleted',
        [defines.disconnect_reason.banned] = 'banned',
        [defines.disconnect_reason.switching_servers] = 'switching servers'
    }
}
