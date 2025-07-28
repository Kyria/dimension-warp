for _, resource in ipairs({ "kr-imersite", "kr-mineral-water", "kr-rare-metal-ore" }) do
    data.raw.planet['neo-nauvis'].map_gen_settings.autoplace_controls[resource] = {}
    data.raw.planet['neo-nauvis'].map_gen_settings.autoplace_settings.entity.settings[resource] = {}
end