utils = {} or utils


function utils.format_time(sec)
    local seconds = sec % 60
    local minutes = math.floor((sec / 60) % 60)
    local hours = math.floor(sec / 3600)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end


--- weighted random choice. weights must be sum up to 100 cumulative (% chance)
function utils.weighted_random_choice(elements, weights)
    local random_value = math.random(100)
    local cumulative_weight = 0

    for i, weight in ipairs(weights) do
        cumulative_weight = cumulative_weight + weight
        if random_value <= cumulative_weight then
            return elements[i]
        end
    end
end

--- source: factorissimo-2-notnotmelon
--- modified to feat the mod needs
function utils.add_music(source_planet, destination_planet)
    for _, music in pairs(data.raw["ambient-sound"]) do
        if music.planet == source_planet.name or (music.track_type == "hero-track" and music.name:find(source_planet.name)) then
            local new_music = table.deepcopy(music)
            new_music.name = music.name .. "-" .. destination_planet.name
            new_music.planet = destination_planet.name
            if new_music.track_type == "hero-track" then
                new_music.track_type = "main-track"
                new_music.weight = 10
            end
            data:extend {new_music}
        end
    end
end

--- source: factorissimo-2-notnotmelon
--- Creates a flying text for all players.
--- @param args table
function utils.create_flying_text(args)
    args.create_at_cursor = false
    for _, player in pairs(game.connected_players) do
        player.create_local_flying_text(args)
    end
end


function utils.add_tiles(tiles, name, top_left, bottom_right)
    top_left = math2d.position.ensure_xy(top_left)
    bottom_right = math2d.position.ensure_xy(bottom_right)
    for i = top_left.x, bottom_right.x do
        for j = top_left.y, bottom_right.y do
            local position = {x = i, y = j}
            table.insert(tiles, {name = name, position = position})
        end
    end
end

function utils.put_warning_tiles(surface, template)
    tiles = {}
    for _, tile_position in pairs(template) do
        utils.add_tiles(tiles, "dimension-hazard", tile_position[1], tile_position[2])
    end
    surface.set_tiles(tiles)
end


function utils.link_gates(teleport_connection1, teleport_connection2, teleport1, teleport2)
    storage.teleporter[teleport_connection1] = {active = true, from = teleport1, to = teleport2}
    storage.teleporter[teleport_connection2] = {active = true, from = teleport2, to = teleport1}
end

function utils.link_cables(entity1, entity2, wire_connectors)
    if not entity1.valid or not entity2.valid then return end
    for _, connector in pairs(wire_connectors) do
        local entity1_connector = entity1.get_wire_connector(connector, true)
        local entity2_connector = entity2.get_wire_connector(connector, true)
        if entity1_connector and entity2_connector then
            entity1_connector.connect_to(entity2_connector, false, defines.wire_origin.script)
        end
    end
end