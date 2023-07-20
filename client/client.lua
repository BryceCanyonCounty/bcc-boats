local VORPcore = {}
-- Start Prompts
local OpenShops
local CloseShops
local OpenReturn
local CloseReturn
local ShopPrompt1 = GetRandomIntInRange(0, 0xffffff)
local ShopPrompt2 = GetRandomIntInRange(0, 0xffffff)
local ReturnPrompt1 = GetRandomIntInRange(0, 0xffffff)
local ReturnPrompt2 = GetRandomIntInRange(0, 0xffffff)
-- Boats
local ShopName
local ShopEntity
local MyEntity
local MyBoat = nil
local MyBoatId
local InMenu = false
local isAnchored
local BoatCam
local Shop
local Cam = false
local Portable = nil
MenuData = {}

TriggerEvent('getCore', function(core)
    VORPcore = core
end)
TriggerEvent('menuapi:getData', function(call)
    MenuData = call
end)

-- Start Boats
CreateThread(function()
    ShopOpen()
    ShopClosed()
    ReturnOpen()
    ReturnClosed()

    while true do
        Wait(0)
        local player = PlayerPedId()
        local pcoords = GetEntityCoords(player)
        local sleep = true
        local hour = GetClockHours()

        if not InMenu and not IsEntityDead(player) then
            for shop, shopCfg in pairs(Config.shops) do
                if shopCfg.shopHours then
                    -- Using Shop Hours - Shop Closed
                    if hour >= shopCfg.shopClose or hour < shopCfg.shopOpen then
                        if shopCfg.blipOn and Config.blipOnClosed and not Config.shops[shop].Blip then
                            AddBlip(shop)
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipClosed])) -- BlipAddModifier
                        else
                            if Config.shops[shop].Blip then
                                RemoveBlip(Config.shops[shop].Blip)
                                Config.shops[shop].Blip = nil
                            end
                        end
                        if shopCfg.NPC then
                            DeleteEntity(shopCfg.NPC)
                            shopCfg.NPC = nil
                        end
                        local sDist = #(pcoords - shopCfg.npc)
                        local rDist = #(pcoords - shopCfg.boat)
                        if sDist <= shopCfg.sDistance and not IsPedInAnyBoat(player) then
                            sleep = false
                            local shopClosed = CreateVarString(10, 'LITERAL_STRING', shopCfg.shopName .. _U('closed'))
                            PromptSetActiveGroupThisFrame(ShopPrompt2, shopClosed)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, CloseShops) then -- UiPromptHasStandardModeCompleted
                                VORPcore.NotifyRightTip(shopCfg.shopName .. _U('hours') .. shopCfg.shopOpen .. _U('to') .. shopCfg.shopClose .. _U('hundred'), 4000)
                            end
                        elseif rDist <= shopCfg.rDistance and IsPedInAnyBoat(player) then
                            sleep = false
                            local returnClosed = CreateVarString(10, 'LITERAL_STRING', shopCfg.shopName .. _U('closed'))
                            PromptSetActiveGroupThisFrame(ReturnPrompt2, returnClosed)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, CloseReturn) then -- UiPromptHasStandardModeCompleted
                                Wait(100)
                                VORPcore.NotifyRightTip(shopCfg.shopName .. _U('hours') .. shopCfg.shopOpen .. _U('to') .. shopCfg.shopClose .. _U('hundred'), 4000)
                            end
                        end
                    elseif hour >= shopCfg.shopOpen then
                        -- Using Shop Hours - Shop Open
                        if shopCfg.blipOn and not Config.shops[shop].Blip then
                            AddBlip(shop)
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipOpen])) -- BlipAddModifier
                        end
                        if not next(shopCfg.allowedJobs) then
                            local sDist = #(pcoords - shopCfg.npc)
                            local rDist = #(pcoords - shopCfg.boat)
                            if shopCfg.npcOn then
                                if sDist <= shopCfg.nDistance then
                                    if not shopCfg.NPC then
                                        AddNPC(shop)
                                    end
                                else
                                    if shopCfg.NPC then
                                        DeleteEntity(shopCfg.NPC)
                                        shopCfg.NPC = nil
                                    end
                                end
                            end
                            if sDist <= shopCfg.sDistance and not IsPedInAnyBoat(player) then
                                sleep = false
                                local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                                PromptSetActiveGroupThisFrame(ShopPrompt1, shopOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    OpenMenu(shop)
                                end
                            elseif (rDist <= shopCfg.rDistance) and IsPedInAnyBoat(player) then
                                sleep = false
                                local returnOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                                PromptSetActiveGroupThisFrame(ReturnPrompt1, returnOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                    ReturnBoat(shop)
                                end
                            end
                        else
                            -- Using Shop Hours - Shop Open - Job Locked
                            if Config.shops[shop].Blip then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipJob])) -- BlipAddModifier
                            end
                            local sDist = #(pcoords - shopCfg.npc)
                            local rDist = #(pcoords - shopCfg.boat)
                            if shopCfg.npcOn then
                                if sDist <= shopCfg.nDistance then
                                    if not shopCfg.NPC then
                                        AddNPC(shop)
                                    end
                                else
                                    if shopCfg.NPC then
                                        DeleteEntity(shopCfg.NPC)
                                        shopCfg.NPC = nil
                                    end
                                end
                            end
                            if sDist <= shopCfg.sDistance and not IsPedInAnyBoat(player) then
                                sleep = false
                                local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                                PromptSetActiveGroupThisFrame(ShopPrompt1, shopOpen)

                                local args = shop
                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    VORPcore.RpcCall('CheckPlayerJob', function(result)
                                        if result then
                                            OpenMenu(shop)
                                        else
                                            return
                                        end
                                    end, args)
                                end
                            elseif rDist <= shopCfg.rDistance and IsPedInAnyBoat(player) then
                                sleep = false
                                local returnOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                                PromptSetActiveGroupThisFrame(ReturnPrompt1, returnOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                    ReturnBoat(shop)
                                end
                            end
                        end
                    end
                else
                    -- Not Using Shop Hours - Shop Always Open
                    if shopCfg.blipOn and not Config.shops[shop].Blip then
                        AddBlip(shop)
                        Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipOpen])) -- BlipAddModifier
                    end
                    if not next(shopCfg.allowedJobs) then
                        local sDist = #(pcoords - shopCfg.npc)
                        local rDist = #(pcoords - shopCfg.boat)
                        if shopCfg.npcOn then
                            if sDist <= shopCfg.nDistance then
                                if not shopCfg.NPC then
                                    AddNPC(shop)
                                end
                            else
                                if shopCfg.NPC then
                                    DeleteEntity(shopCfg.NPC)
                                    shopCfg.NPC = nil
                                end
                            end
                        end
                        if sDist <= shopCfg.sDistance and not IsPedInAnyBoat(player) then
                            sleep = false
                            local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                            PromptSetActiveGroupThisFrame(ShopPrompt1, shopOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                OpenMenu(shop)
                            end
                        elseif rDist <= shopCfg.rDistance and IsPedInAnyBoat(player) then
                            sleep = false
                            local returnOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                            PromptSetActiveGroupThisFrame(ReturnPrompt1, returnOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                ReturnBoat(shop)
                            end
                        end
                    else
                        -- -- Not Using Shop Hours - Shop Always Open - Job Locked
                        if Config.shops[shop].Blip then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shop].Blip, joaat(Config.BlipColors[shopCfg.blipJob])) -- BlipAddModifier
                        end
                        local sDist = #(pcoords - shopCfg.npc)
                        local rDist = #(pcoords - shopCfg.boat)
                        if shopCfg.npcOn then
                            if sDist <= shopCfg.nDistance then
                                if not shopCfg.NPC then
                                    AddNPC(shop)
                                end
                            else
                                if shopCfg.NPC then
                                    DeleteEntity(shopCfg.NPC)
                                    shopCfg.NPC = nil
                                end
                            end
                        end
                        if sDist <= shopCfg.sDistance and not IsPedInAnyBoat(player) then
                            sleep = false
                            local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                            PromptSetActiveGroupThisFrame(ShopPrompt1, shopOpen)

                            local args = shop
                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                VORPcore.RpcCall('CheckPlayerJob', function(result)
                                    if result then
                                        OpenMenu(shop)
                                    else
                                        return
                                    end
                                end, args)
                            end
                        elseif rDist <= shopCfg.rDistance and IsPedInAnyBoat(player) then
                            sleep = false
                            local returnOpen = CreateVarString(10, 'LITERAL_STRING', shopCfg.promptName)
                            PromptSetActiveGroupThisFrame(ReturnPrompt1, returnOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                ReturnBoat(shop)
                            end
                        end
                    end
                end
            end
        end
        if sleep then
            Wait(1000)
        end
    end
end)

