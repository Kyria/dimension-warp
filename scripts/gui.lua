--- Everything related to DW GUI is here.
------------------------------------------------------------
dw.gui = dw.gui or {}

local function get_player_gui_settings(player)
    local player_settings = settings.get_player_settings(player)
    return {
        highlight_change = player_settings['dw-gui-highlight-qty-change'].value --[[@as boolean]],
        default_color = player_settings['dw-gui-default-color'].value --[[@as string]],
        increase_color = player_settings['dw-gui-increase-qty-color'].value --[[@as string]],
        decrease_color = player_settings['dw-gui-decrease-qty-color'].value --[[@as string]],
        delimiter = player_settings['dw-gui-thousand-delimiter'].value --[[@as string]],
        info_planet = player_settings['dw-gui-info-planet'].value --[[@as boolean]],
        info_dimension = player_settings['dw-gui-info-dimension'].value --[[@as boolean]],
        info_planet_clock = player_settings['dw-gui-info-planet-clock'].value --[[@as boolean]],
        info_evolution = player_settings['dw-gui-info-evolution'].value --[[@as boolean]],
        info_warp_timer = player_settings['dw-gui-info-warp-timer'].value --[[@as boolean]],
        info_manual_timer = player_settings['dw-gui-info-manual-warp-timer'].value --[[@as boolean]],
        planet_selector = player_settings['dw-gui-planet-selector'].value --[[@as boolean]],
    }
end

local function set_warp_toggle_buttons(player)
    local buttonflow = mod_gui.get_button_flow(player)
    local warp_toggle = buttonflow.warp_toggle or buttonflow.add({type = "sprite-button", name = "warp_toggle", sprite = "warp-toggle-icon"})
    local container_toggle = buttonflow.container_toggle or buttonflow.add({type = "sprite-button", name = "container_toggle", sprite = "warp-toggle-container-icon"})
    warp_toggle.visible = true
    warp_toggle.tooltip = {"dw-messages.gui-button-tooltip"}
    container_toggle.visible = true
    container_toggle.tooltip = {"dw-messages.gui-watchitem-tooltip"}
end
dw.gui.set_warp_toggle_buttons = set_warp_toggle_buttons

