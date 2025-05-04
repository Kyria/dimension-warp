local tech_neonauvis = {
    type = "technology",
    name = "neo-nauvis",
    icons = {{
        icon = data.raw["planet"]["nauvis"].icon,
        tint = defines.color.royalblue
    }},
    visible_when_disabled = false,
    research_trigger = { type = "build-entity", entity = "simple-teleport" },
    effects = {{ type = "unlock-space-location", space_location = "neo-nauvis" }},
}


data.extend({tech_neonauvis})

require 'warp-platform'
require 'warp-generator'

if mods['space-age'] then
    require 'space-age.warp-platform-fix'
    require 'space-age.warp-generator-fix'
end