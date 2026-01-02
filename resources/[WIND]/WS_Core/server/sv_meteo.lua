------------------ EDIT THIS -------------------

-- Set this value to false if you do not want the weather to change automatically every 10 minutes.
DynamicWeather = true

---------------------------------------------------
debugprint = false -- do not touch this unless you know what you are doing or unless Vespura asked you to enable this.
---------------------------------------------------

-------------------- DO NOT MODIFY --------------------
AvailableWeatherTypes = {
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN',
}

CurrentWeather = "EXTRASUNNY"
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = 10

RegisterServerEvent('vSync:requestSync')
AddEventHandler('vSync:requestSync', function()
    TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

function isAllowedToChange(player)
    local playerSRC = player
    local xPlayer = ESX.GetPlayerFromId(playerSRC)
    local rank = xPlayer.getGroup()
    local allowed = false

    for _, needrank in pairs(Config.adminweather) do
        if rank == needrank then
            allowed = true
        end
    end

    if not allowed then
        TriggerClientEvent("esx:showNotification", playerSRC, "You are not allowed to use this command.")
    end
    return allowed
end

RegisterCommand('freezetime', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            freezeTime = not freezeTime
            if freezeTime then
                TriggerClientEvent('esx:showNotification', source, 'Time is now ~b~frozen~s~.')
            else
                TriggerClientEvent('esx:showNotification', source, 'Time is ~y~no longer frozen~s~.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have permission to use this command.')
        end
    else
        freezeTime = not freezeTime
        print(freezeTime and "Time is now frozen." or "Time is no longer frozen.")
    end
end)

RegisterCommand('freezeweather', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            DynamicWeather = not DynamicWeather
            if not DynamicWeather then
                TriggerClientEvent('esx:showNotification', source, 'Dynamic weather changes are now ~r~disabled~s~.')
            else
                TriggerClientEvent('esx:showNotification', source, 'Dynamic weather changes are now ~b~enabled~s~.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have permission to use this command.')
        end
    else
        DynamicWeather = not DynamicWeather
        print(DynamicWeather and "Weather is no longer frozen." or "Weather is now frozen.")
    end
end)

RegisterCommand('weather', function(source, args)
    local function isValidWeatherType(wtype)
        for _, type in ipairs(AvailableWeatherTypes) do
            if wtype == type then return true end
        end
        return false
    end

    if args[1] == nil then
        local msg = "Invalid syntax, use: /weather <weather_type>"
        if source == 0 then
            print(msg)
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1' .. msg)
        end
        return
    end

    local newWeather = string.upper(args[1])
    if not isValidWeatherType(newWeather) then
        local validList = table.concat(AvailableWeatherTypes, ' ')
        local msg = "Invalid weather type. Valid types: " .. validList
        if source == 0 then
            print(msg)
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1' .. msg)
        end
        return
    end

    if source == 0 or isAllowedToChange(source) then
        CurrentWeather = newWeather
        newWeatherTimer = 10
        TriggerEvent('vSync:requestSync')
        if source ~= 0 then
            TriggerClientEvent('esx:showNotification', source, 'Weather will change to: ~y~' .. string.lower(newWeather) .. '~s~.')
        else
            print("Weather updated.")
        end
    end
end, false)

RegisterCommand('blackout', function(source)
    blackout = not blackout
    if source == 0 then
        print(blackout and "Blackout enabled." or "Blackout disabled.")
    elseif isAllowedToChange(source) then
        TriggerClientEvent(
            'esx:showNotification',
            source,
            blackout and 'Blackout ~b~enabled~s~.' or 'Blackout ~r~disabled~s~.'
        )
        TriggerEvent('vSync:requestSync')
    end
end)

RegisterCommand('morning', function(source)
    if source == 0 then print('Use "/time <hh> <mm>" from console') return end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerClientEvent('esx:showNotification', source, 'Time set to ~y~morning~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)

RegisterCommand('noon', function(source)
    if source == 0 then print('Use "/time <hh> <mm>" from console') return end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerClientEvent('esx:showNotification', source, 'Time set to ~y~noon~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)

RegisterCommand('evening', function(source)
    if source == 0 then print('Use "/time <hh> <mm>" from console') return end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerClientEvent('esx:showNotification', source, 'Time set to ~y~evening~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)

RegisterCommand('night', function(source)
    if source == 0 then print('Use "/time <hh> <mm>" from console') return end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerClientEvent('esx:showNotification', source, 'Time set to ~y~night~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)

function ShiftToMinute(minute)
    timeOffset = timeOffset - (((baseTime + timeOffset) % 60) - minute)
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ((((baseTime + timeOffset) / 60) % 24) - hour) * 60
end

RegisterCommand('time', function(source, args)
    local h, m = tonumber(args[1]), tonumber(args[2])
    if source == 0 then
        if h and m then
            ShiftToHour(math.min(h, 23))
            ShiftToMinute(math.min(m, 59))
            print("Time changed to " .. h .. ":" .. m .. ".")
            TriggerEvent('vSync:requestSync')
        else
            print("Syntax: /time <hour> <minute>")
        end
    elseif isAllowedToChange(source) then
        ShiftToHour(math.min(h or 0, 23))
        ShiftToMinute(math.min(m or 0, 59))
        TriggerClientEvent('esx:showNotification', source, "Time has been updated.")
        TriggerEvent('vSync:requestSync')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local newBaseTime = os.time(os.date("!*t")) / 2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait(60000)
        if newWeatherTimer == 0 then
            if DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = 10
        end
    end
end)

function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY" then
        CurrentWeather = (math.random(1,2) == 1) and "CLEARING" or "OVERCAST"
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            CurrentWeather = (CurrentWeather == "CLEARING") and "FOGGY" or "RAIN"
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end

    TriggerEvent("vSync:requestSync")

    if debugprint then
        print("[vSync] A new random weather type has been generated: " .. CurrentWeather .. ".")
        print("[vSync] Timer has been reset to 10 minutes.")
    end
end
