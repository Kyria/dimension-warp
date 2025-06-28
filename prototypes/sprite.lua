data:extend({
    {
        type = "sprite",
        name = "warp-toggle-icon",
        priority = "extra-high-no-scale",
        layers = {
            {
                filename = "__base__/graphics/icons/nauvis.png",
                tint = util.color(defines.hexcolor.royalblue.. 'd9'),
                width = 64,
                height = 64,
            },
            {
                filename = "__base__/graphics/icons/info.png",
                width = 64,
                height = 64,
                scale = 0.5,
                shift = {10,10},
                tint = util.color(defines.hexcolor.lightsteelblue.. 'd9'),
            },
        },
        flags = {"gui-icon"},
    },
})
