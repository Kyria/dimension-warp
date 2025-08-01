local default_tile =  "dimension-space"
local safe_tiles = {
    ["dimension-harvester-hazard"] = true,
    ["harvester-platform"] = true,
    ["mining-platform"] = true,
    ["energy-platform"] = true,
    ["factory-platform"] = true,
    ["dimension-hazard"] = true,
    ["water"] = true,
    ["water-green"] = true,
}

local function replace_space_tiles(surface, platform_area)
    -- force change mapgen to use the new tile
    local mapgen = surface.map_gen_settings
    mapgen.autoplace_settings.tile.settings = {}
    mapgen.autoplace_settings.tile.settings[default_tile]={frequency=1, size=1, richness=1}
    surface.map_gen_settings = mapgen

    -- remove chunks not containing base
    for chunk in surface.get_chunks() do
        if not math2d.bounding_box.collides_with(chunk.area, platform_area) then
            surface.delete_chunk({chunk.x, chunk.y})
        end
    end

    -- replace leftover tiles
    local origin_tiles = surface.find_tiles_filtered{
        area = {{platform_area.left_top[1] - 32, platform_area.left_top[2] - 32}, {platform_area.right_bottom[1] + 32, platform_area.right_bottom[2] + 32}},
    }
    local new_tiles = {}
    for _, tile in pairs(origin_tiles) do
        if not safe_tiles[tile.name] then
            table.insert(new_tiles, {name = default_tile, position = tile.position})
        end
    end
    surface.set_tiles(new_tiles, true, false, false)
end

-----------------------
--- Produstia
-----------------------
if storage.platform.factory.surface then
    local size = storage.platform.factory.size
    replace_space_tiles(
        storage.platform.factory.surface,
        {left_top = {-size/2, -size/2}, right_bottom={(size-1)/2, (size-1)/2}}
    )
    dw.platforms.init_update_factory_platform()
end

-----------------------
--- Smeltus
-----------------------
if storage.platform.mining.surface then
    local size_x = storage.platform.mining.size.x
    local size_y = storage.platform.mining.size.y
    local platform_area = {left_top = {-size_x/2, -size_y/2}, right_bottom={(size_x-1)/2, (size_y-1)/2}}

    if storage.harvesters.left.gate then
        local harvester_const = dw.harvesters.left
        local harvester = storage.harvesters.left
        local harvester_area = math2d.bounding_box.create_from_centre(harvester_const.center, harvester.size + 1 + harvester.border * 2)
        platform_area.left_top[1] = math.min(platform_area.left_top[1], harvester_area.left_top.x)
        platform_area.left_top[2] = math.min(platform_area.left_top[2], harvester_area.left_top.y)
        platform_area.right_bottom[1] = math.max(platform_area.right_bottom[1], harvester_area.right_bottom.x)
        platform_area.right_bottom[2] = math.max(platform_area.right_bottom[2], harvester_area.right_bottom.y)
    end
    if storage.harvesters.right.gate then
        local harvester_const = dw.harvesters.right
        local harvester = storage.harvesters.right
        local harvester_area = math2d.bounding_box.create_from_centre(harvester_const.center, harvester.size + 1 + harvester.border * 2)
        platform_area.left_top[1] = math.min(platform_area.left_top[1], harvester_area.left_top.x)
        platform_area.left_top[2] = math.min(platform_area.left_top[2], harvester_area.left_top.y)
        platform_area.right_bottom[1] = math.max(platform_area.right_bottom[1], harvester_area.right_bottom.x)
        platform_area.right_bottom[2] = math.max(platform_area.right_bottom[2], harvester_area.right_bottom.y)
    end
    replace_space_tiles(storage.platform.mining.surface, platform_area)
    dw.platforms.init_update_mining_platform()
    if storage.harvesters.left.gate then dw.platforms.place_harvester_tiles("left") end
    if storage.harvesters.right.gate then dw.platforms.place_harvester_tiles("right") end
end

-----------------------
--- Electria
-----------------------
if storage.platform.power.surface then
    local size = storage.platform.power.size
    local horizontal = math2d.bounding_box.create_from_centre({0,0}, size * 2 - 1, size * 2 / 3 - 1)
    local vertical = math2d.bounding_box.create_from_centre({0,0}, size * 2 / 3 - 1,  size * 2 - 1)
    replace_space_tiles(
        storage.platform.power.surface,
        {left_top={horizontal.left_top.x, vertical.left_top.y}, right_bottom={horizontal.right_bottom.x, vertical.right_bottom.y}}
    )
    dw.platforms.init_update_power_platform()
end