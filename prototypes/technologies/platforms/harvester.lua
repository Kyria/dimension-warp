local harvester_right_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
    {icon = "__base__/graphics/technology/electric-mining-drill.png", tint = util.color(defines.hexcolor.orange.. 'd9'), icon_size=256, scale = 0.3, shift = {25, 0}, floating = true},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local harvester_left_icon = {
    {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
    {icon = "__base__/graphics/technology/electric-mining-drill.png", tint = util.color(defines.hexcolor.orange.. 'd9'), icon_size=256, scale = 0.3, shift = {-25, 0}, floating = true},
    {
        icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
local harvester_right_1 = {
    type = "technology", name = "dimension-harvester-right-1", icons = harvester_right_icon,
    prerequisites = {"mining-platform-upgrade-1", "uranium-mining"},
    unit = {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 2},
            {"chemical-science-pack", 1},
        },
        time = 30,
    },
    upgrade = true,
}
local harvester_right_2 = {
    type = "technology", name = "dimension-harvester-right-2", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-1", "electric-engine"},
    unit = {
        count = 1500,
        ingredients = {
            {"automation-science-pack", 2},
            {"logistic-science-pack", 2},
            {"chemical-science-pack", 1},
        },
        time = 30,
    },
    upgrade = true,
}
local harvester_right_3 = {
    type = "technology", name = "dimension-harvester-right-3", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-2", "utility-science-pack"},
    unit = {
        count = 2500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 2},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 2},
        },
        time = 30,
    },
    upgrade = true,
}
local harvester_right_4 = {
    type = "technology", name = "dimension-harvester-right-4", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-3", "logistic-system"},
    unit = {
        count = 5000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 2},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 2},
        },
        time = 30,
    },
    upgrade = true,
}
local harvester_right_5 = {
    type = "technology", name = "dimension-harvester-right-5", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-4", "mining-productivity-3"},
    unit = {
        count = 5000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 2},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
            {"utility-science-pack", 2},
        },
        time = 30,
    },
    upgrade = true,
}
local harvester_right_6 = {
    type = "technology", name = "dimension-harvester-right-6", icons = harvester_right_icon,
    prerequisites = {"dimension-harvester-right-5", "warp-generator-5"},
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 2},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
            {"utility-science-pack", 2},
            {"space-science-pack", 1},
        },
        time = 30,
    },
    upgrade = true,
}

local harvester_left_1 = table.deepcopy(harvester_right_1)
harvester_left_1.name = "dimension-harvester-left-1"
harvester_left_1.icons = harvester_left_icon

local harvester_left_2 = table.deepcopy(harvester_right_2)
harvester_left_2.name = "dimension-harvester-left-2"
harvester_left_2.icons = harvester_left_icon
harvester_left_2.prerequisites = {"dimension-harvester-left-1", "electric-engine"}

local harvester_left_3 = table.deepcopy(harvester_right_3)
harvester_left_3.name = "dimension-harvester-left-3"
harvester_left_3.icons = harvester_left_icon
harvester_left_3.prerequisites = {"dimension-harvester-left-2", "utility-science-pack"}

local harvester_left_4 = table.deepcopy(harvester_right_4)
harvester_left_4.name = "dimension-harvester-left-4"
harvester_left_4.icons = harvester_left_icon
harvester_left_4.prerequisites = {"dimension-harvester-left-3", "logistic-system"}

local harvester_left_5 = table.deepcopy(harvester_right_5)
harvester_left_5.name = "dimension-harvester-left-5"
harvester_left_5.icons = harvester_left_icon
harvester_left_5.prerequisites = {"dimension-harvester-left-4", "mining-productivity-3"}

local harvester_left_6 = table.deepcopy(harvester_right_6)
harvester_left_6.name = "dimension-harvester-left-6"
harvester_left_6.icons = harvester_left_icon
harvester_left_6.prerequisites = {"dimension-harvester-left-5", "warp-generator-5"}

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
}