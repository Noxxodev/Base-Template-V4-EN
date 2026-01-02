ESX = exports["es_extended"]:getSharedObject()

RegisterCommand(Config.Command, function()
    lib.showContext('f5menu')
end)

RegisterKeyMapping(Config.Command, 'Personal menu', 'keyboard', Config.Key)

lib.registerContext({
    id = 'f5menu',
    title = 'F5 Menu',
    options = {
        {
            title = 'My documents',
            description = 'Show my documents',
            icon = 'fa-regular fa-id-card',
            onSelect = function()
                lib.showContext('documentmenu')
            end,
        },
        {
            title = 'Vehicle management',
            description = 'Vehicle management',
            icon = 'fa-solid fa-car',
            onSelect = function()
                lib.showContext('voituremenu')
            end,
        },
    }
})

lib.registerContext({
    id = 'documentmenu',
    title = 'Documents menu',
    menu = 'f5menu',
    options = {
        {
            title = 'Identity card',
            description = 'Identity card',
            icon = 'fa-solid fa-address-card',
            onSelect = function()
                local player, distance = ESX.Game.GetClosestPlayer()

                if distance ~= -1 and distance <= 3.0 then
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                else
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                    ESX.ShowNotification('No player nearby')
                end  
            end,
        },
        {
            title = 'Driving license',
            description = 'Driving license',
            icon = 'fa-solid fa-address-card',
            onSelect = function()
                local player, distance = ESX.Game.GetClosestPlayer()

                if distance ~= -1 and distance <= 3.0 then
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                else
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                    ESX.ShowNotification('No player nearby')
                end
            end,
        },
        {
            title = 'Weapon license',
            description = 'Weapon license',
            icon = 'fa-solid fa-address-card',
            onSelect = function()
                local player, distance = ESX.Game.GetClosestPlayer()

                if distance ~= -1 and distance <= 3.0 then
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
                else
                    TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
                    ESX.ShowNotification('No player nearby')
                end
            end,
        },
    }
})

lib.registerContext({
    id = 'voituremenu',
    title = 'Vehicle menu',
    menu = 'f5menu',
    options = {
        {
            title = 'Roll windows down',
            icon = 'fa-solid fa-car',
            onSelect = function()
                lib.showContext('fenetrevoiturebaisser')
            end,
        },
        {
            title = 'Roll windows up',
            icon = 'fa-solid fa-car',
            onSelect = function()
                lib.showContext('fenetrevoituremonter')
            end,
        },
        {
            title = 'Open doors',
            icon = 'fa-solid fa-car',
            onSelect = function()
                lib.showContext('ouvrirporte')
            end,
        },
        {
            title = 'Close doors',
            icon = 'fa-solid fa-car',
            onSelect = function()
                lib.showContext('fermerporte')
            end,
        },
        {
            title = 'Change seat',
            icon = 'fa-solid fa-car',
            onSelect = function()
                lib.showContext('changerplace')
            end,
        },
        {
            title = 'Engine ON / OFF',
            icon = 'fa-solid fa-car',
            onSelect = function()
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                    SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
                end
            end,
        },
    }
})

lib.registerContext({
    id = 'fenetrevoiturebaisser',
    title = 'Window menu',
    menu = 'voituremenu',
    options = {
        { title = 'Front left',  icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); RollDownWindow(v, 0); lib.showContext('fenetrevoiturebaisser') end },
        { title = 'Front right', icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); RollDownWindow(v, 1); lib.showContext('fenetrevoiturebaisser') end },
        { title = 'Rear left',   icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); RollDownWindow(v, 2); lib.showContext('fenetrevoiturebaisser') end },
        { title = 'Rear right',  icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); RollDownWindow(v, 3); lib.showContext('fenetrevoiturebaisser') end },
        { title = 'All',         icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); for i=0,3 do RollDownWindow(v,i) end; lib.showContext('fenetrevoiturebaisser') end },
    }
})

lib.registerContext({
    id = 'fenetrevoituremonter',
    title = 'Roll windows up',
    menu = 'voituremenu',
    options = {
        { title = 'Front left',  icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); RollUpWindow(v, 0); lib.showContext('fenetrevoituremonter') end },
        { title = 'Front right', icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); RollUpWindow(v, 1); lib.showContext('fenetrevoituremonter') end },
        { title = 'Rear left',   icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); RollUpWindow(v, 2); lib.showContext('fenetrevoituremonter') end },
        { title = 'Rear right',  icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); RollUpWindow(v, 3); lib.showContext('fenetrevoituremonter') end },
        { title = 'All',         icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); for i=0,3 do RollUpWindow(v,i) end; lib.showContext('fenetrevoituremonter') end },
    }
})

lib.registerContext({
    id = 'ouvrirporte',
    title = 'Open doors',
    menu = 'voituremenu',
    options = {
        { title = 'Front left',  icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorOpen(v,0,false); lib.showContext('ouvrirporte') end },
        { title = 'Front right', icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorOpen(v,1,false); lib.showContext('ouvrirporte') end },
        { title = 'Rear left',   icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorOpen(v,2,false); lib.showContext('ouvrirporte') end },
        { title = 'Rear right',  icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorOpen(v,3,false); lib.showContext('ouvrirporte') end },
        { title = 'Hood',        icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorOpen(v,4,false); lib.showContext('ouvrirporte') end },
        { title = 'Trunk',       icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorOpen(v,5,false); lib.showContext('ouvrirporte') end },
        { title = 'All',         icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); for i=0,5 do SetVehicleDoorOpen(v,i,false) end; lib.showContext('ouvrirporte') end },
    }
})

lib.registerContext({
    id = 'fermerporte',
    title = 'Close doors',
    menu = 'voituremenu',
    options = {
        { title = 'Front left',  icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorShut(v,0,false); lib.showContext('fermerporte') end },
        { title = 'Front right', icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorShut(v,1,false); lib.showContext('fermerporte') end },
        { title = 'Rear left',   icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorShut(v,2,false); lib.showContext('fermerporte') end },
        { title = 'Rear right',  icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorShut(v,3,false); lib.showContext('fermerporte') end },
        { title = 'Hood',        icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorShut(v,4,false); lib.showContext('fermerporte') end },
        { title = 'Trunk',       icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetVehicleDoorShut(v,5,false); lib.showContext('fermerporte') end },
        { title = 'All',         icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); for i=0,5 do SetVehicleDoorShut(v,i,false) end; lib.showContext('fermerporte') end },
    }
})

lib.registerContext({
    id = 'changerplace',
    title = 'Change seat',
    menu = 'voituremenu',
    options = {
        { title = 'Driver',        icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetPedIntoVehicle(PlayerPedId(), v, -1); lib.showContext('changerplace') end },
        { title = 'Front right',   icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetPedIntoVehicle(PlayerPedId(), v, 0);  lib.showContext('changerplace') end },
        { title = 'Rear left',     icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetPedIntoVehicle(PlayerPedId(), v, 1);  lib.showContext('changerplace') end },
        { title = 'Rear right',    icon = 'fa-solid fa-car', onSelect = function() local v = GetVehiclePedIsIn(PlayerPedId(), false); SetPedIntoVehicle(PlayerPedId(), v, 2);  lib.showContext('changerplace') end },
    }
})
