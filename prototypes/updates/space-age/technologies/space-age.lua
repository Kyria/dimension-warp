local tech = data.raw['technology']['space-science-pack']
if tech then
    tech.effects = tech.effects or {}
    table.insert(tech.effects, {type = "unlock-recipe", recipe = "water-refrigeration"})
    table.insert(tech.effects, {type = "unlock-recipe", recipe = "steam-condensation"})
    table.insert(tech.effects, {type = "unlock-recipe", recipe = "carbon"})
end

-- Hide space-related technologies no longer needed
local techs_to_hide = {
    "rocket-silo",
    "space-platform",
    "space-platform-thruster",
    "asteroid-reprocessing",
    "advanced-asteroid-processing",
    "asteroid-productivity",
}
for _, name in ipairs(techs_to_hide) do
    data.raw['technology'][name].hidden = true
    data.raw['technology'][name].hidden_in_factoriopedia = true
end

-- space-science-pack inherits rocket-silo's prerequisites
data.raw['technology']['space-science-pack'].prerequisites = table.deepcopy(data.raw['technology']['rocket-silo'].prerequisites)
data.raw['technology']['space-science-pack'].research_trigger = nil
data.raw['technology']['space-science-pack'].unit = table.deepcopy(data.raw['technology']['rocket-silo'].unit)

-- Replace hidden asteroid techs prerequisites with their own prerequisites in all techs
local function replace_prereq(techs, old_name)
    local old_prereqs = table.deepcopy(data.raw['technology'][old_name].prerequisites or {})
    for _, tech in pairs(techs) do
        if tech.prerequisites then
            local found = false
            for i = #tech.prerequisites, 1, -1 do
                if tech.prerequisites[i] == old_name then
                    table.remove(tech.prerequisites, i)
                    found = true
                end
            end
            if found then
                for _, prereq in ipairs(old_prereqs) do
                    table.insert(tech.prerequisites, prereq)
                end
            end
        end
    end
end

replace_prereq(data.raw['technology'], "space-platform-thruster")
replace_prereq(data.raw['technology'], "asteroid-reprocessing")
replace_prereq(data.raw['technology'], "advanced-asteroid-processing")

-- Add our recipes to the promethium science effects
local promethium = data.raw['technology']['promethium-science-pack']
if promethium then
    promethium.effects = promethium.effects or {}
    table.insert(promethium.effects, {type = "unlock-recipe", recipe = "dw-promethium"})
end
