data.raw['technology']['warp-platform-size-1'].unit = {
    count = 500,
    ingredients = {
        {"automation-science-pack", 2},
        {"logistic-science-pack", 1},
    },
    time = 60,
}
data.raw['technology']['warp-platform-size-2'].unit = {
    count = 1000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 2},
    },
    time = 60,
}
data.raw['technology']['warp-platform-size-3'].unit = {
    count = 2500,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 2},
    },
    time = 60,
}

data.raw['technology']['warp-platform-size-4'].prerequisites = {"warp-platform-size-3", "warp-generator-5", "planet-discovery-gleba", "planet-discovery-vulcanus", "planet-discovery-fulgora"}
data.raw['technology']['warp-platform-size-4'].unit = {
    count = 5000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 2}
    },
    time = 60,
}

data.raw['technology']['warp-platform-size-5'].prerequisites = {"warp-platform-size-4", "metallurgic-science-pack"}
data.raw['technology']['warp-platform-size-5'].unit = {
    count = 10000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 3},
        {"metallurgic-science-pack", 2}
    },
    time = 60,
}
data.raw['technology']['warp-platform-size-6'].prerequisites = {"warp-platform-size-5", "electromagnetic-science-pack"}
data.raw['technology']['warp-platform-size-6'].unit = {
    count = 10000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 3},
        {"metallurgic-science-pack", 2},
        {"electromagnetic-science-pack", 2}
    },
    time = 60,
}

data.raw['technology']['warp-platform-size-7'].prerequisites = {"warp-platform-size-6", "cryogenic-science-pack"}
data.raw['technology']['warp-platform-size-7'].unit = {
    count = 10000,
    ingredients = {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 3},
        {"metallurgic-science-pack", 2},
        {"electromagnetic-science-pack", 2},
        {"agricultural-science-pack", 2},
        {"cryogenic-science-pack", 2}
    },
    time = 60,
}
