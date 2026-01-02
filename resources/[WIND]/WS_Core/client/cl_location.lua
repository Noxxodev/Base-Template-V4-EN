ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
    for k, v in pairs(Config.location) do
        local hash = GetHashKey(v.name)
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(1000)
        end

        local ped = CreatePed(4, hash, v.pos.x, v.pos.y, v.pos.z - 1.0, v.pos.h, false, true)
        SetBlockingOfNonTemporaryEvents(ped, v.blocking)
        SetEntityInvincible(ped, v.invincible)
        FreezeEntityPosition(ped, v.freeze)

        exports.qtarget:AddBoxZone("rental", vector3(v.pos.x, v.pos.y, v.pos.z - 0.9), 1.0, 1.5, {
            name = "rental",
            heading = 35,
            debugPoly = false,
            minZ = v.pos.z - 1.0,
            maxZ = v.pos.z + 1.0,
        }, {
            options = {
                {
                    event = "WS_Location:openlocation",
                    id = v.id,
                    icon = v.icon,
                    label = v.titre,
                },
            },
            distance = v.distance
        })

        local blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
        SetBlipSprite(blip, v.blip.sprite)
        SetBlipScale(blip, v.blip.scale)
        SetBlipColour(blip, v.blip.colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(v.blip.name)
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('WS_Location:openlocation')
AddEventHandler('WS_Location:openlocation', function(data)
    local options = {}

    for k, v in pairs(Config.location) do
        if v.id == data.id then
            for _, info in pairs(v.vehicle) do
                table.insert(options, {
                    title = info.label,
                    description = info.description,
                    image = info.image,
                    onSelect = function()
                        spawncar(info.vehicule, info.prix, v.id)
                    end
                })
            end
        end
    end

    lib.registerContext({
        id = 'rental',
        title = 'Car Rental',
        options = options
    })

    lib.showContext('rental')
end)

function spawncar(car, price, ID)
    local money = exports.ox_inventory:Search('count', 'money')

    if money >= price then
        for k, v in pairs(Config.location) do
            if ID == v.id then
                local carHash = GetHashKey(car)
                RequestModel(carHash)
                while not HasModelLoaded(carHash) do
                    RequestModel(carHash)
                    Citizen.Wait(1)
                end

                local vehicle = CreateVehicle(
                    carHash,
                    v.posspawn.x,
                    v.posspawn.y,
                    v.posspawn.z,
                    v.posspawn.h,
                    true,
                    false
                )

                SetEntityAsMissionEntity(vehicle, true, true)
                SetVehicleNumberPlateText(vehicle, "RENTAL")
                SetPedIntoVehicle(PlayerPedId(), vehicle, -1)

                TriggerServerEvent('WS_Location:paidcar', price)

                local timer = lib.timer(v.tempslocation, function()
                    DeleteVehicle(vehicle)
                    lib.hideTextUI()
                    if Config.notif == 1 then
                        ESX.ShowNotification('The rental time has ended.')
                    end
                    if Config.notif == 2 then
                        lib.notify({
                            title = 'Rental',
                            description = "The rental time has ended.",
                            type = 'inform',
                            duration = 10000,
                        })
                    end
                end, true)

                while timer:getTimeLeft('ms') > 0 do
                    local time = timer:getTimeLeft('s')
                    local seconds = math.floor(time)
                    local hours = math.floor(seconds / 3600)
                    local minutes = math.floor((seconds % 3600) / 60)
                    local remainingSeconds = seconds % 60

                    local remainingTime = ""
                    if hours > 0 then
                        remainingTime = remainingTime .. hours .. "h "
                    end
                    if minutes > 0 then
                        remainingTime = remainingTime .. minutes .. "min "
                    end
                    remainingTime = remainingTime .. remainingSeconds .. "s"

                    lib.showTextUI("Time remaining: " .. remainingTime)
                    Wait(1)
                end
            end
        end
    else
        if Config.notif == 1 then
            ESX.ShowNotification("You don't have enough money.")
        end
        if Config.notif == 2 then
            lib.notify({
                title = 'Rental',
                description = "You don't have enough money.",
                type = 'inform',
                duration = 10000,
            })
        end
    end
end
