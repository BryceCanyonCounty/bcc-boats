Config = {}

-- Set Language
Config.defaultlang = 'en_lang'
-----------------------------------------------------

Config.keys = {
    shop    = 0x760A9C6F, --[G] Open Boat Shop Menu
    options = 0xF1301666, --[O] Opens In-Boat Menu for Anchor and Remote Return
    inv     = 0xD8F73058, --[U] Open Boat Inventory
    ret     = 0xD9D0E1C0, --[space] Return Boat to Shop at Prompt
    pickup  = 0x760A9C6F  --[G] Pick Up Portable Canoe
}
-----------------------------------------------------

-- Limit Number of Boats per Player
Config.maxBoats = 5 -- Default: 5
-----------------------------------------------------

-- Sell Price is 60% of cashPrice (shown below)
Config.sellPrice = 0.60 -- Default: 0.60
-----------------------------------------------------

-- If Changeing, Adjust Models in Shop Menus Below
Config.portable = 'pirogue2' -- Default: pirogue2 / Portable Canoe Model
-----------------------------------------------------

-- Block NPC Boat Spawns
Config.blockNpcBoats = false -- If true, will block the spawning of NPC boats
-----------------------------------------------------

-- Show or Remove Blip when Closed
Config.blipOnClosed = true -- If true, will show colored blip when shop is closed
-----------------------------------------------------

-- Places Boat Name Above Boat When Boat is Empty
Config.boatTag = true --Default: true / Set to false to disable
Config.boatTagDist = 15 -- Default: 15 / Distance from Boat to Show Tag
-----------------------------------------------------

-- Set a Blip on your Launched Boat
Config.boatBlip = true --Default: true / Set to false to disable
Config.boatBlipSprite = 'blip_canoe' -- Default: 'blip_canoe'
-----------------------------------------------------

-- Distance from Portable Canoe to Allow Target Prompts
Config.pickupDist = 3 -- Default: 3
-----------------------------------------------------

Config.steamers = {
    -- Steamboats Only / Default: 1.0 / Fast: 1000.0+
    boatsteam02x = { speed = 1.0 },
    keelboat     = { speed = 1.0 }
}
-----------------------------------------------------

-- Distance from Boat to Allow Inventory Access
Config.invDist = 5 -- Default: 5
Config.inventory = {
    -- Portable
    pirogue2       = { slots = 25 },
    -- Canoes
    canoetreetrunk = { slots = 50 },
    canoe          = { slots = 50 },
    pirogue        = { slots = 50 },
    -- Rowboats
    skiff          = { slots = 100 },
    rowboat        = { slots = 100 },
    rowboatSwamp   = { slots = 100 },
    -- Steamboats
    boatsteam02x   = { slots = 200 },
    keelboat       = { slots = 200 }
}
-----------------------------------------------------

