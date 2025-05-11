local harvester_right_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = defines.color.royalblue},
    {icon = "__base__/graphics/icons/electric-mining-drill.png", tint = defines.color.orange, scale = 1.2, shift = {25, 25}},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-mining-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local harvester_left_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = defines.color.royalblue},
    {icon = "__base__/graphics/icons/electric-mining-drill.png", tint = defines.color.orange, scale = 1.2, shift = {-25, 25}},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-mining-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local harvester_top_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = defines.color.royalblue},
    {icon = "__base__/graphics/icons/electric-mining-drill.png", tint = defines.color.orange, scale = 1.2, shift = {0, -25}},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-mining-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}

local harvester_right_1 = {
    type = "technology", name = "dimension-harvester-right-1", icons = harvester_right_icon,
    prerequisites = {"mining-platform"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
}
local harvester_right_2 = {
    type = "technology", name = "dimension-harvester-right-2", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-1"},
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
local harvester_right_3 = {
    type = "technology", name = "dimension-harvester-right-3", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-2"},
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
local harvester_right_4 = {
    type = "technology", name = "dimension-harvester-right-4", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-3"},
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
local harvester_right_5 = {
    type = "technology", name = "dimension-harvester-right-5", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-4"},
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
local harvester_right_6 = {
    type = "technology", name = "dimension-harvester-right-6", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-5"},
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

local harvester_left_1 = {
    type = "technology", name = "dimension-harvester-left-1", icons = harvester_left_icon,
    prerequisites = {"mining-platform"},
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
local harvester_left_2 = {
    type = "technology", name = "dimension-harvester-left-2", icons = harvester_left_icon,
    prerequisites = {"dimension-harvester-left-1"},
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
local harvester_left_3 = {
    type = "technology", name = "dimension-harvester-left-3", icons = harvester_left_icon,
    prerequisites = {"dimension-harvester-left-2"},
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
local harvester_left_4 = {
    type = "technology", name = "dimension-harvester-left-4", icons = harvester_left_icon,
    prerequisites = {"dimension-harvester-left-3"},
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
local harvester_left_5 = {
    type = "technology", name = "dimension-harvester-left-5", icons = harvester_left_icon,
    prerequisites = {"dimension-harvester-left-4"},
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
local harvester_left_6 = {
    type = "technology", name = "dimension-harvester-left-6", icons = harvester_left_icon,
    prerequisites = {"dimension-harvester-left-5"},
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

local harvester_top_1 = {
    type = "technology", name = "dimension-harvester-top-1", icons = harvester_top_icon,
    prerequisites = {"mining-platform"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 1},
        },
        time = 60,
    },
}
local harvester_top_2 = {
    type = "technology", name = "dimension-harvester-top-2", icons = harvester_top_icon,
    prerequisites = {"dimension-harvester-top-1"},
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
local harvester_top_3 = {
    type = "technology", name = "dimension-harvester-top-3", icons = harvester_top_icon,
    prerequisites = {"dimension-harvester-top-2"},
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
local harvester_top_4 = {
    type = "technology", name = "dimension-harvester-top-4", icons = harvester_top_icon,
    prerequisites = {"dimension-harvester-top-3"},
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
local harvester_top_5 = {
    type = "technology", name = "dimension-harvester-top-5", icons = harvester_top_icon,
    prerequisites = {"dimension-harvester-top-4"},
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
local harvester_top_6 = {
    type = "technology", name = "dimension-harvester-top-6", icons = harvester_top_icon,
    prerequisites = {"dimension-harvester-top-5"},
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
    harvester_right_1,
    harvester_right_2,
    harvester_right_3,
    harvester_right_4,
    harvester_right_5,
    harvester_right_6,
    harvester_left_1,
    harvester_left_2,
    harvester_left_3,
    harvester_left_4,
    harvester_left_5,
    harvester_left_6,
    harvester_top_1,
    harvester_top_2,
    harvester_top_3,
    harvester_top_4,
    harvester_top_5,
    harvester_top_6,
}