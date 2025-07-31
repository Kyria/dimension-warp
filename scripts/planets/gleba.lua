dw.mapgen = dw.mapgen or {}
dw.mapgen.gleba = dw.mapgen.gleba or {}

local function normal(mapgen)
    mapgen.autoplace_controls.gleba_enemy_base = {frequency = 1, size = 1}
    mapgen.starting_area = "normal"
    return mapgen
end

local function flooded(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_controls.gleba_enemy_base = {frequency = 3, size = 1}
    mapgen.autoplace_controls.gleba_water.frequency = 6
    mapgen.autoplace_controls.gleba_water.size = 10

    mapgen.autoplace_settings.tile.settings['natural-yumako-soil'] = nil
    mapgen.autoplace_settings.tile.settings['wetland-yumako'] = nil
    mapgen.autoplace_settings.tile.settings["wetland-light-green-slime"] = nil
    mapgen.autoplace_settings.tile.settings["wetland-green-slime"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-brown-blubber"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-olive-blubber"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-olive-blubber-2"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-olive-blubber-3"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-pale-green"] = nil
    mapgen.autoplace_settings.tile.settings['natural-jellynut-soil'] = nil
    mapgen.autoplace_settings.tile.settings['wetland-jellynut'] = nil
    mapgen.autoplace_settings.tile.settings["wetland-pink-tentacle"] = nil
    mapgen.autoplace_settings.tile.settings["wetland-red-tentacle"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-cream-red"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein-2"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein-3"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein-4"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein-dead"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-infection"] = nil
    return mapgen
end

local function no_yumako_soil(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_settings.tile.settings['natural-yumako-soil'] = nil
    mapgen.autoplace_settings.tile.settings['wetland-yumako'] = nil
    mapgen.autoplace_settings.tile.settings["wetland-light-green-slime"] = nil
    mapgen.autoplace_settings.tile.settings["wetland-green-slime"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-brown-blubber"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-olive-blubber"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-olive-blubber-2"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-olive-blubber-3"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-pale-green"] = nil
    return mapgen
end

local function no_jellynut_soil(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_settings.tile.settings['natural-jellynut-soil'] = nil
    mapgen.autoplace_settings.tile.settings['wetland-jellynut'] = nil
    mapgen.autoplace_settings.tile.settings["wetland-pink-tentacle"] = nil
    mapgen.autoplace_settings.tile.settings["wetland-red-tentacle"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-cream-red"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein-2"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein-3"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein-4"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-vein-dead"] = nil
    mapgen.autoplace_settings.tile.settings["lowland-red-infection"] = nil
    return mapgen

end

local function agricultural_fields(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_controls.gleba_enemy_base = {frequency = 0.5, size = 2}
    mapgen.property_expression_names.gleba_fertile_spots_coastal_raw = 0.85
    mapgen.property_expression_names.gleba_fertile_spots_coastal = 0.85
    mapgen.property_expression_names.gleba_fertile_solid = 0.85

    mapgen.autoplace_settings.tile.settings = {
        ['natural-yumako-soil'] = {},
        ['wetland-yumako'] = {},
        ["wetland-light-green-slime"] = {},
        ["wetland-green-slime"] = {},
        ["lowland-brown-blubber"] = {},
        ["lowland-olive-blubber"] = {},
        ["lowland-olive-blubber-2"] = {},
        ["lowland-olive-blubber-3"] = {},
        ["lowland-pale-green"] = {},
        ['natural-jellynut-soil'] = {},
        ['wetland-jellynut'] = {},
        ["wetland-pink-tentacle"] = {},
        ["wetland-red-tentacle"] = {},
        ["lowland-cream-red"] = {},
        ["lowland-red-vein"] = {},
        ["lowland-red-vein-2"] = {},
        ["lowland-red-vein-3"] = {},
        ["lowland-red-vein-4"] = {},
        ["lowland-red-vein-dead"] = {},
        ["lowland-red-infection"] = {},
    }
    return mapgen
end

local function pentapod_nest(mapgen)
    mapgen = normal(mapgen)
    mapgen.autoplace_controls.gleba_enemy_base = {frequency = 4, size = 4}
    return mapgen
end

local function gleba_randomizer(mapgen, surface_name)
    mapgen.seed = math.random(2^16) + game.tick

    local randomizer_list = {
        {"Normal", normal, "dw-randomizer.gleba-normal"}
    }
    local randomizer_weights = {10}

    if storage.warp.number >= 100 and not storage.gleba_first_warp then
        table.insert(randomizer_list, {"Flooded", flooded, "dw-randomizer.gleba-flooded"})
        table.insert(randomizer_list, {"Alternate", no_yumako_soil, "dw-randomizer.gleba-no-yumako"})
        table.insert(randomizer_list, {"Alternate", no_jellynut_soil, "dw-randomizer.gleba-no-jellynut"})
        table.insert(randomizer_list, {"Fertile", agricultural_fields, "dw-randomizer.gleba-fertile"})
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 4)
        table.insert(randomizer_weights, 4)
        table.insert(randomizer_weights, 2)
    end

    if storage.warp.number >= 150 and not storage.gleba_first_warp then
        local weight = math.min(4, math.floor(storage.warp.number / 100))
        table.insert(randomizer_list, {"Nest", pentapod_nest, "dw-randomizer.gleba-nest"})
        table.insert(randomizer_weights, weight)
    end

    if storage.gleba_first_warp then storage.gleba_first_warp = false end

    local _, randomizer = utils.weighted_random_choice(randomizer_list, randomizer_weights)
    mapgen = randomizer[2](mapgen)

    local surface = game.create_surface(surface_name, mapgen)
    storage.warp.randomizer = randomizer[1]
    storage.warp.message = randomizer[3]

    return surface
end


local function on_technology_research_finished(event)
    local tech = event.research
    if tech.name == "planet-discovery-gleba" then
        storage.gleba_first_warp = true
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
dw.mapgen.gleba.randomizer = gleba_randomizer