-- Boat Shops
Config.shops = {
    lagras = {
        shopName = 'Lagras Boats', -- Name of Shop on Menu
        promptName = 'Lagras Boats', -- Text Below the Prompt Button
        blipOn = true, -- Turns Blips On / Off
        blipName = 'Lagras Boats', -- Name of the Blip on the Map
        blipSprite = 2005921736, -- 2005921736 = Canoe / -1018164873 = Tugboat
        blipOpen = 'WHITE', -- Shop Open - Default: White - Blip Colors Shown Below
        blipClosed = 'RED', -- Shop Closed - Default: Red - Blip Colors Shown Below
        blipJob = 'YELLOW_ORANGE', -- Shop Job Locked - Default: Yellow_Orange - Blip Colors Shown Below
        npcOn = true, -- Turns NPCs On / Off
        npcModel = 'A_M_M_UniBoatCrew_01', -- Sets Model for NPCs
        npc = vector3(2123.95, -551.63, 41.53), -- Blip and NPC Positions
        npcHeading = 113.62, -- NPC Heading
        boat = vector3(2131.6, -543.66, 40.73), -- Boat Spawn and Return Positions
        boatHeading = 46.62, -- Boat Spawn Heading
        boatCam = vector3(2122.92, -548.97, 42.46), -- Camera Location to View Boat When In-Menu
        player = vector4(2122.87, -551.68, 42.52, 284.48), -- Player Return Teleport Position
        nDistance = 100.0, -- Distance from Shop for NPC to Spawn
        sDistance = 2.0, -- Distance from Shop to Get Menu Prompt
        rDistance = 6.0, -- Distance from Boat Area to Get Return Prompt
        allowedJobs = {}, -- Empty, Everyone Can Use / Insert Job to limit access - ex. 'police'
        jobGrade = 0, -- Enter Minimum Rank / Job Grade to Access Shop
        shopHours = false, -- If You Want the Shops to Use Open and Closed Hours
        shopOpen = 7, -- Shop Open Time / 24 Hour Clock
        shopClose = 21, -- Shop Close Time / 24 Hour Clock
        boats = { -- Gold to Dollar Ratio Based on 1899 Gold Price
            {
                boatType = 'Portable', -- Do Not Put Same Model in Canoes Section
                ['pirogue2'] = { label = 'Canoe', cashPrice = 350, goldPrice = 17 }
            },
            {
                boatType = 'Canoes',
                ['canoetreetrunk'] = { label = 'Dugout Canoe',  cashPrice = 150, goldPrice = 7  },
                ['canoe']          = { label = 'Canoe',         cashPrice = 300, goldPrice = 15 },
                ['pirogue']        = { label = 'Pirogue Canoe', cashPrice = 300, goldPrice = 15 }
            },
            {
                boatType = 'Rowboats',
                ['skiff']        = { label = 'Skiff',         cashPrice = 500, goldPrice = 24 },
                ['rowboat']      = { label = 'Rowboat',       cashPrice = 750, goldPrice = 36 },
                ['rowboatSwamp'] = { label = 'Swamp Rowboat', cashPrice = 750, goldPrice = 36 }
            },
            {
                boatType = 'Steamboats',
                ['boatsteam02x'] = { label = 'Steamboat', cashPrice = 1250, goldPrice = 60 },
                ['keelboat']     = { label = 'Keelboat',  cashPrice = 1950, goldPrice = 94 }
            }
        }
    },
    -----------------------------------------------------

    saintdenis = {
        shopName = 'Saint Denis Boats',
        promptName = 'Saint Denis Boats',
        blipOn = true,
        blipName = 'Saint Denis Boats',
        blipSprite = -1018164873,
        blipOpen = 'WHITE',
        blipClosed = 'RED',
        blipJob = 'YELLOW_ORANGE',
        npcOn = true,
        npcModel = 'A_M_M_UniBoatCrew_01',
        npc = vector3(2949.77, -1250.18, 41.411),
        npcHeading = 95.39,
        boat = vector3(2953.50, -1260.21, 41.58),
        boatHeading = 274.14,
        boatCam = vector3(2951.33, -1251.82, 42.44),
        player = vector4(2948.28, -1250.32, 42.36, 283.74),
        nDistance = 100.0,
        sDistance = 2.0,
        rDistance = 6.0,
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        boats = {
            {
                boatType = 'Portable', -- Do Not Change or Add Models/Boats to Portable Section
                ['pirogue2'] = { label = 'Canoe', cashPrice = 350, goldPrice = 17 }
            },
            {
                boatType = 'Canoes', -- Do Not Add 'pirogue2' Model as a Regular Boat
                ['canoetreetrunk'] = { label = 'Dugout Canoe',  cashPrice = 150, goldPrice = 7  },
                ['canoe']          = { label = 'Canoe',         cashPrice = 300, goldPrice = 15 },
                ['pirogue']        = { label = 'Pirogue Canoe', cashPrice = 300, goldPrice = 15 }
            },
            {
                boatType = 'Rowboats',
                ['skiff']        = { label = 'Skiff',         cashPrice = 500, goldPrice = 24 },
                ['rowboat']      = { label = 'Rowboat',       cashPrice = 750, goldPrice = 36 },
                ['rowboatSwamp'] = { label = 'Swamp Rowboat', cashPrice = 750, goldPrice = 36 }
            },
            {
                boatType = 'Steamboats',
                ['boatsteam02x'] = { label = 'Steamboat', cashPrice = 1250, goldPrice = 60 },
                ['keelboat']     = { label = 'Keelboat',  cashPrice = 1950, goldPrice = 94 }
            }
        }
    },
    -----------------------------------------------------

    annesburg = {
        shopName = 'Annesburg Boats',
        promptName = 'Annesburg Boats',
        blipOn = true,
        blipName = 'Annesburg Boats',
        blipSprite = -1018164873,
        blipOpen = 'WHITE',
        blipClosed = 'RED',
        blipJob = 'YELLOW_ORANGE',
        npcOn = true,
        npcModel = 'A_M_M_UniBoatCrew_01',
        npc = vector3(3033.23, 1369.64, 41.62),
        npcHeading = 67.42,
        boat = vector3(3036.05, 1380.40, 40.27),
        boatHeading = 251.0,
        boatCam = vector3(3033.01, 1371.53, 42.67),
        player = vector4(3031.75, 1370.37, 42.57, 255.25),
        nDistance = 100.0,
        sDistance = 2.0,
        rDistance = 6.0,
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        boats = {
            {
                boatType = 'Portable', -- Do Not Change or Add Models/Boats to Portable Section
                ['pirogue2'] = { label = 'Canoe', cashPrice = 350, goldPrice = 17 }
            },
            {
                boatType = 'Canoes', -- Do Not Add 'pirogue2' Model as a Regular Boat
                ['canoetreetrunk'] = { label = 'Dugout Canoe',  cashPrice = 150, goldPrice = 7  },
                ['canoe']          = { label = 'Canoe',         cashPrice = 300, goldPrice = 15 },
                ['pirogue']        = { label = 'Pirogue Canoe', cashPrice = 300, goldPrice = 15 }
            },
            {
                boatType = 'Rowboats',
                ['skiff']        = { label = 'Skiff',         cashPrice = 500, goldPrice = 24 },
                ['rowboat']      = { label = 'Rowboat',       cashPrice = 750, goldPrice = 36 },
                ['rowboatSwamp'] = { label = 'Swamp Rowboat', cashPrice = 750, goldPrice = 36 }
            },
            {
                boatType = 'Steamboats',
                ['boatsteam02x'] = { label = 'Steamboat', cashPrice = 1250, goldPrice = 60 },
                ['keelboat']     = { label = 'Keelboat',  cashPrice = 1950, goldPrice = 94 }
            }
        }
    },
    -----------------------------------------------------

    blackwater = {
        shopName = 'Blackwater Boats',
        promptName = 'Blackwater Boats',
        blipOn = true,
        blipName = 'Blackwater Boats',
        blipSprite = -1018164873,
        blipOpen = 'WHITE',
        blipClosed = 'RED',
        blipJob = 'YELLOW_ORANGE',
        npcOn = true,
        npcModel = 'A_M_M_UniBoatCrew_01',
        npc = vector3(-682.36, -1242.97, 42.11),
        npcHeading = 88.90,
        boat = vector3(-682.22, -1254.50, 40.27),
        boatHeading = 277.0,
        boatCam = vector3(-683.17, -1245.29, 43.06),
        player = vector4(-683.87, -1242.94, 43.06, 277.61),
        nDistance = 100.0,
        sDistance = 2.0,
        rDistance = 6.0,
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        boats = {
            {
                boatType = 'Portable', -- Do Not Change or Add Models/Boats to Portable Section
                ['pirogue2'] = { label = 'Canoe', cashPrice = 350, goldPrice = 17 }
            },
            {
                boatType = 'Canoes', -- Do Not Add 'pirogue2' Model as a Regular Boat
                ['canoetreetrunk'] = { label = 'Dugout Canoe',  cashPrice = 150, goldPrice = 7  },
                ['canoe']          = { label = 'Canoe',         cashPrice = 300, goldPrice = 15 },
                ['pirogue']        = { label = 'Pirogue Canoe', cashPrice = 300, goldPrice = 15 }
            },
            {
                boatType = 'Rowboats',
                ['skiff']        = { label = 'Skiff',         cashPrice = 500, goldPrice = 24 },
                ['rowboat']      = { label = 'Rowboat',       cashPrice = 750, goldPrice = 36 },
                ['rowboatSwamp'] = { label = 'Swamp Rowboat', cashPrice = 750, goldPrice = 36 }
            },
            {
                boatType = 'Steamboats',
                ['boatsteam02x'] = { label = 'Steamboat', cashPrice = 1250, goldPrice = 60 },
                ['keelboat']     = { label = 'Keelboat',  cashPrice = 1950, goldPrice = 94 }
            }
        }
    },
    -----------------------------------------------------

    wapiti = {
        shopName = 'Wapiti Boats',
        promptName = 'Wapiti Boats',
        blipOn = true,
        blipName = 'Wapiti Boats',
        blipSprite = 2005921736,
        blipOpen = 'WHITE',
        blipClosed = 'RED',
        blipJob = 'YELLOW_ORANGE',
        npcOn = true,
        npcModel = 'A_M_M_UniBoatCrew_01',
        npc = vector3(614.46, 2209.5, 222.01),
        npcHeading = 194.08,
        boat = vector3(636.8, 2212.13, 220.78),
        boatHeading = 212.13,
        boatCam = vector3(625.05, 2211.25, 222.64),
        player = vector4(614.47, 2207.97, 222.97, 5.61),
        nDistance = 100.0,
        sDistance = 2.0,
        rDistance = 6.0,
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        boats = {
            {
                boatType = 'Portable', -- Do Not Change or Add Models/Boats to Portable Section
                ['pirogue2'] = { label = 'Canoe', cashPrice = 350, goldPrice = 17 }
            },
            {
                boatType = 'Canoes', -- Do Not Add 'pirogue2' Model as a Regular Boat
                ['canoetreetrunk'] = { label = 'Dugout Canoe',  cashPrice = 150, goldPrice = 7  },
                ['canoe']          = { label = 'Canoe',         cashPrice = 300, goldPrice = 15 },
                ['pirogue']        = { label = 'Pirogue Canoe', cashPrice = 300, goldPrice = 15 }
            },
            {
                boatType = 'Rowboats',
                ['skiff']        = { label = 'Skiff',         cashPrice = 500, goldPrice = 24 },
                ['rowboat']      = { label = 'Rowboat',       cashPrice = 750, goldPrice = 36 },
                ['rowboatSwamp'] = { label = 'Swamp Rowboat', cashPrice = 750, goldPrice = 36 }
            },
            {
                boatType = 'Steamboats',
                ['boatsteam02x'] = { label = 'Steamboat', cashPrice = 1250, goldPrice = 60 },
                ['keelboat']     = { label = 'Keelboat',  cashPrice = 1950, goldPrice = 94 }
            }
        }
    },
    -----------------------------------------------------

    manteca = {
        shopName = 'Manteca Falls Boats',
        promptName = 'Manteca Falls Boats',
        blipOn = true,
        blipName = 'Manteca Falls Boats',
        blipSprite = -1018164873,
        blipOpen = 'WHITE',
        blipClosed = 'RED',
        blipJob = 'YELLOW_ORANGE',
        npcOn = true,
        npcModel = 'A_M_M_UniBoatCrew_01',
        npc = vector3(-2017.76, -3048.91, -12.21),
        npcHeading = 21.23,
        boat = vector3(-2030.37, -3048.24, -12.69),
        boatHeading = 197.53,
        boatCam = vector3(-2019.41, -3048.47, -11.25),
        player = vector4(-2018.32, -3047.83, -11.26, 205.54),
        nDistance = 100.0,
        sDistance = 2.0,
        rDistance = 6.0,
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        boats = {
            {
                boatType = 'Portable', -- Do Not Change or Add Models/Boats to Portable Section
                ['pirogue2'] = { label = 'Canoe', cashPrice = 350, goldPrice = 17 }
            },
            {
                boatType = 'Canoes', -- Do Not Add 'pirogue2' Model as a Regular Boat
                ['canoetreetrunk'] = { label = 'Dugout Canoe',  cashPrice = 150, goldPrice = 7  },
                ['canoe']          = { label = 'Canoe',         cashPrice = 300, goldPrice = 15 },
                ['pirogue']        = { label = 'Pirogue Canoe', cashPrice = 300, goldPrice = 15 }
            },
            {
                boatType = 'Rowboats',
                ['skiff']        = { label = 'Skiff',         cashPrice = 500, goldPrice = 24 },
                ['rowboat']      = { label = 'Rowboat',       cashPrice = 750, goldPrice = 36 },
                ['rowboatSwamp'] = { label = 'Swamp Rowboat', cashPrice = 750, goldPrice = 36 }
            },
            {
                boatType = 'Steamboats',
                ['boatsteam02x'] = { label = 'Steamboat', cashPrice = 1250, goldPrice = 60 },
                ['keelboat']     = { label = 'Keelboat',  cashPrice = 1950, goldPrice = 94 }
            }
        }
    },
    -----------------------------------------------------

    sisika = {
        shopName = 'Sisika Boats',
        promptName = 'Sisika Boats',
        blipOn = true,
        blipName = 'Sisika Boats',
        blipSprite = 2005921736,
        blipOpen = 'WHITE',
        blipClosed = 'RED',
        blipJob = 'YELLOW_ORANGE',
        npcOn = true,
        npcModel = 'A_M_M_UniBoatCrew_01',
        npc = vector3(3266.12, -716.04, 40.98),
        npcHeading = 274.85,
        boat = vector3(3252.1, -706.06, 41.93),
        boatHeading = 75.28,
        boatCam = vector3(3265.04, -715.53, 41.95),
        player = vector4(3267.94, -715.9, 42.0, 101.39),
        nDistance = 100.0,
        sDistance = 2.0,
        rDistance = 6.0,
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        boats = {
            {
                boatType = 'Portable', -- Do Not Change or Add Models/Boats to Portable Section
                ['pirogue2'] = { label = 'Canoe', cashPrice = 350, goldPrice = 17 }
            },
            {
                boatType = 'Canoes', -- Do Not Add 'pirogue2' Model as a Regular Boat
                ['canoetreetrunk'] = { label = 'Dugout Canoe',  cashPrice = 150, goldPrice = 7  },
                ['canoe']          = { label = 'Canoe',         cashPrice = 300, goldPrice = 15 },
                ['pirogue']        = { label = 'Pirogue Canoe', cashPrice = 300, goldPrice = 15 }
            },
            {
                boatType = 'Rowboats',
                ['skiff']        = { label = 'Skiff',         cashPrice = 500, goldPrice = 24 },
                ['rowboat']      = { label = 'Rowboat',       cashPrice = 750, goldPrice = 36 },
                ['rowboatSwamp'] = { label = 'Swamp Rowboat', cashPrice = 750, goldPrice = 36 }
            },
            {
                boatType = 'Steamboats',
                ['boatsteam02x'] = { label = 'Steamboat', cashPrice = 1250, goldPrice = 60 },
                ['keelboat']     = { label = 'Keelboat',  cashPrice = 1950, goldPrice = 94 }
            }
        }
    },
    -----------------------------------------------------

    braithwaite = {
        shopName = 'Braithwaite Dock',
        promptName = 'Braithwaite Dock',
        blipOn = true,
        blipName = 'Braithwaite Dock',
        blipSprite = 2005921736,
        blipOpen = 'WHITE',
        blipClosed = 'RED',
        blipJob = 'YELLOW_ORANGE',
        npcOn = true,
        npcModel = 'A_M_M_UniBoatCrew_01',
        npc = vector3(884.67, -1781.19, 41.09),
        npcHeading = 316.17,
        boat = vector3(878.62, -1770.58, 40.57),
        boatHeading = 133.63,
        boatCam = vector3(883.82, -1779.89, 42.09),
        player = vector4(885.98, -1779.96, 42.09, 132.54),
        nDistance = 100.0,
        sDistance = 2.0,
        rDistance = 6.0,
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        boats = {
            {
                boatType = 'Portable', -- Do Not Change or Add Models/Boats to Portable Section
                ['pirogue2'] = { label = 'Canoe', cashPrice = 350, goldPrice = 17 }
            },
            {
                boatType = 'Canoes', -- Do Not Add 'pirogue2' Model as a Regular Boat
                ['canoetreetrunk'] = { label = 'Dugout Canoe',  cashPrice = 150, goldPrice = 7  },
                ['canoe']          = { label = 'Canoe',         cashPrice = 300, goldPrice = 15 },
                ['pirogue']        = { label = 'Pirogue Canoe', cashPrice = 300, goldPrice = 15 }
            },
            {
                boatType = 'Rowboats',
                ['skiff']        = { label = 'Skiff',         cashPrice = 500, goldPrice = 24 },
                ['rowboat']      = { label = 'Rowboat',       cashPrice = 750, goldPrice = 36 },
                ['rowboatSwamp'] = { label = 'Swamp Rowboat', cashPrice = 750, goldPrice = 36 }
            },
            {
                boatType = 'Steamboats',
                ['boatsteam02x'] = { label = 'Steamboat', cashPrice = 1250, goldPrice = 60 },
                ['keelboat']     = { label = 'Keelboat',  cashPrice = 1950, goldPrice = 94 }
            }
        }
    },
    -----------------------------------------------------

    guarma = {
        shopName = 'Guarma Boats',
        promptName = 'Guarma Boats',
        blipOn = true,
        blipName = 'Guarma Boats',
        blipSprite = 2005921736,
        blipOpen = 'WHITE',
        blipClosed = 'RED',
        blipJob = 'YELLOW_ORANGE',
        npcOn = true,
        npcModel = 'A_M_M_UniBoatCrew_01',
        npc = vector3(1271.93, -6852.74, 42.27),
        npcHeading = 195.32,
        boat = vector3(1271.17, -6841.04, 40.25),
        boatHeading = 58.99,
        boatCam = vector3(1267.54, -6849.3, 43.4),
        player = vector4(1272.62, -6854.04, 43.27, 20.86),
        nDistance = 100.0,
        sDistance = 2.0,
        rDistance = 6.0,
        allowedJobs = {},
        jobGrade = 0,
        shopHours = false,
        shopOpen = 7,
        shopClose = 21,
        boats = {
            {
                boatType = 'Portable', -- Do Not Change or Add Models/Boats to Portable Section
                ['pirogue2'] = { label = 'Canoe', cashPrice = 350, goldPrice = 17 }
            },
            {
                boatType = 'Canoes', -- Do Not Add 'pirogue2' Model as a Regular Boat
                ['canoetreetrunk'] = { label = 'Dugout Canoe',  cashPrice = 150, goldPrice = 7  },
                ['canoe']          = { label = 'Canoe',         cashPrice = 300, goldPrice = 15 },
                ['pirogue']        = { label = 'Pirogue Canoe', cashPrice = 300, goldPrice = 15 }
            },
            {
                boatType = 'Rowboats',
                ['skiff']        = { label = 'Skiff',         cashPrice = 500, goldPrice = 24 },
                ['rowboat']      = { label = 'Rowboat',       cashPrice = 750, goldPrice = 36 },
                ['rowboatSwamp'] = { label = 'Swamp Rowboat', cashPrice = 750, goldPrice = 36 }
            },
            {
                boatType = 'Steamboats',
                ['boatsteam02x'] = { label = 'Steamboat', cashPrice = 1250, goldPrice = 60 },
                ['keelboat']     = { label = 'Keelboat',  cashPrice = 1950, goldPrice = 94 }
            }
        }
    }
}
-----------------------------------------------------

