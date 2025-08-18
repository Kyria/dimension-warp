-- force all pipes entity and storage tanks to have long extent, to avoid issue due to mobile gates / harvesters
local fluid_box_entity_types = {'valve', 'pump', 'pipe', 'pipe-to-ground', 'storage-tank', 'mining-drill', 'offshore-pump', 'assembling-machine', 'boiler', 'fluid-turret'}
for _, entity_type in pairs(fluid_box_entity_types) do
    for _, entity in pairs(data.raw[entity_type]) do
        -- most entities
        if entity.fluid_box then
            entity.fluid_box.max_pipeline_extent = 25000
        end
        -- drills, boiler (output)
        if entity.input_fluid_box then
            entity.input_fluid_box.max_pipeline_extent = 25000
        end
        if entity.output_fluid_box then
            entity.output_fluid_box.max_pipeline_extent = 25000
        end
        -- assembling machine
        if entity.fluid_boxes then
            for _, fluid_box in pairs(entity.fluid_boxes) do
                fluid_box.max_pipeline_extent = 25000
            end
        end
    end
end
