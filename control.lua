require "lib.lib"

------------------------------------------------------------
--- Globals
------------------------------------------------------------
local function set_globals()
    --- platform globals (size + surface)
    storage.platform = storage.platform or {
        warp = {size = dw.platform_size.warp[1]},
        factory = {size = 0, surface = nil},
        mining = {size = {x=0, y=0}, surface = nil},
        power = {size = 0, water = false, surface = nil},
    }

    -- warp informations
    storage.warp = storage.warp or {
        number = 0,
        current = {},
        previous = nil,
        status = defines.warp.awaiting,
        time = game.tick,
    }

    -- timer informations
    storage.timer = storage.timer or { -- timers are in seconds, not ticks
        active = false,
        base = 20 * 60, -- 20min
        warp = nil,
        manual_warp = nil,
    }

    -- vote and player count
    storage.votes = storage.votes or {
        count = 0,
        players = {},
        min_vote = 1,
        players_count = 0,
    }

    -- mapgen
    storage.mapgen = storage.mapgen or {
        defaults = {},
        autoplace_controls = {},
        autoplace_settings = {},
    }

    -- list of teleport locations with status, and both teleporter entity (fom/to)
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
        ['harvester-right-to-surface'] =    {active = false},
        ['surface-to-warp-gate'] =          {active = false},
        ['surface-to-harvester-left'] =     {active = false},
        ['surface-to-harvester-right'] =    {active = false},
    }
    -- timer check for player teleport
    storage.players_last_teleport = storage.players_last_teleport or {}

    -- stairs (chest/loader/pipes) between surfaces
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
    storage.warpgate = storage.warpgate or {
        chest_number = 2,
        type = "warp-gate",
        mobile_chests = {},
        mobile_loaders = {}
    }
    storage.harvesters = storage.harvesters or {
        loaders = 2,
        loader_tier = "harvest-linked-belt",
        pipes_type = "dw-pipe",
        left = {gate = nil, area = nil, size=0, loaders = {}},
        right = {gate = nil, area = nil, size=0, loaders = {}}
    }
    storage.agricultural = storage.agricultural or {
        yumako_towers = {},
        jellynut_towers = {},
    }
end
dw.register_event('on_init', set_globals)
dw.register_event('on_configuration_changed', set_globals)

------------------------------------------------------------
require "scripts.surface-generation"
require "scripts.teleport"
require "scripts.gui"
require "scripts.platforms.surface"
require "scripts.platforms.dimensions"
require "scripts.platforms.harvesters"

require "scripts.scenario.freeplay"
require "scripts.scenario.lab_intro"

require "scripts.warp"
require "scripts.enemies"

require "scripts.entities.warpgate"
require "scripts.entities.rocket_silo"
require "scripts.entities.logistics"
require "scripts.entities.dimension-crane"

require "compatibility.picker-dollies"

--require "scripts.debug"

local function mod_warning()
    if script.active_mods['Repair_Turret'] then
        game.print({"dw-warning.repair-tower-mod"})
    end
end
dw.register_event('on_init', mod_warning)
dw.register_event('on_configuration_changed', mod_warning)