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
IsSteamer, IsLarge, IsPortable, IsBoatDamaged, IsFishing = false, false, false, false, false
BoatCfg = {}
FuelEnabled, ConditionEnabled, SetWrecked, Trading = false, false, false, false
local Knots, SpeedIncrement = 0, 0
local Speed, Pressure, PSI = 1.0, 0, 'psi: ~o~'
local ShopName, SiteCfg, BoatCam
local ShopEntity, MyEntity, BoatModel = 0, 0, nil
local InMenu, Cam, IsAnchored = false, false, false
local HasJob, IsBoatman, HasSpeedJob = false, false, false
local ReturnVisible, IsShopClosed, IsStarted = false, false, false

-- Initialize random seed for better math.random usage
math.randomseed(GetGameTimer() + GetRandomIntInRange(1, 1000))

local function StartPrompts()
    if not Config.oxtarget then
        ShopPrompt = UiPromptRegisterBegin()
        UiPromptSetControlAction(ShopPrompt, Config.keys.shop)
        UiPromptSetText(ShopPrompt, CreateVarString(10, 'LITERAL_STRING', _U('shopPrompt')))
        UiPromptSetEnabled(ShopPrompt, true)
        UiPromptSetVisible(ShopPrompt, true)
        UiPromptSetStandardMode(ShopPrompt, true)
        UiPromptSetGroup(ShopPrompt, ShopGroup, 0)
        UiPromptRegisterEnd(ShopPrompt)
    end

    ReturnPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(ReturnPrompt, Config.keys.ret)
    UiPromptSetText(ReturnPrompt, CreateVarString(10, 'LITERAL_STRING', _U('returnPrompt')))
    UiPromptSetEnabled(ReturnPrompt, true)
    UiPromptSetVisible(ReturnPrompt, false)
    UiPromptSetStandardMode(ReturnPrompt, true)
    UiPromptSetGroup(ReturnPrompt, DriveGroup, 0)
    UiPromptRegisterEnd(ReturnPrompt)

    LootPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(LootPrompt, Config.keys.loot)
    UiPromptSetText(LootPrompt, CreateVarString(10, 'LITERAL_STRING', _U('lootBoatPrompt')))
    UiPromptSetEnabled(LootPrompt, true)
    UiPromptSetVisible(LootPrompt, true)
    UiPromptSetStandardMode(LootPrompt, true)
    UiPromptSetGroup(LootPrompt, LootGroup, 0)
    UiPromptRegisterEnd(LootPrompt)
end

local function isShopClosed(siteCfg)
    local hour = GetClockHours()
    local hoursActive = siteCfg.shop.hours.active

    if not hoursActive then
        return false
    end

    local openHour = siteCfg.shop.hours.open
    local closeHour = siteCfg.shop.hours.close

    if openHour < closeHour then
        -- Normal: shop opens and closes on the same day
        return hour < openHour or hour >= closeHour
    else
        -- Overnight: shop closes on the next day
        return hour < openHour and hour >= closeHour
    end
end

local function ManageSiteBlip(site, closed)
    local siteCfg = Sites[site]

    if (closed and not siteCfg.blip.show.closed) or (not siteCfg.blip.show.open) then
        if siteCfg.Blip then
            RemoveBlip(siteCfg.Blip)
            siteCfg.Blip = nil
        end
        return
    end

    if not siteCfg.Blip then
        siteCfg.Blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, siteCfg.npc.coords) -- BlipAddForCoords
        SetBlipSprite(siteCfg.Blip, siteCfg.blip.sprite, true)
        Citizen.InvokeNative(0x9CB1A1623062F402, siteCfg.Blip, siteCfg.blip.name)               -- SetBlipName
    end

    local color = siteCfg.blip.color.open
    if siteCfg.shop.jobsEnabled then color = siteCfg.blip.color.job end
    if closed then color = siteCfg.blip.color.closed end

    if Config.BlipColors[color] then
        Citizen.InvokeNative(0x662D364ABF16DE2F, siteCfg.Blip, joaat(Config.BlipColors[color])) -- BlipAddModifier
    else
        print('Error: Blip color not defined for color: ' .. tostring(color))
    end
end

