local setting_tile_platform = settings.startup['dw-default-tile-platform'].value
local setting_tile_dimension = settings.startup['dw-default-tile-dimensions'].value
local default_platform_tile = (data.raw['tile'][setting_tile_platform]) and setting_tile_platform or "concrete"
local default_dimension_tile = (data.raw['tile'][setting_tile_dimension]) and setting_tile_dimension or "tutorial-grid"

local function create_surface_tile(tile_info)
    -- Deep copy the base concrete tile
    local tile = table.deepcopy(tile_info.base_tile)

    -- Modify the tile properties
    tile.name = tile_info.name
    tile.layer_group = "ground-artificial" -- Set the layer group
    tile.tint = tile_info.tint -- Apply the tint to the tile
    tile.type = "tile"
    tile.layer = 75
    tile.walking_speed_modifier = 1.5
    tile.variant = nil
    tile.frozen_variant = nil
    tile.stack_size = 200
    tile.is_foundation = true
    tile.allows_being_covered = false
    tile.minable = nil
    tile.placeable_by = nil
    data:extend({tile})
end

data.raw['tile']['out-of-map'].autoplace = {probability_expression = 1}
data.raw['tile']['out-of-map'].absorptions_per_second = {pollution = 0.0001}

create_surface_tile {
    name = "warp-platform",
    tint = defines.color.lightcyan,
    base_tile = data.raw["tile"][default_platform_tile],
}
create_surface_tile {
    name = "dimension-hazard",
    tint = defines.color.lightgoldenrodyellow,
    base_tile = data.raw["tile"]['hazard-concrete-right'],
}
create_surface_tile {
    name = "factory-platform",
    tint = defines.color.lightsteelblue,
    base_tile = data.raw["tile"][default_dimension_tile],
}
create_surface_tile {
    name = "energy-platform",
    tint = defines.color.lightgoldenrodyellow,
    base_tile = data.raw["tile"][default_dimension_tile],
}
create_surface_tile {
    name = "mining-platform",
    tint = defines.color.darksalmon,
    base_tile = data.raw["tile"][default_dimension_tile],
}