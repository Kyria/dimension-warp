local icon = {
    {
        icon = "__base__/graphics/technology/inserter-capacity.png",
        icon_size = 256,
        tint = defines.color.royalblue,
    },
    {
        icon = "__core__/graphics/icons/technology/constants/constant-capacity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}

-- adds +5 to inserters
data:extend{
    {
        type = "technology",
        name = "dimension-inserter-capacity-1",
        icons = icon,
        effects = {
            {
                type = "inserter-stack-size-bonus",
                modifier = 1
            },
            {
                type = "bulk-inserter-capacity-bonus",
                modifier = 1
            }
        },
        prerequisites = {"inserter-capacity-bonus-2"},
        unit = {
            count = 600,
            ingredients = {
                {"automation-science-pack", 2},
                {"logistic-science-pack", 2}
            },
            time = 30
        },
        upgrade = true,
    },
    {
        type = "technology",
        name = "dimension-inserter-capacity-2",
        icons = icon,
        effects = {
            {
                type = "inserter-stack-size-bonus",
                modifier = 1
            },
            {
                type = "bulk-inserter-capacity-bonus",
                modifier = 1
            }
        },
        prerequisites = {"inserter-capacity-bonus-1", "dimension-inserter-capacity-1"},
        unit = {
            count = 750,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 3}
            },
            time = 30
        },
        upgrade = true,
    },
    {
        type = "technology",
        name = "dimension-inserter-capacity-3",
        icons = icon,
        effects = {
            {
                type = "inserter-stack-size-bonus",
                modifier = 1
            },
            {
                type = "bulk-inserter-capacity-bonus",
                modifier = 1
            }
        },
        prerequisites = {"inserter-capacity-bonus-2", "dimension-inserter-capacity-2"},
        unit = {
            count = 1000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2},
                {"chemical-science-pack", 2}
            },
            time = 30
        },
        upgrade = true,
    },
    {
        type = "technology",
        name = "dimension-inserter-capacity-4",
        icons = icon,
        effects = {
            {
                type = "inserter-stack-size-bonus",
                modifier = 1
            },
            {
                type = "bulk-inserter-capacity-bonus",
                modifier = 1
            }
        },
        prerequisites = {"inserter-capacity-bonus-3", "dimension-inserter-capacity-3"},
        unit = {
            count = 2000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 2},
                {"production-science-pack", 2}
            },
            time = 30
        },
        upgrade = true,
    },
    {
        type = "technology",
        name = "dimension-inserter-capacity-5",
        icons = icon,
        effects = {
            {
                type = "inserter-stack-size-bonus",
                modifier = 1
            },
            {
                type = "bulk-inserter-capacity-bonus",
                modifier = 1
            }
        },
        prerequisites = {"inserter-capacity-bonus-4", "dimension-inserter-capacity-4"},
        unit = {
            count = 5000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 2},
                {"production-science-pack", 3}
            },
            time = 30
        },
        upgrade = true,
    },
}