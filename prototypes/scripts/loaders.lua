require 'circuit-connector-generated-definitions'
require 'circuit-connector-sprites'
local hit_effects = require "__base__.prototypes.entity.hit-effects"
local sounds = require "__base__.prototypes.entity.sounds"

local loader_connector_definitions = circuit_connector_definitions.create_vector(
    universal_connector_template,
    {
        { variation = 26, main_offset = util.by_pixel(1, 11),  shadow_offset = util.by_pixel(1, 12), show_shadow = true },  -- North
        { variation = 24, main_offset = util.by_pixel(-15, 0), shadow_offset = { 0, 0 }, },                                 -- East
        { variation = 24, main_offset = util.by_pixel(-17, 0), shadow_offset = { 0, 0 }, },                                 -- South
        { variation = 31, main_offset = util.by_pixel(15, 0),  shadow_offset = { 0, 0 }, },                                 -- West

        { variation = 31, main_offset = util.by_pixel(17, 0),  shadow_offset = { 0, 0 }, },                                 -- South
        { variation = 31, main_offset = util.by_pixel(15, 0),  shadow_offset = { 0, 0 }, },                                 -- West
        { variation = 30, main_offset = util.by_pixel(0, 11),  shadow_offset = util.by_pixel(0, 12), show_shadow = true, }, -- North
        { variation = 24, main_offset = util.by_pixel(-15, 0), shadow_offset = { 0, 0 }, },                                 -- East
    }
)

dw.loaders_generate_structure = function(tint)
    return {
        direction_in = {
            sheets = {
                -- Base
                {
                    filename = "__dimension-warp__/graphics/entities/miniloader/miniloader-structure-base.png",
                    height = 192,
                    priority = 'extra-high',
                    scale = 0.5,
                    width = 192,
                    y = 0,
                },
                -- Mask
                {
                    filename = "__dimension-warp__/graphics/entities/miniloader/miniloader-structure-mask.png",
                    height = 192,
                    priority = 'extra-high',
                    scale = 0.5,
                    width = 192,
                    y = 0,
                    tint = tint,
                },
                -- Shadow
                {
                    filename = "__dimension-warp__/graphics/entities/miniloader/miniloader-structure-shadow.png",
                    draw_as_shadow = true,
                    height = 192,
                    priority = 'extra-high',
                    scale = 0.5,
                    width = 192,
                    y = 0,
                }
            }
        },
        direction_out = {
            sheets = {
                -- Base
                {
                    filename = "__dimension-warp__/graphics/entities/miniloader/miniloader-structure-base.png",
                    height = 192,
                    priority = 'extra-high',
                    scale = 0.5,
                    width = 192,
                    y = 192,
                },
                -- Mask
                {
                    filename = "__dimension-warp__/graphics/entities/miniloader/miniloader-structure-mask.png",
                    height = 192,
                    priority = 'extra-high',
                    scale = 0.5,
                    width = 192,
                    y = 192,
                    tint = tint,
                },
                -- Shadow
                {
                    filename = "__dimension-warp__/graphics/entities/miniloader/miniloader-structure-shadow.png",
                    height = 192,
                    priority = 'extra-high',
                    scale = 0.5,
                    width = 192,
                    y = 192,
                    draw_as_shadow = true,
                }
            }
        },
        back_patch = {
            sheet = {
                filename = "__dimension-warp__/graphics/entities/miniloader/miniloader-structure-back-patch.png",
                priority = 'extra-high',
                width = 192,
                height = 192,
                scale = 0.5,
            }
        },
        front_patch = {
            sheet = {
                filename = "__dimension-warp__/graphics/entities/miniloader/miniloader-structure-front-patch.png",
                priority = 'extra-high',
                width = 192,
                height = 192,
                scale = 0.5,
            }
        }
    }
end


