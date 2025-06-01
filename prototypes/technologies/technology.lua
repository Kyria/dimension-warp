local tech_neonauvis = {
    type = "technology",
    name = "neo-nauvis",
    icons = {{
        icon = "__base__/graphics/icons/starmap-planet-nauvis.png",
        tint = util.color(defines.hexcolor.royalblue.. 'd9'),
        icon_size = 512,
    }},
    visible_when_disabled = false,
    research_trigger = { type = "build-entity", entity = "warp-gate" },
    effects = {{ type = "unlock-space-location", space_location = "neo-nauvis" }},
}


data:extend{tech_neonauvis}

require 'warp-generator'
require 'platforms.warp'
require 'platforms.factory'
require 'platforms.harvester'
require 'platforms.mining'
require 'platforms.energy'
require 'platforms.electrified-ground'

require 'others.steel-axe'
require 'others.inventory'
require 'others.inserter'
require 'others.damage'
require 'others.drones'
require 'others.mining'

require 'entities.radar'
require 'entities.stairs'
require 'entities.beacon'
require 'entities.warp-gate'

-- specific changes for tech if space-age is active.
if mods['space-age'] then
    require 'space-age.warp-generator'
    require 'space-age.others.damage'
    require 'space-age.others.mining'
    require 'space-age.others.stairs'
    require 'space-age.entities.beacon'
    require 'space-age.entities.warp-gate'
    require 'space-age.platforms.warp'
    require 'space-age.platforms.factory'
    require 'space-age.platforms.mining'
    require 'space-age.platforms.energy'
    require 'space-age.platforms.harvester'
end