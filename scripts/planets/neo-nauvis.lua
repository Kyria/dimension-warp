dw.mapgen = dw.mapgen or {}
dw.mapgen['neo-nauvis'] = dw.mapgen['neo-nauvis'] or {}

---------------------------------
--- Resource management
---------------------------------
dw.mapgen['neo-nauvis'].resource_list = {"iron-ore", "copper-ore", "stone", "coal", "uranium-ore", "crude-oil"}
dw.mapgen['neo-nauvis'].missing_resource_weights = {1,1,2,2,2,1}

if script.active_mods['Krastorio2'] or script.active_mods['Krastorio2-spaced-out'] then
    table.insert(dw.mapgen['neo-nauvis'].resource_list, "kr-imersite")
    table.insert(dw.mapgen['neo-nauvis'].resource_list, "kr-mineral-water")
    table.insert(dw.mapgen['neo-nauvis'].resource_list, "kr-rare-metal-ore")
    table.insert(dw.mapgen['neo-nauvis'].missing_resource_weights, 1)
    table.insert(dw.mapgen['neo-nauvis'].missing_resource_weights, 1)
    table.insert(dw.mapgen['neo-nauvis'].missing_resource_weights, 1)
end

---------------------------------
--- Tiles management
---------------------------------
dw.mapgen['neo-nauvis'].barren_tiles = {"sand-1", "sand-2", "sand-3", "red-desert-0", "red-desert-1", "red-desert-2", "red-desert-3"}

if script.active_mods['alien-biomes'] then
    dw.mapgen['neo-nauvis'].barren_tiles = {
        "mineral-aubergine-dirt-1", "mineral-aubergine-dirt-2", "mineral-aubergine-dirt-3", "mineral-aubergine-dirt-4", "mineral-aubergine-dirt-5", "mineral-aubergine-dirt-6",
        "mineral-aubergine-sand-1", "mineral-aubergine-sand-2", "mineral-aubergine-sand-3",
        "mineral-beige-dirt-1", "mineral-beige-dirt-2", "mineral-beige-dirt-3", "mineral-beige-dirt-4", "mineral-beige-dirt-5", "mineral-beige-dirt-6",
        "mineral-beige-sand-1", "mineral-beige-sand-2", "mineral-beige-sand-3",
        "mineral-black-dirt-1", "mineral-black-dirt-2", "mineral-black-dirt-3", "mineral-black-dirt-4", "mineral-black-dirt-5", "mineral-black-dirt-6",
        "mineral-black-sand-1", "mineral-black-sand-2", "mineral-black-sand-3",
        "mineral-brown-dirt-1", "mineral-brown-dirt-2", "mineral-brown-dirt-3", "mineral-brown-dirt-4", "mineral-brown-dirt-5", "mineral-brown-dirt-6",
        "mineral-brown-sand-1", "mineral-brown-sand-2", "mineral-brown-sand-3",
        "mineral-cream-dirt-1", "mineral-cream-dirt-2", "mineral-cream-dirt-3", "mineral-cream-dirt-4", "mineral-cream-dirt-5", "mineral-cream-dirt-6",
        "mineral-cream-sand-1", "mineral-cream-sand-2", "mineral-cream-sand-3",
        "mineral-dustyrose-dirt-1", "mineral-dustyrose-dirt-2", "mineral-dustyrose-dirt-3", "mineral-dustyrose-dirt-4", "mineral-dustyrose-dirt-5", "mineral-dustyrose-dirt-6",
        "mineral-dustyrose-sand-1", "mineral-dustyrose-sand-2", "mineral-dustyrose-sand-3",
        "mineral-grey-dirt-1", "mineral-grey-dirt-2", "mineral-grey-dirt-3", "mineral-grey-dirt-4", "mineral-grey-dirt-5", "mineral-grey-dirt-6",
        "mineral-grey-sand-1", "mineral-grey-sand-2", "mineral-grey-sand-3", "mineral-purple-dirt-1",
        "mineral-purple-dirt-2", "mineral-purple-dirt-3", "mineral-purple-dirt-4", "mineral-purple-dirt-5", "mineral-purple-dirt-6",
        "mineral-purple-sand-1", "mineral-purple-sand-2", "mineral-purple-sand-3",
        "mineral-red-dirt-1", "mineral-red-dirt-2", "mineral-red-dirt-3", "mineral-red-dirt-4", "mineral-red-dirt-5", "mineral-red-dirt-6",
        "mineral-red-sand-1", "mineral-red-sand-2", "mineral-red-sand-3",
        "mineral-tan-dirt-1", "mineral-tan-dirt-2", "mineral-tan-dirt-3", "mineral-tan-dirt-4", "mineral-tan-dirt-5", "mineral-tan-dirt-6",
        "mineral-tan-sand-1", "mineral-tan-sand-2", "mineral-tan-sand-3", "mineral-violet-dirt-1",
        "mineral-violet-dirt-2", "mineral-violet-dirt-3", "mineral-violet-dirt-4", "mineral-violet-dirt-5", "mineral-violet-dirt-6",
        "mineral-violet-sand-1", "mineral-violet-sand-2", "mineral-violet-sand-3",
        "mineral-white-dirt-1", "mineral-white-dirt-2", "mineral-white-dirt-3", "mineral-white-dirt-4", "mineral-white-dirt-5", "mineral-white-dirt-6",
        "mineral-white-sand-1", "mineral-white-sand-2", "mineral-white-sand-3",
    }
