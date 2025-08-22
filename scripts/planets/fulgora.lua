dw.mapgen = dw.mapgen or {}
dw.mapgen.fulgora = dw.mapgen.fulgora or {}

---------------------------------
--- Enemy management
---------------------------------
-- number here is a multiplier for the values, as some mod just change standards enemies
dw.mapgen.fulgora.enemies = {
    biter = {"enemy-base", 1.5},
}

if script.active_mods['Electric_flying_enemies'] then
    dw.mapgen.fulgora.enemies.explosive = {"electric_enemies", 1}
    dw.mapgen.fulgora.enemies.biter = nil
end

local function set_enemy_autoplace(mapgen, base_frequency, base_size)
    for _, enemy in pairs(dw.mapgen.fulgora.enemies) do
        local frequency = enemy[2] * base_frequency
        local size = enemy[2] * base_size
        mapgen.autoplace_controls[enemy[1]] = {richness=1, frequency=frequency, size=size}
    end
end

---------------------------------
--- Randomizers
---------------------------------
local function normal(mapgen)
    mapgen.starting_area = "small"
    mapgen.autoplace_controls['scrap'] = {frequency = 1, size = 1, richness = 1}
    mapgen.autoplace_controls["fulgora_islands"] = {size = 6, frequency = 6}
    mapgen.property_expression_names["control:fulgora_islands:frequency"] = 4
    mapgen.property_expression_names["control:fulgora_islands:size"] = 4
    set_enemy_autoplace(mapgen, 1.5, 1)
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
    mapgen.autoplace_controls['fulgora_cliff'].frequency = 0
    mapgen.autoplace_settings.tile.settings['oil-ocean-shallow'] = nil
    mapgen.autoplace_settings.tile.settings['oil-ocean-deep'] = nil

    set_enemy_autoplace(mapgen, 3, 2)
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
    mapgen.autoplace_controls['fulgora_cliff'].frequency = 0
    set_enemy_autoplace(mapgen, 4, 8)
    return mapgen
end

local function no_scrap(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_controls["scrap"].richness = 0
    return mapgen
end

local function junkyard(mapgen)
    mapgen = no_scrap(mapgen)
    set_enemy_autoplace(mapgen, 4, 4)
    mapgen.autoplace_controls['fulgora_cliff'].frequency = 0
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

-- force dusk on planet
local function surface_always_dusk(surface)
    surface.daytime = 0.35
    surface.freeze_daytime = true
end

-- force night on planet
local function surface_always_night(surface)
    surface.daytime = 0.5
    surface.freeze_daytime = true
end

local function surface_random_day_tick(surface)
    surface.ticks_per_day = 60 * 60 * math.random(2,10)
end

local function fulgora_randomizer(mapgen, surface_name)
    mapgen.seed = math.random(2^16) + game.tick

    local randomizer_list = {
        {"Normal", normal, nil, "dw-randomizer.fulgora-normal"}
    }
    local randomizer_weights = {10}

    if storage.warp.number >= 50 and not storage.fulgora_first_warp then
        table.insert(randomizer_list, {"Barren", barren, surface_always_dusk, "dw-randomizer.fulgora-barren"})
        table.insert(randomizer_list, {"Dry", dry, surface_random_day_tick, "dw-randomizer.fulgora-dry"})
        table.insert(randomizer_list, {"Bituminous", oil_planet, nil, "dw-randomizer.fulgora-oil-planet"})
        table.insert(randomizer_list, {"No Scrap", no_scrap, surface_random_day_tick, "dw-randomizer.fulgora-no-scrap"})

        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 1)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 1)
    end

    if storage.warp.number >= 120 and not storage.fulgora_first_warp then
        local weight = math.floor(storage.warp.number / 60)
        table.insert(randomizer_list, {"Junkyard", junkyard, surface_always_dusk, "dw-randomizer.fulgora-junkyard"})
        table.insert(randomizer_list, {"Death World", death_world, surface_always_night, "dw-randomizer.fulgora-death-world"})
        table.insert(randomizer_weights, weight)
        table.insert(randomizer_weights, weight)
    end

    storage.fulgora_first_warp = false

    local _, randomizer = utils.weighted_random_choice(randomizer_list, randomizer_weights)
    mapgen = randomizer[2](mapgen)

    local surface = game.create_surface(surface_name, mapgen)
    if randomizer[3] then randomizer[3](surface) end
    storage.warp.randomizer = randomizer[1]
    storage.warp.message = randomizer[4]

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