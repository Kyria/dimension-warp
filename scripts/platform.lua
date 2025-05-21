--- All surface platform related function
------------------------------------------------------------

dw.update_warp_platform_size = function()
    local surface = storage.warp.current.surface
    local new_platform_area = math2d.bounding_box.create_from_centre({0, 0}, storage.platform.warp.size, storage.platform.warp.size)
    local tiles = {}

    local size = storage.platform.warp.size
    utils.add_tiles(tiles, "warp-platform", {-size/2, -size/2}, {(size-1)/2, (size-1)/2})

    local stuff_to_remove = surface.find_entities_filtered {
        area = new_platform_area,
        force = {"player", "enemy"},
        invert = true,
    }
    for _, stuff in pairs(stuff_to_remove) do
        stuff.destroy()
    end
    surface.set_tiles(tiles)
    if storage.platform.warp.size >= 12 then
        utils.put_warning_tiles(surface, dw.hazard_tiles.surface)
    end
end


dw.teleport_platform = function()
    if storage.warp.status ~= defines.warp.warping then return end

    local platform_area = math2d.bounding_box.create_from_centre({0, 0}, storage.platform.warp.size, storage.platform.warp.size)
    local platform_area_delta = math2d.bounding_box.create_from_centre({0, 0}, storage.platform.warp.size + 2, storage.platform.warp.size + 2)

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
        dw.safe_teleport(vehicle, destination, position, true)
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
            if math2d.bounding_box.contains_point(platform_area_delta, player.physical_position) then
                dw.safe_teleport(player, storage.warp.current.surface, player.physical_position, true)
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


local function relink_loader_chest(surface, positions_list)
    for _, positions in pairs(positions_list) do
        local chest_index = 'surface_' .. positions.chests[1][1] .. '_' .. positions.chests[1][2]
        local loader_index = 'surface_' .. positions.loaders[1][1] .. '_' .. positions.loaders[1][2]

        --- if we didn't store any pair with that index, it means the chest/loader pair is not yet deployed
        if not storage.stairs.chest_pairs[chest_index] then goto continue end

        local chest = surface.find_entities_filtered{position = positions.chests[1], name = {"dw-chest", "dw-logistic-input", "dw-logistic-output"}}
        local loader = surface.find_entities_filtered{position = positions.loaders[1], name = {storage.stairs.loader_tier}}

        if chest[1] and loader[1] then
            storage.stairs.chest_pairs[chest_index].A = chest[1]
            storage.stairs.chest_loader_pairs.surface[loader_index].loader = loader[1]
            storage.stairs.chest_loader_pairs.surface[loader_index].chest = chest[1]
        end
        ::continue::
    end
end

local function relink_pipes(surface, positions_list)
    for _, positions in pairs(positions_list) do
        local index = 'surface_' .. positions.pipes[1][1] .. '_' .. positions.pipes[1][2]

        --- if we didn't store any pair with that index, it means the pipe pair is not yet deployed
        if not storage.stairs.pipe_pairs[index] then goto continue end

        local pipe = surface.find_entities_filtered{position = positions.pipes[1], name = {storage.stairs.pipes_type}}

        if pipe[1] then
            storage.stairs.pipe_pairs[index].A = pipe[1]
            pipe[1].fluidbox.add_linked_connection(0, storage.stairs.pipe_pairs[index].B, 0)
        end
        ::continue::
    end
end

--- force update some entities that may be broken due to clone
--- and the fact surfaces are not linked to planet asoon as they are created
dw.platform_force_update_entities = function()
    local surface = storage.warp.current.surface
    local platform = math2d.bounding_box.create_from_centre({0, 0}, storage.platform.warp.size, storage.platform.warp.size)

    -- update lightning attractors
    local lightning_attractors = surface.find_entities_filtered{
        type = "lightning-attractor",
        area = platform,
    }

    for _, rod in pairs(lightning_attractors) do
        rod.clone{position=rod.position, create_build_effect_smoke=false}
        rod.destroy()
    end

    --- update teleporters (radio station + warpgate)
    local radio_tower = surface.find_entity(dw.entities.surface_radio_station.name, dw.entities.surface_radio_station.position)
    if radio_tower then
        utils.link_gates('factory-to-warp', 'warp-to-factory', storage.teleporter['factory-to-warp'].from, radio_tower)
        utils.link_cables(storage.teleporter['factory-to-warp'].from, radio_tower, defines.wire_connectors.logic)
    end

    --- update electricity link
    local surface_radio_pole = surface.find_entity(dw.entities.surface_radio_pole.name, dw.entities.surface_radio_pole.position)
    local factory_power_pole = storage.platform.factory.surface.find_entity(dw.entities.pole_factory_surface.name, dw.entities.pole_factory_surface.position)
    if surface_radio_pole and factory_power_pole then
        utils.link_cables(surface_radio_pole, factory_power_pole, defines.wire_connectors.pdower)
    end

    --- relink loaders/chests between surfaces
    relink_loader_chest(surface, dw.stairs.surface_factory)
    relink_pipes(surface, dw.stairs.surface_factory)
end


local function on_technology_research_finished(event)
    local tech = event.research
    if string.match(tech.name, "warp%-platform%-size%-%d+") then
        storage.platform.warp.size = 14 * tech.level + 8
        dw.update_warp_platform_size()
    end

    if string.match(tech.name, "platform%-radar") then
        local radio_tower = storage.warp.current.surface.find_entity(dw.entities.surface_radio_station.name, dw.entities.surface_radio_station.position)
        if radio_tower then
            radio_tower.active = true
        end
    end
end


dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
