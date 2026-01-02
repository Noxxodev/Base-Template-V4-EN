ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    for k, v in pairs(Config.teleporation) do 
        if v.blips.active then 
            local blip = AddBlipForCoord(v.blips.pos.x, v.blips.pos.y, v.blips.pos.z)
            SetBlipSprite(blip, v.blips.sprite)
            SetBlipScale(blip, v.blips.scale)
            SetBlipColour(blip, v.blips.colour)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(v.blips.name)
            EndTextCommandSetBlipName(blip)
        end

        if v.ped.active then 
            local hash = GetHashKey(v.ped.nameped)
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Wait(100)
            end
        
            local ped = CreatePed(4, hash, v.ped.pos.x, v.ped.pos.y, v.ped.pos.z - 1.0, v.ped.pos.h, false, true)
            SetBlockingOfNonTemporaryEvents(ped, v.ped.blocking)
            SetEntityInvincible(ped, v.ped.invincible)
            FreezeEntityPosition(ped, v.ped.freeze)
        end

        exports.qtarget:AddBoxZone("teleport_point", vector3(v.ox_target.pos.x, v.ox_target.pos.y, v.ox_target.pos.z), 1.0, 1.5, {
            name = "teleport_point",
            heading = v.ox_target.pos.h,
            debugPoly = false,
            minZ = v.ox_target.pos.z - 1.0,
            maxZ = v.ox_target.pos.z + 1.0,
        }, {
            options = {
                {
                    event = "WS_pointdeteleportation:pointdetp",
                    icon = v.ox_target.icon,
                    label = v.ox_target.titre,
                    id = k
                },
            },
            distance = v.ox_target.distance
        })
    end
end)

RegisterNetEvent('WS_pointdeteleportation:pointdetp')
AddEventHandler('WS_pointdeteleportation:pointdetp', function(data)
    local options = {}

    for k, v in pairs(Config.teleporation) do 
        if data.id == k then 
            for _, info in pairs(v.position) do
                table.insert(options, {
                    title = info.label,
                    onSelect = function()
                        TriggerServerEvent(
                            "WS_pointdeteleportation:teleportation",
                            info.pos,
                            info.label
                        )
                    end,
                })
            end
        end
    end

    lib.registerContext({
        id = 'menu_teleportation',
        title = 'Teleport Menu',
        options = options
    })

    lib.showContext('menu_teleportation')
end)
