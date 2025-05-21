data:extend({
    {
        type = "radar",
        name = "radio-station",

        collision_mask = {layers={object=true, item=true, meltable=true, water_tile=true, is_lower_object=true, is_object=true, player=true}},
        icon = "__dimension-warp__/graphics/entities/radio-station/radio-station-icon.png",
        icon_size = 64,
        flags = {"placeable-player", "player-creation"},
        minable = nil,
        placeable_by = nil,
        max_health = 5000,
        collision_box = {{-0.95, -0.95}, {0.95, 0.95}},
        selection_box = {{-1, -1}, {1, 1}},
        corpse = "radar-remnants",
        dying_explosion = "radar-explosion",

        is_military_target = true,
        circuit_connector = {
            points = {
                shadow ={
                    red = util.by_pixel(-28, -91),
                    green = util.by_pixel(-28, -91)
                },
                wire ={
                    red = util.by_pixel(-28, -91),
                    green = util.by_pixel(-28, -91)
                }
            }
        },
        circuit_wire_max_distance = 9,
        radius_minimap_visualisation_color = {0.059, 0.092, 0.235, 0.275},
        impact_category = "metal",

        energy_per_nearby_scan = "250kJ",
        energy_per_sector = "500kJ",
        energy_source = {
            type = "void",
            emissions_per_minute = {
                pollution = 50,
                spores = 50,
            }
        },
        energy_usage = "100kW",
        max_distance_of_nearby_sector_revealed = 4,
        max_distance_of_sector_revealed = 14,

        rotation_speed = 0.015,
        pictures = {
            layers = {
                {
                    filename = "__dimension-warp__/graphics/entities/radio-station/radio-station-hr-shadow.png",
                    priority = "low",
                    width = 400,
                    height = 350,
                    direction_count= 20,
                    line_length= 8,
                    lines_per_file= 3,
                    shift= {0, -1},
                    scale = 0.5,
                    draw_as_shadow = true,
                },
                {
                    filename = "__dimension-warp__/graphics/entities/radio-station/radio-station-hr-animation-1.png",
                    priority = "low",
                    width = 160,
                    height = 290,
                    direction_count = 20,
                    line_length = 8,
                    lines_per_file = 3,
                    scale = 0.5,
                    shift = {0, -1},
                },
                {
                    filename = "__dimension-warp__/graphics/entities/radio-station/radio-station-hr-emission-1.png",
                    priority = "low",
                    width = 160,
                    height = 290,
                    direction_count = 20,
                    line_length = 8,
                    lines_per_file = 3,
                    scale = 0.5,
                    draw_as_glow = true,
                    blend_mode = "additive",
                    shift = {0, -1},
                },
            }
        }
    }
})