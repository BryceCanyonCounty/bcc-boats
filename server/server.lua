local VORPcore = {}
local VORPInv = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

-- Buy New Boats
RegisterServerEvent('bcc-boats:BuyBoat')
AddEventHandler('bcc-boats:BuyBoat', function(data)
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
            local charCash = Character.money
            local cashPrice = data.Cash

            if charCash >= cashPrice then
                Character.removeCurrency(0, cashPrice)
            else
                VORPcore.NotifyRightTip(_source, _U('shortCash'), 4000)
                TriggerClientEvent('bcc-boats:BoatMenu', _source)
                return
            end
        else
            local charGold = Character.gold
            local goldPrice = data.Gold

            if charGold >= goldPrice then
                Character.removeCurrency(1, goldPrice)
            else
                VORPcore.NotifyRightTip(_source, _U('shortGold'), 4000)
                TriggerClientEvent('bcc-boats:BoatMenu', _source)
                return
            end
        end
        local rename = false
        TriggerClientEvent('bcc-boats:SetBoatName', _source, data, rename)
    end)
end)

-- Save New Boat Purchase to Database
RegisterServerEvent('bcc-boats:SaveNewBoat')
AddEventHandler('bcc-boats:SaveNewBoat', function(data, name)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local boatName = tostring(name)
    local boatModel = data.ModelB

    MySQL.Async.execute('INSERT INTO boats (identifier, charid, name, model) VALUES (?, ?, ?, ?)', {identifier, charid, boatName, boatModel},
    function(done)
    end)
end)

-- Rename Player Owned Boat
RegisterServerEvent('bcc-boats:UpdateBoatName')
AddEventHandler('bcc-boats:UpdateBoatName', function(data, name)
    local boatName = tostring(name)
    local boatId = data.BoatId
    MySQL.Async.execute('UPDATE boats SET name = ? WHERE id = ?', {boatName, boatId},
    function(done)
    end)
end)

-- Get Player Owned Boats
RegisterServerEvent('bcc-boats:GetMyBoats')
AddEventHandler('bcc-boats:GetMyBoats', function()
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
    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ? AND model = ? LIMIT 1', {identifier, charid, model},
    function(boat)
        for i = 1, 1 do
            local portable = true
            TriggerClientEvent('bcc-boats:LaunchBoat', _source, boat[i].id, boat[i].model, boat[i].name, portable)
        end
    end)
end)

-- Sell Player Owned Boats
RegisterServerEvent('bcc-boats:SellBoat')
AddEventHandler('bcc-boats:SellBoat', function(data, shopId)
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
                    VORPInv.subItem(_source, 'pirogue2', 1)
                end
                MySQL.Async.execute('DELETE FROM boats WHERE identifier = ? AND charid = ? AND id = ?', {identifier, charid, boatId},
                function(done)
                    for _,boatModels in pairs(Config.boatShops[shopId].boats) do
                        for model,boatConfig in pairs(boatModels) do
                            if model ~= "boatType" then
                                if model == modelBoat then
                                    local sellPrice = boatConfig.sellPrice
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
RegisterServerEvent('bcc-boats:RegisterInventory')
AddEventHandler('bcc-boats:RegisterInventory', function(id, boatModel, portable, shopId)
    if portable then
        VORPInv.registerInventory('boat_' .. tostring(id), _U('boatInv'), tonumber(Config.portableInvLimit))
        return
    else
        for _,boatModels in pairs(Config.boatShops[shopId].boats) do
            for model,boatConfig in pairs(boatModels) do
                if model ~= 'boatType' then
                    if model == boatModel then
                        VORPInv.registerInventory('boat_' .. tostring(id), _U('boatInv'), tonumber(boatConfig.invLimit))
                    end
                end
            end
        end
    end
end)

-- Open Boat Inventory
RegisterServerEvent('bcc-boats:OpenInventory')
AddEventHandler('bcc-boats:OpenInventory', function(id)
    local _source = source
    VORPInv.OpenInv(_source, 'boat_' .. tostring(id))
end)

-- Check Player Job and Job Grade
RegisterServerEvent('bcc-boats:getPlayerJob')
AddEventHandler('bcc-boats:getPlayerJob', function()
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