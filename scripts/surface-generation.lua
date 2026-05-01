--- Surface generation and randomization
------------------------------------------------------------
require "scripts.planets.neo-nauvis"
if script.active_mods['space-age'] then
    require "scripts.planets.fulgora"
    require "scripts.planets.gleba"
    require "scripts.planets.vulcanus"
    require "scripts.planets.aquilo"
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
    game.map_settings.enemy_evolution.time_factor = 0.000006 -- default 0.000004
    game.map_settings.enemy_evolution.destroy_factor = 0.0002 -- default 0.002
    game.map_settings.enemy_evolution.pollution_factor = 0.0000005 -- default 0.0000009

    game.map_settings.unit_group.min_group_gathering_time = 600
    game.map_settings.unit_group.max_group_gathering_time = 2 * 600
    game.map_settings.unit_group.max_unit_group_size = 200
    game.map_settings.unit_group.max_wait_time_for_late_members = 2 * 360

    game.map_settings.enemy_expansion.enabled = true
    game.map_settings.enemy_expansion.settler_group_min_size = 1
    game.map_settings.enemy_expansion.settler_group_max_size = 1
end

local function generate_surface(planet, vanilla)
    force_map_settings()

    if not game.planets[planet] then
        planet = "neo-nauvis"
    end

    local mapgen = table.deepcopy(game.planets[planet].prototype.map_gen_settings)
    storage.warp.previous = storage.warp.current
    storage.warp.number = storage.warp.number + 1
    storage.warp.randomizer = "Normal"
    storage.warp.current = {
        name = planet..'-'..storage.warp.number,
        planet = planet,
        surface = "",
        surface_index = ""
    }

    if dw.mapgen[planet] and dw.mapgen[planet].randomizer then
        local surface = dw.mapgen[planet].randomizer(mapgen, storage.warp.current.name)

        surface.localised_name = game.planets[planet].prototype.localised_name
        -- force the name, in case we are in a situation where it's fixed (eg. aquilo)
        storage.warp.current.name = surface.name
        storage.warp.current.surface = surface
        storage.warp.current.surface_index = surface.index

    else
        if planet == "nauvis" then
            local surface = game.planets.nauvis.surface or game.planets.nauvis.create_surface()
            storage.warp.current.name = surface.name
            storage.warp.current.surface = surface
            storage.warp.current.surface_index = surface.index
        else
            if game.planets[planet].prototype.entities_require_heating then
                local surface = game.planets[planet].create_surface()
                storage.warp.current.name = surface.name
                storage.warp.current.surface = surface
                storage.warp.current.surface_index = surface.index
            else
                mapgen.seed = math.random(2^16) + game.tick
                local surface = game.create_surface(storage.warp.current.name, mapgen)
                surface.localised_name = game.planets[planet].prototype.localised_name
                storage.warp.current.surface = surface
                storage.warp.current.surface_index = surface.index
            end
            --- we also force the timer for these planet
            storage.timer.warp = (storage.timer.base > 0) and math.min(storage.timer.base, 30 * 60) or (30 * 60)
        end
    end
    dw.rampant.check_surface_processed(storage.warp.current.surface)
    storage.warp.current.surface.request_to_generate_chunks({x= 0, y = 0}, storage.platform.warp.size / 32 + 1)
    storage.warp.current.surface.force_generate_chunk_requests()
end
dw.generate_surface = generate_surface

local function associate_surface_to_planet()
        local planet = game.planets[storage.warp.current.planet]
        if not planet.prototype.entities_require_heating and planet.name ~= "nauvis" then
            planet.associate_surface(storage.warp.current.surface)
        end
        dw.platform_force_update_entities()
        storage.warp.previous = nil
        storage.warp.status = defines.warp.awaiting
end

local function update_surfaces_properties()
    if storage.warp.status ~= defines.warp.warping then return end
    if storage.warp.previous.planet ~= "nauvis" then
        game.delete_surface(storage.warp.previous.name)
    else
        -- as we don't delete surface from nauvis, we need to make sure 
        -- that the next surface is correctly associated to its planet.
        associate_surface_to_planet()
        
        -- now we delete the platform on nauvis, we don't want to be able to duplicate what's there.
        local platform_area = math2d.bounding_box.create_from_centre({0, 0}, storage.platform.warp.size, storage.platform.warp.size)
        local nauvis_surface = game.planets.nauvis.surface
        if nauvis_surface then
            local entities = nauvis_surface.find_entities{platform_area.left_top, platform_area.right_bottom}
            for _, entity in pairs(entities) do
                if entity.valid then
                    entity.destroy{raise_destroy = true}
                end
            end
            -- replace all tiles in the platform area with dimension-space
            local tiles = {}
            for x = math.floor(platform_area.left_top.x), math.ceil(platform_area.right_bottom.x) - 1 do
                for y = math.floor(platform_area.left_top.y), math.ceil(platform_area.right_bottom.y) - 1 do
                    table.insert(tiles, {name = "dimension-space", position = {x, y}})
                end
            end
            nauvis_surface.set_tiles(tiles)
        end
    end
end
dw.update_surfaces_properties = update_surfaces_properties

local function surface_deleted(event)
    if storage.warp.previous and event.surface_index == storage.warp.previous.surface_index then
        associate_surface_to_planet()
    end
end

dw.register_event(defines.events.on_surface_deleted, surface_deleted)
