local radar = table.deepcopy(data.raw['radar']['radar'])
radar.name = "dw-hidden-radar"
radar.icon = nil
radar.icon_size = nil
radar.icons = {util.empty_icon()}
radar.collision_box = {{0,0}, {0,0}}
radar.selection_box = {{0,0}, {0,0}}
radar.collision_mask = {layers = {}}
radar.working_sound = nil
radar.minable = nil
radar.placeable_by = nil

radar.radius_minimap_visualisation_color = nil
radar.energy_per_nearby_scan = "250kJ"
radar.energy_per_sector = "500kJ"
radar.energy_source = {
    type = "void",
    emissions_per_minute = {
        pollution = 50,
    }
}
radar.energy_usage = "100kW"
radar.max_distance_of_nearby_sector_revealed = 6
radar.max_distance_of_sector_revealed = 0
radar.integration_patch = nil
radar.water_reflection = nil
radar.pictures = {
    layers = {
        {
            filename = "__core__/graphics/empty.png",
            priority = "extra-high",
            width = 1,
            height = 1,
            direction_count = 1,
        },
    }
}


if mods['space-age'] then
    radar.energy_source.emissions_per_minute = {
        pollution = 50,
        spores = 50,
    }
end

data:extend{radar}