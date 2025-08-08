
---Grant the helper items in the beginning of the game, so it's easier for player
---@param event EventData.on_player_changed_position
local function check_cheat_bag(event)
    if not settings.global['dw-helper-starter-item'].value then return end

    local player = game.players[event.player_index]
    if player.surface.name ~= 'nauvis' and not storage.cheat_bag[player.name] then
        local character = player.character
        if not character then return end

        -- clear armor then replace with a new one
        local armor_inventory = character.get_inventory(defines.inventory.character_armor)
        if not armor_inventory then return end

        -- if something is already in the armor, move it to main inventory, not to break it
        if armor_inventory[1] then
            character.get_main_inventory().insert(armor_inventory[1])
        end
        armor_inventory.clear()

        -- insert the items now
        player.insert{name="power-armor", count = 1}
        player.insert{name="construction-robot", count = 50}
        player.force.create_ghost_on_entity_death = true
        local grid = armor_inventory[1].grid

        if grid then
            if script.active_mods['Krastorio2'] or script.active_mods['Krastorio2-spaced-out'] then
                player.insert{name="kr-fuel", count = 200}
                grid.put({name = "kr-portable-generator-equipment"})
                grid.put({name = "kr-superior-solar-panel-equipment"})
                grid.put({name = "kr-superior-solar-panel-equipment"})
                grid.put({name = "kr-superior-solar-panel-equipment"})
            else
                grid.put({name = "fission-reactor-equipment"})
                grid.put({name = "personal-roboport-mk2-equipment"})
            end
            grid.put({name = "personal-roboport-mk2-equipment"})
            grid.put({name = "battery-mk2-equipment"})
            grid.put({name = "battery-mk2-equipment"})
            grid.put({name = "energy-shield-equipment"})

            -- charge everything
            for _, equipment in ipairs(grid.equipment) do
                if equipment.max_shield > 0 then
                    equipment.shield = equipment.max_shield
                elseif equipment.max_energy > 0 then
                    equipment.energy = equipment.max_energy
                end
            end
        end
        storage.cheat_bag[player.name] = true
    end
end

---Count items from all chests (non logistic) in a given surface
---@param surface LuaSurface
---@param area ?BoundingBox
local function count_chest_items(surface, area)
    local chests
    if area then
        chests = surface.find_entities_filtered{area=area, type={"container", "logistic-container"}, force=game.forces.player}
    else
        chests = surface.find_entities_filtered{type={"container", "logistic-container"}, force=game.forces.player}
    end
    for _, chest in pairs(chests) do
        for _, item_qty in pairs(storage.gui.item_list) do
            item_qty.qty = item_qty.qty + chest.get_item_count(item_qty.item)
        end
    end
end

---Count all the item we watch to update the watch GUI.
---Call the method to count logistic networks and chests
---@param event EventData.on_tick
local function count_stored_items(event)
    if not storage.nauvis_lab_exploded then return end
    -- init the list
    local item_list = {}
    for _, item in pairs(storage.gui.item_watch) do
        local index = item.name .. '-' .. item.quality
        if not item_list[index] then
            item_list[index] = {
                item = item,
                qty = 0,
                prev = (storage.gui.item_list[index] and storage.gui.item_list[index].qty or 0)
            }
        end
    end
    storage.gui.item_list = item_list

    -- count items
    count_chest_items(storage.warp.current.surface, math2d.bounding_box.create_from_centre({0, 0}, storage.platform.warp.size, storage.platform.warp.size))
    if storage.platform.factory.surface then count_chest_items(storage.platform.factory.surface) end
    if storage.platform.mining.surface then count_chest_items(storage.platform.mining.surface) end
    if storage.platform.power.surface then count_chest_items(storage.platform.power.surface) end

    -- update GUI
    dw.gui.update_watchdogs_gui()
end

dw.register_event(defines.events.on_player_changed_position, check_cheat_bag)
dw.register_event("on_nth_tick_300", count_stored_items)