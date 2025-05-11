local icon = (mods['space-age']) and "__space-age__/graphics/icons/lightning.png" or "__base__/graphics/icons/accumulator.png"
local platform_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = defines.color.royalblue},
    {icon = icon, tint = defines.color.darkgoldenrod, scale = 1.5, shift = {20, 20}},
}

local tech_platform = {
    type = "technology", name = "power-platform", icons = platform_icon,
    prerequisites = {"neo-nauvis"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
}

--- upgrade techs
---
local platform_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = defines.color.royalblue},
    {icon = icon, tint = defines.color.darkgoldenrod, scale = 1.5, shift = {20, 20}},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-mining-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local tech_platform_1 = {
    type = "technology", name = "power-platform-upgrade-1", icons = platform_icon,
    prerequisites = {"power-platform"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
}
local tech_platform_2 = {
    type = "technology", name = "power-platform-upgrade-2", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-1"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_3 = {
    type = "technology", name = "power-platform-upgrade-3", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-2"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_4 = {
    type = "technology", name = "power-platform-upgrade-4", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-3"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_5 = {
    type = "technology", name = "power-platform-upgrade-5", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-4"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_6 = {
    type = "technology", name = "power-platform-upgrade-6", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-5"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
    upgrade = true,
}
local tech_platform_7 = {
    type = "technology", name = "power-platform-upgrade-7", icons = platform_icon,
    prerequisites = {"power-platform-upgrade-6"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
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
    tech_platform_7
}