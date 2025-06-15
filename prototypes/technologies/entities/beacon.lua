local function make_tech(level, prerequisites, unit)
    return {
        type = "technology",
        name = "dw-factory-beacon-" .. level,
        localised_description = {"technology-description.dw-factory-beacon-" .. level},
        icons = {
            {
                icon = "__base__/graphics/technology/effect-transmission.png",
                icon_size = 256,
                tint = util.color(defines.hexcolor.royalblue.. 'd9'),
            }
        },
        prerequisites = prerequisites,
        unit = unit,
    }
end

local beacon_1 = make_tech(1,
    {"modules", "factory-platform"},
    {
        count = 500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 60,
    }
)
local beacon_2 = make_tech(2,
    {"dw-factory-beacon-1", "factory-platform-upgrade-1"},
    {
        count = 750,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 60,
    }
)

local beacon_3 = make_tech(3,
    {"dw-factory-beacon-2", "factory-platform-upgrade-2"},
    {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 60,
    }
)

local beacon_4 = make_tech(4,
    {"dw-factory-beacon-3", "factory-platform-upgrade-3"},
    {
        count = 500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
        },
        time = 60,
    }
)

local beacon_5 = make_tech(5,
    {"dw-factory-beacon-4", "factory-platform-upgrade-4"},
    {
        count = 500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
        },
        time = 60,
    }
)

local beacon_6 = make_tech(6,
    {"dw-factory-beacon-5", "factory-platform-upgrade-5"},
    {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
        },
        time = 60,
    }
)

local beacon_7 = make_tech(7,
    {"dw-factory-beacon-6", "factory-platform-upgrade-6"},
    {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"production-science-pack", 1},
            {"space-science-pack", 1},
        },
        time = 60,
    }
)


data:extend{
    beacon_1,
    beacon_2,
    beacon_3,
    beacon_4,
    beacon_5,
    beacon_6,
    beacon_7,
}

