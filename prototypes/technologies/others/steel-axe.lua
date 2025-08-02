data:extend {
    {
        type = "technology",
        name = "dimension-steel-axe",
        icons = {
            {
                icon = "__base__/graphics/technology/steel-axe.png",
                icon_size = 256,
                tint = util.color(defines.hexcolor.royalblue.. 'd9')
            }
        },
        prerequisites = {"steel-axe"},
        research_trigger = {
            type = "craft-item",
            item = "steel-plate",
            count = 1000
        },
        effects = {
            {
                type = "character-mining-speed",
                modifier = 3
            }
        },
    }
}