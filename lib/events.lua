dw = dw or {}
dw.events = dw.events or {}

special_events = {
    on_nth_tick = true,
    on_init = true,
    on_load = true,
    on_configuration_changed = true,
}

dw.register_event = function(event, callback, filter)
    if not dw.events[event] then
        dw.events[event] = {}
        dw.events[event].callbacks = {}

        -- add helper to trigger all callback at once
        dw.events[event].run = function(event_data)
            for _, cb in pairs(dw.events[event].callbacks) do
                cb(event_data)
            end
        end

        if not special_events[event] then
            filter = filter or nil
            script.on_event(event, dw.events[event].run, filter)
        end
    end

    for _, cb in pairs(dw.events[event].callbacks) do
        if cb == callback then return end
    end
    table.insert(dw.events[event].callbacks, callback)
end

--- remove a specific callback from event
--- technically, it would be more efficient to use [i]=nil, but
--- we won't have enough event for it to really matter...
dw.remove_event = function(event, callback)
    if not dw.events[event] then return end
    for i=#dw.events[event].callbacks, 1, -1 do
        local cb = dw.events[event].callbacks[i]
        if cb == callback then
            table.remove(dw.events[event].callbacks, i)
        end
    end
end

--- make a specific function to trigger events outside on_event
--- to be able to check if the event is actually registered
dw.fire_event = function(event, event_data)
    if dw.events[event] then
        dw.events[event].run(event_data)
    end
end

script.on_init(function(event) dw.fire_event("on_init", event) end)
script.on_load(function(event) dw.fire_event("on_load", event) end)
script.on_configuration_changed(function(event) dw.fire_event("on_configuration_changed", event) end)