-- Open Main Menu
function OpenMenu(shop)
    DisplayRadar(false)
    TaskStandStill(PlayerPedId(), -1)
    InMenu = true
    Shop = shop
    ShopName = Config.shops[Shop].shopName
    CreateCamera()

    SendNUIMessage({
        action = 'show',
        shopData = Config.shops[Shop].boats,
        location = ShopName
    })
    SetNuiFocus(true, true)
    TriggerServerEvent('bcc-boats:GetMyBoats')
end

-- Get Boat Data for Players Boats
RegisterNetEvent('bcc-boats:BoatsData', function(dataBoats)
    SendNUIMessage({
        myBoatsData = dataBoats
    })
end)

-- View Boats for Purchase
RegisterNUICallback('LoadBoat', function(data, cb)
    cb('ok')
    if MyEntity then
        DeleteEntity(MyEntity)
        MyEntity = nil
    end

    local boatModel = data.boatModel
    local model = joaat(boatModel)
    LoadModel(model)

    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end

    SetCamFov(BoatCam, 50.0)
    if boatModel == 'keelboat' then
        SetCamFov(BoatCam, 80.0)
    end
    local shopCfg = Config.shops[Shop]
    ShopEntity = CreateVehicle(model, shopCfg.boat, shopCfg.boatHeading, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, ShopEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, ShopEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
    if not Cam then
        Cam = true
        CameraLighting()
    end
end)

-- Buy and Name New Boat
RegisterNUICallback('BuyBoat', function(data, cb)
    cb('ok')
    TriggerServerEvent('bcc-boats:BuyBoat', data)
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
                        TriggerServerEvent('bcc-boats:SaveNewBoat', data, boatName)
                        return
                    else
                        TriggerServerEvent('bcc-boats:SaveNewCraft', data, boatName)
                        return
                    end
                else
                    TriggerServerEvent('bcc-boats:UpdateBoatName', data, boatName)
                    return
                end
            else
                TriggerEvent('bcc-boats:SetBoatName', data, rename)
                return
            end
		end
        if not crafted then
            SendNUIMessage({
                action = 'show',
                shopData = Config.shops[Shop].boats,
                location = ShopName
            })
            SetNuiFocus(true, true)
            TriggerServerEvent('bcc-boats:GetMyBoats')
        end
    end)
end)

