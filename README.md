# bcc-boats

## Description
Are you ready for an adventure on the water? Imagine gliding down a tranquil river, surrounded by lush greenery and wildlife. Or setting out on a serene lake, with nothing but the sound of the wind. Or perhaps feeling the salty spray of the Guarma sea as you chart a course along the coastline of the island.

## Features
- Buy and sell boats through the boat shops
- Craft or Purchase a portable canoe and carry it with you to explore remote waterways
- Adjustable speed on steam-powered boats
  - Fuel usage changes with different speeds
- Boats need maintenance with a repair tool to maintain condition level
  - If condition level reaches 0 the boat will be unusable until repaired
- On steam-powered boats, if you run the engine beyond 185 psi fuel and condition levels decrease much more rapidly
  - Normal operating range is 85 - 185 psi
  - Pressure increments at 20 psi per level
- Start and Stop steam engines by increasing or decreasing steam pressure
  - Stop the engine to save fuel 
- Bonus speed in steam-powered boats with specified jobs  
- Boat Shop in Guarma with calm seas to explore
  - Can use bcc-guarma for access
- Individual inventory for owned boats (size configurable per boat model)
- Inventory can be shared / Will also allow looting
- Boats can be driven across the map without sinking
- Choose cash or gold in the menu for purchases
- Shop hours may be set individually for each shop or disabled to allow the shop to remain open
- Shop blips are colored and changeable per shop location
- Blips can change color reflecting if shop is open, closed or job locked
- Shop access can be limited by job and jobgrade
- Limit individual boat model purchases to a specified job
- Boats can be returned at any shop location via prompt
- Prompts for anchor operation
- Config setting to prevent the spawning of NPC boats
- Give your boat a special name at purchase and rename anytime using the shop menu
- Set a max number of boats per player and boatmen in the main config
- Distance-based NPC spawns
- Full boat menu system
  - Add fuel
  - Repair boat
  - Access inventory
  - Return boat remotely while away from a shop
  - Start trade system to trade boat to another player
- ox_target to interact with the shop NPC. Config option to select ox_target option. Use Redm version of [ox_target](https://github.com/MrTerabyteLK/ox_target)
- select between vorp notification or ox_lib notification system in the config.
- RedM style ox_lib notificaiton and Configuration option to change the ox_lib notification style.
- Config option to use discord webhook for send logs to discord.
- Config option to use ox_lib logging feature for use with  Loki, Datadog, FiveManage, Gray Log.
- Many new config settings!

## Commands
- Command `/boatEnter` if unable to get back to the driving position

## Attention
- If updating an existing installation
  - There is a server-side command to update the database for all of your existing boats
  - Fuel and condition values will be updated to max levels per model from the boats config file
  - Command can be found at the end of the server file
  - This only needs to be run once, *for this update*, and can then be safely deleted from the file
  - Script needs to be started in dev mode and the user needs to be an admin to access the command

- Run the sql file to install the fuel and condition items to your database
- Add the new coal and hammer images to inventory (path in installation instructions below)

## Dependencies
- [vorp_core](https://github.com/VORPCORE/vorp-core-lua)
- [vorp_inventory](https://github.com/VORPCORE/vorp_inventory-lua)
- [feather-menu](https://github.com/FeatherFramework/feather-menu/releases)
- [bcc-utils](https://github.com/BryceCanyonCounty/bcc-utils)

## Optional Dependencies if you use ox_target feature or ox_lib notification.
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/MrTerabyteLK/ox_target) This is an modified version of ox_target to work with RedM. Use the RexShack's [ox_target](https://github.com/Rexshack-RedM/ox_target) if you use RSG-Core.

## Installation
- Make sure dependencies are installed/updated and ensured before this script
- Add `bcc-boats` folder to your resources folder
- Add `ensure bcc-boats` to your `resources.cfg`
- Run the included database file `boats.sql`
- Add images to: `...\vorp_inventory\html\img`
- Restart server

## Credits
- kcrp_boats
- lrp_stable

## GitHub
- https://github.com/BryceCanyonCounty/bcc-boats