Config = {}

Config.defaultlang = 'en_lang'
-----------------------------------------------------

Config.devMode = false -- Default: false / DO NOT Enable on Live Server
-----------------------------------------------------

Config.oxtarget = false -- Enable or disable ox target for access shop.
Config.oxdistance = 2.0 -- Define the distance to ox target to work.

Config.notify = 'vorp' -- ox for ox_lib notification vorp for vorp notification
Config.oxposition = 'center-right' -- Ox notifiation position. use 'top' or 'top-right' or 'top-left' or 'bottom' or 'bottom-right' or 'bottom-left' or 'center-right' or 'center-left'
Config.oxstyle = { -- Ox Lib notification css style you can change this as you wish to match for your server theme
    backgroundImage = 'linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url("https://cdn.cs1.frontlineesport.com/yGexrZvPOfRu.jpg")', -- Adds a black overlay with a opacity on top of the image
    backgroundSize = 'cover',           -- Ensures the image covers the entire notification area
    backgroundRepeat = 'no-repeat',     -- Prevents the image from repeating
    backgroundPosition = 'center',      -- Centers the image
    color = '#FFFFFF',                  -- Off-white text color
    textAlign = 'center',               -- Align the text
    lineHeight = '1.4',
    width = 'auto',
    minWidth = '250px',
    maxWidth = '500px',
    ['.description'] = {
        fontSize = '17px',
        fontFamily = 'Georgia, Times, Serif',
    },
}

-----------------------------------------------------

Config.keys = {
    shop     = 0x760A9C6F, --[G] Open Boat Shop Menu
    ret      = 0x27D1C284, --[R] Return Boat to Shop at Prompt
    trade    = 0x80F28E95, --[L] Trade Boat
    loot     = 0x760A9C6F, --[G] Loot Boat Inventory
    anchor   = 0xF1301666, --[O] Operate Anchor
    increase = 0x6319DB71, --[Up Arrow] Increase Boat Speed
    decrease = 0x05CA7C52, --[Down Arrow] Decrease Boat Speed
    menu     = 0x63A0D258, --[G] Open Boat Menu
    action   = 0x760A9C6F, --[G] Open Boat Menu Off Boat
}
-----------------------------------------------------

-- Max Number of Boats per Player
Config.maxBoats = {
    players = 5, -- Default: 5
    boatman = 10 -- Default: 10
}
-----------------------------------------------------

-- Translate Label Only
Config.fuel = {
    item = 'bcc_coal', -- Default: 'bcc_coal' / Item Name in Database for Fuel Item
    label = 'Coal'     -- Default: 'Coal' / Item Label for Fuel
}
-----------------------------------------------------

-- Translate Label Only
Config.repair = {
    item = 'bcc_repair_hammer', -- Default: 'bcc_repair_hammer' / Item Name in Database for Repair Item
    label = 'Repair Hammer',    -- Default: 'Repair Hammer' / Item Label for Repair Item
    usage = 1                   -- Default: 1 / Durability Value Removed from item per Use
}
-----------------------------------------------------

-- Sell Price is 60% of Cash Price (shown below)
Config.sellPrice = 0.60 -- Default: 0.60
-----------------------------------------------------

Config.portable = {
    model = 'pirogue2', -- Default: pirogue2 / If Changeing, Adjust Models in Boats Config File
    item = 'portable_canoe'
}
-----------------------------------------------------

-- Block NPC Boat Spawns
Config.blockNpcBoats = false -- If true, will block the spawning of NPC boats
-----------------------------------------------------

Config.guarma = {
    enable = true -- Default: true / Calm the Ocean in Guarma
}
-----------------------------------------------------

-- Boatman Job
Config.boatmanOnly = false -- *Not Currently Used*
Config.boatmanJob = {
    { name = 'boatman', grade = 0 },
}
-----------------------------------------------------
-- Enable disable discord logs
Config.discordlog = false
Config.Webhook       = ''
Config.WebhookTitle  = ''
Config.WebhookAvatar = ''

-- Enable ox logging DO NOT TOUCH THIS IF YOU DON'T KNOW WHAT YOU DOING (You can use this for Loki, Datadog, FiveManage, Gray Log. Refer the ox_lib documentation)
Config.oxLogging = false
-----------------------------------------------------

Config.locations = { -- Water Locations for Portable Canoe
    [1]  = { name = 'Sea of Coronado', hash = -247856387 },
    [2]  = { name = 'San Luis River', hash = -1504425495 },
    [3]  = { name = 'Lake Don Julio', hash = -1369817450 },
    [4]  = { name = 'Flat Iron Lake', hash = -1356490953 },
    [5]  = { name = 'Upper Montana River', hash = -1781130443 },
    [6]  = { name = 'Owanjila', hash = -1300497193 },
    [7]  = { name = 'Hawks Eye Creek', hash = -1276586360 },
    [8]  = { name = 'Little Creek River', hash = -1410384421 },
    [9]  = { name = 'Dakota River', hash = 370072007 },
    [10] = { name = 'Beartooth Beck', hash = 650214731 },
    [11] = { name = 'Lake Isabella', hash = 592454541 },
    [12] = { name = 'Cattail Pond', hash = -804804953 },
    [13] = { name = 'Deadboot Creek', hash = 1245451421 },
    [14] = { name = 'Spider Gorge', hash = -218679770 },
    [15] = { name = 'O\'Creagh\'s Run', hash = -1817904483 },
    [16] = { name = 'Moonstone Pond', hash = -811730579 },
    [17] = { name = 'Kamassa River', hash = -1229593481 },
    [18] = { name = 'Elysian Pool', hash = -105598602 },
    [19] = { name = 'Heartlands Overflow', hash = 1755369577 },
    [20] = { name = 'Lagras Bayou', hash = -557290573 },
    [21] = { name = 'Lannahechee River', hash = -2040708515 },
    [22] = { name = 'Calmut Ravine', hash = 231313522 },
    [23] = { name = 'Ringneck Creek', hash = 2005774838 },
    [24] = { name = 'Stillwater Creek', hash = -1287619521 },
    [25] = { name = 'Lower Montana River', hash = -1308233316 },
    [27] = { name = 'Aurora Basin', hash = -196675805 },
    [28] = { name = 'Barrow Lagoon', hash = 795414694 },
    [29] = { name = 'Arroyo De La Vibora', hash = -49694339 },
    [30] = { name = 'Bahia De La Paz', hash = -1168459546 },
    [31] = { name = 'Dewberry Creek', hash = 469159176 },
    [32] = { name = 'Whinyard Strait', hash = -261541730 },
    [33] = { name = 'Cairn Lake', hash = -1073312073 },
    [34] = { name = 'Hot Springs', hash = 1175365009 },
    [35] = { name = 'Mattlock Pond', hash = 301094150 },
    [36] = { name = 'Southfield Flats', hash = -823661292 },
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
