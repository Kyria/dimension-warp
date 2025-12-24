local function generate_icon(overlay_icon, tint)
    return {
        {icon = "__dimension-warp__/graphics/icons/technologies/dimension-warp-512.png", tint = util.color('#aaaaaa77'), icon_size = 512},
        {
            icon = "__core__/graphics/icons/technology/constants/" .. overlay_icon,
            icon_size = 128,
            scale = 0.75,
            shift = {50, 45},
            floating = true,
            tint = tint
        }
    }
end

local tech_warp_generator_1 = { -- 20min
    type = "technology", name = "warp-generator-1",
    icons = generate_icon("constant-battery.png", nil), --util.color(defines.hexcolor.gold.. 'ff')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator"} }},
    prerequisites = {"neo-nauvis", "automation-science-pack"},
    research_trigger = {
        type = "craft-item",
        item = "automation-science-pack",
        count = 100,
    }
}
local tech_warp_generator_2 = { -- 30min
    type = "technology", name = "warp-generator-2",
    icons = generate_icon("constant-speed.png", util.color(defines.hexcolor.darkgoldenrod.. 'ff')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-1", "radar"},
    unit = {
        count = 100,
        ingredients = {
            {"automation-science-pack", 1},
        },
        time = 15,
    },
}

local tech_warp_generator_3 = { -- 40min
    type = "technology", name = "warp-generator-3",
    icons = generate_icon("constant-speed.png", util.color(defines.hexcolor.darkgoldenrod.. 'ff')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-2", "military-2"},
    unit = {
        count = 250,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 15,
    },
}

local tech_warp_generator_4 = { -- 50min
    type = "technology", name = "warp-generator-4",
    icons = generate_icon("constant-speed.png", util.color(defines.hexcolor.yellowgreen.. 'ff')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-3", "military-3", "advanced-oil-processing"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack", 2},
            {"chemical-science-pack", 2},
        },
        time = 15,
    },
}

local tech_warp_generator_5 = { -- 60min
    type = "technology", name = "warp-generator-5",
    icons = generate_icon("constant-speed.png", util.color(defines.hexcolor.yellowgreen.. 'ff')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-4", "production-science-pack"},
    unit = {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack", 2},
            {"chemical-science-pack", 1},
            {"production-science-pack", 2},
        },
        time = 15,
    },
}

local tech_warp_generator_6 = { -- +30 min (90min)
    type = "technology", name = "warp-generator-6",
    icons = generate_icon("constant-speed.png", util.color(defines.hexcolor.lawngreen.. 'ff')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-5", "effect-transmission", "military-4"},
    unit = {
        count = 2500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack", 2},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 2},
            {"production-science-pack", 2},
        },
        time = 15,
    },
}

--- next levels will unlock other features


data:extend({
    tech_warp_generator_1,
    tech_warp_generator_2,
    tech_warp_generator_3,
    tech_warp_generator_4,
    tech_warp_generator_5,
    tech_warp_generator_6,
})