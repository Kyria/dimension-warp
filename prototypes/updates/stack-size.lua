if not settings.startup['dw-adjust-stack-size'].value then
    return
end

local stack_size_value = 200

-- ore and basic materials
data.raw.item["coal"].stack_size = stack_size_value
data.raw.item["copper-ore"].stack_size = stack_size_value
data.raw.item["iron-ore"].stack_size = stack_size_value
data.raw.item["stone"].stack_size = stack_size_value
data.raw.item["uranium-ore"].stack_size = stack_size_value
data.raw.item["wood"].stack_size = stack_size_value
data.raw.item["uranium-235"].stack_size = stack_size_value
data.raw.item["uranium-238"].stack_size = stack_size_value

-- plates / melted materials / processed raw
data.raw.item["stone-brick"].stack_size = stack_size_value
data.raw.item["copper-plate"].stack_size = stack_size_value
data.raw.item["steel-plate"].stack_size = stack_size_value
data.raw.item["iron-plate"].stack_size = stack_size_value
data.raw.item["iron-gear-wheel"].stack_size = stack_size_value
data.raw.item["iron-stick"].stack_size = stack_size_value
data.raw.item["processing-unit"].stack_size = stack_size_value

-- fuels
data.raw.item["solid-fuel"].stack_size = stack_size_value
data.raw.item["rocket-fuel"].stack_size = stack_size_value * 0.5
data.raw.item["uranium-fuel-cell"].stack_size = stack_size_value * 0.5
data.raw.item["depleted-uranium-fuel-cell"].stack_size = stack_size_value * 0.5
data.raw.item["nuclear-fuel"].stack_size = stack_size_value * 0.05

-- petroleum items
data.raw.item["battery"].stack_size = stack_size_value
data.raw.item["low-density-structure"].stack_size = stack_size_value * 0.5
data.raw.item["plastic-bar"].stack_size = stack_size_value
data.raw.item["sulfur"].stack_size = stack_size_value

-- concrete and related
data.raw.item["concrete"].stack_size = stack_size_value
data.raw.item["hazard-concrete"].stack_size = stack_size_value
data.raw.item["refined-concrete"].stack_size = stack_size_value
data.raw.item["refined-hazard-concrete"].stack_size = stack_size_value

-- ammo
data.raw.ammo["artillery-shell"].stack_size = 25
data.raw.ammo["firearm-magazine"].stack_size = stack_size_value
data.raw.ammo["piercing-rounds-magazine"].stack_size = stack_size_value
data.raw.ammo["uranium-rounds-magazine"].stack_size = stack_size_value
data.raw.ammo["cannon-shell"].stack_size = stack_size_value
data.raw.ammo["explosive-cannon-shell"].stack_size = stack_size_value
data.raw.ammo["uranium-cannon-shell"].stack_size = stack_size_value
data.raw.ammo["rocket"].stack_size = stack_size_value
data.raw.ammo["explosive-rocket"].stack_size = stack_size_value

-- other
data.raw.capsule["raw-fish"].stack_size = 50
data.raw.item["barrel"].stack_size = 20
data.raw.item["explosives"].stack_size = stack_size_value
data.raw.item["stone-wall"].stack_size = stack_size_value
data.raw.item["landfill"].stack_size = stack_size_value
data.raw.tool["space-science-pack"].stack_size = 1000


if mods['space-age'] then
    -- raw
    data.raw.item["calcite"].stack_size = stack_size_value
    data.raw.item["tungsten-ore"].stack_size = stack_size_value

    data.raw.item["holmium-ore"].stack_size = stack_size_value
    data.raw.item["scrap"].stack_size = stack_size_value

    -- processed
    data.raw.item["holmium-plate"].stack_size = stack_size_value
    data.raw.item["supercapacitor"].stack_size = stack_size_value
    data.raw.item["carbon-fiber"].stack_size = stack_size_value

    data.raw.item["lithium"].stack_size = stack_size_value
    data.raw.item["lithium-plate"].stack_size = stack_size_value
    data.raw.item["ice"].stack_size = stack_size_value
    data.raw.item["quantum-processor"].stack_size = stack_size_value

    data.raw.item["tungsten-carbide"].stack_size = stack_size_value
    data.raw.item["tungsten-plate"].stack_size = stack_size_value
    data.raw.item["carbon"].stack_size = stack_size_value

    -- fuels
    data.raw.item["fusion-power-cell"].stack_size = stack_size_value * 0.5

    -- concrete and related
    data.raw.item['artificial-yumako-soil'].stack_size = stack_size_value
    data.raw.item['artificial-jellynut-soil'].stack_size = stack_size_value
    data.raw.item['overgrowth-yumako-soil'].stack_size = stack_size_value
    data.raw.item['overgrowth-jellynut-soil'].stack_size = stack_size_value

    -- ammo
    data.raw.ammo["railgun-ammo"].stack_size = stack_size_value * 0.25

    -- gleba stuff
    data.raw.item["yumako-seed"].stack_size = stack_size_value
    data.raw.item["jellynut-seed"].stack_size = stack_size_value
    data.raw.capsule["yumako"].stack_size = stack_size_value
    data.raw.capsule["jellynut"].stack_size = stack_size_value
    data.raw.item["iron-bacteria"].stack_size = stack_size_value
    data.raw.item["copper-bacteria"].stack_size = stack_size_value
    data.raw.item["nutrients"].stack_size = stack_size_value
    data.raw.capsule["bioflux"].stack_size = stack_size_value
end