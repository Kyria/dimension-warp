dw.platforms = dw.platforms or {}

local function lay_hidden_ore(area)
    for i = area.left_top.x, area.right_bottom.x, 1 do
        for j = area.left_top.y, area.right_bottom.y, 1 do
            local position = {i, j}
            storage.platform.mining.surface.create_entity{
                name = "dw-hidden-ore",
                position = position,
                amount = 1,
            }
        end
    end
end

local function create_update_pipes_loaders(side)
    local harvester_const = dw.harvesters[side]
    local harvester = storage.harvesters[side]
    local inner_surface = harvester.deployed and storage.warp.current.surface or storage.platform.mining.surface

    local inner_x = harvester_const.center[1] + ((side == "left") and (harvester.size / 2 - 0.5) or (-harvester.size / 2 + 0.5))
    local outer_x = inner_x + ((side == "left") and 2 or -2)

    -- loaders between harvester and mining platform
    for i = 1, storage.harvesters.loaders, 1 do
        local inner_position = {x = inner_x, y = dw.harvesters.loader_y[i]}
        local outer_position = {x = outer_x, y = dw.harvesters.loader_y[i]}

        if harvester.deployed then
            inner_position = math2d.position.subtract(inner_position, harvester_const.center)
            inner_position = math2d.position.add(inner_position, harvester.mobile.position)
        end

        if harvester.loaders[i] then
            local inner_loader = harvester.loaders[i][1]
            local outer_loader = harvester.loaders[i][2]
            -- check for position
            if outer_loader.position.x ~= outer_position.x then
                local to_remove = outer_loader.surface.find_entities_filtered {position = outer_position, type = {"character"}, invert = true}
                for _, entity in pairs(to_remove) do entity.destroy() end

                local new_outer = outer_loader.clone{
                    position = outer_position,
                    surface = outer_loader.surface,
                    force = game.forces.player
                }
                outer_loader.destroy()
                outer_loader = new_outer
            end
            if inner_loader.position.x ~= inner_position.x then
                local to_remove = inner_loader.surface.find_entities_filtered {position = inner_position, type = {"character"}, invert = true}
                for _, entity in pairs(to_remove) do entity.destroy() end

                local new_inner = inner_loader.clone{
                    position = inner_position,
                    surface = inner_loader.surface,
                    force = game.forces.player
                }
                inner_loader.destroy()
                inner_loader = new_inner
            end

            -- check for tier
            if outer_loader.name ~= storage.harvesters.loader_tier then
                local new_outer = storage.platform.mining.surface.create_entity{
                    name = storage.harvesters.loader_tier,
                    position = outer_position,
                    direction = outer_loader.direction,
                    force = game.forces.player,
                    fast_replace = true,
                    spill = false,
                }
                outer_loader = new_outer
            end

            if inner_loader.name ~= storage.harvesters.loader_tier then
                local new_inner = inner_surface.create_entity{
                    name = storage.harvesters.loader_tier,
                    position = inner_position,
                    direction = inner_loader.direction,
                    force = game.forces.player,
                    fast_replace = true,
                    spill = false,
                }
                inner_loader = new_inner
            end

            -- force all links, in case anything changed
            inner_loader.destructible = false
            outer_loader.destructible = false
            harvester.loaders[i][1] = inner_loader
            harvester.loaders[i][2] = outer_loader
            inner_loader.connect_linked_belts(outer_loader)

        else
            local to_remove = inner_surface.find_entities_filtered {position = inner_position, type = {"character"}, invert = true}
            for _, entity in pairs(to_remove) do entity.destroy() end
            local to_remove = storage.platform.mining.surface.find_entities_filtered {position = outer_position, type = {"character"}, invert = true}
            for _, entity in pairs(to_remove) do entity.destroy() end


            local inner_loader = inner_surface.create_entity{
                name = storage.harvesters.loader_tier,
                position = inner_position,
                direction = defines.loader_facing[(side == "left") and "right" or "left"].input,
                force = game.forces.player
            }

            local outer_loader = storage.platform.mining.surface.create_entity{
                name = storage.harvesters.loader_tier,
                position = outer_position,
                direction = defines.loader_facing[(side == "left") and "left" or "right"].output,
                force = game.forces.player
            }

            inner_loader.destructible = false
            outer_loader.destructible = false
            harvester.loaders[i] = {inner_loader, outer_loader}
            inner_loader.linked_belt_type = "input"
            outer_loader.linked_belt_type = "output"
            inner_loader.connect_linked_belts(outer_loader)
        end
    end

    -- pipes

    local inner_position = {x = inner_x, y = dw.harvesters.pipe_y}
    local outer_position = {x = outer_x, y = dw.harvesters.pipe_y}

    if harvester.deployed then
        inner_position = math2d.position.subtract(inner_position, harvester_const.center)
        inner_position = math2d.position.add(inner_position, harvester.mobile.position)
    end

    if not harvester.pipe then
        local to_remove = inner_surface.find_entities_filtered {position = inner_position, type = {"character"}, invert = true}
        for _, entity in pairs(to_remove) do entity.destroy() end
        local to_remove = storage.platform.mining.surface.find_entities_filtered {position = outer_position, type = {"character"}, invert = true}
        for _, entity in pairs(to_remove) do entity.destroy() end

        local inner_pipe = inner_surface.create_entity {
            name = storage.harvesters.pipes_type,
            position = inner_position,
            direction = ((side == "left") and defines.direction.west or defines.direction.east),
            force = game.forces.player,
        }
        local outer_pipe = inner_surface.create_entity {
            name = storage.harvesters.pipes_type,
            position = outer_position,
            direction = ((side == "left") and defines.direction.east or defines.direction.west),
            force = game.forces.player,
        }
        inner_pipe.destructible = false
        outer_pipe.destructible = false
        inner_pipe.fluidbox.add_linked_connection(0, outer_pipe, 0)
        harvester.pipe = {inner_pipe, outer_pipe}
    else

        local inner_pipe = harvester.pipe[1]
        local outer_pipe = harvester.pipe[2]
        if outer_pipe.position.x ~= outer_position.x then
            local to_remove = outer_pipe.surface.find_entities_filtered {position = outer_position, type = {"character"}, invert = true}
            for _, entity in pairs(to_remove) do entity.destroy() end

            local new_outer = outer_pipe.clone{
                position = outer_position,
                surface = outer_pipe.surface,
                force = game.forces.player
            }
            outer_pipe.destroy()
            outer_pipe = new_outer
        end
        if inner_pipe.position.x ~= inner_position.x then
            local to_remove = inner_pipe.surface.find_entities_filtered {position = inner_position, type = {"character"}, invert = true}
            for _, entity in pairs(to_remove) do entity.destroy() end

            local new_inner = inner_pipe.clone{
                position = inner_position,
                surface = inner_pipe.surface,
                force = game.forces.player
            }
            inner_pipe.destroy()
            inner_pipe = new_inner
        end

        inner_pipe.destructible = false
        outer_pipe.destructible = false
        inner_pipe.fluidbox.add_linked_connection(0, outer_pipe, 0)
        harvester.pipe = {inner_pipe, outer_pipe}
    end
