require 'prototypes.updates.stack-size'
require 'prototypes.updates.spoilage'
require 'prototypes.updates.adjust-restrictions'
require 'prototypes.updates.pipes'
require 'prototypes.updates.ammo'

if mods['space-age'] then
    require 'prototypes.updates.space-connection'
    require 'prototypes.updates.space-costs'
end

if mods['Krastorio2'] or mods['Krastorio2-spaced-out'] then
    require 'prototypes.compatibilities.updates.krastorio2'
end