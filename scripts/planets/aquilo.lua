dw.mapgen = dw.mapgen or {}
dw.mapgen.aquilo = dw.mapgen.aquilo or {}

dw.mapgen.aquilo.resource_list = {"aquilo_crude_oil", "fluorine_vent", "lithium_brine"}
---------------------------------
--- Enemy management
---------------------------------
-- number here is a multiplier for the values, as some mod just change standards enemies
dw.mapgen.aquilo.enemies = {
    biter = {"enemy-base", 1},
}
if script.active_mods['Cold_biters'] and prototypes.autoplace_control.frost_enemy_base then
    dw.mapgen.aquilo.enemies.frost = {"frost_enemy_base", 1}
    dw.mapgen.aquilo.enemies.biter = nil
end

local function set_enemy_autoplace(mapgen, base_frequency, base_size, force)
    if script.active_mods['Cold_biters'] or force then
        for _, enemy in pairs(dw.mapgen.aquilo.enemies) do
            local frequency = enemy[2] * base_frequency
            local size = enemy[2] * base_size
            mapgen.autoplace_controls[enemy[1]] = {richness=1, frequency=frequency, size=size}
        end
    end
end

---------------------------------
--- Randomizers
---------------------------------
local function barren(mapgen)
    set_enemy_autoplace(mapgen, 0, 0)
    for _, resource in pairs(dw.mapgen.aquilo.resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 0, size = 1, frequency = 1}
    end
    return mapgen
end

local function normal(mapgen)
    set_enemy_autoplace(mapgen, 1.5, 1)
    for _, resource in pairs(dw.mapgen.aquilo.resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 1, size = 1, frequency = 1}
    end
    return mapgen
end

local function oil_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen.aquilo.resource_list, "aquilo_crude_oil", 3, 1, 2)
end

local function fluorine_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen.aquilo.resource_list, "fluorine_vent", 5, 3, 4)
end

local function lithium_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen.aquilo.resource_list, "lithium_brine", 3, 2, 4)
end

local function ammoniacal_planet(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_settings.tile.settings = {}
    mapgen.autoplace_settings.tile.settings['ammoniacal-ocean'] = {richness = 1, size = 1, frequency = 1}
    mapgen.autoplace_settings.tile.settings['ammoniacal-ocean-2'] = {richness = 1, size = 1, frequency = 1}
    for _, resource in pairs(dw.mapgen.aquilo.resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 0, size = 1, frequency = 1}
    end
    return mapgen
end

local function dry_ice_planet(mapgen)
    for _, resource in pairs(dw.mapgen.aquilo.resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 4, size = 2, frequency = 1}
    end

    mapgen.autoplace_settings.tile.settings['ammoniacal-ocean'] = nil
    mapgen.autoplace_settings.tile.settings['ammoniacal-ocean-2'] = nil
    mapgen.autoplace_settings.tile.settings['brash-ice'] = nil
    mapgen.autoplace_settings.tile.settings['ice-rough'] = nil
    mapgen.autoplace_settings.tile.settings['ice-smooth'] = nil

    mapgen.autoplace_settings.entity.settings["lithium-iceberg-big"] = nil
    mapgen.autoplace_settings.entity.settings["lithium-iceberg-huge"] = nil

    mapgen.starting_area = "small"
    set_enemy_autoplace(mapgen, 3, 3, true)

    return mapgen
end


-- force dusk on planet
local function surface_always_dusk(surface)
    surface.daytime = 0.35
    surface.freeze_daytime = true
end

local function surface_random_day_tick(surface)
    surface.ticks_per_day = 60 * 60 * math.random(10, 60)
    surface.daytime = math.random()
end


local function aquilo_randomizer(mapgen, surface_name)
    mapgen.seed = math.random(2^16) + game.tick

    local randomizer_list = {
        {"Normal", normal, nil, "dw-randomizer.aquilo-normal"}
    }
    local randomizer_weights = {10}

    if storage.warp.number >= 100 and not storage.aquilo_first_warp then
        table.insert(randomizer_list, {"Barren", barren, surface_random_day_tick, "dw-randomizer.aquilo-barren"})
        table.insert(randomizer_list, {"Bituminous", oil_planet, surface_random_day_tick, "dw-randomizer.aquilo-oil"})
        table.insert(randomizer_list, {"Toxic", fluorine_planet, surface_random_day_tick, "dw-randomizer.aquilo-fluorine"})
        table.insert(randomizer_list, {"Alkali", lithium_planet, surface_random_day_tick, "dw-randomizer.aquilo-lithium"})
        table.insert(randomizer_list, {"Ammoniacal", ammoniacal_planet, surface_random_day_tick, "dw-randomizer.aquilo-ammoniacal"})


        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 2)
    end

    if storage.warp.number >= 200 and not storage.aquilo_first_warp then
        local weight = math.floor(storage.warp.number / 125)
        table.insert(randomizer_list, {"Frigid", dry_ice_planet, surface_always_dusk, "dw-randomizer.aquilo-dry-ice"})
        table.insert(randomizer_weights, weight)
    end

    storage.aquilo_first_warp = false

    local _, randomizer = utils.weighted_random_choice(randomizer_list, randomizer_weights)
    mapgen = randomizer[2](mapgen)

    local surface = game.planets.aquilo.create_surface()
    if randomizer[3] then randomizer[3](surface) end
    surface.map_gen_settings = mapgen
    surface.name = surface_name

    storage.warp.randomizer = randomizer[1]
    storage.warp.message = randomizer[4]

    return surface
end

local function on_technology_research_finished(event)
    local tech = event.research
    if tech.name == "planet-discovery-aquilo" then
        storage.aquilo_first_warp = true
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
dw.mapgen.aquilo.randomizer = aquilo_randomizer