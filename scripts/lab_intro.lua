--- Start event controls.

--- blueprint for the exploding base
local bp_nauvis_lab = {
    pos = {x = -8, y = -5},
    bp = "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"
}

local function generate_lab_structure()
    local surface = game.surfaces['nauvis']
    local force = game.forces['neutral']

    --- generate chunk to place the blueprint
    surface.request_to_generate_chunks({x= 0, y = 0}, 8)
    surface.force_generate_chunk_requests()

    --- remove rocks that may prevent the blueprint to be correctly placed
    local rocks = surface.find_entities_filtered{area = {{-40, -32}, {32, 32}}, name = {"big-rock", "huge-rock", "big-sand-rock"}}
    for _, rock in pairs(rocks) do
        rock.destroy()
    end

    --- create the blueprint
    local inv = game.create_inventory(1)
    inv.insert{name="blueprint", count = 1}
    local blueprint = inv[1]
    blueprint.import_stack(bp_nauvis_lab.bp)

    --- make sure to research all tech / deactivate ghosts for neutral
    force.research_all_technologies()
    force.create_ghost_on_entity_death = false

    --- build the blueprint and revive (construct) the entities
    local entities = blueprint.build_blueprint{
        surface = surface,
        force = force,
        position = bp_nauvis_lab.pos,
        build_mode = defines.build_mode.forced,
        direction=defines.direction.north,
        skip_fog_of_war=false
    }

    for _, entity in pairs(entities) do
        if entity.valid then
            _, e = entity.revive({raise_revive = true})
            if e then
                table.insert(storage.intro_built_entities, e)
                e.minable = false
            end
        end
    end

    inv.destroy()
end


local function spawn_biters()
    local surface = game.surfaces['nauvis']
    local force = game.forces['enemy']

    local center_x, center_y = 0, 0
    local radius = 300
    local total_entities = 100

    for i = 1, total_entities do
        -- Calculate the angle for each entity, evenly spaced around the circle
        local angle = (2 * math.pi / total_entities) * i

        -- Calculate the x and y coordinates on the circle
        local x = center_x + math.cos(angle) * radius
        local y = center_y + math.sin(angle) * radius

        -- Create the entity at the calculated position
        local biter = surface.create_entity{name = "behemoth-biter", position = {x = x, y = y}, force = force}
        local spitter = surface.create_entity{name = "behemoth-spitter", position = {x = x, y = y}, force = force}
        if biter and biter.commandable then
            biter.commandable.set_command({type = defines.command.attack_area, destination = {x = 0, y = 0}, radius = 50})
        end
        if spitter and spitter.commandable then
            spitter.commandable.set_command({type = defines.command.attack_area, destination = {x = 0, y = 0}, radius = 50})
        end
    end
end

--- remove the nauvis chunks as we won't get there anymore
local function remove_nauvis_chunk()
    for chunk in game.surfaces['nauvis'].get_chunks() do
        game.surfaces['nauvis'].delete_chunk({chunk.x, chunk.y})
    end
end

local function check_if_player_changed_surface()
    if not storage.nauvis_lab_exploded then return end
    if storage.all_players_left_nauvis then
        dw.remove_event(defines.events.on_tick, check_if_player_changed_surface)
        remove_nauvis_chunk()
        return
    end

    --- we check every 10sec if a player is still present, otherwise we flag it
    local any_player_on_nauvis = false
    if game.tick > 0 and game.tick % 600 ~= 0 then
        for _, player in pairs(game.players) do
            if player.surface.name == 'nauvis' then
                any_player_on_nauvis = true
            end
        end
        if not any_player_on_nauvis then
            storage.all_players_left_nauvis = true
        end
    end

    --- we leave players 5min then wel them if they are not on the new surface
    if game.tick == 0 or game.tick % 18000 ~= 0 then return end
    for _, player in pairs(game.players) do
        if player.surface.name == 'nauvis' then
            player.print({"dw-messages.intro-death"}, {color=defines.color.orange})
            player.character.die()
        end
    end
end

--- kill everything we created, to have a cool explosion
local function destroy_nauvis_lab_event()

    --- if the event was already fired, just remove it and forget
    if storage.nauvis_lab_exploded then
        dw.remove_event(defines.events.on_tick, destroy_nauvis_lab_event)
        return
    end

    if not storage.intro_built_entities then return end
    if game.tick == 0 or game.tick % 600 ~= 0 then return end
    for _, entity in pairs(storage.intro_built_entities) do
        entity.damage(1000000, game.forces['neutral'])
    end

    storage.nauvis_lab_exploded = true
    game.forces['player'].technologies['neo-nauvis'].researched = true
    storage.intro_built_entities = nil

    --- display message to notify the player of what's next
    game.print({"dw-messages.intro-explosion"}, {color=defines.color.orange})

    --- trigger biter spawn
    spawn_biters()

    --- create the portal
    local nauvis_teleport = game.surfaces['nauvis'].create_entity{
        name = "simple-teleport",
        position = {0, -4},
        force = game.forces['player'],
        direction = defines.direction.north
    }
    if nauvis_teleport then
        table.insert(storage.teleporter['nauvis'], {
            entity = nauvis_teleport,
            box = nauvis_teleport.selection_box,
            destination_surface = storage.warp.current.name,
            destination_position = {0, 0},
        })
    end

    --- randomize the center of the platform on neo_nauvis
    dw.update_warp_platform_size()
end

--- lay message for first character, and make sure new players are teleported to the new surface
local function on_character_created(event)
    local player = game.players[event.player_index]

    --- only display for first character.
    if player.index == 1 then
        game.print({"dw-messages.intro"}, {color=defines.color.orange})
    end
end


--- display message when player teleports to the new surface
local function player_teleported_to_neo_nauvis(event)
    if storage.lab_intro_finished or storage.warp.number > 1 then
        dw.remove_event(defines.events.on_player_changed_surface, player_teleported_to_neo_nauvis)
        return
    end

    local player = game.players[event.player_index]
    local surface = player.surface

    if surface.name == storage.warp.current.name then
        game.print({"dw-messages.intro-new-dimension-start"}, {color=defines.color.green})
    end
    storage.lab_intro_finished = true
end

local function on_init()
    storage.intro_built_entities = storage.intro_built_entities or {}
    generate_lab_structure()

    --- we do this manually, to be sure neo-nauvis is created from start
    dw.generate_surface('neo-nauvis', true)
    local planet = game.planets[storage.warp.current.type]
    planet.associate_surface(storage.warp.current.surface)

end

dw.register_event("on_init", on_init)
dw.register_event(defines.events.on_tick, destroy_nauvis_lab_event)
dw.register_event(defines.events.on_tick, check_if_player_changed_surface)
dw.register_event(defines.events.on_player_created, on_character_created)
dw.register_event(defines.events.on_player_changed_surface, player_teleported_to_neo_nauvis)