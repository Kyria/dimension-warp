local nauvis = data.raw["planet"]["nauvis"]
local neo_nauvis = table.deepcopy(nauvis)

neo_nauvis.name = "neo-nauvis"
neo_nauvis.order = "a[neo-nauvis]"
neo_nauvis.type = "planet"
neo_nauvis.draw_orbit = false
neo_nauvis.hidden = true
neo_nauvis.distance = 30
neo_nauvis.orientation = 0.46

neo_nauvis.icons = {{
    icon = nauvis.icon,
    tint = defines.color.royalblue
}}
neo_nauvis.starmap_icons = {{
    icon = nauvis.starmap_icon,
    icon_size = 512,
    tint = defines.color.royalblue
}}

if mods['space-age'] then
    local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

    neo_nauvis.subgroup = "planets"
    neo_nauvis.asteroid_spawn_influence = 1
    neo_nauvis.asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_vulcanus, 0.1)
end

data:extend({neo_nauvis})
utils.add_music(nauvis, neo_nauvis)