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
-- Jobs
local PlayerJob
local JobName
local JobGrade
-- Boats
local ShopName
local ShopEntity
local MyEntity
local MyBoat = nil
local MyBoatId
local InMenu = false
local isAnchored
local BoatCam
local ShopId
local Cam = false
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
        local coords = GetEntityCoords(player)
        local sleep = true
        local dead = IsEntityDead(player)
        local hour = GetClockHours()

        if not InMenu and not dead then
            for shopId, shopConfig in pairs(Config.shops) do
                if shopConfig.shopHours then
                    -- Using Shop Hours - Shop Closed
                    if hour >= shopConfig.shopClose or hour < shopConfig.shopOpen then
                        if Config.blipOnClosed then
                            if not Config.shops[shopId].Blip and shopConfig.blipOn then
                                AddBlip(shopId)
                            end
                        else
                            if Config.shops[shopId].Blip then
                                RemoveBlip(Config.shops[shopId].Blip)
                                Config.shops[shopId].Blip = nil
                            end
                        end
                            if Config.shops[shopId].Blip then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorClosed])) -- BlipAddModifier
                            end
                        if shopConfig.NPC then
                            DeleteEntity(shopConfig.NPC)
                            shopConfig.NPC = nil
                        end
                        local pcoords = vector3(coords.x, coords.y, coords.z) -- Player Coords
                        local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z) -- Shop Coords
                        local rcoords = vector3(shopConfig.boat.x, shopConfig.boat.y, shopConfig.boat.z) -- Return Coords
                        local sDistance = #(pcoords - scoords)
                        local rDistance = #(pcoords - rcoords)

                        if sDistance <= shopConfig.sDistance and not IsPedInAnyBoat(player) then
                            sleep = false
                            local shopClosed = CreateVarString(10, 'LITERAL_STRING', shopConfig.shopName .. _U('closed'))
                            PromptSetActiveGroupThisFrame(ShopPrompt2, shopClosed)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, CloseShops) then -- UiPromptHasStandardModeCompleted
                                Wait(100)
                                VORPcore.NotifyRightTip(shopConfig.shopName .. _U('hours') .. shopConfig.shopOpen .. _U('to') .. shopConfig.shopClose .. _U('hundred'), 5000)
                            end
                        elseif rDistance <= shopConfig.rDistance and IsPedInAnyBoat(player) then
                            sleep = false
                            local returnClosed = CreateVarString(10, 'LITERAL_STRING', shopConfig.shopName .. _U('closed'))
                            PromptSetActiveGroupThisFrame(ReturnPrompt2, returnClosed)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, CloseReturn) then -- UiPromptHasStandardModeCompleted
                                Wait(100)
                                VORPcore.NotifyRightTip(shopConfig.shopName .. _U('hours') .. shopConfig.shopOpen .. _U('to') .. shopConfig.shopClose .. _U('hundred'), 5000)
                            end
                        end
                    elseif hour >= shopConfig.shopOpen then
                        -- Using Shop Hours - Shop Open
                        if not Config.shops[shopId].Blip and shopConfig.blipOn then
                            AddBlip(shopId)
                        end
                        if not next(shopConfig.allowedJobs) then
                            if Config.shops[shopId].Blip then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorOpen])) -- BlipAddModifier
                            end
                            local pcoords = vector3(coords.x, coords.y, coords.z)
                            local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                            local rcoords = vector3(shopConfig.boat.x, shopConfig.boat.y, shopConfig.boat.z)
                            local sDistance = #(pcoords - scoords)
                            local rDistance = #(pcoords - rcoords)

                            if sDistance <= shopConfig.nDistance then
                                if not shopConfig.NPC and shopConfig.npcOn then
                                    AddNPC(shopId)
                                end
                            else
                                if shopConfig.NPC then
                                    DeleteEntity(shopConfig.NPC)
                                    shopConfig.NPC = nil
                                end
                            end
                            if sDistance <= shopConfig.sDistance and not IsPedInAnyBoat(player) then
                                sleep = false
                                local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                                PromptSetActiveGroupThisFrame(ShopPrompt1, shopOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    OpenMenu(shopId)
                                    DisplayRadar(false)
                                    TaskStandStill(player, -1)
                                end
                            elseif (rDistance <= shopConfig.rDistance) and IsPedInAnyBoat(player) then
                                sleep = false
                                local returnOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                                PromptSetActiveGroupThisFrame(ReturnPrompt1, returnOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                    ReturnBoat(shopId)
                                end
                            end
                        else
                            -- Using Shop Hours - Shop Open - Job Locked
                            if Config.shops[shopId].Blip then
                                Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorJob])) -- BlipAddModifier
                            end
                            local pcoords = vector3(coords.x, coords.y, coords.z)
                            local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                            local rcoords = vector3(shopConfig.boat.x, shopConfig.boat.y, shopConfig.boat.z)
                            local sDistance = #(pcoords - scoords)
                            local rDistance = #(pcoords - rcoords)

                            if sDistance <= shopConfig.nDistance then
                                if not shopConfig.NPC and shopConfig.npcOn then
                                    AddNPC(shopId)
                                end
                            else
                                if shopConfig.NPC then
                                    DeleteEntity(shopConfig.NPC)
                                    shopConfig.NPC = nil
                                end
                            end
                            if sDistance <= shopConfig.sDistance and not IsPedInAnyBoat(player) then
                                sleep = false
                                local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                                PromptSetActiveGroupThisFrame(ShopPrompt1, shopOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                    TriggerServerEvent('bcc-boats:getPlayerJob')
                                    Wait(200)
                                    if PlayerJob then
                                        if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                            if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                                OpenMenu(shopId)
                                                DisplayRadar(false)
                                                TaskStandStill(player, -1)
                                            else
                                                VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade,5000)
                                                return
                                            end
                                        else
                                            VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade,5000)
                                            return
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade,5000)
                                        return
                                    end
                                end
                            elseif rDistance <= shopConfig.rDistance and IsPedInAnyBoat(player) then
                                sleep = false
                                local returnOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                                PromptSetActiveGroupThisFrame(ReturnPrompt1, returnOpen)

                                if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                    ReturnBoat(shopId)
                                end
                            end
                        end
                    end
                else
                    -- Not Using Shop Hours - Shop Always Open
                    if not Config.shops[shopId].Blip and shopConfig.blipOn then
                        AddBlip(shopId)
                    end
                    if not next(shopConfig.allowedJobs) then
                        if Config.shops[shopId].Blip then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorOpen])) -- BlipAddModifier
                        end
                        local pcoords = vector3(coords.x, coords.y, coords.z)
                        local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                        local rcoords = vector3(shopConfig.boat.x, shopConfig.boat.y, shopConfig.boat.z)
                        local sDistance = #(pcoords - scoords)
                        local rDistance = #(pcoords - rcoords)
                        if sDistance <= shopConfig.nDistance then
                            if not shopConfig.NPC and shopConfig.npcOn then
                                AddNPC(shopId)
                            end
                        else
                            if shopConfig.NPC then
                                DeleteEntity(shopConfig.NPC)
                                shopConfig.NPC = nil
                            end
                        end
                        if sDistance <= shopConfig.sDistance and not IsPedInAnyBoat(player) then
                            sleep = false
                            local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                            PromptSetActiveGroupThisFrame(ShopPrompt1, shopOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                OpenMenu(shopId)
                                DisplayRadar(false)
                                TaskStandStill(player, -1)
                            end
                        elseif rDistance <= shopConfig.rDistance and IsPedInAnyBoat(player) then
                            sleep = false
                            local returnOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                            PromptSetActiveGroupThisFrame(ReturnPrompt1, returnOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenReturn) then -- UiPromptHasStandardModeCompleted
                                ReturnBoat(shopId)
                            end
                        end
                    else
                        -- -- Not Using Shop Hours - Shop Always Open - Job Locked
                        if Config.shops[shopId].Blip then
                            Citizen.InvokeNative(0x662D364ABF16DE2F, Config.shops[shopId].Blip, joaat(Config.BlipColors[shopConfig.blipColorJob])) -- BlipAddModifier
                        end
                        local pcoords = vector3(coords.x, coords.y, coords.z)
                        local scoords = vector3(shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z)
                        local rcoords = vector3(shopConfig.boat.x, shopConfig.boat.y, shopConfig.boat.z)
                        local sDistance = #(pcoords - scoords)
                        local rDistance = #(pcoords - rcoords)

                        if sDistance <= shopConfig.nDistance then
                            if not shopConfig.NPC and shopConfig.npcOn then
                                AddNPC(shopId)
                            end
                        else
                            if shopConfig.NPC then
                                DeleteEntity(shopConfig.NPC)
                                shopConfig.NPC = nil
                            end
                        end
                        if sDistance <= shopConfig.sDistance and not IsPedInAnyBoat(player) then
                            sleep = false
                            local shopOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                            PromptSetActiveGroupThisFrame(ShopPrompt1, shopOpen)

                            if Citizen.InvokeNative(0xC92AC953F0A982AE, OpenShops) then -- UiPromptHasStandardModeCompleted
                                TriggerServerEvent('bcc-boats:getPlayerJob')
                                Wait(200)
                                if PlayerJob then
                                    if CheckJob(shopConfig.allowedJobs, PlayerJob) then
                                        if tonumber(shopConfig.jobGrade) <= tonumber(JobGrade) then
                                            OpenMenu(shopId)
                                            DisplayRadar(false)
                                            TaskStandStill(player, -1)
                                        else
                                            VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade,5000)
                                            return
                                        end
                                    else
                                        VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade,5000)
                                        return
                                    end
                                else
                                    VORPcore.NotifyRightTip(_U('needJob') .. JobName .. ' ' .. shopConfig.jobGrade,5000)
                                    return
                                end
                            end
                        elseif rDistance <= shopConfig.rDistance and IsPedInAnyBoat(player) then
                            sleep = false
                            local returnOpen = CreateVarString(10, 'LITERAL_STRING', shopConfig.promptName)
                            PromptSetActiveGroupThisFrame(ReturnPrompt1, returnOpen)

                            ReturnBoat(shopId)
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
function OpenMenu(shopId)
    InMenu = true
    ShopId = shopId
    ShopName = Config.shops[ShopId].shopName
    CreateCamera()

    SendNUIMessage({
        action = 'show',
        shopData = Config.shops[ShopId].boats,
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
    local shopConfig = Config.shops[ShopId]
    ShopEntity = CreateVehicle(model, shopConfig.boat.x, shopConfig.boat.y, shopConfig.boat.z, shopConfig.boat.h, false, false)
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

RegisterNetEvent('bcc-boats:SetBoatName', function(data, rename)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'hide'
    })

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
                    TriggerServerEvent('bcc-boats:SaveNewBoat', data, boatName)
                else
                    TriggerServerEvent('bcc-boats:UpdateBoatName', data, boatName)
                end
            else
                TriggerEvent('bcc-boats:SetBoatName', data, rename)
                return
            end

            SetNuiFocus(true, true)
            SendNUIMessage({
                action = 'show',
                shopData = Config.shops[ShopId].boats,
                location = ShopName
            })

            Wait(1000)
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

    local shopConfig = Config.shops[ShopId]
    MyEntity = CreateVehicle(model, shopConfig.boat.x, shopConfig.boat.y, shopConfig.boat.z, shopConfig.boat.h, false, false)
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
        local boatConfig = Config.shops[ShopId]
        MyBoat = CreateVehicle(model, boatConfig.boat.x, boatConfig.boat.y, boatConfig.boat.z, boatConfig.boat.h, true, false)
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

    local boatBlip = Citizen.InvokeNative(0x23F74C2FDA6E7C61, -1749618580, MyBoat) -- BlipAddForEntity
    SetBlipSprite(boatBlip, joaat('blip_canoe'), true)
    Citizen.InvokeNative(0x9CB1A1623062F402, boatBlip, boatName) -- SetBlipName
    VORPcore.NotifyRightTip(_U('boatMenuTip'),4000)
end)

