data:extend{
    {
        type = "technology",
        name = "platform-radar",
        icons = {
            {
                icon = "__base__/graphics/technology/radar.png",
                icon_size = 256,
                tint = util.color(defines.hexcolor.royalblue.. 'd9'),
            }
        },
        prerequisites = {
            "electrified-ground",
            "concrete",
            "radar"
        },
        unit = {
            count = 200,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
            },
            time = 30,
        },
    }
}