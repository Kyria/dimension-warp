local power_4 = data.raw['technology']['power-platform-upgrade-4']
table.insert(power_4.prerequisites, "space-science-pack")
table.insert(power_4.prerequisites, "warp-generator-5")
table.insert(power_4.unit.ingredients, {"space-science-pack", 1})

local power_5 = data.raw['technology']['power-platform-upgrade-5']
power_5.prerequisites = {"power-platform-upgrade-4", "lightning-collector"}
power_5.unit = {
    count = 2500,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 2},
        {"space-science-pack", 1},
        {"electromagnetic-science-pack", 2},
    },
    time = 30,
}


local power_6 = data.raw['technology']['power-platform-upgrade-6']
power_6.prerequisites = {"power-platform-upgrade-5", "agricultural-science-pack"}
power_6.unit = {
    count = 5000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 2},
        {"space-science-pack", 1},
        {"electromagnetic-science-pack", 2},
        {"agricultural-science-pack", 2},
    },
    time = 30,
}


local power_7 = data.raw['technology']['power-platform-upgrade-7']
power_7.prerequisites = {"power-platform-upgrade-6", "fusion-reactor"}
power_7.unit = {
    count = 10000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"space-science-pack", 1},
        {"electromagnetic-science-pack", 2},
        {"agricultural-science-pack", 2},
        {"cryogenic-science-pack", 2},
    },
    time = 30,
}