end

local function place_harvester_tiles(side)
    local harvester_const = dw.harvesters[side]
    local harvester = storage.harvesters[side]

    local harvester_area = math2d.bounding_box.create_from_centre(harvester_const.center, harvester.size - 1)
    local warn_area = math2d.bounding_box.create_from_centre(harvester_const.center, harvester.size + 1)
    local side_area = math2d.bounding_box.create_from_centre(harvester_const.center, harvester.size + 1 + harvester.border * 2)
    local path_area = {
        {harvester_const.center[1] - harvester.border, harvester_const.center[2] - harvester.border},
        {side == "left" and (-storage.platform.mining.size.x / 2) or (storage.platform.mining.size.x / 2), harvester.border - 1}
    }

    local tiles = {}
    utils.add_tiles(tiles, "mining-platform", path_area[1], path_area[2])
    utils.add_tiles(tiles, "mining-platform", side_area.left_top, side_area.right_bottom)
    utils.add_tiles(tiles, "dimension-harvester-hazard", warn_area.left_top, warn_area.right_bottom)
    utils.add_tiles(tiles, "harvester-platform", harvester_area.left_top, harvester_area.right_bottom)
    storage.platform.mining.surface.set_tiles(tiles)
end
dw.platforms.place_harvester_tiles = place_harvester_tiles

