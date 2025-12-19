# bcc-boats

## Description

Embark on thrilling water adventures with **bcc-boats**! Whether you're gliding down tranquil rivers, exploring serene lakes, or navigating the salty seas of Guarma, this mod offers a comprehensive boating experience.

## Features

- **Boat Shop Integration**: Buy and sell boats through dedicated boat shops.
- **Portable Canoes**: Craft or purchase portable canoes to explore remote waterways.
- **Adjustable Speed**: Control the speed of steam-powered boats, affecting fuel usage.
- **Maintenance System**: Maintain your boat's condition with repair tools to keep it operational.
- **Steam Engine Management**: Start and stop steam engines to conserve fuel.
- **Job-Specific Bonuses**: Enjoy bonus speeds on steam-powered boats with specified jobs.
- **Guarma Exploration**: Access a boat shop in Guarma with calm seas for exploration.
- **Customizable Inventory**: Individual inventory for owned boats, configurable per boat model.
- **Inventory Sharing**: Share or loot inventories.
- **Durability**: Boats can be driven across the map without sinking.
- **Payment Options**: Choose between cash or gold for purchases.
- **Shop Customization**: Set shop hours, blip colors, and access restrictions based on jobs and job grades.
- **Boat Return System**: Return boats at any shop location via prompt or remotely using boat's menu.
- **Anchor Operation**: Prompts for anchor operation.
- **NPC Boat Control**: Config setting to prevent the spawning of NPC boats.
- **Boat Naming**: Name your boat at purchase and rename it anytime using the shop menu.
- **Player Limits**: Set a max number of boats per player and boatmen in the main config.
- **Distance-Based NPC Spawns**: NPCs spawn based on distance from player.
- **Fishing System**: Cast nets and catch fish from fishing-enabled boats with configurable timeout cooldown.
- **Comprehensive Boat Menu**:
  - Add fuel
  - Repair boat
  - Access inventory
  - Return boat remotely
  - Trade boat to another player
  - Start fishing (on fishing-enabled boats)
- **Interaction System**: (Optional) Use `ox_target` to interact with the shop NPC.
- **Notification Systems**: Choose between `vorp` or `ox_lib` notification systems.
- **Logging Options**: Use Discord webhooks or `ox_lib` logging features for integration with Loki, Datadog, FiveManage, Gray Log.
- **Extensive Config Settings**: Many new config settings for customization.

## Commands

- **`/boatEnter`**: Use this command if you are unable to get back to the driving position.

## Dependencies

- [vorp_core](https://github.com/VORPCORE/vorp-core-lua)
- [vorp_inventory](https://github.com/VORPCORE/vorp_inventory-lua)
- [feather-menu](https://github.com/FeatherFramework/feather-menu/releases)
- [feather-progressbar](https://github.com/FeatherFramework/feather-progressbar)
- [bcc-utils](https://github.com/BryceCanyonCounty/bcc-utils)
- [bcc-minigames](https://github.com/BryceCanyonCounty/bcc-minigames)

## Optional Dependencies

- [ox_lib](https://github.com/overextended/ox_lib) (Required for `ox_lib` notification and logging features)
- [ox_target](https://github.com/MrTerabyteLK/ox_target) (Modified version for RedM. Use RexShack's [ox_target](https://github.com/Rexshack-RedM/ox_target) if you use RSG-Core)

## Installation

1. **Dependencies**: Make sure all dependencies are installed/updated and ensured before this script.
2. **Resource Folder**: Download the latest release `bcc-boats.zip` at [/releases/latest](https://github.com/BryceCanyonCounty/bcc-boats/releases/latest).
3. **Resources Configuration**: Add `ensure bcc-boats` to your `server.cfg`.
4. **Database Setup**: The database will be automatically set up from `database.lua` on resource start.
5. **Inventory Images**: Add images to: `...\vorp_inventory\html\img`.
6. **Server Restart**: Restart your server to apply the changes.

## Inspiration

- **kcrp_boats**

## GitHub

- [bcc-boats](https://github.com/BryceCanyonCounty/bcc-boats)
