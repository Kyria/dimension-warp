require 'lib.defines'
require 'lib.utils'

require 'prototypes.tiles'
require 'prototypes.planet.neo-nauvis'
require 'prototypes.teleport'
require 'prototypes.technologies.technology'
require 'prototypes.entities.radio-station'

data:extend({
    {
        type = "sprite",
        name = "warp-toggle-icon",
        priority = "extra-high-no-scale",
        layers = {
            {
                filename = data.raw["planet"]["nauvis"].icon,
                tint = defines.color.royalblue,
                width = 64,
                height = 64,
                scale = 0.5
            },
            {
                filename = "__base__/graphics/icons/info.png",
                width = 64,
                height = 64,
                scale = 0.2,
                shift = {10,10},
                tint = defines.color.lightsteelblue,
            },
        },
        flags = {"gui-icon"},
    }
})


-- {
--     type = "custom-input",
--     name = "factory-rotate",
--     key_sequence = "R",
--     controller_key_sequence = "controller-rightstick"
-- },