-- Sell Player Owned Boats
RegisterNUICallback('SellBoat', function(data, cb)
    cb('ok')
    DeleteEntity(MyEntity)
    Cam = false
    TriggerServerEvent('bcc-boats:SellBoat', data, ShopId)
end)

-- Close Main Menu
RegisterNUICallback('CloseMenu', function(data, cb)
    cb('ok')
    SendNUIMessage({ action = 'hide' })
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
    ShopEntity = nil
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
        shopData = Config.shops[ShopId].boats,
        location = ShopName
    })
    TriggerServerEvent('bcc-boats:GetMyBoats')
end)

-- Boat Anchor Operation and Boat Return at Non-Shop Locations
CreateThread(function()
    while true do
        Wait(1)
        if Citizen.InvokeNative(0x580417101DDB492F, 2, Config.keys.options) then -- IsControlJustPressed
            if Citizen.InvokeNative(0xA3EE4A07279BB9DB, PlayerPedId(), MyBoat) then -- IsPedInVehicle
                BoatOptionsMenu()
            end
        end
    end
end)

function BoatOptionsMenu()
    MenuData.CloseAll()
    InMenu = true
    local player = PlayerPedId()
    local elements = {
        {
            label = _U('anchorMenu'),
            value = 'anchor',
            desc = _U('anchorAction')
        },
        {
            label = _U('inventoryMenu'),
            value = 'inventory',
            desc = _U('inventoryAction')
        },
        {
            label = _U('returnMenu'),
            value = 'return',
            desc = _U('returnAction')
        }
    }
    MenuData.Open('default', GetCurrentResourceName(), 'menuapi', {
        title    = _U('boatMenu'),
        subtext  = _U('boatSubMenu'),
        align    = 'top-left',
        elements = elements,
    }, function(data, menu)
        if data.current.value == 'anchor' then

            local playerBoat = GetVehiclePedIsIn(player, true)
            if not isAnchored then
                SetBoatAnchor(playerBoat, true)
                SetBoatFrozenWhenAnchored(playerBoat, true)
                isAnchored = true
                VORPcore.NotifyRightTip(_U('anchorDown'), 4000)
            else
                SetBoatAnchor(playerBoat, false)
                isAnchored = false
                VORPcore.NotifyRightTip(_U('anchorUp'), 4000)
            end
            menu.close()
            InMenu = false

        elseif data.current.value == 'inventory' then

            TriggerServerEvent('bcc-boats:OpenInventory', MyBoatId)
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
function ReturnBoat(shopId)
    local player = PlayerPedId()
    local shopConfig = Config.shops[shopId]
    if Citizen.InvokeNative(0xA3EE4A07279BB9DB, player, MyBoat) then -- IsPedInVehicle
        TaskLeaveVehicle(player, MyBoat, 0)
        DoScreenFadeOut(500)
        Wait(500)
        Citizen.InvokeNative(0x203BEFFDBE12E96A, player, shopConfig.player.x, shopConfig.player.y, shopConfig.player.z, shopConfig.player.h) -- SetEntityCoordsAndHeading
        Wait(500)
        DoScreenFadeIn(500)
        DeleteEntity(MyBoat)
    else
        VORPcore.NotifyRightTip(_U('noReturn'), 5000)
    end
end

-- Camera to View Boats
function CreateCamera()
    local shopConfig = Config.shops[ShopId]
    BoatCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(BoatCam, shopConfig.boatCam.x, shopConfig.boatCam.y, shopConfig.boatCam.z + 1.2 )
    SetCamActive(BoatCam, true)
    PointCamAtCoord(BoatCam, shopConfig.boat.x, shopConfig.boat.y, shopConfig.boat.z)
    SetCamFov(BoatCam, 50.0)
    DoScreenFadeOut(500)
    Wait(500)
    DoScreenFadeIn(500)
    RenderScriptCams(true, false, 0, 0, 0)
end

function CameraLighting()
    CreateThread(function()
        local shopConfig = Config.shops[ShopId]
        while Cam do
            Wait(0)
            Citizen.InvokeNative(0xD2D9E04C0DF927F4, shopConfig.boat.x, shopConfig.boat.y, shopConfig.boat.z + 3, 13, 28, 46, 5.0, 10.0) -- DrawLightWithRange
        end
    end)
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
        local pcoords = GetEntityCoords(player)
        local bcoords = GetEntityCoords(MyBoat)
        local callDist = #(pcoords - bcoords)
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

-- Prevents Boat from Sinking
CreateThread(function()
    while true do
        Wait(0)
        Citizen.InvokeNative(0xC1E8A365BF3B29F2, PlayerPedId(), 364, 1) -- SetPedResetFlag / IgnoreDrownAndKillVolumes
    end
end)

-- Calm the Guarma Sea
RegisterNetEvent('vorp:SelectedCharacter', function(charid)
    Citizen.InvokeNative(0xC63540AEF8384732, 0.1, 0.1, 1, 0.1, 0.1, 0.1, 0.1, 0.1, 1) -- SetOceanGuarmaWaterQuadrant
end)

-- Menu Prompts
function ShopOpen()
    local str = _U('shopPrompt')
    OpenShops = PromptRegisterBegin()
    PromptSetControlAction(OpenShops, Config.keys.shop)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(OpenShops, str)
    PromptSetEnabled(OpenShops, 1)
    PromptSetVisible(OpenShops, 1)
    PromptSetStandardMode(OpenShops, 1)
    PromptSetGroup(OpenShops, ShopPrompt1)
    PromptRegisterEnd(OpenShops)
end

function ShopClosed()
    local str = _U('shopPrompt')
    CloseShops = PromptRegisterBegin()
    PromptSetControlAction(CloseShops, Config.keys.shop)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(CloseShops, str)
    PromptSetEnabled(CloseShops, 1)
    PromptSetVisible(CloseShops, 1)
    PromptSetStandardMode(CloseShops, 1)
    PromptSetGroup(CloseShops, ShopPrompt2)
    PromptRegisterEnd(CloseShops)
end

function ReturnOpen()
    local str = _U('returnPrompt')
    OpenReturn = PromptRegisterBegin()
    PromptSetControlAction(OpenReturn, Config.keys.ret)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(OpenReturn, str)
    PromptSetEnabled(OpenReturn, 1)
    PromptSetVisible(OpenReturn, 1)
    PromptSetStandardMode(OpenReturn, 1)
    PromptSetGroup(OpenReturn, ReturnPrompt1)
    PromptRegisterEnd(OpenReturn)
end

function ReturnClosed()
    local str = _U('returnPrompt')
    CloseReturn = PromptRegisterBegin()
    PromptSetControlAction(CloseReturn, Config.keys.ret)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(CloseReturn, str)
    PromptSetEnabled(CloseReturn, 1)
    PromptSetVisible(CloseReturn, 1)
    PromptSetStandardMode(CloseReturn, 1)
    PromptSetGroup(CloseReturn, ReturnPrompt2)
    PromptRegisterEnd(CloseReturn)
end

-- Blips
function AddBlip(shopId)
    local shopConfig = Config.shops[shopId]
    shopConfig.Blip = N_0x554d9d53f696d002(1664425300, shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z) -- BlipAddForCoords
    SetBlipSprite(shopConfig.Blip, shopConfig.blipSprite, 1)
    SetBlipScale(shopConfig.Blip, 0.2)
    Citizen.InvokeNative(0x9CB1A1623062F402, shopConfig.Blip, shopConfig.blipName) -- SetBlipName
end

-- NPCs
function AddNPC(shopId)
    local shopConfig = Config.shops[shopId]
    local model = joaat(shopConfig.npcModel)
    LoadModel(model)
    local npc = CreatePed(shopConfig.npcModel, shopConfig.npc.x, shopConfig.npc.y, shopConfig.npc.z, shopConfig.npc.h, false, true, true, true)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true) -- SetRandomOutfitVariation
    SetEntityCanBeDamaged(npc, false)
    SetEntityInvincible(npc, true)
    Wait(500)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    Config.shops[shopId].NPC = npc
