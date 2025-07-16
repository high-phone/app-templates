local resourceName = GetCurrentResourceName()

CreateThread(function()
    while GetResourceState('high-phone') ~= "started" do
        Wait(500)
    end

    local success, response = exports['high-phone']:addApplication("vue_app", {
        developer = "High Scripts",
        preAdded = true,
        size = 69.69,
        icon = {
            imageUrl = ("https://cfx-nui-%s/ui/dist/icon.png"):format(resourceName),
            background = "#0E0F0E"
        },
        externalUrl = 'http://localhost:3310'
        -- externalUrl = ('@%s/ui/dist/index.html'):format(resourceName),
    }, {
        ["en"] = {
            label = "Vue App",
            description = "A custom Vue application"
        }
    })

    if not success then
        warn("Failed to add custom application", response)
    end
end)

RegisterNUICallback('getCoords', function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    cb({ x = coords.x, y = coords.y, z = coords.z })
end)

CreateThread(function ()
    local index = 1

    while true do
        Wait(1000)
        
        exports['high-phone']:sendAppNui("vue_app", {
            action = 'heartbeat',
            payload = {
                index = index
            }
        })

        index = index + 1
    end
end)

--[[ exports["high-phone"]:sendNotification({
    application = { name = "fd_banking" },
    content = text
})

exports["high-phone"]:sendAppNui('fd_banking', data) ]]