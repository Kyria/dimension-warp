if not mods['space-age'] then return end

data:extend({
  {
    type = "recipe",
    name = "water-refrigeration",
    category = "chemistry-or-cryogenics",
    subgroup = "fluid-recipes",
    order = "d[other-chemistry]-c[water-refrigeration]",
    localised_name = {"recipe-name.water-refrigeration"},
    icons = {
      {
        icon = "__space-age__/graphics/icons/ice.png",
        icon_size = 64,
        icon_mipmaps = 4,
      },
      {
        icon = "__base__/graphics/icons/fluid/water.png",
        icon_size = 64,
        icon_mipmaps = 4,
        scale = 0.5,
        shift = {-16, 16},
      },
    },
    crafting_machine_tint = {
      primary = util.color("03b1fcff"),
    },
    energy_required = 60,
    allow_productivity = false,
    ingredients = {
      {type = "fluid", name = "water", amount = 1000},
    },
    results = {
      {type = "item",  name = "ice",   amount = 20},
      {type = "fluid", name = "water", amount = 220},
      {type = "fluid", name = "steam", amount = 2000, temperature = 165},
    },
    enabled = false,
  },
  {
    type = "recipe",
    name = "dw-promethium",
    category = "metallurgy",
    subgroup = "uranium-processing",
    order = "p[promethium]",
    icons = {
      {
        icon = "__space-age__/graphics/icons/promethium-asteroid-chunk.png",
        icon_size = 64,
      },
    },
    energy_required = 10,
    allow_productivity = false,
    ingredients = {
      {type = "item", name = "uranium-ore",      amount = 100},
      {type = "item", name = "refined-concrete", amount = 200},
      {type = "item", name = "scrap",            amount = 200},
      {type = "item", name = "tungsten-plate",   amount = 100},
    },
    results = {
      {type = "item", name = "promethium-asteroid-chunk", amount = 10},
      {type = "item", name = "uranium-238",               amount = 5},
    },
    enabled = false,
  },
})

if mods['Krastorio2'] or mods['Krastorio2-spaced-out'] then
  table.insert(data.raw.recipe['dw-promethium'].ingredients, {type = "item", name = "kr-rare-metals", amount = 150})
end
