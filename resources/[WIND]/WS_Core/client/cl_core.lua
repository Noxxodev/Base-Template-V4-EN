ESX = exports['es_extended']:getSharedObject()

-- FINGER POINTING

local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(50)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(25)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(75)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                Wait(50)
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end

        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end

        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                camPitch = math.clamp(camPitch, -70.0, 42.0)
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                camHeading = math.clamp(camHeading, -180.0, 180.0)
                camHeading = (camHeading + 180.0) / 360.0

                local cosCamHeading = math.cos(camHeading)
                local sinCamHeading = math.sin(camHeading)

                local blocked, nn
                local coords = GetOffsetFromEntityInWorldCoords(
                    ped,
                    (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)),
                    (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)),
                    0.6
                )

                local ray = Cast_3dRayPointToPoint(
                    coords.x, coords.y, coords.z - 0.2,
                    coords.x, coords.y, coords.z + 0.2,
                    0.4, 95, ped, 7
                )

                nn, blocked, coords, coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson",
                    Citizen.InvokeNative(0xEE778F8C7E1142E2,
                        Citizen.InvokeNative(0x19CAFA3C87F7C2FF)
                    ) == 4
                )
            end
        end
    end
end)

-- POINTER DONE


-- HANDS UP

Citizen.CreateThread(function()
    local dict = "missminuteman_1ig_2"
    
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    local handsup = false
    while true do
        Citizen.Wait(1)
        if IsControlJustPressed(1, 323) then -- X key
            if not handsup then
                TaskPlayAnim(GetPlayerPed(-1), dict, "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
                handsup = true
            else
                handsup = false
                ClearPedTasks(GetPlayerPed(-1))
            end
        end
    end
end)

-- PAUSE MENU

local config = {
    ["ONE"] = "Wind Studio",
    ["TWO"] = "Base Template V4",
    ["THREE"] = "By Noxxo"
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        
        -- Left side
        N_0xb9449845f73f5e9c("SHIFT_CORONA_DESC")
        PushScaleformMovieFunctionParameterBool(true)
        PopScaleformMovieFunction()

        -- Right side
        BeginScaleformMovieMethodOnFrontendHeader("SET_HEADING_DETAILS")
        PushScaleformMovieFunctionParameterString(config["ONE"])
        PushScaleformMovieFunctionParameterString(config["TWO"])
        PushScaleformMovieFunctionParameterString(config["THREE"])
        ScaleformMovieMethodAddParamBool(false)
        ScaleformMovieMethodAddParamBool(isScripted)
        EndScaleformMovieMethod() 
    end
end)

-- INTERFACE BUTTONS
Citizen.CreateThread(function()
    local name = GetPlayerName(PlayerId())
    local id = GetPlayerServerId(PlayerId())
    
    AddTextEntry('FE_THDR_GTAO', 'Base Template V4 - ~b~Wind Studio~s~ | ID: ' .. id .. ' | Name: ' .. name)
    AddTextEntry('PM_PANE_LEAVE', 'Disconnect and return to home 🐌')
    AddTextEntry('PM_PANE_QUIT', 'Exit FiveM 🐌')
    AddTextEntry('PM_SCR_MAP', '🗺️')
    AddTextEntry('PM_SCR_GAM', '🐌')
    AddTextEntry('PM_SCR_INF', '📝')
    AddTextEntry('PM_SCR_SET', '⚙️')
    AddTextEntry('PM_SCR_STA', '📊')
    AddTextEntry('PM_SCR_RPL', 'Editor ∑')
    AddTextEntry('PM_SCR_GAL', '📷')
end)

-- DISABLE ROLL (REALISM)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if IsControlPressed(0, 25) then
            DisableControlAction(0, 22, true)
        end
    end
end)

-- DISABLE MELEE WITH R
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        DisableControlAction(0, 140, true)
    end
end)

-- DISABLE WEAPON BUTT STRIKE
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end
    end
end)

-- ID COMMAND

RegisterCommand('id', function()
    lib.notify({
        title = 'Your ID is ' .. GetPlayerServerId(PlayerId()),
        description = 'Notification',
        position = 'top',
        duration = 5000,
        style = {
            backgroundColor = '#001D32',
            borderRadius = 30,
            color = '#C4E5FF',
            ['.description'] = {
                color = '#909296'
            }
        },
        icon = 'circle-info',
        iconColor = '#C4E5FF'
    })
end, false)
