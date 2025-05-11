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


local function force_map_settings()
    game.map_settings.pollution.enabled = true
    game.map_settings.pollution.diffusion_ratio = 0.105
    game.map_settings.pollution.min_to_diffuse = 15
    game.map_settings.pollution.ageing = 1.0
    game.map_settings.pollution.expected_max_per_chunk = 250
    game.map_settings.pollution.min_to_show_per_chunk = 50
    game.map_settings.pollution.pollution_restored_per_tree_damage = 9
    game.map_settings.pollution.enemy_attack_pollution_consumption_modifier = 1.0

    game.map_settings.enemy_evolution.enabled = true -- default 0.002
    game.map_settings.enemy_evolution.time_factor = 0.000004 -- default 0.000004
    game.map_settings.enemy_evolution.destroy_factor = 0.0002 -- default 0.002
    game.map_settings.enemy_evolution.pollution_factor = 0.0000002 -- default 0.0000009

    game.map_settings.unit_group.min_group_gathering_time = 600
    game.map_settings.unit_group.max_group_gathering_time = 2 * 600
    game.map_settings.unit_group.max_unit_group_size = 200
    game.map_settings.unit_group.max_wait_time_for_late_members = 2 * 360

    game.map_settings.enemy_expansion.enabled = true
    game.map_settings.enemy_expansion.settler_group_min_size = 1
    game.map_settings.enemy_expansion.settler_group_max_size = 1
end


local function randomize_mapgen(planet)
    -- possible result :
    -- --> more resources
    -- --> less resources
    -- --> full random
    -- --> 1 or less
    -- --> deathworld like
    -- --> space
    -- -->
    return storage.mapgen.defaults[planet]
end

local function randomize_heating_planet(planet)
    local planet_list = {}
    local index = 0
    for _, p in pairs(game.planets) do
        if string.find(p.name, planet, 1, true) then
            table.insert(planet_list, p.name)
            index = index + 1
        end
    end

    if index == 0 then
        return nil
    else
        return planet_list[math.random(index)]
    end
end


dw.generate_surface = function(planet, vanilla)
    force_map_settings()

    -- if planet has heating, we cannot customize mapgen
    if game.planets[planet].prototype.entities_require_heating then
        planet = randomize_heating_planet(planet)

        -- if no valid planet is found, use neo-nauvis
        if not planet then
            return dw.generate_surface('neo-nauvis')
        end

        storage.warp.previous = storage.warp.current
        storage.warp.number = storage.warp.number + 1

        local surface = game.planets[planet].create_surface()

        storage.warp.current = {
            name = surface.name,
            type = planet,
            surface = surface,
            surface_index = surface.index
        }

        --- we also force the timer for these planet
        storage.timer.warp = (storage.timer.base > 0) and math.min(storage.timer.base, 30 * 60) or (30 * 60)
    else

        storage.warp.previous = storage.warp.current
        storage.warp.number = storage.warp.number + 1
        storage.warp.current = {
            name = planet..'-'..storage.warp.number,
            type = planet,
        }

        local mapgen = storage.mapgen.defaults[planet]
        if not vanilla then
            mapgen = randomize_mapgen(planet)
            mapgen.seed = math.random(1, 2^32-1)
        end

        local surface = game.create_surface(storage.warp.current.name, mapgen)
        surface.localised_name = game.planets[planet].prototype.localised_name
        storage.warp.current.surface = surface
        storage.warp.current.surface_index = surface.index
    end

    storage.warp.current.surface.request_to_generate_chunks({x= 0, y = 0}, storage.platform.warp.size / 32 + 1)
    storage.warp.current.surface.force_generate_chunk_requests()
end


dw.update_surfaces_properties = function()
    if storage.warp.status ~= defines.warp.warping then return end
    game.delete_surface(storage.warp.previous.name)
end

local function update_default_mapgen()
    for _, planet in pairs(game.planets) do
        if planet.prototype.entities_require_heating then goto continue end
        if planet.name == "nauvis" then goto continue end

        storage.mapgen.defaults[planet.name] = planet.prototype.map_gen_settings
        ::continue::
    end
end

local function update_autoplace_control_list()
    for _, planet in pairs(game.planets) do
        if planet.prototype.entities_require_heating then goto continue end

        local mapgen = planet.prototype.map_gen_settings
        if not mapgen or not mapgen.autoplace_controls then goto continue end

        storage.mapgen.autoplace_controls[planet.name] = {total = 0, autoplace = {}}

        for autoplace_name, _ in pairs(mapgen.autoplace_controls) do
            if prototypes.autoplace_control[autoplace_name].richness then
                storage.mapgen.autoplace_controls[planet.name].autoplace[autoplace_name] = true
                storage.mapgen.autoplace_controls[planet.name].total = storage.mapgen.autoplace_controls[planet.name].total + 1
            end
        end

        ::continue::
    end
end


local function surface_deleted(event)
    if event.surface_index == storage.warp.previous.surface_index then
        local planet = game.planets[storage.warp.current.type]
        if not planet.prototype.entities_require_heating then
            planet.associate_surface(storage.warp.current.surface)
        end
        dw.platform_force_update_entities()
        storage.warp.previous = nil
        storage.warp.status = defines.warp.awaiting
    end
end


dw.register_event(defines.events.on_surface_deleted, surface_deleted)
dw.register_event('on_init', update_autoplace_control_list)
dw.register_event('on_init', update_default_mapgen)
dw.register_event('on_configuration_changed', update_autoplace_control_list)
dw.register_event('on_configuration_changed', update_default_mapgen)