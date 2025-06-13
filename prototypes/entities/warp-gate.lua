-----------------------------
--- Warp gate (base)
-----------------------------
local warp_gate = table.deepcopy(data.raw.accumulator['accumulator'])
warp_gate.type = "accumulator"
warp_gate.name = "warp-gate"
warp_gate.subgroup = "warpgate"
warp_gate.corpse = "lab-remnants"
warp_gate.icons = {
    {
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = util.color(defines.hexcolor.royalblue .. 'd9')
    }
}
warp_gate.chargable_graphics = {
    picture = {
        layers = {
            {
                filename = "__base__/graphics/entity/lab/lab.png",
                width = 194,
                height = 174,
                shift = util.by_pixel(0, 1.5),
                scale = 0.5,
                tint = util.color(defines.hexcolor.royalblue .. '77')
            },
            {
                filename = "__base__/graphics/entity/lab/lab-integration.png",
                width = 242,
                height = 162,
                shift = util.by_pixel(0, 15.5),
                scale = 0.5
            },
            {
                filename = "__base__/graphics/entity/lab/lab-shadow.png",
                width = 242,
                height = 136,
                shift = util.by_pixel(13, 11),
                draw_as_shadow = true,
                scale = 0.5
            }
        }
    }
}
warp_gate.flags = {"placeable-neutral", "player-creation"}
warp_gate.minable = nil
warp_gate.max_health = 1000
warp_gate.is_military_target = true
warp_gate.selectable_in_game = true
warp_gate.collision_box = {{-1.9, -1.4}, {1.9, 1.4}}
warp_gate.selection_box = {{-2, -1.5}, {2, 1.5}}
warp_gate.collision_mask = {layers={object=true, item=true, floor=true, water_tile=true, is_lower_object=true, player=true}}
warp_gate.working_sound = nil
warp_gate.energy_source = {
        type = "electric",
        buffer_capacity = "1GJ",
        usage_priority = "secondary-output",
        input_flow_limit = "20GW",
        output_flow_limit = "20GW",
        drain = nil,
    }
warp_gate.draw_copper_wires = false


-----------------------------
--- Mobile gates
-----------------------------
local mobile_gate1 = table.deepcopy(warp_gate)
mobile_gate1.name = "mobile-gate-1"
mobile_gate1.chargable_graphics.picture.layers[1].tint = util.color(defines.hexcolor.deepskyblue .. '77')
mobile_gate1.icons[1].tint = util.color(defines.hexcolor.deepskyblue .. '77')
mobile_gate1.energy_source.buffer_capacity = "4MJ"
mobile_gate1.energy_source.output_flow_limit = "250kW"
mobile_gate1.fast_replaceable_group = "mobile_gate"
mobile_gate1.minable = {mining_time = 0.2, result = "mobile-gate-1"}
mobile_gate1.placeable_by = {item = "mobile-gate-1", count = 1}

local mobile_gate2 = table.deepcopy(mobile_gate1)
mobile_gate2.name = "mobile-gate-2"
mobile_gate2.energy_source.buffer_capacity = "10MJ"
mobile_gate2.energy_source.output_flow_limit = "1MW"
mobile_gate2.minable = {mining_time = 0.2, result = "mobile-gate-2"}
mobile_gate2.placeable_by = {item = "mobile-gate-2", count = 1}

local mobile_gate3 = table.deepcopy(mobile_gate1)
mobile_gate3.name = "mobile-gate-3"
mobile_gate3.energy_source.buffer_capacity = "25MJ"
mobile_gate3.energy_source.output_flow_limit = "10MW"
mobile_gate3.minable = {mining_time = 0.2, result = "mobile-gate-3"}
mobile_gate3.placeable_by = {item = "mobile-gate-3", count = 1}

local mobile_gate4 = table.deepcopy(mobile_gate1)
mobile_gate4.name = "mobile-gate-4"
mobile_gate4.energy_source.buffer_capacity = "50MJ"
mobile_gate4.energy_source.output_flow_limit = "100MW"
mobile_gate4.minable = {mining_time = 0.2, result = "mobile-gate-4"}
mobile_gate4.placeable_by = {item = "mobile-gate-4", count = 1}

local mobile_gate5 = table.deepcopy(mobile_gate1)
mobile_gate5.name = "mobile-gate-5"
mobile_gate5.energy_source.buffer_capacity = "100MJ"
mobile_gate5.energy_source.output_flow_limit = "1GW"
mobile_gate5.minable = {mining_time = 0.2, result = "mobile-gate-5"}
mobile_gate5.placeable_by = {item = "mobile-gate-5", count = 1}

-----------------------------
--- Surface gates
-----------------------------
local factory_gate = table.deepcopy(warp_gate)
factory_gate.name = "factory-gate"
factory_gate.chargable_graphics.picture.layers[1].tint = util.color(defines.hexcolor.lightsteelblue .. '77')
factory_gate.icons[1].tint = util.color(defines.hexcolor.lightsteelblue .. '77')

local mining_gate = table.deepcopy(warp_gate)
mining_gate.name = "mining-gate"
mining_gate.chargable_graphics.picture.layers[1].tint = util.color(defines.hexcolor.darksalmon .. '77')
mining_gate.icons[1].tint = util.color(defines.hexcolor.darksalmon .. '77')

local power_gate = table.deepcopy(warp_gate)
power_gate.name = "power-gate"
power_gate.chargable_graphics.picture.layers[1].tint = util.color(defines.hexcolor.lightgoldenrodyellow .. '77')
power_gate.icons[1].tint = util.color(defines.hexcolor.lightgoldenrodyellow .. '77')

local surface_gate = table.deepcopy(warp_gate)
surface_gate.name = "surface-gate"
surface_gate.chargable_graphics.picture.layers[1].tint = util.color(defines.hexcolor.royalblue .. '77')
surface_gate.icons[1].tint = util.color(defines.hexcolor.royalblue .. '77')

local function create_item(name, icons)
    return {
        type = 'item',
        name = name,
        subgroup = "warpgate",

        stack_size = 1,
        weight = 1.5 * tons,
        icons = icons,

        place_result = name,
    }
end

data:extend{
    warp_gate,
    factory_gate,
    mining_gate,
    power_gate,
    surface_gate,

    mobile_gate1,
    mobile_gate2,
    mobile_gate3,
    mobile_gate4,
    mobile_gate5,
    create_item("mobile-gate-1", mobile_gate1.icons),
    create_item("mobile-gate-2", mobile_gate1.icons),
    create_item("mobile-gate-3", mobile_gate1.icons),
    create_item("mobile-gate-4", mobile_gate1.icons),
    create_item("mobile-gate-5", mobile_gate1.icons),

}