local function get_warp_frame(player)
    local frameflow = mod_gui.get_frame_flow(player)
    local dw_frame = frameflow.dw_frame or frameflow.add({type = "flow", name = "dw_frame", direction = "vertical"})
    local warp_frame = dw_frame.warp_frame or dw_frame.add({type = "flow", name = "warp_frame", direction = "vertical"})
    warp_frame.visible = warp_frame.visible or false
    warp_frame.style.padding = {5, 0, 0, 5}

    local surfaceflow = warp_frame.surface or warp_frame.add{type = "label", name = "surface", caption = {"dw-gui.planet", "nauvis", "Nauvis", "normal"}}
    local dimensionflow = warp_frame.dimension or warp_frame.add{type = "label", name = "dimension", caption = {"dw-gui.dimension", "0"}}
    local surface_time = warp_frame.surface_time or warp_frame.add{type = "label", name = "surface_time", caption = {"dw-gui.planet_clock", "0"}}
    local surface_evolution = warp_frame.surface_evolution or warp_frame.add{type = "label", name = "surface_evolution", caption = {"dw-gui.planet_evolution", "0"}}
    local warpflow = warp_frame.warp_timer or warp_frame.add{type = "label", name = "warp_timer", caption = {"dw-gui.autowarp_timer", "0"}}
    local manualwarpflow = warp_frame.warp_timer_manual or warp_frame.add{type = "label", name = "warp_timer_manual", caption = {"dw-gui.manualwarp_timer", "0"}}
    local destination_flow = warp_frame.destination_flow or warp_frame.add{type = "flow", name = "destination_flow", direction = "horizontal"}
    local warp_button = warp_frame.warp_button or warp_frame.add{type="button", name="warp_button", caption={"dw-gui.warp-button"}, style = "confirm_button"}

    -- preferred destination selector buttons
    local preferred_dest_label = destination_flow.label or destination_flow.add{type="label", name="label", caption={"dw-gui.preferred-destination"}}
    local destination_list = {
        none = destination_flow['preferred-none'] or destination_flow.add{type="sprite-button", name="preferred-none", sprite="virtual-signal.signal-deny", auto_toggle=true, toggled=true},
    }
    destination_list.none.style.width = 25
    destination_list.none.style.height = 25
    destination_list.none.style.padding = 0
    destination_list.none.style.margin = 0
    storage.planet_selector_list["preferred-none"] = true
    
    for _, planet in pairs(game.planets) do
        if not utils.ignore_planet(planet.name) and player.force.is_space_location_unlocked(planet.name) then 
            destination_list["preferred-" .. planet.name] = destination_flow["preferred-" .. planet.name] or destination_flow.add{type="sprite-button", name="preferred-" .. planet.name, sprite="space-location." .. planet.name, tooltip = {"space-location-name." .. planet.name}, auto_toggle=true}
            destination_list["preferred-" .. planet.name].style.width = 25
            destination_list["preferred-" .. planet.name].style.height = 25
            destination_list["preferred-" .. planet.name].style.padding = 0
            destination_list["preferred-" .. planet.name].style.margin = 0
            storage.planet_selector_list["preferred-" .. planet.name] = true
        end
    end

    local player_gui_settings = get_player_gui_settings(player)
    surfaceflow.visible = player_gui_settings.info_planet and (storage.nauvis_lab_exploded or false)
    dimensionflow.visible = player_gui_settings.info_dimension and (storage.nauvis_lab_exploded or false)
    surface_time.visible = player_gui_settings.info_planet_clock and (storage.nauvis_lab_exploded or false)
    surface_evolution.visible = player_gui_settings.info_evolution and (storage.nauvis_lab_exploded or false)
    warpflow.visible = player_gui_settings.info_warp_timer and storage.timer.active
    manualwarpflow.visible = player_gui_settings.info_manual_timer and storage.timer.active
    destination_flow.visible = player_gui_settings.planet_selector and storage.planet_selector_enabled
    warp_button.visible = storage.timer.active

    return warp_frame
end
dw.gui.get_warp_frame = get_warp_frame

local function get_or_create_item_selector(player, frame, name)
    local flow = frame[name] or frame.add({type = "flow", name = name, direction = "horizontal"})

    local item_button = flow.item or flow.add{type="choose-elem-button", name="item", elem_type="item-with-quality"}
    item_button.elem_value = storage.gui.item_watch[name]

    local item_count = flow.count or flow.add{type="label", name="count", caption = "0"}

    item_button.style.width = 25
    item_button.style.height = 25
    item_button.style.padding = 0
    item_button.style.margin = 0
    item_button.visible = true
    item_count.visible = true
    item_count.style.height = 25
    item_count.style.width = 80
    item_count.style.right_padding = 5
    item_count.style.vertical_align = "center"
    item_count.style.horizontal_align = "right"
    item_count.style.font_color = util.color(get_player_gui_settings(player).default_color)
    item_count.style.hovered_font_color  = util.color("#C4E9FF")

    return flow
end

local function get_container_frame(player)
    local frameflow = mod_gui.get_frame_flow(player)
    local dw_frame = frameflow.dw_frame or frameflow.add({type = "flow", name = "dw_frame", direction = "vertical"})
    local container_frame = dw_frame.container_frame or dw_frame.add({type = "frame", name = "container_frame", direction = "vertical", visible = false, style="dw_frame"})
    container_frame.visible = container_frame.visible or false
    container_frame.style.margin = {5, 0, 0, 5}

    if not container_frame.header_label then container_frame.add{type = "label", name = "header_label", caption = {"dw-gui.item-watch"}} end
    if not container_frame.header_line then container_frame.add{type = "line", name = "header_line"} end

    local item_table = container_frame.item_table or container_frame.add({type = "table", name = "item_table", column_count = 3})
    if not container_frame.footer_line then container_frame.add{type = "line", name = "footer_line"} end

    for watchdog, _ in pairs(storage.gui.watchdogs) do
        get_or_create_item_selector(player, item_table, 'watch-item-' .. watchdog)
    end

    return container_frame
