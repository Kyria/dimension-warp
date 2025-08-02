local factory_4 = data.raw['technology']['factory-platform-upgrade-4']
table.insert(factory_4.prerequisites, "space-science-pack")
table.insert(factory_4.prerequisites, "warp-generator-5")
table.insert(factory_4.unit.ingredients, {"space-science-pack", 1})

local factory_5 = data.raw['technology']['factory-platform-upgrade-5']
table.insert(factory_5.prerequisites, "turbo-transport-belt")
table.insert(factory_5.unit.ingredients, {"space-science-pack", 1})
table.insert(factory_5.unit.ingredients, {"metallurgic-science-pack", 2})

local factory_6 = data.raw['technology']['factory-platform-upgrade-6']
factory_6.prerequisites = {"factory-platform-upgrade-5", "biolab"}
factory_6.unit = {
    count = 2500,
    ingredients = {
        {"automation-science-pack", 2},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 2},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 1},
        {"agricultural-science-pack", 2},
        {"electromagnetic-science-pack", 2},
    },
    time = 15,
}


local factory_7 = data.raw['technology']['factory-platform-upgrade-7']
factory_7.prerequisites = {"factory-platform-upgrade-6", "quantum-processor"}
factory_7.unit = {
    count = 5000,
    ingredients = {
        {"automation-science-pack", 2},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 2},
        {"space-science-pack", 1},
        {"metallurgic-science-pack", 1},
        {"agricultural-science-pack", 1},
        {"electromagnetic-science-pack", 1},
        {"cryogenic-science-pack", 2},
    },
    time = 15,
}