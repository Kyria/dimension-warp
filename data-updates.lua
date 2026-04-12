require 'prototypes.updates.stack-size'
require 'prototypes.updates.spoilage'
require 'prototypes.updates.adjust-restrictions'
require 'prototypes.updates.pipes'
require 'prototypes.updates.ammo'

if mods['space-age'] then
    require 'prototypes.updates.space-age.aquilo'
    require 'prototypes.updates.space-age.space-connection'
    require 'prototypes.updates.space-age.space-costs'
    require 'prototypes.updates.space-age.tesla'
end
