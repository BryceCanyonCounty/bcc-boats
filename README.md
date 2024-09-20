# bcc-boats

## Description
Are you ready for an adventure on the water? Imagine gliding down a tranquil river, surrounded by lush greenery and wildlife. Or setting out on a serene lake, with nothing but the sound of the wind. Or perhaps feeling the salty spray of the Guarma sea as you chart a course along the coastline of the island.

## Features
- Buy and sell boats through the boat shops
- Craft or Purchase a portable canoe and carry it with you to explore remote waterways
- Adjustable speed on steam-powered boats
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
- Limit individual boat purchases to a specified job
- Boats can be returned at any shop location via prompt
- Prompts for anchor operation, remote boat return and boat trades
- Config setting to prevent the spawning of NPC boats
- Give your boat a special name at purchase and rename anytime using the menu
- Set a max number of boats per player and boatmen in the main config
- Distance-based NPC spawns
- Start and Stop steam engines by increasing or decreasing steam pressure
- Bonus speed in steam-powered boats with specified jobs

## Coming Soon
- Fuel usage in steam boats
- Boat condition / Repairs on all boats

## Commands
- Command `/boatEnter` if unable to get back to the driving position

## Dependencies
- [vorp_core](https://github.com/VORPCORE/vorp-core-lua)
- [vorp_inventory](https://github.com/VORPCORE/vorp_inventory-lua)
- [vorp_menu](https://github.com/VORPCORE/vorp_menu)
- [bcc-utils](https://github.com/BryceCanyonCounty/bcc-utils)

## Installation
- Make sure dependencies are installed/updated and ensured before this script
- Add `bcc-boats` folder to your resources folder
- Add `ensure bcc-boats` to your `resources.cfg`
- Run the included database file `boats.sql`
- Add canoe image to: `...\vorp_inventory\html\img`
- Restart server

## Credits
- kcrp_boats
- lrp_stable

## GitHub
- https://github.com/BryceCanyonCounty/bcc-boats