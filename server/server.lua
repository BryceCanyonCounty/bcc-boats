local VORPcore = {}
local VORPInv = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

-- Buy New Boats
RegisterNetEvent('bcc-boats:BuyBoat', function(data)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local maxBoats = Config.maxBoats
    local model = data.ModelB

    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        if #boats >= maxBoats then
            VORPcore.NotifyRightTip(_source, _U('boatLimit') .. maxBoats .. _U('boats'), 4000)
            TriggerClientEvent('bcc-boats:BoatMenu', _source)
            return
        end
        if model == 'pirogue2' then
            for i = 1, #boats do
                if boats[i].model == 'pirogue2' then
                    VORPcore.NotifyRightTip(_source, _U('ownPortable'), 4000)
                    TriggerClientEvent('bcc-boats:BoatMenu', _source)
                    return
                end
            end
        end
        if data.IsCash then
            local cashPrice = data.Cash
            if Character.money >= cashPrice then
                Character.removeCurrency(0, cashPrice)
            else
                VORPcore.NotifyRightTip(_source, _U('shortCash'), 4000)
                TriggerClientEvent('bcc-boats:BoatMenu', _source)
                return
            end
        else
            local goldPrice = data.Gold
            if Character.gold >= goldPrice then
                Character.removeCurrency(1, goldPrice)
            else
                VORPcore.NotifyRightTip(_source, _U('shortGold'), 4000)
                TriggerClientEvent('bcc-boats:BoatMenu', _source)
                return
            end
        end
        TriggerClientEvent('bcc-boats:SetBoatName', _source, data, false)
    end)
end)

-- Save New Boat Purchase to Database
RegisterNetEvent('bcc-boats:SaveNewBoat', function(data, name)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.Async.execute('INSERT INTO boats (identifier, charid, name, model) VALUES (?, ?, ?, ?)', {identifier, charid, tostring(name), data.ModelB},
    function(done)
    end)
end)

-- Rename Player Owned Boat
RegisterNetEvent('bcc-boats:UpdateBoatName', function(data, name)
    MySQL.Async.execute('UPDATE boats SET name = ? WHERE id = ?', {tostring(name), data.BoatId},
    function(done)
    end)
end)

-- Get Player Owned Boats
RegisterNetEvent('bcc-boats:GetMyBoats', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local hasPortable = VORPInv.getItem(_source, 'portable_canoe')

    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        TriggerClientEvent('bcc-boats:BoatsData', _source, boats)
        if hasPortable == nil then
            for i = 1, #boats do
                if boats[i].model == 'pirogue2' then
                    VORPInv.addItem(_source, 'portable_canoe', 1)
                end
            end
        end
    end)
end)

-- Register Portable Canoe
VORPInv.RegisterUsableItem('portable_canoe', function(data)
    local _source = data.source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local model = 'pirogue2'

    VORPInv.CloseInv(_source)
    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ? AND model = ?', {identifier, charid, model},
    function(boat)
        for i = 1, 1 do
            if boat[i].model == model then
                TriggerClientEvent('bcc-boats:LaunchBoat', _source, boat[i].id, boat[i].model, boat[i].name, true)
            end
        end
    end)
end)

-- Sell Player Owned Boats
RegisterNetEvent('bcc-boats:SellBoat', function(data, shopId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local modelBoat = nil
    local boatId = tonumber(data.BoatId)

    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        for i = 1, #boats do
            if tonumber(boats[i].id) == boatId then
                modelBoat = boats[i].model
                if modelBoat == 'pirogue2' then
                    VORPInv.subItem(_source, 'portable_canoe', 1)
                end
                MySQL.Async.execute('DELETE FROM boats WHERE identifier = ? AND charid = ? AND id = ?', {identifier, charid, boatId},
                function(done)
                    for _,boatModels in pairs(Config.shops[shopId].boats) do
                        for model,boatConfig in pairs(boatModels) do
                            if model ~= "boatType" then
                                if model == modelBoat then
                                    local sellPrice = (Config.sellPrice * boatConfig.cashPrice)
                                    Character.addCurrency(0, sellPrice)
                                    VORPcore.NotifyRightTip(_source, _U('soldBoat') .. data.BoatName .. _U('frcash') .. sellPrice, 5000)
                                end
                            end
                        end
                    end
                end)
            end
        end
        TriggerClientEvent('bcc-boats:BoatMenu', _source)
    end)
end)

-- Register Boat Inventory
RegisterNetEvent('bcc-boats:RegisterInventory', function(id, boatModel)
    for model, invConfig in pairs(Config.inventory) do
        if model == boatModel then
            VORPInv.registerInventory('boat_' .. tostring(id), _U('boatInv'), tonumber(invConfig.slots))
        end
    end
end)

-- Open Boat Inventory
RegisterNetEvent('bcc-boats:OpenInventory', function(id)
    local _source = source
    VORPInv.OpenInv(_source, 'boat_' .. tostring(id))
end)

-- Check Player Job and Job Grade
RegisterNetEvent('bcc-boats:getPlayerJob', function()
    local _source = source
    if _source then
        local Character = VORPcore.getUser(_source).getUsedCharacter
        local CharacterJob = Character.job
        local CharacterGrade = Character.jobGrade
        TriggerClientEvent('bcc-boats:sendPlayerJob', _source, CharacterJob, CharacterGrade)
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