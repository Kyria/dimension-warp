local other_mod_loader = settings.startup['dw-another-mod-loader'].value and (mods['aai-loaders'] or mods['Krastorio2'])

-- add missing belts for K2
local template = {
    ['advanced-loader'] = {
        mod = "Krastorio2",
        order = 'd[a]-e',
        subgroup = 'loader',
        stack_size = 50,
        tint = util.color('#22EC17d9'),
        tint_darker = util.color('#32992cd9'),
        belt = data.raw['transport-belt']['kr-advanced-transport-belt'],
        ingredients = {
            {type = 'item', name = "dw-express-loader", amount = 1},
            {type = "item", name = "kr-rare-metals", amount = 25},
            {type = "item", name = "kr-steel-gear-wheel", amount = 25},
        },
        tech = "kr-logistic-4",
        next = "dw-superior-loader",
    },
    ['superior-loader'] = {
        mod = "Krastorio2",
        order = 'd[a]-f',
        subgroup = 'loader',
        stack_size = 50,
        tint = util.color('#D201F7d9'),
        tint_darker = util.color('#7a248ad9'),
        belt = data.raw['transport-belt']['kr-superior-transport-belt'],
        ingredients = {
            {type = 'item', name = "dw-express-loader", amount = 1},
            {type = "item", name = "kr-imersium-gear-wheel", amount = 25},
            {type = "item", name = "kr-imersium-plate", amount = 25},
        },
        tech = "kr-logistic-5",
    },
}

if dw.setting_loader_mod == "Krastorio2" then
    local loader = table.deepcopy(data.raw['loader-1x1']['kr-loader'])
    local fast_loader = table.deepcopy(data.raw['loader-1x1']['kr-fast-loader'])
    local express_loader = table.deepcopy(data.raw['loader-1x1']['kr-express-loader'])
    local adv_loader = table.deepcopy(data.raw['loader-1x1']['kr-advanced-loader'])
    local sup_loader = table.deepcopy(data.raw['loader-1x1']['kr-superior-loader'])

    loader.name = "dw-stair-loader"
    loader.localised_description = nil
    loader.energy_source = {type = "void"}
    loader.next_upgrade = nil
    loader.placeable_by = nil
    loader.heating_energy = nil
    loader.minable = nil

    fast_loader.name = "dw-stair-fast-loader"
    fast_loader.localised_description = nil
    fast_loader.energy_source = {type = "void"}
    fast_loader.next_upgrade = nil
    fast_loader.placeable_by = nil
    fast_loader.heating_energy = nil
    fast_loader.minable = nil

    express_loader.name = "dw-stair-express-loader"
    express_loader.localised_description = nil
    express_loader.energy_source = {type = "void"}
    express_loader.next_upgrade = nil
    express_loader.placeable_by = nil
    express_loader.heating_energy = nil
    express_loader.minable = nil

    adv_loader.name = "dw-stair-advanced-loader"
    adv_loader.localised_description = nil
    adv_loader.energy_source = {type = "void"}
    adv_loader.next_upgrade = nil
    adv_loader.placeable_by = nil
    adv_loader.heating_energy = nil
    adv_loader.minable = nil

    sup_loader.name = "dw-stair-superior-loader"
    sup_loader.localised_description = nil
    sup_loader.energy_source = {type = "void"}
    sup_loader.next_upgrade = nil
    sup_loader.placeable_by = nil
    sup_loader.heating_energy = nil
    sup_loader.minable = nil

    local dw_tech_fast_loader = dw.create_stair_loader_tech("dw-fast-loader", "logistics-2")
    local dw_tech_express_loader = dw.create_stair_loader_tech("dw-express-loader", "logistics-3", dw_tech_fast_loader.name)
    local dw_tech_adv_loader = dw.create_stair_loader_tech("dw-advanced-loader", "kr-logistic-4", dw_tech_express_loader.name)
    local dw_tech_sup_loader = dw.create_stair_loader_tech("dw-superior-loader", "kr-logistic-5", dw_tech_adv_loader.name)

    data.extend{
        loader,
        fast_loader,
        express_loader,
        adv_loader,
        sup_loader,
        dw_tech_fast_loader,
        dw_tech_express_loader,
        dw_tech_adv_loader,
        dw_tech_sup_loader,
    }
end

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

    data.raw['loader-1x1']['dw-express-loader'].next_upgrade = "dw-advanced-loader"
    data:extend{dw.create_stair_loader_tech('dw-advanced-loader', template['advanced-loader'].tech, "dw-express-loader-stairs")}
    data:extend{dw.create_stair_loader_tech('dw-superior-loader', template['superior-loader'].tech, "dw-advanced-loader-stairs")}
end