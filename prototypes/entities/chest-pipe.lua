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
    max_pipeline_extent = 25000,
    hide_connection_info = true,
    volume = 100,
    pipe_covers = pipecoverspictures(),
}
util.recursive_tint(pipetoground, util.color(defines.hexcolor.dimgrey.. 'd9'))

local yumako_chest_input = table.deepcopy(data.raw['logistic-container']['buffer-chest'])
yumako_chest_input.name = "dw-crane-yumako-seed-input"
yumako_chest_input.minable = nil
yumako_chest_input.placeable_by = nil
util.recursive_tint(yumako_chest_input, util.color(defines.hexcolor.coral.. 'd9'))

local yumako_chest_output = table.deepcopy(data.raw['logistic-container']['passive-provider-chest'])
yumako_chest_output.name = "dw-crane-yumako-output"
yumako_chest_output.minable = nil
yumako_chest_output.placeable_by = nil
util.recursive_tint(yumako_chest_output, util.color(defines.hexcolor.coral.. 'd9'))

local jellynut_chest_input = table.deepcopy(data.raw['logistic-container']['buffer-chest'])
jellynut_chest_input.name = "dw-crane-jellynut-seed-input"
jellynut_chest_input.minable = nil
jellynut_chest_input.placeable_by = nil
util.recursive_tint(jellynut_chest_input, util.color(defines.hexcolor.olive.. 'd9'))

local jellynut_chest_output = table.deepcopy(data.raw['logistic-container']['passive-provider-chest'])
jellynut_chest_output.name = "dw-crane-jellynut-output"
jellynut_chest_output.minable = nil
jellynut_chest_output.placeable_by = nil
util.recursive_tint(jellynut_chest_output, util.color(defines.hexcolor.olive.. 'd9'))

data:extend{
    dimension_chest,
    input_chest,
    output_chest,
    pipetoground,
    yumako_chest_input,
    yumako_chest_output,
    jellynut_chest_input,
    jellynut_chest_output
}