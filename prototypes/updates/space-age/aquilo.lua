
-- adjust the clumped and broken formation by changing the constant at the beginning of each expressions
data.raw["noise-expression"]["aquilo_elevation"].local_expressions.formation_clumped = "-13\z
                          + 12 * max(aquilo_island_peaks, random_island_peaks)\z
                          + 15 * tri_crack"
data.raw["noise-expression"]["aquilo_elevation"].local_expressions.formation_broken  = "-4\z
                          + 8 * max(aquilo_island_peaks * 1.1, min(0., random_island_peaks - 0.2))\z
                          + 13 * (pow(voronoi_large * max(0, voronoi_large_cell * 1.2 - 0.2) + 0.5 * voronoi_small * max(0, aux + 0.1), 0.5))"

-- adjust the blended expression to have different elevation, just like nauvis lake
data.raw["noise-expression"]["aquilo_elevation"].local_expressions.min_formation = "min(formation_clumped, formation_broken)"
data.raw["noise-expression"]["aquilo_elevation"].local_expressions.blended = "lerp(min_formation, elevation_lakes, 0.5)"

-- and mix both expressions to have both "nauvis like" terrain, while still having these icebergs and islands
data.raw["noise-expression"]["aquilo_elevation"].expression = "lerp(blended, maxed, 0.6)"

-- increase brash_ice occurence
data.raw["noise-expression"]["brash_ice"].expression = "0.05 * (elevation / 5 -aux / 3 + 1.25)"

-- make brash ice walkable and change the pollution tint
data.raw.tile["brash-ice"].collision_mask.layers.player = nil
data.raw.tile["brash-ice"].walking_speed_modifier = 0.4
data.raw.tile["brash-ice"].effect_color_secondary = nil

-- adjust lithium icebergs occurence
data.raw["simple-entity"]["lithium-iceberg-huge"].autoplace.probability_expression = "(aquilo_high_frequency_peaks - 1.5) * 0.02"
data.raw["simple-entity"]["lithium-iceberg-big"].autoplace.probability_expression = "(aquilo_high_frequency_peaks - 1) * 0.05"

-- Force biters on aquilo.
data.raw.planet.aquilo.map_gen_settings.autoplace_controls["enemy-base"] = {richness=1, frequency=1, size=1}