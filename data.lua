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
require 'lib.utils'
require 'prototypes.scripts.loaders'

require 'prototypes.subgroup'
require 'prototypes.tiles'
require 'prototypes.planet.neo-nauvis'
require 'prototypes.planet.factory'
require 'prototypes.planet.mining'
require 'prototypes.planet.power'
require 'prototypes.teleport'
require 'prototypes.technologies.technology'
require 'prototypes.entities.radio-station'
require 'prototypes.entities.chest-pipe'
require 'prototypes.entities.power-pole'
require 'prototypes.entities.hidden-radar'
require 'prototypes.entities.factory-beacon'
require 'prototypes.buildings.loaders'


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

if mods['Krastorio2'] then
    require 'prototypes.compatibilities.krastorio2'
end
if mods['aai-loaders'] then
    require 'prototypes.compatibilities.aai-loaders'
end


-- {
--     type = "custom-input",
--     name = "factory-rotate",
--     key_sequence = "R",
--     controller_key_sequence = "controller-rightstick"
-- },