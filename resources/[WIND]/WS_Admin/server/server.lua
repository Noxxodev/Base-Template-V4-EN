ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('WS_Admin:getgroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()

    if group == 'admin' or group == 'owner' then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('WS_Admin:gotoplayer')
AddEventHandler('WS_Admin:gotoplayer', function(target)
    local playerPed = GetPlayerPed(source)
    local targetPed = GetPlayerPed(tonumber(target))
    local targetCoords = GetEntityCoords(targetPed)

    if targetPed ~= 0 then 
        SetEntityCoords(playerPed, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, true)
        TriggerClientEvent('esx:showNotification', source, "You have been successfully teleported to the player.", "success")
    else
        TriggerClientEvent('esx:showNotification', source, "The player does not exist.", "error")
    end
end)

RegisterServerEvent('WS_Admin:bringplayer')
AddEventHandler('WS_Admin:bringplayer', function(target)
    local targetPed = GetPlayerPed(tonumber(target))
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    if targetPed ~= 0 then 
        SetEntityCoords(targetPed, playerCoords.x, playerCoords.y, playerCoords.z, false, false, false, true)
        TriggerClientEvent('esx:showNotification', source, "You have successfully teleported the player to you.", "success")
    else
        TriggerClientEvent('esx:showNotification', source, "The player does not exist.", "error")
    end
end)

RegisterServerEvent('WS_Admin:spawncar')
AddEventHandler('WS_Admin:spawncar', function(carname)
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)

    local hash = GetHashKey(carname)

    local vehicle = CreateVehicle(hash, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)

    TriggerClientEvent('esx:showNotification', source, "Vehicle spawned.", "success")
end)

---------------------------------------------------------------------------------------------------------------------
-- Info
print("[^4WIND STUDIO^7] " .. "Admin Template" .. ", [^1VERSION^7] 1.0.0, [^2BY^7] Noxxo, [^5DISCORD^7] https://discord.gg/7SBn6ygS87")
