--- We delete all space connections, as we don't want platform
-- Keep connections referenced by achievements to avoid ID assignment errors
local keep_connections = {
    ["solar-system-edge-shattered-planet"] = true,
}
for key in pairs(data.raw['space-connection']) do
    if not keep_connections[key] then
        data.raw['space-connection'][key] = nil
    end
end

-- Rename promethium-asteroid-chunk and move to intermediate products
local promethium_item = data.raw['item']['promethium-asteroid-chunk']
if promethium_item then
    promethium_item.localised_name = {"item-name.promethium-asteroid-chunk"}
    promethium_item.subgroup = "intermediate-product"
    promethium_item.order = "z[promethium]"
end

-- Hide space-related recipes
local recipes_to_hide = {
    "rocket-silo",
    "rocket-part",
    "cargo-landing-pad",
    "cargo-bay",
    "space-platform-foundation",
    "space-platform-starter-pack",
    "asteroid-collector",
    "crusher",
    "thruster",
    -- asteroid crushing
    "metallic-asteroid-crushing",
    "carbonic-asteroid-crushing",
    "oxide-asteroid-crushing",
    "advanced-metallic-asteroid-crushing",
    "advanced-carbonic-asteroid-crushing",
    "advanced-oxide-asteroid-crushing",
    -- asteroid reprocessing
    "metallic-asteroid-reprocessing",
    "carbonic-asteroid-reprocessing",
    "oxide-asteroid-reprocessing",
    -- thruster fuels
    "thruster-fuel",
    "thruster-oxidizer",
    "advanced-thruster-fuel",
    "advanced-thruster-oxidizer",
}

for _, name in ipairs(recipes_to_hide) do
    local recipe = data.raw['recipe'][name]
    if recipe then
        recipe.hidden = true
        recipe.hidden_in_factoriopedia = true
    end
end

-- Remove asteroid chunks (except promethium) from all visible recipe ingredients (as we cannot get them anymore)
for _, recipe in pairs(data.raw['recipe']) do
    if not recipe.hidden and recipe.ingredients then
        local filtered = {}
        for _, entry in ipairs(recipe.ingredients) do
            local item_name = entry.name or (type(entry[1]) == "string" and entry[1])
            if not (item_name and item_name ~= "promethium-asteroid-chunk" and item_name:find("asteroid%-chunk$")) then
                filtered[#filtered + 1] = entry
            end
        end
        recipe.ingredients = filtered
    end
end

