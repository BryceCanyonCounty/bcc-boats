local FeatherMenu = exports['feather-menu'].initiate()

function OpenBoatMenu()
    local BoatMenu = FeatherMenu:RegisterMenu('bcc:boats:menu', {
        top = '3%',
        left = '3%',
        ['720width'] = '400px',
        ['1080width'] = '500px',
        ['2kwidth'] = '600px',
        ['4kwidth'] = '800px',
        style = {},
        contentslot = {
            style = {
                ['height'] = '350px',
                ['min-height'] = '250px'
            }
        },
        draggable = true,
        canclose = true
    }, {
        opened = function()
            DisplayRadar(false)
        end,
        closed = function()
            DisplayRadar(true)
        end
    })

    -----------------------------------------------------
    -- Main Page
    -----------------------------------------------------
    local MainPage = BoatMenu:RegisterPage('main:page')
    local FuelPage = BoatMenu:RegisterPage('fuel:page')
    local RepairPage = BoatMenu:RegisterPage('repair:page')
    local ReturnPage = BoatMenu:RegisterPage('return:page')
    local TradePage = BoatMenu:RegisterPage('trade:page')
    local playerPed = PlayerPedId()

    MainPage:RegisterElement('header', {
        value = MyBoatName,
        slot = 'header',
        style = {
            ['color'] = '#999'
        }
    })

    MainPage:RegisterElement('subheader', {
        value = _U('boatMenu'),
        slot = 'header',
        style = {
            ['font-size'] = '0.94vw',
            ['color'] = '#CC9900'
        }
    })

    MainPage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })

    if IsSteamer then
        MainPage:RegisterElement('button', {
            label = _U('addFuel'),
            slot = 'content',
            style = {
                ['color'] = '#E0E0E0'
            }
        }, function()
            if BoatCfg.fuel.enabled then
                if FuelLevel < BoatCfg.fuel.maxAmount then
                    FuelPage:RouteTo()
                else
                    if Config.notify == 'vorp' then
                        Core.NotifyRightTip(_U('fuelFull'), 4000)
                    elseif Config.notify == 'ox' then
                        lib.notify({description = _U('fuelFull'), type = 'inform', style = Config.oxstyle, position = Config.oxposition})
                    end
                end
            else
                if Config.notify == 'vorp' then
                    Core.NotifyRightTip(_U('fuelDisabled'), 4000)
                elseif Config.notify == 'ox' then
                    lib.notify({description = _U('fuelDisabled'), type = 'inform', style = Config.oxstyle, position = Config.oxposition})
                end
            end
        end)
    end

    MainPage:RegisterElement('button', {
        label = _U('repairBoat'),
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function()
        if BoatCfg.condition.enabled then
            if RepairLevel < BoatCfg.condition.maxAmount then
                RepairPage:RouteTo()
            else
                if Config.notify == 'vorp' then
                    Core.NotifyRightTip(_U('noRepairs'), 4000)
                elseif Config.notify == 'ox' then
                    lib.notify({description = _U('noRepairs'), type = 'inform', style = Config.oxstyle, position = Config.oxposition})
                end
            end
        else
            if Config.notify == 'vorp' then
                Core.NotifyRightTip(_U('repairDisabled'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('repairDisabled'), type = 'inform', style = Config.oxstyle, position = Config.oxposition})
            end
        end
    end)

    MainPage:RegisterElement('button', {
        label = _U('cargo'),
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function()
        if BoatCfg.inventory.enabled then
            TriggerServerEvent('bcc-boats:OpenInventory', MyBoatId)
            BoatMenu:Close()
        else
            if Config.notify == 'vorp' then
                Core.NotifyRightTip(_U('cargoDisabled'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('cargoDisabled'), type = 'inform', style = Config.oxstyle, position = Config.oxposition})
            end
        end
    end)

    if IsLarge then
        if Citizen.InvokeNative(0xE052C1B1CAA4ECE4, MyBoat, -1) then -- IsVehicleSeatFree
            MainPage:RegisterElement('button', {
                label = _U('driveBoat'),
                slot = 'content',
                style = {
                    ['color'] = '#E0E0E0'
                }
            }, function()
                BoatMenu:Close()
                ExecuteCommand('boatEnter')
            end)
        else
            MainPage:RegisterElement('button', {
                label = _U('stopDriving'),
                slot = 'content',
                style = {
                    ['color'] = '#E0E0E0'
                }
            }, function()
                BoatMenu:Close()
                local offset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, -4.0, 0.0) -- GetOffsetFromEntityInWorldCoords
                local heading = GetEntityHeading(playerPed)
                DoScreenFadeOut(500)
                Wait(300)
                TaskLeaveVehicle(playerPed, MyBoat, 0)
                Wait(200)
                Citizen.InvokeNative(0x203BEFFDBE12E96A, playerPed, offset.x, offset.y, offset.z, heading, false, false, false) -- SetEntityCoordsAndHeading
                Wait(500)
                DoScreenFadeIn(500)
            end)
        end
    end

    MainPage:RegisterElement('button', {
        label = _U('returnBoat'),
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function()
        ReturnPage:RouteTo()
    end)

    if not IsPortable then
        MainPage:RegisterElement('button', {
            label = _U('startTrade'),
            slot = 'content',
            style = {
                ['color'] = '#E0E0E0'
            }
        }, function()
            if not IsPedOnSpecificVehicle(playerPed, MyBoat) then
                if not Trading then
                    TradePage:RouteTo()
                elseif Config.notify == 'vorp' then
                    Core.NotifyRightTip(_U('alreadyTrading'), 4000)
                elseif Config.notify == 'ox' then
                    lib.notify({description = _U('alreadyTrading'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
                end
            elseif Config.notify == 'vorp' then
                Core.NotifyRightTip(_U('exitBoat'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('exitBoat'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
            end
        end)
    end

    MainPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    MainPage:RegisterElement('button', {
        label = _U('close'),
        slot = 'footer',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function()
        BoatMenu:Close()
    end)

    MainPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    -----------------------------------------------------
    -- Fuel Page
    -----------------------------------------------------
    local function GetPlayerFuelCount()
        local count = Core.Callback.TriggerAwait('bcc-boats:GetFuelCount')
        if count then
            return count
        end
    end
    local fuelCount = GetPlayerFuelCount()

    FuelPage:RegisterElement('header', {
        value = MyBoatName,
        slot = 'header',
        style = {
            ['color'] = '#999'
        }
    })

    FuelPage:RegisterElement('subheader', {
        value = _U('addFuel'),
        slot = 'header',
        style = {
            ['font-size'] = '0.94vw',
            ['color'] = '#CC9900'
        }
    })

    FuelPage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })

    FuelPage:RegisterElement('subheader', {
        value = _U('boatFuel'),
        slot = 'header',
        style = {
            ['color'] = '#ddd'
        }
    })

    FuelText = FuelPage:RegisterElement('textdisplay', {
        value = _U('max') .. BoatCfg.fuel.maxAmount .. _U('current') .. FuelLevel,
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0',
            ['font-variant'] = 'small-caps',
            ['font-size'] = '0.83vw',
        }
    })

    CountText = FuelPage:RegisterElement('textdisplay', {
        value = _U('availableFuel') .. fuelCount,
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0',
            ['font-variant'] = 'small-caps',
            ['font-size'] = '0.83vw',
        }
    })

    local fuelInputValue = nil
    FuelPage:RegisterElement('input', {
        label = _U('quantity'),
        placeholder = '0',
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function(data)
        fuelInputValue = data.value
        if data.value == '' then
            fuelInputValue = nil
        end
        if fuelInputValue then
            FuelButton:update({
                label = _U('submit')
            })
        else
            FuelButton:update({
                label = _U('refresh')
            })
        end
    end)

    FuelButton = FuelPage:RegisterElement('button', {
        label = _U('refresh'),
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function()
        if fuelInputValue then
            local quantity = tonumber(fuelInputValue)
            if not quantity or quantity <= 0 then
                if Config.notify == 'vorp' then
                    return Core.NotifyRightTip(_U('validNumber'), 4000)
                elseif Config.notify == 'ox' then
                    lib.notify({description = _U('validNumber'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
                end
            end

            if fuelCount < quantity then
                if Config.notify == 'vorp' then
                    return Core.NotifyRightTip(_U('notEnoughFuel'), 4000)
                elseif Config.notify == 'ox' then
                    lib.notify({description = _U('notEnoughFuel'), type = 'error', style = Config.oxstyle, position = Config.oxposition})
                end
            end

            local newLevel = Core.Callback.TriggerAwait('bcc-boats:AddBoatFuel', MyBoatId, MyBoatModel, quantity)
            if newLevel then
                FuelLevel = newLevel
            end
        end
        FuelText:update({
            value = _U('max') .. BoatCfg.fuel.maxAmount .. _U('current') .. FuelLevel
        })
        CountText:update({
            value =  _U('availableFuel') .. GetPlayerFuelCount()
        })
    end)

    FuelPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    FuelPage:RegisterElement('button', {
        label = _U('back'),
        slot = 'footer',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function()
        MainPage:RouteTo()
    end)

    FuelPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    -----------------------------------------------------
    -- Repair Page
    -----------------------------------------------------
    local function GetItemDurability()
        local result = Core.Callback.TriggerAwait('bcc-boats:GetItemDurability', Config.repair.item)
        if result then
            return result
        else
            return 0
        end
    end
    local durability = GetItemDurability()

    RepairPage:RegisterElement('header', {
        value = MyBoatName,
        slot = 'header',
        style = {
            ['color'] = '#999'
        }
    })

    RepairPage:RegisterElement('subheader', {
        value = _U('repairBoat'),
        slot = 'header',
        style = {
            ['font-size'] = '0.94vw',
            ['color'] = '#CC9900'
        }
    })

    RepairPage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })

    RepairPage:RegisterElement('subheader', {
        value = _U('boatCondition'),
        slot = 'header',
        style = {
            ['color'] = '#ddd'
        }
    })

    ConditionText = RepairPage:RegisterElement('textdisplay', {
        value = _U('max') .. BoatCfg.condition.maxAmount .. _U('current') .. RepairLevel,
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0',
            ['font-variant'] = 'small-caps',
            ['font-size'] = '0.83vw'
        }
    })

    DurabilityText = RepairPage:RegisterElement('textdisplay', {
        value = _U('toolDurability') .. tostring(durability) .. '%',
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0',
            ['font-variant'] = 'small-caps',
            ['font-size'] = '0.83vw'
        }
    })

    RepairPage:RegisterElement('button', {
        label = _U('useTool'),
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function(data)
        if RepairLevel >= BoatCfg.condition.maxAmount then
            if Config.notify == 'vorp' then
                return Core.NotifyRightTip(_U('noRepairs'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('noRepairs'), type = 'inform', style = Config.oxstyle, position = Config.oxposition})
            end
        end
        local newLevel = Core.Callback.TriggerAwait('bcc-boats:RepairBoat', MyBoatId, MyBoatModel)
        if newLevel then
            RepairLevel = newLevel
            if IsBoatDamaged and (RepairLevel >= BoatCfg.condition.itemAmount) then
                IsBoatDamaged = false
            end
        end
        ConditionText:update({
            value = _U('max') .. BoatCfg.condition.maxAmount .. _U('current') .. RepairLevel
        })
        DurabilityText:update({
            value = _U('toolDurability') .. tostring(GetItemDurability()) .. '%'
        })
    end)

    RepairPage:RegisterElement('button', {
        label = _U('refresh'),
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function()
        ConditionText:update({
            value = _U('max') .. BoatCfg.condition.maxAmount .. _U('current') .. RepairLevel
        })
        DurabilityText:update({
            value = _U('toolDurability') .. tostring(GetItemDurability()) .. '%'
        })
    end)

    RepairPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    RepairPage:RegisterElement('button', {
        label = _U('back'),
        slot = 'footer',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function()
        MainPage:RouteTo()
    end)

    RepairPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    -----------------------------------------------------
    -- Return Page
    -----------------------------------------------------
    ReturnPage:RegisterElement('header', {
        value = MyBoatName,
        slot = 'header',
        style = {
            ['color'] = '#999'
        }
    })

    ReturnPage:RegisterElement('subheader', {
        value = _U('returnBoat'),
        slot = 'header',
        style = {
            ['font-size'] = '0.94vw',
            ['color'] = '#CC9900'
        }
    })

    ReturnPage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })

    local CancelReturn = true
    ReturnPage:RegisterElement('checkbox', {
        label = _U('confirm'),
        start = false,
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function(data)
        if data.value == true then
            CancelReturn = false
            ReturnButton:update({
                label = _U('submit')
            })
        else
            CancelReturn = true
            ReturnButton:update({
                label = _U('back')
            })
        end
    end)

    ReturnPage:RegisterElement('textdisplay', {
        value = _U('remoteReturnText'),
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    })

    ReturnPage:RegisterElement('line', {
        slot = 'content',
        style = {}
    })

    ReturnPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    ReturnButton = ReturnPage:RegisterElement('button', {
        label = _U('back'),
        slot = 'footer',
        style = {
            ['color'] = '#E0E0E0'
        }
    }, function()
        if CancelReturn then
            MainPage:RouteTo()
        else
            BoatMenu:Close()
            if IsPedOnSpecificVehicle(playerPed, MyBoat) then
                TaskLeaveVehicle(playerPed, MyBoat, 0)
                Wait(1000)
            end
            DoScreenFadeOut(500)
            Wait(500)
            ResetBoat()
            Wait(500)
            DoScreenFadeIn(500)
        end
    end)

    ReturnPage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    BoatMenu:Open({
        startupPage = MainPage
    })

    -----------------------------------------------------
    -- Trade Page
    -----------------------------------------------------
    TradePage:RegisterElement('header', {
        value = MyBoatName,
        slot = 'header',
        style = {
            ['color'] = '#999'
        }
    })

    TradePage:RegisterElement('subheader', {
        value = _U('tradeBoat'),
        slot = 'header',
        style = {
            ['font-size'] = '0.94vw',
            ['color'] = '#CC9900'
        }
    })

    TradePage:RegisterElement('line', {
        slot = 'header',
        style = {}
    })

    local CancelTrade = true
    TradePage:RegisterElement('checkbox', {
        label = _U('confirm'),
        start = false,
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        },
    }, function(data)
        if data.value == true then
            CancelTrade = false
            TradeButton:update({
                label = _U('submit'),
            })
        else
            CancelTrade = true
            TradeButton:update({
                label = _U('back'),
            })
        end
    end)

    TradePage:RegisterElement('textdisplay', {
        value = _U('standNearPlayer'),
        slot = 'content',
        style = {
            ['color'] = '#E0E0E0'
        }
    })

    TradePage:RegisterElement('line', {
        slot = 'content',
        style = {}
    })

    TradePage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    TradeButton = TradePage:RegisterElement('button', {
        label = _U('back'),
        slot = 'footer',
        style = {
            ['color'] = '#E0E0E0'
        },
    }, function()
        if CancelTrade then
            MainPage:RouteTo()
        else
            BoatMenu:Close()
            if Config.notify == 'vorp' then
                Core.NotifyRightTip(_U('readyToTrade'), 4000)
            elseif Config.notify == 'ox' then
                lib.notify({description = _U('readyToTrade'), type = 'inform', style = Config.oxstyle, position = Config.oxposition})
            end
            Trading = true
            TriggerEvent('bcc-boats:TradeBoat')
            TriggerEvent('bcc-boats:StartTradePrompts')
        end
    end)

    TradePage:RegisterElement('line', {
        slot = 'footer',
        style = {}
    })

    BoatMenu:Open({
        startupPage = MainPage
    })
end
