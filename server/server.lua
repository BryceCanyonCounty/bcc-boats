local Core = exports.vorp_core:GetCore()

local function CheckPlayerJob(charJob, jobGrade, jobConfig)
    for _, job in pairs(jobConfig) do
        if (charJob == job.name) and (tonumber(jobGrade) >= tonumber(job.grade)) then
            return true
        end
    end
end

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

    for _, boatModels in pairs(Boats) do
        for modelBoat, boatConfig in pairs(boatModels.models) do
            if model == modelBoat then
                if data.IsCash then
                    if character.money >= boatConfig.price.cash then
                        cb(true)
                    else
                        Core.NotifyRightTip(src, _U('shortCash'), 4000)
                        return cb(false)
                    end
                else
                    if character.gold >= boatConfig.price.gold then
                        cb(true)
                    else
                        Core.NotifyRightTip(src, _U('shortGold'), 4000)
                        return cb(false)
                    end
                end
            end
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
    local cash = data.IsCash

    for _, boatModels in pairs(Boats) do
        for modelBoat, boatConfig in pairs(boatModels.models) do
            if model == modelBoat then
                if (cash) and (character.money >= boatConfig.price.cash) then
                    character.removeCurrency(0, boatConfig.price.cash)
                elseif (not cash) and (character.gold >= boatConfig.price.gold) then
                    character.removeCurrency(1, boatConfig.price.gold)
                else
                    if cash then
                        Core.NotifyRightTip(src, _U('shortCash'), 4000)
                    elseif not cash then
                        Core.NotifyRightTip(src, _U('shortGold'), 4000)
                    end
                    return cb(true)
                end
                local fuel = boatConfig.fuel.maxAmount
                local condition = boatConfig.condition.maxAmount
                MySQL.query.await('INSERT INTO `boats` (`identifier`, `charid`, `name`, `model`, `fuel`, `condition`) VALUES (?, ?, ?, ?, ?, ?)',
                    { identifier, charid, name, model, fuel, condition })
                break
            end
        end
    end

    if model == Config.portable.model then
        exports.vorp_inventory:addItem(src, Config.portable.item, 1)
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

    for _, boatModels in pairs(Boats) do
        for modelBoat, boatConfig in pairs(boatModels.models) do
            if model == modelBoat then
                local fuel = boatConfig.fuel.maxAmount
                local condition = boatConfig.condition.maxAmount
                MySQL.query.await('INSERT INTO `boats` (`identifier`, `charid`, `name`, `model`, `fuel`, `condition`) VALUES (?, ?, ?, ?, ?, ?)',
                    { identifier, charid, name, model, fuel, condition })
                break
            end
        end
    end

    cb(true)
end)

Core.Callback.Register('bcc-boats:UpdateBoatName', function(source, cb, data, name)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local identifier = character.identifier
    local charid = character.charIdentifier

    MySQL.query.await('UPDATE `boats` SET `name` = ? WHERE `charid` = ? AND `identifier` = ? AND `id` = ?',
    { name, charid, identifier, data.BoatId })
    cb(true)
end)

Core.Callback.Register('bcc-boats:GetBoats', function(source, cb)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local identifier = character.identifier
    local charid = character.charIdentifier
    local hasPortable = exports.vorp_inventory:getItem(src, Config.portable.item)

    if hasPortable == nil then
        MySQL.query.await('DELETE FROM `boats` WHERE `charid` = ? AND `identifier` = ? AND `model` = ?',
        { charid, identifier, Config.portable.model })
    end

    local boats = MySQL.query.await('SELECT * FROM `boats` WHERE `charid` = ? AND `identifier` = ?',
    { charid, identifier })
    cb(boats)
end)