local function LoadModel(model, modelName)
    if not IsModelValid(model) then
        return print('Invalid model:', modelName)
    end

    if not HasModelLoaded(model) then
        RequestModel(model, false)

        local timeout = 10000
        local startTime = GetGameTimer()

        while not HasModelLoaded(model) do
            if GetGameTimer() - startTime > timeout then
                print('Failed to load model:', modelName)
                return
            end
            Wait(10)
        end
    end
end

local function AddNPC(site)
    local siteCfg = Sites[site]
    local coords = siteCfg.npc.coords

    if not siteCfg.NPC then
        local modelName = siteCfg.npc.model
        local model = joaat(modelName)
        LoadModel(model, modelName)

        siteCfg.NPC = CreatePed(model, coords.x, coords.y, coords.z, siteCfg.npc.heading, false, false, false, false)
        Citizen.InvokeNative(0x283978A15512B2FE, siteCfg.NPC, true) -- SetRandomOutfitVariation

        --TaskStartScenarioInPlace(siteCfg.NPC, "WORLD_HUMAN_SMOKING", -1, true)
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
                        if not IsShopClosed then
                            CheckPlayerJob(false, site, false)
                            if siteCfg.shop.jobsEnabled then
                                if not HasJob then return end
                            end
                            OpenMenu(site)
                        else
                            lib.notify({description = siteCfg.shop.name .. _U('hours') .. ' ' .. siteCfg.shop.hours.open .. ':00 ' .. _U('to') .. ' ' .. siteCfg.shop.hours.close .. ':00', duration = 4000, type = 'inform', iconColor = 'white', style = Config.oxstyle, position = Config.oxposition})
                        end
                    end,
                    distance = Config.oxdistance
                }
            })
        end
    end
end

local function RemoveNPC(site)
    local siteCfg = Sites[site]

    if siteCfg.NPC then
        DeleteEntity(siteCfg.NPC)
        siteCfg.NPC = nil
    end
end

CreateThread(function()
    StartPrompts()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = 1000

        if InMenu or IsEntityDead(playerPed) then
            Wait(1000)
            goto END
        end

        for site, siteCfg in pairs(Sites) do
            local distance = #(playerCoords - siteCfg.npc.coords)
            IsShopClosed = isShopClosed(siteCfg)

            ManageSiteBlip(site, IsShopClosed)

            if distance > siteCfg.npc.distance or IsShopClosed then
                RemoveNPC(site)
            elseif siteCfg.npc.active then
                AddNPC(site)
            end

            if not Config.oxtarget then
                if distance <= siteCfg.shop.distance and not IsPedInAnyBoat(playerPed) and not IsPedSwimming(playerPed) then
                    sleep = 0
                    local promptText = IsShopClosed and siteCfg.shop.name .. _U('hours') .. siteCfg.shop.hours.open .. _U('to') ..
                    siteCfg.shop.hours.close .. _U('hundred') or siteCfg.shop.prompt

                    UiPromptSetActiveGroupThisFrame(ShopGroup, CreateVarString(10, 'LITERAL_STRING', promptText), 1, 0, 0, 0)
                    UiPromptSetEnabled(ShopPrompt, not IsShopClosed)

                    if not IsShopClosed then
                        if Citizen.InvokeNative(0xC92AC953F0A982AE, ShopPrompt) then -- UiPromptHasStandardModeCompleted
                            CheckPlayerJob(false, site, false)
                            if siteCfg.shop.jobsEnabled then
                                if not HasJob then goto END end
                            end
                            OpenMenu(site)
                        end
                        goto END
                    end
                end
            end

            if distance <= siteCfg.boat.distance and IsPedInVehicle(playerPed, MyBoat, false) then
                sleep = 0
                UiPromptSetVisible(ReturnPrompt, true)
                ReturnVisible = true
                if Citizen.InvokeNative(0xC92AC953F0A982AE, ReturnPrompt) then -- UiPromptHasStandardModeCompleted
                    ReturnBoat(site)
                end
                goto END
            end

            if ReturnVisible then
                if distance > siteCfg.boat.distance then
                    UiPromptSetVisible(ReturnPrompt, false)
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
            translations = Translations,
            location = ShopName,
            myBoatsData = data,
            currencyType = Config.currency
        })
        SetNuiFocus(true, true)
    else
        print('Failed to load boats data.')
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
                    translations = Translations,
                    location = ShopName,
                    myBoatsData = boatData,
                    currencyType = Config.currency
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

    BoatModel = data.boatModel
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

    if not SetWrecked then
        StatusNotification('repair')
    end

    Citizen.InvokeNative(0xAEAB044F05B92659, MyBoat, true) -- SetBoatAnchor
    Citizen.InvokeNative(0x286771F3059A37A7, MyBoat, true) -- SetBoatRemainsAnchoredWhilePlayerIsDriver
    if IsLarge then
        FreezeEntityPosition(MyBoat, true)
    end
    SetEntityCollision(MyBoat, true, true)
    IsAnchored = true
    Speed = 1.0
    PromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorUp')))
    DBG:Info(string.format('Boat set damaged and anchored id=%s', tostring(MyBoatId)))
