dw.mapgen = dw.mapgen or {}
dw.mapgen['neo-nauvis'] = dw.mapgen['neo-nauvis'] or {}

local resource_list = {"iron-ore", "copper-ore", "stone", "coal", "uranium-ore", "crude-oil"}
local missing_resource_weights = {1,1,2,2,2,1}

if script.active_mods['Krastorio2'] or script.active_mods['Krastorio2-spaced-out'] then
    table.insert(resource_list, "kr-imersite")
    table.insert(resource_list, "kr-mineral-water")
    table.insert(resource_list, "kr-rare-metal-ore")
    table.insert(missing_resource_weights, 1)
    table.insert(missing_resource_weights, 1)
    table.insert(missing_resource_weights, 1)
end

---An island with no resources
local function barren_island(mapgen)
    -- make the island
    mapgen.property_expression_names.elevation = "elevation_island"
    mapgen.property_expression_names.moisture = "moisture_basic"
    mapgen.property_expression_names.aux = "aux_basic"
    mapgen.property_expression_names.cliffiness = "cliffiness_basic"
    mapgen.property_expression_names.cliff_elevation = "cliff_elevation_from_elevation"
    mapgen.property_expression_names.trees_forest_path_cutout = 1

    -- remove resources except wood
    for _, resource in pairs(resource_list) do
        mapgen.autoplace_controls[resource].richness = 0
    end

    return mapgen
end

-- A quarantine island
local function death_island(mapgen)
    mapgen = barren_island(mapgen)
    mapgen.autoplace_controls["enemy-base"].frequency = 10
    mapgen.autoplace_controls["enemy-base"].size = 4
    mapgen.starting_area = "very-small"
    return mapgen
end

-- A barren world (no water / no resources)
local function barren(mapgen)
    for _, resource in pairs(resource_list) do
        mapgen.autoplace_controls[resource].richness = 0
    end
    mapgen.autoplace_controls["trees"].frequency = 0
    mapgen.autoplace_controls["rocks"].frequency = 5
    mapgen.autoplace_controls["rocks"].size = 5

    mapgen.autoplace_settings.tile.settings = {
        ["sand-1"] = {richness=1, frequency=1, size=1},
        ["sand-2"] = {richness=1, frequency=1, size=1},
        ["sand-3"] = {richness=1, frequency=1, size=1},
        ["red-desert-0"] = {richness=1, frequency=1, size=1},
        ["red-desert-1"] = {richness=1, frequency=1, size=1},
        ["red-desert-2"] = {richness=1, frequency=1, size=1},
        ["red-desert-3"] = {richness=1, frequency=1, size=1},
    }
    mapgen.autoplace_settings.decorative.settings = {}
    return mapgen
end

-- Biters ate everything from this world.
local function death_barren(mapgen)
    barren(mapgen)
    mapgen.autoplace_controls["enemy-base"].frequency = 5
    mapgen.autoplace_controls["enemy-base"].size = 10
    mapgen.starting_area = "very-small"
    return mapgen
end

-- Amazonia is rich, dangerous, and full of trees
local function amazonia(mapgen)
    mapgen.autoplace_controls["trees"].frequency = 5
    mapgen.autoplace_controls["trees"].size = 5

    mapgen.property_expression_names.moisture = "moisture_nauvis"
    mapgen.property_expression_names["control:moisture:bias"] = 5

    mapgen.autoplace_controls["enemy-base"].frequency = 2.5
    mapgen.autoplace_controls["enemy-base"].size = 3

    for _, resource in pairs(resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 1, size = 4, frequency = 2}
    end

    mapgen.starting_area = "big"

    return mapgen
end

-- Home sweet home
local function normal(mapgen)
    mapgen.autoplace_controls["trees"].frequency = 1
    mapgen.autoplace_controls["trees"].size = 1
    mapgen.autoplace_controls["enemy-base"].frequency = 1.5
    mapgen.autoplace_controls["enemy-base"].size = 1

    for _, resource in pairs(resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 1, size = 1, frequency = 1}
    end

    mapgen.starting_area = "normal"
    return mapgen
end

-- massive 1 resource
local function iron_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, resource_list, "iron-ore", 2, 2, 1)
end
local function coal_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, resource_list, "coal", 1.5, 3, 1)
end
local function copper_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, resource_list, "copper-ore", 2, 2, 1)
end
local function oil_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, resource_list, "crude-oil", 3, 2, 5)
end
local function uranium_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, resource_list, "uranium-ore", 2, 2, 5)
end
local function stone_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, resource_list, "stone", 2, 2, 1)
end
local function kr_imersite_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, resource_list, "kr-imersite", 3, 2, 5)
end
local function kr_mineral_water_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, resource_list, "kr-mineral-water", 3, 2, 5)
end
local function kr_rare_metal_planet(mapgen)
    mapgen = normal(mapgen)
    return utils.adjust_resource_proportion(mapgen, resource_list, "kr-rare-metal-ore", 1.5, 1, 8)
