-- change default import for items when importing on space platform.
require 'prototypes.update-final.collision'

if mods['space-age'] then
    for _, item in pairs(data.raw.item) do
        item.default_import_location = 'produstia'
    end
    for _, tool in pairs(data.raw.tool) do
        tool.default_import_location = 'produstia'
    end
    for _, ammo in pairs(data.raw.ammo) do
        ammo.default_import_location = 'produstia'
    end
    for _, module in pairs(data.raw.module) do
        module.default_import_location = 'produstia'
    end
    for _, capsule in pairs(data.raw.capsule) do
        capsule.default_import_location = 'produstia'
    end

    for _, planet in pairs(data.raw.planet) do
        if not planet.pollutant_type then planet.pollutant_type = "pollution" end
    end
end

-- force autoplce from nauvis to neo-nauvis
local nauvis_mgs = data.raw.planet['nauvis'].map_gen_settings
data.raw.planet['neo-nauvis'].map_gen_settings = table.deepcopy(nauvis_mgs)

-- fix harvester techs uranium mining requirements sometimes removed(hidden) in mods. 
if data.raw.technology['uranium-mining'].hidden then
    for _, tech_name in pairs({'dimension-harvester-right-2', 'dimension-harvester-left-2'}) do
        local prereqs = data.raw.technology[tech_name].prerequisites
        if prereqs then
            for i = #prereqs, 1, -1 do
                if prereqs[i] == 'uranium-mining' then
                    table.remove(prereqs, i)
                end
            end
        end
    end
end