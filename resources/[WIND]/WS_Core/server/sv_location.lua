ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('WS_Location:paidcar')
AddEventHandler('WS_Location:paidcar', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(price)
end)