Config.locations = { -- Water Locations for Portable Canoe
    [1]  = { name = 'Sea of Coronado',     hash = -247856387  },
    [2]  = { name = 'San Luis River',      hash = -1504425495 },
    [3]  = { name = 'Lake Don Julio',      hash = -1369817450 },
    [4]  = { name = 'Flat Iron Lake',      hash = -1356490953 },
    [5]  = { name = 'Upper Montana River', hash = -1781130443 },
    [6]  = { name = 'Owanjila',            hash = -1300497193 },
    [7]  = { name = 'Hawks Eye Creek',     hash = -1276586360 },
    [8]  = { name = 'Little Creek River',  hash = -1410384421 },
    [9]  = { name = 'Dakota River',        hash =  370072007  },
    [10] = { name = 'Beartooth Beck',      hash =  650214731  },
    [11] = { name = 'Lake Isabella',       hash =  592454541  },
    [12] = { name = 'Cattail Pond',        hash = -804804953  },
    [13] = { name = 'Deadboot Creek',      hash =  1245451421 },
    [14] = { name = 'Spider Gorge',        hash = -218679770  },
    [15] = { name = 'O\'Creagh\'s Run',    hash = -1817904483 },
    [16] = { name = 'Moonstone Pond',      hash = -811730579  },
    [17] = { name = 'Kamassa River',       hash = -1229593481 },
    [18] = { name = 'Elysian Pool',        hash = -105598602  },
    [19] = { name = 'Heartlands Overflow', hash =  1755369577 },
    [20] = { name = 'Lagras Bayou',        hash = -557290573  },
    [21] = { name = 'Lannahechee River',   hash = -2040708515 },
    [22] = { name = 'Calmut Ravine',       hash =  231313522  },
    [23] = { name = 'Ringneck Creek',      hash =  2005774838 },
    [24] = { name = 'Stillwater Creek',    hash = -1287619521 },
    [25] = { name = 'Lower Montana River', hash = -1308233316 },
    [27] = { name = 'Aurora Basin',        hash = -196675805  },
    [28] = { name = 'Barrow Lagoon',       hash =  795414694  },
    [29] = { name = 'Arroyo De La Vibora', hash = -49694339   },
    [30] = { name = 'Bahia De La Paz',     hash = -1168459546 },
    [31] = { name = 'Dewberry Creek',      hash =  469159176  },
    [32] = { name = 'Whinyard Strait',     hash = -261541730  },
    [33] = { name = 'Cairn Lake',          hash = -1073312073 },
    [34] = { name = 'Hot Springs',         hash =  1175365009 },
    [35] = { name = 'Mattlock Pond',       hash =  301094150  },
    [36] = { name = 'Southfield Flats',    hash = -823661292  },
}
-----------------------------------------------------

