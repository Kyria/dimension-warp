dw = dw or {}

-- has value true if we want to use another loader mod AND the selected mod in the setings is the right one
dw.setting_loader_mod =
    settings.startup['dw-another-mod-loader'].value and (
        mods['aai-loaders'] and (
            mods['Krastorio2'] and settings.startup['dw-another-mod-loader-select'].value == "Krastorio2"
                and "Krastorio2"
            or "aai-loaders"
        )
        or mods['Krastorio2'] and (
            mods['aai-loaders'] and settings.startup['dw-another-mod-loader-select'].value == "aai-loaders"
                and "aai-loaders"
            or "Krastorio2"
        )
    )
    or "vanilla"



require 'lib.defines'
require 'lib.constants'
require 'lib.utils'
require 'prototypes.scripts.loaders'

require 'prototypes.sounds'
require 'prototypes.subgroup'
require 'prototypes.tiles'
require 'prototypes.resource'
require 'prototypes.planet.neo-nauvis'
require 'prototypes.planet.factory'
require 'prototypes.planet.mining'
require 'prototypes.planet.power'
require 'prototypes.buildings.agricultural-tower'
require 'prototypes.buildings.loaders'
require 'prototypes.technologies.technology'
require 'prototypes.entities.radio-station'
require 'prototypes.entities.chest-pipe'
require 'prototypes.entities.power-pole'
require 'prototypes.entities.hidden-radar'
require 'prototypes.entities.factory-beacon'
require 'prototypes.entities.warp-gate'
require 'prototypes.entities.harvesters'
require 'prototypes.entities.harvesters-linked-belt'


data:extend({
    {
        type = "sprite",
        name = "warp-toggle-icon",
        priority = "extra-high-no-scale",
        layers = {
            {
                filename = "__base__/graphics/icons/nauvis.png",
                tint = util.color(defines.hexcolor.royalblue.. 'd9'),
                width = 64,
                height = 64,
            },
            {
                filename = "__base__/graphics/icons/info.png",
                width = 64,
                height = 64,
                scale = 0.5,
                shift = {10,10},
                tint = util.color(defines.hexcolor.lightsteelblue.. 'd9'),
            },
        },
        flags = {"gui-icon"},
    },
    {
        type = "sprite",
        name = "warp-actions-toggle-icon",
        priority = "extra-high-no-scale",
        layers = {
            {
                filename = "__base__/graphics/icons/nauvis.png",
                tint = util.color(defines.hexcolor.royalblue.. 'd9'),
                width = 64,
                height = 64,
            },
            {
                filename = "__core__/graphics/icons/tooltips/tooltip-category-debug.png",
                width = 40,
                height = 40,
                scale = 0.75,
                shift = {10,10},
                tint = util.color(defines.hexcolor.lightsteelblue),
            },
        },
        flags = {"gui-icon"},
    }
})

if mods['Krastorio2'] then
    require 'prototypes.compatibilities.krastorio2'
end
if mods['aai-loaders'] then
    require 'prototypes.compatibilities.aai-loaders'
end