end
dw.gui.get_container_frame = get_container_frame

local function update_manual_warp_button()
    for _, player in pairs(game.players) do
        local frame = get_warp_frame(player)
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
dw.gui.update_manual_warp_button = update_manual_warp_button

local function update_preferred_destination(previous_destination, current_destination)
    for _, player in pairs(game.players) do
        local frame = get_warp_frame(player)
        local previous_button = frame.destination_flow["preferred-" .. previous_destination]
        if previous_button then
            previous_button.toggled = false
        end
        local current_button = frame.destination_flow["preferred-" .. current_destination]
        if current_button then
            current_button.toggled = true
        end
    end
end

local function warp_frame_click(event)
    local player = game.players[event.player_index]
    local button = event.element
    if button.name == "warp_toggle" then
        local frame = get_warp_frame(player)
        frame.visible = not frame.visible
    end

    if button.name == "warp_button" then
        storage.votes.count = storage.votes.count + 1
        storage.votes.players[event.player_index] = true
        update_manual_warp_button()
    end

    if button.name == "container_toggle" then
        local frame = get_container_frame(player)
        frame.visible = not frame.visible
    end

    if button.name:match('^preferred%-') then
        local planet_name = button.name:sub(11)
        local previous = storage.warp.preferred_destination or "none"
        if button.toggled then
            storage.warp.preferred_destination = planet_name
        else
            storage.warp.preferred_destination = nil
        end
        update_preferred_destination(previous, storage.warp.preferred_destination or "none")
    end
end

---Event fired when player change an item in the item watcher
---@param event EventData.on_gui_elem_changed
local function item_watch_changed(event)
    local elem = event.element
    local name = elem.parent.name
    local item = elem.elem_value -- name, quality
    local remove_watchdog = false

    if not name or not name:match('watch%-item%-%d+') then return end

    -- add the item to the watchlist, or remove it if required
    if item then
        -- add the item to the watchlist, only increase the counter if the watcher didn't have any item yet
        if not storage.gui.item_watch[name] then
            storage.gui.count_watched_item = storage.gui.count_watched_item + 1
        end
        storage.gui.item_watch[name] = item

        -- add a watchdog for an item
        if storage.gui.count_watched_item == storage.gui.count_watchdogs then
            storage.gui.count_watchdogs = storage.gui.count_watchdogs + 1
            storage.gui.watchdogs[game.tick] = true
        end

    else
        -- remove the watched item based on the watchdog name
        if storage.gui.item_watch[name] then
            storage.gui.item_watch[name] = nil
            storage.gui.count_watched_item = storage.gui.count_watched_item - 1

            -- if we have more than 3 watchdogs, and more than 1 empty, remove the one we unset
            if storage.gui.count_watchdogs > 3 and (storage.gui.count_watchdogs - storage.gui.count_watched_item) > 1  then
                local watchdog = tonumber(name:match('watch%-item%-(%d+)'))
                if watchdog then
                    storage.gui.watchdogs[watchdog] = nil
                    storage.gui.count_watchdogs = storage.gui.count_watchdogs - 1
                    remove_watchdog = true
                end
            end
        end
    end

    -- update player UI
    for _, player in pairs(game.players) do
        local frame = get_container_frame(player)
        frame.item_table[name].item.elem_value = item
        frame.item_table[name].count.caption = "0"

        if not item and remove_watchdog then
            frame.item_table[name].destroy()
        end
    end
end

