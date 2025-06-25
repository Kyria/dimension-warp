
-- fix mining productivity in space age
data.raw['technology']['dimension-mining-productivity-21'] = nil

local mining_prod = data.raw['technology']['dimension-mining-productivity-16']
mining_prod.max_level = 25
mining_prod.prerequisites = {"mining-productivity-3", "dimension-mining-productivity-11"}
mining_prod.unit.count_formula = "1000+500*(L-15)"
