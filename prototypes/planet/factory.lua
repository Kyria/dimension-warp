--- factory planet: Produstia
---
local nauvis = data.raw["planet"]["nauvis"]

local tile_name = settings.startup['dw-default-tile-background'].value
local default_tile = (data.raw['tile'][tile_name]) and tile_name or "out-of-map"

local produstia = {
    name = "produstia",
    order = "a[produstia]",
    type = "planet",
    draw_orbit = false,
    distance = 65,
    orientation = 0.26,
    gravity_pull = 10,
    magnitude = 0.5,

    icons = {{
        icon = "__base__/graphics/icons/assembling-machine-3.png",
        tint = defines.color.darkgray
    }},
    starmap_icons = {{
        icon = "__base__/graphics/icons/assembling-machine-3.png",
        icon_size = 512,
        tint = defines.color.darkgray
    }},

    pollutant_type = "pollution",
    solar_power_in_space = 300,
    planet_procession_set =
    {
        arrival = {"default-b"},
        departure = {"default-rocket-a"}
    },
    surface_properties = {
        ["solar-power"] = 0,
        ["day-night-cycle"] = 0,
        ["ceiling"] = 1, -- required for rockets
    },
    surface_render_parameters = {},
    lightning_properties = nil,
    procession_graphic_catalogue = table.deepcopy(nauvis.procession_graphic_catalogue),
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
    local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

    produstia.subgroup = "planets"
    produstia.asteroid_spawn_influence = 1
    produstia.asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.1)

    data:extend({produstia})
else
    data:extend({produstia})
end

utils.add_music(nauvis, produstia)