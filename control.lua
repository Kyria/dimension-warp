require "lib.lib"

dw.register_event('on_init', function()
    storage.platform = storage.platform or {
        warp = {size = 8, center = {0, 0}},
        factory = {size = 8},
        mining = {size = 8},
        energy = {size = 8},
    }
    storage.warp = storage.warp or {
        number = 0,
        current = {},
        previous = nil,
        status = defines.warp.awaiting,
    }
    storage.timer = {
        active = false,
        base = 20 * 60, -- 20min in ticks
        warp = nil,
        manual_warp = nil,
    }
    storage.votes = storage.votes or {
        count = 0,
        players = {},
        min_vote = 1,
        players_count = 0,
    }
    storage.teleporter = storage.teleporter or {}
    storage.teleporter['nauvis'] = storage.teleporter['nauvis'] or {}
    storage.players_last_teleport = storage.players_last_teleport or {}
end)

require "scripts.surface"
require "scripts.teleport"
require "scripts.gui"
require "scripts.platform"

require "scripts.freeplay"
require "scripts.lab_intro"
require "scripts.warp"

require "scripts.debug"