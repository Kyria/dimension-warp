
dw.update_warp_platform_size = function()
    local surface = storage.warp.current.surface
    local new_platform_area = math2d.bounding_box.create_from_centre(storage.platform.warp.center, storage.platform.warp.size, storage.platform.warp.size)
    local tiles = {}
    for i = 0, storage.platform.warp.size - 1 do
        for j = 0, storage.platform.warp.size - 1 do
            local position = {
                x = storage.platform.warp.center[1] - storage.platform.warp.size/2 + i,
                y = storage.platform.warp.center[2] - storage.platform.warp.size/2 + j
            }
            table.insert(tiles, {name = "warp-platform", position = position})
        end
    end

    local stuff_to_remove = surface.find_entities_filtered {
        area = new_platform_area,
        force = {"player", "enemy"},
        invert = true,
    }
    for _, stuff in pairs(stuff_to_remove) do
        stuff.destroy()
    end
    surface.set_tiles(tiles)
end

local function teleport_platform()
    if storage.warp.status ~= defines.warp.warping then return end

    local platform_area = math2d.bounding_box.create_from_centre(storage.platform.warp.center, storage.platform.warp.size, storage.platform.warp.size)
    local platform_area_delta = math2d.bounding_box.create_from_centre(storage.platform.warp.center, storage.platform.warp.size + 2, storage.platform.warp.size + 2)

    local source = storage.warp.previous.surface
    local destination = storage.warp.current.surface

    --- clone the tiles first, so we prepare the area, remove all unwanted stuff
    source.clone_area({
        source_area = platform_area,
        destination_area = platform_area,
        destination_surface = destination,
        clone_tiles = true,
        clone_entities = false,
        clone_decoratives = false,
        clear_destination_entities = true,
        clear_destination_decoratives = true,
        expand_map = true,
        create_build_effect_smoke = false,
    })

    --- check for cars & stuff. Use area_delta so we catch stuff on the border
    local vehicles = source.find_entities_filtered{
        type = {"car", "spider-vehicle"},
        area = platform_area_delta,
    }
    for _, vehicle in pairs(vehicles) do
        local position = vehicle.position
        dw.safe_teleport(vehicle, destination.name, position)
    end

    --- check for train related stuff, as we don't want to teleport them there
    --- but let the clone do its job to properly create them. So we need to remove
    --- the playfrom passengers and drivers
    local trains_and_wagons = source.find_entities_filtered{
        type = {"locomotive", "cargo-wagon", "fluid-wagon", "artillery-wagon"},
        area = platform_area_delta,
    }

    local trains_with_drivers = {}
    local locomotive_data = {}
    for _, train in pairs(trains_and_wagons) do
        local driver = train.get_driver()
        train.set_driver(nil)
        if driver and driver.is_player() then driver = driver.character end
        if driver and driver.valid then
            table.insert(trains_with_drivers, {
                train_position = train.position,
                driver_position = driver.position,
                train_name = train.name,
                driver_name = driver.name,
            })
        end

        if train.type == "locomotive" then
            local locomotive = train.train --[[@as LuaTrain]]
            local train_data = {
                schedule = locomotive.schedule,
                manual_mode = locomotive.manual_mode,
                name = train.name,
                position = train.position

            }
            table.insert(locomotive_data, train_data)
        end
    end

    --- check for players, and teleport them to the new surface
    for _, player in pairs(game.players) do
        if player.surface.name == source.name then
            if math2d.bounding_box.contains_point(platform_area_delta, player.position) then
                dw.safe_teleport(player, storage.warp.current.name, player.position)
            else
                player.character.die()
            end
        end
    end

    --- clone the left entities (includes biters... ?)
    storage.warp.previous.surface.clone_area{
        source_area = platform_area,
        destination_area = platform_area,
        destination_surface = destination,
        clone_tiles = false,
        clone_entities = true,
        clone_decoratives = false,
        clear_destination_entities = false,
        clear_destination_decoratives = false,
        expand_map = false,
        create_build_effect_smoke = false
    }

    for _, train_driver in pairs(trains_with_drivers) do
        local train = destination.find_entity(train_driver.train_name, train_driver.train_position)
        local driver = destination.find_entity(train_driver.driver_name, train_driver.driver_position)
        if train and driver then
            train.set_driver(driver)
        end
    end

    for _, train_data in pairs(locomotive_data) do
        local locomotive = destination.find_entity(train_data.name, train_data.position)
        if locomotive then
            local train = locomotive.train --[[@as LuaTrain]]
            if train then
                train.schedule = train_data.schedule
                train.manual_mode = train_data.manual_mode
            end
        end
    end

    dw.update_surfaces_properties()
end


dw.prepare_warp_to_next_surface = function()
    if storage.warp.status ~= defines.warp.awaiting then return end
    storage.warp.status = defines.warp.preparing

    local target = "neo-nauvis" --- dw select random surface
    dw.generate_surface(target)

    storage.warp.status = defines.warp.warping
    teleport_platform()
end


local function on_technology_research_finished(event)
    local tech = event.research
    if string.match(tech.name, "warp%-platform%-size%-%d+") then
        storage.platform.warp.size = 14 * tech.level + 8
        dw.update_warp_platform_size()
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
