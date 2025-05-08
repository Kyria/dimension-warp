local setting_tile_platform = settings.startup['dw-default-tile-platform'].value
local setting_tile_dimension = settings.startup['dw-default-tile-dimensions'].value
local default_platform_tile = (data.raw['tile'][setting_tile_platform]) and setting_tile_platform or "concrete"
local default_dimension_tile = (data.raw['tile'][setting_tile_dimension]) and setting_tile_dimension or "tutorial-grid"

local function create_surface_tile(tile_info)
    -- Deep copy the base concrete tile
    local tile = table.deepcopy(tile_info.base_tile)

    -- Modify the tile properties
    tile.name = tile_info.name
    tile.layer_group = "zero" -- Set the layer group
    tile.tint = tile_info.tint -- Apply the tint to the tile
    tile.type = "tile"
    tile.layer = 75
    tile.walking_speed_modifier = 1.5
    tile.variant = nil
    tile.frozen_variant = nil
    tile.stack_size = 200
    tile.is_foundation = true
    tile.allows_being_covered = false
    if not tile_info.buildable then
        data:extend({tile})
    else
        tile.minable = {
            mining_time = 0.1,
            result = tile_info.name,
            count = 1,
        }

        local item = table.deepcopy(data.raw["item"]["concrete"])
        item.name = tile_info.name
        item.stack_size = 50
        item.icons = {
            {
                icon = data.raw["item"]["concrete"].icon,
                icon_size = 64,
                tint = tile_info.tint
            }
        }
        item.place_as_tile = {
            result = tile_info.name,
            condition = {layers = {empty_space = true, out_of_map = true}},
            condition_size = 1,
            tile_condition = (mods['space-age']) and {"empty-space"} or {"out-of-map"},
            invert = true,
        }

        local item_recipe = {
            type = "recipe",
            name = tile_info.name,
            icons = {
                {
                    icon = data.raw["item"]["concrete"].icon,
                    icon_size = 64,
                    tint = tile_info.tint
                }
            },
            category = "advanced-crafting",
            ingredients = tile_info.ingredients or {{type="item", name="concrete", amount=100}},
            results = {{type = "item", name = tile_info.name, amount = 1}},
            auto_recycle = true
        }

        data:extend({tile, item, item_recipe})
    end
end

data.raw['tile']['out-of-map'].autoplace = {probability_expression = 1}
data.raw['tile']['out-of-map'].absorptions_per_second = {pollution = 0.0001}

create_surface_tile {
    name = "warp-platform",
    tint = defines.color.slategrey,
    buildable = false,
    base_tile = data.raw["tile"][default_platform_tile],
}
create_surface_tile {
    name = "factory-platform",
    tint = defines.color.lightgoldenrodyellow,
    buildable = true,
    base_tile = data.raw["tile"][default_dimension_tile],
}
create_surface_tile {
    name = "energy-platform",
    tint = defines.color.lightsteelblue,
    buildable = true,
    base_tile = data.raw["tile"][default_dimension_tile],
}
create_surface_tile {
    name = "mining-platform",
    tint = defines.color.darksalmon,
    buildable = true,
    base_tile = data.raw["tile"][default_dimension_tile],
}
create_surface_tile {
    name = "spacehub-platform",
    tint = defines.color.lightskyblue,
    buildable = true,
    base_tile = data.raw["tile"][default_dimension_tile],
}
