local collision_mask_util = require("collision-mask-util")

-- create specfic collision layers
data:extend{
    {type = "collision-layer", name = "surface-tiles"},
    {type = "collision-layer", name = "platform"},
    {type = "collision-layer", name = "produstia"},
    {type = "collision-layer", name = "electria"},
    {type = "collision-layer", name = "smeltus"}
}

-- set collision to the DW tiles
data.raw.tile['warp-platform'].collision_mask.layers['platform'] = true
data.raw.tile['dimension-hazard'].collision_mask.layers['produstia'] = true
data.raw.tile['factory-platform'].collision_mask.layers['produstia'] = true
data.raw.tile['energy-platform'].collision_mask.layers['electria'] = true
data.raw.tile['mining-platform'].collision_mask.layers['smeltus'] = true
data.raw.tile['harvester-platform'].collision_mask.layers['smeltus'] = true
data.raw.tile['dimension-harvester-hazard'].collision_mask.layers['smeltus'] = true

-- set collision to all other tiles
for _, tile in pairs(data.raw.tile) do
    if not tile.collision_mask.layers['platform'] and
        not tile.collision_mask.layers['produstia'] and
        not tile.collision_mask.layers['electria'] and
        not tile.collision_mask.layers['smeltus'] then
        tile.collision_mask.layers['surface-tiles'] = true
    end
end

-- add collision to specific buildings
-- only surface tiles, no DW tiles from platforms or surfaces.
local only_surface_entities = {
    data.raw.container["harvester-left-grid-1"],
    data.raw.container["harvester-left-grid-2"],
    data.raw.container["harvester-left-grid-3"],
    data.raw.container["harvester-left-grid-4"],
    data.raw.container["harvester-left-grid-5"],
    data.raw.container["harvester-left-grid-6"],
    data.raw.container["harvester-right-grid-1"],
    data.raw.container["harvester-right-grid-2"],
    data.raw.container["harvester-right-grid-3"],
    data.raw.container["harvester-right-grid-4"],
    data.raw.container["harvester-right-grid-5"],
    data.raw.container["harvester-right-grid-6"],
    data.raw.radar["harvester-left-mobile-gate"],
    data.raw.radar["harvester-right-mobile-gate"],
    data.raw.accumulator["mobile-gate-1"],
    data.raw.accumulator["mobile-gate-2"],
    data.raw.accumulator["mobile-gate-3"],
    data.raw.accumulator["mobile-gate-4"],
    data.raw.accumulator["mobile-gate-5"]
}

-- produstia only
local only_produstia = {
    data.raw["rocket-silo"]["rocket-silo"],
    data.raw["cargo-landing-pad"]["cargo-landing-pad"]
}

-- produstia, electria, smeltus only
local only_sub_surfaces = {}

-- produstia, electria, smeltus + surface platform
local only_dw_surfaces = {}

-- others, depending on mod loaded
if mods['space-age'] then
    table.insert(only_surface_entities, data.raw['agricultural-tower']["dimension-crane-yumako"])
    table.insert(only_surface_entities, data.raw['agricultural-tower']["dimension-crane-jellynut"])
end

if mods['factorissimo-2-notnotmelon'] then
    if mods['space-age'] then
        table.insert(only_sub_surfaces, data.raw['storage-tank']['factory-1'])
        table.insert(only_sub_surfaces, data.raw['storage-tank']['factory-2'])
        table.insert(only_sub_surfaces, data.raw['storage-tank']['factory-3'])
        table.insert(only_sub_surfaces, data.raw['storage-tank']['space-factory-1'])
        table.insert(only_sub_surfaces, data.raw['storage-tank']['space-factory-2'])
        table.insert(only_sub_surfaces, data.raw['storage-tank']['space-factory-3'])
    else
        table.insert(only_dw_surfaces, data.raw['storage-tank']['factory-1'])
        table.insert(only_dw_surfaces, data.raw['storage-tank']['factory-2'])
        table.insert(only_dw_surfaces, data.raw['storage-tank']['factory-3'])
        table.insert(only_dw_surfaces, data.raw['storage-tank']['space-factory-1'])
        table.insert(only_dw_surfaces, data.raw['storage-tank']['space-factory-2'])
        table.insert(only_dw_surfaces, data.raw['storage-tank']['space-factory-3'])
    end
end

for _, entity in pairs(only_surface_entities) do
    if not entity.collision_mask then entity.collision_mask = collision_mask_util.get_mask(entity) end
    entity.collision_mask.layers['platform'] = true
    entity.collision_mask.layers['produstia'] = true
    entity.collision_mask.layers['electria'] = true
    entity.collision_mask.layers['smeltus'] = true
end

for _, entity in pairs(only_produstia) do
    if not entity.collision_mask then entity.collision_mask = collision_mask_util.get_mask(entity) end
    entity.collision_mask.layers['surface-tiles'] = true
    entity.collision_mask.layers['platform'] = true
    entity.collision_mask.layers['electria'] = true
    entity.collision_mask.layers['smeltus'] = true
end

for _, entity in pairs(only_sub_surfaces) do
    if not entity.collision_mask then entity.collision_mask = collision_mask_util.get_mask(entity) end
    entity.collision_mask.layers['surface-tiles'] = true
    entity.collision_mask.layers['platform'] = true
end

for _, entity in pairs(only_dw_surfaces) do
    if not entity.collision_mask then entity.collision_mask = collision_mask_util.get_mask(entity) end
    entity.collision_mask.layers['surface-tiles'] = true
end

