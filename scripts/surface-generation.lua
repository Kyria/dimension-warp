--- Surface generation and randomization
------------------------------------------------------------
local function ore_missing_gen(mapgen, planet_name)
    local total_ore = storage.mapgen.autoplace_settings[planet_name].total
    local number_saved = math.random(math.max(1, total_ore - 1))
    local resource_list = {}
    for resource, _ in pairs(storage.mapgen.autoplace_settings[planet_name].autoplace) do
        table.insert(resource_list, resource)
    end
    for i = 0, total_ore - number_saved, 1 do
        local index_removed = math.random(total_ore - i)
        mapgen.autoplace_settings.entity.settings[resource_list[index_removed]] = nil
        table.remove(resource_list, index_removed)
    end
    return mapgen
end

local function barren_gen(mapgen, planet_name)
    for resource, _ in pairs(storage.mapgen.autoplace_settings[planet_name].autoplace) do
        mapgen.autoplace_settings.entity.settings[resource] = nil
    end
    return mapgen
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

    game.map_settings.enemy_evolution.enabled = true --
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

--- normal
local ore_random_types = {{"normal", nil}}
local ore_random_weights = {10}

local function randomize_mapgen(planet)
    if storage.warp.number >= 5 then
        for _, types in pairs(ore_random_types) do
            if types[1] == 'missing' then goto end_missing end
        end
        ore_random_weights[1] = 5
        table.insert(ore_random_types, {"missing", ore_missing_gen})
        table.insert(ore_random_weights, 10)
        ::end_missing::
    end
    if storage.warp.number >= 10 then
        for _, types in pairs(ore_random_types) do
            if types[1] == 'barren' then goto end_barren end
        end
        table.insert(ore_random_types, {"barren", barren_gen})
        table.insert(ore_random_weights, 2)
        ::end_barren::
    end

    local mapgen = table.deepcopy(storage.mapgen.defaults[planet])
    local random_gen = utils.weighted_random_choice(ore_random_types, ore_random_weights)

    if random_gen[1] ~= "normal" then
        mapgen = random_gen[2](mapgen, planet)
    end
    storage.warp.gen = random_gen[1]

    return mapgen
end

dw.generate_surface = function(planet, vanilla)
    force_map_settings()

    -- if planet has heating, we cannot customize mapgen
    if game.planets[planet].prototype.entities_require_heating then
        storage.warp.previous = storage.warp.current
        storage.warp.number = storage.warp.number + 1
        storage.warp.gen = "normal"

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

        local mapgen = table.deepcopy(storage.mapgen.defaults[planet])
        if not vanilla then
            mapgen = randomize_mapgen(planet)
            mapgen.seed = math.random(1, 2^32-1)
            --- test
            mapgen.starting_area = math.random()*0.8
            --if mapgen.autoplace_controls['enemy-base'] then
            --    mapgen.autoplace_controls['enemy-base'].frequency = math.random()*5
            --    mapgen.autoplace_controls["enemy-base"].size = math.random()*5
            --    game.print('starting area : ' .. mapgen.starting_area)
            --    game.print('enemy freq : ' .. mapgen.autoplace_controls['enemy-base'].frequency)
            --    game.print('enemy size : ' .. mapgen.autoplace_controls['enemy-base'].size)
            --else
            --    -- if planet == "fulgora" then
            --        -- mapgen.autoplace_controls['enemy-base'] = {
            --            -- richness = 1,
            --            -- frequency = 4,
            --            -- size = 4
            --        -- }
            --    -- end
            --end
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
        if dw.safe_surfaces[planet.name] then goto continue end

        storage.mapgen.defaults[planet.name] = planet.prototype.map_gen_settings

        for autoplace_name, _ in pairs(planet.prototype.map_gen_settings.autoplace_controls) do
            if prototypes.autoplace_control[autoplace_name].richness then
                storage.mapgen.defaults[planet.name].autoplace_controls[autoplace_name] = nil
            end
        end
        ::continue::
    end
end

local function update_autoplace_list()
    for _, planet in pairs(game.planets) do
        if planet.prototype.entities_require_heating then goto continue end
        if dw.safe_surfaces[planet.name] then goto continue end

        local mapgen = planet.prototype.map_gen_settings
        if not mapgen or not mapgen.autoplace_settings.entity then goto continue end

        storage.mapgen.autoplace_settings[planet.name] = {total = 0, autoplace = {}}

        -- store autoplace controls
        if mapgen.autoplace_settings.entity then
            for name, _ in pairs(mapgen.autoplace_settings.entity.settings) do
                if prototypes.entity[name].type == 'resource' then
                    storage.mapgen.autoplace_settings[planet.name].autoplace[name] = true
                    storage.mapgen.autoplace_settings[planet.name].total = storage.mapgen.autoplace_settings[planet.name].total + 1
                end
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
dw.register_event('on_init', update_autoplace_list)
dw.register_event('on_init', update_default_mapgen)
dw.register_event('on_configuration_changed', update_autoplace_list)
dw.register_event('on_configuration_changed', update_default_mapgen)