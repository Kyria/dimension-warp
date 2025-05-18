
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

-- special entities with fixed position
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

    -- surface mobile teleporter
    surface_warp_gate = {
        name = "warp-gate",
        position = {0, -6.5},
        area = {{-2, -2}, {1, 1}}
    },

    -- inter surface gates
    gate_factory_surface = {
        name = "warp-gate",
        position = {0, -6.5},
        area = {{-2, -2}, {1, 1}}
    },
    gate_factory_mining = {
        name = "warp-gate",
        position = {0, 6.5},
        area = {{-2, -2}, {1, 1}}
    },
    gate_mining_factory = {
        name = "warp-gate",
        position = {0, -6.5},
        area = {{-2, -2}, {1, 1}}
    },
    gate_mining_power = {
        name = "warp-gate",
        position = {0, 6.5},
        area = {{-2, -2}, {1, 1}}
    },
    gate_power_mining = {
        name = "warp-gate",
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

dw.stairs = {

}

