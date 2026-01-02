ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('WS_pointdeteleportation:teleportation')
AddEventHandler('WS_pointdeteleportation:teleportation', function(pos, posname)
    local playerPed = GetPlayerPed(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if playerPed ~= 0 then 
        SetEntityCoords(playerPed, pos.x, pos.y, pos.z, false, false, false, true)
        TriggerClientEvent('esx:showNotification', source, "You have been teleported to: " .. posname)
    else
        TriggerClientEvent('esx:showNotification', source, "Player not found")
    end
end)

print("[^4WIND STUDIO^7] " .. "Teleportation" .. ", [^1VERSION^7] 1.0.0, [^2BY^7] Noxxo, [^5DISCORD^7] https://discord.gg/7SBn6ygS87")