local function create_harvester_zone(side)
    local harvester_const = dw.harvesters[side]
    local harvester = storage.harvesters[side]
    local harvester_area = math2d.bounding_box.create_from_centre(harvester_const.center, harvester.size - 1)

    place_harvester_tiles(side)
    lay_hidden_ore(harvester_area)

    if not harvester.gate then
        local harvester_gate = storage.platform.mining.surface.create_entity{
            name = harvester_const.name,
            position = harvester_const.center,
            force = game.forces.player,
        }
        harvester_gate.destructible = false
        local pole = storage.platform.mining.surface.create_entity{
            name = harvester_const.pole,
            position = harvester_const.center,
            force = game.forces.player,
        }
        pole.destructible = false
        harvester.gate = harvester_gate
        harvester.pole = pole
    end

    -- as we update the size, if it's deployed we need to update the overlay and area
    if harvester.deployed then
        harvester.rectangle.destroy()
        local draw_area = math2d.bounding_box.create_from_centre(harvester.mobile.position, harvester.size)
        harvester.rectangle = rendering.draw_rectangle{
            color = util.color('#69351010'),
            left_top = draw_area.left_top,
            right_bottom = draw_area.right_bottom,
            surface = storage.warp.current.surface,
            only_in_alt_mode = true,
            draw_on_ground = true,
            filled = true
        }
        harvester.area = math2d.bounding_box.create_from_centre(harvester.mobile.position, harvester.size - 1)
    end

    create_update_pipes_loaders(side)
end

--- Link the pipe and loaders deployed in surface to the one in Smeltus
local function link_harvester_pipe_chest(side)
    local harvester_const = dw.harvesters[side]
    local harvester = storage.harvesters[side]
    local surface = harvester.deployed and storage.warp.current.surface or storage.platform.mining.surface
    local inner_x = harvester_const.center[1] + ((side == "left") and (harvester.size / 2 - 0.5) or (-harvester.size / 2 + 0.5))

    -- loader link
    for i = 1, storage.harvesters.loaders, 1 do
        local inner_position = {inner_x, dw.harvesters.loader_y[i]}
        if harvester.deployed then
            inner_position = math2d.position.subtract(inner_position, harvester_const.center)
            inner_position = math2d.position.add(inner_position, harvester.mobile.position)
        end

        if harvester.loaders[i] then
            local loader = surface.find_entity(storage.harvesters.loader_tier, inner_position)
            if loader then
                loader.connect_linked_belts(harvester.loaders[i][2])
                harvester.loaders[i][1] = loader
                loader.destructible = false
            end
        end
    end

    -- pipe link
    local inner_position = {inner_x, dw.harvesters.pipe_y}
    if harvester.deployed then
        inner_position = math2d.position.subtract(inner_position, harvester_const.center)
        inner_position = math2d.position.add(inner_position, harvester.mobile.position)
    end

    if harvester.pipe then
        local pipe = surface.find_entity(storage.harvesters.pipes_type, inner_position)
        if pipe then
            pipe.fluidbox.add_linked_connection(0, harvester.pipe[2], 0)
            harvester.pipe[1] = pipe
            pipe.destructible = false
        end
    end

end

local function recall_harvester(side)
    if not storage.harvesters[side].deployed then return end
    local surface = storage.warp.current.surface
    local deployed_area = storage.harvesters[side].area
    local deployed_center = storage.harvesters[side].mobile.position

    -- remove entities we don't want to teleport back
    storage.harvesters[side].rectangle.destroy()
    storage.harvesters[side].mobile_pole.destroy()

    -- find all entities we want to teleport back to harvester zone
    local harvester_entities = surface.find_entities_filtered {
        type = {"locomotive", "cargo-wagon", "fluid-wagon", "artillery-wagon",
                "car", "spider-vehicle", "player", "character", "radar", "resource"},
        area = deployed_area,
        invert = true,
    }

    local destination_offset = math2d.position.subtract(dw.harvesters[side].center, deployed_center)
    storage.platform.mining.surface.clone_entities{
        entities = harvester_entities,
        destination_surface = storage.platform.mining.surface,
        destination_offset = destination_offset
    }

    -- remove the entities
    for _, h_entity in pairs(harvester_entities) do
        h_entity.destroy()
    end

    storage.harvesters[side].mobile.destroy()
    storage.harvesters[side].deployed = false
    link_harvester_pipe_chest(side)
end
dw.platforms.recall_harvester = recall_harvester

