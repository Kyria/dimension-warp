require ("__base__.prototypes.entity.pipecovers")

local default_output = settings.startup['dw-logistic-chest-output'].value
local default_input = settings.startup['dw-logistic-chest-input'].value

local dimension_chest = table.deepcopy(data.raw['container']['steel-chest'])
dimension_chest.name = "dw-chest"
dimension_chest.minable = nil
dimension_chest.placeable_by = nil
dimension_chest.fast_replaceable_group = "stair-chest"
util.recursive_tint(dimension_chest, util.color(defines.hexcolor.dimgrey.. 'd9'))

local input_chest = table.deepcopy(data.raw['logistic-container'][default_input] or data.raw['logistic-container']['requester-chest'])
input_chest.name = "dw-logistic-input"
input_chest.minable = nil
input_chest.placeable_by = nil
input_chest.fast_replaceable_group = "stair-chest"
util.recursive_tint(input_chest, util.color(defines.hexcolor.dimgrey.. 'd9'))

local output_chest = table.deepcopy(data.raw['logistic-container'][default_output] or data.raw['logistic-container']['active-provider-chest'])
output_chest.name = "dw-logistic-output"
output_chest.minable = nil
output_chest.placeable_by = nil
output_chest.fast_replaceable_group = "stair-chest"
util.recursive_tint(output_chest, util.color(defines.hexcolor.dimgrey.. 'd9'))

local pipetoground = table.deepcopy(data.raw['pipe-to-ground']['pipe-to-ground'])
pipetoground.name = "dw-pipe"
pipetoground.minable = nil
pipetoground.placeable_by = nil
pipetoground.fast_replaceable_group = nil
pipetoground.fluid_box = {
    pipe_connections = {
        { position = {0, 0}, direction = defines.direction.north, connection_type = "normal"}, -- default
        { position = {0, 0}, direction = defines.direction.south, connection_type = "linked", linked_connection_id = 0,}
    },
    hide_connection_info = true,
    volume = 100,
    pipe_covers = pipecoverspictures(),
}
util.recursive_tint(pipetoground, util.color(defines.hexcolor.dimgrey.. 'd9'))



data:extend{dimension_chest, input_chest, output_chest, pipetoground}