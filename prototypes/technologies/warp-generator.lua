local function generate_icon(overlay_icon, tint)
    return {
        {icon = "__base__/graphics/icons/starmap-planet-nauvis.png", icon_size = 512, tint = util.color(defines.hexcolor.royalblue.. 'd9')},
        {icon = overlay_icon, tint = tint, scale = 1, shift = {30, 30}, floating = true}
    }
end

local tech_warp_generator_1 = { -- 20min
    type = "technology", name = "warp-generator-1",
    icons = generate_icon(data.raw["virtual-signal"]["signal-sun"].icon, util.color(defines.hexcolor.gold.. 'd9')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator"} }},
    prerequisites = {"neo-nauvis", "automation-science-pack"},
    research_trigger = {
        type = "craft-item",
        item = "automation-science-pack",
        count = 25,
    }
}
local tech_warp_generator_2 = { -- 30min
    type = "technology", name = "warp-generator-2",
    icons = generate_icon(data.raw["virtual-signal"]["signal-speed"].icon, util.color(defines.hexcolor.darkgoldenrod.. 'd9')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-1", "radar"},
    unit = {
        count = 250,
        ingredients = {
            {"automation-science-pack", 1},
        },
        time = 30,
    },
}

local tech_warp_generator_3 = { -- 40min
    type = "technology", name = "warp-generator-3",
    icons = generate_icon(data.raw["virtual-signal"]["signal-speed"].icon, util.color(defines.hexcolor.darkgoldenrod.. 'd9')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-2", "military-2"},
    unit = {
        count = 500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
        },
        time = 30,
    },
}

local tech_warp_generator_4 = { -- 50min
    type = "technology", name = "warp-generator-4",
    icons = generate_icon(data.raw["virtual-signal"]["signal-speed"].icon, util.color(defines.hexcolor.yellowgreen.. 'd9')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-3", "military-3", "advanced-oil-processing"},
    unit = {
        count = 1000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack", 3},
            {"chemical-science-pack", 2},
        },
        time = 30,
    },
}

local tech_warp_generator_5 = { -- 60min
    type = "technology", name = "warp-generator-5",
    icons = generate_icon(data.raw["virtual-signal"]["signal-speed"].icon, util.color(defines.hexcolor.yellowgreen.. 'd9')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-4", "effect-transmission", "military-4"},
    unit = {
        count = 2500,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack", 3},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 2},
            {"production-science-pack", 2},
        },
        time = 30,
    },
}

local tech_warp_generator_6 = { -- unlimited time, except aquilo
    type = "technology", name = "warp-generator-6",
    icons = generate_icon(data.raw["virtual-signal"]["signal-speed"].icon, util.color(defines.hexcolor.lawngreen.. 'd9')),
    effects = {{ type = "nothing", effect_description = {"technology-description.warp-generator-efficiency"} }},
    prerequisites = {"warp-generator-5"},
    unit = {
        count = 5000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack", 3},
            {"chemical-science-pack", 1},
            {"utility-science-pack", 2},
            {"production-science-pack", 2},
        },
        time = 30,
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