-- Rename Player Boats
RegisterNUICallback('RenameBoat', function(data, cb)
    cb('ok')
    TriggerEvent('bcc-boats:SetBoatName', data, true)
end)

-- View Player Boats
RegisterNUICallback('LoadMyBoat', function(data, cb)
    cb('ok')
    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end

    local boatModel = data.BoatModel
    local model = joaat(boatModel)
    LoadModel(model)

    if MyEntity then
        DeleteEntity(MyEntity)
        MyEntity = nil
    end

    SetCamFov(BoatCam, 50.0)
    if boatModel == 'keelboat' then
        SetCamFov(BoatCam, 80.0)
    end

    local shopCfg = Config.shops[Shop]
    MyEntity = CreateVehicle(model, shopCfg.boat, shopCfg.boatHeading, false, false)
    Citizen.InvokeNative(0x7263332501E07F52, MyEntity, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x7D9EFB7AD6B19754, MyEntity, true) -- FreezeEntityPosition
    SetModelAsNoLongerNeeded(model)
    if not Cam then
        Cam = true
        CameraLighting()
    end
end)

-- Launch Player Owned Boats
RegisterNUICallback('LaunchData', function(data,cb)
    cb('ok')
    TriggerEvent('bcc-boats:LaunchBoat', data.BoatId, data.BoatModel, data.BoatName, false)
end)

