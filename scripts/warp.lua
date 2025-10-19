--- warp between surface and timers are managed in this file
------------------------------------------------------------
dw.warp = dw.warp or {}

local function calculate_manual_warp_time()
    local base_time = 10 --seconds
    local max_time = settings.global['dw-manual-warp-max-time'].value * 60
    local warp_zone = math.floor(storage.warp.number * settings.global['dw-manual-warp-zone-multiplier'].value)

    return math.min(max_time, base_time + warp_zone ^ 1.35)
end

-- return if we should ignore the planet for warp selection
local function ignore_planet(planet)
    -- ignore nauvis
    if planet == "nauvis" then return true end
    -- ignore specials surface frm the mod
    if dw.safe_surfaces[planet] then return true end
    if planet:match('.*%-factory%-floor') or planet:match('factory%s-travel%s-surface') then return true end
    return false
end

local function get_allowed_planet()
    local force = game.forces['player']
    local allowed_planets = {}
    local total = 0
    local current = storage.warp.current.surface
    local current_require_heat = current.planet.prototype.entities_require_heating
    for _, planet in pairs(game.planets) do
        -- remove nauvis, dimension surfaces from the list
        if not ignore_planet(planet.name) then
            if force.is_space_location_unlocked(planet.name) then
                if current_require_heat and planet.name == current.planet.name then
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
    return destinations[math.random(total_dest)]
end

local function prepare_warp_to_next_surface()
    if storage.warp.status ~= defines.warp.awaiting then return end
    storage.warp.status = defines.warp.preparing

    local target = select_destination() --- dw select random surface
    dw.generate_surface(target)

    storage.warp.status = defines.warp.warping
    dw.teleport_platform()
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

        if (storage.timer.warp < 60 and storage.timer.warp > 0) or storage.timer.manual_warp < 10 then
            if game.tick % (3 * 60) == 0 then
                game.play_sound{path = "dw-alarm"}
            end
        end

        if storage.timer.warp == 0 or storage.timer.manual_warp == 0 then
            -- return warp gate
            if storage.warpgate.mobile_gate then
                storage.warpgate.mobile_gate.destroy{raise_destroy=true}
            end
            -- harvesters recall
            dw.platforms.recall_harvester("left")
            dw.platforms.recall_harvester("right")

            -- generate new surface and teleport
            prepare_warp_to_next_surface()
            -- play sound
            game.play_sound{path = "dw-warpdrive"}
            if storage.warp.message then game.print({storage.warp.message}) end
            storage.warp.message = nil

            -- reset all timers / globals
            storage.timer.warp = storage.timer.base
            storage.timer.manual_warp = calculate_manual_warp_time()
            storage.warp.time = game.tick

            -- reset warp votes
            storage.votes.count = 0
            storage.votes.players = {}

            -- reset evolution based on warp number
            dw.set_warp_evolution_factor()
            storage.pollution = 1
            dw.gui.update_manual_warp_button()

            -- once everything's done, force recreate the tiles in platforms (because some explosions may break some.)
            dw.update_warp_platform_size()
            if storage.platform.factory.surface then dw.platforms.init_update_factory_platform() end
            if storage.harvesters.left.gate then dw.platforms.place_harvester_tiles("left") end
            if storage.harvesters.right.gate then dw.platforms.place_harvester_tiles("right") end
            if storage.platform.mining.surface then dw.platforms.init_update_mining_platform() end
            if storage.platform.power.surface then dw.platforms.init_update_power_platform() end
        end

    end

    --- each seconds, we update the GUI
    dw.gui.update()
end
dw.warp.warp_timer = warp_timer


local function update_warp_vote_threshold()
    local new_vote_threshold = math.max(1, math.ceil(storage.votes.players_count * settings.global['dw-min-warp-voter'].value))
    --- reset warp votes if the threshold changed
    if storage.votes.min_vote ~= new_vote_threshold then
        storage.votes.min_vote = new_vote_threshold
        storage.votes.count = 0
        storage.votes.players = {}
        dw.gui.update_manual_warp_button()
    end
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
        else
            storage.timer.base = storage.timer.base + 30 * 60
        end
        if not storage.timer.warp then
            storage.timer.warp = storage.timer.base
        end
        dw.gui.update_manual_warp_button()
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