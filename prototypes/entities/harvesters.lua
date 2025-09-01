
-----------------------------
--- Harvester gates
-----------------------------
local harvester_left_gate = table.deepcopy(data.raw.radar['radio-station'])
harvester_left_gate.name = "harvester-left-gate"
harvester_left_gate.subgroup = "warpgate"
harvester_left_gate.max_distance_of_nearby_sector_revealed = 1
harvester_left_gate.max_distance_of_sector_revealed = 0
harvester_left_gate.energy_source.emissions_per_minute = (mods['space-age']) and {pollution = 5, spores = 5} or {pollution = 5}
harvester_left_gate.icons = {
    {
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = util.color(defines.hexcolor.chocolate .. '77')
    },
    {
        icon = "__base__/graphics/icons/arrows/left-arrow.png",
        icon_size = 64,
        icon_mipmaps = 4,
        scale = 0.5,
        shift = {-16, 0}
        --tint = util.color(defines.hexcolor.royalblue .. 'd9')
    }
}
harvester_left_gate.remains_when_mined = "harvester-left-gate"
harvester_left_gate.minable = {mining_time = 0.2, result = "harvester-left-mobile-gate"}

local harvester_left_mobilegate = table.deepcopy(harvester_left_gate)
harvester_left_mobilegate.name = "harvester-left-mobile-gate"
harvester_left_mobilegate.icons[1].tint = util.color(defines.hexcolor.orange .. '77')
harvester_left_mobilegate.minable = {mining_time = 0.2, result = "harvester-left-mobile-gate"}
harvester_left_mobilegate.placeable_by = nil
harvester_left_mobilegate.remains_when_mined = nil
harvester_left_mobilegate.flags = {"placeable-player"}


local harvester_right_gate = table.deepcopy(harvester_left_gate)
harvester_right_gate.name = "harvester-right-gate"
harvester_right_gate.icons[2] = {
    icon = "__base__/graphics/icons/arrows/right-arrow.png",
    icon_size = 64,
    icon_mipmaps = 4,
    scale = 0.5,
    shift = {16, 0}
    --tint = util.color(defines.hexcolor.royalblue .. 'd9')
}
harvester_right_gate.remains_when_mined = "harvester-right-gate"
harvester_right_gate.minable = {mining_time = 0.2, result = "harvester-right-mobile-gate"}

local harvester_right_mobilegate = table.deepcopy(harvester_right_gate)
harvester_right_mobilegate.name = "harvester-right-mobile-gate"
harvester_right_mobilegate.icons[1].tint = util.color(defines.hexcolor.orange .. '77')
harvester_right_mobilegate.minable = {mining_time = 0.2, result = "harvester-right-mobile-gate"}
harvester_right_mobilegate.placeable_by = nil
harvester_right_mobilegate.remains_when_mined = nil
harvester_right_mobilegate.flags = {"placeable-player"}

local function create_item(name, icons)
    return {
        type = 'item',
        name = name,
        subgroup = "warpgate",

        stack_size = 10,
        weight = 1.5 * tons,
        icons = icons,

        place_result = name,
    }
end

-- create special entity with tile as icon (or whatever) that has the same size as harvesters
-- this entity will be removed when placed, replaced by the mobile gate + tiles.
local function create_placement_grid(name, size)
    return {
        type = "container", -- use the container, as it's really small
        name = name,
        icons = harvester_left_mobilegate.icons,
        flags = {"placeable-neutral", "player-creation"},
        inventory_size = size,
        picture = {
            filename = "__base__/graphics/terrain/lab-tiles/lab-dark-1.png",
            size = 32,
            scale = size,
            tint = util.color(defines.hexcolor.chocolate .. "66"),
            position = {0, 0},
        },
        selection_box = {
            {-1 * size / 2, -1 * size / 2},
            {(size / 2), (size / 2)}
        },
        collision_box = {
            {(-1 * size / 2) - 0.1, (-1 * size / 2) - 0.1},
            {(size / 2) - 0.1, (size / 2) - 0.1}
        },
        collision_mask = {layers={is_lower_object=true, is_object=true}},
        minable = nil,
        placeable_by = nil,
    }
end

data:extend{
    harvester_left_gate,
    harvester_left_mobilegate,
    harvester_right_gate,
    harvester_right_mobilegate,
    create_item("harvester-left-mobile-gate", harvester_left_mobilegate.icons),
    create_item("harvester-right-mobile-gate", harvester_right_mobilegate.icons),
    create_placement_grid("harvester-left-grid-1", dw.platform_size.harvester[1]),
    create_placement_grid("harvester-left-grid-2", dw.platform_size.harvester[2]),
    create_placement_grid("harvester-left-grid-3", dw.platform_size.harvester[3]),
    create_placement_grid("harvester-left-grid-4", dw.platform_size.harvester[4]),
    create_placement_grid("harvester-left-grid-5", dw.platform_size.harvester[5]),
    create_placement_grid("harvester-left-grid-6", dw.platform_size.harvester[6]),
    create_placement_grid("harvester-right-grid-1", dw.platform_size.harvester[1]),
    create_placement_grid("harvester-right-grid-2", dw.platform_size.harvester[2]),
    create_placement_grid("harvester-right-grid-3", dw.platform_size.harvester[3]),
    create_placement_grid("harvester-right-grid-4", dw.platform_size.harvester[4]),
    create_placement_grid("harvester-right-grid-5", dw.platform_size.harvester[5]),
    create_placement_grid("harvester-right-grid-6", dw.platform_size.harvester[6]),
    create_item("harvester-left-grid-1", harvester_left_mobilegate.icons),
    create_item("harvester-left-grid-2", harvester_left_mobilegate.icons),
    create_item("harvester-left-grid-3", harvester_left_mobilegate.icons),
    create_item("harvester-left-grid-4", harvester_left_mobilegate.icons),
    create_item("harvester-left-grid-5", harvester_left_mobilegate.icons),
    create_item("harvester-left-grid-6", harvester_left_mobilegate.icons),
    create_item("harvester-right-grid-1", harvester_right_mobilegate.icons),
    create_item("harvester-right-grid-2", harvester_right_mobilegate.icons),
    create_item("harvester-right-grid-3", harvester_right_mobilegate.icons),
    create_item("harvester-right-grid-4", harvester_right_mobilegate.icons),
    create_item("harvester-right-grid-5", harvester_right_mobilegate.icons),
    create_item("harvester-right-grid-6", harvester_right_mobilegate.icons),
}