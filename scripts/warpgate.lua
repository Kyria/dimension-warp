--- create entities using the position list, centered around "center"
local function create_entities_relative_to_position(surface, name, center, positions, direction, loader, entity_list)
    entity_list = entity_list or {}
    local entity_center = center.x and {center.x, center.y} or center
    local max_index = math.min(storage.warpgate.chest_number, #positions)
    for i = 1, max_index, 1 do
        local final_position = {entity_center[1] + positions[i][1], entity_center[2] + positions[i][2]}

        local to_remove = surface.find_entities_filtered {position = final_position, type = {"character"}, invert = true}
        if to_remove[1] then
            if to_remove[1].name ~= name or to_remove[1] ~= entity_list[i] then
                to_remove[1].destroy()
            else
                goto continue
            end
        end

        local entity = surface.create_entity {
            name = name,
            position = final_position,
            force = game.forces.player,
            direction = direction and direction or (i % 2 == 0) and defines.direction.east or defines.direction.west,
            type = loader,
        }
        entity.destructible = false

        entity_list[i] = entity

        ::continue::
    end
    return entity_list
end

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
        storage.stairs.chest_type.output,
        dw.warp_gate.position,
        dw.warp_gate.chests,
        defines.direction.north,
        nil,
        storage.warpgate.platform.chests
    )
    create_entities_relative_to_position(
        surface,
        storage.stairs.loader_tier,
        dw.warp_gate.position,
        dw.warp_gate.loaders,
        defines.loader_facting.bottom.output,
        "output",
        storage.warpgate.platform.loaders
    )
    create_entities_relative_to_position(
        surface,
        storage.stairs.pipes_type,
        dw.warp_gate.position,
        dw.warp_gate.pipes,
        nil,
        nil,
        storage.warpgate.platform.pipes
    )
end

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

local function gate_research(event)
    local tech = event.research

    if string.match(tech.name, "dw%-warp%-gate%-%d") then
        storage.warpgate.mobile_type = "mobile-gate-" .. tech.level
        if tech.level == 1 then
            create_warpgate()
            create_mobile_gate()
        end
    end

    if string.match(tech.name, "dw%-number%-stairs%-advanced") then
        storage.warpgate.chest_number = storage.warpgate.chest_number + 2
        if storage.warpgate.gate then
            create_warpgate()
        end
    end
end

local function mobile_gate_removed_killed(event)
    local gate = event.entity
    if not string.match(gate.name, "mobile%-gate%-%d") then return end

    local position = gate.position
    local surface = gate.surface
end

local function mobile_gate_placed(event)
    local gate = event.entity
    if not string.match(gate.name, "mobile%-gate%-%d") then return end

    if storage.warpgate.mobile_gate and storage.warpgate.mobile_gate.valid then
        storage.warpgate.mobile_gate.destroy{raise_destroy=true}
    end
    local gate = event.entity
    local surface = gate.surface
    local chests = create_entities_relative_to_position(
        surface,
        storage.stairs.chest_type.output,
        gate.position,
        dw.warp_gate.chests,
        defines.direction.north
    )
    local loaders = create_entities_relative_to_position(
        surface,
        storage.stairs.loader_tier,
        gate.position,
        dw.warp_gate.loaders,
        defines.loader_facting.bottom.input,
        "input"
    )
    local pipes = create_entities_relative_to_position(
        surface,
        storage.stairs.pipes_type,
        gate.position,
        dw.warp_gate.pipes
    )

    utils.link_gates("warp-gate-to-surface", "surface-to-warp-gate", storage.warpgate.gate, gate)
    storage.warpgate.mobile_gate = gate
end

dw.register_event(defines.events.on_research_finished, gate_research)
dw.register_event(defines.events.on_built_entity, mobile_gate_placed)
dw.register_event(defines.events.on_robot_built_entity, mobile_gate_placed)
dw.register_event(defines.events.script_raised_destroy, mobile_gate_removed_killed) -- triggered by destroy()
dw.register_event(defines.events.on_player_mined_entity, mobile_gate_removed_killed)
dw.register_event(defines.events.on_robot_mined_entity, mobile_gate_removed_killed)
dw.register_event(defines.events.on_entity_died, mobile_gate_removed_killed)