--- Update the watchdogs labels to display the actual item quantity
local function update_watchdogs_gui()
    for _, player in pairs(game.connected_players) do
        local player_gui_settings = get_player_gui_settings(player)

        for watchdog, item in pairs(storage.gui.item_watch) do
            local item_quantity = storage.gui.item_list[item.name .. '-' .. item.quality] or 0
            local frameflow = mod_gui.get_frame_flow(player)

            if not frameflow.dw_frame or not frameflow.dw_frame.container_frame then
                get_container_frame(player)
            end

            local frame = frameflow.dw_frame.container_frame
            if not frame.item_table[watchdog].count then
                get_container_frame(player)
            end

            local item_variation = item_quantity.qty - item_quantity.prev
            frame.item_table[watchdog].count.tooltip = nil
            if player_gui_settings.highlight_change then
                local color = util.color(player_gui_settings.default_color)
                if item_variation > 0 then
                    color = util.color(player_gui_settings.increase_color)
                elseif item_variation < 0 then
                    color = util.color(player_gui_settings.decrease_color)
                end
                frame.item_table[watchdog].count.style.font_color = color
                frame.item_table[watchdog].count.tooltip = (item_variation ~= 0 and {"dw-gui.item-variation", item_variation} or nil)
            end

            -- starting 1million, we don't display the exact value anymore.
            if item_quantity.qty >= 1000000 then
                frame.item_table[watchdog].count.caption = util.format_number(item_quantity.qty, true)
            else
                frame.item_table[watchdog].count.caption = utils.format_thousands(item_quantity.qty, player_gui_settings.delimiter)
            end
        end
    end
end
dw.gui.update_watchdogs_gui = update_watchdogs_gui

---Call by all init method to create the user GUI.
---@param player LuaPlayer
local function prepare_warp_gui(player)
    set_warp_toggle_buttons(player)
    get_warp_frame(player)
    get_container_frame(player)
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

--- Update all the GUI information (except items)
local function update()
    for _, player in pairs(game.players) do
        local frame = get_warp_frame(player)

        local player_gui_settings = get_player_gui_settings(player)
        
        frame.surface.visible = player_gui_settings.info_planet and (storage.nauvis_lab_exploded or false)
        frame.dimension.visible = player_gui_settings.info_dimension and (storage.nauvis_lab_exploded or false)
        frame.surface_time.visible = player_gui_settings.info_planet_clock and (storage.nauvis_lab_exploded or false)
        frame.surface_evolution.visible = player_gui_settings.info_evolution and (storage.nauvis_lab_exploded or false)
        frame.destination_flow.visible = player_gui_settings.planet_selector and storage.planet_selector_enabled

        frame.surface.caption = {"dw-gui.planet", storage.warp.current.planet, {"space-location-name." .. storage.warp.current.planet}, storage.warp.randomizer or "normal"}
        frame.dimension.caption = {"dw-gui.dimension", storage.warp.number}
        frame.surface_evolution.caption = {"dw-gui.planet_evolution", string.format("%.2f", game.forces.enemy.get_evolution_factor(storage.warp.current.surface) * 100)}
        frame.surface_time.caption = {"dw-gui.planet_clock", utils.format_time(game.tick/60 - storage.warp.time/60)}

        if storage.timer.active then
            if storage.timer.warp >= 0 then
                frame.warp_timer.visible = player_gui_settings.info_warp_timer
                local timer = utils.format_time(storage.timer.warp)
                if storage.timer.warp <= 60 then timer = "[font=default-bold][color=#faf17a]" .. timer .. "[/color][/font]" end
                frame.warp_timer.caption = {"dw-gui.autowarp_timer", timer}
            else
                frame.warp_timer.visible = false
            end
            frame.warp_timer_manual.visible = player_gui_settings.info_manual_timer
            local timer = utils.format_time(storage.timer.manual_warp)
            if storage.timer.manual_warp < 10 then timer = "[font=default-bold][color=#faf17a]" .. timer .. "[/color][/font]" end
            frame.warp_timer_manual.caption = {"dw-gui.manualwarp_timer", timer}
        end
    end
end
dw.gui.update = update

dw.register_event('on_init', on_init)
dw.register_event('on_configuration_changed', on_init)
dw.register_event(defines.events.on_player_created, on_player_created)
dw.register_event(defines.events.on_gui_click, warp_frame_click)
dw.register_event(defines.events.on_gui_elem_changed, item_watch_changed)