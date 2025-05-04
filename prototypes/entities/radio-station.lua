data:extend({
    {
        type = "radar",
        name = "radio-station",
        localised_name = "radio-station",
        localised_description = "radio-station",

        collision_mask = {layers={object=true, item=true, floor=true, water_tile=true, is_lower_object=true, player=true}},
        icon = "__dimension-warp__/graphics/entities/radio-station/radio-station-icon.png",
        icon_size = 64,
        flags = {"placeable-player", "player-creation"},
        minable = nil,
        max_health = 5000,
        collision_box = {{-0.9, -0.9}, {0.9, 0.9}},
        selection_box = {{-1, -1}, {1, 1}},

        energy_per_nearby_scan = "250kJ",
        energy_per_sector = "500kJ",
        energy_source = {type = "void"},
        energy_usage = "100kW",
        max_distance_of_nearby_sector_revealed = 4,
        max_distance_of_sector_revealed = 14,

        rotation_speed = 0.015,
        pictures = {
            layers = {
                {
                    filename = "__dimension-warp__/graphics/entities/radio-station/radio-station-hr-shadow.png",
                    priority = "high",
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
                    priority = "high",
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
                    priority = "high",
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