end

-- Danger
local function death_world(mapgen)
    mapgen = normal(mapgen)

    mapgen.autoplace_controls["enemy-base"].frequency = 10
    mapgen.autoplace_controls["enemy-base"].size = 10
    mapgen.starting_area = 0
    return mapgen
end

-- Something's missing...
local function missing_resource(mapgen)
    mapgen = normal(mapgen)

    for _, resource in pairs(resource_list) do
        mapgen.autoplace_controls[resource] = {richness = 1.5, size = 1, frequency = 1.5}
    end

    -- min 2 removed, max "max - 2" kept
    local number_ore = math.random(#resource_list - 2)
    local list = table.deepcopy(resource_list)
    local weights = table.deepcopy(missing_resource_weights)
    for i = number_ore, 1, -1 do
        local index, selected = utils.weighted_random_choice(list, weights)
        mapgen.autoplace_controls[selected].richness = 0
        table.remove(list, index)
        table.remove(weights, index)
    end
    return mapgen
end


---Select a random mapgen and return the surface generated with it
---@param mapgen MapGenSettings the mapgen to use as base
---@param surface_name string the name of the surface to create
---@return LuaSurface surface -- The surface created.
local function neo_nauvis_randomizer(mapgen, surface_name)
    mapgen.seed = math.random(2^16) + game.tick

    local randomizer_list = {
        {"Normal", normal, "dw-randomizer.neo-nauvis-normal"}
    }
    local randomizer_weights = {10}

    if storage.warp.number >= 5 then
        table.insert(randomizer_list, {"Barren", barren, "dw-randomizer.neo-nauvis-barren"})
        table.insert(randomizer_list, {"Lonely Island", barren_island, "dw-randomizer.neo-nauvis-lonely-island"})
        table.insert(randomizer_list, {"Alternate", missing_resource, "dw-randomizer.neo-nauvis-alternate"})
        table.insert(randomizer_list, {"Metallic", iron_planet, "dw-randomizer.neo-nauvis-iron"})
        table.insert(randomizer_list, {"Conductive", copper_planet, "dw-randomizer.neo-nauvis-copper"})
        table.insert(randomizer_list, {"Carbonaceous", coal_planet, "dw-randomizer.neo-nauvis-coal"})
        table.insert(randomizer_list, {"Bituminous", oil_planet, "dw-randomizer.neo-nauvis-oil"})
        table.insert(randomizer_list, {"Radioactive", uranium_planet, "dw-randomizer.neo-nauvis-uranium"})
        table.insert(randomizer_list, {"Granitic", stone_planet, "dw-randomizer.neo-nauvis-stone"})

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
            table.insert(randomizer_list, {"Aquiferous", kr_mineral_water_planet, "dw-randomizer.neo-nauvis-kr-mineral-water"})
            table.insert(randomizer_list, {"Violetine", kr_imersite_planet, "dw-randomizer.neo-nauvis-kr-imersite"})
            table.insert(randomizer_list, {"Alloyed", kr_rare_metal_planet, "dw-randomizer.neo-nauvis-kr-rare-metal"})
            table.insert(randomizer_weights, 2)
            table.insert(randomizer_weights, 2)
            table.insert(randomizer_weights, 2)
        end

    end

    if storage.warp.number >= 25 then
        table.insert(randomizer_list, {"Amazonia", amazonia, "dw-randomizer.neo-nauvis-amazonia"})
        table.insert(randomizer_weights, 5)
    end

    if storage.warp.number >= 75 then
        local weight = math.min(5, math.floor(storage.warp.number / 50))
        table.insert(randomizer_list, {"Quarantine Island", death_island, "dw-randomizer.neo-nauvis-death-island"})
        table.insert(randomizer_list, {"Ravaged", death_barren, "dw-randomizer.neo-nauvis-death-barren"})
        table.insert(randomizer_list, {"Infested", death_world, "dw-randomizer.neo-nauvisorld"})
        table.insert(randomizer_weights, weight)
        table.insert(randomizer_weights, weight)
        table.insert(randomizer_weights, weight)
    end

    local _, randomizer = utils.weighted_random_choice(randomizer_list, randomizer_weights)
    mapgen = randomizer[2](mapgen)

    local surface = game.create_surface(surface_name, mapgen)
    storage.warp.randomizer = randomizer[1]
    storage.warp.message = randomizer[3]

    return surface
end

dw.mapgen['neo-nauvis'].randomizer = neo_nauvis_randomizer