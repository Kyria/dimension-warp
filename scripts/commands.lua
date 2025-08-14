


local function reset_platforms(command)
    if not storage.platform.factory.surface then return end

    local platform_area = math2d.bounding_box.create_from_centre({0, 0}, storage.platform.warp.size, storage.platform.warp.size)
    local surface = storage.warp.current.surface
    local entity_list = {
        "dw-hidden-radio-pole", "dw-hidden-gate-pole", "dw-chest", "dw-logistic-input", "dw-logistic-output", "dw-pipe",
        "dw-stair-loader", "dw-stair-fast-loader", "dw-stair-express-loader"
    }

    if prototypes.entity['dw-stair-turbo-loader'] then table.insert(entity_list, 'dw-stair-turbo-loader') end
    if prototypes.entity['dw-stair-advanced-loader'] then table.insert(entity_list, 'dw-stair-advanced-loader') end
    if prototypes.entity['dw-stair-superior-loader'] then table.insert(entity_list, 'dw-stair-superior-loader') end

    local entities = surface.find_entities_filtered{
        area = platform_area,
        name = entity_list
    }
    for _, entity in pairs(entities) do
        entity.destroy()
    end

    -- recreate surface chests and links with factory
    local factory_pole = storage.platform.factory.surface.find_entity("dw-hidden-gate-pole", {0, -6})
    local pole = dw.platforms.create_special_entity(storage.warp.current.surface, dw.entities.surface_radio_pole)
    if factory_pole and pole then utils.link_cables(factory_pole, pole, defines.wire_connectors.power) end
    dw.logistics.create_loader_chest_pair(storage.warp.current.surface, storage.platform.factory.surface, dw.stairs.surface_factory)
    dw.logistics.create_pipe_pairs(storage.warp.current.surface, storage.platform.factory.surface, dw.stairs.surface_factory)

    -- recreate the mobile gate if it exists
    if storage.warpgate.gate then
        if storage.warpgate.mobile_gate and storage.warpgate.mobile_gate.valid then storage.warpgate.mobile_gate.destroy{raise_destroy=true} end
        dw.gate.create_warpgate()
        dw.gate.create_mobile_gate()
    end
end

local function reset_harvester_side(side, entity_list)
    local surface = storage.platform.mining.surface
    local harvester_area = math2d.bounding_box.create_from_centre(dw.harvesters[side].center, storage.harvesters[side].size - 1)

    dw.platforms.recall_harvester(side)

    local entities = surface.find_entities_filtered{
        area = harvester_area,
        name = entity_list
    }
    for _,entity in pairs(entities) do
        entity.destroy()
    end

    dw.platforms.create_harvester_zone(side)
    dw.platforms.create_update_pipes_loaders(side)
end

local function reset_harvesters(command)
    if not storage.platform.mining.surface then return end

    local entity_list = {
        "dw-hidden-radio-pole", "dw-hidden-gate-pole", "dw-chest", "dw-logistic-input", "dw-logistic-output", "dw-pipe",
        "dw-stair-loader", "dw-stair-fast-loader", "dw-stair-express-loader",
        "harvest-linked-belt", "harvest-fast-linked-belt", "harvest-express-linked-belt"
    }

    if prototypes.entity['dw-stair-turbo-loader'] then
        table.insert(entity_list, 'dw-stair-turbo-loader')
        table.insert(entity_list, 'harvest-turbo-linked-belt')
    end
    if prototypes.entity['dw-stair-advanced-loader'] then
        table.insert(entity_list, 'dw-stair-advanced-loader')
        table.insert(entity_list, 'harvest-advanced-linked-belt')
    end
    if prototypes.entity['dw-stair-superior-loader'] then
        table.insert(entity_list, 'dw-stair-superior-loader')
        table.insert(entity_list, 'harvest-superior-linked-belt')
    end

    if storage.harvesters.left.gate then reset_harvester_side("left", entity_list) end
    if storage.harvesters.right.gate then reset_harvester_side("right", entity_list) end
end


commands.add_command("dw_reset_warp_platform", {"dw-commands.reset-platform"}, reset_platforms)
commands.add_command("dw_reset_harvesters", {"dw-commands.reset-harvesters"}, reset_harvesters)