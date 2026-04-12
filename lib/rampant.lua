dw.rampant = dw.rampant or {}

dw.rampant.constants = dw.rampant.constants or {}
dw.rampant.constants.AI_STATE_PEACEFUL = 1
dw.rampant.constants.AI_STATE_AGGRESSIVE = 2
dw.rampant.constants.AI_STATE_RAIDING = 4
dw.rampant.constants.AI_STATE_MIGRATING = 5
dw.rampant.constants.AI_STATE_SIEGE = 6
dw.rampant.constants.AI_STATE_ONSLAUGHT = 7
dw.rampant.constants.AI_STATE_GROWING = 8

dw.rampant.constants.AI_STATE_ENGLISH = {}
dw.rampant.constants.AI_STATE_ENGLISH[dw.rampant.constants.AI_STATE_PEACEFUL] = "AI_STATE_PEACEFUL"
dw.rampant.constants.AI_STATE_ENGLISH[dw.rampant.constants.AI_STATE_AGGRESSIVE] = "AI_STATE_AGGRESSIVE"
dw.rampant.constants.AI_STATE_ENGLISH[dw.rampant.constants.AI_STATE_RAIDING] = "AI_STATE_RAIDING"
dw.rampant.constants.AI_STATE_ENGLISH[dw.rampant.constants.AI_STATE_MIGRATING] = "AI_STATE_MIGRATING"
dw.rampant.constants.AI_STATE_ENGLISH[dw.rampant.constants.AI_STATE_SIEGE] = "AI_STATE_SIEGE"
dw.rampant.constants.AI_STATE_ENGLISH[dw.rampant.constants.AI_STATE_ONSLAUGHT] = "AI_STATE_ONSLAUGHT"
dw.rampant.constants.AI_STATE_ENGLISH[dw.rampant.constants.AI_STATE_GROWING] = "AI_STATE_GROWING"

dw.rampant.active = script.active_mods['RampantFixed'] or false

dw.rampant.get_ai_state = function(surface)
    if not dw.rampant.active then return end
    return remote.call("rampantFixed", "getAI_state", {surfaceIndex = surface.index})
end
dw.rampant.set_ai_state = function(surface, state)
    if not dw.rampant.active then return end
    return remote.call("rampantFixed", "setAI_state_ExtCtrl", {surfaceIndex = surface.index, state = state})
end

dw.rampant.check_surface_processed = function(surface)
    if not dw.rampant.active then return true end
    local state = dw.rampant.get_ai_state(surface)
    if state == nil then
        game.print({"dw-warning.rampant-surface-not-active", surface.name})
        return false
    end
    return true
end