Config.BlipColors = {
    LIGHT_BLUE    = 'BLIP_MODIFIER_MP_COLOR_1',
    DARK_RED      = 'BLIP_MODIFIER_MP_COLOR_2',
    PURPLE        = 'BLIP_MODIFIER_MP_COLOR_3',
    ORANGE        = 'BLIP_MODIFIER_MP_COLOR_4',
    TEAL          = 'BLIP_MODIFIER_MP_COLOR_5',
    LIGHT_YELLOW  = 'BLIP_MODIFIER_MP_COLOR_6',
    PINK          = 'BLIP_MODIFIER_MP_COLOR_7',
    GREEN         = 'BLIP_MODIFIER_MP_COLOR_8',
    DARK_TEAL     = 'BLIP_MODIFIER_MP_COLOR_9',
    RED           = 'BLIP_MODIFIER_MP_COLOR_10',
    LIGHT_GREEN   = 'BLIP_MODIFIER_MP_COLOR_11',
    TEAL2         = 'BLIP_MODIFIER_MP_COLOR_12',
    BLUE          = 'BLIP_MODIFIER_MP_COLOR_13',
    DARK_PUPLE    = 'BLIP_MODIFIER_MP_COLOR_14',
    DARK_PINK     = 'BLIP_MODIFIER_MP_COLOR_15',
    DARK_DARK_RED = 'BLIP_MODIFIER_MP_COLOR_16',
    GRAY          = 'BLIP_MODIFIER_MP_COLOR_17',
    PINKISH       = 'BLIP_MODIFIER_MP_COLOR_18',
    YELLOW_GREEN  = 'BLIP_MODIFIER_MP_COLOR_19',
    DARK_GREEN    = 'BLIP_MODIFIER_MP_COLOR_20',
    BRIGHT_BLUE   = 'BLIP_MODIFIER_MP_COLOR_21',
    BRIGHT_PURPLE = 'BLIP_MODIFIER_MP_COLOR_22',
    YELLOW_ORANGE = 'BLIP_MODIFIER_MP_COLOR_23',
    BLUE2         = 'BLIP_MODIFIER_MP_COLOR_24',
    TEAL3         = 'BLIP_MODIFIER_MP_COLOR_25',
    TAN           = 'BLIP_MODIFIER_MP_COLOR_26',
    OFF_WHITE     = 'BLIP_MODIFIER_MP_COLOR_27',
    LIGHT_YELLOW2 = 'BLIP_MODIFIER_MP_COLOR_28',
    LIGHT_PINK    = 'BLIP_MODIFIER_MP_COLOR_29',
    LIGHT_RED     = 'BLIP_MODIFIER_MP_COLOR_30',
    LIGHT_YELLOW3 = 'BLIP_MODIFIER_MP_COLOR_31',
    WHITE         = 'BLIP_MODIFIER_MP_COLOR_32'
}
