---@type BCCBoatsDebugLib
local DBG = BCCBoatsDebug

local SEED_VERSION = 1

local ITEMS = {
    { 'portable_canoe', 'Portable Canoe', 1, 1, 'item_standard', 1, 'Bryce Canyon Canoes' },
    { 'bcc_coal', 'Coal', 50, 1, 'item_standard', 1, 'Fuel for steam engines.' },
    { 'bcc_repair_hammer', 'Repair Hammer', 1, 1, 'item_standard', 1, 'Tool used for repairs.' },
    { 'a_c_fishbluegil_01_ms', 'Bluegill (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Bluegill fish.' },
    { 'a_c_fishbluegil_01_sm', 'Bluegill (Small)', 10, 1, 'item_standard', 1, 'A small-sized Bluegill fish.' },
    { 'a_c_fishbullheadcat_01_ms', 'Bullhead Catfish (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Bullhead Catfish.' },
    { 'a_c_fishbullheadcat_01_sm', 'Bullhead Catfish (Small)', 10, 1, 'item_standard', 1, 'A small-sized Bullhead Catfish.' },
    { 'a_c_fishchainpickerel_01_ms', 'Chain Pickerel (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Chain Pickerel.' },
    { 'a_c_fishchainpickerel_01_sm', 'Chain Pickerel (Small)', 10, 1, 'item_standard', 1, 'A small-sized Chain Pickerel.' },
    { 'a_c_fishchannelcatfish_01_lg', 'Channel Catfish (Large)', 10, 1, 'item_standard', 1, 'A large-sized Channel Catfish.' },
    { 'a_c_fishchannelcatfish_01_xl', 'Channel Catfish (XL)', 10, 1, 'item_standard', 1, 'An extra-large Channel Catfish.' },
    { 'a_c_fishlakesturgeon_01_lg', 'Lake Sturgeon', 10, 1, 'item_standard', 1, 'A large Lake Sturgeon.' },
    { 'a_c_fishlargemouthbass_01_lg', 'Largemouth Bass (Large)', 10, 1, 'item_standard', 1, 'A large Largemouth Bass.' },
    { 'a_c_fishlargemouthbass_01_ms', 'Largemouth Bass (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Largemouth Bass.' },
    { 'a_c_fishlongnosegar_01_lg', 'Longnose Gar', 10, 1, 'item_standard', 1, 'A large Longnose Gar.' },
    { 'a_c_fishmuskie_01_lg', 'Muskie', 10, 1, 'item_standard', 1, 'A large Muskie.' },
    { 'a_c_fishnorthernpike_01_lg', 'Northern Pike', 10, 1, 'item_standard', 1, 'A large Northern Pike.' },
    { 'a_c_fishperch_01_ms', 'Perch (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Perch.' },
    { 'a_c_fishperch_01_sm', 'Perch (Small)', 10, 1, 'item_standard', 1, 'A small-sized Perch.' },
    { 'a_c_fishrainbowtrout_01_lg', 'Rainbow Trout (Large)', 10, 1, 'item_standard', 1, 'A large Rainbow Trout.' },
    { 'a_c_fishrainbowtrout_01_ms', 'Rainbow Trout (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Rainbow Trout.' },
    { 'a_c_fishredfinpickerel_01_ms', 'Redfin Pickerel (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Redfin Pickerel.' },
    { 'a_c_fishredfinpickerel_01_sm', 'Redfin Pickerel (Small)', 10, 1, 'item_standard', 1, 'A small-sized Redfin Pickerel.' },
    { 'a_c_fishrockbass_01_ms', 'Rock Bass (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Rock Bass.' },
    { 'a_c_fishrockbass_01_sm', 'Rock Bass (Small)', 10, 1, 'item_standard', 1, 'A small-sized Rock Bass.' },
    { 'a_c_fishsalmonsockeye_01_lg', 'Sockeye Salmon (Large)', 10, 1, 'item_standard', 1, 'A large Sockeye Salmon.' },
    { 'a_c_fishsalmonsockeye_01_ml', 'Sockeye Salmon (Medium-Large)', 10, 1, 'item_standard', 1, 'A medium-large Sockeye Salmon.' },
    { 'a_c_fishsalmonsockeye_01_ms', 'Sockeye Salmon (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Sockeye Salmon.' },
    { 'a_c_fishsmallmouthbass_01_lg', 'Smallmouth Bass (Large)', 10, 1, 'item_standard', 1, 'A large Smallmouth Bass.' },
    { 'a_c_fishsmallmouthbass_01_ms', 'Smallmouth Bass (Medium)', 10, 1, 'item_standard', 1, 'A medium-sized Smallmouth Bass.' },
}

