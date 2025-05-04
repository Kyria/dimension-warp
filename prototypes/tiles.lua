local function create_tile(tile_info)
    -- Deep copy the base concrete tile
    local tile = table.deepcopy(tile_info.base_tile)

    -- Modify the tile properties
    tile.name = tile_info.name
    tile.group = "ground-artificial" -- Set the layer group
    tile.tint = tile_info.tint -- Apply the tint to the tile
    tile.type = "tile"
    tile.layer = 75
    tile.walking_speed_modifier = 1.5
    tile.variant = nil
    tile.stack_size = 200
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
            condition = {layers = {ground_tile = true}},
            condition_size = 1,
            tile_condition = {"water", "deepwater"}
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

create_tile {
    name = "warp-platform",
    tint = defines.color.slategrey,
    buildable = false,
    base_tile = data.raw["tile"]["concrete"],
}
create_tile {
    name = "factory-platform",
    tint = defines.color.lightgoldenrodyellow,
    buildable = true,
    base_tile = data.raw["tile"]["tutorial-grid"],
}
create_tile {
    name = "energy-platform",
    tint = defines.color.lightsteelblue,
    buildable = true,
    base_tile = data.raw["tile"]["tutorial-grid"],
}
create_tile {
    name = "mining-platform",
    tint = defines.color.darksalmon,
    buildable = true,
    base_tile = data.raw["tile"]["tutorial-grid"],
}
create_tile {
    name = "spacehub-platform",
    tint = defines.color.lightskyblue,
    buildable = true,
    base_tile = data.raw["tile"]["tutorial-grid"],
}
