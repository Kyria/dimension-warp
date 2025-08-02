data:extend{
    {
        type = "technology",
        name = "dw-number-stairs-advanced",
        icons = {
            {
                icon = "__base__/graphics/technology/logistics-1.png",
                icon_size = 256,
                tint = util.color(defines.hexcolor.royalblue.. 'd9'),
            },
            {
                icon = "__core__/graphics/icons/technology/constants/constant-capacity.png",
                icon_size = 128,
                scale = 0.5,
                shift = {50, 50},
                floating = true
            }
        },
        prerequisites = {
            "warp-platform-size-2",
            "power-platform",
        },
        unit = {
            count = 10000,
            ingredients = {
                {"automation-science-pack", 1},
            },
            time = 15,
        },
    },
    {
        type = "technology",
        name = "dw-number-stairs-superior",
        icons = {
            {
                icon = "__base__/graphics/technology/logistics-2.png",
                icon_size = 256,
                tint = util.color(defines.hexcolor.royalblue.. 'd9'),
            },
            {
                icon = "__core__/graphics/icons/technology/constants/constant-capacity.png",
                icon_size = 128,
                scale = 0.5,
                shift = {50, 50},
                floating = true
            }
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
    {
        type = "technology",
        name = "dw-stair-logistic-chest",
        icons = {
            {
                icon = "__base__/graphics/technology/logistic-system.png",
                icon_size = 256,
                tint = util.color(defines.hexcolor.royalblue.. 'd9'),
            },
        },
        prerequisites = {
            "logistic-system",
            "power-platform",
        },
        unit = {
            count = 500,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2},
                {"chemical-science-pack", 1},
                {"utility-science-pack", 1},
            },
            time = 30,
        },
    },
}