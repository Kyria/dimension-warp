--- prevent the rocket silo from being built everywhere.
------------------------------------------------------------
---
local function prevent_building_except_in_factory(event)
    local source = (event.robot) and event.robot or game.players[event.player_index]
    local entity = event.entity

    if not entity.valid then return end

    if entity.name == "rocket-silo" or entity.name == "cargo-landing-pad" then
        if entity.surface.name ~= "produstia" then
            if entity.type == 'entity-ghost' then
                entity.destroy()
                return
            end

            local consumed = (event.stack) and event.stack or event.consumed_items[1]
            local item_stack = {name=consumed, count=1}
            if consumed.quality then item_stack.quality = consumed.quality.name end

            if event.player_index and source.valid and source.character and source.character.valid then
                source.insert(item_stack)
            else
                entity.surface.spill_item_stack {
                    position = entity.position,
                    stack = item_stack,
                    enable_looted = true,
                    force = entity.force
                }
            end

            utils.create_flying_text{
                position = entity.position,
                surface = entity.surface,
                text = {"dw-messages.cannot-build-silo-cargo"},
                color = util.color(defines.hexcolor.orangered.. 'd9')}
            entity.destroy()
        end
    end
end

dw.register_event(defines.events.on_built_entity, prevent_building_except_in_factory)
dw.register_event(defines.events.on_robot_built_entity, prevent_building_except_in_factory)