--- Deactivate default freeplay behaviors
------------------------------------------------------------
local function freeplay()
    if not remote.interfaces.freeplay then return end

    remote.call("freeplay", "set_skip_intro", true)
    remote.call("freeplay", "set_disable_crashsite", true)

    --- only override default win victory for space age.
    -- if remote.interfaces.silo_script  then
    --     remote.call("silo_script", "set_no_victory", true)
    -- end
    -- if remote.interfaces.space_finish_script then
    --     remote.call("space_finish_script", "set_victory_location", "nauvis")
    -- end
end

dw.register_event("on_init", freeplay)
dw.register_event("on_configuration_changed", freeplay)