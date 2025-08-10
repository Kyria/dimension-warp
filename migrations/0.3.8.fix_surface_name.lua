-- fix the surface name, just in case the user is already on a bugging surface.
if storage.warp.current.name ~= storage.warp.current.surface.name then
    storage.warp.current.name = storage.warp.current.surface.name
end