RegisterNetEvent('bcc-boats:LaunchBoat', function(boatId, boatModel, boatName, portable)
    if MyBoat then
        DeleteEntity(MyBoat)
        MyBoat = nil
    end
    isAnchored = false

    MyBoatId = boatId
    local player = PlayerPedId()
    local model = joaat(boatModel)

    if not portable then
        LoadModel(model)
        local shopCfg = Config.shops[Shop]
        MyBoat = CreateVehicle(model, shopCfg.boat, shopCfg.boatHeading, true, false)
    else
        local coords = GetEntityCoords(player)
        local water = Citizen.InvokeNative(0x5BA7A68A346A5A91, coords.x, coords.y, coords.z) -- GetWaterMapZoneAtCoords
        local canLaunch = false
        for k, _ in pairs(Config.locations) do
            if water == Config.locations[k].hash and IsPedOnFoot(player) and IsEntityInWater(player) then
                canLaunch = true
                break
            end
        end
        if canLaunch then
            local bcoords = GetOffsetFromEntityInWorldCoords(player, 0.0, 4.0, 0.5)
            local heading = GetEntityHeading(player)
            LoadModel(model)
            MyBoat = CreateVehicle(model, bcoords, heading, true, false)
            Portable = true
            TriggerEvent('bcc-boats:PortableMenu')
        else
            VORPcore.NotifyRightTip(_U('noLaunch'), 4000)
            return
        end
    end
    Citizen.InvokeNative(0x7263332501E07F52, MyBoat, true) -- SetVehicleOnGroundProperly
    Citizen.InvokeNative(0x62A6D317A011EA1D, MyBoat, false) -- SetBoatSinksWhenWrecked
    for k, v in pairs(Config.steamers) do
        if k == boatModel then
            Citizen.InvokeNative(0x35AD938C74CACD6A, MyBoat, v.speed) -- ModifyVehicleTopSpeed
            break
        end
    end
    SetModelAsNoLongerNeeded(model)
    DoScreenFadeOut(500)
    Wait(500)
    SetPedIntoVehicle(player, MyBoat, -1)
    Wait(500)
    DoScreenFadeIn(500)

    TriggerServerEvent('bcc-boats:RegisterInventory', MyBoatId, boatModel)

    if Config.boatTag then
        TriggerEvent('bcc-boats:BoatTag', boatName)
    end
    if Config.boatBlip then
        TriggerEvent('bcc-boats:BoatBlip', boatName)
    end
    TriggerEvent('bcc-boats:BoatActions')
    VORPcore.NotifyRightTip(_U('boatMenuTip'),4000)
end)

-- Set Boat Name Above Boat
AddEventHandler('bcc-boats:BoatTag', function(boatName)
    local player = PlayerPedId()
    local boatTagDist = Config.boatTagDist
    local boatTag = Citizen.InvokeNative(0xE961BF23EAB76B12, MyBoat, boatName) -- CreateMpGamerTagOnEntity
    Citizen.InvokeNative(0xA0D7CE5F83259663, boatTag) -- SetMpGamerTagBigText
    while MyBoat do
        Wait(1000)
        local dist = #(GetEntityCoords(player) - GetEntityCoords(MyBoat))
        if dist <= boatTagDist and not Citizen.InvokeNative(0xEC5F66E459AF3BB2, player, MyBoat) then -- IsPedOnSpecificVehicle
            Citizen.InvokeNative(0x93171DDDAB274EB8, boatTag, 2) -- SetMpGamerTagVisibility
        else
            if Citizen.InvokeNative(0x502E1591A504F843, boatTag, MyBoat) then -- IsMpGamerTagActiveOnEntity
                Citizen.InvokeNative(0x93171DDDAB274EB8, boatTag, 0) -- SetMpGamerTagVisibility
            end
        end
    end
end)

-- Set Blip on Launched Boat when Empty
AddEventHandler('bcc-boats:BoatBlip', function(boatName)
    local player = PlayerPedId()
    local boatBlip
    while MyBoat do
        Wait(1000)
        if Citizen.InvokeNative(0xEC5F66E459AF3BB2, player, MyBoat) then -- IsPedOnSpecificVehicle
            if boatBlip then
                RemoveBlip(boatBlip)
                boatBlip = nil
            end
        else
            if not boatBlip then
                boatBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, MyBoat) -- BlipAddForEntity
                SetBlipSprite(boatBlip, joaat(Config.boatBlipSprite), 1)
                Citizen.InvokeNative(0x9CB1A1623062F402, boatBlip, boatName) -- SetBlipNameFromPlayerString
            end
        end
    end
