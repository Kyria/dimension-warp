local function on_research_finished(event)
    if event.research.name ~= "stabilize-dimensions" then return end

    game.set_win_ending_info{
        image_path = "__dimension-warp__/graphics/icons/technologies/dimension-warp-512.png",
        title = {"dw-messages.stabilize-dimensions-victory-title"},
        message = {"dw-messages.stabilize-dimensions-victory"},
        bullet_points = {
            {"dw-messages.stabilize-dimensions-bullet-1"},
            {"dw-messages.stabilize-dimensions-bullet-2"},
        },
        final_message = {"dw-messages.stabilize-dimensions-final"},
    }

    game.set_game_state{
        game_finished = true,
        player_won = true,
        can_continue = true,
        victorious_force = event.research.force,
    }

    -- set victory flag
    storage.victory = true
    storage.gui.planet_selector_enabled = true

    -- deactivate warp timer. 
    storage.timer.base = -1
    storage.timer.warp = -1
end

dw.register_event(defines.events.on_research_finished, on_research_finished)
