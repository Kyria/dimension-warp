local simple_teleport_item = {
    type = "item",
    name = "simple-teleport",
    icons = {
        {
            icon = data.raw['item']['lab'].icon,
            icon_size = 64,
            icon_mipmaps = 4,
            tint = defines.color.darkcyan
        },
        {
            icon = data.raw['item']['accumulator'].icon,
            icon_size = 64,
            icon_mipmaps = 4,
            scale = 0.25,
            shift = {12, 12},
            tint = defines.color.cyan
        }
    },
    place_result = "simple-teleport",
    stack_size = 10
}

local simple_teleport_entity = table.deepcopy(data.raw.accumulator['accumulator'])
simple_teleport_entity.type = "accumulator"
simple_teleport_entity.name = "simple-teleport"
simple_teleport_entity.icons = {
    {
        icon = data.raw['item']['lab'].icon,
        icon_size = 64,
        icon_mipmaps = 4,
        tint = defines.color.darkcyan
    },
    {
        icon = data.raw['item']['accumulator'].icon,
        icon_size = 64,
        icon_mipmaps = 4,
        scale = 0.25,
        shift = {12, 12},
        tint = defines.color.cyan
    }
}
simple_teleport_entity.chargable_graphics = {
    picture = {
        filename = data.raw.lab['lab'].icon,
        width = 64,
        height = 64,
        tint = defines.color.darkcyan },
}
simple_teleport_entity.flags = {"placeable-neutral", "player-creation"}
simple_teleport_entity.minable = nil
simple_teleport_entity.max_health = 1000
simple_teleport_entity.is_military_target = true
simple_teleport_entity.selectable_in_game = true
simple_teleport_entity.collision_box = {{-0.9, -0.9}, {0.9, 0.9}}
simple_teleport_entity.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
simple_teleport_entity.collision_mask = {layers={object=true, item=true, floor=true, water_tile=true, is_lower_object=true}}
simple_teleport_entity.working_sound = nil

simple_teleport_entity.energy_source = {
        type = "electric",
        buffer_capacity = "10MJ",
        usage_priority = "secondary-output",
        input_flow_limit = "100kW",
        output_flow_limit = "100kW",
        drain = "1kW",
    }
simple_teleport_entity.draw_copper_wires = false

data:extend({simple_teleport_item, simple_teleport_entity})
