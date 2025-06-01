if not settings.startup['dw-adjust-spoilage'].value or not mods['space-age'] then
    return
end

-- raw gleba recieve large buff (x4: 4h)
data.raw.capsule["yumako"].spoil_ticks = 4 * 3600 * 60
data.raw.capsule["jellynut"].spoil_ticks = 4 * 3600 * 60

-- bioflux recieve smaller buff (x2: 4h)
data.raw.capsule["bioflux"].spoil_ticks = 4 * 3600 * 60

-- nutrients last for 20min
data.raw.item["nutrients"].spoil_ticks = 20 * 60 * 60

-- eggs are given a bit more time.
-- But this also a debuff, as this mean you may store lots of them ...
data.raw.item["biter-egg"].spoil_ticks = 1 * 3600 * 60
data.raw.item["pentapod-egg"].spoil_ticks = 30 * 60 * 60

-- agricultural science pack has no more spoilage, considering the difficulty related to gleba / the mod
data.raw.tool["agricultural-science-pack"].spoil_ticks = 0
data.raw.tool["agricultural-science-pack"].spoil_result = nil