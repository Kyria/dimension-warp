data:extend{
    {
        type = "technology",
        name = "dw-number-stairs-superior",
        icons = {
            {
                icon = "__base__/graphics/technology/logistics-1.png",
                icon_size = 256,
                tint = defines.color.royalblue,
                scale = 0.5,
                floating = true,
                shift = {10,10}
            },
            {
                icon = "__base__/graphics/technology/logistics-1.png",
                icon_size = 256,
                tint = defines.color.royalblue,
            },
        },
        prerequisites = {
            "warp-platform-size-2",
            "power-platform",
        },
        unit = {
            count = 10000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
            },
            time = 30,
        },
    },
    {
        type = "technology",
        name = "dw-number-stairs-advanced",
        icons = {
            {
                icon = "__base__/graphics/technology/logistics-2.png",
                icon_size = 256,
                tint = defines.color.royalblue,
                scale = 0.5,
                floating = true,
                shift = {10,10}
            },
            {
                icon = "__base__/graphics/technology/logistics-2.png",
                icon_size = 256,
                tint = defines.color.royalblue,
            },
        },
        prerequisites = {
            "logistics-2",
            "chemical-science-pack",
            "power-platform",
        },
        unit = {
            count = 1000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2},
                {"chemical-science-pack", 1},
            },
            time = 30,
        },
    },
}