--- warp between surface and timers are managed in this file
------------------------------------------------------------

local function calculate_manual_warp_time()
    local base_time = 10 --seconds
    local max_time = settings.global['dw-manual-warp-max-time'].value * 60
    local warp_zone = math.floor(storage.warp.number * settings.global['dw-manual-warp-zone-multiplier'].value)
    local warp_multi = math.floor((1 + (math.min(100, storage.warp.number)) / 5) ^ (2 + (math.min(100, storage.warp.number) / 40)))

    return math.min(max_time, base_time + warp_zone + warp_multi)
end


local function warp_timer()
    if not storage.nauvis_lab_exploded then return end

    if storage.timer.active then
        if storage.timer.warp >= 0 then
            storage.timer.warp = storage.timer.warp - 1
        end

        if storage.votes.count >= storage.votes.min_vote then
            storage.timer.manual_warp = storage.timer.manual_warp - 1
        else
            storage.timer.manual_warp = math.max(10, storage.timer.manual_warp - 1)
        end

        if storage.timer.warp < 60 then
            --- play some sounds
        end

        if storage.timer.warp == 0 or storage.timer.manual_warp == 0 then
            -- return warp gate
            storage.warpgate.mobile_gate.destroy{raise_destroy=true}
            -- returters

            -- generate new surface and teleport
            dw.prepare_warp_to_next_surface()

            -- reset all timers / globals
            storage.timer.warp = storage.timer.base
            storage.timer.manual_warp = calculate_manual_warp_time()
            storage.warp.time = game.tick
            --- reset warp votes
            storage.votes.count = 0
            storage.votes.players = {}
            --- reset evolution based on warp number
            game.forces.enemy.set_evolution_factor(math.min(100, 1.8 ^ (storage.warp.number / 20) + math.log(storage.warp.number, 10) * 5) / 100, storage.warp.current.surface)
            storage.pollution = storage.warp.number * math.min(10, 10 ^ (storage.warp.number / 100))
            dw.update_manual_warp_button()
        end

    end

    --- each seconds, we update the GUI
    dw.update_gui()
end


local function update_warp_vote_threshold()
    local new_vote_threshold = math.max(1, math.ceil(storage.votes.players_count * settings.global['dw-min-warp-voter'].value))
    --- reset warp votes if the threshold changed
    if storage.votes.min_vote ~= new_vote_threshold then
        storage.votes.min_vote = new_vote_threshold
        storage.votes.count = 0
        storage.votes.players = {}
        dw.update_manual_warp_button()
    end
end


-- return if we should ignore the planet for warp selection
local function ignore_planet(planet)
    -- ignore nauvis
    if planet == "nauvis" then return true end
    -- ignore specials surface frm the mod
    if dw.safe_surfaces[planet] then return true end
    return false
end


local function get_allowed_planet()
    local force = game.forces['player']
    local allowed_planets = {}
    local total = 0
    local current = storage.warp.current.surface
    local current_require_heat = current.planet.prototype.entities_require_heating
    for _, planet in pairs(game.planets) do
        -- remove nauvis, dimensions surface anmo surfaces from the list
        if not ignore_planet(planet.name) then
            if force.is_space_location_unlocked(planet.name) then
                if current_require_heat and planet.name == current.name then
                    goto continue
                end
                table.insert(allowed_planets, planet.name)
                total = total + 1

                ::continue::
            end
        end
    end
    return total, allowed_planets
end


local function select_destination()
    local total_dest, destinations = get_allowed_planet()
    if storage.allowed_warp_selection and math.random() > 0.7 then
        --- warp to selected
    else
        return destinations[math.random(total_dest)]
    end
end


dw.prepare_warp_to_next_surface = function()
    if storage.warp.status ~= defines.warp.awaiting then return end
    storage.warp.status = defines.warp.preparing

    local target = select_destination() --- dw select random surface
    dw.generate_surface(target)

    storage.warp.status = defines.warp.warping
    dw.teleport_platform()
end


local function warp_generator_research(event)
    local tech = event.research
    if string.match(tech.name, "warp%-generator%-1") then
        storage.timer.active = true
        storage.timer.manual_warp = calculate_manual_warp_time()
        game.print({"dw-messages.warp-generator-1"})
    end
    if string.match(tech.name, "warp%-generator%-%d+") then
        if tech.level < 6 then
            storage.timer.base =  (20 + (tech.level - 1)  * 10) * 60
            if not storage.timer.warp then
                storage.timer.warp = storage.timer.base
            end
        else
            storage.timer.base = -1
            storage.timer.warp = -1
        end
        dw.update_manual_warp_button()
    end
end


local function update_warp_vote_join(event)
    storage.votes.players_count = storage.votes.players_count + 1
    update_warp_vote_threshold()
end


local function update_warp_vote_leave(event)
    storage.votes.players_count = storage.votes.players_count - 1
    update_warp_vote_threshold()
end


dw.register_event('on_nth_tick_60', warp_timer)
dw.register_event(defines.events.on_research_finished, warp_generator_research)
dw.register_event(defines.events.on_player_joined_game, update_warp_vote_join)
dw.register_event(defines.events.on_player_left_game, update_warp_vote_leave)
dw.register_event(defines.events.on_player_kicked, update_warp_vote_leave)