local new_power_size = {
    [18] = 18,
    [24] = 27,
    [30] = 36,
    [36] = 42,
    [48] = 54,
    [54] = 66,
    [66] = 75,
    [84] = 84
}

local new_mining_size = {
    [20] = {x=20, y=16},
    [26] = {x=32, y=22},
    [34] = {x=46, y=30},
    [52] = {x=62, y=40},
    [70] = {x=80, y=48},
    [88] = {x=100, y=56},
    [110] = {x=118, y=62},
    [136] = {x=136, y=70}
}

local new_harvester_size = {
    [12] = 12,
    [16] = 18,
    [22] = 26,
    [30] = 32,
    [40] = 42,
    [52] = 52
}
local new_harvester_path_size = {
    [12] = 3,
    [16] = 4,
    [22] = 5,
    [30] = 6,
    [40] = 7,
    [52] = 8 
}

-- if the different platforms are unlocked, update them to get the new size.
if storage.platform.mining.surface then
    if new_mining_size[storage.platform.mining.size.x] then
        storage.platform.mining.size = new_mining_size[storage.platform.mining.size.x]
    end
    dw.platforms.init_update_mining_platform()
end

if storage.platform.power.surface then
    if new_power_size[storage.platform.power.size] then
        storage.platform.power.size = new_power_size[storage.platform.power.size]
    end
    dw.platforms.init_update_power_platform()
end

if storage.harvesters.left.gate then
    if new_harvester_size[storage.harvesters.left.size] then
        dw.platforms.recall_harvester("left")
        storage.harvesters.left.border = new_harvester_path_size[storage.harvesters.left.size]
        storage.harvesters.left.size = new_harvester_size[storage.harvesters.left.size]
        dw.platforms.create_harvester_zone("left")
    end
end

if storage.harvesters.right.gate then
    if new_harvester_size[storage.harvesters.right.size] then
        dw.platforms.recall_harvester("right")
        storage.harvesters.right.border = new_harvester_path_size[storage.harvesters.right.size]
        storage.harvesters.right.size = new_harvester_size[storage.harvesters.right.size]
        dw.platforms.create_harvester_zone("right")
    end
end