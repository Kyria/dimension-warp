--- Teleport mechanics are all here
------------------------------------------------------------

local non_player_controllers = {
    [defines.controllers.god] = true,
    [defines.controllers.editor] = true,
    [defines.controllers.spectator] = true,
    [defines.controllers.remote] = true,
}

--- contain everything related to player teleport between surfaces
dw.safe_teleport = function(player_or_vehicle, surface, position)
    position = {x = position.x or position[1], y = position.y or position[2]}
    local is_player = player_or_vehicle.is_player()
    local type = is_player and player_or_vehicle.character.name or player_or_vehicle.prototype
    local index = is_player and player_or_vehicle.index or player_or_vehicle.unit_number

    if not surface then return end
    if non_player_controllers[player_or_vehicle.controller_type] then return end

    -- prevent teleporting from anywhere to the surface if we are currently in warp
    if storage.warp.status ~= defines.warp.awaiting and surface.name == storage.warp.previous.name then
        if is_player then player_or_vehicle.print({"dw-messages.warp-no-teleport"}) end
        return
    end

    position = surface.find_non_colliding_position(type, position, 5, 0.5, false) or position
    player_or_vehicle.teleport(position, surface)

    storage.players_last_teleport[index] = game.tick
end

---
local function check_player_teleport()
    for player_index, player in pairs(game.connected_players) do
        if player.driving then goto continue end
        if not player.walking_state.walking then goto continue end

        -- prevent teleport spam
        if (storage.players_last_teleport[player_index] or 0) > game.tick - 20 then
            goto continue
        end


        local position = player.position
        local check_area = {
            {position.x - 0.4, position.y - 0.5},
            {position.x + 0.4, position.y + 0.5}
        }
        local entities = player.surface.find_entities_filtered{area = check_area, name = {"warp-gate", "radio-station"}}

        --- is the entities found an active teleporter ?
        for _, found_entity in pairs(entities) do
            for _, teleporter in pairs(storage.teleporter) do
                if not teleporter.active then goto continue_teleport end
                if player.surface.name ~= teleporter.from.surface.name then goto continue_teleport end
                if teleporter.from == found_entity then
                    local distance = math2d.position.distance(teleporter.from.position, position)
                    local final_pos = util.moveposition(teleporter.to.position, player.walking_state.direction, distance + 0.5)

                    dw.safe_teleport(player, teleporter.to.surface, final_pos)
                    goto continue
                end
                ::continue_teleport::
            end
        end

        ::continue::
    end
end


local function on_teleport_died(event)
    local entity = event.entity
    local surface = entity.surface
    if not storage.teleporter[surface.name] then return end
    if not entity.name == "warp-gate" then return end

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
            dw.safe_teleport(player, storage.warp.current.surface, {0, 0})
        end
    end
end


dw.register_event(defines.events.on_player_died, dead_on_previous_surface)
dw.register_event(defines.events.on_entity_died, on_teleport_died, {{filter = "name", name = "warp-gate"}})
dw.register_event(defines.events.on_player_created, teleport_safely_player_on_event)
dw.register_event(defines.events.on_player_joined_game, teleport_safely_player_on_event)
dw.register_event('on_nth_tick_6', check_player_teleport)