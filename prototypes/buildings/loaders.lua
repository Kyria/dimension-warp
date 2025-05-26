local template = {
    ['loader'] =  {
        order = 'd[a]-b',
        subgroup = 'loader',
        stack_size = 50,
        tint = util.color('#ffc340d9'),
        tint_darker = util.color('#9e7928d9'),
        belt = data.raw['transport-belt']['transport-belt'],
        ingredients = {
            {type = "item", name = "transport-belt", amount = 4},
            {type = "item", name = "iron-plate", amount = 25},
            {type = "item", name = "electronic-circuit", amount = 25}
        },
        tech = 'logistics',
        next = "dw-fast-loader",
    },

    ['fast-loader'] = {
        order = 'd[a]-c',
        subgroup = 'loader',
        stack_size = 50,
        tint = util.color('#e31717d9'),
        tint_darker = util.color('#8a1919d9'),
        belt = data.raw['transport-belt']['fast-transport-belt'],
        ingredients = {
            {type = 'item', name = "dw-loader", amount = 1},
            {type = "item", name = "iron-gear-wheel", amount = 50},
            {type = "item", name = "electronic-circuit", amount = 50}
        },
        tech = 'logistics-2',
        next = "dw-express-loader",
    },

    ['express-loader'] = {
        order = 'd[a]-d',
        subgroup = 'loader',
        stack_size = 50,
        tint = util.color('#43c0fad9'),
        tint_darker = util.color('#3a7c9cd9'),
        belt = data.raw['transport-belt']['express-transport-belt'],
        ingredients = {
            {type = 'item', name = "dw-fast-loader", amount = 1},
            {type = "item", name = "iron-gear-wheel", amount = 50},
            {type = "item", name = "advanced-circuit", amount = 50},
            {type = "fluid", name = "lubricant", amount = 100}
        },
        tech = 'logistics-3',
        next = mods['space-age'] and "dw-turbo-loader" or "",
    },

    ['turbo-loader'] = {
        mod = "space-age",
        order = 'd[a]-e',
        subgroup = 'loader',
        stack_size = 50,
        tint = util.color('#A8D550d9'),
        tint_darker = util.color('#678c1fd9'),
        belt = data.raw['transport-belt']['turbo-transport-belt'],
        ingredients = {
            {type = 'item', name = "dw-express-loader", amount = 1},
            {type = "item", name = "tungsten-plate", amount = 75},
            {type = "item", name = "processing-unit", amount = 10},
            {type = "fluid", name = "lubricant", amount = 160}
        },
        tech = 'turbo-transport-belt',
    },

}

if dw.setting_loader_mod == "vanilla" then
    local data_list = {}
    for loader_name, params in pairs(template) do
        if params.mod and not mods[params.mod] then goto continue end

        local loader, recipe, item = dw.create_loader(loader_name, params)
        local dim_loader = table.deepcopy(loader)
        dim_loader.name = "dw-stair-" .. dim_loader.name:gsub('dw%-', '')
        dim_loader.energy_source = {type = "void"}
        dim_loader.icons[2].tint = params.tint_darker
        dim_loader.structure = dw.loaders_generate_structure(params.tint_darker)
        dim_loader.fast_replaceable_group = "stair-loader"
        dim_loader.placeable_by = nil
        dim_loader.next_upgrade = nil
        dim_loader.minable = nil

        table.insert(data_list, loader)
        table.insert(data_list, dim_loader)
        table.insert(data_list, recipe)
        table.insert(data_list, item)

        ::continue::
    end
    data:extend(data_list)
    data:extend{dw.create_stair_loader_tech('fast-loader', template['fast-loader'].tech)}
    data:extend{dw.create_stair_loader_tech('express-loader', template['express-loader'].tech, "dw-fast-loader-stairs")}
    if mods['space-age'] then
        data:extend{dw.create_stair_loader_tech('turbo-loader', template['turbo-loader'].tech, "dw-express-loader-stairs")}
    end
end
