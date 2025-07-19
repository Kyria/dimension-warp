local logistic_chests = {
    data.raw['logistic-container']['dw-logistic-input'],
    data.raw['logistic-container']['dw-logistic-output'],
}
local yumako_chest = {
    data.raw['logistic-container']['dw-crane-yumako-seed-input'],
    data.raw['logistic-container']['dw-crane-yumako-output'],
}
local jelly_chest = {
    data.raw['logistic-container']['dw-crane-jellynut-seed-input'],
    data.raw['logistic-container']['dw-crane-jellynut-output'],
}

for _, chest in pairs(logistic_chests) do
    for _, layer in pairs(chest.animation.layers) do
        if layer.tint then
            local color = util.multiply_color(layer.tint, 0.55)
            layer.tint = {r=color[1], g=color[2], b=color[3], a=(color[1] > 1 and 220 or 0.85)}
        end
    end
end

for _, chest in pairs(jelly_chest) do
    for _, layer in pairs(chest.animation.layers) do
        if layer.tint then
            local color = util.multiply_color(layer.tint, 0.55)
            layer.tint = {r=color[1], g=color[2], b=color[3], a=(color[1] > 1 and 255*0.5 or 0.5)}
        end
    end
    chest.animation.layers[1].tint = util.color(defines.hexcolor.olive.. 'd9')
    chest.animation.layers[2].tint = util.color(defines.hexcolor.olive.. 'd9')
end

for _, chest in pairs(yumako_chest) do
    for _, layer in pairs(chest.animation.layers) do
        if layer.tint then
            local color = util.multiply_color(layer.tint, 0.55)
            layer.tint = {r=color[1], g=color[2], b=color[3], a=(color[1] > 1 and 255*0.5 or 0.5)}
        end
    end
    chest.animation.layers[1].tint = util.color(defines.hexcolor.coral.. 'd9')
    chest.animation.layers[2].tint = util.color(defines.hexcolor.coral.. 'd9')
end