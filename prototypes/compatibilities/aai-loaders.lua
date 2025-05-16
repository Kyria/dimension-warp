local other_mod_loader = settings.startup['dw-another-mod-loader'].value and (mods['aai-loaders'] or mods['Krastorio2'])

if dw.setting_loader_mod == "aai-loaders" then
    local loader = table.deepcopy(data.raw['loader-1x1']['aai-loader'])
    local fast_loader = table.deepcopy(data.raw['loader-1x1']['aai-fast-loader'])
    local express_loader = table.deepcopy(data.raw['loader-1x1']['aai-express-loader'])

    loader.name = "dw-stair-loader"
    loader.localised_description = nil
    loader.energy_source = {type = "void"}
    loader.placeable_by = nil
    loader.heating_energy = nil
    loader.next_upgrade = nil
    loader.minable = nil

    fast_loader.name = "dw-stair-fast-loader"
    fast_loader.localised_description = nil
    fast_loader.energy_source = {type = "void"}
    fast_loader.placeable_by = nil
    fast_loader.heating_energy = nil
    fast_loader.next_upgrade = nil
    fast_loader.minable = nil

    express_loader.name = "dw-stair-express-loader"
    express_loader.localised_description = nil
    express_loader.energy_source = {type = "void"}
    express_loader.placeable_by = nil
    express_loader.heating_energy = nil
    express_loader.next_upgrade = nil
    express_loader.minable = nil

    local tech = data.raw['technology']['aai-fast-loader'] and "aai-fast-loader" or "logistics-2"
    local dw_tech_fast_loader = dw.create_stair_loader_tech("dw-fast-loader", tech)

    local tech = data.raw['technology']['aai-express-loader'] and "aai-express-loader" or "logistics-3"
    local dw_tech_express_loader = dw.create_stair_loader_tech("dw-express-loader", tech, dw_tech_fast_loader.name)

    data.extend{
        loader,
        fast_loader,
        express_loader,
        dw_tech_fast_loader,
        dw_tech_express_loader,
    }

    if mods['space-age'] then
        local turbo_loader = table.deepcopy(data.raw['loader-1x1']['aai-turbo-loader'])

        turbo_loader.name = "dw-stair-turbo-loader"
        turbo_loader.localised_description = nil
        turbo_loader.energy_source = {type = "void"}
        turbo_loader.placeable_by = nil
        turbo_loader.heating_energy = nil
        turbo_loader.next_upgrade = nil
        turbo_loader.minable = nil

        local tech = data.raw['technology']['aai-turbo-loader'] and "aai-turbo-loader" or "turbo-transport-belt"
        local dw_tech_turbo_loader = dw.create_stair_loader_tech("dw-turbo-loader", tech, dw_tech_express_loader.name)

        data.extend{
            turbo_loader,
            dw_tech_turbo_loader,
        }
    end


end