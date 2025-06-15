--- from Quezler - https://github.com/Quezler/glutenfree/blob/main/mods/warptorio2-warp-harvester-indoor-drill-placement/data.lua
data:extend({{
    type = "resource",
    name = "dw-hidden-ore",

    stage_counts = {
        10000,
        6330,
        3670,
        1930,
        870,
        270,
        100,
        50
    },

    stages = {
        sheet = {
            filename = "__base__/graphics/entity/uranium-ore/uranium-ore.png",
            frame_count = 8,
            height = 64,
            hr_version = {
                filename = "__base__/graphics/entity/uranium-ore/hr-uranium-ore.png",
                frame_count = 8,
                height = 128,
                priority = "extra-high",
                scale = 0.5,
                variation_count = 8,
                width = 128,
                tint = {0, 0, 0, 0} -- invisible
            },
            priority = "extra-high",
            variation_count = 8,
            width = 64,
            tint = {0, 0, 0, 0} -- invisible
        }
    },

    minable = {
        fluid_amount = 10,
        mining_particle = "stone-particle",
        mining_time = 2,
        required_fluid = "fluid-unknown",
    },

}})