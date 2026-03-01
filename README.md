# qbx_valet_parking

Script semplice per Qbox che integra:

- `qbx_garages` per apertura/gestione garage
- `ox_target` per interazione con ped
- `ox_lib` per menu/context e TextUI

## Cosa fa

Per ogni garage configurato:

1. Spawna un ped `s_m_y_valet_01` in `prendiCoords`.
2. Avvicinandoti al ped, tramite `ox_target`, puoi selezionare **Apri garage**.
3. Si apre il menu context di `ox_lib`; cliccando **Apri garage** viene triggerato l'evento configurato per aprire `qbx_garages`.
4. Nel punto `spawnCoords`, quando sei nel veicolo, premi **E** per parcheggiare nel garage configurato.

## Installazione

1. Copia la cartella della resource nel tuo server.
2. Aggiungi nel `server.cfg`:

```cfg
ensure ox_lib
ensure ox_target
ensure qbx_garages
ensure qbx_valet_parking
```

3. Modifica `config.lua`:
   - `garageId`: deve combaciare con l'id garage usato da `qbx_garages`.
   - `prendiCoords`: punto dove vuoi il ped valet.
   - `spawnCoords`: punto spawn/parcheggio.
   - `OpenGarageEvent` / `ParkVehicleEvent`: se i tuoi eventi sono diversi, aggiornali.

## Note importanti

- Gli eventi di `qbx_garages` possono variare in base alla versione o personalizzazioni.
- Se non si apre il garage o non parcheggia, controlla i nomi evento nel tuo `qbx_garages` e aggiorna il `config.lua`.
