--- Teleport mechanics are all here
------------------------------------------------------------

non_player_controllers = {
    [defines.controllers.god] = true,
    [defines.controllers.editor] = true,
    [defines.controllers.spectator] = true,
    [defines.controllers.remote] = true,
}

--- contain everything related to player teleport between surfaces
local function safe_teleport(player_or_vehicle, surface, position, force_teleport)
    position = {x = position.x or position[1], y = position.y or position[2]}
    local is_player = player_or_vehicle.is_player()
    local controller_type = is_player and player_or_vehicle.controller_type or nil
    local type = is_player and "character" or player_or_vehicle.prototype
    local index = is_player and player_or_vehicle.index or player_or_vehicle.unit_number

    if not surface then return end
    if is_player and non_player_controllers[controller_type] and not force_teleport then return end

    -- prevent teleporting from anywhere to the surface if we are currently in warp
    if storage.warp.status ~= defines.warp.awaiting and surface.name == storage.warp.previous.name then
        if is_player then player_or_vehicle.print({"dw-messages.warp-no-teleport"}) end
        return
    end

    position = surface.find_non_colliding_position(type, position, 5, 0.5, false) or position
    player_or_vehicle.teleport(position, surface)

    storage.players_last_teleport[index] = game.tick
end
dw.safe_teleport = safe_teleport

---
local function check_player_teleport()
    for player_index, player in pairs(game.connected_players) do
        if not player.walking_state.walking and not player.driving then goto continue end

        -- prevent teleport spam
        if (storage.players_last_teleport[player_index] or 0) > game.tick - 20 then
            goto continue
        end

        -- use the bounding box to determine the size of the check area
        local position = player.physical_position
        local bounding_box = player.character and player.character.bounding_box
        if player.driving then
            position = player.physical_vehicle.position
            bounding_box = player.physical_vehicle.bounding_box
        end
        if player.character and player.character.is_flying then
            position.y = position.y + player.character.flight_height
        end
        if not bounding_box then goto continue end

        local entity_size = 0.2 + math2d.position.distance(bounding_box.left_top, bounding_box.right_bottom) / 2
        local check_area = {
            {position.x - entity_size, position.y - entity_size},
            {position.x + entity_size, position.y + entity_size}
        }
        
        local entities = player.surface.find_entities_filtered{area = check_area, subgroup="warpgate"}

        --- is the entities found an active teleporter ?
        for _, found_entity in pairs(entities) do
            for _, teleporter in pairs(storage.teleporter) do
                if not teleporter.active then goto continue_teleport end
                if not teleporter.from.valid or not teleporter.to.valid then goto continue_teleport end
                if player.surface.name ~= teleporter.from.surface.name then goto continue_teleport end
                if teleporter.from == found_entity then
                    local relative_position = math2d.position.subtract(teleporter.from.position, position)

                    -- make sure we are outside of the teleporter area when teleporting
                    -- so we check current length with increase, compared to the "length" of the target teleporter half-size + entity size
                    local distance = math2d.position.vector_length(relative_position) * 1.3
                    local teleporter_check_distance = entity_size - 0.2 + math2d.position.distance(teleporter.to.bounding_box.left_top, teleporter.to.bounding_box.right_bottom) / 2
                    if distance < teleporter_check_distance then
                        relative_position = math2d.position.multiply_scalar(relative_position, (teleporter_check_distance / distance) + 0.3)
                    else
                        relative_position = math2d.position.multiply_scalar(relative_position, 1.3)
                    end

                    local final_pos = math2d.position.add(teleporter.to.position, relative_position)

                    if player.driving then
                        local speed = player.physical_vehicle.speed
                        safe_teleport(player.vehicle, teleporter.to.surface, final_pos)
                        if player.physical_vehicle.type == "car" then player.physical_vehicle.speed = speed end
                    else
                        safe_teleport(player, teleporter.to.surface, final_pos)
                    end
                    player.play_sound{path = "dw-teleport"}
                    goto continue
                end
                ::continue_teleport::
            end
        end

        ::continue::
    end
end

--- Make sure that dead player on any old surface is moved to the new surface
local function dead_on_previous_surface(event)
    local player = game.players[event.player_index]
    if player.surface.name ~= storage.warp.current.name then
        player.teleport({0, 0}, storage.warp.current.name)
    end
end


--- make sure new players are teleported to the new surface
local function teleport_safely_player_on_event(event)
    local player = game.players[event.player_index]

    --- make sure to teleport any new player to the current warp surface
    if storage.nauvis_lab_exploded then
        if not dw.safe_surfaces[player.surface.name] then
            local previous_surface = player.physical_surface
            safe_teleport(player, storage.warp.current.surface, {0, 0}, true)
            if previous_surface == "nauvis" and storage.all_players_left_nauvis then game.surfaces.nauvis.clear() end
        end
    end

    --- only display for first character.
    if player.index == 1 and not storage.nauvis_lab_exploded then
        game.print({"dw-messages.intro"}, {color=util.color(defines.hexcolor.orange.. 'd9')})
    end
end



dw.register_event(defines.events.on_player_died, dead_on_previous_surface)
dw.register_event(defines.events.on_player_created, teleport_safely_player_on_event)
dw.register_event(defines.events.on_player_joined_game, teleport_safely_player_on_event)
dw.register_event('on_nth_tick_6', check_player_teleport)