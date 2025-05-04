-- remove surface restriction from recipes
for _, recipe in pairs(data.raw['recipe']) do
    recipe.surface_conditions = nil
end
