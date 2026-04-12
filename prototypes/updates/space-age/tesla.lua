-- Only nerf tesla turret if RampantFixed is not present.
-- Update consumption for tesla turret. Result is a longer cooldown but keep the damage.
-- Before: 7MW input, 12MJ per shot (1.7s cooldown)
-- After: 6MW input, 36MJ per shot (6s cooldown)
if mods['RampantFixed'] then return end
local tesla_turret = data.raw["electric-turret"]["tesla-turret"]
tesla_turret.attack_parameters.ammo_type.energy_consumption = "36MJ"
tesla_turret.energy_source.buffer_capacity = "54MJ"
tesla_turret.energy_source.input_flow_limit = "6MW"