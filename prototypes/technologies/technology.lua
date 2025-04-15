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