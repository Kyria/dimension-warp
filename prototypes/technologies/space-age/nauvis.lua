local tech = data.raw['technology']['stabilize-dimensions']
if not tech then return end

tech.prerequisites = {"warp-generator-6", "promethium-science-pack"}

tech.unit = {
    count = 10000,
    ingredients = {
        {"automation-science-pack",   1},
        {"logistic-science-pack",     1},
        {"military-science-pack",     1},
        {"chemical-science-pack",     1},
        {"production-science-pack",   1},
        {"utility-science-pack",      1},
        {"space-science-pack",        1},
        {"metallurgic-science-pack",  1},
        {"agricultural-science-pack", 1},
        {"electromagnetic-science-pack", 1},
        {"cryogenic-science-pack",    1},
        {"promethium-science-pack",   1},
    },
    time = 60,
}
