if not mods['space-age'] then return end

local dimension_crane_yumako = table.deepcopy(data.raw['agricultural-tower']['agricultural-tower'])
dimension_crane_yumako.name = "dimension-crane-yumako"
dimension_crane_yumako.radius = 5 -- 121 squares, vs 48 for normal
dimension_crane_yumako.energy_source.emissions_per_minute.spores = dimension_crane_yumako.energy_source.emissions_per_minute.spores * 3
dimension_crane_yumako.minable = {mining_time = 2, result = "dimension-crane-yumako", count = 1}
dimension_crane_yumako.accepted_seeds = {"yumako-seed"}
util.recursive_tint(dimension_crane_yumako, util.color(defines.hexcolor.coral .. '77'))
dimension_crane_yumako.icon = nil
dimension_crane_yumako.icons = {
    {
        icon = "__space-age__/graphics/icons/agricultural-tower.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = util.color(defines.hexcolor.coral .. 'ff'),
    },
    {
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        icon_mipmaps = 4,
        scale = 0.3,
        shift = {10, 10},
        tint = util.color(defines.hexcolor.lightblue .. 'ff')
    },
}

local dimension_crane_jellynut = table.deepcopy(dimension_crane_yumako)
dimension_crane_jellynut.name = "dimension-crane-jellynut"
dimension_crane_jellynut.accepted_seeds = {"jellynut-seed"}
util.recursive_tint(dimension_crane_jellynut, util.color(defines.hexcolor.olive .. '77'))
dimension_crane_jellynut.icons = {
    {
        icon = "__space-age__/graphics/icons/agricultural-tower.png",
        icon_size = 64,
        icon_mipmaps = 4,
        tint = util.color(defines.hexcolor.olive .. 'ff'),
    },
    {
        icon = "__base__/graphics/icons/lab.png",
        icon_size = 64,
        icon_mipmaps = 4,
        scale = 0.3,
        shift = {10, 10},
        tint = util.color(defines.hexcolor.lightblue .. 'ff')
    },
}
dimension_crane_jellynut.minable = {mining_time = 2, result = "dimension-crane-jellynut", count = 1}

local dimension_crane_yumako_item = {
    type = 'item',
    name = "dimension-crane-yumako",
    subgroup = "agriculture",
    stack_size = 20,
    weight = 50 * kg,
    icons = dimension_crane_yumako.icons,
    place_result = "dimension-crane-yumako",
}
local dimension_crane_jellynut_item = {
    type = 'item',
    name = "dimension-crane-jellynut",
    subgroup = "agriculture",
    stack_size = 20,
    weight = 50 * kg,
    icons = dimension_crane_jellynut.icons,
    place_result = "dimension-crane-jellynut",
}


local dimension_crane_yumako_recipe = {
    type = "recipe",
    category = "organic",
    subgroup = "agriculture",
    name = "dimension-crane-yumako",
    order = "a[dimension-crane]-b[yumako]",
    icons = dimension_crane_yumako.icons,
    ingredients = {
        {type = "item", name = "agricultural-tower", amount = 10},
        {type = "item", name = "yumako-seed", amount = 100},
        {type = "item", name = "jellynut-seed", amount = 100},
        {type = "item", name = "pentapod-egg", amount = 10},
        {type = "item", name = "carbon-fiber", amount = 5},
    },
    results = {{type = "item", name = "dimension-crane-yumako", amount = 1}},
    energy_required = 10,
    enabled = false,
}

local dimension_crane_jellynut_recipe = {
    type = "recipe",
    category = "organic",
    subgroup = "agriculture",
    name = "dimension-crane-jellynut",
    order = "a[dimension-crane]-b[jellynut]",
    icons = dimension_crane_jellynut.icons,
    ingredients = {
        {type = "item", name = "agricultural-tower", amount = 10},
        {type = "item", name = "yumako-seed", amount = 100},
        {type = "item", name = "jellynut-seed", amount = 100},
        {type = "item", name = "pentapod-egg", amount = 10},
        {type = "item", name = "carbon-fiber", amount = 5},
    },
    results = {{type = "item", name = "dimension-crane-jellynut", amount = 1}},
    energy_required = 10,
    enabled = false,
}

