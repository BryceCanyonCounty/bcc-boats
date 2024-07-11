local Core = exports.vorp_core:GetCore()

Core.Callback.Register('bcc-boats:BuyBoat', function(source, cb, data)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier
    local maxBoats = Config.maxBoats.players
    if data.isBoatman then
        maxBoats = Config.maxBoats.boatman
    end
    local model = data.Model
    local portable = Config.portable.model

    local boats = MySQL.query.await('SELECT * FROM `boats` WHERE `charid` = ?', { charid })
    if #boats >= maxBoats then
        Core.NotifyRightTip(src, _U('boatLimit') .. maxBoats .. _U('boats'), 4000)
        return cb(false)
    end
    if model == portable then
        for i = 1, #boats do
            if boats[i].model == portable then
                Core.NotifyRightTip(src, _U('ownPortable'), 4000)
                return cb(false)
            end
        end
    end
    if data.IsCash then
        if character.money >= data.CashPrice then
            cb(true)
        else
            Core.NotifyRightTip(src, _U('shortCash'), 4000)
            return cb(false)
        end
    else
        if character.gold >= data.GoldPrice then
            cb(true)
        else
            Core.NotifyRightTip(src, _U('shortGold'), 4000)
            return cb(false)
        end
    end
end)

Core.Callback.Register('bcc-boats:SaveNewBoat', function(source, cb, data, name)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local identifier = character.identifier
    local charid = character.charIdentifier
    local model = data.Model

    MySQL.query.await('INSERT INTO `boats` (identifier, charid, name, model) VALUES (?, ?, ?, ?)', { identifier, charid, name, model })
    if data.IsCash then
        character.removeCurrency(0, data.CashPrice)
    else
        character.removeCurrency(1, data.GoldPrice)
    end

    if model == Config.portable.model then
        exports.vorp_inventory:addItem(src, 'portable_canoe', 1)
    end
    cb(true)
end)

Core.Callback.Register('bcc-boats:SaveNewCraft', function(source, cb, model, name)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local identifier = character.identifier
    local charid = character.charIdentifier

    MySQL.query.await('INSERT INTO `boats` (identifier, charid, name, model) VALUES (?, ?, ?, ?)', { identifier, charid, name, model })
    cb(true)
end)

Core.Callback.Register('bcc-boats:UpdateBoatName', function(source, cb, data, name)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier

    MySQL.query.await('UPDATE `boats` SET `name` = ? WHERE `charid` = ? AND `id` = ?', { name, charid, data.BoatId })
    cb(true)
end)

Core.Callback.Register('bcc-boats:GetBoats', function(source, cb)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier
    local hasPortable = exports.vorp_inventory:getItem(src, 'portable_canoe')

    if hasPortable == nil then
        MySQL.query.await('DELETE FROM `boats` WHERE `charid` = ? AND `model` = ?', { charid, Config.portable.model })
    end

    local boats = MySQL.query.await('SELECT * FROM `boats` WHERE `charid` = ?', { charid })
    cb(boats)
end)

exports.vorp_inventory:registerUsableItem('portable_canoe', function(data)
    local src = data.source
    local user = Core.getUser(src)
    if not user then return end
    local character = user.getUsedCharacter
    local identifier = character.identifier
    local charid = character.charIdentifier
    local hasPortable = nil
    local model = Config.portable.model

    exports.vorp_inventory:closeInventory(src)
    local boats = MySQL.query.await('SELECT * FROM `boats` WHERE `identifier` = ? AND `charid` = ?', {identifier, charid})
    for i = 1, #boats do
        if boats[i].model == model then
            hasPortable = true
            TriggerClientEvent('bcc-boats:SpawnBoat', src, boats[i].id, boats[i].model, boats[i].name, true)
        end
    end
    if not hasPortable then
        local charJob = character.job
        local jobGrade = character.jobGrade
        local isBoatman = false
        isBoatman = CheckPlayerJob(charJob, jobGrade, Config.boatmanJob)

        local maxBoats = Config.maxBoats.players
        if isBoatman then
            maxBoats = Config.maxBoats.boatman
        end

        if #boats >= maxBoats then
            Core.NotifyRightTip(src, _U('boatLimit') .. maxBoats .. _U('boats'), 4000)
            return
        end
        TriggerClientEvent('bcc-boats:SetBoatName', src, model, false, true)
    end
end)

