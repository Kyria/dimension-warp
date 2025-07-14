dw.mapgen = dw.mapgen or {}
dw.mapgen.fulgora = dw.mapgen.fulgora or {}

local function add_biters(mapgen)
    mapgen.autoplace_controls["enemy-base"] = {size = 1, frequency = 2}
    mapgen.starting_area = "very-small"
    return mapgen
end

local function barren(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_controls["scrap"].richness = 0
    mapgen.autoplace_settings.entity.settings = {
        ['scrap'] = {},
        ['fulgurite'] = {},
    }
    return mapgen
end

local function dry(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_settings.tile.settings['oil-ocean-shallow'] = nil
    mapgen.autoplace_settings.tile.settings['oil-ocean-deep'] = nil
    return mapgen
end

local function oil_planet(mapgen)
    mapgen = barren(mapgen)
    mapgen.autoplace_settings.tile.settings = {
        ["oil-ocean-shallow"] = {},
        ["oil-ocean-deep"] = {},
    }
    return mapgen
end

local function normal(mapgen)
    mapgen.starting_area = "small"
    mapgen.autoplace_controls["fulgora_islands"] = {size = 4, frequency = 4}
    mapgen.property_expression_names["control:fulgora_islands:frequency"] = 4
    mapgen.property_expression_names["control:fulgora_islands:size"] = 4
    return mapgen
end

local function death_world(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_controls["enemy-base"] = {size = 8, frequency = 4}
    return mapgen
end

local function no_scrap(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_controls["scrap"].richness = 0
    return mapgen
end

local function junkyard(mapgen)
    mapgen = no_scrap(mapgen)
    mapgen.autoplace_settings.entity.settings["fulgoran-ruin-vault"] = {size = 4, frequency = 10}
    mapgen.autoplace_settings.entity.settings["fulgoran-ruin-attractor"] = {size = 4, frequency = 10}
    mapgen.autoplace_settings.entity.settings["fulgoran-ruin-colossal"] = {size = 4, frequency = 10}
    mapgen.autoplace_settings.entity.settings["fulgoran-ruin-huge"] = {size = 4, frequency = 10}
    mapgen.autoplace_settings.entity.settings["fulgoran-ruin-big"] = {size = 4, frequency = 10}
    mapgen.autoplace_settings.entity.settings["fulgoran-ruin-stonehenge"] = {size = 4, frequency = 10}
    mapgen.autoplace_settings.entity.settings["fulgoran-ruin-medium"] = {size = 4, frequency = 10}
    mapgen.autoplace_settings.entity.settings["fulgoran-ruin-small"] = {size = 4, frequency = 10}
    return mapgen
end

local function fulgora_randomizer(mapgen, surface_name)
    mapgen = add_biters(mapgen)
    mapgen.seed = math.random(2^16) + game.tick

    local randomizer_list = {
        {"Normal", normal, "dw-randomizer.fulgora-normal"}
    }
    local randomizer_weights = {10}

    if storage.warp.number >= 50 then
        randomizer_list = util.merge({randomizer_list, {
            {"Barren", barren, "dw-randomizer.fulgora-barren"},
            {"Dry", dry, "dw-randomizer.fulgora-dry"},
            {"Bituminous", oil_planet, "dw-randomizer.fulgora-oil-planet"},
            {"No Scrap", no_scrap, "dw-randomizer.fulgora-no-scrap"},
            {"Junkyard", junkyard, "dw-randomizer.fulgora-junkyard"},
        }})
        randomizer_weights = util.merge({randomizer_weights, {2, 5, 2, 2, 5}})
    end

    if storage.warp.number >= 100 then
        local weight = math.min(4, math.floor(storage.warp.number / 100))
        randomizer_list = util.merge({randomizer_list, {
            {"Death World", death_world, "dw-randomizer.fulgora-death-world"},
        }})
        randomizer_weights = util.merge({randomizer_weights, {weight, weight}})
    end

    local _, randomizer = utils.weighted_random_choice(randomizer_list, randomizer_weights)
    mapgen = dormant(mapgen)

    local surface = game.create_surface(surface_name, mapgen)
    storage.warp.randomizer = randomizer[1]
    storage.warp.message = randomizer[3]

    return surface
end

dw.mapgen.fulgora.randomizer = fulgora_randomizer