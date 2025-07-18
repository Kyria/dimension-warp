local mining_4 = data.raw['technology']['mining-platform-upgrade-4']
table.insert(mining_4.prerequisites, "space-science-pack")
table.insert(mining_4.prerequisites, "warp-generator-5")
table.insert(mining_4.unit.ingredients, {"space-science-pack", 1})

local mining_5 = data.raw['technology']['mining-platform-upgrade-5']
mining_5.unit = {
    count = 2000,
    ingredients = {
        {"automation-science-pack", 2},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 2},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 2},
    },
    time = 30,
}

local mining_6 = data.raw['technology']['mining-platform-upgrade-6']
mining_6.prerequisites = {"mining-platform-upgrade-5", "stack-inserter"}
mining_6.unit = {
    count = 2500,
    ingredients = {
        {"automation-science-pack", 2},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 2},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 2},
        {"agricultural-science-pack", 2},
    },
    time = 30,
}

local mining_7 = data.raw['technology']['mining-platform-upgrade-7']
mining_7.prerequisites = {"mining-platform-upgrade-6", "productivity-module-3"}
mining_7.unit = {
    count = 5000,
    ingredients = {
        {"automation-science-pack", 2},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 2},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 2},
        {"agricultural-science-pack", 2},
    },
    time = 30,
}
