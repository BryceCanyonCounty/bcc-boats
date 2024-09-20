Boats = { -- Gold to Dollar Ratio Based on 1899 Gold Price
    -----------------------------------------------------
    -- Portable Canoe
    -----------------------------------------------------
    {
        type = 'Portable',
        models = {
            ['pirogue2'] = {           -- Do Not Put Same Model in Canoes Section
                label = 'Canoe',       -- Label to Display in Menu
                price = {
                    cash = 350,        -- Price in Cash
                    gold = 17          -- Price in Gold
                },
                anchored = false,      -- Set true to spawn boat in anchored state
                steamer = false,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = false,   -- Set false to Disable Fuel Use
                    maxAmount = 100,   -- Maximum Fuel Capacity
                    itemAmount = 5,    -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5 -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 25,     -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            }
        }
    },
    -----------------------------------------------------
    -- Canoes
    -----------------------------------------------------
    {
        type = 'Canoes',
        models = {
            ['canoetreetrunk'] = {
                label = 'Dugout Canoe', -- Label to Display in Menu
                price = {
                    cash = 150,         -- Price in Cash
                    gold = 7            -- Price in Gold
                },
                anchored = false,       -- Set true to spawn boat in anchored state
                steamer = false,        -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = false,    -- Set false to Disable Fuel Use
                    maxAmount = 100,    -- Maximum Fuel Capacity
                    itemAmount = 5,     -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30,  -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5  -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 50,     -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            },
            -----------------------------------------------------

            ['canoe'] = {
                label = 'Canoe',       -- Label to Display in Menu
                price = {
                    cash = 300,        -- Price in Cash
                    gold = 15          -- Price in Gold
                },
                anchored = false,      -- Set true to spawn boat in anchored state
                steamer = false,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = false,   -- Set false to Disable Fuel Use
                    maxAmount = 100,   -- Maximum Fuel Capacity
                    itemAmount = 5,    -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5 -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 50,     -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            },
            -----------------------------------------------------

            ['pirogue'] = {
                label = 'Pirogue Canoe', -- Label to Display in Menu
                price = {
                    cash = 300,          -- Price in Cash
                    gold = 15            -- Price in Gold
                },
                anchored = false,        -- Set true to spawn boat in anchored state
                steamer = false,         -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = false,     -- Set false to Disable Fuel Use
                    maxAmount = 100,     -- Maximum Fuel Capacity
                    itemAmount = 5,      -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30,   -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5   -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 50,     -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            },
        }
    },
    -----------------------------------------------------
    -- Rowboats
    -----------------------------------------------------
    {
        type = 'Rowboats',
        models = {
            ['rowboat'] = {
                label = 'Rowboat',     -- Label to Display in Menu
                price = {
                    cash = 750,        -- Price in Cash
                    gold = 36          -- Price in Gold
                },
                anchored = false,      -- Set true to spawn boat in anchored state
                steamer = false,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = false,   -- Set false to Disable Fuel Use
                    maxAmount = 100,   -- Maximum Fuel Capacity
                    itemAmount = 5,    -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5 -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 100,    -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            },
            -----------------------------------------------------

            ['rowboatSwamp'] = {
                label = 'Swamp Rowboat 1', -- Label to Display in Menu
                price = {
                    cash = 750,            -- Price in Cash
                    gold = 36              -- Price in Gold
                },
                anchored = false,          -- Set true to spawn boat in anchored state
                steamer = false,           -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = false,       -- Set false to Disable Fuel Use
                    maxAmount = 100,       -- Maximum Fuel Capacity
                    itemAmount = 5,        -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30,     -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5     -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 100,    -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            },
            -----------------------------------------------------

            ['rowboatSwamp02'] = {
                label = 'Swamp Rowboat 2', -- Label to Display in Menu
                price = {
                    cash = 750,            -- Price in Cash
                    gold = 36              -- Price in Gold
                },
                anchored = false,          -- Set true to spawn boat in anchored state
                steamer = false,           -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = false,       -- Set false to Disable Fuel Use
                    maxAmount = 100,       -- Maximum Fuel Capacity
                    itemAmount = 5,        -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30,     -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5     -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 100,    -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            }
        }
    },
    -----------------------------------------------------
    -- Steamboats
    -----------------------------------------------------
    {
        type = 'Steamboats',
        models = {
            ['boatsteam02x'] = {
                label = 'Steamboat',   -- Label to Display in Menu
                price = {
                    cash = 1250,       -- Price in Cash
                    gold = 60          -- Price in Gold
                },
                anchored = true,       -- Set true to spawn boat in anchored state
                steamer = true,        -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = true,    -- Set false to Disable Fuel Use
                    maxAmount = 100,   -- Maximum Fuel Capacity
                    itemAmount = 5,    -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5 -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 200,    -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            },
            -----------------------------------------------------

            ['keelboat'] = {
                label = 'Keelboat',    -- Label to Display in Menu
                price = {
                    cash = 1950,       -- Price in Cash
                    gold = 94          -- Price in Gold
                },
                anchored = true,       -- Set true to spawn boat in anchored state
                steamer = true,        -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = true,    -- Set false to Disable Fuel Use
                    maxAmount = 100,   -- Maximum Fuel Capacity
                    itemAmount = 5,    -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5 -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 200,    -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            },
        }
    },
    -----------------------------------------------------
    -- Other Boats
    -----------------------------------------------------
    {
        type = 'Others',
        models = {
            ['skiff'] = {
                label = 'Skiff',       -- Label to Display in Menu
                price = {
                    cash = 250,        -- Price in Cash
                    gold = 12          -- Price in Gold
                },
                anchored = false,      -- Set true to spawn boat in anchored state
                steamer = false,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                fuel = {
                    enabled = false,   -- Set false to Disable Fuel Use
                    maxAmount = 100,   -- Maximum Fuel Capacity
                    itemAmount = 5,    -- Number of Items Needed to Fuel Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Fuel Level
                    decreaseAmount = 5 -- Amount of Fuel to Decrease
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition
                    itemAmount = 5,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 30, -- Time in Seconds to Decrease Condition Level
                    decreaseAmount = 5 -- Amount of Condition to Decrease
                },
                speed = {              -- Only works with Steamboats
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}           -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 50,     -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            },
        }
    }
}
