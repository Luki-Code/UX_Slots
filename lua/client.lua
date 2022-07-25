Framework = nil
ESX = nil

if Config.Framework == 'ESX' then

    Citizen.CreateThread(function()
        while not Framework do
            TriggerEvent('esx:getSharedObject', function(obj)
                Framework = obj
            end)
            Citizen.Wait(10)
        end
    end)

    RegisterNetEvent('slots:on')
    AddEventHandler('slots:on', function()

        
        Framework.TriggerServerCallback("Slots:BalanceStatement", function (cb)
            SendNUIMessage({
                display = true,
                type = "ui",
                guthaben = cb,
                SetNuiFocus(true, true)

            })
        end)
    end)



    RegisterNUICallback('RemoveMoneyFromBets', function(data)
        Framework.TriggerServerCallback("Slots:RemoveMoneyFromBetsServer", function(cb)
            SendNUIMessage({
                type = "ui",

                guthaben = cb
            })
        end, data.moneyPlaced)


    end)


    RegisterNUICallback('AddMoneyFromWin', function(win)
        Framework.TriggerServerCallback("Slots:AddMoneyFromWinServer", function(cb)
            SendNUIMessage({
                type = "ui",

                guthaben = cb
            })
        end, win.win)

    end)



elseif Config.Framework == 'QBCore' then

    Citizen.CreateThread(function()
        while not Framework do
            Framework = exports['qb-core']:GetCoreObject()
            Citizen.Wait(10)
        end
    end)

    RegisterNetEvent('slots:on')
    AddEventHandler('slots:on', function()

        Framework.Functions.TriggerCallback("Slots:BalanceStatement", function (cb)
            SendNUIMessage({
                type = "ui",
                guthaben = cb,
                display = true,
                SetNuiFocus(true, true)

            })
        end)
    end)



    RegisterNetEvent('slots:on')
    AddEventHandler('slots:on', function()

        Framework.Functions.TriggerCallback("Slots:BalanceStatement", function(cb)

            SendNUIMessage({
                type = "ui",
                guthaben = cb,
                display = true,
                SetNuiFocus(true, true)

            })
        end)
    end)


    RegisterNUICallback('RemoveMoneyFromBets', function(data)
        Framework.Functions.TriggerCallback("Slots:RemoveMoneyFromBetsServer", function(cb)
            SendNUIMessage({
                type = "ui",

                guthaben = cb
            })
        end, data.moneyPlaced)


    end)


    RegisterNUICallback('AddMoneyFromWin', function(win)
        Framework.Functions.TriggerCallback("Slots:AddMoneyFromWinServer", function(cb)
            SendNUIMessage({
                type = "ui",

                guthaben = cb
            })

        end, win.win)
    end)


end





local requiredDistance = Config.OpenRange --Meters

Citizen.CreateThread(function()
    local playerPos = GetEntityCoords(PlayerPedId())

    while true do
        local shortestDistance = math.huge
        for name,coords in pairs(Config.SlotMachines) do
            playerPos = GetEntityCoords(PlayerPedId())


            local distance = #(playerPos - coords)

            if distance < shortestDistance then
                shortestDistance = distance

            end

            if distance <= requiredDistance then


                while distance <= requiredDistance do
                    if (IsControlJustReleased(0, 38)) then
                        TriggerEvent("slots:on")

                    end
                    Citizen.Wait(0)


                    playerPos = GetEntityCoords(PlayerPedId())
                    distance = #(playerPos - coords)
                end
            end
        end
        Citizen.Wait(100 + math.floor(shortestDistance * 10)) -- Increases the waiting time by the player distance -> 500 meter == 5 seconds / 30m == 400 milliseconds += 100ms base tick
    end
end)




RegisterNUICallback('NUIOFF', function()
    SetNuiFocus(false, false)
    slotsOff()
end)







function slotsOff()
    SendNUIMessage({
        SetNuiFocus(false, false)

    })
end







