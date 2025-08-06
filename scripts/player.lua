
---
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

dw.register_event(defines.events.on_player_changed_position, check_cheat_bag)