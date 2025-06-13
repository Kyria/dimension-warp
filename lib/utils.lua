utils = {} or utils


function utils.format_time(sec)
    local seconds = sec % 60
    local minutes = math.floor((sec / 60) % 60)
    local hours = math.floor(sec / 3600)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end


--- weighted random choice.
function utils.weighted_random_choice(elements, weights)
    local total_weight = 0
    for _, weight in ipairs(weights) do total_weight = total_weight + weight end

    local random_value = math.random() * total_weight
    local cumulative_weight = 0

    for i, weight in ipairs(weights) do
        cumulative_weight = cumulative_weight + weight
        if random_value <= cumulative_weight then
            return elements[i]
        end
    end
end

---Generate a random double
---@param min number
---@param max number
---@return number
function utils.random(min, max)
    return (max - min) * math.random() + min
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
    local stepi = 1
    local stepj = 1
    top_left = math2d.position.ensure_xy(top_left)
    bottom_right = math2d.position.ensure_xy(bottom_right)
    if top_left.x > bottom_right.x then stepi = -1 end
    if top_left.y > bottom_right.y then stepj = -1 end

    for i = top_left.x, bottom_right.x, stepi do
        for j = top_left.y, bottom_right.y, stepj do
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

---Check that we construct entity only on surface, not any platform.
---If we do, destroy and return the item.
---@param event EventData.on_built_entity|EventData.on_robot_built_entity the event data
---@param allowed_surfaces table<string,boolean> the surface list, key must be surface name with true if allowed
---@param localized_message string the localized message
---@return boolean # true if the surface is allowed
function utils.entity_built_surface_check(event, allowed_surfaces, localized_message)

    local source = (event.robot) and event.robot or game.players[event.player_index] ---@type LuaEntity|LuaPlayer
    local entity = event.entity
    local consumed = (event.stack) and event.stack or event.consumed_items[1]
    local item_stack = {name=consumed, count=1}

    if allowed_surfaces[entity.surface.name] then return true end

    if consumed.quality then item_stack.quality = consumed.quality.name end

    if event.player_index and source.valid and source.character and source.character.valid then
        source.insert(item_stack)
    else
        entity.surface.spill_item_stack {
            position = entity.position,
            stack = item_stack,
            enable_looted = true,
            force = entity.force
        }
    end

    utils.create_flying_text{
        position = entity.position,
        surface = entity.surface,
        text = {localized_message},
        color = util.color(defines.hexcolor.orangered.. 'd9')}
    entity.destroy()

    return false
end
