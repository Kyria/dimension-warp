local icons = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = defines.color.royalblue},
    {icon = "__base__/graphics/technology/research-speed.png", tint = util.color(defines.hexcolor.deepskyblue .. '77'), icon_size=256, scale = 0.4, shift = {20, 20}, floating = true},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
data:extend{
    {
        type = "technology",
        name = "dw-warp-gate-1",
        icons = icons,
        prerequisites = {"circuit-network", "warp-generator-3"},
        unit = {
            count = 500,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
            },
            time = 60,
        },
    },
    {
        type = "technology",
        name = "dw-warp-gate-2",
        icons = icons,
        prerequisites = {"oil-processing", "dw-warp-gate-1"},
        unit = {
            count = 500,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2},
            },
            time = 60,
        },
    },
    {
        type = "technology",
        name = "dw-warp-gate-3",
        icons = icons,
        prerequisites = {"electric-energy-accumulators", "dw-warp-gate-2", "chemical-science-pack", "military-science-pack"},
        unit = {
            count = 1000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2},
                {"military-science-pack", 1},
                {"chemical-science-pack", 1},
            },
            time = 60,
        },
    },
    {
        type = "technology",
        name = "dw-warp-gate-4",
        icons = icons,
        prerequisites = {"dw-warp-gate-3", "fission-reactor-equipment"},
        unit = {
            count = 2000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"military-science-pack", 1},
                {"chemical-science-pack", 1},
                {"utility-science-pack", 2},
            },
            time = 60,
        },
    },
    {
        type = "technology",
        name = "dw-warp-gate-5",
        icons = icons,
        prerequisites = {"warp-generator-5","dw-warp-gate-4"},
        unit = {
            count = 2000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"military-science-pack", 1},
                {"chemical-science-pack", 1},
                {"utility-science-pack", 2},
                {"space-science-pack", 2},
            },
            time = 60,
        },
    }
}