local UPSERT_SQL = [[
INSERT INTO `items` (`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `desc`)
VALUES (?, ?, ?, ?, ?, ?, ?)
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `limit` = VALUES(`limit`), `can_remove` = VALUES(`can_remove`), `type` = VALUES(`type`), `usable` = VALUES(`usable`), `desc` = VALUES(`desc`);
]]

local CREATE_MIGRATIONS_SQL = [[
CREATE TABLE IF NOT EXISTS `resource_migrations` (
  `resource` VARCHAR(128) NOT NULL PRIMARY KEY,
  `version` INT NOT NULL
);
]]

local function hasAwaitMySQL()
    return (MySQL ~= nil and MySQL.query ~= nil and MySQL.query.await ~= nil) or false
end

local function waitForDB(maxAttempts, delay)
    maxAttempts = maxAttempts or 8
    delay = delay or 500
    for i = 1, maxAttempts do
        if hasAwaitMySQL() then
            local ok = pcall(function() return MySQL.query.await('SELECT 1') end)
            if ok then return true end
        else
            if exports and (exports.mysql or exports.oxmysql) then
                return true
            end
        end
        Wait(delay)
        delay = delay * 2
    end
    return false
end

local function dbExecuteAwait(sql, params)
    if hasAwaitMySQL() then
        return MySQL.update.await(sql, params)
    end
    local done, result = false, nil
    local db = exports and (exports.mysql or exports.oxmysql) or nil
    if not db then error('No DB available') end
    db:execute(sql, params or {}, function(res)
        result = res
        done = true
    end)
    local tick = 0
    while not done and tick < 100 do
        Wait(50)
        tick = tick + 1
    end
    return result
end

local function dbQueryAwait(sql, params)
    if hasAwaitMySQL() then
        return MySQL.query.await(sql, params)
    end
    local done, result = false, nil
    local db = exports and (exports.mysql or exports.oxmysql) or nil
    if not db then error('No DB available') end
    db:execute(sql, params or {}, function(res)
        result = res
        done = true
    end)
    local tick = 0
    while not done and tick < 100 do
        Wait(50)
        tick = tick + 1
    end
    return result
end

local function ensureBoatsSchema()
    local createBoats = [[
    CREATE TABLE IF NOT EXISTS `boats` (
      `id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
      `identifier` VARCHAR(50) NOT NULL,
      `charid` INT(11) NOT NULL,
      `name` VARCHAR(100) NOT NULL,
      `model` VARCHAR(100) NOT NULL,
      `fuel` INT(11) NULL,
      `condition` INT(11) NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]]
    if hasAwaitMySQL() then
        MySQL.update.await(createBoats)
    else
        dbExecuteAwait(createBoats)
    end
end

local function getMigrationVersion()
    if not waitForDB() then return 0 end
    if hasAwaitMySQL() then
        MySQL.update.await(CREATE_MIGRATIONS_SQL)
        local rows = MySQL.query.await('SELECT version FROM resource_migrations WHERE resource = ?', { GetCurrentResourceName() })
        if rows and rows[1] and rows[1].version then
            return tonumber(rows[1].version) or 0
        end
        return 0
    else
        dbExecuteAwait(CREATE_MIGRATIONS_SQL)
        local rows = dbQueryAwait('SELECT version FROM resource_migrations WHERE resource = ?', { GetCurrentResourceName() })
        if rows and rows[1] and rows[1].version then
            return tonumber(rows[1].version) or 0
        end
        return 0
    end
end

local function setMigrationVersion(v)
    if hasAwaitMySQL() then
        MySQL.update.await('INSERT INTO resource_migrations(resource, version) VALUES(?, ?) ON DUPLICATE KEY UPDATE version = VALUES(version);', { GetCurrentResourceName(), v })
    else
        dbExecuteAwait('INSERT INTO resource_migrations(resource, version) VALUES(?, ?) ON DUPLICATE KEY UPDATE version = VALUES(version);', { GetCurrentResourceName(), v })
    end
end

local function seedItems(force)
    if not Config then
        DBG.Warning('Config missing; cannot determine autoSeedDatabase setting. Skipping seeding.')
        return
    end
    if Config.autoSeedDatabase == false and not force then
        DBG.Info('autoSeedDatabase disabled in config; skipping DB seeding.')
        return
    end
    if not waitForDB() then
        DBG.Warning('Database not available after retries; skipping seeding.')
        return
    end
    local currentVersion = 0
    local ok, err = pcall(function() currentVersion = getMigrationVersion() end)
    if not ok then
        DBG.Warning(string.format('Failed to get migration version: %s', tostring(err)))
        currentVersion = 0
    end
    if currentVersion >= SEED_VERSION and not force then
        DBG.Info(string.format('Items already seeded (version %s), skipping.', tostring(currentVersion)))
        return
    end
    DBG.Info('Seeding items...')
    for _, item in ipairs(ITEMS) do
        local ok2, res = pcall(function()
            return dbExecuteAwait(UPSERT_SQL, { item[1], item[2], item[3], item[4], item[5], item[6], item[7] })
        end)
        if not ok2 then
            DBG.Error(string.format('Failed to upsert item %s: %s', tostring(item[1]), tostring(res)))
        else
            DBG.Info(string.format('Upserted item: %s', tostring(item[1])))
        end
    end
    pcall(function() setMigrationVersion(SEED_VERSION) end)
    DBG.Info(string.format('Seeding complete; set seed version to %s', tostring(SEED_VERSION)))
end

RegisterCommand('bcc-boats:seed', function(source, args, raw)
    if source ~= 0 then
        DBG.Warning('bcc-boats:seed can only be run from server console')
        return
    end
    seedItems(true)
end, true)

RegisterCommand('bcc-boats:verify', function(source, args, raw)
    if source ~= 0 then
        DBG.Warning('bcc-boats:verify can only be run from server console')
        return
    end
    if not waitForDB() then
        DBG.Warning('Database not available; cannot verify items.')
        return
    end
    local missing = {}
    for _, item in ipairs(ITEMS) do
        local rows = dbQueryAwait('SELECT item FROM items WHERE item = ?', { item[1] })
        if not rows or #rows == 0 then
            table.insert(missing, item[1])
        end
    end
    if #missing == 0 then
        DBG.Info('All items present in the items table.')
    else
        DBG.Warning(string.format('Missing items: %s', table.concat(missing, ', ')))
    end
end, true)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    CreateThread(function()
        Wait(1000)
        local ok, err = pcall(ensureBoatsSchema)
        if not ok then
        DBG.Warning(string.format('Failed to ensure boats schema: %s', tostring(err)))
        end
        seedItems(false)
    end)
end)

