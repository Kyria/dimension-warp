local function create_linked_belt(name, base)
    return {
        type = "linked-belt",
        name = name,
        structure = table.deepcopy(base.structure),
        structure_render_layer = 'object',

        belt_animation_set = table.deepcopy(base.belt_animation_set),
        speed = table.deepcopy(base.speed),
        animation_speed_coefficient = 32,

        max_health = 150,
        icons = table.deepcopy(base.icons),
        collision_box = table.deepcopy(base.collision_box),
        selection_box = table.deepcopy(base.selection_box),
        collision_mask = table.deepcopy(base.collision_mask),
        minable = nil,
        fast_replaceable_group = "harvest-linked-belt"
    }
end
dw.harvester_create_linked_belt = create_linked_belt

-- works for vanilla, aai loaders and krastorio2
data:extend{
    create_linked_belt("harvest-linked-belt", data.raw['loader-1x1']["dw-stair-loader"]),
    create_linked_belt("harvest-fast-linked-belt", data.raw['loader-1x1']["dw-stair-fast-loader"]),
    create_linked_belt("harvest-express-linked-belt", data.raw['loader-1x1']["dw-stair-express-loader"]),
}

-- space age specific
if data.raw['loader-1x1']["dw-stair-turbo-loader"] then
    data:extend{create_linked_belt("harvest-turbo-linked-belt", data.raw['loader-1x1']["dw-stair-turbo-loader"])}
end
