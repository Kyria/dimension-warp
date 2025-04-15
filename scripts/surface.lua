


local planet_ore = {
    vulcanus = {'vulcanus_coal', 'sulfuric_acid_geyser', 'tungsten_ore', 'calcite'},
    ["neo-nauvis"] = {'coal', 'copper-ore', 'iron-ore', 'stone', 'uranium-ore', 'crude-oil'},
    fulgora = {'scrap'},
    gleba = {'stone'},
    aquilo = {'lithium_brine', 'fluorine_vent', 'aquilo_crude_oil'}
}

local planet_tile = {
    vulcanus = {{'lava', 'lava-hot'}},
    ["neo-nauvis"] = {'water'},
    fulgora = {{'oil-ocean-shallow', 'oil-ocean-deep'}},
    gleba = {{'natural-yumako-soil', 'wetland-yumako'}, {'natural-jellynut-soil', 'wetland-jellynut'}},
    aquilo = {{'ammoniacal-ocean', 'ammoniacal-ocean-2'}}
}
---
--- ["fulgora_islands"] = {},
--- ["fulgora_cliff"] = {},

--- increase the richness / frequency of ore.
local function ore_rich_gen(mapgen, resources)
    local richness_multiplier = math.random(1, settings.global['dw-max-richness-multiplier'].value)
    local frequency_multiplier = math.random(1, settings.global['dw-max-frequency-multiplier'].value)
    local size_multiplier = math.random(1, settings.global['dw-max-size-multiplier'].value)

end

--- lower the richness / frequency of ore
local function ore_scarce_gen(mapgen, resources)
    local richness_multiplier = math.random(settings.global['dw-min-richness-multiplier'].value, 1)
    local frequency_multiplier = math.random(settings.global['dw-min-frequency-multiplier'].value, 1)
    local size_multiplier = math.random(settings.global['dw-min-size-multiplier'].value, 1)


end

--- full random
local function ore_random_gen(mapgen, resources)
    local richness_multiplier = math.random(settings.global['dw-min-richness-multiplier'].value, settings.global['dw-max-richness-multiplier'].value)
    local frequency_multiplier = math.random(settings.global['dw-min-frequency-multiplier'].value, settings.global['dw-max-frequency-multiplier'].value)
    local size_multiplier = math.random(settings.global['dw-min-size-multiplier'].value, settings.global['dw-max-size-multiplier'].value)

end

---
local function ore_missing_gen(mapgen, resources)

end


local function get_default_mapgens()
    local default_map_gen = {}
    for _, planet in pairs(game.planets) do
        if planet.name ~= "nauvis" then
            default_map_gen[planet.name] = planet.prototype.map_gen_settings
        end
    end
    return default_map_gen
end

dw.generate_surface = function(planet, vanilla)
    dw.default_map_gen = dw.default_map_gen or get_default_mapgens()
    if not planet or not dw.default_map_gen[planet] then return end
    local mapgen = table.deepcopy(dw.default_map_gen[planet])

    storage.warp.previous = storage.warp.current
    storage.warp.number = storage.warp.number + 1
    storage.warp.current = {
        name = planet..'-'..storage.warp.number,
        type = planet,
    }

    if not vanilla then
        mapgen.seed = math.random(1, 2^32-1)
    end

    local surface = game.create_surface(storage.warp.current.name, mapgen)
    storage.warp.current.surface = surface
    storage.warp.current.surface_index = surface.index

    surface.request_to_generate_chunks({x= 0, y = 0}, 4)
    surface.force_generate_chunk_requests()
end

dw.update_surfaces_properties = function()
    if storage.warp.status ~= defines.warp.warping then return end
    game.delete_surface(storage.warp.previous.name)
end

local function surface_deleted(event)
    if event.surface_index == storage.warp.previous.surface_index then
        local planet = game.planets[storage.warp.current.type]
        planet.associate_surface(storage.warp.current.surface)
        storage.warp.previous = nil
        storage.warp.status = defines.warp.awaiting
    end
end


--- Make sure that dead player on nauvis are moved to the new surface
local function dead_on_previous_surface(event)
    local player = game.players[event.player_index]
    if player.surface.name ~= storage.warp.current.name then
        player.teleport({0, 0}, storage.warp.current.name)
    end
end

--- make sure new players are teleported to the new surface
local function on_character_created(event)
    local player = game.players[event.player_index]

    --- make sure to teleport any new player to the current warp surface
    if storage.nauvis_lab_exploded then
        dw.safe_teleport(player, storage.warp.current.name, {0, 0})
    end
end

dw.register_event(defines.events.on_player_died, dead_on_previous_surface)
dw.register_event(defines.events.on_player_created, on_character_created)
dw.register_event(defines.events.on_surface_deleted, surface_deleted)