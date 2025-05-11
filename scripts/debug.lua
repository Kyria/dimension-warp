local tech_list = {
    "electrified-ground",
    "warp-generator-1",
    "warp-generator-2",
    "warp-generator-3",
    "warp-generator-4",
    "warp-generator-5",
    "warp-generator-6",
    "warp-platform-size-1",
    "warp-platform-size-2",
    "warp-platform-size-3",
    "warp-platform-size-4",
    "warp-platform-size-5",
    "warp-platform-size-6",
    "warp-platform-size-7",
    "power-platform",
    "mining-platform",
    "factory-platform",
    "factory-platform-upgrade-1",
    "factory-platform-upgrade-2",
    "factory-platform-upgrade-3",
    "factory-platform-upgrade-4",
    "factory-platform-upgrade-5",
    "factory-platform-upgrade-6",
    "factory-platform-upgrade-7",
    "mining-platform-upgrade-1",
    "mining-platform-upgrade-2",
    "mining-platform-upgrade-3",
    "mining-platform-upgrade-4",
    "mining-platform-upgrade-5",
    "mining-platform-upgrade-6",
    "mining-platform-upgrade-7",
    "power-platform-upgrade-1",
    "power-platform-upgrade-2",
    "power-platform-upgrade-3",
    "power-platform-upgrade-4",
    "power-platform-upgrade-5",
    "power-platform-upgrade-6",
    "power-platform-upgrade-7",
    "dimension-harvester-top-1",
    "dimension-harvester-top-2",
    "dimension-harvester-top-3",
    "dimension-harvester-top-4",
    "dimension-harvester-top-5",
    "dimension-harvester-top-6",
    "dimension-harvester-right-1",
    "dimension-harvester-right-2",
    "dimension-harvester-right-3",
    "dimension-harvester-right-4",
    "dimension-harvester-right-5",
    "dimension-harvester-right-6",
    "dimension-harvester-left-1",
    "dimension-harvester-left-2",
    "dimension-harvester-left-3",
    "dimension-harvester-left-4",
    "dimension-harvester-left-5",
    "dimension-harvester-left-6",
}

local function debug_gui(player)
    local frame = dw.gui.get_warp_frame(player)
    local line = frame.add{type = "line"}
    line.style.top_margin = 5
    frame.add{type = "label", caption = "Debug"}
    frame.add{type = "button", name = "give-starter-item", caption = "Items"}
    frame.add{type = "button", name = "trigger-next-warp", caption = "Warp Next"}

    local debugtech = frame.add({type = "flow", name="debug-tech", direction = "horizontal"})
    debugtech.add{type = "drop-down", name = "tech-select", caption = "Tech", items=tech_list}
    debugtech.add{type = "button", name = "debug-tech-grant", caption = "Grant"}
end

local function give_debug_items(player_index)
    local player = game.players[player_index]
    player.insert{name="iron-ore", count=300}
    player.insert{name="copper-ore", count=300}
    player.insert{name="stone-furnace", count=8}
    player.insert{name="coal", count=400}
    player.insert{name="iron-gear-wheel", count=50}
    player.insert{name="electronic-circuit", count=10}
    player.insert{name="transport-belt", count=4}
    player.insert{name="automation-science-pack", count=24}
end

local function grant_tech(player_index)
    local player = game.players[player_index]
    local frame = dw.gui.get_warp_frame(player)
    local tech_dropdown = frame['debug-tech']['tech-select']
    local selected_index = tech_dropdown.selected_index
    if selected_index == 0 then return end

    local selected_tech = tech_dropdown.get_item(selected_index)
    if selected_tech then
        game.forces['player'].technologies[selected_tech].researched = true
    end
end


local function debug_clicked(event)
    if not event.element.valid then return end
    if event.element.name == "trigger-next-warp" then dw.prepare_warp_to_next_surface() end
    if event.element.name == "give-starter-item" then give_debug_items(event.player_index) end
    if event.element.name == "debug-tech-grant" then grant_tech(event.player_index) end
end

local function init()
    for _, player in pairs(game.players) do
        debug_gui(player)
    end
end
local function on_player_created(event)
    local player = game.players[event.player_index]
    debug_gui(player)
end

dw.register_event('on_init', init)
dw.register_event(defines.events.on_player_created, on_player_created)
dw.register_event(defines.events.on_gui_click, debug_clicked)