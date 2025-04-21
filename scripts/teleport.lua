--- contain everything related to player teleport between surfaces
local math2d = require "math2d"

dw.safe_teleport = function(player_or_vehicle, surface, position)
    position = {x = position.x or position[1], y = position.y or position[2]}
    local is_player = player_or_vehicle.is_player()
    local type = is_player and player_or_vehicle.character.name or player_or_vehicle.prototype
    local index = is_player and player_or_vehicle.index or player_or_vehicle.unit_number

    if not game.surfaces[surface] then return end
    if is_player and not player_or_vehicle.character then return end

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

dw.register_event(defines.events.on_player_changed_position, on_player_changed_position)
dw.register_event(defines.events.on_entity_died, on_teleport_died, {{filter = "name", name = "simple-teleport"}})