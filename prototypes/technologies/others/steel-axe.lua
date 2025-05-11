data:extend {
    {
        type = "technology",
        name = "dimension-steel-axe",
        icons = {
            {
                icon = "__base__/graphics/technology/steel-axe.png",
                icon_size = 256,
                tint = defines.color.royalblue
            }
        },
        prerequisites = {"steel-axe"},
        research_trigger = {
            type = "craft-item",
            item = "steel-plate",
            count = 2000
        },
        effects = {
            {
                type = "character-mining-speed",
                modifier = 2
            }
        },
    }
}