end

RegisterNUICallback('SpawnData', function(data, cb)
    cb('ok')
    TriggerEvent('bcc-boats:SpawnBoat', data.boatId, data.boatModel, data.boatName, false)
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
    IsFishing = BoatCfg.fishing
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
        if IsLarge then
            FreezeEntityPosition(MyBoat, true)
        end
        SetEntityCollision(MyBoat, true, true)
        IsAnchored = true
        DBG:Info(string.format('Boat anchored on spawn id=%s', tostring(MyBoatId)))
    end

    if IsSteamer then
        Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
        IsStarted = false
        Speed = 1.0
        if FuelEnabled then
            FuelLevel = GetFuel()
        end
        if BoatCfg and BoatCfg.speed and BoatCfg.speed.enabled then
            CheckPlayerJob(false, false, BoatCfg.speed)
            local inc = tonumber(BoatCfg.speed.increment) or 0
            local bonus = tonumber(BoatCfg.speed.bonus) or 0
            if HasSpeedJob then
                SpeedIncrement = inc + bonus
            else
                SpeedIncrement = inc
            end
        else
            SpeedIncrement = 0
        end
    end

    -- Debug: log basic boat spawn info
    DBG:Info(string.format('Spawned boat id=%s model=%s portable=%s', tostring(MyBoatId), tostring(MyBoatModel), tostring(portable)))

    RepairLevel = ConditionEnabled and GetCondition() or 100
    if ConditionEnabled then
        if RepairLevel < BoatCfg.condition.itemAmount then
            SetBoatDamaged()
        end

        TriggerEvent('bcc-boats:RepairMonitor')
        TriggerEvent('bcc-boats:DamageMonitor')
        TriggerEvent('bcc-boats:WreckedMonitor')
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
        -- Prevent increasing steam while the boat is anchored
        if IsAnchored then
            if Config.notify == 'vorp' then
                Core.NotifyRightTip(_U('anchorRaiseFirst'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('anchorRaiseFirst'), type = 'inform', style = Config.oxstyle, position = Config.oxposition})
            end
            return
        end
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
                    StatusNotification('repair')
                    return
                end
            end

            Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, true, true) -- SetVehicleEngineOn
            IsStarted = true
            Pressure = 85
            Speed = 1.0
            DBG:Info(string.format('Engine started for boatId=%s; SpeedIncrement=%s', tostring(MyBoatId), tostring(SpeedIncrement)))
            if FuelEnabled then
                TriggerEvent('bcc-boats:FuelMonitor')
            end
            Citizen.InvokeNative(0x35AD938C74CACD6A, MyBoat, Speed) -- ModifyVehicleTopSpeed
            return
        end

        if BoatCfg and BoatCfg.speed and BoatCfg.speed.enabled then
            local inc = tonumber(SpeedIncrement) or 0
            local maxSpeed = ((inc * 6) + 1.0)
            Speed = Speed + inc
            if Speed > maxSpeed then Speed = maxSpeed goto END end

            Pressure = Pressure + 20
            if Pressure > 205 then Pressure = 205 end
        end
    else
        local inc = tonumber(SpeedIncrement) or 0
        Speed = Speed - inc
        if Speed < 1.0 then Speed = 1.0 end

        Pressure = Pressure - 20
        if Pressure < 85 then
            Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
            IsStarted = false
            Pressure = 0
            Speed = 1.0
            DBG:Info(string.format('Engine stopped for boatId=%s', tostring(MyBoatId)))
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
            -- Server now returns a plain scalar (level) or false on error
            if newLevel == false then
                DBG:Warning('FuelMonitor: UpdateFuelLevel returned false')
            else
                FuelLevel = tonumber(newLevel) or FuelLevel
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
            -- Debug: notify out-of-fuel event
            DBG:Info(string.format('Boat out of fuel for boatId=%s', tostring(MyBoatId)))
            break
        end
        Wait(interval) -- Interval to decrease fuel
    end
