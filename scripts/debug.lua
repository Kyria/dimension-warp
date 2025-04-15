local function debug_gui(player)
    local frame = dw.gui.get_warp_frame(player)

    frame.add{type = "button", name = "trigger-next-warp", caption = "Warp Next"}
end

local function debug_clicked(event)
    if not event.element.valid then return end
    if event.element.name == "trigger-next-warp" then dw.prepare_warp_to_next_surface() end
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