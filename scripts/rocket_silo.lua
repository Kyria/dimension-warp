--- prevent the rocket silo from being built everywhere.
------------------------------------------------------------
---
local function prevent_building_except_in_factory(event)
    local source = (event.robot) and event.robot or game.players[event.player_index]
    local entity = event.entity

    if not entity.valid then return end

    if entity.name == "rocket-silo" or entity.name == "cargo-landing-pad" then
        utils.entity_built_surface_check(event, {produstia=true}, "dw-messages.cannot-build-silo-cargo")
    end
end

dw.register_event(defines.events.on_built_entity, prevent_building_except_in_factory)
dw.register_event(defines.events.on_robot_built_entity, prevent_building_except_in_factory)