exports.vorp_inventory:registerUsableItem(Config.portable.item, function(data)
    local src = data.source
    local user = Core.getUser(src)
    if not user then return end
    local character = user.getUsedCharacter
    local identifier = character.identifier
    local charid = character.charIdentifier
    local hasPortable = false
    local model = Config.portable.model

    exports.vorp_inventory:closeInventory(src)
    local boats = MySQL.query.await('SELECT * FROM `boats` WHERE `identifier` = ? AND `charid` = ?',
    {identifier, charid})
    for i = 1, #boats do
        if boats[i].model == model then
            hasPortable = true
            TriggerClientEvent('bcc-boats:SpawnBoat', src, boats[i].id, boats[i].model, boats[i].name, true)
            break
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
    local identifier = character.identifier
    local charid = character.charIdentifier
    local modelBoat = nil
    local boatId = tonumber(data.BoatId)

    local boats = MySQL.query.await('SELECT * FROM `boats` WHERE `charid` = ? AND `identifier` = ?',
    { charid, identifier })
    for i = 1, #boats do
        if tonumber(boats[i].id) == boatId then
            modelBoat = boats[i].model
            if modelBoat == Config.portable.model then
                exports.vorp_inventory:subItem(src, Config.portable.item, 1)
            end
            MySQL.query.await('DELETE FROM `boats` WHERE `charid` = ? AND `identifier` = ? AND `id` = ?',
            { charid, identifier, boatId })
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

Core.Callback.Register('bcc-boats:SaveBoatTrade', function(source, cb, serverId, boatId, boatModel)
    -- Current Owner
    local src = source
    local curUser = Core.getUser(src)
    if not curUser then return cb(false) end
    local curCharacter = curUser.getUsedCharacter
    local curName = curCharacter.firstname .. " " .. curCharacter.lastname
    -- New Owner
    local newUser = Core.getUser(serverId)
    if not newUser then return cb(false) end
    local newCharacter = newUser.getUsedCharacter
    local newIdentifier = newCharacter.identifier
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
    local boats = MySQL.query.await('SELECT * FROM `boats` WHERE `charid` = ? AND `identifier` = ?',
    { newCharId, newIdentifier })
    if #boats >= maxBoats then
        Core.NotifyRightTip(src, _U('tradeFailed') .. newName .. _U('tooManyBoats'), 5000)
        return cb(false)
    end

    MySQL.query.await('UPDATE `boats` SET `identifier` = ?, `charid` = ? WHERE `id` = ? AND `model` = ?',
    { newIdentifier, newCharId, boatId, boatModel })

    Core.NotifyRightTip(src, _U('youGave') .. newName .. _U('aBoat'), 4000)
    Core.NotifyRightTip(serverId, curName .._U('gaveBoat'), 4000)
    cb(true)
end)

RegisterServerEvent('bcc-boats:RegisterInventory', function(id, boatModel)
    local src = source
    local user = Core.getUser(src)
    if not user then return end
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
    local user = Core.getUser(src)
    if not user then return end
    exports.vorp_inventory:openInventory(src, 'boat_' .. tostring(id))
end)

Core.Callback.Register('bcc-boats:GetFuelLevel', function(source, cb, MyBoatId)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier

    local fuelLevel = MySQL.query.await('SELECT `fuel` FROM `boats` WHERE `id` = ? AND charid = ?', { MyBoatId, charid })
    if fuelLevel and fuelLevel[1] then
        cb(fuelLevel[1].fuel)
    else
        cb(false)
    end
end)

Core.Callback.Register('bcc-boats:UpdateFuelLevel', function(source, cb, myBoatId, myBoatModel)
    local src = source
    local user = Core.getUser(src)
    if not user then return end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier

    local boatData = MySQL.query.await('SELECT * FROM `boats` WHERE `id` = ? AND `model` = ? AND charid = ?', { myBoatId, myBoatModel, charid })
    if not boatData or not boatData[1] then return cb(false) end

    local boatCfg = nil
    for _, boatModels in pairs(Boats) do
        for model, boatConfig in pairs(boatModels.models) do
            if myBoatModel == model then
                boatCfg = boatConfig
                break
            end
        end
    end

    if not boatCfg then return cb(false) end

    local updateLevel = boatData[1].fuel - boatCfg.fuel.itemAmount

    MySQL.query.await('UPDATE `boats` SET `fuel` = ? WHERE `id` = ? AND `charid` = ?', { updateLevel, myBoatId, charid })

    cb(updateLevel)
end)

Core.Callback.Register('bcc-boats:GetFuelCount', function(source, cb)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end

    local fuelCount = exports.vorp_inventory:getItemCount(src, nil, Config.fuel.item)
    if fuelCount then
        cb(fuelCount)
    else
        cb(false)
    end
end)

Core.Callback.Register('bcc-boats:AddBoatFuel', function(source, cb, myBoatId, myBoatModel, amount)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier
    local item = Config.fuel.item

    local boatData = MySQL.query.await('SELECT * FROM `boats` WHERE `id` = ? AND `model` = ? AND charid = ?', { myBoatId, myBoatModel, charid })
    if not boatData or not boatData[1] then return cb(false) end

    local boatCfg = nil
    for _, boatModels in pairs(Boats) do
        for model, boatConfig in pairs(boatModels.models) do
            if myBoatModel == model then
                boatCfg = boatConfig
                break
            end
        end
    end

    if not boatCfg then return cb(false) end

    local newLevel = boatData[1].fuel + amount
    if newLevel > boatCfg.fuel.maxAmount then
        return Core.NotifyRightTip(src, _U('quantityTooHigh'), 4000)
    end

    local count = exports.vorp_inventory:getItemCount(src, nil, item)
    if count and count >= amount then
        exports.vorp_inventory:subItem(src, item, amount)
    else
        return cb(false)
    end

    MySQL.query.await('UPDATE `boats` SET `fuel` = ? WHERE `id` = ? AND `charid` = ?', { newLevel, myBoatId, charid })

    cb(newLevel)
end)

Core.Callback.Register('bcc-boats:GetRepairLevel', function(source, cb, myBoatId, myBoatModel)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier

    local repairLevel = MySQL.query.await('SELECT `condition` FROM `boats` WHERE `id` = ? AND `model` = ? AND charid = ?', { myBoatId, myBoatModel, charid })
    if repairLevel and repairLevel[1] then
        cb(repairLevel[1].condition)
    else
        cb(false)
    end
end)

Core.Callback.Register('bcc-boats:UpdateRepairLevel', function(source, cb, myBoatId, myBoatModel)
    local src = source
    local user = Core.getUser(src)
    if not user then return end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier

    local boatData = MySQL.query.await('SELECT * FROM `boats` WHERE `id` = ? AND `model` = ? AND charid = ?', { myBoatId, myBoatModel, charid })
    if not boatData or not boatData[1] then return cb(false) end

    local boatCfg = nil
    for _, boatModels in pairs(Boats) do
        for model, boatConfig in pairs(boatModels.models) do
            if myBoatModel == model then
                boatCfg = boatConfig
                break
            end
        end
    end

    if not boatCfg then return cb(false) end

    local updateLevel = boatData[1].condition - boatCfg.condition.itemAmount

    MySQL.query.await('UPDATE `boats` SET `condition` = ? WHERE `id` = ? AND `charid` = ?', { updateLevel, myBoatId, charid })

    cb(updateLevel)
end)

Core.Callback.Register('bcc-boats:GetItemDurability', function(source, cb, item)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end

    local tool = exports.vorp_inventory:getItem(src, item)
    if not tool then return cb('0') end

    local toolMeta = tool['metadata']
    cb(toolMeta.durability)
end)

local function UpdateRepairItem(src, item)
    local toolUsage = Config.repair.usage
    local tool = exports.vorp_inventory:getItem(src, item)
    local toolMeta = tool['metadata']
    local durabilityValue

    if next(toolMeta) == nil then
        durabilityValue = 100 - toolUsage
        exports.vorp_inventory:subItem(src, item, 1, {})
        exports.vorp_inventory:addItem(src, item, 1, { description = _U('durability') .. '<span style=color:yellow;>' .. tostring(durabilityValue) .. '%' .. '</span>', durability = durabilityValue })
    else
        durabilityValue = toolMeta.durability - toolUsage
        exports.vorp_inventory:subItem(src, item, 1, toolMeta)

        if durabilityValue >= toolUsage then
            exports.vorp_inventory:subItem(src, item, 1, toolMeta)
            exports.vorp_inventory:addItem(src, item, 1, { description = _U('durability') .. '<span style=color:yellow;>' .. tostring(durabilityValue) .. '%' .. '</span>', durability = durabilityValue })
        elseif durabilityValue < toolUsage then
            exports.vorp_inventory:subItem(src, item, 1, toolMeta)
            Core.NotifyRightTip(src, _U('needNewTool'), 4000)
        end
    end
end

Core.Callback.Register('bcc-boats:RepairBoat', function(source, cb, myBoatId, myBoatModel)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charid = character.charIdentifier
    local item = Config.repair.item

    local hasItem = exports.vorp_inventory:getItem(src, item)
    if not hasItem then
        Core.NotifyRightTip(src, _U('youNeed') .. Config.repair.label  .. _U('toRepair'), 4000)
        return cb(false)
    end

    local boatData = MySQL.query.await('SELECT * FROM `boats` WHERE `id` = ? AND `model` = ? AND charid = ?', { myBoatId, myBoatModel, charid })
    if not boatData or not boatData[1] then return cb(false) end

    local boatCfg = nil
    for _, boatModels in pairs(Boats) do
        for model, boatConfig in pairs(boatModels.models) do
            if myBoatModel == model then
                boatCfg = boatConfig
                break
            end
        end
    end

    if not boatCfg then return cb(false) end

    if boatData[1].condition >= boatCfg.condition.maxAmount then return cb(false) end

    local updateLevel = boatData[1].condition + boatCfg.condition.repairValue
    if updateLevel > boatCfg.condition.maxAmount then
        updateLevel = boatCfg.condition.maxAmount
    end

    MySQL.query.await('UPDATE `boats` SET `condition` = ? WHERE `id` = ? AND `charid` = ?', { updateLevel, myBoatId, charid })

    UpdateRepairItem(src, item)

    cb(updateLevel)
end)

Core.Callback.Register('bcc-boats:CheckJob', function(source, cb, boatman, site, speed)
    local src = source
    local user = Core.getUser(src)
    if not user then return cb(false) end
    local character = user.getUsedCharacter
    local charJob = character.job
    local jobGrade = character.jobGrade

    local jobConfig
    if boatman then
        jobConfig = Config.boatmanJob
    elseif site then
        jobConfig = Sites[site].shop.jobs
    else
        jobConfig = speed.jobs
    end
    local hasJob = false
    hasJob = CheckPlayerJob(charJob, jobGrade, jobConfig)
    if hasJob then
        cb({true, charJob})
    else
        cb({false, charJob})
    end
end)

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

------------------------------------------------------------------------
-- This is to Update Your Existing Boats Fuel and Condition Values
-- Values will be Set to the Max Amounts in the Config File per Model
-- This is a One Time Command to Update Your Database
-- Must be an Admin with Script in Dev Mode to Run this Command
-- After Running this Command You can Comment or Delete It
------------------------------------------------------------------------

RegisterCommand('updateBoatsDB', function(source, args, rawCommand)
    if not Config.devMode then return print('Dev Mode must be enabled to use this command!') end
    print('UPDATING::Boats Database')

    local boatData = MySQL.query.await('SELECT `id`, `model` FROM `boats`')
    if not boatData or next(boatData) == nil then
        return print('ERROR::No Boats Found in Database!')
    end

    for i = 1, #boatData do
        local boatModel = boatData[i].model
        local boatId = boatData[i].id

        local boatCfg = nil
        for _, boatModels in pairs(Boats) do
            for model, boatConfig in pairs(boatModels.models) do
                if boatModel == model then
                    boatCfg = boatConfig
                    break
                end
            end
        end

        if not boatCfg then
            print('ALERT::Boat Model: ' .. boatModel .. ' for ID: ' .. boatId .. ' Not Found in Config File!')
            goto END
        end

        MySQL.query.await('UPDATE `boats` SET `fuel` = ?, `condition` = ? WHERE `id` = ?',
        { boatCfg.fuel.maxAmount, boatCfg.condition.maxAmount, boatId })
        ::END::
    end

    print('SUCCESS::Boats Database Update Completed')
end, true)

--------------------------------------------------------------------------