end)

function GetFuel()
    local res = Core.Callback.TriggerAwait('bcc-boats:GetFuelLevel', MyBoatId)
    -- Server returns a plain number (level) or false on error
    if res == false then
        DBG:Warning('GetFuel: callback returned false')
        return 0
    end
    return tonumber(res) or 0
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
            local newLevel = Core.Callback.TriggerAwait('bcc-boats:UpdateRepairLevel', MyBoatId, MyBoatModel, false, nil)
            -- Server returns numeric level or false on error
            if newLevel == false then
                DBG:Warning('RepairMonitor: UpdateRepairLevel returned false')
            else
                RepairLevel = tonumber(newLevel) or RepairLevel
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
    local res = Core.Callback.TriggerAwait('bcc-boats:GetRepairLevel', MyBoatId, MyBoatModel)
    -- Server returns numeric level or false on error
    if res == false then
        DBG:Warning('GetCondition: callback returned false')
        return 0
    end
    return tonumber(res) or 0
end

local function AdjustCondition(damageValue)
    -- Defensive: ensure damageValue is a sane integer within expected bounds
    local dv = tonumber(damageValue) or 0
    if dv ~= dv then dv = 0 end -- guard against NaN
    dv = math.floor(dv)

    local maxDamage = 100
    if BoatCfg and BoatCfg.condition and BoatCfg.condition.maxAmount then
        maxDamage = tonumber(BoatCfg.condition.maxAmount) or maxDamage
    end
    dv = math.max(0, math.min(dv, maxDamage))

    if dv <= 0 then
        DBG:Info(string.format('AdjustCondition: ignored non-positive damageValue=%s for boatId=%s', tostring(dv), tostring(MyBoatId)))
        return
    end

    -- Call server callback in protected call to avoid runtime errors bubbling up
    local ok, res = pcall(function()
        return Core.Callback.TriggerAwait('bcc-boats:UpdateRepairLevel', MyBoatId, MyBoatModel, true, dv)
    end)
    if not ok then
        DBG:Warning(string.format('AdjustCondition: callback failed: %s', tostring(res)))
        return
    end

    -- Server returns numeric level or false on error
    if res == false then
        DBG:Warning(string.format('AdjustCondition: server error for boatId=%s', tostring(MyBoatId)))
        return
    end
    if not res then
        DBG:Warning(string.format('AdjustCondition: missing level for boatId=%s in response', tostring(MyBoatId)))
        return
    end
    RepairLevel = tonumber(res) or RepairLevel
    StatusNotification('damaged')
end

