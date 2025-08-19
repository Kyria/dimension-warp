data:extend{
    {
        type = "shortcut",
        name = "harvester-left-shortcut",
        action = "lua",
        icons = {
            {
                icon = "__base__/graphics/icons/lab.png",
                icon_size = 64,
                icon_mipmaps = 4,
                tint = util.color(defines.hexcolor.chocolate .. 'cc'),
            },
            {
                icon = "__base__/graphics/icons/arrows/left-arrow.png",
                icon_size = 64,
                icon_mipmaps = 4,
                scale = 0.4,
                shift = {-16, 0}
            }
        },
        small_icons = {
            {
                icon = "__base__/graphics/icons/lab.png",
                icon_size = 64,
                icon_mipmaps = 4,
                tint = util.color(defines.hexcolor.chocolate .. 'cc'),
            },
            {
                icon = "__base__/graphics/icons/arrows/left-arrow.png",
                icon_size = 64,
                icon_mipmaps = 4,
                scale = 0.4,
                shift = {-16, 0}
            }
        },
        technology_to_unlock = "dimension-harvester-left-1",
        unavailable_until_unlocked = true,
        order = "d[dimension]-a[harvester-left]",
        style = "blue",
    },
    {
        type = "shortcut",
        name = "harvester-right-shortcut",
        action = "lua",
        icons = {
            {
                icon = "__base__/graphics/icons/lab.png",
                icon_size = 64,
                icon_mipmaps = 4,
                tint = util.color(defines.hexcolor.chocolate .. 'cc'),
            },
            {
                icon = "__base__/graphics/icons/arrows/right-arrow.png",
                icon_size = 64,
                icon_mipmaps = 4,
                scale = 0.4,
                shift = {16, 0}
            }
        },
        small_icons = {
            {
                icon = "__base__/graphics/icons/lab.png",
                icon_size = 64,
                icon_mipmaps = 4,
                tint = util.color(defines.hexcolor.chocolate .. 'cc'),
            },
            {
                icon = "__base__/graphics/icons/arrows/right-arrow.png",
                icon_size = 64,
                icon_mipmaps = 4,
                scale = 0.4,
                shift = {16, 0}
            }
        },
        technology_to_unlock = "dimension-harvester-right-1",
        unavailable_until_unlocked = true,
        order = "d[dimension]-c[harvester-right]",
        style = "blue",
    },
    {
        type = "shortcut",
        name = "warp-gate-shortcut",
        action = "lua",
        icons = {
            {
                icon = "__base__/graphics/icons/lab.png",
                icon_size = 64,
                icon_mipmaps = 4,
                tint = util.color(defines.hexcolor.royalblue .. 'd9')
            }
        },
        small_icons = {
            {
                icon = "__base__/graphics/icons/lab.png",
                icon_size = 64,
                icon_mipmaps = 4,
                tint = util.color(defines.hexcolor.royalblue .. 'd9')
            }
        },
        technology_to_unlock = "dw-warp-gate-1",
        unavailable_until_unlocked = true,
        order = "d[dimension]-b[warpgate]",
        style = "blue",
    },
}