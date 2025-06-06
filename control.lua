require "lib.lib"

------------------------------------------------------------
--- Globals
------------------------------------------------------------
local function set_globals()
    --- platform globals (size + surface)
    storage.platform = storage.platform or {
        warp = {size = dw.platform_size.warp[1]},
        factory = {size = 0, surface=nil},
        mining = {size = {x=0, y=0}, surface=nil},
        power = {size = 0, surface=nil},
    }
    --- warp informations
    storage.warp = storage.warp or {
        number = 0,
        current = {},
        previous = nil,
        status = defines.warp.awaiting,
        time = game.tick,
    }
    --- timer informations
    storage.timer = { -- timers are in seconds, not ticks
        active = false,
        base = 20 * 60, -- 20min
        warp = nil,
        manual_warp = nil,
    }
    --- vote and player count
    storage.votes = storage.votes or {
        count = 0,
        players = {},
        min_vote = 1,
        players_count = 0,
    }
    --- mapgen
    storage.mapgen = storage.mapgen or {
        defaults = {},
        autoplace_controls = {}
    }
    --- list of teleport locations with status, and both teleporter entity (from/to)
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
    --- timer check for player teleport
    storage.players_last_teleport = storage.players_last_teleport or {}
    --- stairs (chest/loader/pipes) between surfaces
    storage.stairs = storage.stairs or {
        chest_number = 2,
        chest_type = {input = "dw-chest", output="dw-chest"},
        loader_tier = "dw-stair-loader",
        pipes_type = "dw-pipe",
        chest_pairs = {},
        pipe_pairs = {},
        chest_loader_pairs = {gate={}, surface={}, produstia={}, smeltus={}, electria={}},
    }
    -- base global pollution value
    storage.pollution = storage.pollution or 1

    -- warp gates / harvester gate level
    storage.warpgate = {
        chest_number = 2,
        type = "warp-gate",
        mobile_chests = {},
        mobile_loaders = {}
    }
    storage.harvesters = {
        energ_level = 1

    }
end
dw.register_event('on_init', set_globals)

------------------------------------------------------------
require "scripts.surface"
require "scripts.teleport"
require "scripts.gui"
require "scripts.platform"
require "scripts.dimensions"
require "scripts.warpgate"

require "scripts.freeplay"
require "scripts.lab_intro"
require "scripts.warp"

require "scripts.enemies"
require "scripts.rocket_silo"

require "scripts.debug"
