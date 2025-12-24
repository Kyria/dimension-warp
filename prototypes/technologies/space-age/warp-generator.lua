data.raw['technology']['warp-generator-5'].prerequisites = {"warp-generator-4", "space-science-pack"}
data.raw['technology']['warp-generator-5'].unit = {
    count = 1000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 2},
        {"chemical-science-pack", 1},
        {"space-science-pack", 2}
    },
    time = 15,
}

data.raw['technology']['warp-generator-6'].unit = {
    count = 2500,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 2},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 2},
        {"production-science-pack", 2},
        {"space-science-pack", 2}
    },
    time = 15,
}

--- preferred planet selector
data:extend{{ -- 60min
    type = "technology", name = "warp-preferred-planet",
    icons = {
        {icon = "__dimension-warp__/graphics/icons/technologies/dimension-warp-512.png", tint = util.color('#aaaaaa77'), icon_size = 512},
        {
            icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
            icon_size = 128,
            scale = 0.75,
            shift = {50, 45},
            floating = true,
        }
    },
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-preferred-planet"} }},
    prerequisites = {"warp-generator-5", "space-science-pack"},
    unit = {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack", 1},
            {"chemical-science-pack", 1},
            {"space-science-pack", 2},
        },
        time = 15,
    },
}}