--- contain everything related to player teleport between surfaces
dw.safe_teleport = function(player_or_vehicle, surface, position)
    position = {x = position.x or position[1], y = position.y or position[2]}
    local is_player = player_or_vehicle.is_player()
    local type = is_player and player_or_vehicle.character.name or player_or_vehicle.prototype
    local index = is_player and player_or_vehicle.index or player_or_vehicle.unit_number

    if not game.surfaces[surface] then return end
    if is_player and not player_or_vehicle.character then return end

    -- prevent teleporting from anywhere to the surface if we are currently in warp
    if storage.warp.status ~= defines.warp.awaiting and surface == storage.warp.previous.name then
        if is_player then player_or_vehicle.print({"dw-messages.warp-no-teleport"}) end
        return
    end

    -- prevent teleport spam
    if storage.players_last_teleport[index] and storage.players_last_teleport[index] > game.tick - 30 then
        return
    end

    position = game.surfaces[surface].find_non_colliding_position(type, position, 5, 0.5, false) or position
    player_or_vehicle.teleport(position, surface)

    storage.players_last_teleport[index] = game.tick
end


local function on_player_changed_position(event)
    local player = game.players[event.player_index]
    if not player.character or not player.surface then return end
    if not storage.teleporter[player.surface.name] then return end


    for _, teleporter in pairs(storage.teleporter[player.surface.name]) do
        if math2d.bounding_box.contains_point(teleporter.box, player.position) then
            dw.safe_teleport(player, teleporter.destination_surface, teleporter.destination_position)
        end
    end
end


local function on_teleport_died(event)
    local entity = event.entity
    local surface = entity.surface
    if not storage.teleporter[surface.name] then return end
    if not entity.name == "simple-teleport" then return end

    for i=#storage.teleporter[surface.name], 1, -1 do
        local teleporter = storage.teleporter[surface.name][i]
        if teleporter.entity == entity then
            table.remove(storage.teleporter[surface.name], i)
            break
        end
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
            dw.safe_teleport(player, storage.warp.current.name, {0, 0})
        end
    end
end


dw.register_event(defines.events.on_player_died, dead_on_previous_surface)
dw.register_event(defines.events.on_player_changed_position, on_player_changed_position)
dw.register_event(defines.events.on_entity_died, on_teleport_died, {{filter = "name", name = "simple-teleport"}})
dw.register_event(defines.events.on_player_created, teleport_safely_player_on_event)
dw.register_event(defines.events.on_player_joined_game, teleport_safely_player_on_event)