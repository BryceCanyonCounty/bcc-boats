Boats = { -- Gold to Dollar Ratio Based on 1899 Gold Price
    -----------------------------------------------------
    -- Portable Canoe
    -----------------------------------------------------
    {
        type = 'Portable',
        models = {
            ['pirogue2'] = {     -- Do Not Put Same Model in Canoes Section
                label = 'Canoe', -- Label to Display in Shop Menu
                distance = 5,    -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 350,  -- Price in Cash
                    gold = 17    -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = false,     -- Set true to spawn boat in anchored state
                steamer = false,      -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = false,  -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,  -- Only works with Steamboat Type
                    increment = 50.0, -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,     -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}         -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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
                label = 'Dugout Canoe', -- Label to Display in Shop Menu
                distance = 5,           -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 150,         -- Price in Cash
                    gold = 7            -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = false,      -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = false,  -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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
                label = 'Canoe', -- Label to Display in Shop Menu
                distance = 5,    -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 300,  -- Price in Cash
                    gold = 15    -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = false,      -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = false,  -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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
                label = 'Pirogue Canoe', -- Label to Display in Shop Menu
                distance = 5,            -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 300,          -- Price in Cash
                    gold = 15            -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = false,      -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = false,  -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 50,     -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            }
        }
    },
    -----------------------------------------------------
    -- Rowboats
    -----------------------------------------------------
    {
        type = 'Rowboats',
        models = {
            ['rowboat'] = {
                label = 'Rowboat', -- Label to Display in Shop Menu
                distance = 5,      -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 750,    -- Price in Cash
                    gold = 36      -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = false,      -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = false,  -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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
                label = 'Swamp Rowboat 1', -- Label to Display in Shop Menu
                distance = 5,              -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 750,            -- Price in Cash
                    gold = 36              -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = false,      -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = false,  -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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
                label = 'Swamp Rowboat 2', -- Label to Display in Shop Menu
                distance = 5,              -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 750,            -- Price in Cash
                    gold = 36              -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = false,      -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = false,  -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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
                label = 'Steamboat', -- Label to Display in Shop Menu
                distance = 5,        -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 1250,     -- Price in Cash
                    gold = 60        -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = true,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = true,   -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = true,    -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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
                label = 'Keelboat', -- Label to Display in Shop Menu
                distance = 5,       -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 1950,    -- Price in Cash
                    gold = 94       -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = true,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = true,   -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = true,    -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 200,    -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            }
        }
    },
    -----------------------------------------------------
    -- Large Boats
    -----------------------------------------------------
    {
        type = 'Large Boats',
        models = {
            ['ship_nbdGuama'] = {
                label = 'Guarma Ship', -- Label to Display in Shop Menu
                distance = 10,         -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 4950,       -- Price in Cash
                    gold = 239          -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = true,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = true,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = true,   -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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

            ['turbineboat'] = {
                label = 'Turbine Boat', -- Label to Display in Shop Menu
                distance = 10,          -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 4950,        -- Price in Cash
                    gold = 239           -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = true,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = true,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = true,   -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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

            ['tugboat2'] = {
                label = 'Tugboat', -- Label to Display in Shop Menu
                distance = 10,     -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 3950,   -- Price in Cash
                    gold = 191      -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = true,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = true,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = true,   -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
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

            ['horseBoat'] = {
                label = 'Horse Boat', -- Label to Display in Shop Menu
                distance = 10,        -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 3950,      -- Price in Cash
                    gold = 191         -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = true,      -- Set false to spawn boat in un-anchored state
                steamer = true,       -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = true,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = true,   -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 200,    -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            }
        }
    },
    -----------------------------------------------------
    -- Other Boats
    -----------------------------------------------------
    {
        type = 'Others',
        models = {
            ['skiff'] = {
                label = 'Skiff', -- Label to Display in Shop Menu
                distance = 5,    -- Default: 5 / Distance from Boat to Show Prompts / Open Menu
                price = {
                    cash = 250,  -- Price in Cash
                    gold = 12    -- Price in Gold
                },
                blip = {
                    enabled = true,    -- Set false to Disable Blip
                    sprite = 62421675, -- Default: 62421675 / 'blip_canoe'
                },
                gamerTag = {
                    enabled = true,   -- Default: true / Places Boat Name Above Boat When Empty
                    distance = 15     -- Default: 15 / Distance from Boat to Show Tag
                },
                anchored = false,     -- Set true to spawn boat in anchored state
                steamer = false,      -- Set true if Boat is Steam Powered (Adds Prompts for Steam Engine)
                isLarge = false,      -- Set true Only if Boat is 'Large Boats' Type
                fuel = {              -- Only works with Steam Powered Boats
                    enabled = false,  -- Set false to Disable Fuel Use
                    maxAmount = 100,  -- Maximum Fuel Capacity
                    itemAmount = 1,   -- Number of Items Used per 'decreaseTime' Interval
                    decreaseTime = 30 -- Time, in Seconds, to Decrease Fuel Level by 'itemAmount'
                },
                condition = {
                    enabled = true,    -- Set false to Disable Condition Decrease
                    maxAmount = 100,   -- Maximum Condition Value
                    itemAmount = 1,    -- Number of Items Needed to Repair Boat
                    decreaseTime = 60, -- Time, in Seconds, to Decrease Condition Level by 'itemAmount'
                    repairValue = 25   -- Value to Increase Condition by When Using Repair Item
                },
                speed = {
                    enabled = false,   -- Only works with Steamboat Type
                    increment = 50.0,  -- Default: 50.0 / Speed Increase per PSI Level
                    bonus = 25.0,      -- Default: 25.0 / Bonus speed added to increment with required job
                    jobs = {}          -- Example: { {name = 'police', grade = 1}, {name = 'doctor', grade = 0} } / Job/Grade required to get bonus speed
                },
                inventory = {
                    enabled = true, -- Set false to Disable Inventory
                    limit = 50,     -- Maximum Inventory Limit
                    weapons = true, -- Set false to Disable Weapons
                    shared = true   -- Set false to Disable Shared Inventory
                },
                -- Only Players with Specified Job will See that Boat to Purchase in the Menu
                job = {} -- Example: {'police', 'doctor'}
            }
        }
    }
}
