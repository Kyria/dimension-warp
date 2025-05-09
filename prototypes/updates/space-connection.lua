--- We delete all space connections, as we don't want platform (if any)
--- to be able to go to another planet. Only platform allowed are those created by the mod.
--- definition are here https://github.com/wube/factorio-data/blob/master/space-age/prototypes/planet/planet.lua
for key, val in pairs(data.raw['space-connection']) do
    if key == "produstia-solar-system-edge" then goto continue end
    if key == "solar-system-edge-shattered-planet" then goto continue end
        data.raw['space-connection'][key] = nil
    ::continue::
end


-- data.raw['space-location']['shattered-planet'] = nil
-- data.raw['space-location']['solar-system-edge'] = nil
-- data.raw['space-connection']['solar-system-edge-shattered-planet'] = nil
