local carry = {
    InProgress = false,
    targetSrc = -1,
    type = "",
    carrier = {
        animDict = "missfinale_c2mcs_1",
        anim = "fin_c2_mcs_1_camman",
        flag = 49,
    },
    carried = {
        animDict = "nm",
        anim = "firemans_carry",
        attachX = 0.27,
        attachY = 0.15,
        attachZ = 0.63,
        flag = 33,
    }
}

local function showNativeNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function getClosestPlayer(radius)
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local me = PlayerPedId()
    local myCoords = GetEntityCoords(me)

    for _, playerId in ipairs(players) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= me then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(targetCoords - myCoords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = playerId
                closestDistance = distance
            end
        end
    end

    if closestDistance ~= -1 and closestDistance <= radius then
        return closestPlayer
    else
        return nil
    end
end

local function loadAnimation(animDict)
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(10)
        end
    end
    return animDict
end

RegisterCommand("carry", function(source, args)
    if not carry.InProgress then
        local nearbyPlayer = getClosestPlayer(3)
        if nearbyPlayer then
            local targetSrc = GetPlayerServerId(nearbyPlayer)
            if targetSrc ~= -1 then
                carry.InProgress = true
                carry.targetSrc = targetSrc
                TriggerServerEvent("CarryPeople:sync", targetSrc)
                loadAnimation(carry.carrier.animDict)
                carry.type = "carry"
            else
                showNativeNotification("No nearby player to carry!")
            end
        else
            showNativeNotification("No nearby player to carry!")
        end
    else
        carry.InProgress = false
        ClearPedSecondaryTask(PlayerPedId())
        DetachEntity(PlayerPedId(), true, false)
        TriggerServerEvent("CarryPeople:stop", carry.targetSrc)
        carry.targetSrc = 0
    end
end, false)

RegisterNetEvent("CarryPeople:syncTarget")
AddEventHandler("CarryPeople:syncTarget", function(targetSrc)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    carry.InProgress = true
    loadAnimation(carry.carried.animDict)
    AttachEntityToEntity(
        PlayerPedId(),
        targetPed,
        0,
        carry.carried.attachX,
        carry.carried.attachY,
        carry.carried.attachZ,
        0.5,
        0.5,
        180,
        false,
        false,
        false,
        false,
        2,
        false
    )
    carry.type = "beingcarried"
end)

RegisterNetEvent("CarryPeople:cl_stop")
AddEventHandler("CarryPeople:cl_stop", function()
    carry.InProgress = false
    ClearPedSecondaryTask(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
end)

Citizen.CreateThread(function()
    while true do
        if carry.InProgress then
            if carry.type == "beingcarried" then
                if not IsEntityPlayingAnim(PlayerPedId(), carry.carried.animDict, carry.carried.anim, 3) then
                    TaskPlayAnim(
                        PlayerPedId(),
                        carry.carried.animDict,
                        carry.carried.anim,
                        8.0,
                        -8.0,
                        100000,
                        carry.carried.flag,
                        0,
                        false,
                        false,
                        false
                    )
                end
            elseif carry.type == "carry" then
                if not IsEntityPlayingAnim(PlayerPedId(), carry.carrier.animDict, carry.carrier.anim, 3) then
                    TaskPlayAnim(
                        PlayerPedId(),
                        carry.carrier.animDict,
                        carry.carrier.anim,
                        8.0,
                        -8.0,
                        100000,
                        carry.carrier.flag,
                        0,
                        false,
                        false,
                        false
                    )
                end
            end
        end
        Wait(1)
    end
end)