dw.create_loader = function (loader_name, params)
    loader_name = 'dw-' .. loader_name

    local loader = {
        -- Prototype Base
        name = loader_name,
        type = "loader-1x1",
        order = params.order,
        subgroup = params.subgroup,

        -- LoaderPrototype
        structure = dw.loaders_generate_structure(params.tint),
        structure_render_layer = 'object',

        container_distance = 1,
        allow_rail_interaction = true,
        allow_container_interaction = true,
        per_lane_filters = false,
        filter_count = 5,
        energy_source = {type = "electric", usage_priority = "secondary-input", drain = "2kW"},
        energy_per_item = "4kJ",

        circuit_wire_max_distance = default_circuit_wire_max_distance,
        circuit_connector = loader_connector_definitions,

        open_sound = sounds.transport_belt_open,
        close_sound = sounds.transport_belt_close,

        working_sound = {
            sound = {filename = "__base__/sound/underground-belt.ogg", volume = 0.2, audible_distance_modifier = 0.5},
            max_sounds_per_prototype = 2,
            persistent = true,
            use_doppler_shift = false
        },

        max_health = params.belt.max_health,
        belt_animation_set = table.deepcopy(params.belt.belt_animation_set),
        animation_speed_coefficient = 32,
        speed = params.belt.speed,

        -- EntityPrototype
        icons = {
            {
                icon = "__dimension-warp__/graphics/icons/miniloader/icon-base.png",
                icon_size = 64,
            },
            {
                icon = "__dimension-warp__/graphics/icons/miniloader/icon-mask.png",
                icon_size = 64,
                tint = params.tint,
            },
        },

        collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
        collision_mask = { layers = { water_tile = true, floor = true, transport_belt = true, object = true, meltable = true} },
        selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
        flags = {"placeable-player", "placeable-neutral", "player-creation"},

        minable = { mining_time = 0.1, result = loader_name },
        placeable_by = { item = loader_name, count = 1 },
        next_upgrade = params.next,

        integration_patch_render_layer = "decals",
        integration_patch = {
            north = util.empty_sprite(),
            east = util.empty_sprite(),
            south = util.empty_sprite(),
            west = util.empty_sprite(),
        },
        corpse = "small-remnants",
        dying_explosion = "underground-belt-explosion",
        resistances = params.belt.resistances,
        damaged_trigger_effect = hit_effects.entity(),
        fast_replaceable_group = "loader",
    }

    if mods['space-age'] then
        loader.adjustable_belt_stack_size = true
        loader.max_belt_stack_size = 4
    end

    local recipe = {
        type = 'recipe',
        name = loader_name,
        category = "advanced-crafting",
        localised_name = loader_name,
        ingredients = params.ingredients,
        enabled = false,
        results = {
            {
                type = 'item',
                name = loader_name,
                amount = 1,
            },
        },
    }

    local item = {
        type = 'item',
        name = loader_name,
        localised_name = loader_name,
        order = params.order,
        subgroup = params.subgroup,

        stack_size = params.stack_size,
        weight = 1000 / params.stack_size * kg,
        icons = {
            {
                icon = "__dimension-warp__/graphics/icons/miniloader/icon-base.png",
                icon_size = 64,
            },
            {
                icon = "__dimension-warp__/graphics/icons/miniloader/icon-mask.png",
                icon_size = 64,
                tint = params.tint,
            },
        },

        place_result = loader_name,
    }

    local technology = data.raw.technology[params.tech]
    if not technology then goto tech_next_step end
    table.insert(technology.effects, { type = "unlock-recipe", recipe = loader_name })
    ::tech_next_step::

    return loader, recipe, item
end

dw.create_stair_loader_tech = function(loader, unlock_tech, previous_level)
    if not data.raw['technology'][unlock_tech] then return end

    local icons = nil
    if data.raw['technology'][unlock_tech].icons then
        icons = table.deepcopy(data.raw['technology'][unlock_tech].icons)
        util.recursive_tint(icons, defines.color.royalblue)
        table.insert(icons, {
            icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
            icon_size = 128,
            scale = 0.5,
            shift = {50, 50},
            floating = true
        })
    else
        icons = {
            {
                icon = data.raw['technology'][unlock_tech].icon,
                icon_size = data.raw['technology'][unlock_tech].icon_size,
                tint = defines.color.royalblue
            },
            {
                icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
                icon_size = 128,
                scale = 0.5,
                shift = {50, 50},
                floating = true
            }
        }
    end

    local prerequisites = {unlock_tech}
    if previous_level then table.insert(prerequisites, previous_level) end

    local technology = {
        type = 'technology',
        name = 'dw-' .. loader .. "-stairs",
        icons = icons,
        prerequisites = prerequisites,
        unit = data.raw['technology'][unlock_tech].unit,
        visible_when_disabled = false,
    }

    return technology
end