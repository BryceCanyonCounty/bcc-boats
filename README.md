# BCC Boats

#### Description
This is a boating script for RedM servers using the [VORP framework](https://github.com/VORPCORE). Boats can be bought and sold through shops. There are 7 shops configured, more shop locations may be added using the `config.lua` file.

#### Features
- Buy and sell boats through the boat shops
- Chooses cash or gold in the menu for purchases
- Individual inventory for owned boats (size configurable per boat model)
- Shop hours may be set individually for each shop or disabled to allow the shop to remain open
- Shop blips are colored and changeable per shop location
- Blips can change color reflecting if shop is open, closed or job locked
- Shop access can be limited by job and jobgrade
- Boats can be returned at any shop location via prompt or remotely using the in-boat menu after parking/beaching the boat somewhere
- In-boat menu for anchor operation and remote boat return
- Config setting to prevent the spawning of NPC boats
- Boats can be driven across the map without sinking
- Give your boat a special name at purchase and rename anytime using the menu
- Set a max number of boats per player in the config

#### Commands
`/boatEnter` To be used in F8 console if unable to get back to the driving position

#### Configuration
Settings can be changed in the `config.lua` file. Here is an example of one shop:
```lua
    lagras = {
        shopName = "Lagras Boats", -- Name of Shop on Menu
        promptName = "Lagras Boats", -- Text Below the Prompt Button
        blipAllowed = true, -- Turns Blips On / Off
        blipName = "Lagras Boats", -- Name of the Blip on the Map
        blipSprite = 2005921736, -- 2005921736 = Canoe / -1018164873 = Tugboat
        blipColorOpen = "BLIP_MODIFIER_MP_COLOR_32", -- Shop Open - Default: White - Blip Colors Shown Below
        blipColorClosed = "BLIP_MODIFIER_MP_COLOR_10", -- Shop Closed - Default: Red - Blip Colors Shown Below
        blipColorJob = "BLIP_MODIFIER_MP_COLOR_23", -- Shop Job Locked - Default: Yellow - Blip Colors Shown Below
        npc = {x = 2123.95, y = -551.63, z = 41.53, h = 113.62}, -- Blip and NPC Positions
        spawn = {x = 2131.6, y = -543.66, z = 40.73, h = 46.62}, -- Boat Spawn and Return Positions
        player = {x = 2122.87, y = -551.68, z = 42.52, h = 284.48}, -- Player Return Teleport Position
        boatCam = {x = 2122.92, y = -548.97, z = 42.46}, -- Camera Location to View Boat When In-Menu
        distanceShop = 2.0, -- Distance from NPC to Get Menu Prompt
        distanceReturn = 6.0, -- Distance from Shop to Get Return Prompt
        npcAllowed = true, -- Turns NPCs On / Off
        npcModel = "A_M_M_UniBoatCrew_01", -- Sets Model for NPCs
        allowedJobs = {}, -- Empty, Everyone Can Use / Insert Job to limit access - ex. "police"
        jobGrade = 0, -- Enter Minimum Rank / Job Grade to Access Shop
        shopHours = false, -- If You Want the Shops to Use Open and Closed Hours
        shopOpen = 7, -- Shop Open Time / 24 Hour Clock
        shopClose = 21, -- Shop Close Time / 24 Hour Clock
        boats = { -- Gold to Dollar Ratio Based on 1899 Gold Price / sellPrice is 60% of cashPrice
            {
                boatType = "Canoes",
                ["canoetreetrunk"] = { label = "Dugout Canoe",  cashPrice = 150,   goldPrice = 7,   sellPrice = 90,  invLimit = 50 },
                ["canoe"]          = { label = "Canoe",         cashPrice = 300,   goldPrice = 15,  sellPrice = 180, invLimit = 50 },
                ["pirogue"]        = { label = "Pirogue Canoe", cashPrice = 300,   goldPrice = 15,  sellPrice = 180, invLimit = 50 }
            },
            {
                boatType = "Rowboats",
                ["skiff"]          = { label = "Skiff",         cashPrice = 500,  goldPrice = 24,  sellPrice = 300, invLimit = 100 },
                ["rowboat"]        = { label = "Rowboat",       cashPrice = 750,  goldPrice = 36,  sellPrice = 450, invLimit = 100 },
                ["rowboatSwamp"]   = { label = "Swamp Rowboat", cashPrice = 750,  goldPrice = 36,  sellPrice = 450, invLimit = 100 }
            },
            {
                boatType = "Steamboats",
                ["boatsteam02x"]   = { label = "Steamboat",     cashPrice = 1250,  goldPrice = 60, sellPrice = 750,  invLimit = 200 },
                ["keelboat"]       = { label = "Keelboat",      cashPrice = 1950,  goldPrice = 94, sellPrice = 1170, invLimit = 200 }
            }
        }
    },
```

#### Dependencies
- [vorp_core](https://github.com/VORPCORE/vorp-core-lua)
- [vorp_inventory](https://github.com/VORPCORE/vorp_inventory-lua)
- [menuapi](https://github.com/outsider31000/menuapi)

#### Installation
- Ensure that the dependancies are added and started
- Add `bcc-boats` folder to your resources folder
- Add `ensure bcc-boats` to your `resources.cfg`
- Run the included database file `boats.sql`

#### Credits
- kcrp_boats
