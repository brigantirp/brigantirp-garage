local spawnedPeds = {}
local showingTextUi = false

local function notifyError(message)
    lib.notify({
        title = 'Garage',
        description = message,
        type = 'error'
    })
end

local function requestModel(model)
    if not IsModelInCdimage(model) then return false end
    RequestModel(model)

    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then
            return false
        end
        Wait(50)
    end

    return true
end

local function openGarageFor(data)
    TriggerEvent(Config.OpenGarageEvent, data.garageId)
end

local function registerMenu(data)
    local menuId = ('%s_%s'):format(Config.Menu.id, data.id)

    lib.registerContext({
        id = menuId,
        title = data.label or Config.Menu.title,
        options = {
            {
                title = Config.Menu.openLabel,
                description = Config.Menu.openDescription,
                icon = 'warehouse',
                onSelect = function()
                    openGarageFor(data)
                end
            }
        }
    })

    return menuId
end

local function spawnValet(data)
    local model = Config.ValetModel
    local ok = requestModel(model)
    if not ok then
        notifyError(('Impossibile caricare modello ped: %s'):format(model))
        return
    end

    local coords = data.prendiCoords
    local ped = CreatePed(0, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, false)

    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)

    if Config.PedScenario and Config.PedScenario ~= '' then
        TaskStartScenarioInPlace(ped, Config.PedScenario, 0, true)
    end

    SetModelAsNoLongerNeeded(model)

    local menuId = registerMenu(data)
    exports.ox_target:addLocalEntity(ped, {
        {
            name = ('open_garage_%s'):format(data.id),
            icon = 'fa-solid fa-warehouse',
            label = Config.Menu.openLabel,
            distance = Config.TargetDistance,
            onSelect = function()
                lib.showContext(menuId)
            end
        }
    })

    spawnedPeds[#spawnedPeds + 1] = ped
end

local function vehicleCanBeParked(vehicle, spawnCoords, radius)
    local vehCoords = GetEntityCoords(vehicle)
    local dist = #(vehCoords - vec3(spawnCoords.x, spawnCoords.y, spawnCoords.z))
    return dist <= radius
end

local function tryParkCurrentVehicle(data)
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then
        notifyError('Devi essere in un veicolo per parcheggiare.')
        return
    end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if GetPedInVehicleSeat(vehicle, -1) ~= ped then
        notifyError('Devi essere il guidatore del veicolo.')
        return
    end

    if not vehicleCanBeParked(vehicle, data.spawnCoords, data.parkRadius) then
        notifyError('Devi essere nel punto di spawn per parcheggiare.')
        return
    end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)

    if Config.UseServerEventForParking then
        TriggerServerEvent(Config.ParkVehicleEvent, data.garageId, netId, plate)
    else
        TriggerEvent(Config.ParkVehicleEvent, data.garageId, netId, plate)
    end
end

local function handleParkingLoop()
    while true do
        local waitTime = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        local insideZone = false
        local selectedGarage

        for i = 1, #Config.Garages do
            local garage = Config.Garages[i]
            local spawnPos = garage.spawnCoords
            local dist = #(playerCoords - vec3(spawnPos.x, spawnPos.y, spawnPos.z))

            if dist <= (garage.parkRadius + 1.0) then
                insideZone = true
                selectedGarage = garage
                waitTime = 0
                break
            end
        end

        if insideZone and selectedGarage then
            if not showingTextUi then
                lib.showTextUI(Config.TextUI.park)
                showingTextUi = true
            end

            if IsControlJustReleased(0, 38) then -- E
                tryParkCurrentVehicle(selectedGarage)
            end
        elseif showingTextUi then
            lib.hideTextUI()
            showingTextUi = false
        end

        Wait(waitTime)
    end
end

CreateThread(function()
    for i = 1, #Config.Garages do
        spawnValet(Config.Garages[i])
    end

    handleParkingLoop()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    if showingTextUi then
        lib.hideTextUI()
    end

    for i = 1, #spawnedPeds do
        local ped = spawnedPeds[i]
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
    end
end)
