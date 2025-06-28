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
require 'prototypes.sprite'
require 'prototypes.tiles'
require 'prototypes.resource'
require 'prototypes.enemies'
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


if mods['Krastorio2'] then
    require 'prototypes.compatibilities.krastorio2'
end
if mods['aai-loaders'] then
    require 'prototypes.compatibilities.aai-loaders'
end
