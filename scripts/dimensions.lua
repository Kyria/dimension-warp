--- All about managing the different zones
--- except the surface platform.

local function init_surface(planet_name)
    local surface = game.planets[planet_name].create_surface()
    surface.solar_power_multiplier = 0
    surface.daytime = 0.5
    surface.always_day = true
    surface.freeze_daytime = true
    surface.request_to_generate_chunks({0, 0}, 2)
    surface.force_generate_chunk_requests()
    return surface
end

local function link_gates(teleport_connection1, teleport_connection2, teleport1, teleport2)
    storage.teleporter[teleport_connection1] = {active = true, from = teleport1, to = teleport2}
    storage.teleporter[teleport_connection2] = {active = true, from = teleport2, to = teleport1}
end

local function create_gate(surface, name, position, area_to_clear)
    if area_to_clear then
        area_to_clear = {
            {area_to_clear[1][1] + position[1], area_to_clear[1][2] + position[2]},
            {area_to_clear[2][1] + position[1], area_to_clear[2][2] + position[2]}
        }
        local to_remove = surface.find_entities_filtered {area = area_to_clear, type = {"character"}, invert = true}
        for _, entity in pairs(to_remove) do
            entity.destroy()
        end
    end

    gate = surface.create_entity{
        name = name,
        position = position,
        force = game.forces.player,
        direction = defines.direction.north
    }
    gate.destructible = false
    return gate
end

local function create_warp_factory_teleporters_logistic()
    local gate_1 = create_gate(storage.platform.factory.surface, "warp-gate", {0, -6.5}, {{-2, -2}, {1, 1}})
    local gate_2 = create_gate(storage.warp.current.surface, "radio-station", {0, -6}, {{-1, -1}, {0, 0}})
    link_gates("factory-to-warp", "warp-to-factory", gate_1, gate_2)
end

local function create_factory_mining_teleporters_logistic()
    local gate_1 = create_gate(storage.platform.mining.surface, "warp-gate", {0, -6.5}, {{-2, -2}, {1, 1}})
    local gate_2 = create_gate(storage.platform.factory.surface, "warp-gate", {0, 6.5}, {{-2, -2}, {1, 1}})
    link_gates("mining-to-factory", "factory-to-mining", gate_1, gate_2)
end

local function create_mining_power_teleporters_logistic()
    local gate_1 = create_gate(storage.platform.power.surface, "warp-gate", {0, -0.5}, {{-2, -2}, {1, 1}})
    local gate_2 = create_gate(storage.platform.mining.surface, "warp-gate", {0, 6.5}, {{-2, -2}, {1, 1}})
    link_gates("power-to-mining", "mining-to-power", gate_1, gate_2)
end


local function init_update_power_platform()
    if not storage.platform.power.surface then
        storage.platform.power.surface = init_surface('electria')
        create_mining_power_teleporters_logistic()
    end

    local tiles = {}
    local size = storage.platform.power.size

    local horizontal_top_left = {-size, -math.ceil(size / 3)}
    local horizontal_bottom_right = {size - 1, math.floor(size / 3)}

    local vertical_top_left = {-math.ceil(size / 3), -size}
    local vertical_bottom_right = {math.floor(size / 3), size - 1}
    utils.add_tiles(tiles, "energy-platform", horizontal_top_left, horizontal_bottom_right)
    utils.add_tiles(tiles, "energy-platform", vertical_top_left, vertical_bottom_right)
    storage.platform.power.surface.set_tiles(tiles)
end

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
end

local function init_update_factory_platform()
    if not storage.platform.factory.surface then
        storage.platform.factory.surface = init_surface('produstia')
        create_warp_factory_teleporters_logistic()
    end

    local tiles = {}
    local size = storage.platform.factory.size
    utils.add_tiles(tiles, "factory-platform", {-size/2, -size/2}, {(size-1)/2, (size-1)/2})
    storage.platform.factory.surface.set_tiles(tiles)
end


local function on_technology_research_finished(event)
    local tech = event.research

    if string.match(tech.name, "factory%-platform") then
        storage.platform.factory.size = 20
        init_update_factory_platform()
    end
    if string.match(tech.name, "mining%-platform") then
        storage.platform.mining.size = {x = 20, y = 16}
        init_update_mining_platform()
    end
    if string.match(tech.name, "power%-platform") then
        storage.platform.power.size = 20
        init_update_power_platform()
    end

    if string.match(tech.name, "factory%-platform%-upgrade%-%d+") then
        storage.platform.factory.size = 2 * tech.level ^ 2 + 5 * tech.level + 20
        init_update_factory_platform()
    end
    if string.match(tech.name, "mining%-platform%-upgrade%-%d+") then
        storage.platform.mining.size = {x = 2 * tech.level ^ 2 + 3 * tech.level + 20, y = tech.level ^ 2 + tech.level + 16}
        init_update_mining_platform()
    end
    if string.match(tech.name, "power%-platform%-upgrade%-%d+") then
        storage.platform.power.size = tech.level ^ 2 + 2 * tech.level + 20
        init_update_power_platform()
    end

    if string.match(tech.name, "dimension%-harvester%-%s+%-%d+") then
        storage.harvester.side.size = tech.level ^ 2 + tech.level + 10
        storage.harvester.side.border = math.max((tech.level - 1), 2)
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
dw.register_event(defines.events.on_player_rotated_entity, function(event) if event.entity.name == "dimension-input-chest" then game.print('rotate?') end end)