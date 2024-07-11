Boats = { -- Gold to Dollar Ratio Based on 1899 Gold Price
    {
        type = 'Portable', -- Do Not Put Same Model in Canoes Section
        models = {-- Only Players with Specified Job will See that Boat to Purchase in the Menu
            ['pirogue2'] = {
                label = 'Canoe',
                steamer = false,
                price = {
                    cash = 350,
                    gold = 17
                },
                inventory = {
                    enabled = true,
                    limit = 25,
                    weapons = true,
                    shared = true
                },
                job = {} -- Example: {'police', 'doctor'}
            }
        }
    },
    -----------------------------------------------------
    {
        type = 'Canoes',
        models = {
            ['canoetreetrunk'] = {
                label = 'Dugout Canoe',
                steamer = false,
                price = {
                    cash = 150,
                    gold = 7
                },
                inventory = {
                    enabled = true,
                    limit = 50,
                    weapons = true,
                    shared = true
                },
                job = {}
            },

            ['canoe'] = {
                label = 'Canoe',
                steamer = false,
                price = {
                    cash = 300,
                    gold = 15
                },
                inventory = {
                    enabled = true,
                    limit = 50,
                    weapons = true,
                    shared = true
                },
                job = {}
            },

            ['pirogue'] = {
                label = 'Pirogue Canoe',
                steamer = false,
                price = {
                    cash = 300,
                    gold = 15
                },
                inventory = {
                    enabled = true,
                    limit = 50,
                    weapons = true,
                    shared = true
                },
                job = {}
            },
        }
    },
    -----------------------------------------------------
    {
        type = 'Rowboats',
        models = {
            ['rowboat'] = {
                label = 'Rowboat',
                steamer = false,
                price = {
                    cash = 750,
                    gold = 36
                },
                inventory = {
                    enabled = true,
                    limit = 100,
                    weapons = true,
                    shared = true
                },
                job = {}
            },

            ['rowboatSwamp'] = {
                label = 'Swamp Rowboat 1',
                steamer = false,
                price = {
                    cash = 750,
                    gold = 36
                },
                inventory = {
                    enabled = true,
                    limit = 100,
                    weapons = true,
                    shared = true
                },
                job = {}
            },

            ['rowboatSwamp02'] = {
                label = 'Swamp Rowboat 2',
                steamer = false,
                price = {
                    cash = 750,
                    gold = 36
                },
                inventory = {
                    enabled = true,
                    limit = 100,
                    weapons = true,
                    shared = true
                },
                job = {}
            }
        }
    },
    -----------------------------------------------------
    {
        type = 'Steamboats',
        models = {
            ['boatsteam02x'] = {
                label = 'Steamboat',
                steamer = true,
                price = {
                    cash = 1250,
                    gold = 60
                },
                inventory = {
                    enabled = true,
                    limit = 200,
                    weapons = true,
                    shared = true
                },
                job = {}
            },

            ['keelboat'] = {
                label = 'Keelboat',
                steamer = true,
                price = {
                    cash = 1950,
                    gold = 94
                },
                inventory = {
                    enabled = true,
                    limit = 200,
                    weapons = true,
                    shared = true
                },
                job = {}
            },
        }
    },
    -----------------------------------------------------
    {
        type = 'Others',
        models = {
            ['skiff'] = {
                label = 'Skiff',
                steamer = false,
                price = {
                    cash = 250,
                    gold = 12
                },
                inventory = {
                    enabled = true,
                    limit = 50,
                    weapons = true,
                    shared = true
                },
                job = {}
            },
        }
    }
}
