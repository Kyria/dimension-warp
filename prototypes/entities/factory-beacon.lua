-- everything here comes from wretlaw120 - Beacon Rebalance
-- with a few adjustment to fit the mod needs
local base = util.table.deepcopy(data.raw["beacon"]["beacon"])
base.icons = {util.empty_icon()}
base.icon_size = nil
base.icon = nil
base.icon_mipmaps = 4
base.corpse = "medium-remnants"
base.graphics_set = {
    module_icons_suppressed = false,
    animation_list = {
        -- Beacon Base
        {
            render_layer = "lower-object-above-shadow",
            always_draw = true,
            animation = {
                layers = {
                    -- Base
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/beacon-base.png",
                        width = 232,
                        height = 186,
                        shift = util.by_pixel(11*(4/3), 1.5*(4/3)),
                        scale = 0.5*(4/3),
                    },
                    -- Shadow
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/hr-beacon-base-shadow.png",
                        width = 232,
                        height = 186,
                        shift = util.by_pixel(11*(4/3), 1.5*(4/3)),
                        draw_as_shadow = true,
                        scale = 0.5*(4/3),
                    }
                }
            }
        },
        -- Beacon Antenna
        {
            render_layer = "object",
            always_draw = true,
            animation = {
                layers = {
                    -- Base
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/hr-beacon-antenna-blue.png",
                        width = 108,
                        height = 100,
                        line_length = 8,
                        frame_count = 32,
                        animation_speed = 0.5,
                        shift = util.by_pixel(-1*(4/3), -55*(4/3)),
                        scale = 0.5*(4/3),
                    },
                    -- Shadow
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/hr-beacon-antenna-shadow.png",
                        width = 126,
                        height = 98,
                        line_length = 8,
                        frame_count = 32,
                        animation_speed = 0.5,
                        shift = util.by_pixel(100.5*(4/3), 15.5*(4/3)),
                        draw_as_shadow = true,
                        scale = 0.5*(4/3),
                    }
                }
            }
        }
    }
}
base.water_reflection = {
    pictures = {
        filename = "__dimension-warp__/graphics/entities/factory-beacon/beacon-reflection.png",
        priority = "extra-high",
        width = 24,
        height = 28,
        shift = util.by_pixel(0*(4/3), 55*(4/3)),
        variation_count = 1,
        scale = 5*(4/3),
    },
    rotate = false,
    orientation_to_variation = false
}
base.graphics_set.module_visualisations = {
    -- vanilla art style
    {
        art_style = "vanilla",
        use_for_empty_slots = true,
        tier_offset = 0,
        slots =
        {
            -- slot 1
            {
                {
                    has_empty_slot = true,
                    render_layer = "lower-object",
                    pictures =
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/blank.png",
                        line_length = 4,
                        width = 50,
                        height = 66,
                        variation_count = 4,
                        scale = 0.5,
                        shift = util.by_pixel(-16, 14.5)
                    }
                },
                {
                    apply_module_tint = "primary",
                    render_layer = "lower-object",
                    pictures =
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/blank.png",
                        line_length = 3,
                        width = 36,
                        height = 32,
                        variation_count = 3,
                        scale = 0.5,
                        shift = util.by_pixel(-17, 15)
                    }
                },
                {
                    apply_module_tint = "secondary",
                    render_layer = "lower-object-above-shadow",
                    pictures =
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/blank.png",
                        line_length = 3,
                        width = 26,
                        height = 12,
                        variation_count = 3,
                        scale = 0.5,
                        shift = util.by_pixel(-18.5, 13)
                    }
                },
                {
                    apply_module_tint = "secondary",
                    draw_as_light = true,
                    draw_as_sprite = false,
                    pictures =
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/blank.png",
                        line_length = 3,
                        width = 56,
                        height = 42,
                        variation_count = 3,
                        shift = util.by_pixel(-18, 13),
                        scale = 0.5
                    }
                }
            },
            --slot 2 lazy copy version
            {
                {
                    has_empty_slot = true,
                    render_layer = "lower-object",
                    pictures =
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/blank.png",
                        line_length = 4,
                        width = 50,
                        height = 66,
                        variation_count = 4,
                        scale = 0.5,
                        shift = util.by_pixel(-16, 14.5)
                    }
                },
                {
                    apply_module_tint = "primary",
                    render_layer = "lower-object",
                    pictures =
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/blank.png",
                        line_length = 3,
                        width = 36,
                        height = 32,
                        variation_count = 3,
                        scale = 0.5,
                        shift = util.by_pixel(-17, 15)
                    }
                },
                {
                    apply_module_tint = "secondary",
                    render_layer = "lower-object-above-shadow",
                    pictures =
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/blank.png",
                        line_length = 3,
                        width = 26,
                        height = 12,
                        variation_count = 3,
                        scale = 0.5,
                        shift = util.by_pixel(-18.5, 13)
                    }
                },
                {
                    apply_module_tint = "secondary",
                    draw_as_light = true,
                    draw_as_sprite = false,
                    pictures =
                    {
                        filename = "__dimension-warp__/graphics/entities/factory-beacon/blank.png",
                        line_length = 3,
                        width = 56,
                        height = 42,
                        variation_count = 3,
                        shift = util.by_pixel(-18, 13),
                        scale = 0.5
                    }
                }
            }
        }
    } -- end vanilla art style
}
base.module_slots = 10
base.supply_area_distance = 64
base.icons_positioning = {{
    inventory_index = defines.inventory.beacon_modules,
    max_icons_per_row = 5,
    scale = .5,
    separation_multiplier = 1.1,
    multi_row_initial_height_modifier = -.3
}}
base.profile = {1, 1}
base.distribution_effectivity = 1
base.beacon_counter = "total"
base.minable = nil
base.collision_box = {{-1.8, -1.8}, {1.8, 1.8}}
base.selection_box = {{-2, -2}, {2, 2}}
base.drawing_box = {{-2, -2}, {2, 2}}
base.energy_usage = "20MW"
base.placeable_by = nil
base.fast_replaceable_group = "factory-beacon"
base.allowed_effects = {"consumption", "speed", "pollution", "productivity", "quality"}

