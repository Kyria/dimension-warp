-- we don't want to change this if K2 / K2SO is active.
if mods['Krastorio2'] or mods['Krastorio2-spaced-out'] then return end

-- update magazine size of some vanilla ammo
data.raw.ammo['shotgun-shell'].magazine_size = 12
data.raw.ammo['piercing-shotgun-shell'].magazine_size = 12
data.raw.ammo['firearm-magazine'].magazine_size = 20
data.raw.ammo['piercing-rounds-magazine'].magazine_size = 20
data.raw.ammo['uranium-rounds-magazine'].magazine_size = 20
