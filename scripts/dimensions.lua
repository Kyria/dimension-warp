--- All about managing the different zones
--- except the surface platform.
------------------------------------------------------------

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
        local to_remove = surface.find_entities_filtered {area = area_to_clear, type = {"character"}, invert = true}
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

--- surface A should always be first surface in dw.stairs index name.
--- surface B should always be second surface in dw.stairs index name.
--- in the case of the surface mobile gate, A = platform, B = anywhere.
local function create_loader_chest_pair(surface_A, surface_B, positions)
    local surface_name_A = dw.safe_surfaces[surface_A.name] and surface_A.name or "surface"
    local surface_name_B = dw.safe_surfaces[surface_B.name] and surface_B.name or "surface"

    local max = math.min(#positions, storage.stairs.chest_number)
    for i = 1, max, 1 do
        local chest_index = surface_name_A .. '_' .. positions[i].chests[1][1] .. '_' .. positions[i].chests[1][2]
        local loader_index_A = surface_name_A .. '_' .. positions[i].loaders[1][1] .. '_' .. positions[i].loaders[1][2]
        local loader_index_B = surface_name_B .. '_' .. positions[i].loaders[2][1] .. '_' .. positions[i].loaders[2][2]
        local chest_A = nil
        local chest_B = nil
        local loader_A = nil
        local loader_B = nil
        local type = defines.item_direction.push

        if storage.stairs.chest_pairs[chest_index] then
            chest_A = storage.stairs.chest_pairs[chest_index].A
            chest_B = storage.stairs.chest_pairs[chest_index].B
            type = storage.stairs.chest_pairs[chest_index].type
        end
        if storage.stairs.chest_loader_pairs[surface_name_A][loader_index_A] then
            loader_A = storage.stairs.chest_loader_pairs[surface_name_A][loader_index_A].loader
        end
        if storage.stairs.chest_loader_pairs[surface_name_B][loader_index_B] then
            loader_B = storage.stairs.chest_loader_pairs[surface_name_B][loader_index_B].loader
        end

        --- if the chest is not valid or doesn't exist, we create it
        if not chest_A or (chest_A and not chest_A.valid) then
            local to_remove = surface_A.find_entities_filtered {position = positions[i].chests[1], type = {"character"}, invert = true}
            for _, entity in pairs(to_remove) do entity.destroy() end
            chest_A = surface_A.create_entity {
                name = (type == defines.item_direction.push) and storage.stairs.chest_type.input or storage.stairs.chest_type.output,
                position = positions[i].chests[1],
                force = game.forces.player,
                direction = defines.direction.north
            }
            chest_A.destructible = false
        end

        --- if the chest is not valid or doesn't exist, we create it
        if not chest_B or (chest_B and not chest_B.valid) then
            local to_remove = surface_B.find_entities_filtered {position = positions[i].chests[2], type = {"character"}, invert = true}
            for _, entity in pairs(to_remove) do entity.destroy() end
            chest_B = surface_B.create_entity {
                name = (type == defines.item_direction.push) and storage.stairs.chest_type.output or storage.stairs.chest_type.input,
                position = positions[i].chests[2],
                force = game.forces.player,
                direction = defines.direction.north
            }
            chest_B.destructible = false
        end

        --- pair both chest and provide the type of flow.
        storage.stairs.chest_pairs[chest_index] = {
            A = chest_A,
            B = chest_B,
            type = type,
        }

        --- we create each loaders, and set them the right type
        if not loader_A or (loader_A and not loader_A.valid) then
            local to_remove = surface_A.find_entities_filtered {position = positions[i].loaders[1], type = {"character"}, invert = true}
            for _, entity in pairs(to_remove) do entity.destroy() end
            local loader_type = (type == defines.item_direction.push) and "input" or "output"
            loader_A = surface_A.create_entity {
                name = storage.stairs.loader_tier,
                position = positions[i].loaders[1],
                force = game.forces.player,
                direction = positions[i].direction[1][loader_type],
                type = loader_type
            }
            loader_A.destructible = false
        end

        if not loader_B or (loader_B and not loader_B.valid) then
            local to_remove = surface_B.find_entities_filtered {position = positions[i].loaders[2], type = {"character"}, invert = true}
            for _, entity in pairs(to_remove) do entity.destroy() end
            local loader_type = (type == defines.item_direction.push) and "output" or "input"
            loader_B = surface_B.create_entity {
                name = storage.stairs.loader_tier,
                position = positions[i].loaders[2],
                force = game.forces.player,
                direction = positions[i].direction[2][loader_type],
                type = loader_type,
            }
            loader_B.destructible = false
        end

        --- we store each pair (chest/loader) and save the ref to find the linked pair
        --- this is used for post warp check / rotation of loaders to change flow direction
        storage.stairs.chest_loader_pairs[surface_name_A][loader_index_A] = {
            loader = loader_A,
            chest = chest_A,
            type = (type == defines.item_direction.push) and "input" or "output",
            ref = {surface_name_B, loader_index_B}
        }
        storage.stairs.chest_loader_pairs[surface_name_B][loader_index_B] = {
            loader = loader_B,
            chest = chest_B,
            type = (type == defines.item_direction.push) and "output" or "input",
            ref = {surface_name_A, loader_index_A}
        }
    end
end

local function upgrade_stairs()
    for surface_name, loader_pair in pairs(storage.stairs.chest_loader_pairs) do
        for index, stairs in pairs(loader_pair) do
            local loader = stairs.loader
            local surface = stairs.loader.surface
            local new_loader = surface.create_entity{
                name = storage.stairs.loader_tier,
                position = loader.position,
                force = game.forces.player,
                direction = loader.direction,
                type = loader.loader_type,
                fast_replace = true,
            }
            new_loader.destructible = false
            storage.stairs.chest_loader_pairs[surface_name][index].loader = new_loader
        end
    end
end

local function update_chests()
    for surface_name, loader_pair in pairs(storage.stairs.chest_loader_pairs) do
        for index, stairs in pairs(loader_pair) do
            local chest = stairs.chest
            local surface = stairs.chest.surface

            -- find the index of the chest pair
            local chest_index = surface_name .. '_' .. chest.position.x .. '_' .. chest.position.y
            local chest_pair_index = "A"
            local chest_name = ""
            if not storage.stairs.chest_pairs[chest_index] then
                -- the current pair is not the "A" chest, so check from the pair ref
                local pair_chest = storage.stairs.chest_loader_pairs[stairs.ref[1]][stairs.ref[2]].chest
                local chest_surface_name = pair_chest.surface.name
                chest_surface_name = dw.safe_surfaces[chest_surface_name] and chest_surface_name or "surface"
                chest_index = chest_surface_name .. '_' .. pair_chest.position.x .. '_' .. pair_chest.position.y
                chest_pair_index = "B"

                -- here it means we are the "destination" of the item direction, so we need to inverse the chest type
                local chest_type = storage.stairs.chest_pairs[chest_index].type
                chest_name = (chest_type == defines.item_direction.push) and storage.stairs.chest_type.output or storage.stairs.chest_type.input
            else
                local chest_type = storage.stairs.chest_pairs[chest_index].type
                chest_name = (chest_type == defines.item_direction.push) and storage.stairs.chest_type.input or storage.stairs.chest_type.output
            end

            -- upgrade the chest and store it in the globals
            local new_chest = surface.create_entity{
                name = chest_name,
                position = chest.position,
                force = game.forces.player,
                direction = chest.direction,
                fast_replace = true,
            }
            new_chest.destructible = false
            storage.stairs.chest_loader_pairs[surface_name][index].chest = new_chest
            storage.stairs.chest_pairs[chest_index][chest_pair_index] = new_chest
        end
    end
end


--- surface A should always be first surface in dw.stairs index name.
--- surface B should always be second surface in dw.stairs index name.
--- order matters as it's used for the storage
local function create_pipe_pairs(surface_A, surface_B, positions)
    local surface_name_A = dw.safe_surfaces[surface_A.name] and surface_A.name or "surface"

    local max = math.min(#positions, storage.stairs.chest_number)
    for i = 1, max, 1 do
        local pipe_index = surface_name_A .. '_' .. positions[i].pipes[1][1] .. '_' .. positions[i].pipes[1][2]

        if storage.stairs.pipe_pairs[pipe_index] then goto continue end

        --- destroy what's existing in pipe position
        local to_remove = surface_A.find_entities_filtered {position = positions[i].pipes[1], type = {"character"}, invert = true}
        for _, entity in pairs(to_remove) do entity.destroy() end
        local pipe_A = surface_A.create_entity {
            name = storage.stairs.pipes_type,
            position = positions[i].pipes[1],
            force = game.forces.player,
            direction = (i % 2 == 0) and defines.direction.east or defines.direction.west,
        }
        pipe_A.destructible = false

        local to_remove = surface_B.find_entities_filtered {position = positions[i].pipes[2], type = {"character"}, invert = true}
        for _, entity in pairs(to_remove) do entity.destroy() end
        local pipe_B = surface_B.create_entity {
            name = storage.stairs.pipes_type,
            position = positions[i].pipes[2],
            force = game.forces.player,
            direction = (i % 2 == 0) and defines.direction.east or defines.direction.west,
        }
        pipe_B.destructible = false

        pipe_A.fluidbox.add_linked_connection(0, pipe_B, 0)
        storage.stairs.pipe_pairs[pipe_index] = {A = pipe_A, B = pipe_B}
        ::continue::
    end
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

    create_loader_chest_pair(storage.warp.current.surface, storage.platform.factory.surface, dw.stairs.surface_factory)
    create_pipe_pairs(storage.warp.current.surface, storage.platform.factory.surface, dw.stairs.surface_factory)
end

local function create_factory_mining_teleporters_logistic()
    local gate_1 = create_special_entity(storage.platform.mining.surface, dw.entities.gate_mining_factory, true)
    local gate_2 = create_special_entity(storage.platform.factory.surface, dw.entities.gate_factory_mining, true)
    utils.link_gates("mining-to-factory", "factory-to-mining", gate_1, gate_2)
    utils.link_cables(gate_1, gate_2, defines.wire_connectors.logic)

    local pole_1 = create_special_entity(storage.platform.factory.surface, dw.entities.pole_factory_mining)
    local pole_2 = create_special_entity(storage.platform.mining.surface, dw.entities.pole_mining_factory)
    utils.link_cables(pole_1, pole_2, defines.wire_connectors.power)

    create_loader_chest_pair(storage.platform.factory.surface, storage.platform.mining.surface, dw.stairs.factory_mining)
    create_pipe_pairs(storage.platform.factory.surface, storage.platform.mining.surface, dw.stairs.factory_mining)
end

local function create_mining_power_teleporters_logistic()
    local gate_1 = create_special_entity(storage.platform.power.surface, dw.entities.gate_power_mining, true)
    local gate_2 = create_special_entity(storage.platform.mining.surface, dw.entities.gate_mining_power, true)
    utils.link_gates("power-to-mining", "mining-to-power", gate_1, gate_2)
    utils.link_cables(gate_1, gate_2, defines.wire_connectors.logic)

    local pole_1 = create_special_entity(storage.platform.mining.surface, dw.entities.pole_mining_power)
    local pole_2 = create_special_entity(storage.platform.power.surface, dw.entities.pole_power_mining)
    utils.link_cables(pole_1, pole_2, defines.wire_connectors.power)

    create_loader_chest_pair(storage.platform.mining.surface, storage.platform.power.surface, dw.stairs.mining_power)
    create_pipe_pairs(storage.platform.mining.surface, storage.platform.power.surface, dw.stairs.mining_power)
end


local function init_update_power_platform()
    if not storage.platform.power.surface then
        storage.platform.power.surface = init_surface('electria')
        create_mining_power_teleporters_logistic()
    end

    local tiles = {}
    local size = storage.platform.power.size

    local horizontal_top_left = {-size, -size / 3}
    local horizontal_bottom_right = {size - 1, (size / 3) - 1}

    local vertical_top_left = {-size / 3, -size}
    local vertical_bottom_right = {(size / 3) - 1, size - 1}
    utils.add_tiles(tiles, "energy-platform", horizontal_top_left, horizontal_bottom_right)
    utils.add_tiles(tiles, "energy-platform", vertical_top_left, vertical_bottom_right)
    storage.platform.power.surface.set_tiles(tiles)
    utils.put_warning_tiles(storage.platform.power.surface, dw.hazard_tiles.power)
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
    utils.put_warning_tiles(storage.platform.mining.surface, dw.hazard_tiles.mining)
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
    utils.put_warning_tiles(storage.platform.factory.surface, dw.hazard_tiles.factory)
end


local function on_technology_research_finished(event)
    local tech = event.research

    if string.match(tech.name, "dw%-.*%-loader%-stairs") then
        local loader = string.match(tech.name, "dw%-(.*)%-stairs")
        if loader then
            storage.stairs.loader_tier = "dw-stair-" .. loader
            upgrade_stairs()
        end
    end

    if string.match(tech.name, "dw%-number%-stairs%-.*") then
        storage.stairs.chest_number = storage.stairs.chest_number + 2
        create_loader_chest_pair(storage.platform.factory.surface, storage.platform.mining.surface, dw.stairs.factory_mining)
        create_loader_chest_pair(storage.platform.mining.surface, storage.platform.power.surface, dw.stairs.mining_power)
        create_loader_chest_pair(storage.warp.current.surface, storage.platform.factory.surface, dw.stairs.surface_factory)
        create_pipe_pairs(storage.platform.factory.surface, storage.platform.mining.surface, dw.stairs.factory_mining)
        create_pipe_pairs(storage.platform.mining.surface, storage.platform.power.surface, dw.stairs.mining_power)
        create_pipe_pairs(storage.warp.current.surface, storage.platform.factory.surface, dw.stairs.surface_factory)
    end

    if string.match(tech.name, "dw%-stair%-logistic%-chest") then
        storage.stairs.chest_type.input = "dw-logistic-input"
        storage.stairs.chest_type.output = "dw-logistic-output"
        update_chests()
    end

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

    if string.match(tech.name, "factory%-platform") then
        storage.platform.factory.size = dw.platform_size.factory[1]
        init_update_factory_platform()
    end
    if string.match(tech.name, "mining%-platform") then
        storage.platform.mining.size = dw.platform_size.mining[1]
        init_update_mining_platform()
    end
    if string.match(tech.name, "power%-platform") then
        storage.platform.power.size = dw.platform_size.power[1]
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

    if string.match(tech.name, "dimension%-harvester%-%a+%-%d+") then
        storage.harvester.side.size = dw.platform_size.harvester[tech.level]
        storage.harvester.side.border = math.max((tech.level - 1), 2)
    end
end

local function transfert_chest_content(inventory_from, inventory_to)
    for i = 1, #inventory_from do
        local stack = inventory_from[i]
        if stack.valid_for_read then
            local inserted = inventory_to.insert(stack)
            if inserted > 0 then
                stack.count = stack.count - inserted
            end
        end
    end
end

local function move_chest_items()
    for k, chest_pair in pairs(storage.stairs.chest_pairs) do
        local chest_A = chest_pair.A
        local chest_B = chest_pair.B
        if chest_A and chest_B and chest_A.valid and chest_B.valid then
            local inventory_A = chest_A.get_inventory(defines.inventory.chest)
            local inventory_B = chest_B.get_inventory(defines.inventory.chest)
            if chest_pair.type == defines.item_direction.push then
                transfert_chest_content(inventory_A, inventory_B)
            else
                transfert_chest_content(inventory_B, inventory_A)
            end
        end
    end
end

local function invert_chest_flow(event)
    local entity = event.entity
    if string.match(entity.name, "dw%-stair%-loader") or string.match(entity.name, "dw%-stair%-%a+%-loader") then
        local surface_name = dw.safe_surfaces[entity.surface.name] and entity.surface.name or "surface"
        local index = surface_name .. '_' .. entity.position.x .. '_' .. entity.position.y
        if storage.stairs.chest_loader_pairs[surface_name][index] then
            local pair_A = storage.stairs.chest_loader_pairs[surface_name][index]
            local pair_B = storage.stairs.chest_loader_pairs[pair_A.ref[1]][pair_A.ref[2]]

            --- invert loaders
            if pair_A.loader and pair_A.loader.valid then
                pair_A.loader.loader_type = pair_B.type
            end
            if pair_B.loader and pair_B.loader.valid then
                pair_B.loader.loader_type = pair_A.type
            end

            --- chest invertion, only do something if we have logistic chests
            if pair_A.chest.name ~= "dw-chest" then
                local chest_type = (pair_A.type == "input") and storage.stairs.chest_type.output or storage.stairs.chest_type.input
                local chest_A = pair_A.chest.surface.create_entity {
                    name = chest_type,
                    position = pair_A.chest.position,
                    force = pair_A.chest.force,
                    fast_replace = true
                }
                chest_A.destructible = false
                pair_A.chest = chest_A

                local chest_type = (pair_B.type == "input") and storage.stairs.chest_type.output or storage.stairs.chest_type.input
                local chest_B = pair_B.chest.surface.create_entity {
                    name = chest_type,
                    position = pair_B.chest.position,
                    force = pair_B.chest.force,
                    fast_replace = true
                }
                chest_B.destructible = false
                pair_B.chest = chest_B
            end

            --- find the corresponding chest pair
            local chest_index = surface_name .. '_' .. pair_A.chest.position.x .. '_' .. pair_A.chest.position.y
            if storage.stairs.chest_pairs[chest_index] then
                storage.stairs.chest_pairs[chest_index] = {
                    A = pair_A.chest,
                    B = pair_B.chest,
                    type = (pair_A.type == "input") and defines.item_direction.pull or defines.item_direction.push,
                }
            else
                local surface_name_B = dw.safe_surfaces[pair_B.chest.surface.name] and pair_B.chest.surface.name or "surface"
                local chest_index = surface_name_B .. '_' .. pair_B.chest.position.x .. '_' .. pair_B.chest.position.y
                if storage.stairs.chest_pairs[chest_index] then
                    storage.stairs.chest_pairs[chest_index] = {
                        A = pair_B.chest,
                        B = pair_A.chest,
                        type = (pair_A.type == "input") and defines.item_direction.push or defines.item_direction.pull,
                    }
                end
            end


            --- update the types
            local type = pair_A.type
            pair_A.type = pair_B.type
            pair_B.type = type
        end
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
dw.register_event("on_nth_tick_5", move_chest_items)
dw.register_event(defines.events.on_player_rotated_entity, invert_chest_flow)