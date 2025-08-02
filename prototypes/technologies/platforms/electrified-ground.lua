data:extend{
    {
        type = "technology",
        name = "electrified-ground",
        icons = {
            {
                icon = "__base__/graphics/technology/electric-energy-distribution-2.png",
                icon_size = 256,
                tint = util.color(defines.hexcolor.royalblue.. 'd9'),
            }
        },
        prerequisites = {
            "electric-energy-distribution-1",
            "power-platform"
        },
        unit = {
            count = 100,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
            },
            time = 15,
        },
    }
}