AddEventHandler('bcc-boats:DamageMonitor', function()
    CreateThread(function()
        while MyBoat ~= 0 do
            Wait(0)

            local size = GetNumberOfEvents(0)
            if size > 0 then
                for i = 0, size - 1 do
                    local event = Citizen.InvokeNative(0xA85E614430EFF816, 0, i) -- GetEventAtIndex

                    if event == 402722103 then -- EVENT_ENTITY_DAMAGED
                        local eventDataSize = 9
                        local eventDataStruct = DataView.ArrayBuffer(128)
                        eventDataStruct:SetInt32(0, 0)  -- Damaged Entity Id
                        eventDataStruct:SetInt32(8, 0)  -- Object/Ped Id that Damaged Entity
                        eventDataStruct:SetInt32(16, 0) -- Weapon Hash that Damaged Entity
                        eventDataStruct:SetInt32(24, 0) -- Ammo Hash that Damaged Entity
                        eventDataStruct:SetInt32(32, 0) -- (float) Damage Amount
                        eventDataStruct:SetInt32(40, 0) -- Unknown
                        eventDataStruct:SetInt32(48, 0) -- (float) Entity Coord x
                        eventDataStruct:SetInt32(56, 0) -- (float) Entity Coord y
                        eventDataStruct:SetInt32(64, 0) -- (float) Entity Coord z

                        local data = Citizen.InvokeNative(0x57EC5FA4D4D6AFCA, 0, i, eventDataStruct:Buffer(), eventDataSize) -- GetEventData
                        local entity = eventDataStruct:GetInt32(0)

                        if data and entity and entity == MyBoat then
                            if ConditionEnabled then
                                -- Safely attempt to read the float damage amount from the event data
                                local ok, rawDamage = pcall(function() return eventDataStruct:GetFloat32(32) end)
                                if not ok or rawDamage == nil then
                                    DBG:Warning(string.format('Failed to read damage event data for boatId=%s', tostring(MyBoatId)))
                                    goto CONTINUE_AFTER_DAMAGE
                                end

                                -- Defensive numeric checks
                                if type(rawDamage) ~= 'number' or rawDamage ~= rawDamage then -- NaN check
                                    DBG:Warning(string.format('Invalid raw damage read (%s) for boatId=%s', tostring(rawDamage), tostring(MyBoatId)))
                                    goto CONTINUE_AFTER_DAMAGE
                                end

                                -- Normalize and clamp the damage values
                                local computed = math.ceil(rawDamage / 5)
                                local damageValue = tonumber(computed) or 0
                                if damageValue ~= damageValue then damageValue = 0 end
                                -- Use boat condition max as upper bound when available
                                local maxDamage = 100
                                if BoatCfg and BoatCfg.condition and BoatCfg.condition.maxAmount then
                                    maxDamage = tonumber(BoatCfg.condition.maxAmount) or maxDamage
                                end
                                damageValue = math.max(0, math.min(damageValue, maxDamage))

                                DBG:Info(string.format('Boat Damage Value: %s (raw=%s)', tostring(damageValue), tostring(rawDamage)))

                                AdjustCondition(damageValue)
                            else
                                Citizen.InvokeNative(0x55CCAAE4F28C67A0, MyBoat, 1000.0) -- SetVehicleBodyHealth
                                Citizen.InvokeNative(0x79811282A9D1AE56, MyBoat) -- SetVehicleFixed
                                DBG:Info(string.format('Boat Repaired (Condition Disabled)'))
                            end
                        end
                        ::CONTINUE_AFTER_DAMAGE::
                    end
                end
            end
        end
    end)
end)

AddEventHandler('bcc-boats:WreckedMonitor', function()
    while MyBoat ~= 0 do
        local isWrecked = Citizen.InvokeNative(0xDDBEA5506C848227, MyBoat) -- IsVehicleWrecked

        if isWrecked and not SetWrecked then
            local updated = Core.Callback.TriggerAwait('bcc-boats:SetWreckedCondition', MyBoatId)
            -- Inline parse of updated response
            local ok, err
            if type(updated) == 'table' then
                if updated.ok == true then
                    ok = true
                else
                    ok = false
                    err = updated.error or 'unknown_error'
                end
            else
                ok = (updated == true or updated == 1)
            end
            if err then
                DBG:Warning(string.format('WreckedMonitor: SetWreckedCondition error=%s', tostring(err)))
            end

            if ok == true then
                RepairLevel = 0
                StatusNotification('wrecked')
                SetWrecked = true

                local playerPed = PlayerPedId()
                if IsPedOnSpecificVehicle(playerPed, MyBoat) then
                    TaskLeaveVehicle(playerPed, MyBoat, 0)
                    Wait(1000)
                end

                if IsSteamer then
                    Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
                    IsStarted = false
                    Pressure = 0
                    Speed = 1.0
                end

                SetBoatDamaged()
            end
        end

        Wait(1000)
    end
end)

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
                    if IsLarge then
                        FreezeEntityPosition(MyBoat, true)
                    end
                    SetEntityCollision(MyBoat, true, true)
                    Citizen.InvokeNative(0xB64CFA14CB9A2E78, MyBoat, false, true) -- SetVehicleEngineOn
                    IsAnchored = true
                    IsStarted = false
                    Pressure = 0
                    Speed = 1.0
                    PromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorUp')))
                    DBG:Info(string.format('Player anchored boat id=%s', tostring(MyBoatId)))
                else
                    Citizen.InvokeNative(0xAEAB044F05B92659, MyBoat, false) -- SetBoatAnchor
                    Citizen.InvokeNative(0x286771F3059A37A7, MyBoat, false) -- SetBoatRemainsAnchoredWhilePlayerIsDriver
                    if IsLarge then
                        FreezeEntityPosition(MyBoat, false)
                    end
                    SetEntityCollision(MyBoat, true, true)
                    IsAnchored = false
                    PromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorDown')))
                    DBG:Info(string.format('Player unanchored boat id=%s', tostring(MyBoatId)))
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