end

---------------------------------
--- Enemy management
---------------------------------
-- number here is a multiplier for the values, as some mod just change standards enemies
dw.mapgen['neo-nauvis'].enemies = {
    biter = {"enemy-base", 1.3},
}
if script.active_mods['Explosive_biters'] then
    if prototypes.autoplace_control.hot_enemy_base then
        dw.mapgen['neo-nauvis'].enemies.explosive = {"hot_enemy_base", 0.75}
        dw.mapgen['neo-nauvis'].enemies.biter[2] = dw.mapgen['neo-nauvis'].enemies.biter[2] - 0.2
    else
        dw.mapgen['neo-nauvis'].enemies.biter[2] = dw.mapgen['neo-nauvis'].enemies.biter[2] + 0.3
    end
end
if script.active_mods['Cold_biters'] then
    if prototypes.autoplace_control.frost_enemy_base then
        dw.mapgen['neo-nauvis'].enemies.frost = {"frost_enemy_base", 0.75}
        dw.mapgen['neo-nauvis'].enemies.biter[2] = dw.mapgen['neo-nauvis'].enemies.biter[2] - 0.2
    else
        dw.mapgen['neo-nauvis'].enemies.biter[2] = dw.mapgen['neo-nauvis'].enemies.biter[2] + 0.3
    end
end

local function set_enemy_autoplace(mapgen, base_frequency, base_size)
    for _, enemy in pairs(dw.mapgen['neo-nauvis'].enemies) do
        local frequency = enemy[2] * base_frequency
        local size = enemy[2] * base_size
        mapgen.autoplace_controls[enemy[1]] = {richness=1, frequency=frequency, size=size}
    end
end

---------------------------------
--- Randomizers
---------------------------------
---An island with no resources
local function barren_island(mapgen)
    -- make the island
    mapgen.property_expression_names.elevation = "elevation_island"
    mapgen.property_expression_names.moisture = "moisture_basic"
    mapgen.property_expression_names.aux = "aux_basic"
    mapgen.property_expression_names.cliffiness = "cliffiness_basic"
    mapgen.property_expression_names.cliff_elevation = "cliff_elevation_from_elevation"
    mapgen.property_expression_names.trees_forest_path_cutout = 1

    set_enemy_autoplace(mapgen, 0, 0)

    -- remove resources except wood
    for _, resource in pairs(dw.mapgen['neo-nauvis'].resource_list) do
        mapgen.autoplace_controls[resource].richness = 0
    end

    return mapgen
end

-- A quarantine island
local function death_island(mapgen)
    mapgen = barren_island(mapgen)
    set_enemy_autoplace(mapgen, 6, 4)
    mapgen.starting_area = 0.25
    return mapgen
