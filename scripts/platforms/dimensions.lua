--- All about managing the different zones
--- except the surface platform.
------------------------------------------------------------
dw.platforms = dw.platforms or {}

local function init_surface(planet_name)
    local surface = game.planets[planet_name].create_surface()
    surface.solar_power_multiplier = 0
    if storage.platform.electrified_ground then
        surface.daytime = 0
        surface.always_day = true
        surface.create_global_electric_network()
    else
        surface.daytime = 0.5
    end
    surface.freeze_daytime = true
    surface.request_to_generate_chunks({0, 0}, 2)
    surface.force_generate_chunk_requests()
    return surface
end

local function create_special_entity(surface, entity_info, clear_area)
    local name = entity_info.name
    local position = entity_info.position
    if clear_area then
        area_to_clear = {
            {entity_info.area[1][1] + position[1], entity_info.area[1][2] + position[2]},
            {entity_info.area[2][1] + position[1], entity_info.area[2][2] + position[2]}
        }
        local to_remove = surface.find_entities_filtered {area = area_to_clear, type = {"character", "rocket-silo-rocket", "cargo-pod"}, invert = true}
        for _, entity in pairs(to_remove) do
            entity.destroy()
        end
    end

    local entity = surface.create_entity{
        name = name,
        position = position,
        force = game.forces.player,
        direction = entity_info.direction or defines.direction.north
    }
    entity.destructible = false
    return entity
end

local function create_warp_factory_teleporters_logistic()
    local gate_1 = create_special_entity(storage.platform.factory.surface, dw.entities.gate_factory_surface, true)
    local gate_2 = create_special_entity(storage.warp.current.surface, dw.entities.surface_radio_station, true)
    gate_2.active = false
    utils.link_gates("factory-to-warp", "warp-to-factory", gate_1, gate_2)
    utils.link_cables(gate_1, gate_2, defines.wire_connectors.logic)

    local pole_1 = create_special_entity(storage.warp.current.surface, dw.entities.surface_radio_pole)
    local pole_2 = create_special_entity(storage.platform.factory.surface, dw.entities.pole_factory_surface)
    utils.link_cables(pole_1, pole_2, defines.wire_connectors.power)

    dw.logistics.create_loader_chest_pair(storage.warp.current.surface, storage.platform.factory.surface, dw.stairs.surface_factory)
    dw.logistics.create_pipe_pairs(storage.warp.current.surface, storage.platform.factory.surface, dw.stairs.surface_factory)
end

local function create_factory_mining_teleporters_logistic()
    local gate_1 = create_special_entity(storage.platform.mining.surface, dw.entities.gate_mining_factory, true)
    local gate_2 = create_special_entity(storage.platform.factory.surface, dw.entities.gate_factory_mining, true)
    utils.link_gates("mining-to-factory", "factory-to-mining", gate_1, gate_2)
    utils.link_cables(gate_1, gate_2, defines.wire_connectors.logic)

    local pole_1 = create_special_entity(storage.platform.factory.surface, dw.entities.pole_factory_mining)
    local pole_2 = create_special_entity(storage.platform.mining.surface, dw.entities.pole_mining_factory)
    utils.link_cables(pole_1, pole_2, defines.wire_connectors.power)

    dw.logistics.create_loader_chest_pair(storage.platform.factory.surface, storage.platform.mining.surface, dw.stairs.factory_mining)
    dw.logistics.create_pipe_pairs(storage.platform.factory.surface, storage.platform.mining.surface, dw.stairs.factory_mining)
end

local function create_mining_power_teleporters_logistic()
    local gate_1 = create_special_entity(storage.platform.power.surface, dw.entities.gate_power_mining, true)
    local gate_2 = create_special_entity(storage.platform.mining.surface, dw.entities.gate_mining_power, true)
    utils.link_gates("power-to-mining", "mining-to-power", gate_1, gate_2)
    utils.link_cables(gate_1, gate_2, defines.wire_connectors.logic)

    local pole_1 = create_special_entity(storage.platform.mining.surface, dw.entities.pole_mining_power)
    local pole_2 = create_special_entity(storage.platform.power.surface, dw.entities.pole_power_mining)
    utils.link_cables(pole_1, pole_2, defines.wire_connectors.power)

    dw.logistics.create_loader_chest_pair(storage.platform.mining.surface, storage.platform.power.surface, dw.stairs.mining_power)
    dw.logistics.create_pipe_pairs(storage.platform.mining.surface, storage.platform.power.surface, dw.stairs.mining_power)
end


