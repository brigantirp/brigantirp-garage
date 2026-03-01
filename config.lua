Config = {}

-- Elenco garage supportati da questo script.
-- prendiCoords: coordinate dove compare il ped valet (normalmente "coords" nel qbx_garages)
-- spawnCoords: coordinate dove spawnano/parcheggiano i veicoli (normalmente "spawn" nel qbx_garages)
Config.Garages = {
    {
        id = 'legion',
        label = 'Garage Legion',
        garageId = 'legion',
        prendiCoords = vec4(215.84, -810.12, 30.73, 158.0),
        spawnCoords = vec4(229.3, -800.11, 30.57, 158.0),
        parkRadius = 3.0,
    },
}

Config.ValetModel = `s_m_y_valet_01`
Config.PedScenario = 'WORLD_HUMAN_CLIPBOARD'
Config.TargetDistance = 2.0

Config.Menu = {
    id = 'valet_garage_menu',
    title = 'Valet Garage',
    openLabel = 'Apri garage',
    openDescription = 'Apri il garage e seleziona un veicolo.',
}

-- Se usi un evento diverso nel tuo qbx_garages, cambia qui.
Config.OpenGarageEvent = 'qbx_garages:client:openGarage'

-- Se usi un evento server/client diverso per parcheggiare, cambia qui.
Config.ParkVehicleEvent = 'qbx_garages:server:parkVehicle'
Config.UseServerEventForParking = true

Config.TextUI = {
    park = '[E] Parcheggia veicolo',
}
