--- create entities using the position list, centered around "center"
local function create_entities_relative_to_position(surface, entity_info, entity_list)
    local name = entity_info.name
    local center = entity_info.center
    local positions = entity_info.positions
    local direction = entity_info.direction
    local loader = entity_info.loader
    local mobile = entity_info.mobile
    local mobile_type = entity_info.mobile_type

    entity_list = entity_list or {}
    local entity_center = center.x and {center.x, center.y} or center
    local max_index = math.min(storage.warpgate.chest_number, #positions)
    for i = 1, max_index, 1 do
        local final_position = {entity_center[1] + positions[i][1], entity_center[2] + positions[i][2]}

        local to_remove = surface.find_entities_filtered {position = final_position, type = {"character"}, invert = true}
        if to_remove[1] then
            if to_remove[1].name ~= name then
                to_remove[1].destroy()
            else
                entity_list[i] = to_remove[1]
                goto continue
            end
        end

        -- if we deploy the mobile gate, check the equivalent in platform first and decide what to put
        if mobile then
            local static_loader_position = math2d.position.add(dw.warp_gate.loaders[i], storage.warpgate.gate.position)
            local index = "gate_" .. static_loader_position.x .. '_' .. static_loader_position.y
            local pair = storage.stairs.chest_loader_pairs.gate[index]

            if mobile_type == "chest" then
                if storage.stairs.chest_type.input ~= "dw-chest" then
                    name = (pair.type == "input") and storage.stairs.chest_type.output or storage.stairs.chest_type.input
                else
                    name = storage.stairs.chest_type.input
                end
            end
            if mobile_type == "loader" then
                loader = defines.opposite_loader[pair.type]
                direction = defines.loader_facing.bottom[loader]
            end
        end

        local entity = surface.create_entity {
            name = name,
            position = final_position,
            force = game.forces.player,
            direction = direction and direction or (i % 2 == 0) and defines.direction.east or defines.direction.west,
            type = loader,
            fast_replace = true,
        }
        entity.destructible = false

        -- transfer chest inventory if we saved one
        if mobile and mobile_type == "chest" then
            local index = positions[i][1] .. positions[i][2]
            if storage.warpgate.mobile_chests[index] then
                local inventory = entity.get_inventory(defines.inventory.chest)
                for stackindex = 1, #storage.warpgate.mobile_chests[index], 1 do
                    inventory.insert(storage.warpgate.mobile_chests[index][stackindex])
                end
                storage.warpgate.mobile_chests[index] = nil
            end
        end

        -- re-set loader filter if it existed
        if mobile and mobile_type == "loader" then
            local index = positions[i][1] .. positions[i][2]
            if storage.warpgate.mobile_loaders[index] then
                entity.loader_filter_mode = storage.warpgate.mobile_loaders[index].mode
                for filter_i = 1, #storage.warpgate.mobile_loaders[index].filters, 1 do
                    entity.set_filter(filter_i, storage.warpgate.mobile_loaders[index].filters[filter_i])
                end
                storage.warpgate.mobile_loaders[index] = nil
            end
        end

        entity_list[i] = entity

        ::continue::
    end
    return entity_list
end

local function link_warp_gate(mobile_chests, mobile_loaders, mobile_pipes, force_warpgate_link)
    local max_index = math.min(storage.warpgate.chest_number, #dw.warp_gate.chests)
    -- only use chest as max index, as we have same amount of each
    for i = 1, max_index, 1 do
        -- chests
        local platform_chest_position = math2d.position.add(dw.warp_gate.chests[i], storage.warpgate.gate.position)
        local chest_index = "gate_" .. platform_chest_position.x .. '_' .. platform_chest_position.y
        storage.stairs.chest_pairs[chest_index] = storage.stairs.chest_pairs[chest_index] or {}
        if force_warpgate_link then
            local type = storage.stairs.chest_pairs[chest_index] and storage.stairs.chest_pairs[chest_index].type or defines.item_direction.pull
            local chest_type = type == defines.item_direction.pull and storage.stairs.chest_type.output or storage.stairs.chest_type.input
            local chest = storage.warp.current.surface.find_entity(chest_type, platform_chest_position)
            storage.stairs.chest_pairs[chest_index].A = chest
            storage.stairs.chest_pairs[chest_index].type = type
        end
        storage.stairs.chest_pairs[chest_index].B = mobile_chests and mobile_chests[i]

        -- loader/chest
        local platform_loader_position = math2d.position.add(dw.warp_gate.loaders[i], storage.warpgate.gate.position)
        local loader_index_A = "gate_" .. platform_loader_position.x .. '_' .. platform_loader_position.y
        storage.stairs.chest_loader_pairs["gate"][loader_index_A] = storage.stairs.chest_loader_pairs["gate"][loader_index_A] or {}
        if force_warpgate_link then
            local loader_type = storage.stairs.chest_loader_pairs["gate"][loader_index_A].type or "output"
            local loader = storage.warp.current.surface.find_entity(storage.stairs.loader_tier, platform_loader_position)
            storage.stairs.chest_loader_pairs["gate"][loader_index_A] = {
                loader = loader,
                chest = storage.stairs.chest_pairs[chest_index].A,
                type = loader_type,
                ref = {"gate", i}
            }
        end

        if mobile_loaders and mobile_loaders[i] then
            local loader_index_B = "gate_" .. mobile_loaders[i].position.x .. '_' .. mobile_loaders[i].position.y
            storage.stairs.chest_loader_pairs["gate"][loader_index_A].ref = {"gate", loader_index_B}
            storage.stairs.chest_loader_pairs["gate"][loader_index_B] = {
                loader = mobile_loaders[i],
                chest = mobile_chests[i],
                type = mobile_loaders[i].loader_type,
                ref = {"gate", loader_index_A}
            }
        end

        -- pipes
        local platform_pipe_position = math2d.position.add(dw.warp_gate.pipes[i], storage.warpgate.gate.position)
        local pipe_index = 'gate_' .. platform_pipe_position.x .. '_' .. platform_pipe_position.y
        storage.stairs.pipe_pairs[pipe_index] = storage.stairs.pipe_pairs[pipe_index] or {}
        if force_warpgate_link then
            local pipe = storage.warp.current.surface.find_entity(storage.stairs.pipes_type, platform_pipe_position)
            storage.stairs.pipe_pairs[pipe_index].A = pipe
            storage.stairs.pipe_pairs[pipe_index].B = nil
        end

        storage.stairs.pipe_pairs[pipe_index].B = mobile_pipes and mobile_pipes[i]
        if storage.stairs.pipe_pairs[pipe_index].B then
            storage.stairs.pipe_pairs[pipe_index].A.fluidbox.add_linked_connection(0, storage.stairs.pipe_pairs[pipe_index].B, 0)
        end
    end
end
dw.link_warp_gate = link_warp_gate

local function create_warpgate()
    local surface = storage.warp.current.surface

    local area = {
        {dw.warp_gate.area[1][1] + dw.warp_gate.position[1], dw.warp_gate.area[1][2] + dw.warp_gate.position[2]},
        {dw.warp_gate.area[2][1] + dw.warp_gate.position[1], dw.warp_gate.area[2][2] + dw.warp_gate.position[2]}
    }
    local to_remove = surface.find_entities_filtered {area = area, type = {"character", "warp-gate"}, invert = true}
    for _, entity in pairs(to_remove) do entity.destroy() end

    local gate = surface.create_entity {
        name = dw.warp_gate.name,
        position = dw.warp_gate.position,
        force = game.forces.player,
        direction = defines.direction.north,
    }
    gate.destructible = false
    storage.warpgate.gate = gate

    create_entities_relative_to_position(
        surface,
        {
            name = storage.stairs.chest_type.output,
            center = dw.warp_gate.position,
            positions = dw.warp_gate.chests,
            direction = defines.direction.north,
            loader = nil,
        }
    )

    create_entities_relative_to_position(
        surface,
        {
            name = storage.stairs.loader_tier,
            center = dw.warp_gate.position,
            positions = dw.warp_gate.loaders,
            direction = defines.loader_facing.bottom.output,
            loader = "output",
        }
    )
    create_entities_relative_to_position(
        surface,
        {
            name = storage.stairs.pipes_type,
            center = dw.warp_gate.position,
            positions = dw.warp_gate.pipes,
            direction = nil,
            loader = nil,
        }
    )
    link_warp_gate(nil, nil, nil, true)

    local power_pole = surface.create_entity {
        name = "dw-hidden-gate-pole",
        position = dw.warp_gate.position,
        force = game.forces.player,
        direction = defines.direction.north,
    }
    power_pole.destructible = false
    storage.warpgate.gatepole = power_pole

    local radio_tower_pole = surface.find_entity(dw.entities.surface_radio_pole.name, dw.entities.surface_radio_pole.position)
    if radio_tower_pole and power_pole then
        utils.link_cables(power_pole, radio_tower_pole, defines.wire_connectors.power)
    end
end

--- create the mobile gate for the user to pick it after each warp / from shortcuts
local function create_mobile_gate()
    local position = storage.warp.current.surface.find_non_colliding_position(
        storage.warpgate.mobile_type,
        dw.warp_gate.position, 20, 1, true)
    if position then
        local mobile_gate = storage.warp.current.surface.create_entity{
            name = storage.warpgate.mobile_type,
            position = position,
            force = game.forces.player
        }
        utils.link_gates("warp-gate-to-surface", "surface-to-warp-gate", storage.warpgate.gate, mobile_gate)
        storage.warpgate.mobile_gate = mobile_gate
    end
end
dw.create_mobile_gate = create_mobile_gate

local function gate_research(event)
    local tech = event.research

    if string.match(tech.name, "dw%-warp%-gate%-%d") then
        storage.warpgate.mobile_type = "mobile-gate-" .. tech.level
        if tech.level == 1 then
            create_warpgate()
            create_mobile_gate()
        else
            -- the gate is deployed
            if storage.warpgate.mobile_gate and storage.warpgate.mobile_gate.valid then
                local mobile_gate = storage.warp.current.surface.create_entity{
                    name = storage.warpgate.mobile_type,
                    position = storage.warpgate.mobile_gate.position,
                    force = game.forces.player,
                    fast_replace = true,
                    spill = false
                }
                utils.link_gates("warp-gate-to-surface", "surface-to-warp-gate", storage.warpgate.gate, mobile_gate)
                utils.link_cables(storage.warpgate.gate, mobile_gate, defines.wire_connectors.logic)
                storage.warpgate.mobile_gate = mobile_gate
            end
            -- replace the gate in inventory if found in a player.
            for _, player in pairs(game.players) do
                local inventory = player.get_main_inventory()
                if inventory and not inventory.is_empty() then
                    for i = 1, #inventory, 1 do
                        if inventory[i].valid_for_read then
                            if string.match(inventory[i].name, "mobile%-gate%-%d") then
                                local new_gate = {name = storage.warpgate.mobile_type, count = inventory[i].count}
                                inventory[i].clear()
                                inventory.insert(new_gate)
                            end
                        end
                    end
                end
            end
        end
    end

    if string.match(tech.name, "dw%-number%-stairs%-advanced") then
        storage.warpgate.chest_number = storage.warpgate.chest_number + 2
        if storage.warpgate.gate then
            create_warpgate()
        end
    end
end

---Event the catch the destruction of mobile gate. Destruct all chests/loaders
---Save chests content for when a mobile gate is placed again
---@param event (EventData.script_raised_destroy|EventData.on_player_mined_entity|EventData.on_robot_mined_entity|EventData.on_entity_died)
local function mobile_gate_removed_killed(event)
    local gate = event.entity
    if not string.match(gate.name, "mobile%-gate%-%d") then return end

    local gate_pos = gate.position
    local surface = gate.surface

    local max_index = math.min(storage.warpgate.chest_number, #dw.warp_gate.chests)
    for i = 1, max_index, 1 do
        local position = dw.warp_gate.chests[i]
        local index = position[1] .. position[2]
        local chest = surface.find_entity(storage.stairs.chest_type.input, math2d.position.add(gate_pos, position))
        local chest = chest or surface.find_entity(storage.stairs.chest_type.output, math2d.position.add(gate_pos, position))
        if chest then
            local inventory = chest.get_inventory(defines.inventory.chest)
            if inventory and not inventory.is_empty() then
                storage.warpgate.mobile_chests[index] = {}
                for i = 1, #inventory, 1 do
                    if inventory[i].valid_for_read then
                        table.insert(storage.warpgate.mobile_chests[index], {
                            name = inventory[i].name,
                            type = inventory[i].type,
                            count = inventory[i].count,
                            health = inventory[i].health,
                            quality = inventory[i].quality,
                            spoil_tick = inventory[i].spoil_tick,
                            spoil_percent = inventory[i].spoil_percent,
                        })
                    end
                end
            end
            chest.destroy()
        end

        local position = dw.warp_gate.loaders[i]
        local index = position[1] .. position[2]
        local loader = surface.find_entity(storage.stairs.loader_tier, math2d.position.add(gate_pos, position))
        if loader then
            if loader.loader_filter_mode and loader.loader_filter_mode ~= "none" then
                storage.warpgate.mobile_loaders[index] = {mode=loader.loader_filter_mode, filters={}}
                for filter_i = 1, loader.filter_slot_count, 1 do
                    storage.warpgate.mobile_loaders[index].filters[filter_i] = loader.get_filter(filter_i)
                end
            end
            loader.destroy()
        end

        local position = dw.warp_gate.pipes[i]
        local pipe = surface.find_entity(storage.stairs.pipes_type, math2d.position.add(gate_pos, position))
        if pipe then pipe.destroy() end
    end

    local pole = surface.find_entity("dw-hidden-gate-pole", gate_pos)
    if pole then pole.destroy() end
end


---@param event (EventData.on_built_entity|EventData.on_robot_built_entity)
local function mobile_gate_placed(event)
    local gate = event.entity
    if not gate.valid then return end
    if not string.match(gate.name, "mobile%-gate%-%d") then return end
    if not utils.entity_built_surface_check(event, {[storage.warp.current.name]=true}, "dw-messages.cannot-build-mobile-gate") then return end

    if storage.warpgate.mobile_gate and storage.warpgate.mobile_gate.valid then
        -- manually destroy it and remove all components, so we are sure to do it before next steps
        storage.warpgate.mobile_gate.destroy{raise_destroy=true}
    end


    -- if the player uses an outdate version for whatever reason, replace with the right one
    if gate.name ~= storage.warpgate.mobile_type then
        gate = storage.warp.current.surface.create_entity{
            name = storage.warpgate.mobile_type,
            position = gate.position,
            force = game.forces.player,
            fast_replace = true,
            spill = false
        }
        -- update entity otherwise it will break other event handlers
        event.entity = gate
    end

    local surface = gate.surface

    storage.warpgate.mobile_gate = gate

    local mobile_chests = create_entities_relative_to_position(
        surface,
        {
            name = nil,
            center = gate.position,
            positions = dw.warp_gate.chests,
            direction = defines.direction.north,
            loader = nil,
            mobile_type = "chest",
            mobile = true,
        }
    )
    local mobile_loaders = create_entities_relative_to_position(
        surface,
        {
            name = storage.stairs.loader_tier,
            center = gate.position,
            positions = dw.warp_gate.loaders,
            direction = nil,
            loader = nil,
            mobile_type = "loader",
            mobile = true,
        }
    )
    local mobile_pipes = create_entities_relative_to_position(
        surface,
        {
            name = storage.stairs.pipes_type,
            center = gate.position,
            positions = dw.warp_gate.pipes,
            direction = nil,
            loader = nil,
            mobile = true,
        }
    )

    local power_pole = surface.create_entity {
        name = "dw-hidden-gate-pole",
        position = gate.position,
        force = game.forces.player,
        direction = defines.direction.north,
    }
    power_pole.destructible = false

    if storage.warpgate.gatepole and power_pole then
        utils.link_cables(power_pole, storage.warpgate.gatepole, defines.wire_connectors.power)
    end

    utils.link_gates("warp-gate-to-surface", "surface-to-warp-gate", storage.warpgate.gate, gate)
    utils.link_cables(storage.warpgate.gate, gate, defines.wire_connectors.logic)

    storage.warpgate.mobile_gate = gate
    link_warp_gate(mobile_chests, mobile_loaders, mobile_pipes)
end

dw.register_event(defines.events.on_research_finished, gate_research)
dw.register_event(defines.events.on_built_entity, mobile_gate_placed)
dw.register_event(defines.events.on_robot_built_entity, mobile_gate_placed)
dw.register_event(defines.events.script_raised_destroy, mobile_gate_removed_killed) -- triggered by destroy()
dw.register_event(defines.events.on_player_mined_entity, mobile_gate_removed_killed)
dw.register_event(defines.events.on_robot_mined_entity, mobile_gate_removed_killed)
dw.register_event(defines.events.on_entity_died, mobile_gate_removed_killed)

