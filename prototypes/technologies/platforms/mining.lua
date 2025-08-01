local icon = (mods['space-age']) and "__space-age__/graphics/technology/foundry.png" or "__base__/graphics/technology/advanced-material-processing-2.png"
local platform_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
    {icon = icon, tint = util.color(defines.hexcolor.peachpuff.. 'd9'), icon_size=256, scale = 0.4, shift = {20, 20}, floating = true},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local tech_platform = {
    type = "technology", name = "mining-platform", icons = platform_icon,
    prerequisites = {"factory-platform"},
    effects = {
        {
            type = "unlock-space-location",
            space_location = "smeltus",
            use_icon_overlay_constant = true
        },
    },
    unit = {
        count = 100,
        ingredients = {
            {"automation-science-pack", 1},
        },
        time = 15,
    },
}

--- upgrade techs
---
local platform_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
    {icon = icon, tint = util.color(defines.hexcolor.peachpuff.. 'd9'), icon_size=256, scale = 0.4, shift = {20, 20}},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local tech_platform_1 = {
    type = "technology", name = "mining-platform-upgrade-1", icons = platform_icon,
    prerequisites = {"mining-platform", "electric-mining-drill", "advanced-material-processing"},
    unit = {
        count = 200,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 15,
    },
    upgrade = true,
}
local tech_platform_2 = {
    type = "technology", name = "mining-platform-upgrade-2", icons = platform_icon,
    prerequisites = {"mining-platform-upgrade-1", "plastics"},
    unit = {
        count = 400,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 15,
    },
    upgrade = true,
}
local tech_platform_3 = {
    type = "technology", name = "mining-platform-upgrade-3", icons = platform_icon,
    prerequisites = {"mining-platform-upgrade-2", "low-density-structure"},
    unit = {
        count = 700,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
        },
        time = 15,
    },
    upgrade = true,
}
local tech_platform_4 = {
    type = "technology", name = "mining-platform-upgrade-4", icons = platform_icon,
    prerequisites = {"mining-platform-upgrade-3", "advanced-material-processing-2"},
    unit = {
        count = 1100,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
        },
        time = 15,
    },
    upgrade = true,
}
local tech_platform_5 = {
    type = "technology", name = "mining-platform-upgrade-5", icons = platform_icon,
    prerequisites = {"mining-platform-upgrade-4", "coal-liquefaction"},
    unit = {
        count = 1600,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
        },
        time = 15,
    },
    upgrade = true,
}
local tech_platform_6 = {
    type = "technology", name = "mining-platform-upgrade-6", icons = platform_icon,
    prerequisites = {"mining-platform-upgrade-5", "space-science-pack"},
    unit = {
        count = 2500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
            {"space-science-pack", 2},
        },
        time = 15,
    },
    upgrade = true,
}
local tech_platform_7 = {
    type = "technology", name = "mining-platform-upgrade-7", icons = platform_icon,
    prerequisites = {"mining-platform-upgrade-6", "warp-generator-5"},
    unit = {
        count = 5000,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
            {"space-science-pack", 2},
        },
        time = 15,
    },
    upgrade = true,
}

data:extend{
    tech_platform,
    tech_platform_1,
    tech_platform_2,
    tech_platform_3,
    tech_platform_4,
    tech_platform_5,
    tech_platform_6,
    tech_platform_7
}