data:extend({
  {
    type = "technology",
    name = "stabilize-dimensions",
    icons = {
      {
        icon = "__dimension-warp__/graphics/icons/technologies/dimension-warp-512.png",
        icon_size = 512,
        tint = util.color('#aaaaaa77'),
      },
      {
        icon = "__base__/graphics/icons/starmap-planet-nauvis.png",
        icon_size = 512,
        scale = 0.2,
        shift = {20, 28},
        floating = true,
      },
    },
    localised_name = {"technology-name.stabilize-dimensions"},
    localised_description = {"technology-description.stabilize-dimensions"},
    effects = {
      {type = "unlock-space-location", space_location = "nauvis", use_icon_overlay_constant = true},
    },
    prerequisites = {"warp-generator-6", "space-science-pack"},
    unit = {
      count = 10000,
      ingredients = {
        {"automation-science-pack",  1},
        {"logistic-science-pack",    1},
        {"military-science-pack",    1},
        {"chemical-science-pack",    1},
        {"production-science-pack",  1},
        {"utility-science-pack",     1},
        {"space-science-pack",       1},
      },
      time = 60,
    },
  },
})