local function init_update_power_platform()
    if not storage.platform.power.surface then
        storage.platform.power.surface = init_surface('electria')
        create_mining_power_teleporters_logistic()
    end

    local tiles = {}
    local size = storage.platform.power.size

    if storage.platform.power.water then
        local horizontal_water = math2d.bounding_box.create_from_centre({0,0}, size*2 + 1, size * 2 / 3 + 1)
        utils.add_tiles(tiles, "water", horizontal_water.left_top, horizontal_water.right_bottom)
        local vertical_water = math2d.bounding_box.create_from_centre({0,0}, size * 2 / 3 + 1,  size*2 + 1)
        utils.add_tiles(tiles, "water", vertical_water.left_top, vertical_water.right_bottom)
    end

    local horizontal = math2d.bounding_box.create_from_centre({0,0}, size*2 - 1, size * 2 / 3 - 1)
    local vertical = math2d.bounding_box.create_from_centre({0,0}, size * 2 / 3 - 1,  size*2 - 1)
    utils.add_tiles(tiles, "energy-platform", horizontal.left_top, horizontal.right_bottom)
    utils.add_tiles(tiles, "energy-platform", vertical.left_top, vertical.right_bottom)

    storage.platform.power.surface.set_tiles(tiles, true, false, false)
    utils.put_warning_tiles(storage.platform.power.surface, dw.hazard_tiles.power)
end
dw.platforms.init_update_power_platform = init_update_power_platform

local function init_update_mining_platform()
    if not storage.platform.mining.surface then
        storage.platform.mining.surface = init_surface('smeltus')
        create_factory_mining_teleporters_logistic()
    end

    local tiles = {}
    local size_x = storage.platform.mining.size.x
    local size_y = storage.platform.mining.size.y
    utils.add_tiles(tiles, "mining-platform", {-size_x/2, -size_y/2}, {(size_x-1)/2, (size_y-1)/2})
    storage.platform.mining.surface.set_tiles(tiles)
    utils.put_warning_tiles(storage.platform.mining.surface, dw.hazard_tiles.mining)
end
dw.platforms.init_update_mining_platform = init_update_mining_platform

local function init_update_factory_platform()
    if not storage.platform.factory.surface then
        storage.platform.factory.surface = init_surface('produstia')
        create_warp_factory_teleporters_logistic()
    end

    local tiles = {}
    local size = storage.platform.factory.size
    utils.add_tiles(tiles, "factory-platform", {-size/2, -size/2}, {(size-1)/2, (size-1)/2})
    storage.platform.factory.surface.set_tiles(tiles)
    utils.put_warning_tiles(storage.platform.factory.surface, dw.hazard_tiles.factory)
end
dw.platforms.init_update_factory_platform = init_update_factory_platform


local function on_technology_research_finished(event)
    local tech = event.research

    if string.match(tech.name, "electrified%-ground") then
        storage.platform.electrified_ground = true
        if storage.platform.factory.surface then
            storage.platform.factory.surface.daytime = 0
            storage.platform.factory.surface.always_day = true
            storage.platform.factory.surface.create_global_electric_network()
        end
        if storage.platform.mining.surface then
            storage.platform.mining.surface.daytime = 0
            storage.platform.mining.surface.always_day = true
            storage.platform.mining.surface.create_global_electric_network()
        end
        if storage.platform.power.surface then
            storage.platform.power.surface.daytime = 0
            storage.platform.power.surface.always_day = true
            storage.platform.power.surface.create_global_electric_network()
        end
        game.print({"dw-messages.electrified-ground"})
    end

    if string.match(tech.name, "dw%-factory%-beacon%-%d") then
        local entity = storage.platform.factory.surface.create_entity{
            name = "dw-factory-beacon-" .. tech.level,
            position = {0,0},
            force = "player",
            fast_replace = true
        }
        entity.destructible = false
    end

    if tech.name == "factory-platform" then
        storage.platform.factory.size = dw.platform_size.factory[1]
        game.print({"dw-messages.factory-unlocked"})
        init_update_factory_platform()
    end
    if tech.name == "mining-platform" then
        storage.platform.mining.size = dw.platform_size.mining[1]
        game.print({"dw-messages.mining-unlocked"})
        init_update_mining_platform()
    end
    if tech.name == "power-platform" then
        storage.platform.power.size = dw.platform_size.power[1]
        game.print({"dw-messages.power-unlocked"})
        init_update_power_platform()
    end

    if string.match(tech.name, "factory%-platform%-upgrade%-%d+") then
        storage.platform.factory.size = dw.platform_size.factory[tech.level + 1]
        init_update_factory_platform()
    end
    if string.match(tech.name, "mining%-platform%-upgrade%-%d+") then
        storage.platform.mining.size = dw.platform_size.mining[tech.level + 1]
        init_update_mining_platform()
    end
    if string.match(tech.name, "power%-platform%-upgrade%-%d+") then
        storage.platform.power.size = dw.platform_size.power[tech.level + 1]
        init_update_power_platform()
    end

    if tech.name == "power-platform-water" then
        storage.platform.power.water = true
        init_update_power_platform()
    end
end


dw.register_event(defines.events.on_research_finished, on_technology_research_finished)