dw.mapgen = dw.mapgen or {}
dw.mapgen.vulcanus = dw.mapgen.vulcanus or {}

dw.mapgen.vulcanus.resource_list = {"calcite", "vulcanus_coal", "sulfuric_acid_geyser", "tungsten_ore"}

---------------------------------
--- Enemy management
---------------------------------
-- number here is a multiplier for the values, as some mod just change standards enemies
dw.mapgen.vulcanus.enemies = {
    biter = {"enemy-base", 1},
}

if script.active_mods['Explosive_biters'] and prototypes.autoplace_control.hot_enemy_base then
    dw.mapgen.vulcanus.enemies.explosive = {"hot_enemy_base", 1}
    dw.mapgen.vulcanus.enemies.biter[2] = 0.6
end

local function set_enemy_autoplace(mapgen, base_frequency, base_size)
    for _, enemy in pairs(dw.mapgen.vulcanus.enemies) do
        local frequency = enemy[2] * base_frequency
        local size = enemy[2] * base_size
        mapgen.autoplace_controls[enemy[1]] = {richness=1, frequency=frequency, size=size}
    end
end

---------------------------------
--- Randomizers
---------------------------------
local function barren(mapgen)
    mapgen.autoplace_controls["calcite"].richness = 0
    mapgen.autoplace_controls["vulcanus_coal"].richness = 0
    mapgen.autoplace_controls["sulfuric_acid_geyser"].richness = 0
    mapgen.autoplace_controls["tungsten_ore"].richness = 0
    return mapgen
end

local function eruption(mapgen)
    mapgen = barren(mapgen)
    mapgen.autoplace_settings.tile.settings = {
        ["lava"] = {},
        ["lava-hot"] = {},
    }
    return mapgen
end

local function normal(mapgen)
    mapgen.starting_area = "small"
    mapgen.autoplace_controls["calcite"] = {frequency = 1, richness = 1, size = 1}
    mapgen.autoplace_controls["vulcanus_coal"] = {frequency = 1, richness = 1, size = 1}
    mapgen.autoplace_controls["sulfuric_acid_geyser"] = {frequency = 1, richness = 1, size = 1}
    mapgen.autoplace_controls["tungsten_ore"] = {frequency = 0.8, richness = 1, size = 1}
    set_enemy_autoplace(mapgen, 2, 1)
    return mapgen
end

local function dormant(mapgen)
    mapgen = normal(mapgen)
    mapgen.territory_settings = {
        units ={"small-demolisher"},
        territory_index_expression = "demolisher_territory_expression",
        territory_variation_expression = "demolisher_variation_expression",
        minimum_territory_size = 10
    }
    mapgen.autoplace_settings.tile.settings['lava'] = nil
    mapgen.autoplace_settings.tile.settings['lava-hot'] = nil

    set_enemy_autoplace(mapgen, 3, 3)
    return mapgen
end

local function calcite_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen.vulcanus.resource_list, "calcite", 2, 2, 1)
end
local function coal_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen.vulcanus.resource_list, "vulcanus_coal", 2, 2, 1)
end
local function acid_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen.vulcanus.resource_list, "sulfuric_acid_geyser", 2, 2, 3)
end
local function tungsten_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen.vulcanus.resource_list, "tungsten_ore", 2, 4, 5)
end

local function demolisher_planet(mapgen)
    mapgen = normal(mapgen)

    mapgen.territory_settings = {
        units = storage.warp.number > 150 and {"big-demolisher"} or (storage.warp.number > 70 and {"medium-demolisher", "big-demolisher"} or {"small-demolisher", "medium-demolisher", "big-demolisher"}),
        territory_index_expression = "demolisher_territory_expression",
        territory_variation_expression = "demolisher_variation_expression",
        minimum_territory_size = 10
    }
    return mapgen
end

local function death_world(mapgen)
    mapgen = demolisher_planet(mapgen)
    set_enemy_autoplace(mapgen, 4, 8)
    return mapgen
end

-- Something's missing...
local function missing_resource(mapgen)
    mapgen = normal(mapgen)

    mapgen.autoplace_controls["calcite"] = {richness = 1.5, size = 1, frequency = 1.5}
    mapgen.autoplace_controls["vulcanus_coal"] = {richness = 1.5, size = 1, frequency = 1.5}
    mapgen.autoplace_controls["sulfuric_acid_geyser"] = {richness = 1.5, size = 1, frequency = 1.5}
    mapgen.autoplace_controls["tungsten_ore"] = {richness = 1.5, size = 1, frequency = 1.5}

    local number_ore = math.random(2)
    local list = {"calcite", "vulcanus_coal", "sulfuric_acid_geyser", "tungsten_ore"}
    local weights = {2,1,1,4}
    for i = number_ore, 1, -1 do
        local index, selected = utils.weighted_random_choice(list, weights)
        mapgen.autoplace_controls[selected].richness = 0
        table.remove(list, index)
        table.remove(weights, index)
    end
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
    surface.ticks_per_day = 60 * 60 * math.random(1,5)
end

local function vulcanus_randomizer(mapgen, surface_name)
    mapgen.starting_area = "very-small"
    mapgen.seed = math.random(2^16) + game.tick

    local randomizer_list = {
        {"Normal", normal, nil, "dw-randomizer.vulcanus-normal"}
    }
    local randomizer_weights = {10}

    if storage.warp.number >= 25 and not storage.vulcanus_first_warp then
        table.insert(randomizer_list, {"Barren", barren, surface_always_dusk, "dw-randomizer.vulcanus-barren"})
        table.insert(randomizer_list, {"Erupting", eruption, surface_always_night, "dw-randomizer.vulcanus-erupting"})
        table.insert(randomizer_list, {"Dormant", dormant, surface_random_day_tick, "dw-randomizer.vulcanus-dormant"})
        table.insert(randomizer_list, {"Alternate", missing_resource, surface_random_day_tick, "dw-randomizer.vulcanus-alternate"})
        table.insert(randomizer_list, {"Chalky", calcite_planet, nil, "dw-randomizer.vulcanus-calcite"})
        table.insert(randomizer_list, {"Caustic", acid_planet, nil, "dw-randomizer.vulcanus-acid"})
        table.insert(randomizer_list, {"Hardened", tungsten_planet, nil, "dw-randomizer.vulcanus-tungsten"})
        table.insert(randomizer_list, {"Carbonaceous", coal_planet, nil, "dw-randomizer.vulcanus-coal"})

        table.insert(randomizer_weights, 3)
        table.insert(randomizer_weights, 3)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 15)
        table.insert(randomizer_weights, 1)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 1)
        table.insert(randomizer_weights, 1)
    end

    if storage.warp.number >= 125 and not storage.vulcanus_first_warp then
        local weight = math.floor(storage.warp.number / 60)
        table.insert(randomizer_list, {"Demolisher", demolisher_planet, surface_always_night, "dw-randomizer.vulcanus-demolisher"})
        table.insert(randomizer_list, {"Infested", death_world, surface_always_night, "dw-randomizer.vulcanus-death-world"})

        table.insert(randomizer_weights, weight)
        table.insert(randomizer_weights, weight)
    end

    storage.vulcanus_first_warp = false

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
    if tech.name == "planet-discovery-vulcanus" then
        storage.vulcanus_first_warp = true
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
dw.mapgen.vulcanus.randomizer = vulcanus_randomizer