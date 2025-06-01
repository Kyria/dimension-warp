local icons = {
    {
        icon = "__base__/graphics/technology/mining-productivity.png",
        icon_size = 256,
        tint = util.color(defines.hexcolor.royalblue.. 'd9')
    },
    {
        icon = "__core__/graphics/icons/technology/constants/constant-mining-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}

data:extend{
    {
        type = "technology",
        name = "dimension-mining-productivity-1",
        icons = icons,
        effects = {
            {
                type = "mining-drill-productivity-bonus",
                modifier = 0.1
            }
        },
        prerequisites = {"mining-productivity-1"},
        unit = {
            count_formula = "250+L*50",
            ingredients =
            {
                {"automation-science-pack", 2},
                {"logistic-science-pack", 1}
            },
            time = 60
        },
        upgrade = true,
        max_level = 5
    },
    {
        type = "technology",
        name = "dimension-mining-productivity-6",
        icons = icons,
        effects = {
            {
                type = "mining-drill-productivity-bonus",
                modifier = 0.1
            }
        },
        prerequisites = {"mining-productivity-2", "dimension-mining-productivity-1"},
        unit = {
            count_formula = "500+(L-5)*100",
            ingredients =
            {
                {"automation-science-pack", 2},
                {"logistic-science-pack", 2},
                {"chemical-science-pack", 1}
            },
            time = 60
        },
        upgrade = true,
        max_level = 10
    },
    {
        type = "technology",
        name = "dimension-mining-productivity-11",
        icons = icons,
        effects = {
            {
                type = "mining-drill-productivity-bonus",
                modifier = 0.1
            }
        },
        prerequisites = {"mining-productivity-2", "production-science-pack", "dimension-mining-productivity-6"},
        unit = {
            count_formula = "1000+(L-10)*250",
            ingredients =
            {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2},
                {"chemical-science-pack", 2},
                {"production-science-pack", 1},
            },
            time = 60
        },
        upgrade = true,
        max_level = 15
    },
    {
        type = "technology",
        name = "dimension-mining-productivity-16",
        icons = icons,
        effects = {
            {
                type = "mining-drill-productivity-bonus",
                modifier = 0.1
            }
        },
        prerequisites = {"mining-productivity-3", "dimension-mining-productivity-11"},
        unit = {
            count_formula = "2000+(L-15)*500",
            ingredients =
            {
                {"automation-science-pack", 2},
                {"logistic-science-pack", 2},
                {"chemical-science-pack", 2},
                {"production-science-pack", 1},
                {"utility-science-pack", 1},
            },
            time = 60
        },
        upgrade = true,
        max_level = 20
    },
}