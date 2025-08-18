--- Manage the pollution and enemies behavior
------------------------------------------------------------

--- Remove pollution from all surfaces and add it to a globally calculated value
--- then pollute the warp platform (to trigger bases & cie)
--- based on warptorio original formula, as it was already really good
local function pollute()
	if not storage.timer.active then return end
	local pollution = 0

	-- get platform pollution and clear it there
	pollution = pollution + (storage.platform.factory.surface and storage.platform.factory.surface.get_total_pollution() or 0)
	pollution = pollution + (storage.platform.mining.surface and storage.platform.mining.surface.get_total_pollution() or 0)
	pollution = pollution + (storage.platform.power.surface and storage.platform.power.surface.get_total_pollution() or 0)

	if storage.platform.factory.surface then storage.platform.factory.surface.clear_pollution() end
	if storage.platform.mining.surface then storage.platform.mining.surface.clear_pollution() end
	if storage.platform.power.surface then storage.platform.power.surface.clear_pollution() end

	--- leave a max, but if we pollute every 3 sec, it's still around 5.2h before we reach the max
	storage.pollution = math.min(1000000, storage.pollution + (storage.pollution ^ 0.25) * 0.75)

	pollution = pollution + storage.pollution * settings.global['dw-helper-pollution-multiplier'].value
	storage.warp.current.surface.pollute({-1, 0}, pollution, "radio-station")
end

--- Force enemies in a given radius to attack everything
local function force_enemy_attack()
	local force_attack_wave = settings.global['dw-helper-enemy-force-attack'].value
	if not storage.timer.active then return end
	if storage.warp.number < force_attack_wave then return end
	local time_passed = (game.tick - storage.warp.time) / 3600
	if time_passed <= 10 then return end --- at least 10min on planet
	storage.warp.current.surface.set_multi_command{
		command = {
			type = defines.command.attack_area,
			destination = {0, 0},
			radius = math.floor(storage.platform.warp.size / 2),
			distraction = defines.distraction.by_enemy
		},
		unit_count = 500,
		unit_search_distance = math.min(5000, 3000 * ((time_passed - 10) / 30))
	}
end

--- Calculate and set the new evolution value when warping depending on warp number
local function set_warp_evolution_factor()
	-- storage.warp.number / 5 only makes sure we have anincrease before the exponent starts.
	-- warp 100 = 0.25, 150 = 0.414, 200 = 0.656, 243+ = 1
	local biter_evolution = math.min(100, 1.5 ^ (storage.warp.number / 25) + storage.warp.number / 5) / 100

	-- warp 100 = 0.23, 150 = 0.358, 200 = 0.505, 250 = 0.689, 300 = 0.94, 310+ = 1
	local pentapod_evolution = math.min(100, 1.8 ^ (storage.warp.number / 50) + storage.warp.number / 5) / 100

	if storage.warp.current.planet ~= "gleba" then
		game.forces.enemy.set_evolution_factor(biter_evolution, storage.warp.current.surface)
	else
		game.forces.enemy.set_evolution_factor(pentapod_evolution, storage.warp.current.surface)
	end
end
dw.set_warp_evolution_factor = set_warp_evolution_factor

dw.register_event('on_nth_tick_180', pollute)
dw.register_event('on_nth_tick_7200', force_enemy_attack)