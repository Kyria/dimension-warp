-- change default import for items when importing on space platform.
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
end