dw.mapgen = dw.mapgen or {}
dw.mapgen.fulgora = dw.mapgen.fulgora or {}

local function add_biters(mapgen)
    mapgen.autoplace_controls["enemy-base"] = {size = 1, frequency = 2}
    mapgen.starting_area = "very-small"
    return mapgen
end

local function normal(mapgen)
    mapgen.starting_area = "small"
    mapgen.autoplace_controls['scrap'] = {frequency = 1, size = 1, richness = 1}
    mapgen.autoplace_controls["fulgora_islands"] = {size = 6, frequency = 6}
    mapgen.property_expression_names["control:fulgora_islands:frequency"] = 4
    mapgen.property_expression_names["control:fulgora_islands:size"] = 4
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
    mapgen.autoplace_controls['fulgora_cliff'].frequency = 0
    mapgen.autoplace_settings.tile.settings = {
        ["oil-ocean-shallow"] = {},
        ["oil-ocean-deep"] = {},
    }
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
    mapgen.autoplace_controls["enemy-base"] = {size = 4, frequency = 4}
    mapgen.property_expression_names.fulgora_ruins_walls = 2
    mapgen.property_expression_names.fulgora_ruins_paving = 2
    mapgen.property_expression_names.fulgora_road_jitter = 2
    mapgen.property_expression_names.fulgora_road_cells = 2
    mapgen.property_expression_names.fulgora_road_pyramids = 2
    mapgen.property_expression_names.fulgora_pyramids_banding = 2
    mapgen.property_expression_names.fulgora_spots_prebanding = 2
    mapgen.property_expression_names.fulgora_spots_banding = 2
    mapgen.property_expression_names.fulgora_structure_jitter = 2
    mapgen.property_expression_names.fulgora_structure_cells = 2
    mapgen.property_expression_names.fulgora_structure_subnoise = 2
    mapgen.property_expression_names.fulgora_structure_facets = 2
    mapgen.property_expression_names.fulgora_road_paving_thin = 2
    mapgen.property_expression_names.fulgora_road_paving_2 = 2
    mapgen.property_expression_names.fulgora_road_paving_2b = 2
    mapgen.property_expression_names.fulgora_road_paving_2c = 2
    return mapgen
end

local function fulgora_randomizer(mapgen, surface_name)
    mapgen = add_biters(mapgen)
    mapgen.seed = math.random(2^16) + game.tick

    local randomizer_list = {
        {"Normal", normal, "dw-randomizer.fulgora-normal"}
    }
    local randomizer_weights = {10}

    if storage.warp.number >= 50 and not storage.fulgora_first_warp then
        table.insert(randomizer_list, {"Barren", barren, "dw-randomizer.fulgora-barren"})
        table.insert(randomizer_list, {"Dry", dry, "dw-randomizer.fulgora-dry"})
        table.insert(randomizer_list, {"Bituminous", oil_planet, "dw-randomizer.fulgora-oil-planet"})
        table.insert(randomizer_list, {"No Scrap", no_scrap, "dw-randomizer.fulgora-no-scrap"})
        table.insert(randomizer_list, {"Junkyard", junkyard, "dw-randomizer.fulgora-junkyard"})

        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 1)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 1)
        table.insert(randomizer_weights, 3)
    end

    if storage.warp.number >= 150 and not storage.fulgora_first_warp then
        local weight = math.min(4, math.floor(storage.warp.number / 100))
        table.insert(randomizer_list, {"Death World", death_world, "dw-randomizer.fulgora-death-world"})
        table.insert(randomizer_weights, weight)
    end

    if storage.fulgora_first_warp then storage.fulgora_first_warp = false end

    local _, randomizer = utils.weighted_random_choice(randomizer_list, randomizer_weights)
    mapgen = randomizer[2](mapgen)

    local surface = game.create_surface(surface_name, mapgen)
    storage.warp.randomizer = randomizer[1]
    storage.warp.message = randomizer[3]

    return surface
end

local function on_technology_research_finished(event)
    local tech = event.research
    if tech.name == "planet-discovery-fulgora" then
        storage.fulgora_first_warp = true
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
dw.mapgen.fulgora.randomizer = fulgora_randomizer