CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false

-- Event to update the weather
RegisterNetEvent('vSync:updateWeather')
AddEventHandler('vSync:updateWeather', function(newWeather, newBlackout)
    CurrentWeather = newWeather
    blackout = newBlackout
end)

-- Weather synchronization thread
Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
            lastWeather = CurrentWeather
            SetWeatherTypeOverTime(CurrentWeather, 15.0) -- Weather transition over 15 seconds
            Citizen.Wait(15000)
        end

        Citizen.Wait(100) -- Small delay to avoid crashes
        SetBlackout(blackout)
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(lastWeather)
        SetWeatherTypeNow(lastWeather)
        SetWeatherTypeNowPersist(lastWeather)

        if lastWeather == 'XMAS' then
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
        else
            SetForceVehicleTrails(false)
            SetForcePedFootstepsTracks(false)
        end
    end
end)

-- Event to update time
RegisterNetEvent('vSync:updateTime')
AddEventHandler('vSync:updateTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

-- Time synchronization thread
Citizen.CreateThread(function()
    local hour = 0
    local minute = 0

    while true do
        Citizen.Wait(1)
        local newBaseTime = baseTime

        if GetGameTimer() - 500 > timer then
            newBaseTime = newBaseTime + 0.25
            timer = GetGameTimer()
        end

        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime
        end

        baseTime = newBaseTime
        hour = math.floor(((baseTime + timeOffset) / 60) % 24)
        minute = math.floor((baseTime + timeOffset) % 60)
        NetworkOverrideClockTime(hour, minute, 0)
    end
end)

-- Request sync when the player spawns
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('vSync:requestSync')
end)

-- Add command suggestions to the chat
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/weather', 'Change the weather.', {
        {
            name = "weatherType",
            help = "Available types: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"
        }
    })

    TriggerEvent('chat:addSuggestion', '/time', 'Set the time.', {
        { name = "hours", help = "Number between 0 and 23" },
        { name = "minutes", help = "Number between 0 and 59" }
    })

    TriggerEvent('chat:addSuggestion', '/freezetime', 'Freeze or unfreeze time.')
    TriggerEvent('chat:addSuggestion', '/freezeweather', 'Enable/disable dynamic weather changes.')
    TriggerEvent('chat:addSuggestion', '/morning', 'Set time to 09:00.')
    TriggerEvent('chat:addSuggestion', '/noon', 'Set time to 12:00.')
    TriggerEvent('chat:addSuggestion', '/evening', 'Set time to 18:00.')
    TriggerEvent('chat:addSuggestion', '/night', 'Set time to 23:00.')
    TriggerEvent('chat:addSuggestion', '/blackout', 'Enable/disable blackout mode.')
end)
