local function create_harvester_zone(side)
    local harvester_const = dw.harvesters[side]
    local harvester = storage.harvesters[side]

    local harvester_area = math2d.bounding_box.create_from_centre(harvester_const.center, harvester.size - 11)
    local warn_area = math2d.bounding_box.create_from_centre(harvester_const.center, harvester.size + 1)
    local side_area = math2d.bounding_box.create_from_centre(harvester_const.center, harvester.size + 1 + harvester.border * 2)
    local path_area = {{harvester_const.center[1] - harvester.border, harvester_const.center[2] - harvester.border}, {harvester.border -1 , harvester.border - 1}}

    local tiles = {}
    utils.add_tiles(tiles, "mining-platform", path_area[1], path_area[2])
    utils.add_tiles(tiles, "mining-platform", side_area.left_top, side_area.right_bottom)
    utils.add_tiles(tiles, "dimension-harvester-hazard", warn_area.left_top, warn_area.right_bottom)
    utils.add_tiles(tiles, "harvester-platform", harvester_area.left_top, harvester_area.right_bottom)
    storage.platform.mining.surface.set_tiles(tiles)

    if not harvester.gate then
        local harvester_gate = storage.platform.mining.surface.create_entity{
            name = harvester_const.name,
            position = harvester_const.center,
            force = game.forces.player,
        }
        harvester_gate.destructible = false
        local pole = storage.platform.mining.surface.create_entity{
            name = harvester_const.pole,
            position = harvester_const.center,
            force = game.forces.player,
        }
        pole.destructible = false
        harvester.gate = harvester_gate
        harvester.pole = pole
    end
end

--- Link the pipe and chest deployed in surface/position to the one in Smeltus
local function link_harvester_pipe_chest(side, surface, position)

end

local function harvester_placed(event)
    local harvester_grid = event.entity
    if not harvester_grid or harvester_grid and not harvester_grid.valid then return end
    if not string.match(harvester_grid.name, "harvester%-%a+%-grid%-%d") then return end
    if not utils.entity_built_surface_check(event, {[storage.warp.current.name]=true}, "dw-messages.cannot-build-harvester") then return end

    local position = event.entity.position
    local surface = storage.warp.current.surface
    local side = string.match(harvester_grid.name, "harvester%-(%a+)%-grid%-%d")
    harvester_grid.destroy()

    if storage.harvesters[side].deployed then return end

    -- if we are here, all lights are green to deploy a harvester
    local harvester = surface.create_entity{
        name = dw.harvesters[side].mobile_name,
        position = position,
        force = game.forces.player,
    }
    harvester.destructible = false
    --local pole = surface.create_entity{
    --    name = dw.harvesters[side].pole,
    --    position = position,
    --    force = game.forces.player,
    --}
    --pole.destructible = false

    --local tiles = {}
    --utils.add_tiles(tiles, "harvester-platform", deployed_area.left_top, deployed_area.right_bottom)
    --surface.set_tiles(tiles, true, false, false)
    local draw_area = math2d.bounding_box.create_from_centre(position, storage.harvesters[side].size)
    local render = rendering.draw_rectangle{
        color = util.color('#69351010'),
        left_top = draw_area.left_top,
        right_bottom = draw_area.right_bottom,
        surface = surface,
        only_in_alt_mode = true,
        draw_on_ground = true,
        filled = true
    }


    local deployed_area = math2d.bounding_box.create_from_centre(position, storage.harvesters[side].size - 1)
    local harvester_area = math2d.bounding_box.create_from_centre(dw.harvesters[side].center, storage.harvesters[side].size - 1, storage.harvesters[side].size - 1)
    local harvester_entities = storage.platform.mining.surface.find_entities_filtered {
        type = {"locomotive", "cargo-wagon", "fluid-wagon", "artillery-wagon", "car", "spider-vehicle", "player", "character", "radar", "resource"},
        area = harvester_area,
        invert = true,
    }

    local destination_offset = math2d.position.subtract(position, dw.harvesters[side].center)
    storage.platform.mining.surface.clone_entities{
        entities = harvester_entities,
        destination_surface = surface,
        destination_offset = destination_offset
    }

    for _, h_entity in pairs(harvester_entities) do
        if h_entity.name ~= dw.harvesters[side].pole then
            h_entity.destroy()
        end
    end

    storage.harvesters[side].rectangle = render
    storage.harvesters[side].area = deployed_area
    storage.harvesters[side].mobile = harvester
    storage.harvesters[side].mobile_pole = surface.find_entity(dw.entities.surface_radio_pole.name, position)
    utils.link_cables(storage.harvesters[side].mobile_pole, storage.harvesters[side].pole, defines.wire_connectors.power)
    utils.link_cables(storage.harvesters[side].mobile, storage.harvesters[side].gate, defines.wire_connectors.logic)
    utils.link_gates("harvester-" .. side .. "-to-surface", "surface-to-harvester-" .. side, storage.harvesters[side].gate, storage.harvesters[side].mobile)
    link_harvester_pipe_chest()
end






local function on_technology_research_finished(event)
    local tech = event.research
    if string.match(tech.name, "dimension%-harvester%-%a+%-%d+") then
        local side = string.match(tech.name, "dimension%-harvester%-(%a+)%-%d+")
        if side then
            storage.harvesters[side].size = dw.platform_size.harvester[tech.level]
            storage.harvesters[side].border = math.max((tech.level - 1), 2)
            storage.harvesters[side].mobile_name = "harvester-" .. side .. "-grid-" .. tech.level
            create_harvester_zone(side)
        end
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)

dw.register_event(defines.events.on_built_entity, harvester_placed)
dw.register_event(defines.events.on_robot_built_entity, harvester_placed)

dw.register_event(defines.events.on_player_mined_entity, harvester_mined)
dw.register_event(defines.events.on_robot_mined_entity, harvester_mined)
