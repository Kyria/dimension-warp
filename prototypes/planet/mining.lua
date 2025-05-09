--- Mining op platform: Smeltus
---

local tile_name = settings.startup['dw-default-tile-background'].value
local default_tile = (data.raw['tile'][tile_name]) and tile_name or "out-of-map"
local icon = (mods['space-age']) and "__space-age__/graphics/icons/foundry.png" or "__base__/graphics/icons/electric-furnace.png"

local smeltus = {
    name = "smeltus",
    order = "a[smeltus]",
    type = "planet",
    draw_orbit = false,
    distance = 17,
    orientation = 0.5,
    gravity_pull = 10,
    magnitude = 0.5,

    icons = {{
        icon = icon,
        tint = defines.color.peachpuff
    }},
    starmap_icons = {{
        icon = icon,
        icon_size = 512,
        tint = defines.color.peachpuff
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
    smeltus.subgroup = "planets"
    smeltus.asteroid_spawn_influence = 0
    smeltus.asteroid_spawn_definitions = {}
end

data:extend({smeltus})

if mods['space-age'] then
    utils.add_music(data.raw["planet"]["vulcanus"], smeltus)
else
    utils.add_music(data.raw["planet"]["nauvis"], smeltus)
end