local function harvester_placed(event)
    local harvester_grid = event.entity
    if not harvester_grid or harvester_grid and not harvester_grid.valid then return end
    if not string.match(harvester_grid.name, "harvester%-%a+%-grid%-%d") then return end
    if not utils.entity_built_surface_check(event, {[storage.warp.current.name]=true}, "dw-messages.cannot-build-harvester") then return end

    local position = event.entity.position
    local surface = storage.warp.current.surface
    local side = string.match(harvester_grid.name, "harvester%-(%a+)%-grid%-%d")

    -- check area before anything else
    local check_area = math2d.bounding_box.create_from_centre(position, storage.harvesters[side].size)
    if utils.check_deployable_collision(check_area, defines.deployable_collision_source[side .. "_harvester"]) then
        utils.spill_or_return_item(event)
        utils.create_flying_text{
            position = harvester_grid.position,
            surface = harvester_grid.surface,
            text = {"dw-messages.harvester-deployable-collision"},
            color = util.color(defines.hexcolor.orangered.. 'd9')
        }
        harvester_grid.destroy()
        return
    end

    harvester_grid.destroy()

    if storage.harvesters[side].deployed then return end

    -- if we are here, all lights are green to deploy a harvester
    local harvester = surface.create_entity{
        name = dw.harvesters[side].mobile_name,
        position = position,
        force = game.forces.player,
    }
    harvester.destructible = false

    local draw_area = math2d.bounding_box.create_from_centre(position, storage.harvesters[side].size)
    local render = rendering.draw_rectangle{
        color = util.color('#69351010'),
        left_top = draw_area.left_top,
        right_bottom = draw_area.right_bottom,
        surface = surface,
        only_in_alt_mode = true,
        draw_on_ground = true,
        filled = true
    }

    local deployed_area = math2d.bounding_box.create_from_centre(position, storage.harvesters[side].size - 1)
    local harvester_area = math2d.bounding_box.create_from_centre(dw.harvesters[side].center, storage.harvesters[side].size - 1)
    local harvester_entities = storage.platform.mining.surface.find_entities_filtered {
        type = {"locomotive", "cargo-wagon", "fluid-wagon", "artillery-wagon", "car", "spider-vehicle", "player", "character", "radar", "resource"},
        area = harvester_area,
        invert = true,
    }

    for index, h_entity in pairs(harvester_entities) do
        if h_entity.name == dw.harvesters[side].pole then
            table.remove(harvester_entities, index)
        end
    end

    local destination_offset = math2d.position.subtract(position, dw.harvesters[side].center)
    storage.platform.mining.surface.clone_entities{
        entities = harvester_entities,
        destination_surface = surface,
        destination_offset = destination_offset
    }

    for _, h_entity in pairs(harvester_entities) do
        h_entity.destroy()
    end

    local pole = surface.create_entity{
        name = dw.harvesters[side].pole,
        position = position,
        force = game.forces.player,
    }
    pole.destructible = false


    storage.harvesters[side].rectangle = render
    storage.harvesters[side].area = deployed_area
    storage.harvesters[side].mobile = harvester
    storage.harvesters[side].mobile_pole = pole
    storage.harvesters[side].mobile_pole.destructible = false
    storage.harvesters[side].deployed = true
    utils.link_cables(storage.harvesters[side].mobile_pole, storage.harvesters[side].pole, defines.wire_connectors.power)
    utils.link_cables(storage.harvesters[side].mobile, storage.harvesters[side].gate, defines.wire_connectors.logic)
    utils.link_gates("harvester-" .. side .. "-to-surface", "surface-to-harvester-" .. side, storage.harvesters[side].gate, storage.harvesters[side].mobile)
    link_harvester_pipe_chest(side)
end

local function replace_mined_item(side, event)
    if event.name == defines.events.script_raised_destroy then return end
    local mobile_gate = 'harvester-' .. side .. '-mobile-gate'
    local buffer = event.buffer
    for i = 1, #buffer, 1 do
        if buffer[i].valid_for_read then
            if buffer[1] and buffer[1].name == mobile_gate then
                local new_gate = {name = storage.harvesters[side].mobile_name,count = buffer[i].count}
                buffer[i].clear()
                buffer.insert(new_gate)
            end
        end
    end
end

local function harvester_mined(event)
    local entity = event.entity
    local name = entity.name
    if not entity or entity and not entity.valid then return end

    if entity.valid and string.match(name, "harvester%-%a+%-mobile%-gate") then
        local side = string.match(name, "harvester%-(%a+)%-mobile%-gate")
        recall_harvester(side)
        replace_mined_item(side, event)
    end

    if entity.valid and string.match(name, "harvester%-%a+%-gate") then
        local side = string.match(name, "harvester%-(%a+)%-gate")
        local new_gate = entity.surface.find_entity(name, entity.position)
        new_gate.destructible = false
        storage.harvesters[side].gate = new_gate
        recall_harvester(side)
        replace_mined_item(side, event)
    end