end)

-- Sell Player Owned Boats
RegisterNUICallback('SellBoat', function(data, cb)
    cb('ok')
    DeleteEntity(MyEntity)
    Cam = false
    TriggerServerEvent('bcc-boats:SellBoat', data, Shop)
end)

-- Close Main Menu
RegisterNUICallback('CloseMenu', function(data, cb)
    cb('ok')
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)

    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end
    if MyEntity then
        DeleteEntity(MyEntity)
        MyEntity = nil
    end

    Cam = false
    DestroyAllCams(true)
    DisplayRadar(true)
    InMenu = false
    ClearPedTasksImmediately(PlayerPedId())
end)

-- Reopen Menu After Sell or Failed Purchase
RegisterNetEvent('bcc-boats:BoatMenu', function()
    if ShopEntity then
        DeleteEntity(ShopEntity)
        ShopEntity = nil
    end

    SendNUIMessage({
        action = 'show',
        shopData = Config.shops[Shop].boats,
        location = ShopName
    })
    SetNuiFocus(true, true)
    TriggerServerEvent('bcc-boats:GetMyBoats')
end)

AddEventHandler('bcc-boats:BoatActions', function()
    local player = PlayerPedId()
    local optionKey = Config.keys.options
    local invKey = Config.keys.inv
    local invDist = Config.invDist
    while MyBoat do
        Wait(0)
        -- In-Boat Menu
        if Citizen.InvokeNative(0x580417101DDB492F, 2, optionKey) then -- IsControlJustPressed
            if Citizen.InvokeNative(0xA3EE4A07279BB9DB, player, MyBoat) then -- IsPedInVehicle
                BoatOptionsMenu()
            end
        end
        -- Open Boat Inventory
        if Citizen.InvokeNative(0x580417101DDB492F, 2, invKey) then -- IsControlJustPressed
            local dist = #(GetEntityCoords(player) - GetEntityCoords(MyBoat))
            if dist <= invDist then
                TriggerServerEvent('bcc-boats:OpenInventory', MyBoatId)
            end
        end
        -- Prevents Boat from Sinking
        Citizen.InvokeNative(0xC1E8A365BF3B29F2, player, 364, 1) -- SetPedResetFlag / IgnoreDrownAndKillVolumes
    end
end)

function BoatOptionsMenu()
    MenuData.CloseAll()
    InMenu = true
    local player = PlayerPedId()
    local elements = {}

    if Portable then
        elements = {
            { label = _U('anchorMenu'), value = 'anchor', desc = _U('anchorAction') }
        }
    else
        elements = {
            { label = _U('anchorMenu'), value = 'anchor', desc = _U('anchorAction') },
            { label = _U('returnMenu'), value = 'return', desc = _U('returnAction') }
        }
    end

    MenuData.Open('default', GetCurrentResourceName(), 'menuapi', {
        title    = _U('boatMenu'),
        subtext  = _U('boatSubMenu'),
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'anchor' then

            if not isAnchored then
                SetBoatAnchor(MyBoat, true)
                SetBoatFrozenWhenAnchored(MyBoat, true)
                isAnchored = true
                VORPcore.NotifyRightTip(_U('anchorDown'), 4000)
            else
                SetBoatAnchor(MyBoat, false)
                isAnchored = false
                VORPcore.NotifyRightTip(_U('anchorUp'), 4000)
            end
            menu.close()
            InMenu = false

        elseif data.current.value == 'return' then

            TaskLeaveVehicle(player, MyBoat, 0)
            menu.close()
            InMenu = false
            Wait(15000)
            DeleteEntity(MyBoat)
            MyBoat = nil
        end
    end,
    function(data, menu)
        menu.close()
        InMenu = false
        ClearPedTasksImmediately(player)
        DisplayRadar(true)
    end)
end

-- Return Boat Using Prompt at Shop Location
function ReturnBoat(shop)
    local player = PlayerPedId()
    local shopCfg = Config.shops[shop]
    if Citizen.InvokeNative(0xA3EE4A07279BB9DB, player, MyBoat) then -- IsPedInVehicle
        TaskLeaveVehicle(player, MyBoat, 0)
        DoScreenFadeOut(500)
        Wait(500)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, player, shopCfg.player) -- SetEntityCoordsAndHeading
        Wait(500)
        DoScreenFadeIn(500)
        DeleteEntity(MyBoat)
        MyBoat = nil
        if Portable then
            Portable = nil
        end
    else
        VORPcore.NotifyRightTip(_U('noReturn'), 5000)
    end
