Core = exports.vorp_core:GetCore()
-- Prompts
local ShopPrompt
local ShopGroup = GetRandomIntInRange(0, 0xffffff)
local ReturnPrompt, AnchorPrompt, SteamPrompt, MenuPrompt
local DriveGroup = GetRandomIntInRange(0, 0xffffff)
local TradePrompt
local TradeGroup = GetRandomIntInRange(0, 0xffffff)
local LootPrompt
local LootGroup = GetRandomIntInRange(0, 0xffffff)
local ActionPrompt
local ActionGroup = GetRandomIntInRange(0, 0xffffff)
local PromptsStarted = false
-- Boats
MyBoat, MyBoatId, MyBoatName, MyBoatModel = 0, nil, nil, nil
FuelLevel, RepairLevel = 0, 0
IsSteamer, IsLarge, IsPortable, IsBoatDamaged = false, false, false, false
BoatCfg = {}
FuelEnabled, ConditionEnabled, Trading = false, false, false
local Knots
local Speed, Pressure, PSI = 1.0, 0, 'psi: ~o~'
local ShopName, SiteCfg, BoatCam
local ShopEntity, MyEntity, BoatModel = 0, 0, nil
local InMenu, Cam, IsAnchored = false, false, false
local HasJob, IsBoatman, HasSpeedJob = false, false, false
local ReturnVisible, ShopClosed = false, false
local IsStarted, SpeedIncrement = false, 0.0

local function ManageShopAction(site, needJob)
    local siteCfg = Sites[site]
    if not ShopClosed then
        CheckPlayerJob(false, site, false)
        if needJob then
            if not HasJob then return end
        end
        OpenMenu(site)
    else
        if Config.notify == 'vorp' then
            Core.NotifyRightTip(siteCfg.shop.name .. _U('hours') .. ' ~o~' .. siteCfg.shop.hours.open .. ':00 ' .. _U('to') .. ' ' .. siteCfg.shop.hours.close .. ':00~o~', 4000)
        elseif Config.notify == 'ox' then
            lib.notify({description = siteCfg.shop.name .. _U('hours') .. ' ' .. siteCfg.shop.hours.open .. ':00 ' .. _U('to') .. ' ' .. siteCfg.shop.hours.close .. ':00', duration = 4000, type = 'inform', iconColor = 'white', style = Config.oxstyle, position = Config.oxposition})
        end
    end
end

CreateThread(function()
    StartPrompts()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local hour = GetClockHours()
        local sleep = 1000

        if InMenu or IsEntityDead(playerPed) then goto END end

        for site, siteCfg in pairs(Sites) do
            local distance = #(playerCoords - siteCfg.npc.coords)

            if siteCfg.shop.hours.active then
                if (hour >= siteCfg.shop.hours.close) or (hour < siteCfg.shop.hours.open) then
                    RemoveNPC(site)
                    ShopClosed = true
                else
                    ShopClosed = false
                end
            end

            if not ShopClosed and siteCfg.npc.active then
                if distance <= siteCfg.npc.distance then
                    AddNPC(site)
                else
                    RemoveNPC(site)
                end
            end

            ManageBlip(site, ShopClosed)
            if not Config.oxtarget then
                if distance <= siteCfg.shop.distance and not IsPedInAnyBoat(playerPed) and not IsPedSwimming(playerPed) then
                    sleep = 0
                    PromptSetActiveGroupThisFrame(ShopGroup, CreateVarString(10, 'LITERAL_STRING', siteCfg.shop.prompt), 1, 0, 0, 0)
                    if Citizen.InvokeNative(0xC92AC953F0A982AE, ShopPrompt) then -- UiPromptHasStandardModeCompleted
                        ManageShopAction(site, siteCfg.shop.jobsEnabled)
                    end
                    goto END
                end
            end

            if distance <= siteCfg.boat.distance and IsPedInVehicle(playerPed, MyBoat, false) then
                sleep = 0
                PromptSetVisible(ReturnPrompt, true)
                ReturnVisible = true
                if Citizen.InvokeNative(0xC92AC953F0A982AE, ReturnPrompt) then -- UiPromptHasStandardModeCompleted
                    ReturnBoat(site)
                end
                goto END
            end

            if ReturnVisible then
                if distance > siteCfg.boat.distance then
                    PromptSetVisible(ReturnPrompt, false)
                end
            end
        end
        ::END::
        Wait(sleep)
    end
end)

function OpenMenu(site)
    DisplayRadar(false)
    TaskStandStill(PlayerPedId(), -1)
    InMenu = true
    SiteCfg = Sites[site]
    ShopName = SiteCfg.shop.name
    CreateCamera()

    local data = Core.Callback.TriggerAwait('bcc-boats:GetBoats')
    if data then
        SendNUIMessage({
            action = 'show',
            shopData = JobMatchedBoats,
            location = ShopName,
            myBoatsData = data
        })
        SetNuiFocus(true, true)
    end
end

local function SetCameraFOV(boatModel)
    SetCamFov(BoatCam, 25.0)
    if boatModel == 'keelboat' then
        SetCamFov(BoatCam, 35.0)
    elseif (boatModel == 'ship_nbdGuama') or (boatModel == 'turbineboat') or (boatModel == 'tugboat2') or (boatModel == 'horseBoat') then
        SetCamFov(BoatCam, 65.0)
    end
end