------------------------
---     Beacons      ---
------------------------
local beacon_1 = table.deepcopy(base)
beacon_1.name = "dw-factory-beacon-1"
beacon_1.module_slots = 3
beacon_1.supply_area_distance = 8
beacon_1.energy_usage = "20MW"

local beacon_2 = table.deepcopy(base)
beacon_2.name = "dw-factory-beacon-2"
beacon_2.module_slots = 4
beacon_2.supply_area_distance = 12
beacon_2.energy_usage = "40MW"

local beacon_3 = table.deepcopy(base)
beacon_3.name = "dw-factory-beacon-3"
beacon_3.module_slots = 5
beacon_3.supply_area_distance = 17
beacon_3.energy_usage = "60MW"

local beacon_4 = table.deepcopy(base)
beacon_4.name = "dw-factory-beacon-4"
beacon_4.module_slots = 6
beacon_4.supply_area_distance = 24
beacon_4.energy_usage = "80MW"

local beacon_5 = table.deepcopy(base)
beacon_5.name = "dw-factory-beacon-5"
beacon_5.module_slots = 7
beacon_5.supply_area_distance = 34
beacon_5.energy_usage = "100MW"

local beacon_6 = table.deepcopy(base)
beacon_6.name = "dw-factory-beacon-6"
beacon_6.module_slots = 8
beacon_6.supply_area_distance = 45
beacon_6.energy_usage = "200MW"

local beacon_7 = table.deepcopy(base)
beacon_7.name = "dw-factory-beacon-7"
beacon_7.module_slots = 10
beacon_7.supply_area_distance = 64
beacon_7.energy_usage = "500MW"

data:extend{
    beacon_1,
    beacon_2,
    beacon_3,
    beacon_4,
    beacon_5,
    beacon_6,
    beacon_7,
}