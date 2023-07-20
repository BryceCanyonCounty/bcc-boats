local VORPcore = {}
local VORPInv = {}

TriggerEvent('getCore', function(core)
    VORPcore = core
end)

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

-- Buy New Boats
RegisterNetEvent('bcc-boats:BuyBoat', function(data)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local maxBoats = Config.maxBoats
    local model = data.ModelB
    local portable = Config.portable

    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        if #boats >= maxBoats then
            VORPcore.NotifyRightTip(src, _U('boatLimit') .. maxBoats .. _U('boats'), 4000)
            TriggerClientEvent('bcc-boats:BoatMenu', src)
            return
        end
        if model == portable then
            for i = 1, #boats do
                if boats[i].model == portable then
                    VORPcore.NotifyRightTip(src, _U('ownPortable'), 4000)
                    TriggerClientEvent('bcc-boats:BoatMenu', src)
                    return
                end
            end
        end
        if data.IsCash then
            if Character.money >= data.Cash then
                TriggerClientEvent('bcc-boats:SetBoatName', src, data, false, false)
            else
                VORPcore.NotifyRightTip(src, _U('shortCash'), 4000)
                TriggerClientEvent('bcc-boats:BoatMenu', src)
                return
            end
        else
            if Character.gold >= data.Gold then
                TriggerClientEvent('bcc-boats:SetBoatName', src, data, false, false)
            else
                VORPcore.NotifyRightTip(src, _U('shortGold'), 4000)
                TriggerClientEvent('bcc-boats:BoatMenu', src)
                return
            end
        end
    end)
end)

-- Save New Boat Purchase to Database
RegisterNetEvent('bcc-boats:SaveNewBoat', function(data, name)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    MySQL.Async.execute('INSERT INTO boats (identifier, charid, name, model) VALUES (?, ?, ?, ?)', {identifier, charid, tostring(name), data.ModelB},
    function(done)
        if data.IsCash then
            Character.removeCurrency(0, data.Cash)
        else
            Character.removeCurrency(1, data.Gold)
        end
        TriggerClientEvent('bcc-boats:BoatMenu', src)
    end)
end)

-- Rename Player Owned Boat
RegisterNetEvent('bcc-boats:UpdateBoatName', function(data, name)
    local src = source
    MySQL.Async.execute('UPDATE boats SET name = ? WHERE id = ?', {tostring(name), data.BoatId},
    function(done)
        TriggerClientEvent('bcc-boats:BoatMenu', src)
    end)
end)

-- Get Player Owned Boats
RegisterNetEvent('bcc-boats:GetMyBoats', function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local hasPortable = VORPInv.getItem(src, 'portable_canoe')
    local portable = Config.portable

    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        TriggerClientEvent('bcc-boats:BoatsData', src, boats)
        if hasPortable == nil then
            for i = 1, #boats do
                if boats[i].model == portable then
                    VORPInv.addItem(src, 'portable_canoe', 1)
                end
            end
        end
    end)
end)

-- Register Portable Canoe
VORPInv.RegisterUsableItem('portable_canoe', function(data)
    local src = data.source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local maxBoats = Config.maxBoats
    local hasPortable = nil
    local model = Config.portable

    VORPInv.CloseInv(src)
    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        for i = 1, #boats do
            if boats[i].model == model then
                hasPortable = true
                TriggerClientEvent('bcc-boats:LaunchBoat', src, boats[i].id, boats[i].model, boats[i].name, true)
            end
        end
        if not hasPortable then
            if #boats >= maxBoats then
                VORPcore.NotifyRightTip(src, _U('boatLimit') .. maxBoats .. _U('boats'), 4000)
                return
            end
            TriggerClientEvent('bcc-boats:SetBoatName', src, model, false, true)
        end
    end)
end)

-- Save New Craft to Database
RegisterNetEvent('bcc-boats:SaveNewCraft', function(model, name)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    MySQL.Async.execute('INSERT INTO boats (identifier, charid, name, model) VALUES (?, ?, ?, ?)', {identifier, charid, tostring(name), model},
    function(done)
    end)
end)

-- Sell Player Owned Boats
RegisterNetEvent('bcc-boats:SellBoat', function(data, shopId)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local modelBoat = nil
    local boatId = tonumber(data.BoatId)

    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        for i = 1, #boats do
            if tonumber(boats[i].id) == boatId then
                modelBoat = boats[i].model
                if modelBoat == Config.portable then
                    VORPInv.subItem(src, 'portable_canoe', 1)
                end
                MySQL.Async.execute('DELETE FROM boats WHERE identifier = ? AND charid = ? AND id = ?', {identifier, charid, boatId},
                function(done)
                    for _,boatModels in pairs(Config.shops[shopId].boats) do
                        for model,boatConfig in pairs(boatModels) do
                            if model ~= 'boatType' then
                                if model == modelBoat then
                                    local sellPrice = (Config.sellPrice * boatConfig.cashPrice)
                                    Character.addCurrency(0, sellPrice)
                                    VORPcore.NotifyRightTip(src, _U('soldBoat') .. data.BoatName .. _U('frcash') .. sellPrice, 5000)
                                end
                            end
                        end
                    end
                end)
            end
        end
        TriggerClientEvent('bcc-boats:BoatMenu', src)
    end)
end)

-- Register Boat Inventory
RegisterNetEvent('bcc-boats:RegisterInventory', function(id, boatModel)
    for model, invConfig in pairs(Config.inventory) do
        if model == boatModel then
            VORPInv.registerInventory('boat_' .. tostring(id), _U('boatInv'), tonumber(invConfig.slots), true, false, true)
        end
    end
end)

-- Open Boat Inventory
RegisterNetEvent('bcc-boats:OpenInventory', function(id)
    local src = source
    VORPInv.OpenInv(src, 'boat_' .. tostring(id))
end)

-- Check if Player has Required Job
VORPcore.addRpcCallback('CheckPlayerJob', function(source, cb, shop)
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local playerJob = Character.job
    local jobGrade = Character.jobGrade

    if playerJob then
        for _, job in pairs(Config.shops[shop].allowedJobs) do
            if playerJob == job then
                if tonumber(jobGrade) >= tonumber(Config.shops[shop].jobGrade) then
                    cb(true)
                else
                    VORPcore.NotifyRightTip(src, _U('needJobGrade'), 4000)
                    cb(false)
                end
            else
                VORPcore.NotifyRightTip(src, _U('needJob'), 4000)
                cb(false)
            end
        end
    else
        VORPcore.NotifyRightTip(src, _U('needJob'), 4000)
        cb(false)
    end
end)

-- Prevent NPC Boat Spawns
if Config.blockNpcBoats then
    AddEventHandler('entityCreating', function(entity)
        if GetEntityType(entity) == 2 then
            if GetVehicleType(entity) == 'boat' then
                if GetEntityPopulationType(entity) ~= 7 and GetEntityPopulationType(entity) ~= 8 then
                    CancelEvent()
                end
            end
        end
    end)
end
