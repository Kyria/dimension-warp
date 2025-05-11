--- physical
---
local icons = {
    {
        icon = "__base__/graphics/technology/physical-projectile-damage-1.png",
        icon_size = 256,
        tint = defines.color.royalblue
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
        name = "dimension-physical-projectile-damage-1",
        icons = icons,
        effects = {
            {
                type = "ammo-damage",
                ammo_category = "bullet",
                modifier = 0.15
            },
            {
                type = "turret-attack",
                turret_id = "gun-turret",
                modifier = 0.15
            },
            {
                type = "ammo-damage",
                ammo_category = "shotgun-shell",
                modifier = 0.15
            }
        },
        prerequisites = {"military", "physical-projectile-damage-1"},
        unit = {
            count = 500,
            ingredients = {
                {"automation-science-pack", 2}
            },
            time = 30
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "dimension-physical-projectile-damage-2",
        icons = icons,
        effects = {
            {
                type = "ammo-damage",
                ammo_category = "bullet",
                modifier = 0.15
            },
            {
                type = "turret-attack",
                turret_id = "gun-turret",
                modifier = 0.15
            },
            {
                type = "ammo-damage",
                ammo_category = "shotgun-shell",
                modifier = 0.15
            }
        },
        prerequisites = {"physical-projectile-damage-2", "dimension-physical-projectile-damage-1", "logistic-science-pack"},
        unit = {
            count = 1000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 2}
            },
            time = 30
        },
        upgrade = true
    },
    {
        type = "technology",
        name = "dimension-physical-projectile-damage-3",
        icons = icons,
        effects =
        {
        {
            type = "ammo-damage",
            ammo_category = "bullet",
            modifier = 0.25
        },
        {
            type = "turret-attack",
            turret_id = "gun-turret",
            modifier = 0.25
        },
        {
            type = "ammo-damage",
            ammo_category = "shotgun-shell",
            modifier = 0.25
        }
        },
        prerequisites = {"physical-projectile-damage-3", "dimension-physical-projectile-damage-2", "military-science-pack"},
        unit = {
            count = 2000,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"military-science-pack", 2}
            },
            time = 60
        },
        upgrade = true
    },
}