end

-- Pick Up Portable Canoe
AddEventHandler('bcc-boats:PortableMenu', function()
    local player = PlayerPedId()
    local id = PlayerId()
    local pickupDist = Config.pickupDist
    while MyBoat do
        local sleep = 1000
        local dist = #(GetEntityCoords(player) - GetEntityCoords(MyBoat))
        if dist <= pickupDist then
            Citizen.InvokeNative(0x05254BA0B44ADC16, MyBoat, true) -- SetVehicleCanBeTargetted
            if not Citizen.InvokeNative(0xEC5F66E459AF3BB2, player, MyBoat) then -- IsPedOnSpecificVehicle
                local _, targetEntity = GetPlayerTargetEntity(id)
                if Citizen.InvokeNative(0x27F89FDC16688A7A, id, MyBoat, 0) then -- IsPlayerTargettingEntity
                    sleep = 0
                    local portaGroup = Citizen.InvokeNative(0xB796970BD125FCE8, targetEntity) -- PromptGetGroupIdForTargetEntity
                    TriggerEvent('bcc-boats:PickUpPortable', portaGroup)
                    if Citizen.InvokeNative(0x580417101DDB492F, 2, Config.keys.pickup) then -- IsControlJustPressed
                        DoScreenFadeOut(100)
                        Wait(100)
                        DeleteEntity(MyBoat)
                        Portable = nil
                        Wait(100)
                        DoScreenFadeIn(100)
                    end
                end
            end
        else
            Citizen.InvokeNative(0x05254BA0B44ADC16, MyBoat, false) -- SetVehicleCanBeTargetted
        end
        Wait(sleep)
    end
end)

-- Camera to View Boats
function CreateCamera()
    local shopCfg = Config.shops[Shop]
    BoatCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(BoatCam, shopCfg.boatCam.x, shopCfg.boatCam.y, shopCfg.boatCam.z + 1.2 )
    SetCamActive(BoatCam, true)
    PointCamAtCoord(BoatCam, shopCfg.boat)
    SetCamFov(BoatCam, 50.0)
    DoScreenFadeOut(500)
    Wait(500)
    DoScreenFadeIn(500)
    RenderScriptCams(true, false, 0, 0, 0)
end

function CameraLighting()
    local shopCfg = Config.shops[Shop]
    while Cam do
        Wait(0)
        Citizen.InvokeNative(0xD2D9E04C0DF927F4, shopCfg.boat.x, shopCfg.boat.y, shopCfg.boat.z + 3, 13, 28, 46, 5.0, 10.0) -- DrawLightWithRange
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
    if MyEntity then
        local ownedRot = GetEntityHeading(MyEntity) + dir
        SetEntityHeading(MyEntity, ownedRot % 360)

    elseif ShopEntity then
        local shopRot = GetEntityHeading(ShopEntity) + dir
        SetEntityHeading(ShopEntity, shopRot % 360)
    end
end

RegisterCommand('boatEnter', function(rawCommand)
    if MyBoat then
        local player = PlayerPedId()
        local callDist = #(GetEntityCoords(player) - GetEntityCoords(MyBoat))
        if callDist < 25 then
            DoScreenFadeOut(500)
            Wait(500)
            SetPedIntoVehicle(player, MyBoat, -1)
            Wait(500)
            DoScreenFadeIn(500)
        else
            VORPcore.NotifyRightTip(_U('tooFar'), 5000)
            return
        end
    else
        VORPcore.NotifyRightTip(_U('noBoat'), 5000)
        return
    end
end)

-- Calm the Guarma Sea
RegisterNetEvent('vorp:SelectedCharacter', function(charid)
    Citizen.InvokeNative(0xC63540AEF8384732, 0.1, 0.1, 1, 0.1, 0.1, 0.1, 0.1, 0.1, 1) -- SetOceanGuarmaWaterQuadrant
end)

