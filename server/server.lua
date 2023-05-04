local VORPcore = {}
local VORPInv = {}

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

-- Buy New Boats
RegisterServerEvent('oss_boats:BuyBoat')
AddEventHandler('oss_boats:BuyBoat', function(data)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local maxBoats = Config.maxBoats

    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        if #boats >= maxBoats then
            VORPcore.NotifyRightTip(_source, _U("boatLimit") .. maxBoats .. _U("boats"), 5000)
            TriggerClientEvent('oss_boats:BoatMenu', _source)
            return
        end
        if data.IsCash then
            local charCash = Character.money
            local cashPrice = data.Cash

            if charCash >= cashPrice then
                Character.removeCurrency(0, cashPrice)
            else
                VORPcore.NotifyRightTip(_source, _U("shortCash"), 5000)
                TriggerClientEvent('oss_boats:BoatMenu', _source)
                return
            end
        else
            local charGold = Character.gold
            local goldPrice = data.Gold

            if charGold >= goldPrice then
                Character.removeCurrency(1, goldPrice)
            else
                VORPcore.NotifyRightTip(_source, _U("shortGold"), 5000)
                TriggerClientEvent('oss_boats:BoatMenu', _source)
                return
            end
        end
        local action = "newBoat"
        TriggerClientEvent('oss_boats:SetBoatName', _source, data, action)
    end)
end)

-- Save New Boat Purchase to Database
RegisterServerEvent('oss_boats:SaveNewBoat')
AddEventHandler('oss_boats:SaveNewBoat', function(data, name)
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
RegisterServerEvent('oss_boats:UpdateBoatName')
AddEventHandler('oss_boats:UpdateBoatName', function(data, name)
    local boatName = tostring(name)
    local boatId = data.BoatId
    MySQL.Async.execute('UPDATE boats SET name = ? WHERE id = ?', {boatName, boatId},
    function(done)
    end)
end)

-- Get Player Owned Boats
RegisterServerEvent('oss_boats:GetMyBoats')
AddEventHandler('oss_boats:GetMyBoats', function()
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier

    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        TriggerClientEvent('oss_boats:ReceiveBoatsData', _source, boats)
    end)
end)

-- Sell Player Owned Boats
RegisterServerEvent('oss_boats:SellBoat')
AddEventHandler('oss_boats:SellBoat', function(boatId, boatName, shopId)
    local _source = source
    local Character = VORPcore.getUser(_source).getUsedCharacter
    local identifier = Character.identifier
    local charid = Character.charIdentifier
    local modelBoat = nil

    MySQL.Async.fetchAll('SELECT * FROM boats WHERE identifier = ? AND charid = ?', {identifier, charid},
    function(boats)
        for i = 1, #boats do
            if tonumber(boats[i].id) == tonumber(boatId) then
                modelBoat = boats[i].model
                MySQL.Async.execute('DELETE FROM boats WHERE identifier = ? AND charid = ? AND id = ?', {identifier, charid, boatId},
                function(done)
                end)
            end
        end

        for _,boatModels in pairs(Config.boatShops[shopId].boats) do
            for model,boatConfig in pairs(boatModels) do
                if model ~= "boatType" then
                    if model == modelBoat then
                        local sellPrice = boatConfig.sellPrice
                        Character.addCurrency(0, sellPrice)
                        VORPcore.NotifyRightTip(_source, _U("soldBoat") .. boatName .. _U("frcash") .. sellPrice, 5000)
                    end
                end
            end
        end
        TriggerClientEvent('oss_boats:BoatMenu', _source)
    end)
end)

-- Register Boat Inventory
RegisterServerEvent('oss_boats:RegisterInventory')
AddEventHandler('oss_boats:RegisterInventory', function(id)

    VORPInv.registerInventory("boat_" .. tostring(id), _U("boatInv"), tonumber(Config.invLimit))
end)

-- Open Boat Inventory
RegisterServerEvent('oss_boats:OpenInventory')
AddEventHandler('oss_boats:OpenInventory', function(id)
    local _source = source

    VORPInv.OpenInv(_source, "boat_" .. tostring(id))
end)

-- Check Player Job and Job Grade
RegisterServerEvent('oss_boats:getPlayerJob')
AddEventHandler('oss_boats:getPlayerJob', function()
    local _source = source
    if _source then
        local Character = VORPcore.getUser(_source).getUsedCharacter
        local CharacterJob = Character.job
        local CharacterGrade = Character.jobGrade
        TriggerClientEvent('oss_boats:sendPlayerJob', _source, CharacterJob, CharacterGrade)
    end
end)

-- Prevent NPC Boat Spawns
if Config.blockNpcBoats then
    AddEventHandler('entityCreating', function(entity)
        if GetEntityType(entity) == 2 then
            if GetVehicleType(entity) == "boat" then
                if GetEntityPopulationType(entity) ~= 7 and GetEntityPopulationType(entity) ~= 8 then
                    CancelEvent()
                end
            end
        end
    end)
end