end

local function replace_harvester_inventory(side)
    for _, player in pairs(game.players) do
        local inventory = player.get_main_inventory()
        if inventory and not inventory.is_empty() then
            for i = 1, #inventory, 1 do
                if inventory[i].valid_for_read then
                    if string.match(inventory[i].name, "harvester%-" .. side .. "%-grid%-%d") then
                        local new_harvester = {name = storage.harvesters[side].mobile_name, count = inventory[i].count}
                        inventory[i].clear()
                        inventory.insert(new_harvester)
                    end
                end
            end
        end
    end
end

local function on_technology_research_finished(event)
    local tech = event.research
    if string.match(tech.name, "dimension%-harvester%-%a+%-%d+") then
        local side = string.match(tech.name, "dimension%-harvester%-(%a+)%-%d+")
        if side then
            recall_harvester(side)
            storage.harvesters[side].size = dw.platform_size.harvester[tech.level]
            storage.harvesters[side].border = math.max((tech.level - 1), 3)
            storage.harvesters[side].mobile_name = "harvester-" .. side .. "-grid-" .. tech.level
            create_harvester_zone(side)
            replace_harvester_inventory(side)
        end
    end
    if string.match(tech.name, "dw%-number%-stairs%-.*") then
        storage.harvesters.loaders = storage.harvesters.loaders + 1
        if storage.harvesters.left.gate then create_update_pipes_loaders("left") end
        if storage.harvesters.right.gate then create_update_pipes_loaders("right") end

    end
    if string.match(tech.name, "dw%-.*%-loader%-stairs") then
        local tier = string.match(tech.name, "dw%-(.*)%-loader%-stairs")
        if tier then
            storage.harvesters.loader_tier = "harvest-" .. tier .. "-linked-belt"
            if storage.harvesters.left.gate then create_update_pipes_loaders("left") end
            if storage.harvesters.right.gate then create_update_pipes_loaders("right") end
        end
    end
end

local function invert_belt_from_belt(belt)
    for _, linked_pair in pairs(storage.harvesters['left'].loaders) do
        if linked_pair[1] == belt or linked_pair[2] == belt then
            local belt_type = linked_pair[1].linked_belt_type
            linked_pair[1].connect_linked_belts(nil)
            linked_pair[1].linked_belt_type = linked_pair[2].linked_belt_type
            linked_pair[2].linked_belt_type = belt_type
            linked_pair[1].connect_linked_belts(linked_pair[2])
            return
        end
    end

    for _, linked_pair in pairs(storage.harvesters['right'].loaders) do
        if linked_pair[1] == belt or linked_pair[2] == belt then
            local belt_type = linked_pair[1].linked_belt_type
            linked_pair[1].connect_linked_belts(nil)
            linked_pair[1].linked_belt_type = linked_pair[2].linked_belt_type
            linked_pair[2].linked_belt_type = belt_type
            linked_pair[1].connect_linked_belts(linked_pair[2])
            return
        end
    end
end

local function rotate_linked_belt(event)
    local entity = event.entity
    if not entity.valid then return end

    if string.match(entity.name, "harvest.*linked%-belt") then
        entity.direction = event.previous_direction
        invert_belt_from_belt(entity)
    end
end

local function flipped_linked_belt(event)
    local entity = event.entity
    if not entity.valid then return end

    if string.match(entity.name, "harvest.*linked%-belt") then
        if event.horizontal then
            entity.direction = util.oppositedirection(entity.direction)
        end
        invert_belt_from_belt(entity)
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)

dw.register_event(defines.events.on_built_entity, harvester_placed)
dw.register_event(defines.events.on_robot_built_entity, harvester_placed)
dw.register_event(defines.events.script_raised_revive, harvester_placed) -- need to catch this events, if a mod create the ghost

dw.register_event(defines.events.on_player_mined_entity, harvester_mined)
dw.register_event(defines.events.on_robot_mined_entity, harvester_mined)
dw.register_event(defines.events.script_raised_destroy, harvester_mined) -- need to catch this events, if a mod delete the item

dw.register_event(defines.events.on_player_flipped_entity, flipped_linked_belt)
dw.register_event(defines.events.on_player_rotated_entity, rotate_linked_belt)