end

-- A barren world (no water / no resources)
local function barren(mapgen)
    for _, resource in pairs(dw.mapgen['neo-nauvis'].resource_list) do
        mapgen.autoplace_controls[resource].richness = 0
    end

    set_enemy_autoplace(mapgen, 0, 0)

    mapgen.autoplace_controls["trees"].frequency = 0
    mapgen.autoplace_controls["rocks"].frequency = 5
    mapgen.autoplace_controls["rocks"].size = 5

    mapgen.autoplace_settings.tile.settings = {}
    for _, b_tile in pairs(dw.mapgen['neo-nauvis'].barren_tiles) do
        mapgen.autoplace_settings.tile.settings[b_tile] = {richness=1, frequency=1, size=1}
    end
    mapgen.autoplace_settings.decorative.settings = {}
    return mapgen
end

-- Biters ate everything from this world.
local function death_barren(mapgen)
    barren(mapgen)

    set_enemy_autoplace(mapgen, 4, 10)
    mapgen.starting_area = 0.25
    return mapgen
end

-- Amazonia is rich, dangerous, and full of trees
local function amazonia(mapgen)
    mapgen.autoplace_controls["trees"].frequency = 5
    mapgen.autoplace_controls["trees"].size = 5

    mapgen.property_expression_names.moisture = "moisture_nauvis"
    mapgen.property_expression_names["control:moisture:bias"] = 5

    set_enemy_autoplace(mapgen, 1.2, 2.2)

    for _, resource in pairs(dw.mapgen['neo-nauvis'].resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 1, size = 4, frequency = 2}
    end

    mapgen.starting_area = "big"

    return mapgen
end

-- Home sweet home
local function normal(mapgen)
    mapgen.autoplace_controls["trees"].frequency = 1
    mapgen.autoplace_controls["trees"].size = 1

    set_enemy_autoplace(mapgen, 1.2, 1)

    for _, resource in pairs(dw.mapgen['neo-nauvis'].resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 1, size = 1, frequency = 1}
    end

    mapgen.starting_area = "normal"
    return mapgen
end

-- massive 1 resource
local function iron_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen['neo-nauvis'].resource_list, "iron-ore", 2, 2, 1)
end
local function coal_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen['neo-nauvis'].resource_list, "coal", 1.5, 3, 1)
end
local function copper_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen['neo-nauvis'].resource_list, "copper-ore", 2, 2, 1)
end
local function oil_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen['neo-nauvis'].resource_list, "crude-oil", 3, 2, 5)
end
local function uranium_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen['neo-nauvis'].resource_list, "uranium-ore", 2, 2, 5)
end
local function stone_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen['neo-nauvis'].resource_list, "stone", 2, 2, 1)
end
local function kr_imersite_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen['neo-nauvis'].resource_list, "kr-imersite", 3, 2, 5)
end
local function kr_mineral_water_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen['neo-nauvis'].resource_list, "kr-mineral-water", 3, 2, 5)
end
local function kr_rare_metal_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, dw.mapgen['neo-nauvis'].resource_list, "kr-rare-metal-ore", 1.5, 1, 8)
end

-- Danger
local function death_world(mapgen)
    mapgen = normal(mapgen)

    set_enemy_autoplace(mapgen, 7, 10)
    mapgen.starting_area = 0.25
    return mapgen
end

