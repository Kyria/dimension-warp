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
    distance = 10,
    orientation = 0.43,
    gravity_pull = 10,
    magnitude = 0.5,

    icons = {{
        icon = "__base__/graphics/technology/automation-3.png",
        icon_size = 256,
        tint = util.color(defines.hexcolor.lightsteelblue.. 'd9')
    }},
    starmap_icons = {{
        icon = "__base__/graphics/technology/automation-3.png",
        icon_size = 256,
        tint = util.color(defines.hexcolor.lightsteelblue.. 'd9')
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
    produstia.parked_platforms_orientation = 0.9

    local ss_edge = data.raw['space-location']['solar-system-edge']
    local space_connection = {
        type = "space-connection",
        name = "produstia-solar-system-edge",
        subgroup = "planet-connections",
        from = "produstia",
        to = "solar-system-edge",
        order = "p",
        length = 200000,
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.aquilo_solar_system_edge),
        icons = {
            {icon = "__space-age__/graphics/icons/planet-route.png"},
            {icon = "__base__/graphics/icons/assembling-machine-3.png", icon_size = 64, scale = 0.333, shift = {-6, -6}},
            {icon = ss_edge.icon, icon_size = ss_edge.icon_size or 64, scale = 0.333 * (64 / (ss_edge.icon_size or 64)), shift = {6, 6}}
        },
    }
    data:extend({produstia, space_connection})

else
    data:extend({produstia})
end

utils.add_music(nauvis, produstia)