local icon = "__base__/graphics/technology/nuclear-power.png"
local platform_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
    {icon = icon, tint = util.color(defines.hexcolor.darkgoldenrod.. 'd9'), icon_size=256, scale = 0.4, shift = {20, 20}, floating = true},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}

local tech_platform = {
    type = "technology", name = "power-platform", icons = platform_icon,
    prerequisites = {"mining-platform"},
    effects = {
        {
            type = "unlock-space-location",
            space_location = "electria",
            use_icon_overlay_constant = true
        },
    },
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
        },
        time = 60,
    },
}

--- upgrade techs
---
local platform_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
    {icon = icon, tint = util.color(defines.hexcolor.darkgoldenrod.. 'd9'), icon_size=256, scale = 0.4, shift = {20, 20}},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local tech_platform_1 = {
    type = "technology", name = "power-platform-upgrade-1", icons = platform_icon,
    prerequisites = {"power-platform", "electric-energy-distribution-1"},
    unit = {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 2},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_2 = {
    type = "technology", name = "power-platform-upgrade-2", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-1", "electric-energy-accumulators"},
    unit = {
        count = 1500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 3},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_3 = {
    type = "technology", name = "power-platform-upgrade-3", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-2", "electric-energy-distribution-2"},
    unit = {
        count = 1500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 2},
            {"chemical-science-pack", 2},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_4 = {
    type = "technology", name = "power-platform-upgrade-4", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-3", "nuclear-power"},
    unit = {
        count = 2000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 2},
            {"chemical-science-pack", 3},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_5 = {
    type = "technology", name = "power-platform-upgrade-5", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-4", "kovarex-enrichment-process"},
    unit = {
        count = 2500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 2},
            {"production-science-pack", 2},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_6 = {
    type = "technology", name = "power-platform-upgrade-6", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-5", "space-science-pack"},
    unit = {
        count = 5000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 2},
            {"production-science-pack", 2},
            {"space-science-pack", 2},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_7 = {
    type = "technology", name = "power-platform-upgrade-7", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-6", "warp-generator-5"},
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 2},
            {"production-science-pack", 2},
            {"space-science-pack", 2},
        },
        time = 60,
    },
    upgrade = true,
}

local water_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
    {icon = icon, tint = util.color(defines.hexcolor.darkgoldenrod.. 'd9'), icon_size=256, scale = 0.4, shift = {20, 20}, floating = true},
    {
        icon = "__base__/graphics/icons/fluid/water.png",
        icon_size = 64,
        scale = 0.8,
        shift = {40, 40},
        floating = true
    }
}
local water = {
    type = "technology", name = "power-platform-water", icons = water_icon,
    prerequisites = {"power-platform-upgrade-2", "platform-radar"},
    unit = {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 60,
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
    tech_platform_7,
    water,
}