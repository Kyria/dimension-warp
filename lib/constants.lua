--- platforms size
dw.platform_size = {
    warp = {8, 22, 36, 50, 64, 78, 92, 106},
    factory = {20, 28, 38, 52, 72, 94, 122, 152},
    mining = {{x=20, y=16},{x=26, y=18},{x=34, y=22},{x=48, y=28},{x=64, y=36},{x=85, y=46},{x=110, y=58},{x=136, y=70}},
    power = {18, 24, 30, 36, 48, 54, 66, 84},
    harvester = {12, 16, 22, 30, 40, 52}
}

--- surfaces where players are safe when they connect (no need for safe teleport)
dw.safe_surfaces = {
    produstia = true,
    electria = true,
    smeltus = true,
}

dw.hazard_tiles = {
    surface = {
        --- top radio tower
        {{-5,-8}, {-5,-6}},
        {{-5,-8}, {4,-7}},
        {{4,-8}, {4,-6}},
        --- bottom mobile gate
        {{-2,5}, {1,7}},
        {{-5,6}, {4,7}},
    },
    factory = {
        --- beacon
        {{-2,-2}, {1,1}},
        --- top gate
        {{-5,-8}, {4,-7}},
        {{-2,-6}, {1,-6}},
        {{-6,-8}, {-6,-6}},
        {{5,-8}, {5,-6}},
        --- bottom gate
        {{-5,6}, {4,7}},
        {{-2,5}, {1,7}},
        {{-6,5}, {-6,7}},
        {{5,5}, {5,7}},
    },
    mining = {
        --- gleba chests
        {{-1,-1}, {0,0}},
        --- top gate
        {{-5,-8}, {4,-7}},
        {{-2,-6}, {1,-6}},
        {{-6,-8}, {-6,-6}},
        {{5,-8}, {5,-6}},
        --- bottom gate
        {{-5,6}, {4,7}},
        {{-2,5}, {1,7}},
        {{-6,5}, {-6,7}},
        {{5,5}, {5,7}},
    },
    power = {
        ---  gate
        {{-5,-6}, {4,-5}},
        {{-2,-4}, {1,-4}},
        {{-6,-6}, {-6,-4}},
        {{5,-6}, {5,-4}},
    }
}

--- special entities with fixed position
--- does not contain warpgate / harvesters
dw.entities = {
    -- radio station in surface
    surface_radio_station = {
        name = "radio-station",
        position = {0, -7},
        area = {{-1, -1}, {0, 0}}
    },
    -- hidden power pole for station surface
    surface_radio_pole = {
        name = "dw-hidden-radio-pole",
        position = {0, -7},
        area = {{-1, -1}, {0, 0}}
    },

    -- inter surface gates
    gate_factory_surface = {
        name = "surface-gate",
        position = {0, -6.5},
        area = {{-2, -2}, {1, 1}}
    },
    gate_factory_mining = {
        name = "mining-gate",
        position = {0, 6.5},
        area = {{-2, -2}, {1, 1}}
    },
    gate_mining_factory = {
        name = "factory-gate",
        position = {0, -6.5},
        area = {{-2, -2}, {1, 1}}
    },
    gate_mining_power = {
        name = "power-gate",
        position = {0, 6.5},
        area = {{-2, -2}, {1, 1}}
    },
    gate_power_mining = {
        name = "mining-gate",
        position = {0, -4.5},
        area = {{-2, -2}, {1, 1}}
    },

    -- inter surface power poles
    pole_factory_surface = {
        name = "dw-hidden-gate-pole",
        position = {0, -6},
        area = {{0, 0}, {0, 0}}
    },
    pole_factory_mining = {
        name = "dw-hidden-gate-pole",
        position = {0, 6},
        area = {{0, 0}, {0, 0}}
    },
    pole_mining_factory = {
        name = "dw-hidden-gate-pole",
        position = {0, -6},
        area = {{0, 0}, {0, 0}}
    },
    pole_mining_power = {
        name = "dw-hidden-gate-pole",
        position = {0, 6},
        area = {{0, 0}, {0, 0}}
    },
    pole_power_mining = {
        name = "dw-hidden-gate-pole",
        position = {0, -3},
        area = {{0, 0}, {0, 0}}
    },
}

