--- We delete all space connections, as we don't want platform (if any)
--- to be able to go to another planet. Only platform allowed are those created by the mod.
--- definition are here https://github.com/wube/factorio-data/blob/master/space-age/prototypes/planet/planet.lua
data.raw['space-connection']['nauvis-fulgora'] = nil
data.raw['space-connection']['nauvis-gleba'] = nil
data.raw['space-connection']['nauvis-vulcanus'] = nil
data.raw['space-connection']['vulcanus-gleba'] = nil
data.raw['space-connection']['gleba-fulgora'] = nil
data.raw['space-connection']['gleba-aquilo'] = nil
data.raw['space-connection']['fulgora-aquilo'] = nil
data.raw['space-connection']['aquilo-solar-system-edge'] = nil

-- data.raw['space-location']['shattered-planet'] = nil
-- data.raw['space-location']['solar-system-edge'] = nil
-- data.raw['space-connection']['solar-system-edge-shattered-planet'] = nil
