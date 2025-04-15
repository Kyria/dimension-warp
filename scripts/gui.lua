dw.gui = dw.gui or {}

dw.gui.get_warp_toggle_button = function(player)
    local buttonflow = mod_gui.get_button_flow(player)
    local button = buttonflow.warp_toggle or buttonflow.add({type = "sprite-button", name = "warp_toggle", sprite = "warp-toggle-icon"})
    button.visible = true
    button.tooltip = {"dw-messages.gui-button-tooltip"}
    return button
end

dw.gui.get_warp_frame = function(player)
    local frameflow = mod_gui.get_frame_flow(player)
    local warp_frame = frameflow.warp_frame
    if not warp_frame then
        warp_frame = frameflow.add({type = "flow", name = "warp_frame", direction = "vertical"})
        warp_frame.visible = false
        warp_frame.style.padding = 0
        --local tabbed_frame = warp_frame.add{type="tabbed-pane"}
        --local tab1 = tabbed_frame.add{type="tab", caption="Warp Stats"}
        --local tab2 = tabbed_frame.add{type="tab", caption="Dimension info"}
        warp_frame.add{type="label", name="warp-in", caption="Warp in...."}
        warp_frame.add{type="label", name="surface", caption="Surface: " .. (storage.warp.current.name or "nauvis")}
        --tabbed_frame.add_tab(tab1, label1)
        --tabbed_frame.add_tab(tab2, label2)
    end
    return warp_frame
end

local function toggle_warp_frame(event)
    local player = game.players[event.player_index]
    local button = event.element
    if button.name == "warp_toggle" then
        local frame = dw.gui.get_warp_frame(player)
        frame.visible = not frame.visible
    end
end

local function prepare_warp_gui(player)
    dw.gui.get_warp_toggle_button(player)
    dw.gui.get_warp_frame(player)
end

local function on_init(event)
    for _, player in pairs(game.players) do
        prepare_warp_gui(player)
    end
end

local function on_player_created(event)
    local player = game.players[event.player_index]
    prepare_warp_gui(player)
end

local function update_gui()
    if game.tick % 60 ~= 0 then return end
    for _, player in pairs(game.players) do
        local frame = dw.gui.get_warp_frame(player)
        frame.surface.caption = "Surface: " .. (storage.warp.current.name or "nauvis")
    end
end

dw.register_event('on_init', on_init)
dw.register_event(defines.events.on_player_created, on_player_created)
dw.register_event(defines.events.on_gui_click, toggle_warp_frame)
dw.register_event(defines.events.on_tick, update_gui)