local jellynut_to_yumako_crane = {
    type = "recipe",
    category = "organic-or-hand-crafting",
    subgroup = "agriculture",
    name = "dimension-crane-jellynut-to-yumako",
    order = "a[dimension-crane]-b[jellynut]-c[yumako]",
    icons = {
        {
            icon = "__space-age__/graphics/icons/agricultural-tower.png",
            icon_size = 64,
            icon_mipmaps = 4,
            tint = util.color(defines.hexcolor.olive .. 'ff'),
            shift = {-10,-10}
        },
        {
            icon = "__space-age__/graphics/icons/agricultural-tower.png",
            icon_size = 64,
            icon_mipmaps = 4,
            tint = util.color(defines.hexcolor.coral .. 'ff'),
            shift = {10,10}
        }
    },
    ingredients = {{type = "item", name = "dimension-crane-jellynut", amount = 1}},
    results = {{type = "item", name = "dimension-crane-yumako", amount = 1}},
    energy_required = 10,
    enabled = false,
}
local yumako_to_jellynut_crane = {
    type = "recipe",
    category = "organic-or-hand-crafting",
    subgroup = "agriculture",
    name = "dimension-crane-yumako-to-jellynut",
    order = "a[dimension-crane]-b[yumako]-c[jellynut]",
    icons = {
        {
            icon = "__space-age__/graphics/icons/agricultural-tower.png",
            icon_size = 64,
            icon_mipmaps = 4,
            tint = util.color(defines.hexcolor.coral .. 'ff'),
            shift = {-10,-10}
        },
        {
            icon = "__space-age__/graphics/icons/agricultural-tower.png",
            icon_size = 64,
            icon_mipmaps = 4,
            tint = util.color(defines.hexcolor.olive .. 'ff'),
            shift = {10,10}
        }
    },
    ingredients = {{type = "item", name = "dimension-crane-yumako", amount = 1}},
    results = {{type = "item", name = "dimension-crane-jellynut", amount = 1}},
    energy_required = 10,
    enabled = false,
}

local tech = {
    type = "technology",
    name = "dimension-crane",
    icons = {
        {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
        {
            icon = "__space-age__/graphics/technology/agriculture.png",
            icon_size = 256,
            icon_mipmaps = 4,
            tint = util.color(defines.hexcolor.coral .. 'ff'),
            shift = {-40,-40}
        },
        {
            icon = "__space-age__/graphics/technology/agriculture.png",
            icon_size = 256,
            icon_mipmaps = 4,
            tint = util.color(defines.hexcolor.olive .. 'ff'),
            shift = {40,40}
        }
    },
    prerequisites= {"carbon-fiber"},
    unit = {
        count = 1000,
        time = 60,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"space-science-pack", 1},
            {"agricultural-science-pack", 1},
        }
    },
    effects = {
        {type = "unlock-recipe", recipe = "dimension-crane-yumako"},
        {type = "unlock-recipe", recipe = "dimension-crane-jellynut"},
        {type = "unlock-recipe", recipe = "dimension-crane-jellynut-to-yumako"},
        {type = "unlock-recipe", recipe = "dimension-crane-yumako-to-jellynut"},
        {type = "nothing", effect_description = {"technology-description.dimension-crane-chest"}}
    }
}

data:extend{
    dimension_crane_yumako,
    dimension_crane_yumako_item,
    dimension_crane_yumako_recipe,
    dimension_crane_jellynut,
    dimension_crane_jellynut_item,
    dimension_crane_jellynut_recipe,
    yumako_to_jellynut_crane,
    jellynut_to_yumako_crane,
    tech
}