local adjust_cost = settings.startup['dw-adjust-space-cost'].value
if not adjust_cost then return end

local function multiply_ingredients(recipe, multi)
    for _, ingredient in pairs(recipe.ingredients) do
        ingredient.amount = ingredient.amount * multi
    end
end

multiply_ingredients(data.raw.recipe["space-platform-foundation"], 5)
multiply_ingredients(data.raw.recipe["space-platform-starter-pack"], 5)
multiply_ingredients(data.raw.recipe["cargo-bay"], 2)
multiply_ingredients(data.raw.recipe["asteroid-collector"], 2)
multiply_ingredients(data.raw.recipe["crusher"], 2)
multiply_ingredients(data.raw.recipe["thruster"], 2)
multiply_ingredients(data.raw.recipe["rocket-part"], 10)