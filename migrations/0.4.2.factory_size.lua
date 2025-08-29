local new_factory_size = {
    [20] = 20,
    [28] = 36, -- +8
    [38] = 56, -- +18
    [60] = 76, -- +16
    [80] = 98, -- +18
    [98] = 118, -- +20
    [122] = 136, -- +14
    [152] = 152
}

-- if the factory is unlocked, update it to get the new size.
if storage.platform.factory.surface then
    if new_factory_size[storage.platform.factory.size] then
        storage.platform.factory.size = new_factory_size[storage.platform.factory.size]
    end
    dw.platforms.init_update_factory_platform()
end