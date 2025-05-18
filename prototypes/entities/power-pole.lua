--- create a hidden power pole to allow current to be shared between levels
--- create a hidden power pole to allow current to be shared between levels
local hidden_pole = {
    type = "electric-pole",
    name = "dw-hidden-radio-pole",
    icons = {util.empty_icon()},
    flags = {"placeable-neutral", "player-creation"},
    minable = nil,
    max_health = 150,

    collision_box = {{-0.65, -0.65}, {0.65, 0.65}},
    collision_mask = {layers={}},
    selection_box = {{-0.55, -3},{-0.35, -2.2}},

    draw_copper_wires = true,
    draw_circuit_wires = false,
    auto_connect_up_to_n_wires = 4,

    maximum_wire_distance = 32,
    supply_area_distance = 0,
    pictures = {
        layers = {
            {
                filename = "__core__/graphics/empty.png",
                priority = "extra-high",
                width = 1,
                height = 1,
                direction_count = 1
            }
        }
    },
    connection_points =
    {
        {
            shadow =
            {
                copper = util.by_pixel(-14, -94),
                red = util.by_pixel(-14, -94),
                green =util.by_pixel(-14, -94)
            },
            wire =
            {
                copper = util.by_pixel(-14, -94),
                red = util.by_pixel(-14, -94),
                green = util.by_pixel(-14, -94)
            }
        }
    },
}


local medium_pole = {
    type = "electric-pole",
    name = "dw-hidden-gate-pole",
    icons = {util.empty_icon()},
    flags = {"placeable-neutral", "player-creation"},
    minable = nil,
    max_health = 150,

    collision_box = {{-0.65, -0.65}, {0.65, 0.65}},
    collision_mask = {layers={}},
    selection_box = {{0, 0},{0, 0}},

    draw_copper_wires = true,
    draw_circuit_wires = false,
    auto_connect_up_to_n_wires = 0,

    maximum_wire_distance = 2,
    supply_area_distance = 1,
    pictures = {
        layers = {
            {
                filename = "__core__/graphics/empty.png",
                priority = "extra-high",
                width = 1,
                height = 1,
                direction_count = 1
            }
        }
    },
    connection_points =
    {
        {
            shadow =
            {
                copper = util.by_pixel(0, 0),
                red = util.by_pixel(0, 0),
                green = util.by_pixel(0, 0),
            },
            wire =
            {
                copper = util.by_pixel(0, 0),
                red = util.by_pixel(0, 0),
                green = util.by_pixel(0, 0)
            }
        }
    },
}

data:extend{hidden_pole, medium_pole}