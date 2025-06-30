-- force all pipes entity and storage tanks to have long extent, to avoid issue due to mobile gates / harvesters
for _, pipe_entity in pairs(data.raw['pipe']) do
    if pipe_entity.fluid_box then
        pipe_entity.fluid_box.max_pipeline_extent = 25000
    end
end
for _, pipe_entity in pairs(data.raw['pipe-to-ground']) do
    if pipe_entity.fluid_box then
        pipe_entity.fluid_box.max_pipeline_extent = 25000
    end
end
for _, tank in pairs(data.raw['storage-tank']) do
    if tank.fluid_box then
        tank.fluid_box.max_pipeline_extent = 25000
    end
end