if not script.active_mods['space-age'] then return end

local function transfer_seeds(from_inventory, to_inventory, name, quantity)
    for i = 1, #from_inventory do
        if quantity <= 0 then return end
        local stack = from_inventory[i]

        if stack.valid_for_read then
            if stack.name == name   then
                local inserted_stack = {
                    name = stack.name,
                    count = math.min(stack.count, quantity),
                    quality = table.deepcopy(stack.quality)
                }

                local inserted = to_inventory.insert(inserted_stack)
                if inserted > 0 then
                    stack.count = stack.count - inserted
                    quantity = quantity - inserted
                end
            end
        end
    end
end

local function transfer_seeds_fruits(towers, seed_chest, fruit_chest, seed_name)
    for index, tower in pairs(towers) do
        if not tower.valid then
            table.remove(towers, index)
            goto continue
        end

        local tower_seed_inventory = tower.get_inventory(defines.inventory.agricultural_tower_input)
        local tower_fruit_inventory = tower.get_inventory(defines.inventory.agricultural_tower_output)
        local fruit_chest_inventory = fruit_chest.get_inventory(defines.inventory.chest)
        local seed_chest_inventory = seed_chest.get_inventory(defines.inventory.chest)

        utils.transfert_chest_content(tower_fruit_inventory, fruit_chest_inventory)
        if tower_seed_inventory.get_item_count(seed_name) < 1 then
            transfer_seeds(seed_chest_inventory, tower_seed_inventory, seed_name, 5)
        end

        ::continue::
    end
end

local function crane_built(event)
    local crane = event.entity
    if not crane.valid then return end
    if not string.match(crane.name, "dimension%-crane%-%a+") then return end
    if not utils.entity_built_surface_check(event, {[storage.warp.current.name]=true}, "dw-messages.cannot-build-crane") then return end

    if crane.name == "dimension-crane-yumako" then table.insert(storage.agricultural.yumako_towers, crane) end
    if crane.name == "dimension-crane-jellynut" then table.insert(storage.agricultural.jellynut_towers, crane) end

    local crane_pole = crane.surface.create_entity {
        name = "dw-hidden-gate-pole",
        position = crane.position,
        force = game.forces.player,
    }
    crane_pole.destructible = false
    utils.link_cables(crane_pole, storage.agricultural.pole, defines.wire_connectors.power)
end

---@param event (EventData.on_player_mined_entity|EventData.on_robot_mined_entity|EventData.on_entity_died)
local function crane_destroyed(event)
    local crane = event.entity
    if not crane.valid then return end
    if not string.match(crane.name, "dimension%-crane%-%a+") then return end

    -- remove the hidden pole when we remove the crane
    local pole = crane.surface.find_entity("dw-hidden-gate-pole", crane.position)
    if pole then pole.destroy() end
end

local function move_crane_items(event)
    transfer_seeds_fruits(storage.agricultural.jellynut_towers, storage.agricultural.jellynut_input, storage.agricultural.jellynut_output, "jellynut-seed")
    transfer_seeds_fruits(storage.agricultural.yumako_towers, storage.agricultural.yumako_input, storage.agricultural.yumako_output, "yumako-seed")
end

local function on_technology_research_finished(event)
    local tech = event.research
    if tech.name == "dimension-crane" then
        local yumako_input = storage.platform.mining.surface.create_entity {
            name = "dw-crane-yumako-seed-input",
            position = {-0.5, -0.5},
            force = game.forces.player,
        }
        local yumako_output = storage.platform.mining.surface.create_entity {
            name = "dw-crane-yumako-output",
            position = {-0.5, 0.5},
            force = game.forces.player,
        }
        local jellynut_input = storage.platform.mining.surface.create_entity {
            name = "dw-crane-jellynut-seed-input",
            position = {0.5, -0.5},
            force = game.forces.player,
        }
        local jellynut_output = storage.platform.mining.surface.create_entity {
            name = "dw-crane-jellynut-output",
            position = {0.5, 0.5},
            force = game.forces.player,
        }
        local fruit_pole = storage.platform.mining.surface.create_entity {
            name = "dw-hidden-gate-pole",
            position = {0.5, 0.5},
            force = game.forces.player,
        }
        yumako_input.destructible = false
        yumako_output.destructible = false
        jellynut_input.destructible = false
        jellynut_output.destructible = false
        fruit_pole.destructible = false

        storage.agricultural.yumako_input = yumako_input
        storage.agricultural.yumako_output = yumako_output
        storage.agricultural.jellynut_input = jellynut_input
        storage.agricultural.jellynut_output = jellynut_output

        storage.agricultural.pole = fruit_pole

        storage.agricultural.yumako_towers = {}
        storage.agricultural.jellynut_towers = {}
    end
end

dw.register_event(defines.events.on_research_finished, on_technology_research_finished)
dw.register_event("on_nth_tick_60", move_crane_items)

dw.register_event(defines.events.on_built_entity, crane_built)
dw.register_event(defines.events.on_robot_built_entity, crane_built)

dw.register_event(defines.events.on_player_mined_entity, crane_destroyed)
dw.register_event(defines.events.on_robot_mined_entity, crane_destroyed)
dw.register_event(defines.events.on_entity_died, crane_destroyed)
