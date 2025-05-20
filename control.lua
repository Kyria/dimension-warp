require "lib.lib"

------------------------------------------------------------
--- Globals
------------------------------------------------------------
local function set_globals()
    --- platform globals
    storage.platform = storage.platform or {
        warp = {size = 8},
        factory = {size = 0, surface=nil},
        mining = {size = {x=0, y=0}, surface=nil},
        power = {size = 0, surface=nil},
    }
    storage.warp = storage.warp or {
        number = 0,
        current = {},
        previous = nil,
        status = defines.warp.awaiting,
    }
    storage.timer = { -- timers are in seconds, not ticks
        active = false,
        base = 20 * 60, -- 20min
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
    storage.stairs = storage.stairs or {
        chest_type = {from = "dw-chest", to="dw-chest"},
        pipes_type = "dw-pipe",
        chest_number = 2,
        loader_tier = "dw-stair-loader",
        chest_pairs = {},
        chest_loader_pairs = {surface={}, produstia={}, smeltus={}, electria={}},
        pipe_pairs = {},
    }
end
dw.register_event('on_init', set_globals)

------------------------------------------------------------
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
