--- Boiler room: Electria
local tile_name = settings.startup['dw-default-tile-background'].value
local default_tile = (data.raw['tile'][tile_name]) and tile_name or "out-of-map"
local icon = (mods['space-age']) and "__space-age__/graphics/icons/lightning.png" or "__base__/graphics/icons/accumulator.png"

local electria = {
    name = "electria",
    order = "a[electria]",
    type = "planet",
    draw_orbit = false,
    distance = 13,
    orientation = 0.57,
    gravity_pull = 10,
    magnitude = 0.5,

    icons = {{
        icon = icon,
        tint = defines.color.darkgoldenrod
    }},
    starmap_icons = {{
        icon = icon,
        icon_size = 512,
        tint = defines.color.darkgoldenrod
    }},

    pollutant_type = "pollution",
    solar_power_in_space = 0,
    surface_properties = {
        ["solar-power"] = 0,
        ["day-night-cycle"] = 0,
        ["ceiling"] = 0,
    },
    surface_render_parameters = {},
    lightning_properties = nil,
    player_effects = nil,
    map_gen_settings = {
        default_enable_all_autoplace_controls = false,
        property_expression_names = {},
        autoplace_controls = {},
        autoplace_settings = {
            tile = {treat_missing_as_default = false, settings = {[default_tile] = {}}},
            entity = {treat_missing_as_default = false, settings = {}},
            decorative = {treat_missing_as_default = false, settings = {}},
        },
        starting_area = 0,
    }
}

if mods['space-age'] then
    electria.subgroup = "planets"
    electria.asteroid_spawn_influence = 0
    electria.asteroid_spawn_definitions = {}
end

data:extend({electria})

if mods['space-age'] then
    utils.add_music(data.raw["planet"]["gleba"], electria)
else
    utils.add_music(data.raw["planet"]["nauvis"], electria)
end