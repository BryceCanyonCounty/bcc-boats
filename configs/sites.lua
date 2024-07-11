-- Boat Shops
Sites = {
    lagras = {
        shop = {
            name = 'Lagras Boats',                          -- Name of Shop on Menu
            prompt = 'Lagras Boats',                        -- Text Below the Prompt Button
            distance    = 2.0,                              -- Distance from NPC to Get Menu Prompt
            jobsEnabled = false,                            -- Allow Shop Access to Specified Jobs Only
            jobs = {                                        -- Insert Job to limit access - ex. allowedJobs = {{name = 'police', grade = 1},{name = 'doctor', grade = 3}}
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,                             -- Shop uses Open and Closed Hours
                open   = 7,                                 -- Shop Open Time / 24 Hour Clock
                close  = 21                                 -- Shop Close Time / 24 Hour Clock
            }
        },
        blip = {
            name = 'Lagras Boats',                          -- Name of Blip on Map
            sprite = 2005921736,                            -- 2005921736 = Canoe / -1018164873 = Tugboat
            show = {
                open = true,                                -- Show Blip On Map when Open
                closed = true                               -- Show Blip On Map when Closed
            },
            color = {
                open   = 'WHITE',                           -- Shop Open - Default: White - Blip Colors Shown Below
                closed = 'RED',                             -- Shop Closed - Deafault: Red - Blip Colors Shown Below
                job    = 'YELLOW_ORANGE'                    -- Shop Job Locked - Default: Yellow - Blip Colors Shown Below
            }
        },
        npc = {
            active   = true,                                -- Turns NPC On / Off
            model    = 'A_M_M_UniBoatCrew_01',              -- Model Used for NPC
            coords   = vector3(2123.95, -551.63, 41.53),    -- NPC and Shop Blip Positions
            heading  = 113.62,                              -- NPC Heading
            distance = 100.0                                -- Distance Between Player and Shop for NPC to Spawn
        },
        boat = {
            coords  = vector3(2131.6, -543.66, 40.73),      -- Boat Spawn and Return Positions
            heading = 46.62,                                -- Boat Spawn Heading
            camera  = vector3(2122.92, -548.97, 42.46),     -- Camera Location to View Boat When In-Menu
            distance = 6.0                                  -- Distance from Boat Area to Get Return Prompt
        },
        player = {
            coords = vector3(2122.87, -551.68, 42.52),      -- Player Position on Boat Return
            heading = 284.48                                -- Player Return Heading
        },
        boatmanBuy = false,                                 -- Only a Boatman can Buy Boats from this Shop
    },
    -----------------------------------------------------

    saintdenis = {
        shop = {
            name = 'Saint Denis Boats',
            prompt = 'Saint Denis Boats',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            name = 'Saint Denis Boats',
            sprite = -1018164873,
            show = {
                open = true,
                closed = true
            },
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 'A_M_M_UniBoatCrew_01',
            coords   = vector3(2949.77, -1250.18, 41.411),
            heading  = 95.39,
            distance = 100.0
        },
        boat = {
            coords  = vector3(2953.50, -1260.21, 41.58),
            heading = 274.14,
            camera  = vector3(2951.33, -1251.82, 42.44),
            distance = 15.0
        },
        player = {
            coords = vector3(2948.28, -1250.32, 42.36),
            heading = 283.74
        },
        boatmanBuy = false,
    },
    -----------------------------------------------------

    annesburg = {
        shop = {
            name = 'Annesburg Boats',
            prompt = 'Annesburg Boats',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            name = 'Annesburg Boats',
            sprite = -1018164873,
            show = {
                open = true,
                closed = true
            },
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 'A_M_M_UniBoatCrew_01',
            coords   = vector3(3033.23, 1369.64, 41.62),
            heading  = 67.42,
            distance = 100.0
        },
        boat = {
            coords  = vector3(3036.05, 1380.40, 40.27),
            heading = 251.0,
            camera  = vector3(3033.01, 1371.53, 42.67),
            distance = 6.0
        },
        player = {
            coords = vector3(3031.75, 1370.37, 42.57),
            heading = 255.25
        },
        boatmanBuy = false,
    },
    -----------------------------------------------------

    blackwater = {
        shop = {
            name = 'Blackwater Boats',
            prompt = 'Blackwater Boats',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            name = 'Blackwater Boats',
            sprite = -1018164873,
            show = {
                open = true,
                closed = true
            },
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 'A_M_M_UniBoatCrew_01',
            coords   = vector3(-682.36, -1242.97, 42.11),
            heading  = 88.90,
            distance = 100.0
        },
        boat = {
            coords  = vector3(-682.22, -1254.50, 40.27),
            heading = 277.0,
            camera  = vector3(-683.17, -1245.29, 43.06),
            distance = 6.0
        },
        player = {
            coords = vector3(-683.87, -1242.94, 43.06),
            heading = 277.61
        },
        boatmanBuy = false,
    },
    -----------------------------------------------------

    wapiti = {
        shop = {
            name = 'Wapiti Boats',
            prompt = 'Wapiti Boats',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            name = 'Wapiti Boats',
            sprite = 2005921736,
            show = {
                open = true,
                closed = true
            },
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 'A_M_M_UniBoatCrew_01',
            coords   = vector3(614.46, 2209.5, 222.01),
            heading  = 194.08,
            distance = 100.0
        },
        boat = {
            coords  = vector3(636.8, 2212.13, 220.78),
            heading = 212.13,
            camera  = vector3(625.05, 2211.25, 222.64),
            distance = 6.0
        },
        player = {
            coords = vector3(614.47, 2207.97, 222.97),
            heading = 5.61
        },
        boatmanBuy = false,
    },
    -----------------------------------------------------

    manteca = {
        shop = {
            name = 'Manteca Falls Boats',
            prompt = 'Manteca Falls Boats',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            name = 'Manteca Falls Boats',
            sprite = -1018164873,
            show = {
                open = true,
                closed = true
            },
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 'A_M_M_UniBoatCrew_01',
            coords   = vector3(-2017.76, -3048.91, -12.21),
            heading  = 21.23,
            distance = 100.0
        },
        boat = {
            coords  = vector3(-2030.37, -3048.24, -12.69),
            heading = 197.53,
            camera  = vector3(-2019.41, -3048.47, -11.25),
            distance = 6.0
        },
        player = {
            coords = vector3(-2018.32, -3047.83, -11.26),
            heading = 205.54
        },
        boatmanBuy = false,
    },
    -----------------------------------------------------

    sisika = {
        shop = {
            name = 'Sisika Boats',
            prompt = 'Sisika Boats',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            name = 'Sisika Boats',
            sprite = 2005921736,
            show = {
                open = true,
                closed = true
            },
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 'A_M_M_UniBoatCrew_01',
            coords   = vector3(3266.12, -716.04, 40.98),
            heading  = 274.85,
            distance = 100.0
        },
        boat = {
            coords  = vector3(3252.1, -706.06, 41.93),
            heading = 75.28,
            camera  = vector3(-2019.41, -3048.47, -11.25),
            distance = 6.0
        },
        player = {
            coords = vector3(3267.94, -715.9, 42.0),
            heading = 101.39
        },
        boatmanBuy = false,
    },
    -----------------------------------------------------

    braithwaite = {
        shop = {
            name = 'Braithwaite Dock',
            prompt = 'Braithwaite Dock',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            name = 'Braithwaite Dock',
            sprite = 2005921736,
            show = {
                open = true,
                closed = true
            },
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 'A_M_M_UniBoatCrew_01',
            coords   = vector3(884.67, -1781.19, 41.09),
            heading  = 316.17,
            distance = 100.0
        },
        boat = {
            coords  = vector3(878.62, -1770.58, 40.57),
            heading = 133.63,
            camera  = vector3(883.82, -1779.89, 42.09),
            distance = 6.0
        },
        player = {
            coords = vector3(885.98, -1779.96, 42.09),
            heading = 132.54
        },
        boatmanBuy = false,
    },
    -----------------------------------------------------

    guarma = {
        shop = {
            name = 'Guarma Boats',
            prompt = 'Guarma Boats',
            distance    = 2.0,
            jobsEnabled = false,
            jobs = {
                {name = 'police', grade = 1},
                {name = 'doctor', grade = 3}
            },
            hours = {
                active = false,
                open   = 7,
                close  = 21
            }
        },
        blip = {
            name = 'Guarma Boats',
            sprite = 2005921736,
            show = {
                open = true,
                closed = true
            },
            color = {
                open   = 'WHITE',
                closed = 'RED',
                job    = 'YELLOW_ORANGE'
            }
        },
        npc = {
            active   = true,
            model    = 'A_M_M_UniBoatCrew_01',
            coords   = vector3(1271.93, -6852.74, 42.27),
            heading  = 195.32,
            distance = 100.0
        },
        boat = {
            coords  = vector3(1271.17, -6841.04, 40.25),
            heading = 58.99,
            camera  = vector3(1267.54, -6849.3, 43.4),
            distance = 6.0
        },
        player = {
            coords = vector3(1272.62, -6854.04, 43.27),
            heading = 20.86
        },
        boatmanBuy = false,
    }
}