require "lib.lib"

dw.register_event('on_init', function()
    storage.platform = storage.platform or {
        warp = {size = 8},
        factory = {size = 8, surface=nil},
        mining = {size = 8, surface=nil},
        power = {size = 8, surface=nil},
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
    storage.mapgen = storage.mapgen or {
        defaults = {},
        autoplace_controls = {}
    }
    storage.teleporter = storage.teleporter or {
        ['warp-to-factory'] =               {active = false},
        ['factory-to-warp'] =               {active = false},
        ['mining-to-factory'] =             {active = false},
        ['factory-to-mining'] =             {active = false},
        ['power-to-mining'] =               {active = false},
        ['mining-to-power'] =               {active = false},
        ['nauvis-gate'] =                   {active = false},
        ['warp-gate-to-surface'] =          {active = false},
        ['harvester-left-to-surface'] =     {active = false},
        ['harvester-top-to-surface'] =      {active = false},
        ['harvester-right-to-surface'] =    {active = false},
        ['surface-to-warp-gate'] =          {active = false},
        ['surface-to-harvester-left'] =     {active = false},
        ['surface-to-harvester-top'] =      {active = false},
        ['surface-to-harvester-right'] =    {active = false},
    }
    storage.players_last_teleport = storage.players_last_teleport or {}
end)

require "scripts.surface"
require "scripts.teleport"
require "scripts.gui"
require "scripts.platform"
require "scripts.dimensions"

require "scripts.freeplay"
require "scripts.lab_intro"
require "scripts.warp"

require "scripts.rocket_silo"

require "scripts.debug"

-- on_event("factory-rotate", function(event)
--     local player = game.get_player(event.player_index)
--     local entity = player.selected
--     if not entity or entity.type == "XXX" then return end
--     -- action
-- end