-- Something's missing...
local function missing_resource(mapgen)
    mapgen = normal(mapgen)

    for _, resource in pairs(dw.mapgen['neo-nauvis'].resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 1.5, size = 1, frequency = 1.5}
    end

    -- min 2 removed, max "max - 2" kept
    local number_ore = math.random(#dw.mapgen['neo-nauvis'].resource_list - 2)
    local list = table.deepcopy(dw.mapgen['neo-nauvis'].resource_list)
    local weights = table.deepcopy(dw.mapgen['neo-nauvis'].missing_resource_weights)
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
    surface.ticks_per_day = 60 * 60 * math.random(3,20)
    surface.daytime = math.random()
end


---Select a random mapgen and return the surface generated with it
---@param mapgen MapGenSettings the mapgen to use as base
---@param surface_name string the name of the surface to create
---@return LuaSurface surface -- The surface created.
local function neo_nauvis_randomizer(mapgen, surface_name)
    mapgen.seed = math.random(2^16) + game.tick

    local randomizer_list = {
        {"Normal", normal, nil, "dw-randomizer.neo-nauvis-normal"}
    }
    local randomizer_weights = {10}

    if storage.warp.number >= 5 then
        table.insert(randomizer_list, {"Barren", barren, surface_always_dusk, "dw-randomizer.neo-nauvis-barren"})
        table.insert(randomizer_list, {"Lonely Island", barren_island, surface_always_dusk, "dw-randomizer.neo-nauvis-lonely-island"})
        table.insert(randomizer_list, {"Alternate", missing_resource, surface_random_day_tick, "dw-randomizer.neo-nauvis-alternate"})
        table.insert(randomizer_list, {"Metallic", iron_planet, nil, "dw-randomizer.neo-nauvis-iron"})
        table.insert(randomizer_list, {"Conductive", copper_planet, nil, "dw-randomizer.neo-nauvis-copper"})
        table.insert(randomizer_list, {"Carbonaceous", coal_planet, nil, "dw-randomizer.neo-nauvis-coal"})
        table.insert(randomizer_list, {"Bituminous", oil_planet, nil, "dw-randomizer.neo-nauvis-oil"})
        table.insert(randomizer_list, {"Radioactive", uranium_planet, nil, "dw-randomizer.neo-nauvis-uranium"})
        table.insert(randomizer_list, {"Granitic", stone_planet, nil, "dw-randomizer.neo-nauvis-stone"})

        table.insert(randomizer_weights, 4)
        table.insert(randomizer_weights, 4)
        table.insert(randomizer_weights, 15)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 2)
        table.insert(randomizer_weights, 2)

        if script.active_mods['Krastorio2'] or script.active_mods['Krastorio2-spaced-out'] then
            table.insert(randomizer_list, {"Aquiferous", kr_mineral_water_planet, nil, "dw-randomizer.neo-nauvis-kr-mineral-water"})
            table.insert(randomizer_list, {"Violetine", kr_imersite_planet, nil, "dw-randomizer.neo-nauvis-kr-imersite"})
            table.insert(randomizer_list, {"Alloyed", kr_rare_metal_planet, nil, "dw-randomizer.neo-nauvis-kr-rare-metal"})
            table.insert(randomizer_weights, 2)
            table.insert(randomizer_weights, 2)
            table.insert(randomizer_weights, 2)
        end

    end

    if storage.warp.number >= 25 then
        table.insert(randomizer_list, {"Amazonia", amazonia, surface_random_day_tick, "dw-randomizer.neo-nauvis-amazonia"})
        table.insert(randomizer_weights, 6)
    end

    if storage.warp.number >= 75 then
        local weight = math.floor(storage.warp.number / 50)
        table.insert(randomizer_list, {"Quarantine Island", death_island, surface_random_day_tick, "dw-randomizer.neo-nauvis-death-island"})
        table.insert(randomizer_list, {"Ravaged", death_barren, surface_always_dusk, "dw-randomizer.neo-nauvis-death-barren"})
        table.insert(randomizer_list, {"Infested", death_world, surface_always_night, "dw-randomizer.neo-nauvis-death-world"})
        table.insert(randomizer_weights, weight)
        table.insert(randomizer_weights, weight)
        table.insert(randomizer_weights, weight)
    end

    local _, randomizer = utils.weighted_random_choice(randomizer_list, randomizer_weights)
    mapgen = randomizer[2](mapgen)

    local surface = game.create_surface(surface_name, mapgen)
    if randomizer[3] then randomizer[3](surface) end
    storage.warp.randomizer = randomizer[1]
    storage.warp.message = randomizer[4]

    return surface
end

dw.mapgen['neo-nauvis'].randomizer = neo_nauvis_randomizer