--- chests and loader positions
--- order is important: from center to exterior, in pairs
dw.stairs = {
    surface_factory = {
        {
            chests = {{-1.5, -7.5}, {-2.5, -7.5}},
            loaders = {{-1.5, -6.5}, {-2.5, -6.5}},
            pipes = {{-4.5, -7.5}, {-5.5, -7.5}},
            direction = {defines.loader_facing.top, defines.loader_facing.top}
        },
        {
            chests = {{1.5, -7.5}, {2.5, -7.5}},
            loaders = {{1.5, -6.5}, {2.5, -6.5}},
            pipes = {{4.5, -7.5}, {5.5, -7.5}},
            direction = {defines.loader_facing.top, defines.loader_facing.top}
        },
        {
            chests = {{-2.5, -7.5}, {-3.5, -7.5}},
            loaders = {{-2.5, -6.5}, {-3.5, -6.5}},
            pipes = {{-4.5, -6.5}, {-5.5, -6.5}},
            direction = {defines.loader_facing.top, defines.loader_facing.top}
        },
        {
            chests = {{2.5, -7.5}, {3.5, -7.5}},
            loaders = {{2.5, -6.5}, {3.5, -6.5}},
            pipes = {{4.5, -6.5}, {5.5, -6.5}},
            direction = {defines.loader_facing.top, defines.loader_facing.top}
        },
        {
            chests = {{-3.5, -7.5}, {-4.5, -7.5}},
            loaders = {{-3.5, -6.5}, {-4.5, -6.5}},
            pipes = {{-4.5, -5.5}, {-5.5, -5.5}},
            direction = {defines.loader_facing.top, defines.loader_facing.top}
        },
        {
            chests = {{3.5, -7.5}, {4.5, -7.5}},
            loaders = {{3.5, -6.5}, {4.5, -6.5}},
            pipes = {{4.5, -5.5}, {5.5, -5.5}},
            direction = {defines.loader_facing.top, defines.loader_facing.top}
        }
    },
    factory_mining = {
        {
            chests = {{-2.5, 7.5}, {-2.5, -7.5}},
            loaders = {{-2.5, 6.5}, {-2.5, -6.5}},
            pipes = {{-5.5, 5.5}, {-5.5, -7.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{2.5, 7.5}, {2.5, -7.5}},
            loaders = {{2.5, 6.5}, {2.5, -6.5}},
            pipes = {{5.5, 5.5}, {5.5, -7.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{-3.5, 7.5}, {-3.5, -7.5}},
            loaders = {{-3.5, 6.5}, {-3.5, -6.5}},
            pipes = {{-5.5, 6.5}, {-5.5, -6.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{3.5, 7.5}, {3.5, -7.5}},
            loaders = {{3.5, 6.5}, {3.5, -6.5}},
            pipes = {{5.5, 6.5}, {5.5, -6.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{-4.5, 7.5}, {-4.5, -7.5}},
            loaders = {{-4.5, 6.5}, {-4.5, -6.5}},
            pipes = {{-5.5, 7.5}, {-5.5, -5.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{4.5, 7.5}, {4.5, -7.5}},
            loaders = {{4.5, 6.5}, {4.5, -6.5}},
            pipes = {{5.5, 7.5}, {5.5, -5.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        }
    },
    mining_power = {
        {
            chests = {{-2.5, 7.5}, {-2.5, -5.5}},
            loaders = {{-2.5, 6.5}, {-2.5, -4.5}},
            pipes = {{-5.5, 5.5}, {-5.5, -5.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{2.5, 7.5}, {2.5, -5.5}},
            loaders = {{2.5, 6.5}, {2.5, -4.5}},
            pipes = {{5.5, 5.5}, {5.5, -5.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{-3.5, 7.5}, {-3.5, -5.5}},
            loaders = {{-3.5, 6.5}, {-3.5, -4.5}},
            pipes = {{-5.5, 6.5}, {-5.5, -4.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{3.5, 7.5}, {3.5, -5.5}},
            loaders = {{3.5, 6.5}, {3.5, -4.5}},
            pipes = {{5.5, 6.5}, {5.5, -4.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{-4.5, 7.5}, {-4.5, -5.5}},
            loaders = {{-4.5, 6.5}, {-4.5, -4.5}},
            pipes = {{-5.5, 7.5}, {-5.5, -3.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        },
        {
            chests = {{4.5, 7.5}, {4.5, -5.5}},
            loaders = {{4.5, 6.5}, {4.5, -4.5}},
            pipes = {{5.5, 7.5}, {5.5, -3.5}},
            direction = {defines.loader_facing.bottom, defines.loader_facing.top}
        }
    },
}

--- warp gate
dw.warp_gate = {
    name = "warp-gate",
    position = {0, 6.5},
    area = {{-2, -2}, {1, 1}},
    direction = defines.loader_facing.bottom,
    --- relative position to warp_gate center
    chests = {
        {-2.5, 1},
        {2.5, 1},
        {-3.5, 1},
        {3.5, 1},
    },
    loaders = {
        {-2.5, 0},
        {2.5, 0},
        {-3.5, 0},
        {3.5, 0},
    },
    pipes = {
        {-4.5, 0},
        {4.5, 0},
        {-4.5, 1},
        {4.5, 1},
    }
}

dw.harvesters = {
    left = {
        center = {-103, 0},
        area = {{-1, -1}, {0, 0}},
        name = "harvester-left-gate",
        pole = "dw-hidden-radio-pole",
        mobile_name = "harvester-left-mobile-gate"
    },
    right = {
        center = {103, 0},
        area = {{-1, -1}, {0, 0}},
        name = "harvester-right-gate",
        pole = "dw-hidden-radio-pole",
        mobile_name = "harvester-right-mobile-gate"
    },
}