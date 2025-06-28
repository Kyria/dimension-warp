--- Everything related to DW GUI is here.
------------------------------------------------------------
dw.gui = dw.gui or {}

dw.gui.set_warp_toggle_buttons = function(player)
    local buttonflow = mod_gui.get_button_flow(player)
    local button_info = buttonflow.warp_toggle or buttonflow.add({type = "sprite-button", name = "warp_toggle", sprite = "warp-toggle-icon"})
    button_info.visible = true
    button_info.tooltip = {"dw-messages.gui-button-tooltip"}
end

dw.gui.get_warp_frame = function(player)
    local frameflow = mod_gui.get_frame_flow(player)
    local warp_frame = frameflow.warp_frame or frameflow.add({type = "flow", name = "warp_frame", direction = "vertical"})
    warp_frame.visible = warp_frame.visible or false
    warp_frame.style.padding = {5, 0, 0, 5}

    local surfaceflow = warp_frame.surface or warp_frame.add({type = "label", name = "surface", caption = {"dw-gui.planet", "nauvis", "Nauvis", "normal"}})
    local dimensionflow = warp_frame.dimension or warp_frame.add({type = "label", name = "dimension", caption = {"dw-gui.dimension", "0"}})
    local surface_time = warp_frame.surface_time or warp_frame.add({type = "label", name = "surface_time", caption = {"dw-gui.planet_clock", "0"}})
    local surface_evolution = warp_frame.surface_evolution or warp_frame.add({type = "label", name = "surface_evolution", caption = {"dw-gui.planet_evolution", "0"}})
    local warpflow = warp_frame.warp_timer or warp_frame.add({type = "label", name = "warp_timer", caption = {"dw-gui.autowarp_timer", "0"}})
    local manualwarpflow = warp_frame.warp_timer_manual or warp_frame.add({type = "label", name = "warp_timer_manual", caption = {"dw-gui.manualwarp_timer", "0"}})

    surfaceflow.visible = storage.nauvis_lab_exploded or false
    dimensionflow.visible = storage.nauvis_lab_exploded or false
    surface_time.visible = storage.nauvis_lab_exploded or false
    surface_evolution.visible = storage.nauvis_lab_exploded or false
    warpflow.visible = storage.timer.active
    manualwarpflow.visible = storage.timer.active

    if not warp_frame.warp_button then
        warp_frame.add{type="button", name="warp_button", caption={"dw-gui.warp-button"}, style = "confirm_button"}
    end
    warp_frame.warp_button.visible = storage.timer.active
    return warp_frame
end

dw.update_manual_warp_button = function()
    for _, player in pairs(game.players) do
        local frame = dw.gui.get_warp_frame(player)
        local button = frame.warp_button
        button.visible = storage.timer.active

        if storage.votes.count >= storage.votes.min_vote then
            button.caption = {"dw-gui.warp-button-warping"}
            button.enabled = false
        else
            if storage.votes.count > 0 then
                if storage.votes.players[player.index] then
                    button.caption = {"dw-gui.warp-button-wait", storage.votes.count, storage.votes.min_vote}
                    button.enabled = false
                else
                    button.caption = {"dw-gui.warp-button-warp", storage.votes.count, storage.votes.min_vote}
                    button.enabled = true
                end
            else
                button.caption = {"dw-gui.warp-button"}
                button.enabled = true
            end
        end
    end
end

local function warp_frame_click(event)
    local player = game.players[event.player_index]
    local button = event.element
    if button.name == "warp_toggle" then
        local frame = dw.gui.get_warp_frame(player)
        frame.visible = not frame.visible
    end

    if button.name == "warp_button" then
        storage.votes.count = storage.votes.count + 1
        storage.votes.players[event.player_index] = true
        dw.update_manual_warp_button()
    end
end

local function prepare_warp_gui(player)
    dw.gui.set_warp_toggle_buttons(player)
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



dw.update_gui = function()
    for _, player in pairs(game.players) do
        local frame = dw.gui.get_warp_frame(player)

        frame.surface.visible = storage.nauvis_lab_exploded or false
        frame.dimension.visible = storage.nauvis_lab_exploded or false
        frame.surface_time.visible = storage.nauvis_lab_exploded or false
        frame.surface_evolution.visible = storage.nauvis_lab_exploded or false

        frame.surface.caption = {"dw-gui.planet", storage.warp.current.planet, {"space-location-name." .. storage.warp.current.planet}, storage.warp.randomizer or "normal"}
        frame.dimension.caption = {"dw-gui.dimension", storage.warp.number}
        frame.surface_evolution.caption = {"dw-gui.planet_evolution", string.format("%.2f", game.forces.enemy.get_evolution_factor(storage.warp.current.surface) * 100)}
        frame.surface_time.caption = {"dw-gui.planet_clock", utils.format_time(game.tick/60 - storage.warp.time/60)}

        if storage.timer.active then
            if storage.timer.warp >= 0 then
                frame.warp_timer.visible = true
                local timer = utils.format_time(storage.timer.warp)
                if storage.timer.warp <= 60 then timer = "[font=default-bold][color=#faf17a]" .. timer .. "[/color][/font]" end
                frame.warp_timer.caption = {"dw-gui.autowarp_timer", timer}
            else
                frame.warp_timer.visible = false
            end
            frame.warp_timer_manual.visible = true
            local timer = utils.format_time(storage.timer.manual_warp)
            if storage.timer.manual_warp < 10 then timer = "[font=default-bold][color=#faf17a]" .. timer .. "[/color][/font]" end
            frame.warp_timer_manual.caption = {"dw-gui.manualwarp_timer", timer}
        end
    end
end


dw.register_event('on_init', on_init)
dw.register_event('on_configuration_changed', on_init)
dw.register_event(defines.events.on_player_created, on_player_created)
dw.register_event(defines.events.on_gui_click, warp_frame_click)
