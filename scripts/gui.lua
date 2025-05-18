--- Everything related to DW GUI is here.
------------------------------------------------------------
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
        warp_frame.style.padding = {5, 0, 0, 5}
        local surfaceflow = warp_frame.add({type = "flow", name="surface", direction = "horizontal"})
        local dimensionflow = warp_frame.add({type = "flow", name="dimension", direction = "horizontal"})
        local warpflow = warp_frame.add({type = "flow", name="warp_timer", direction = "horizontal"})
        local manualwarpflow = warp_frame.add({type = "flow", name="warp_timer_manual", direction = "horizontal"})

        surfaceflow.add{type="label", caption="Planet: "}
        surfaceflow.add{type="label", name="variable", caption="Nauvis"}
        surfaceflow.visible = storage.nauvis_lab_exploded or false

        dimensionflow.add{type="label", caption="Dimension: "}
        dimensionflow.add{type="label", name="variable", caption="0"}
        dimensionflow.visible = storage.nauvis_lab_exploded or false

        warpflow.add{type="label", caption="Auto Warp: "}
        warpflow.add{type="label", name="variable", caption="∞"}
        warpflow.visible = storage.timer.active

        manualwarpflow.add{type="label", caption="Manual Warp: "}
        manualwarpflow.add{type="label", name="variable", caption="∞"}
        manualwarpflow.visible = storage.timer.active

        warp_frame.add{type="button", name="warp_button", caption={"dw-gui.warp-button"}, style = "confirm_button"}
        warp_frame.warp_button.visible = storage.timer.active
    end
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



dw.update_gui = function()
    for _, player in pairs(game.players) do
        local frame = dw.gui.get_warp_frame(player)

        frame.surface.visible = storage.nauvis_lab_exploded or false
        frame.dimension.visible = storage.nauvis_lab_exploded or false
        frame.surface.variable.caption = {"space-location-name." .. storage.warp.current.type}
        frame.dimension.variable.caption = storage.warp.number

        if storage.timer.active then
            if storage.timer.warp >= 0 then
                frame.warp_timer.visible = true
                frame.warp_timer.variable.caption = utils.format_time(storage.timer.warp)
            else
                frame.warp_timer.visible = false
            end
            frame.warp_timer_manual.visible = true
            frame.warp_timer_manual.variable.caption = utils.format_time(storage.timer.manual_warp)
        end
    end
end


dw.register_event('on_init', on_init)
dw.register_event(defines.events.on_player_created, on_player_created)
dw.register_event(defines.events.on_gui_click, warp_frame_click)
