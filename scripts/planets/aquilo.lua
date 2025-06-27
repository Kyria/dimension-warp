dw.mapgen = dw.mapgen or {}
dw.mapgen.aquilo = dw.mapgen.aquilo or {}


local function aquilo_randomizer(mapgen, surface_name)
    mapgen.seed = math.random(2^16) + game.tick

    local surface = game.planets.aquilo.create_surface()
    storage.warp.randomizer = "Normal"
    storage.warp.message = "dw-randomizer.aquilo-normal"

    --- we also force the timer for these planet
    storage.timer.warp = (storage.timer.base > 0) and math.min(storage.timer.base, 30 * 60) or (30 * 60)

    return surface
end

dw.mapgen.aquilo.randomizer = aquilo_randomizer