local platform_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
    {icon = "__base__/graphics/technology/automation-3.png", icon_size=256, scale = 0.4, tint = util.color(defines.hexcolor.lightsteelblue.. 'd9'), shift = {20, 20}, floating = true},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local tech_platform = {
    type = "technology", name = "factory-platform", icons = platform_icon,
    prerequisites = {"warp-platform-size-1", "steel-processing"},
    effects = {
        {
            type = "unlock-space-location",
            space_location = "produstia",
            use_icon_overlay_constant = true
        },
    },
    unit = {
        count = 250,
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
    {icon = "__base__/graphics/technology/automation-3.png", tint = util.color(defines.hexcolor.lightsteelblue.. 'd9'), icon_size=256, scale = 0.4, shift = {20, 20}},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local tech_platform_1 = {
    type = "technology", name = "factory-platform-upgrade-1", icons = platform_icon,
    prerequisites = {"factory-platform", "automation-2"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 30,
    },
    upgrade = true,
}
local tech_platform_2 = {
    type = "technology", name = "factory-platform-upgrade-2", icons = platform_icon,
    prerequisites = {"factory-platform-upgrade-1", "advanced-circuit"},
    unit = {
        count = 750,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 30,
    },
    upgrade = true,
}
local tech_platform_3 = {
    type = "technology", name = "factory-platform-upgrade-3", icons = platform_icon,
    prerequisites = {"factory-platform-upgrade-2", "processing-unit"},
    unit = {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
        },
        time = 30,
    },
    upgrade = true,
}
local tech_platform_4 = {
    type = "technology", name = "factory-platform-upgrade-4", icons = platform_icon,
    prerequisites = {"factory-platform-upgrade-3", "production-science-pack"},
    unit = {
        count = 1500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 2},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
        },
        time = 30,
    },
    upgrade = true,
}
local tech_platform_5 = {
    type = "technology", name = "factory-platform-upgrade-5", icons = platform_icon,
    prerequisites = {"factory-platform-upgrade-4", "automation-3"},
    unit = {
        count = 2000,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
        },
        time = 30,
    },
    upgrade = true,
}
local tech_platform_6 = {
    type = "technology", name = "factory-platform-upgrade-6", icons = platform_icon,
    prerequisites = {"factory-platform-upgrade-5", "space-science-pack"},
    unit = {
        count = 2500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
            {"space-science-pack", 2},
        },
        time = 30,
    },
    upgrade = true,
}
local tech_platform_7 = {
    type = "technology", name = "factory-platform-upgrade-7", icons = platform_icon,
    prerequisites = {"factory-platform-upgrade-6", "warp-generator-5"},
    unit = {
        count = 5000,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
            {"space-science-pack", 1},
        },
        time = 30,
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