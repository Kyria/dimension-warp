--- Migration 0.8.0: remove rocket silos, cargo landing pads and cargo bays from produstia
------------------------------------------------------------

if not script.active_mods["space-age"] then return end

local surface = storage.platform.factory.surface
if not surface or not surface.valid then return end

-- destroy rocket silos outright
local rocket_silos = surface.find_entities_filtered{type = {"rocket-silo", "cargo-bay"}}
for _, entity in pairs(rocket_silos) do
    if entity.valid then
        entity.destroy{raise_destroy = true}
    end
end

-- replace cargo landing pads with an iron chest, spilling overflow onto the floor
local cargo_pads = surface.find_entities_filtered{type = "cargo-landing-pad"}
for _, pad in pairs(cargo_pads) do
    if not pad.valid then goto continue end

    local position = pad.position
    local force = pad.force

    -- collect all items from the pad inventory
    local items = {}
    local inv = pad.get_inventory(defines.inventory.chest)
    if inv then
        for i = 1, #inv do
            local stack = inv[i]
            if stack.valid_for_read then
                table.insert(items, {
                    name = stack.name,
                    count = stack.count,
                    quality = stack.quality,
                    health = stack.health,
                })
            end
        end
    end

    pad.destroy{raise_destroy = true}

    -- create a chest at the same position
    local chest = surface.create_entity{
        name = "steel-chest",
        position = position,
        force = force,
        raise_built = true,
    }

    if chest then
        local chest_inv = chest.get_inventory(defines.inventory.chest)
        for _, stack in pairs(items) do
            local inserted = chest_inv.insert(stack)
            local remaining = stack.count - inserted
            -- spill remainder on the floor
            if remaining > 0 then
                surface.spill_item_stack{
                    position = position,
                    stack = {name = stack.name, count = remaining, quality = stack.quality},
                    enable_looted = false,
                    force = force,
                }
            end
        end
    else
        -- no chest could be placed, spill everything
        for _, stack in pairs(items) do
            surface.spill_item_stack{
                position = position,
                stack = stack,
                enable_looted = false,
                force = force,
            }
        end
    end

    ::continue::
end

if game.forces.player.is_space_platforms_unlocked() then
    for _, platform in pairs(game.planets.produstia.get_space_platforms(game.forces.player)) do
        if platform.valid then platform.destroy(60) end
    end
    game.forces.player.lock_space_platforms()
end

if game.forces.player.is_space_location_unlocked("nauvis") and not storage.viqctory then
    game.forces.player.lock_space_location("nauvis")
    storage.victory = false
end