-- Close Boat Shop Menu
RegisterNUICallback('CloseBoat', function(data, cb)
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
            translations = Translations,
            location = ShopName,
            myBoatsData = boatData,
            currencyType = Config.currency
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

--- @param status string
function StatusNotification(status)
    local messages = {
        ['repair']   = _U('needRepairs'),
        ['damaged']  = _U('boatDamaged'),
        ['wrecked']  = _U('boatWrecked')
    }

    if not messages[status] then return end

    if Config.notify == 'vorp' then
        Core.NotifyRightTip(messages[status], 4000)
    elseif Config.notify == 'ox' then
        lib.notify({
            description = messages[status],
            type = 'error',
            style = Config.oxstyle,
            position = Config.oxposition
        })
    end
end

local function GetControlOfBoat()
    if MyBoat == 0 then return end

    if not NetworkHasControlOfEntity(MyBoat) then
        NetworkRequestControlOfEntity(MyBoat)

        local timeout = 10000
        local startTime = GetGameTimer()

        while not NetworkHasControlOfEntity(MyBoat) do
            if GetGameTimer() - startTime > timeout then
                print('Failed to get control of the boat.')
                return
            end
            Wait(10)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        -- Wait until player is in any boat
        local playerPed = PlayerPedId()
        while not IsPedInAnyBoat(playerPed) do
            Wait(1000) -- idle while on foot / not in a boat
            playerPed = PlayerPedId()
        end

        -- Player is in a boat; monitor while in-boat
        while IsPedInAnyBoat(playerPed) do
            local veh = GetVehiclePedIsIn(playerPed, false)
            if veh ~= 0 and veh == MyBoat then
                -- If player is driver of our boat, ensure control and clear anchored-remains flag
                if GetPedInVehicleSeat(veh, -1) == playerPed then
                    if not NetworkHasControlOfEntity(veh) then
                        NetworkRequestControlOfEntity(veh)
                        local start = GetGameTimer()
                        while not NetworkHasControlOfEntity(veh) and GetGameTimer() - start < 3000 do
                            Wait(10)
                        end
                    end

                    if NetworkHasControlOfEntity(veh) then
                        if not IsAnchored then
                            Citizen.InvokeNative(0x286771F3059A37A7, veh, false) -- SetBoatRemainsAnchoredWhilePlayerIsDriver(false)
                        end
                    end
                end
            end

            Wait(200) -- while in-vehicle checks are more frequent but bounded
            playerPed = PlayerPedId()
        end
        -- loop back to idle waiting for next vehicle entry
        Wait(0)
    end
end)

function ResetBoat()
    if MyBoat ~= 0 then
        GetControlOfBoat()
        DeleteEntity(MyBoat)
        MyBoat = 0
    end

    ConditionEnabled = false
    SetWrecked = false
    IsStarted = false
    Pressure = 0
    Speed = 1.0
    IsPortable = false
    IsSteamer = false
    IsFishing = false
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

local function Rotation(dir)
    if (BoatModel == 'ship_nbdGuama') or (BoatModel == 'turbineboat') or (BoatModel == 'tugboat2') or (BoatModel == 'horseBoat') then
        return
    end

    local entity = MyEntity ~= 0 and MyEntity or ShopEntity

    if entity ~= 0 then
        local currentHeading = GetEntityHeading(entity)
        SetEntityHeading(entity, (currentHeading + dir) % 360)
    end