RegisterNUICallback('LoadBoat', function(data, cb)
    cb('ok')
    ResetBoat()

    if MyEntity ~= 0 then
        DeleteEntity(MyEntity)
        MyEntity = 0
    end

    BoatModel = data.boatModel
    local model = joaat(BoatModel)
    LoadModel(model, BoatModel)

    if ShopEntity ~= 0 then
        DeleteEntity(ShopEntity)
        ShopEntity = 0
    end

    SetCameraFOV(BoatModel)

    ShopEntity = CreateVehicle(model, SiteCfg.boat.coords.x, SiteCfg.boat.coords.y, SiteCfg.boat.coords.z, SiteCfg.boat.heading, false, false, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, ShopEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, ShopEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
    if not Cam then
        Cam = true
        CameraLighting()
    end
end)

RegisterNUICallback('BuyBoat', function(data, cb)
    cb('ok')
    CheckPlayerJob(true, false, false)
    if SiteCfg.boatmanBuy and not IsBoatman then
        if Config.notify == 'vorp' then
            Core.NotifyRightTip(_U('boatmanBuyOnly'), 4000)
        elseif Config.notify == 'ox' then
            lib.notify({description = _U('boatmanBuyOnly'), duration = 4000, type = 'inform', style = Config.oxstyle, position = Config.oxposition})
        end
        BoatMenu()
        return
    end
    if IsBoatman then
        data.isBoatman = true
    else
        data.isBoatman = false
    end
    local canBuy = Core.Callback.TriggerAwait('bcc-boats:BuyBoat', data)
    if canBuy then
        TriggerEvent('bcc-boats:SetBoatName', data, false, false)
    else
        BoatMenu()
    end
end)

RegisterNetEvent('bcc-boats:SetBoatName', function(data, rename, crafted)
    if not crafted then
        SendNUIMessage({
            action = 'hide'
        })
        SetNuiFocus(false, false)
    end
    Wait(200)

	CreateThread(function()
		AddTextEntry('FMMC_MPM_NA', _U('nameBoat'))
		DisplayOnscreenKeyboard(1, 'FMMC_MPM_NA', '', '', '', '', '', 30)
		while UpdateOnscreenKeyboard() == 0 do
			DisableAllControlActions(0)
			Wait(0)
		end
		if GetOnscreenKeyboardResult() then
            local boatName = GetOnscreenKeyboardResult()
            if string.len(boatName) > 0 then
                if not rename then
                    if not crafted then
                        local boatSaved = Core.Callback.TriggerAwait('bcc-boats:SaveNewBoat', data, boatName)
                        if boatSaved then
                            BoatMenu()
                        end
                        return
                    else
                        local craftSaved = Core.Callback.TriggerAwait('bcc-boats:SaveNewCraft', data, boatName)
                        if craftSaved then
                            if Config.notify == 'vorp' then
                                Core.NotifyRightTip(_U('craftSaved'), 4000)
                            elseif Config.notify == 'ox' then
                                lib.notify({description = _U('craftSaved'), type = 'success', style = Config.oxstyle, position = Config.oxposition})
                            end
                        end
                        return
                    end
                else
                    local nameSaved = Core.Callback.TriggerAwait('bcc-boats:UpdateBoatName', data, boatName)
                    if nameSaved then
                        BoatMenu()
                    end
                    return
                end
            else
                TriggerEvent('bcc-boats:SetBoatName', data, rename, crafted)
                return
            end
		end
        if not crafted then
            local boatData = Core.Callback.TriggerAwait('bcc-boats:GetBoats')
            if boatData then
                SendNUIMessage({
                    action = 'show',
                    shopData = JobMatchedBoats,
                    location = ShopName,
                    myBoatsData = boatData
                })
                SetNuiFocus(true, true)
            end
        end
    end)
end)

RegisterNUICallback('RenameBoat', function(data, cb)
    cb('ok')
    TriggerEvent('bcc-boats:SetBoatName', data, true, false)
end)

RegisterNUICallback('LoadMyBoat', function(data, cb)
    cb('ok')
    ResetBoat()

    if ShopEntity ~= 0 then
        DeleteEntity(ShopEntity)
        ShopEntity = 0
    end

    BoatModel = data.BoatModel
    local model = joaat(BoatModel)
    LoadModel(model, BoatModel)

    if MyEntity ~= 0 then
        DeleteEntity(MyEntity)
        MyEntity = 0
    end

    SetCameraFOV(BoatModel)

    MyEntity = CreateVehicle(model, SiteCfg.boat.coords.x, SiteCfg.boat.coords.y, SiteCfg.boat.coords.z, SiteCfg.boat.heading, false, false, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, MyEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
    if not Cam then
        Cam = true
        CameraLighting()
    end
end)

local function SetBoatDamaged()
    if MyBoat == 0 then return end
    IsBoatDamaged = true
    if Config.notify == 'vorp' then
        Core.NotifyRightTip(_U('needRepairs'), 4000)
    elseif Config.notify == 'ox' then
        lib.notify({description = _U('needRepairs'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
    end
    Citizen.InvokeNative(0xAEAB044F05B92659, MyBoat, true) -- SetBoatAnchor
    Citizen.InvokeNative(0x286771F3059A37A7, MyBoat, true) -- SetBoatRemainsAnchoredWhilePlayerIsDriver
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyBoat, true) -- FreezeEntityPosition
    IsAnchored = true
    Speed = 1.0
    PromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorUp')))
end

RegisterNUICallback('SpawnData', function(data,cb)
    cb('ok')
    TriggerEvent('bcc-boats:SpawnBoat', data.BoatId, data.BoatModel, data.BoatName, false)
end)

RegisterNetEvent('bcc-boats:SpawnBoat', function(boatId, boatModel, boatName, portable)
    if MyEntity ~= 0 then
        DeleteEntity(MyEntity)
        MyEntity = 0
    end

    ResetBoat()

    if boatModel == Config.portable.model then
        IsPortable = true
    end

    for _, boatModels in pairs(Boats) do
        for model, boatConfig in pairs(boatModels.models) do
            if model == boatModel then
                BoatCfg = boatConfig
                break
            end
        end
    end

    MyBoatModel = boatModel
    MyBoatName = boatName
    MyBoatId = boatId
    IsSteamer = BoatCfg.steamer
    IsLarge = BoatCfg.isLarge
    FuelEnabled = BoatCfg.fuel.enabled
    ConditionEnabled = BoatCfg.condition.enabled
    local playerPed = PlayerPedId()
    local model = joaat(boatModel)

    if not portable then
        LoadModel(model, boatModel)
        MyBoat = CreateVehicle(model, SiteCfg.boat.coords.x, SiteCfg.boat.coords.y, SiteCfg.boat.coords.z, SiteCfg.boat.heading, true, false, false, false)
    else
        local coords = GetEntityCoords(playerPed)
        local water = Citizen.InvokeNative(0x5BA7A68A346A5A91, coords.x, coords.y, coords.z) -- GetWaterMapZoneAtCoords
        local canLaunch = false

        for k, _ in pairs(Config.locations) do
            if water == Config.locations[k].hash and IsPedOnFoot(playerPed) and IsEntityInWater(playerPed) then
                canLaunch = true
                break
            end
        end

        if canLaunch then
            local worldCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 4.0, 0.5)
            LoadModel(model, boatModel)
            MyBoat = CreateVehicle(model, worldCoords.x, worldCoords.y, worldCoords.z, GetEntityHeading(playerPed), true, false, false, false)
        else
            if Config.notify == 'vorp' then
                Core.NotifyRightTip(_U('noLaunch'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('noLaunch'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
            end
            return
        end
    end

    while not DoesEntityExist(MyBoat) do Wait(5) end

    Citizen.InvokeNative(0x7263332501E07F52, MyBoat, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x62A6D317A011EA1D, MyBoat, false) -- SetBoatSinksWhenWrecked

    Citizen.InvokeNative(0xD0E02AA618020D17, PlayerId(), MyBoat) -- SetPlayerOwnsVehicle
    Citizen.InvokeNative(0xE2487779957FE897, MyBoat, 528) -- SetTransportUsageFlags

    SetModelAsNoLongerNeeded(model)
    DoScreenFadeOut(500)
    Wait(500)
    SetPedIntoVehicle(playerPed, MyBoat, -1)
    Wait(500)
    DoScreenFadeIn(500)

    if BoatCfg.inventory.enabled then
        TriggerServerEvent('bcc-boats:RegisterInventory', MyBoatId, boatModel)
    end

    if BoatCfg.inventory.shared then
        Entity(MyBoat).state:set('myBoatId', MyBoatId, true)
    end

    StartBoatPrompts()
    TriggerEvent('bcc-boats:BoatPrompts')

    if BoatCfg.gamerTag.enabled then
        TriggerEvent('bcc-boats:BoatTag')
    end

    if BoatCfg.blip.enabled then
        TriggerEvent('bcc-boats:BoatBlip')
    end

    TriggerEvent('bcc-boats:SpeedMonitor')

    if FuelEnabled then
        TriggerEvent('bcc-boats:SetFuelUsageValues')
    end

    if BoatCfg.anchored then
        Citizen.InvokeNative(0xAEAB044F05B92659, MyBoat, true) -- SetBoatAnchor
        Citizen.InvokeNative(0x286771F3059A37A7, MyBoat, true) -- SetBoatRemainsAnchoredWhilePlayerIsDriver
        Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyBoat, true) -- FreezeEntityPosition
        IsAnchored = true
    end

    if IsSteamer then
        Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
        IsStarted = false
        Speed = 1.0
        if FuelEnabled then
            FuelLevel = GetFuel()
        end
        if BoatCfg.speed.enabled then
            CheckPlayerJob(false, false, BoatCfg.speed)
            if HasSpeedJob then
                SpeedIncrement = tonumber(BoatCfg.speed.increment) + tonumber(BoatCfg.speed.bonus)
            else
                SpeedIncrement = tonumber(BoatCfg.speed.increment)
            end
        end
    end

    if ConditionEnabled then
        RepairLevel = GetCondition()
        if RepairLevel < BoatCfg.condition.itemAmount then
            SetBoatDamaged()
        end
        TriggerEvent('bcc-boats:RepairMonitor')
    end
end)

-- Loot Players Boat Inventory
CreateThread(function()
    while true do
        local vehicle, boatId, owner, model = nil, nil, nil, nil
        local isBoat = false
        local playerPed = PlayerPedId()
        local coords = (GetEntityCoords(playerPed))
        local sleep = 1000

        if (IsEntityDead(playerPed)) then goto END end

        vehicle = Citizen.InvokeNative(0x52F45D033645181B, coords.x, coords.y, coords.z, 5.0, 0, 8194, Citizen.ResultAsInteger()) -- GetClosestVehicle
        if (vehicle == 0) or (vehicle == MyBoat) then goto END end

        model = GetEntityModel(vehicle)
        isBoat = Citizen.InvokeNative(0x799CFC7C5B743B15, model) -- IsThisModelABoat
        if not isBoat then goto END end

        owner = Citizen.InvokeNative(0x7C803BDC8343228D, vehicle) -- GetPlayerOwnerOfVehicle
        if owner == 255 then goto END end

        sleep = 0
        PromptSetActiveGroupThisFrame(LootGroup, CreateVarString(10, 'LITERAL_STRING', _U('lootInventory')), 1, 0, 0, 0)
        if Citizen.InvokeNative(0xC92AC953F0A982AE, LootPrompt) then  -- PromptHasStandardModeCompleted
            boatId = Entity(vehicle).state.myBoatId
            TriggerServerEvent('bcc-boats:OpenInventory', boatId)
        end
        ::END::
        Wait(sleep)
    end
end)

local function SteamBoatSpeed(increase)
    if increase then
        if not IsStarted then
            if FuelEnabled then
                FuelLevel = GetFuel()
                if FuelLevel < BoatCfg.fuel.itemAmount then
                    if Config.notify == 'vorp' then
                        Core.NotifyRightTip(_U('outOfFuel'), 4000)
                    elseif Config.notify =='ox' then
                        lib.notify({description = _U('outOfFuel'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
                    end
                    return
                end
            end

            if ConditionEnabled then
                RepairLevel = GetCondition()
                if RepairLevel < BoatCfg.condition.itemAmount then
                    if Config.notify == 'vorp' then
                        Core.NotifyRightTip(_U('needRepairs'), 4000)
                    elseif Config.notify == 'ox' then
                        lib.notify({description = _U('needRepairs'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
                    end
                    return
                end
            end

            Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, true, true) -- SetVehicleEngineOn
            IsStarted = true
            Pressure = 85
            Speed = 1.0
            if FuelEnabled then
                TriggerEvent('bcc-boats:FuelMonitor')
            end
            Citizen.InvokeNative(0x35AD938C74CACD6A, MyBoat, Speed) -- ModifyVehicleTopSpeed
            return
        end

        if BoatCfg.speed.enabled then
            local maxSpeed = ((SpeedIncrement * 6) + 1.0)
            Speed = Speed + SpeedIncrement
            if Speed > maxSpeed then Speed = maxSpeed goto END end

            Pressure = Pressure + 20
            if Pressure > 205 then Pressure = 205 end
        end
    else
        Speed = Speed - SpeedIncrement
        if Speed < 1.0 then Speed = 1.0 end

        Pressure = Pressure - 20
        if Pressure < 85 then
            Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
            IsStarted = false
            Pressure = 0
            Speed = 1.0
        end
    end
    Citizen.InvokeNative(0x35AD938C74CACD6A, MyBoat, Speed) -- ModifyVehicleTopSpeed
    ::END::
end

AddEventHandler('bcc-boats:SpeedMonitor', function()
    while MyBoat ~= 0 do
        Wait(1000)
        local entitySpeed = Citizen.InvokeNative(0xFB6BA510A533DF81, MyBoat, Citizen.ResultAsFloat()) -- GetEntitySpeed / Meters per Second
        Knots = math.floor(entitySpeed * 1.94384) -- Convert to knots
        PSI = 'psi: ~o~'
        if Pressure > 185 then
            PSI = 'psi: ~e~'
        end
        if Pressure <= 0 then
            Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
        end
    end
end)

-- Set Quicker Fuel Use with Higher Engine Pressure
AddEventHandler('bcc-boats:SetFuelUsageValues', function()
    local fuelDecreaseTime = (BoatCfg.fuel.decreaseTime * 1000)
    local fuelInterval = fuelDecreaseTime
    local fuelInterval_105 = (math.floor(fuelDecreaseTime - (fuelDecreaseTime * 0.05)))
    local fuelInterval_125 = (math.floor(fuelDecreaseTime - (fuelDecreaseTime * 0.10)))
    local fuelInterval_145 = (math.floor(fuelDecreaseTime - (fuelDecreaseTime * 0.15)))
    local fuelInterval_165 = (math.floor(fuelDecreaseTime - (fuelDecreaseTime * 0.20)))
    local fuelInterval_185 = (math.floor(fuelDecreaseTime - (fuelDecreaseTime * 0.25)))
    local fuelInterval_205 = (math.floor(fuelDecreaseTime - (fuelDecreaseTime * 0.50))) -- Over Pressure Penalty

    function GetFuelUsageValues()
        local pressureUpdate = {
            [0] = function()
                fuelInterval = fuelDecreaseTime
            end,
            [85] = function()
                fuelInterval = fuelDecreaseTime
            end,
            [105] = function()
                fuelInterval = fuelInterval_105
            end,
            [125] = function()
                fuelInterval = fuelInterval_125
            end,
            [145] = function()
                fuelInterval = fuelInterval_145
            end,
            [165] = function()
                fuelInterval = fuelInterval_165
            end,
            [185] = function()
                fuelInterval = fuelInterval_185
            end,
            [205] = function()
                fuelInterval = fuelInterval_205
            end
        }
        if pressureUpdate[Pressure] then
            pressureUpdate[Pressure]()
            return fuelInterval
        end
    end
end)

AddEventHandler('bcc-boats:FuelMonitor', function()
    local decreaseTime = (BoatCfg.fuel.decreaseTime * 1000)
    local itemAmount = BoatCfg.fuel.itemAmount
    Wait(decreaseTime) -- Wait after starting engine
    while IsStarted do
        local interval = GetFuelUsageValues()
        if FuelLevel >= itemAmount then
            local newLevel = Core.Callback.TriggerAwait('bcc-boats:UpdateFuelLevel', MyBoatId, MyBoatModel)
            if newLevel then
                FuelLevel = newLevel
            end
        elseif FuelLevel < itemAmount then
            Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
            IsStarted = false
            Pressure = 0
            Speed = 1.0
            if Config.notify == 'vorp' then
                Core.NotifyRightTip(_U('outOfFuel'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('outOfFuel'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
            end
            break
        end
        Wait(interval) -- Interval to decrease fuel
    end
end)

function GetFuel()
    local currentFuel = Core.Callback.TriggerAwait('bcc-boats:GetFuelLevel', MyBoatId)
    if currentFuel then
        return currentFuel
    elseif currentFuel == nil then
        return 0
    end
end

AddEventHandler('bcc-boats:RepairMonitor', function()
    local decreaseTime = (BoatCfg.condition.decreaseTime * 1000)
    local decreaseTime_205 = (math.floor(decreaseTime - (decreaseTime * 0.50)))
    local itemAmount = BoatCfg.condition.itemAmount
    if not IsBoatDamaged then
        Wait(decreaseTime) -- Wait after spawning boat
    end
    while MyBoat ~= 0 do
        local interval = decreaseTime
        if Pressure == 205 then -- Over Pressure Penalty
            interval = decreaseTime_205
        end
        if RepairLevel >= itemAmount then
            IsBoatDamaged = false
            local newLevel = Core.Callback.TriggerAwait('bcc-boats:UpdateRepairLevel', MyBoatId, MyBoatModel)
            if newLevel then
                RepairLevel = newLevel
            end
        end
        if IsBoatDamaged then goto END end
        if RepairLevel < itemAmount then
            if IsSteamer then
                Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
                IsStarted = false
                Pressure = 0
                Speed = 1.0
            end
            SetBoatDamaged()
        end
        ::END::
        Wait(interval) -- Interval to decrease condition
    end
end)

function GetCondition()
    local condition = Core.Callback.TriggerAwait('bcc-boats:GetRepairLevel', MyBoatId, MyBoatModel)
    if condition then
        return condition
    elseif condition == nil then
        return 0
    end
end

AddEventHandler('bcc-boats:BoatPrompts', function()
    local promptDist = BoatCfg.distance
    local increase = Config.keys.increase
    local decrease = Config.keys.decrease

    while MyBoat ~= 0 do
        local playerPed = PlayerPedId()
        local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(MyBoat))
        local sleep = 1000

        if dist > promptDist then goto END end

        if IsPedInVehicle(playerPed, MyBoat, false) then
            sleep = 0
            local boatStatus
            if IsSteamer then
                boatStatus =  'speed: ~o~' .. tostring(Knots) .. '~s~knots | ' .. PSI .. tostring(Pressure)
                .. '~s~ | condition: ~o~' .. tostring(RepairLevel) .. '~s~ | fuel: ~o~' .. tostring(FuelLevel)
            else
                boatStatus = 'speed: ~o~' .. tostring(Knots) .. '~s~knots | ' .. 'condition: ~o~' .. tostring(RepairLevel)
            end
            PromptSetActiveGroupThisFrame(DriveGroup, CreateVarString(10, 'LITERAL_STRING', boatStatus), 1, 0, 0, 0)

            if Citizen.InvokeNative(0xC92AC953F0A982AE, AnchorPrompt) then  -- PromptHasStandardModeCompleted
                if IsBoatDamaged then goto END end

                if not IsAnchored then
                    Citizen.InvokeNative(0xAEAB044F05B92659, MyBoat, true) -- SetBoatAnchor
                    Citizen.InvokeNative(0x286771F3059A37A7, MyBoat, true) -- SetBoatRemainsAnchoredWhilePlayerIsDriver
                    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyBoat, true) -- FreezeEntityPosition
                    Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
                    IsAnchored = true
                    IsStarted = false
                    Pressure = 0
                    Speed = 1.0
                    PromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorUp')))
                else
                    Citizen.InvokeNative(0xAEAB044F05B92659, MyBoat, false) -- SetBoatAnchor
                    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyBoat, false) -- FreezeEntityPosition
                    IsAnchored = false
                    PromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorDown')))
                end
            end

            if Citizen.InvokeNative(0xC92AC953F0A982AE, MenuPrompt) then  -- PromptHasStandardModeCompleted
                OpenBoatMenu()
            end

            if IsSteamer then
                if IsControlJustPressed(0, increase) then
                    SteamBoatSpeed(true)
                end
                if IsControlJustPressed(0, decrease) then
                    SteamBoatSpeed(false)
                end
            end
        else
            sleep = 0
            -- Open Boat Menu when NOT Seated
            PromptSetActiveGroupThisFrame(ActionGroup, CreateVarString(10, 'LITERAL_STRING', MyBoatName), 1, 0, 0, 0)
            if Citizen.InvokeNative(0xC92AC953F0A982AE, ActionPrompt) then  -- PromptHasStandardModeCompleted
                OpenBoatMenu()
            end
        end
        ::END::
        Wait(sleep)
    end
end)

AddEventHandler('bcc-boats:TradeBoat', function()
    while Trading do
        local playerPed = PlayerPedId()
        local sleep = 1000

        if IsEntityDead(playerPed) or IsPedOnSpecificVehicle(playerPed, MyBoat) then
            Trading = false
            break
        end

        local closestPlayer, closestDistance = GetClosestPlayer()
        if closestPlayer and closestDistance <= 2.0 then
            sleep = 0
            PromptSetActiveGroupThisFrame(TradeGroup, CreateVarString(10, 'LITERAL_STRING', MyBoatName), 1, 0, 0, 0)
            if Citizen.InvokeNative(0xE0F65F0640EF0617, TradePrompt) then  -- PromptHasHoldModeCompleted
                local serverId = GetPlayerServerId(closestPlayer)
                local tradeComplete = Core.Callback.TriggerAwait('bcc-boats:SaveBoatTrade', serverId, MyBoatId, MyBoatModel)
                if tradeComplete then
                    ResetBoat()
                end
                Trading = false
            end
        end
        Wait(sleep)
    end
end)

function GetClosestPlayer()
    local players = GetActivePlayers()
    local player = PlayerId()
    local coords = GetEntityCoords(PlayerPedId())
    local closestDistance = nil
    local closestPlayer = nil
    for i = 1, #players, 1 do
        local target = GetPlayerPed(players[i])
        if players[i] ~= player then
            local distance = #(coords - GetEntityCoords(target))
            if closestDistance == nil or closestDistance > distance then
                closestPlayer = players[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

AddEventHandler('bcc-boats:BoatTag', function()
    local tagDist = BoatCfg.gamerTag.distance
    local tagId = Citizen.InvokeNative(0xE961BF23EAB76B12, MyBoat, MyBoatName) -- CreateMpGamerTagOnEntity
    while MyBoat ~= 0 do
        Wait(1000)
        local playerPed = PlayerPedId()
        local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(MyBoat))

        if dist < tagDist and not Citizen.InvokeNative(0xEC5F66E459AF3BB2, playerPed, MyBoat) then -- IsPedOnSpecificVehicle
            Citizen.InvokeNative(0x93171DDDAB274EB8, tagId, 3) -- SetMpGamerTagVisibility
        else
            if Citizen.InvokeNative(0x502E1591A504F843, tagId, MyBoat) then -- IsMpGamerTagActiveOnEntity
                Citizen.InvokeNative(0x93171DDDAB274EB8, tagId, 0) -- SetMpGamerTagVisibility
            end
        end
    end
    Citizen.InvokeNative(0x839BFD7D7E49FE09, Citizen.PointerValueIntInitialized(tagId)) -- RemoveMpGamerTag
end)

-- Set Blip on Launched Boat when Empty
AddEventHandler('bcc-boats:BoatBlip', function()
    local blip
    while MyBoat ~= 0 do
        Wait(1000)
        if Citizen.InvokeNative(0xEC5F66E459AF3BB2, PlayerPedId(), MyBoat) then -- IsPedOnSpecificVehicle
            if blip then
                RemoveBlip(blip)
                blip = nil
            end
        else
            if not blip then
                blip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, 1664425300, MyBoat) -- BlipAddForEntity
                SetBlipSprite(blip, BoatCfg.blip.sprite, true)
                Citizen.InvokeNative(0x9CB1A1623062F402, blip, MyBoatName) -- SetBlipName
            end
        end
    end
end)

RegisterNUICallback('SellBoat', function(data, cb)
    cb('ok')
    DeleteEntity(MyEntity)
    Cam = false
    local boatSold = Core.Callback.TriggerAwait('bcc-boats:SellBoat', data)
    if boatSold then
        BoatMenu()
    end
end)

RegisterNUICallback('CloseMenu', function(data, cb)
    cb('ok')
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)

    if ShopEntity ~= 0 then
        DeleteEntity(ShopEntity)
        ShopEntity = 0
    end

    if MyEntity ~= 0 then
        DeleteEntity(MyEntity)
        MyEntity = 0
    end

    Cam = false
    DestroyAllCams(true)
    DisplayRadar(true)
    InMenu = false
    ClearPedTasks(PlayerPedId())
end)

-- Reopen Menu After Sell or Failed Purchase
function BoatMenu()
    if ShopEntity ~= 0 then
        DeleteEntity(ShopEntity)
        ShopEntity = 0
    end

    local boatData = Core.Callback.TriggerAwait('bcc-boats:GetBoats')
    if boatData then
        SendNUIMessage({
            action = 'show',
            shopData = JobMatchedBoats,
            location = ShopName,
            myBoatsData = boatData
        })
        SetNuiFocus(true, true)
    end
end

-- Return Boat Using Prompt at Shop Location
function ReturnBoat(site)
    local playerPed = PlayerPedId()
    local siteCfg = Sites[site]
    if Citizen.InvokeNative(0xA3EE4A07279BB9DB, playerPed, MyBoat) then -- IsPedInVehicle
        DoScreenFadeOut(500)
        Wait(300)
        TaskLeaveVehicle(playerPed, MyBoat, 0)
        Wait(200)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, playerPed, siteCfg.player.coords, siteCfg.player.heading) -- SetEntityCoordsAndHeading
        ResetBoat()
        Wait(500)
        DoScreenFadeIn(500)
    else
        if Config.notify == 'vorp' then
            Core.NotifyRightTip(_U('noReturn'), 4000)
        elseif Config.notify == 'ox' then
            lib.notify({description = _U('noReturn'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
        end
    end
end

local function GetControlOfBoat()
    while not NetworkHasControlOfEntity(MyBoat) do
        NetworkRequestControlOfEntity(MyBoat)
        Wait(10)
    end
end

function ResetBoat()
    if MyBoat ~= 0 then
        GetControlOfBoat()
        DeleteEntity(MyBoat)
        MyBoat = 0
    end
    Pressure = 0
    Speed = 1.0
    IsPortable = false
    IsSteamer = false
    IsLarge = false
    Trading = false
    IsAnchored = false
    PromptsStarted = false
    PromptDelete(AnchorPrompt)
    PromptDelete(TradePrompt)
    PromptDelete(SteamPrompt)
    PromptDelete(MenuPrompt)
    PromptDelete(ActionPrompt)
end

-- Camera to View Boats
function CreateCamera()
    BoatCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(BoatCam, SiteCfg.boat.camera.x, SiteCfg.boat.camera.y, SiteCfg.boat.camera.z + 1.2 )
    SetCamActive(BoatCam, true)
    PointCamAtCoord(BoatCam, SiteCfg.boat.coords.x, SiteCfg.boat.coords.y, SiteCfg.boat.coords.z)
    SetCamFov(BoatCam, 25.0)
    DoScreenFadeOut(500)
    Wait(500)
    DoScreenFadeIn(500)
    RenderScriptCams(true, false, 0, false, false, 0)
end

function CameraLighting()
    local coords = SiteCfg.boat.coords
    while Cam do
        Wait(0)
        Citizen.InvokeNative(0xD2D9E04C0DF927F4, coords.x, coords.y, coords.z + 3, 13, 28, 46, 5.0, 10.0) -- DrawLightWithRange
    end
end

-- Rotate Boats while Viewing
RegisterNUICallback('Rotate', function(data, cb)
    cb('ok')
    local direction = data.RotateBoat
    if direction == 'left' then
        Rotation(20)
    elseif direction == 'right' then
        Rotation(-20)
    end
end)

function Rotation(dir)
    if (BoatModel == 'ship_nbdGuama') or (BoatModel == 'turbineboat') or (BoatModel == 'tugboat2') or (BoatModel == 'horseBoat') then
        return
    end

    if MyEntity ~= 0 then
        local ownedRot = GetEntityHeading(MyEntity) + dir
        SetEntityHeading(MyEntity, ownedRot % 360)

    elseif ShopEntity ~= 0 then
        local shopRot = GetEntityHeading(ShopEntity) + dir
        SetEntityHeading(ShopEntity, shopRot % 360)
    end
end

function CheckPlayerJob(boatman, site, speed)
    local result = Core.Callback.TriggerAwait('bcc-boats:CheckJob', boatman, site, speed)
    if boatman and result then
        IsBoatman = false
        if result[1] then
            IsBoatman = true
        end
    elseif site and result then
        HasJob = false
        if result[1] then
            HasJob = true
        elseif Sites[site].shop.jobsEnabled then
            if Config.notify == 'vorp' then
                Core.NotifyRightTip(_U('needJob'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('needJob'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
            end
        end
    elseif speed and result then
        HasSpeedJob = false
        if result[1] then
            HasSpeedJob = true
        end
    end
    JobMatchedBoats = FindBoatsByJob(result[2])
end

RegisterCommand('boatEnter', function(source, args, rawCommand)
    if MyBoat == 0 then
        if Config.notify == 'vorp' then
            Core.NotifyRightTip(_U('noBoat'), 5000)

        elseif Config.notify =='ox' then
            lib.notify({description = _U('noBoat'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
        end
        return
    end

    if not Citizen.InvokeNative(0xE052C1B1CAA4ECE4, MyBoat, -1) then return end -- IsVehicleSeatFree

    local playerPed = PlayerPedId()
    local callDist = #(GetEntityCoords(playerPed) - GetEntityCoords(MyBoat))
    if callDist < 50 then
        DoScreenFadeOut(500)
        Wait(500)
        SetPedIntoVehicle(playerPed, MyBoat, -1)
        Wait(500)
        DoScreenFadeIn(500)
    else
        if Config.notify == 'vorp' then
            Core.NotifyRightTip(_U('tooFar'), 5000)

        elseif Config.notify == 'ox' then
            lib.notify({description = _U('tooFar'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
        end
        return
    end
end, false)

-- Calm the Guarma Sea
RegisterNetEvent('vorp:SelectedCharacter', function(charid)
    if Config.guarma.enable then
        Citizen.InvokeNative(0xC63540AEF8384732, 0.0, 50.04, 1, 1.15, 1.28, -1082130432, 1.86, 8.1, 1) -- SetOceanGuarmaWaterQuadrant
    end
end)

-- Prevents Boat from Sinking
CreateThread(function()
    while true do
        Wait(0)
        Citizen.InvokeNative(0xC1E8A365BF3B29F2, PlayerPedId(), 364, 1) -- SetPedResetFlag / IgnoreDrownAndKillVolumes
    end
end)

function StartPrompts()
    if not Config.oxtarget then
        ShopPrompt = PromptRegisterBegin()
        PromptSetControlAction(ShopPrompt, Config.keys.shop)
        PromptSetText(ShopPrompt, CreateVarString(10, 'LITERAL_STRING', _U('shopPrompt')))
        PromptSetEnabled(ShopPrompt, true)
        PromptSetVisible(ShopPrompt, true)
        PromptSetStandardMode(ShopPrompt, true)
        PromptSetGroup(ShopPrompt, ShopGroup, 0)
        PromptRegisterEnd(ShopPrompt)
    end

    ReturnPrompt = PromptRegisterBegin()
    PromptSetControlAction(ReturnPrompt, Config.keys.ret)
    PromptSetText(ReturnPrompt, CreateVarString(10, 'LITERAL_STRING', _U('returnPrompt')))
    PromptSetEnabled(ReturnPrompt, true)
    PromptSetVisible(ReturnPrompt, false)
    PromptSetStandardMode(ReturnPrompt, true)
    PromptSetGroup(ReturnPrompt, DriveGroup, 0)
    PromptRegisterEnd(ReturnPrompt)

    LootPrompt = PromptRegisterBegin()
    PromptSetControlAction(LootPrompt, Config.keys.loot)
    PromptSetText(LootPrompt, CreateVarString(10, 'LITERAL_STRING', _U('lootBoatPrompt')))
    PromptSetEnabled(LootPrompt, true)
    PromptSetVisible(LootPrompt, true)
    PromptSetStandardMode(LootPrompt, true)
    PromptSetGroup(LootPrompt, LootGroup, 0)
    PromptRegisterEnd(LootPrompt)
end

function StartBoatPrompts()
    AnchorPrompt = PromptRegisterBegin()
    PromptSetControlAction(AnchorPrompt, Config.keys.anchor)
    if BoatCfg.anchored then
        PromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorUp')))
    else
        PromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorDown')))
    end
    PromptSetEnabled(AnchorPrompt, true)
    PromptSetVisible(AnchorPrompt, true)
    PromptSetStandardMode(AnchorPrompt, true)
    PromptSetGroup(AnchorPrompt, DriveGroup, 0)
    PromptRegisterEnd(AnchorPrompt)

    if IsSteamer then
        SteamPrompt = PromptRegisterBegin()
        PromptSetControlAction(SteamPrompt, Config.keys.increase)
        PromptSetControlAction(SteamPrompt, Config.keys.decrease)
        PromptSetText(SteamPrompt, CreateVarString(10, 'LITERAL_STRING', _U('steamPrompt')))
        PromptSetEnabled(SteamPrompt, true)
        PromptSetVisible(SteamPrompt, true)
        PromptSetStandardMode(SteamPrompt, true)
        PromptSetGroup(SteamPrompt, DriveGroup, 0)
        PromptRegisterEnd(SteamPrompt)
    end

    MenuPrompt = PromptRegisterBegin()
    PromptSetControlAction(MenuPrompt, Config.keys.menu)
    PromptSetText(MenuPrompt, CreateVarString(10, 'LITERAL_STRING', _U('boatMenuPrompt')))
    PromptSetEnabled(MenuPrompt, true)
    PromptSetVisible(MenuPrompt, true)
    PromptSetStandardMode(MenuPrompt, true)
    PromptSetGroup(MenuPrompt, DriveGroup, 0)
    PromptRegisterEnd(MenuPrompt)

    ActionPrompt = PromptRegisterBegin()
    PromptSetControlAction(ActionPrompt, Config.keys.action)
    PromptSetText(ActionPrompt, CreateVarString(10, 'LITERAL_STRING', _U('boatMenuPrompt')))
    PromptSetEnabled(ActionPrompt, true)
    PromptSetVisible(ActionPrompt, true)
    PromptSetStandardMode(ActionPrompt, true)
    PromptSetGroup(ActionPrompt, ActionGroup, 0)
    PromptRegisterEnd(ActionPrompt)
end

AddEventHandler('bcc-boats:StartTradePrompts', function()
    if not PromptsStarted then
        TradePrompt = PromptRegisterBegin()
        PromptSetControlAction(TradePrompt, Config.keys.trade)
        PromptSetText(TradePrompt, CreateVarString(10, 'LITERAL_STRING', _U('tradePrompt')))
        PromptSetEnabled(TradePrompt, true)
        PromptSetVisible(TradePrompt, true)
        PromptSetHoldMode(TradePrompt, 2000)
        PromptSetGroup(TradePrompt, TradeGroup, 0)
        PromptRegisterEnd(TradePrompt)

        PromptsStarted = true
    end
end)

function ManageBlip(site, closed)
    local siteCfg = Sites[site]

    if closed and not siteCfg.blip.show.closed then
        if Sites[site].Blip then
            RemoveBlip(Sites[site].Blip)
            Sites[site].Blip = nil
        end
        return
    end

    if not Sites[site].Blip then
        siteCfg.Blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, siteCfg.npc.coords) -- BlipAddForCoords
        SetBlipSprite(siteCfg.Blip, siteCfg.blip.sprite, true)
        Citizen.InvokeNative(0x9CB1A1623062F402, siteCfg.Blip, siteCfg.blip.name) -- SetBlipNameFromPlayerString
    end

    local color = siteCfg.blip.color.open
    if siteCfg.shop.jobsEnabled then color = siteCfg.blip.color.job end
    if closed then color = siteCfg.blip.color.closed end
    Citizen.InvokeNative(0x662D364ABF16DE2F, Sites[site].Blip, joaat(Config.BlipColors[color])) -- BlipAddModifier
end

function AddNPC(site)
    local siteCfg = Sites[site]
    if not siteCfg.NPC then
        local modelName = siteCfg.npc.model
        local model = joaat(modelName)
        LoadModel(model, modelName)

        -- Create the NPC
        siteCfg.NPC = CreatePed(model, siteCfg.npc.coords.x, siteCfg.npc.coords.y, siteCfg.npc.coords.z - 1.0, siteCfg.npc.heading, false, false, false, false)
        Citizen.InvokeNative(0x283978A15512B2FE, siteCfg.NPC, true) -- SetRandomOutfitVariation
        SetEntityCanBeDamaged(siteCfg.NPC, false)
        SetEntityInvincible(siteCfg.NPC, true)
        Wait(500)
        FreezeEntityPosition(siteCfg.NPC, true)
        SetBlockingOfNonTemporaryEvents(siteCfg.NPC, true)

        -- Check for ox_target configuration
        if Config.oxtarget then
            exports.ox_target:addLocalEntity(siteCfg.NPC, {
                {
                    name = 'shopInteraction',
                    label = siteCfg.shop.prompt,
                    icon = 'fa-solid fa-ship',
                    canInteract = function(entity)
                        return entity == siteCfg.NPC
                    end,
                    onSelect = function()
                        ManageShopAction(site, siteCfg.shop.jobsEnabled)
                    end,
                    distance = Config.oxdistance
                }
            })
        end
    end
end

function RemoveNPC(site)
    local siteCfg = Sites[site]
    if siteCfg.NPC then
        DeleteEntity(siteCfg.NPC)
        siteCfg.NPC = nil
    end
end

function LoadModel(model, modelName)
    if not IsModelValid(model) then
        return print('Invalid model:', modelName)
    end
    RequestModel(model, false)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

-- to count length of maps
local function len(t)
    local counter = 0
    for _, _ in pairs(t) do
        counter += 1
    end
    return counter
end

--let's go fancy with an implementation that orders pairs for you using default table.sort(). Taken from a lua-users post.
local function __genOrderedIndex(t)
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert(orderedIndex, key)
    end
    table.sort(orderedIndex)
    return orderedIndex
end

local function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.
    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex(t)
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1, #(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i + 1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

local function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end

 function FindBoatsByJob(job)
    local matchingBoats = {}
    for _, boatType in ipairs(Boats) do
        local matchingModels = {}
        for boatModel, boatModelData in orderedPairs(boatType.models) do
            -- using maps to break a loop, though technically making another loop, albeit simpler. Preferably you already configure jobs as a map so that you could expand
            -- perhaps when a request comes to have boat accesses by job grade or similar
            local boatJobs = {}
            for _, boatJob in pairs(boatModelData.job) do
                boatJobs[boatJob] = boatJob
            end
            -- add matching boat directly 
            if boatJobs[job] ~= nil then
                matchingModels[boatModel] = {
                    label = boatModelData.label,
                    cashPrice = boatModelData.price.cash,
                    goldPrice = boatModelData.price.gold,
                    invLimit = boatModelData.invLimit,
                    job = boatModelData.job
                }
            end
            --handle case where there isn\t a job attached to boat config
            if len(boatJobs) == 0 then
                matchingModels[boatModel] = {
                    label = boatModelData.label,
                    cashPrice = boatModelData.price.cash,
                    goldPrice = boatModelData.price.gold,
                    invLimit = boatModelData.invLimit,
                    job = nil
                }
            end
        end

        if len(matchingModels) > 0 then
            matchingBoats[#matchingBoats + 1] = {
                type = boatType.type,
                models = matchingModels
            }
        end
    end
    return matchingBoats
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if InMenu == true then
        SendNUIMessage({
            action = 'hide'
        })
        SetNuiFocus(false, false)
    end
    ClearPedTasksImmediately(PlayerPedId())
    DestroyAllCams(true)
    DisplayRadar(true)
    ResetBoat()

    if MyEntity ~= 0 then
        DeleteEntity(MyEntity)
        MyEntity = 0
    end

    if ShopEntity ~= 0 then
        DeleteEntity(ShopEntity)
        ShopEntity = 0
    end

    for _, siteCfg in pairs(Sites) do
        if siteCfg.Blip then
            RemoveBlip(siteCfg.Blip)
            siteCfg.Blip = nil
        end
        if siteCfg.NPC then
            DeleteEntity(siteCfg.NPC)
            siteCfg.NPC = nil
        end
    end
end)
