local capacity_icon = {
    {
        icon = "__base__/graphics/technology/worker-robots-storage.png",
        icon_size = 256,
        tint = util.color(defines.hexcolor.royalblue.. 'd9'),
    },
    {
        icon = "__core__/graphics/icons/technology/constants/constant-capacity.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}

local speed_icon = {
    {
        icon = "__base__/graphics/technology/worker-robots-speed.png",
        icon_size = 256,
        tint = util.color(defines.hexcolor.royalblue.. 'd9'),
    },
    {
        icon = "__core__/graphics/icons/technology/constants/constant-movement-speed.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50},
        floating = true
    }
}

local speed_1 = table.deepcopy(data.raw['technology']['worker-robots-speed-1'])
local speed_2 = table.deepcopy(data.raw['technology']['worker-robots-speed-2'])
local speed_3 = table.deepcopy(data.raw['technology']['worker-robots-speed-3'])
local speed_4 = table.deepcopy(data.raw['technology']['worker-robots-speed-4'])
local speed_5 = table.deepcopy(data.raw['technology']['worker-robots-speed-5'])

local capacity_1 = table.deepcopy(data.raw['technology']['worker-robots-storage-1'])
local capacity_2 = table.deepcopy(data.raw['technology']['worker-robots-storage-2'])
local capacity_3 = table.deepcopy(data.raw['technology']['worker-robots-storage-3'])


speed_1.name = "dimension-worker-robots-speed-1"
speed_1.type = "technology"
speed_1.icon = nil
speed_1.icon_size = nil
speed_1.icons = speed_icon
speed_1.unit.count = speed_1.unit.count * 2
speed_1.prerequisites = {"worker-robots-speed-1"}

speed_2.name = "dimension-worker-robots-speed-2"
speed_2.icon = nil
speed_2.icon_size = nil
speed_2.icons = speed_icon
speed_2.unit.count = speed_2.unit.count * 2
speed_2.prerequisites = {"worker-robots-speed-2", "dimension-worker-robots-speed-1"}

speed_3.name = "dimension-worker-robots-speed-3"
speed_3.icon = nil
speed_3.icon_size = nil
speed_3.icons = speed_icon
speed_3.unit.count = speed_3.unit.count * 1.5
speed_3.prerequisites = {"worker-robots-speed-3", "dimension-worker-robots-speed-2"}

speed_4.name = "dimension-worker-robots-speed-4"
speed_4.icon = nil
speed_4.icon_size = nil
speed_4.icons = speed_icon
speed_4.unit.count = speed_4.unit.count * 1.5
speed_4.prerequisites = {"worker-robots-speed-4", "dimension-worker-robots-speed-3"}

speed_5.name = "dimension-worker-robots-speed-5"
speed_5.icon = nil
speed_5.icon_size = nil
speed_5.icons = speed_icon
speed_5.unit.count = speed_5.unit.count * 1.5
speed_5.prerequisites = {"worker-robots-speed-5", "dimension-worker-robots-speed-4"}

capacity_1.name = "dimension-worker-robots-storage-1"
capacity_1.icon = nil
capacity_1.icon_size = nil
capacity_1.icons = capacity_icon
capacity_1.unit.count = capacity_1.unit.count * 1.5
capacity_1.prerequisites = {"worker-robots-storage-1"}

capacity_2.name = "dimension-worker-robots-storage-2"
capacity_2.icon = nil
capacity_2.icon_size = nil
capacity_2.icons = capacity_icon
capacity_2.unit.count = capacity_2.unit.count * 1.5
capacity_2.prerequisites = {"worker-robots-storage-2", "dimension-worker-robots-storage-1"}

capacity_3.name = "dimension-worker-robots-storage-3"
capacity_3.icon = nil
capacity_3.icon_size = nil
capacity_3.icons = capacity_icon
capacity_3.unit.count = capacity_3.unit.count * 1.5
capacity_3.prerequisites = {"worker-robots-storage-3", "dimension-worker-robots-storage-2"}

data:extend{
    speed_1,
    speed_2,
    speed_3,
    speed_4,
    speed_5,
    capacity_1,
    capacity_2,
    capacity_3,
}