end

-- Rotate Boats while Viewing
RegisterNUICallback('Rotate', function(data, cb)
    cb('ok')
    local direction = data.RotateBoat
    local dir = direction == 'left' and 1 or -1

    Rotation(dir)
end)

function CheckPlayerJob(boatman, site, speed)
    local result = Core.Callback.TriggerAwait('bcc-boats:CheckJob', boatman, site, speed)
    if not result then return end

    IsBoatman, HasJob, HasSpeedJob = false, false, false

    if boatman and result[1] then
        IsBoatman = true

    elseif site then
        if result[1] then
            HasJob = true
        elseif Sites[site].shop.jobsEnabled then
            if Config.notify == 'vorp' then
                Core.NotifyRightTip(_U('needJob'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('needJob'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
            end
        end

    elseif speed and result[1] then
        HasSpeedJob = true
    end

    JobMatchedBoats = result[2] and FindBoatsByJob(result[2]) or nil
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

function StartBoatPrompts()
    AnchorPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(AnchorPrompt, Config.keys.anchor)
    if BoatCfg.anchored then
        UiPromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorUp')))
    else
        UiPromptSetText(AnchorPrompt, CreateVarString(10, 'LITERAL_STRING', _U('anchorDown')))
    end
    UiPromptSetEnabled(AnchorPrompt, true)
    UiPromptSetVisible(AnchorPrompt, true)
    UiPromptSetStandardMode(AnchorPrompt, true)
    UiPromptSetGroup(AnchorPrompt, DriveGroup, 0)
    UiPromptRegisterEnd(AnchorPrompt)

    if IsSteamer then
        SteamPrompt = UiPromptRegisterBegin()
        UiPromptSetControlAction(SteamPrompt, Config.keys.increase)
        UiPromptSetControlAction(SteamPrompt, Config.keys.decrease)
        UiPromptSetText(SteamPrompt, CreateVarString(10, 'LITERAL_STRING', _U('steamPrompt')))
        UiPromptSetEnabled(SteamPrompt, true)
        UiPromptSetVisible(SteamPrompt, true)
        UiPromptSetStandardMode(SteamPrompt, true)
        UiPromptSetGroup(SteamPrompt, DriveGroup, 0)
        UiPromptRegisterEnd(SteamPrompt)
    end

    MenuPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(MenuPrompt, Config.keys.menu)
    UiPromptSetText(MenuPrompt, CreateVarString(10, 'LITERAL_STRING', _U('boatMenuPrompt')))
    UiPromptSetEnabled(MenuPrompt, true)
    UiPromptSetVisible(MenuPrompt, true)
    UiPromptSetStandardMode(MenuPrompt, true)
    UiPromptSetGroup(MenuPrompt, DriveGroup, 0)
    UiPromptRegisterEnd(MenuPrompt)

    ActionPrompt = UiPromptRegisterBegin()
    UiPromptSetControlAction(ActionPrompt, Config.keys.action)
    UiPromptSetText(ActionPrompt, CreateVarString(10, 'LITERAL_STRING', _U('boatMenuPrompt')))
    UiPromptSetEnabled(ActionPrompt, true)
    UiPromptSetVisible(ActionPrompt, true)
    UiPromptSetStandardMode(ActionPrompt, true)
    UiPromptSetGroup(ActionPrompt, ActionGroup, 0)
    UiPromptRegisterEnd(ActionPrompt)
end

AddEventHandler('bcc-boats:StartTradePrompts', function()
    if not PromptsStarted then
        TradePrompt = UiPromptRegisterBegin()
        UiPromptSetControlAction(TradePrompt, Config.keys.trade)
        UiPromptSetText(TradePrompt, CreateVarString(10, 'LITERAL_STRING', _U('tradePrompt')))
        UiPromptSetEnabled(TradePrompt, true)
        UiPromptSetVisible(TradePrompt, true)
        UiPromptSetHoldMode(TradePrompt, 2000)
        UiPromptSetGroup(TradePrompt, TradeGroup, 0)
        UiPromptRegisterEnd(TradePrompt)

        PromptsStarted = true
    end
end)

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

