
local function prevent_surface_build(event)
    local factorissimo_list = {
        ["factory-1"] = true,
        ["factory-2"] = true,
        ["factory-3"] = true,
        ["factory-1-instantiated"] = true,
        ["factory-2-instantiated"] = true,
        ["factory-3-instantiated"] = true,
    }
    local entity = event.entity
    if not entity.valid or not factorissimo_list[entity.name] then return end

    if entity.surface ~= storage.warp.current.surface then return end

    utils.spill_or_return_item(event)
    utils.create_flying_text{
        position = entity.position,
        surface = entity.surface,
        text = {"dw-messages.cannot-build-factorissimo"},
        color = util.color(defines.hexcolor.orangered.. 'd9')}
    entity.destroy{raise_destroy=true}
end

dw.register_event(defines.events.on_built_entity, prevent_surface_build)
dw.register_event(defines.events.on_robot_built_entity, prevent_surface_build)
dw.register_event(defines.events.script_raised_revive, prevent_surface_build)