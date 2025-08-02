local icon = {
    {
        icon = "__base__/graphics/technology/toolbelt.png",
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
}

data:extend {
    {
        type = "technology",
        name = "dimension-toolbelt-1",
        icons = icon,
        prerequisites = {"toolbelt"},
        effects = {
            {
                type = "character-inventory-slots-bonus",
                modifier = 10
            }
        },
        research_trigger = {
            type = "build-entity",
            entity = "electric-mining-drill",
        },
    },
    {
        type = "technology",
        name = "dimension-toolbelt-2",
        icons = icon,
        prerequisites = {"dimension-toolbelt-1"},
        effects = {
            {
                type = "character-inventory-slots-bonus",
                modifier = 10
            }
        },
        unit = {
            count_formula = "(2^L)*20",
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
            },
            time = 30,
        },
        max_level = 5,
        upgrade = true
    },
}