RegisterCommand("startfire", function()
    local input = exports.ox_lib:inputDialog('Starta en eld', {
        { type = "input", label = "Coords (x,y,z)", placeholder = "Skriv in koordinater" },
        { type = "number", label = "Tid (sekunder)", default = 60 },
        { type = "number", label = "Storlek (meters)", default = 5 }
    })

    if input then
        local coords = input[1]
        local duration = tonumber(input[2])
        local size = tonumber(input[3])

        local coordsArray = splitString(coords, ",")
        local x, y, z = tonumber(coordsArray[1]), tonumber(coordsArray[2]), tonumber(coordsArray[3])

        if x and y and z then
            TriggerServerEvent("startFire", x, y, z, duration, size)
            exports.ox_lib:notify({ type = "success", title = "Eld Startad", description = "Du har startat en eld vid dessa koordinater: " .. coords, duration = 5000 })
        else
            exports.ox_lib:notify({ type = "error", title = "Error", description = "Ogiltiga koordinater har angetts", duration = 5000 })
        end
    end
end)

RegisterNetEvent('clientStartFire')
AddEventHandler('clientStartFire', function(x, y, z, duration, size)
    local fireIds = {}
    local fireDensity = 2 -- Increase this value for more fires, making the fire denser

    -- Calculate number of fires in each dimension
    local numFires = math.floor(size / fireDensity)

    for i = -numFires, numFires do
        for j = -numFires, numFires do
            local fireX = x + i * fireDensity
            local fireY = y + j * fireDensity
            local fireZ = z
            table.insert(fireIds, StartScriptFire(fireX, fireY, fireZ, 25, false))
        end
    end

    Wait(duration * 1000)

    -- Remove all fires
    for _, fireId in ipairs(fireIds) do
        RemoveScriptFire(fireId)
    end
end)

function splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
