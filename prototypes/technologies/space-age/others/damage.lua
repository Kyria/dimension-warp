--- tesla damage
---
local icons = {
    {
        icon = "__space-age__/graphics/technology/electric-weapons-damage.png",
        icon_size = 256,
        tint = util.color(defines.hexcolor.royalblue.. 'd9')
    },
    {
        icon = "__core__/graphics/icons/technology/constants/constant-damage.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}
data:extend {
    {
        type = "technology",
        name = "dimension-tesla-weapons-damage-1",
        icons = icons,
        effects = {
            {
                type = "ammo-damage",
                ammo_category = "tesla",
                modifier = 0.5
            },
        },
        prerequisites = {"electric-weapons-damage-3",  "tesla-weapons"},
        unit = {
            count = 500,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"military-science-pack", 1},
                {"utility-science-pack", 1},
                {"space-science-pack", 1},
                {"electromagnetic-science-pack", 1}
            },
            time = 30
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "dimension-tesla-weapons-damage-2",
        icons = icons,
        effects = {
            {
                type = "ammo-damage",
                ammo_category = "tesla",
                modifier = 0.5
            },
        },
        prerequisites = {"dimension-tesla-weapons-damage-1"},
        unit = {
            count = 1000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"military-science-pack", 2},
                {"utility-science-pack", 1},
                {"space-science-pack", 1},
                {"electromagnetic-science-pack", 1}
            },
            time = 30
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "dimension-tesla-weapons-damage-3",
        icons = icons,
        effects = {
            {
                type = "ammo-damage",
                ammo_category = "tesla",
                modifier = 0.7
            },
        },
        prerequisites = {"dimension-tesla-weapons-damage-2"},
        unit = {
            count = 2000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"chemical-science-pack", 1},
                {"military-science-pack", 2},
                {"utility-science-pack", 1},
                {"space-science-pack", 1},
                {"electromagnetic-science-pack", 1}
            },
            time = 30
        },
        upgrade = true
    },
}