Core.Callback.Register('bcc-boats:SellBoat', function(source, cb, data)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier
    local modelBoat = nil
    local boatId = tonumber(data.BoatId)

    local boats = MySQL.query.await('SELECT * FROM `boats` WHERE `charid` = ?', { charid })
    for i = 1, #boats do
        if tonumber(boats[i].id) == boatId then
            modelBoat = boats[i].model
            if modelBoat == Config.portable.model then
                exports.vorp_inventory:subItem(src, 'portable_canoe', 1)
            end
            MySQL.query.await('DELETE FROM `boats` WHERE `charid` = ? AND `id` = ?', { charid, boatId })
        end
    end
    for _, boatModels in pairs(Boats) do
        for model, boatConfig in pairs(boatModels.models) do
            if model == modelBoat then
                local sellPrice = (Config.sellPrice * boatConfig.price.cash)
                character.addCurrency(0, sellPrice)
                Core.NotifyRightTip(src, _U('soldBoat') .. data.BoatName .. _U('frcash') .. sellPrice, 4000)
                cb(true)
            end
        end
    end
end)

Core.Callback.Register('bcc-boats:SaveBoatTrade', function(source, cb, serverId, boatId)
    -- Current Owner
    local src = source
    local curUser = Core.getUser(src)
    if not curUser then return cb(false) end
    local curCharacter = curUser.getUsedCharacter
    local curName = curCharacter.firstname .. " " .. curCharacter.lastname
    -- New Owner
    local newUser = Core.getUser(serverId)
    local newCharacter = newUser.getUsedCharacter
    local newId = newCharacter.identifier
    local newCharId = newCharacter.charIdentifier
    local newName = newCharacter.firstname .. " " .. newCharacter.lastname
    local charJob = newCharacter.job
    local jobGrade = newCharacter.jobGrade

    local isBoatman = false
    isBoatman = CheckPlayerJob(charJob, jobGrade, Config.boatmanJob)
    local maxBoats = Config.maxBoats.players
    if isBoatman then
        maxBoats = Config.maxBoats.boatman
    end
    local boats = MySQL.query.await('SELECT * FROM `boats` WHERE `charid` = ?', { newCharId })
    if #boats >= maxBoats then
        Core.NotifyRightTip(src, _U('tradeFailed') .. newName .. _U('tooManyBoats'), 5000)
        return cb(false)
    end

    MySQL.query.await('UPDATE `boats` SET `identifier` = ?, `charid` = ? WHERE `id` = ?', { newId, newCharId, boatId })

    Core.NotifyRightTip(src, _U('youGave') .. newName .. _U('aBoat'), 4000)
    Core.NotifyRightTip(serverId, curName .._U('gaveBoat'), 4000)
    cb(true)
end)

RegisterServerEvent('bcc-boats:RegisterInventory', function(id, boatModel)
    local isRegistered = exports.vorp_inventory:isCustomInventoryRegistered('boat_' .. tostring(id))
    if isRegistered then return end

    for _, boatModels in pairs(Boats) do
        for model, boatConfig in pairs(boatModels.models) do
            if model == boatModel then
                local data = {
                    id = 'boat_' .. tostring(id),
                    name = _U('boatInv'),
                    limit = tonumber(boatConfig.inventory.limit),
                    acceptWeapons = boatConfig.inventory.weapons,
                    shared = boatConfig.inventory.shared,
                    ignoreItemStackLimit = true,
                    whitelistItems = false,
                    UsePermissions = false,
                    UseBlackList = false,
                    whitelistWeapons = false
                }
                exports.vorp_inventory:registerInventory(data)
            end
        end
    end
end)

RegisterServerEvent('bcc-boats:OpenInventory', function(id)
    local src = source
    exports.vorp_inventory:openInventory(src, 'boat_' .. tostring(id))
end)

Core.Callback.Register('bcc-boats:CheckJob', function(source, cb, boatman, site)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charJob = character.job
    local jobGrade = character.jobGrade

    local jobConfig
    if boatman then
        jobConfig = Config.boatmanJob
    else
        jobConfig = Sites[site].shop.jobs
    end
    local hasJob = false
    hasJob = CheckPlayerJob(charJob, jobGrade, jobConfig)
    if hasJob then
        cb({true, charJob})
    else
        cb({false, charJob})
    end
end)

function CheckPlayerJob(charJob, jobGrade, jobConfig)
    for _, job in pairs(jobConfig) do
        if (charJob == job.name) and (tonumber(jobGrade) >= tonumber(job.grade)) then
            return true
        end
    end
end

-- Prevent NPC Boat Spawns
if Config.blockNpcBoats then
    AddEventHandler('entityCreating', function(entity)
        if GetEntityType(entity) == 2 and GetVehicleType(entity) == 'boat' then
            if GetEntityPopulationType(entity) ~= 7 and GetEntityPopulationType(entity) ~= 8 then
                CancelEvent()
            end
        end
    end)
end
