local harvester_right_3 = data.raw['technology']['dimension-harvester-right-3']
table.insert(harvester_right_3.prerequisites, "space-science-pack")
table.insert(harvester_right_3.unit.ingredients, {"space-science-pack", 1})

local harvester_right_4 = data.raw['technology']['dimension-harvester-right-4']
harvester_right_4.prerequisites = {"dimension-harvester-right-3", "big-mining-drill"}
harvester_right_4.unit = {
    count = 7500,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 2},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 2},
        {"production-science-pack", 2},
        {"space-science-pack", 1},
    },
    time = 30,
}

local harvester_right_5 = data.raw['technology']['dimension-harvester-right-5']
harvester_right_5.prerequisites = {"dimension-harvester-right-4", "turbo-transport-belt"}
harvester_right_5.unit = {
    count = 10000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 2},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 2},
        {"production-science-pack", 2},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 1},
    },
    time = 30,
}

local harvester_right_6 = data.raw['technology']['dimension-harvester-right-6']
harvester_right_6.prerequisites = {"dimension-harvester-right-5", "fish-breeding"}
harvester_right_6.unit = {
    count = 10000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 2},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 2},
        {"space-science-pack", 1},
        {"production-science-pack", 2},
        {"metallurgic-science-pack", 1},
        {"agricultural-science-pack", 1},
    },
    time = 30,
}

-- left harvester upgrades
local harvester_left_3 = data.raw['technology']['dimension-harvester-left-3']
table.insert(harvester_left_3.prerequisites, "space-science-pack")
harvester_left_3.unit = table.deepcopy(harvester_right_3.unit)

local harvester_left_4 = data.raw['technology']['dimension-harvester-left-4']
harvester_left_4.prerequisites = {"dimension-harvester-left-3", "big-mining-drill"}
harvester_left_4.unit = table.deepcopy(harvester_right_4.unit)

local harvester_left_5 = data.raw['technology']['dimension-harvester-left-5']
harvester_left_5.prerequisites = {"dimension-harvester-left-4", "turbo-transport-belt"}
harvester_left_5.unit = table.deepcopy(harvester_right_5.unit)

local harvester_left_6 = data.raw['technology']['dimension-harvester-left-6']
harvester_left_6.prerequisites = {"dimension-harvester-left-5", "fish-breeding"}
harvester_left_6.unit = table.deepcopy(harvester_right_6.unit)
