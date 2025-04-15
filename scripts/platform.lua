local function get_warp_platform_area(offset_x, offset_y)
    offset_x = offset_x or 0
    offset_y = offset_y or 0
    local left_top = {
        x = storage.platform.warp.center[1] - storage.platform.warp.size/2 + offset_x,
        y = storage.platform.warp.center[2] - storage.platform.warp.size/2 + offset_y,
    }
    local right_bottom = {
        x = storage.platform.warp.center[1] + storage.platform.warp.size/2 + offset_x,
        y = storage.platform.warp.center[2] + storage.platform.warp.size/2 + offset_y,
    }
    return {
        left_top = left_top,
        right_bottom = right_bottom,
    }
end

dw.update_warp_platform_size = function()
    local surface = game.surfaces[storage.warp.current.name]
    local tiles = {}
    for i = 0, storage.platform.warp.size - 1 do
        for j = 0, storage.platform.warp.size - 1 do
            local position = {
                x = storage.platform.warp.center[1] - storage.platform.warp.size/2 + i,
                y = storage.platform.warp.center[2] - storage.platform.warp.size/2 + j
            }
            table.insert(tiles, {name = "warp-platform", position = position})
        end
    end
    surface.set_tiles(tiles)
end

dw.prepare_warp_to_next_surface = function()
    if storage.warp.status ~= defines.warp.awaiting then return end
    storage.warp.status = defines.warp.preparing

    local target = "neo-nauvis" --- dw select random surface
    dw.generate_surface(target)

    local source_platform_area = get_warp_platform_area()
    local target_platform_area = get_warp_platform_area() -- random ?

    --- list entity except player, car, tank, spidertron
    --- clone tiles
    --- filter entities and clone them
    --- teleport non clonable stuff
    --- use area for entities
    --- use area + offset size (+1/side) for checking player
    storage.warp.previous.surface.clone_area{
        source_area = source_platform_area,
        destination_area = target_platform_area,
        destination_surface = storage.warp.current.name,
        clone_tiles = true,
        clone_entities = true,
        clone_decoratives = false,
        clear_destination_entities = true,
        clear_destination_decoratives = true,
        expand_map = true,
        create_build_effect_smoke = true
    }
end

local function warping_players(event)
    if storage.warp.status ~= defines.warp.preparing then return end
    storage.warp.status = defines.warp.warping

    for _, player in pairs(game.players) do
        if player.surface.name == storage.warp.previous.name then
            if math2d.bounding_box.contains_point(get_warp_platform_area(), player.position) then
                dw.safe_teleport(player, storage.warp.current.name, player.position)
            else
                player.character.die()
            end
        end
    end

    dw.update_surfaces_properties()
end

local function on_technology_research_finished(event)
    local tech = event.research
    if string.match(tech.name, "warp%-platform%-size%-%d+") then
        storage.platform.warp.size = 14 * tech.level + 8
        dw.update_warp_platform_size()
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
dw.register_event(defines.events.on_area_cloned, warping_players)