-- Menu Prompts
function ShopOpen()
    local str = CreateVarString(10, 'LITERAL_STRING', _U('shopPrompt'))
    OpenShops = PromptRegisterBegin()
    PromptSetControlAction(OpenShops, Config.keys.shop)
    PromptSetText(OpenShops, str)
    PromptSetEnabled(OpenShops, 1)
    PromptSetVisible(OpenShops, 1)
    PromptSetStandardMode(OpenShops, 1)
    PromptSetGroup(OpenShops, ShopPrompt1)
    PromptRegisterEnd(OpenShops)
end

function ShopClosed()
    local str = CreateVarString(10, 'LITERAL_STRING', _U('shopPrompt'))
    CloseShops = PromptRegisterBegin()
    PromptSetControlAction(CloseShops, Config.keys.shop)
    PromptSetText(CloseShops, str)
    PromptSetEnabled(CloseShops, 1)
    PromptSetVisible(CloseShops, 1)
    PromptSetStandardMode(CloseShops, 1)
    PromptSetGroup(CloseShops, ShopPrompt2)
    PromptRegisterEnd(CloseShops)
end

function ReturnOpen()
    local str = CreateVarString(10, 'LITERAL_STRING', _U('returnPrompt'))
    OpenReturn = PromptRegisterBegin()
    PromptSetControlAction(OpenReturn, Config.keys.ret)
    PromptSetText(OpenReturn, str)
    PromptSetEnabled(OpenReturn, 1)
    PromptSetVisible(OpenReturn, 1)
    PromptSetStandardMode(OpenReturn, 1)
    PromptSetGroup(OpenReturn, ReturnPrompt1)
    PromptRegisterEnd(OpenReturn)
end

function ReturnClosed()
    local str = CreateVarString(10, 'LITERAL_STRING', _U('returnPrompt'))
    CloseReturn = PromptRegisterBegin()
    PromptSetControlAction(CloseReturn, Config.keys.ret)
    PromptSetText(CloseReturn, str)
    PromptSetEnabled(CloseReturn, 1)
    PromptSetVisible(CloseReturn, 1)
    PromptSetStandardMode(CloseReturn, 1)
    PromptSetGroup(CloseReturn, ReturnPrompt2)
    PromptRegisterEnd(CloseReturn)
end

AddEventHandler('bcc-boats:PickUpPortable', function(portaGroup)
    local str = CreateVarString(10, 'LITERAL_STRING', _U('pickupPortable'))
    local pickup = PromptRegisterBegin()
    PromptSetControlAction(pickup, Config.keys.pickup)
    PromptSetText(pickup, str)
    PromptSetEnabled(pickup, 1)
    PromptSetVisible(pickup, 1)
    PromptSetHoldMode(pickup, 1)
    PromptSetGroup(pickup, portaGroup)
    PromptRegisterEnd(pickup)
end)

-- Blips
function AddBlip(shop)
    local shopCfg = Config.shops[shop]
    shopCfg.Blip = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, shopCfg.npc) -- BlipAddForCoords
    SetBlipSprite(shopCfg.Blip, shopCfg.blipSprite, 1)
    SetBlipScale(shopCfg.Blip, 0.2)
    Citizen.InvokeNative(0x9CB1A1623062F402, shopCfg.Blip, shopCfg.blipName) -- SetBlipName
end

-- NPCs
function AddNPC(shop)
    local shopCfg = Config.shops[shop]
    local model = joaat(shopCfg.npcModel)
    LoadModel(model)
    local npc = CreatePed(shopCfg.npcModel, shopCfg.npc, shopCfg.npcHeading, false, true, true, true)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    Wait(500)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    Config.shops[shop].NPC = npc
end

function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if InMenu == true then
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'hide'
        })
        MenuData.CloseAll()
    end
    ClearPedTasksImmediately(PlayerPedId())
    DestroyAllCams(true)
    DisplayRadar(true)

    if MyBoat then
        DeleteEntity(MyBoat)
    end

    for _, shopCfg in pairs(Config.shops) do
        if shopCfg.Blip then
            RemoveBlip(shopCfg.Blip)
            shopCfg.Blip = nil
        end
        if shopCfg.NPC then
            DeleteEntity(shopCfg.NPC)
            shopCfg.NPC = nil
        end
    end
end)
