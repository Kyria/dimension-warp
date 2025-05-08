
local warp_platform_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, dztint = defines.color.royalblue},
    {icon = data.raw["item"]["concrete"].icon, tint = defines.color.slategrey, scale = 1.5, shift = {20, 20}}
}
local tech_warp_platform_1 = {
    type = "technology", name = "warp-platform-size-1", icons = warp_platform_icon,
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-platform-size"} }},
    prerequisites = {"neo-nauvis", "automation-2", "warp-generator-2"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
}
local tech_warp_platform_2 = {
    type = "technology", name = "warp-platform-size-2", icons = warp_platform_icon,
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-platform-size"} }},
    prerequisites = {"warp-platform-size-1", "electric-energy-distribution-2", "warp-generator-3"},
    unit = {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 2},
        },
        time = 60,
    },
}
local tech_warp_platform_3 = {
    type = "technology", name = "warp-platform-size-3", icons = warp_platform_icon,
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-platform-size"} }},
    prerequisites = {"warp-platform-size-2", "utility-science-pack", "warp-generator-4"},
    unit = {
        count = 2500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 2},
        },
        time = 60,
    },
}
local tech_warp_platform_4 = {
    type = "technology", name = "warp-platform-size-4", icons = warp_platform_icon,
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-platform-size"} }},
    prerequisites = {"warp-platform-size-3", "space-science-pack", "warp-generator-5"},
    unit = {
        count = 5000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 2}
        },
        time = 60,
    },
}
local tech_warp_platform_5 = {
    type = "technology", name = "warp-platform-size-5", icons = warp_platform_icon,
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-platform-size"} }},
    prerequisites = {"warp-platform-size-4"},
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 3}
        },
        time = 60,
    },
}
local tech_warp_platform_6 = {
    type = "technology", name = "warp-platform-size-6", icons = warp_platform_icon,
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-platform-size"} }},
    prerequisites = {"warp-platform-size-5"},
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 3}
        },
        time = 60,
    },
}
local tech_warp_platform_7 = {
    type = "technology", name = "warp-platform-size-7", icons = warp_platform_icon,
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-platform-size"} }},
    prerequisites = {"warp-platform-size-6"},
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 3}
        },
        time = 60,
    },
}

data:extend({
    tech_warp_platform_1,
    tech_warp_platform_2,
    tech_warp_platform_3,
    tech_warp_platform_4,
    tech_warp_platform_5,
    tech_warp_platform_6,
    tech_warp_platform_7
})