end

function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(100)
    end
end

-- Check if Player has Job
function CheckJob(allowedJob, playerJob)
    for _, jobAllowed in pairs(allowedJob) do
        JobName = jobAllowed
        if JobName == playerJob then
            return true
        end
    end
    return false
end

RegisterNetEvent('bcc-boats:sendPlayerJob', function(Job, grade)
    PlayerJob = Job
    JobGrade = grade
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if InMenu == true then
        SetNuiFocus(false, false)
        SendNUIMessage({ action = 'hide' })
        MenuData.CloseAll()
    end
    ClearPedTasksImmediately(PlayerPedId())
    PromptDelete(OpenShops)
    PromptDelete(CloseShops)
    PromptDelete(OpenReturn)
    PromptDelete(CloseReturn)
    DestroyAllCams(true)
    DisplayRadar(true)

    if MyBoat then
        DeleteEntity(MyBoat)
        MyBoat = nil
    end

    for _, shopConfig in pairs(Config.shops) do
        if shopConfig.Blip then
            RemoveBlip(shopConfig.Blip)
        end
        if shopConfig.NPC then
            DeleteEntity(shopConfig.NPC)
            DeletePed(shopConfig.NPC)
            SetEntityAsNoLongerNeeded(shopConfig.NPC)
        end
    end
end)
