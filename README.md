# PlantDisplay - Progetto ESPHome

## Panoramica del Progetto
**PlantDisplay** è un sistema di monitoraggio e controllo smart bassu su ESP32-S3 con display touchscreen da 800x480 pixel. Il dispositivo integra funzionalità di monitoraggio piante, controllo climatizzazione, gestione luci e automazioni domestiche.

## Hardware Utilizzato
- **Microcontrollore**: ESP32-S3 DevKit-C-1
- **Display**: Waveshare RGB Display 800x480 con interfaccia RPI DPI
- **Touchscreen**: GT911 capacitivo
- **Memoria**: 8MB Flash + PSRAM OCTAL (64KB cache)
- **I/O Expander**: CH422G per controllo GPIO aggiuntivi
- **Connettività**: WiFi + Bluetooth (proxy BLE attivo)

## Architettura Software

### Framework e Configurazione
- **ESPHome**: v2025.4.2+ (versione minima richiesta)
- **Framework ESP-IDF**: con ottimizzazioni avanzate
- **LVGL**: Interfaccia grafica con buffer al 100%
- **Home Assistant**: Integrazione completa via API

### Funzionalità Principali

#### 1. **Monitoraggio Piante** (Tab "Piante")
Visualizza 4 piante con i seguenti parametri:
- **Conduttività del suolo** (uS/cm)
- **Illuminamento** (lx)
- **Temperatura** (°C)
- **Umidità relativa** (%)

**Range Ottimali per Tipo di Pianta**:
- **Anthurium 1 & 2**: 350-800 uS/cm (piante tropicali)
- **Alstroemeria**: 300-700 uS/cm (piante bulbose)
- **Graptosedum**: 150-400 uS/cm (piante succulente)

**Indicatori Visivi**:
- **Bordi delle carte**: Grigi (normale) / Rossi (valori fuori range)
- **Testo conduttività**: Grigio scuro (normale) / Rosso (fuori range)
- **Aggiornamento**: Dati in tempo reale da Home Assistant

Ogni pianta ha un indicatore colorato:
- **Anthurium 1**: Verde (0x2E7D32) 
- **Anthurium 2**: Rosa/Viola (0xFCE4EC)
- **Alstroemeria**: Teal (0xE0F2F1)
- **Graptosedum**: Arancione (0xFFF3E0)

#### 2. **Controllo Climatizzazione** (Tab "Clima")
Gestione 4 condizionatori per diverse stanze:
- Soggiorno (22°C)
- Camera (20°C)
- Cucina (24°C)
- Studio (21°C)

#### 3. **Controlli Generali** (Tab "Controlli")
- **Luci**: Controllo illuminazione generale
- **Ventola**: Gestione ventilazione
- **Irrigazione**: Sistema di irrigazione automatico
- **Allarme**: Sistema di sicurezza
- **Musica**: Controllo audio
- **Garage**: Apertura/chiusura garage

#### 4. **Meteo** (Tab "Meteo")
- **Condizioni attuali**: Temperatura, condizioni, umidità, vento
- **Previsioni**: 3 giorni (Domenica, Lunedì, Martedì)

### Caratteristiche Tecniche Avanzate

#### Display e Touchscreen
```yaml
Display: RPI DPI RGB - 800x480
Frequenza PCLK: 16MHz
Touchscreen: GT911 capacitivo I2C
Backlight: Controllato via CH422G
```

#### Sistema Anti-Burn
- **Attivazione automatica**: 5 minuti dopo spegnimento backlight
- **Schedulazione**: Attivo dalle 2:00 alle 5:35 (ogni ora: 5-35 minuti)
- **Modalità**: "Snow effect" per prevenire burn-in

#### Ottimizzazioni Prestazioni
- **PSRAM OCTAL**: 80MHz per prestazioni elevate
- **CPU**: 240MHz con cache ottimizzata
- **Memoria**: 64KB data cache + 524KB RAM massima
- **Flash**: QIO mode a 80MHz

## Struttura File del Progetto

```
plantdisplay/
├── plantdisplay.yaml          # Configurazione principale ESPHome
├── lvgl_config.yaml           # Configurazione interfaccia LVGL
├── secrets.yaml               # Credenziali WiFi e API (ignorato)
├── .gitignore                 # File ignorati da Git
├── .esphome/                  # Directory build ESPHome (ignorata)
│   ├── build/                 # File di compilazione
│   ├── storage/               # Configurazioni salvate
│   └── idedata/               # Dati IDE
├── assets/                    # Immagini per le piante
│   ├── Anthurium.jpg         # Immagine Anthurium
│   ├── Alstroemeria.jpg      # Immagine Alstroemeria
│   └── Ggraptosedum.jpg      # Immagine Graptosedum
└── README.md                  # Questa documentazione
```

## Configurazione Rete
- **SSID**: "Marco&Krasi&Chris"
- **Crittografia API**: Configurata per Home Assistant
- **OTA**: Aggiornamenti Over-The-Air abilitati
- **Bluetooth Proxy**: Attivo per dispositivi BLE

## Pin Assignment ESP32-S3

### Display RGB
```
PCLK: GPIO7
DE: GPIO5
HSYNC: GPIO46
VSYNC: GPIO3
Reset: CH422G Pin 3

Dati RGB:
- Rosso: GPIO1,2,42,41,40
- Verde: GPIO39,0,45,48,47,21  
- Blu: GPIO14,38,18,17,10
```

### I2C e Controlli
```
I2C: SDA=GPIO8, SCL=GPIO9
Touchscreen INT: GPIO4
Touchscreen RST: CH422G Pin 1
Backlight: CH422G Pin 2
```

## Automazioni Integrate

### Gestione Energia
- **Antiburn automatico**: Previene danneggiamento display
- **Schedulazione notturna**: Attivazione automatica 2:00-5:35
- **Gestione backlight**: Controllo intelligente illuminazione

### Logging e Debug
- **Logger ESPHome**: Abilitato per debug
- **LVGL Debug**: Livello DEBUG attivo
- **Boot sequence**: Sequenza di avvio controllata

## Stato del Progetto
Il sistema PlantDisplay è completamente operativo con le seguenti funzionalità:

- **Piante**: Monitoraggio di 4 piante con dati in tempo reale per conduttività, illuminamento, temperatura, e umidità. Interfaccia grafica aggiornata e coerente.
- **Climatizzazione**: Controllo di 4 condizionatori attraverso interfaccia LVGL.
- **Controlli Generali**: Gestione di luci, ventole, irrigazione, allarme, musica e controllo garage.
- **Meteo**: Condizioni attuali e previsioni a 3 giorni.

**Aggiornamenti Recenti**:
- **Font Uniformi**: Tutte le card delle piante ora usano font uniformi per un'interfaccia coerente.
- **Risolto Problema dei Caratteri Speciali**: Sostituiti caratteri µ con u per compatibilità.
- **Aggiornamento Dati Sensori**: Convalidata l'acquisizione in tempo reale dei dati dei sensori.

## Sviluppi Futuri
1. **Sensori fisici avanzati**: Migliorare l'integrazione con sensori fisici completi.
2. **API Meteo**: Incorporare dati meteo in tempo reale tramite API.
3. **Notifiche Push**: Implementare avvisi per condizioni critiche delle piante.
4. **Grafici Storici**: Aggiungere grafici per trend storici dei parametri.
5. **Integrazione Vocale**: Supporto per assistenti vocali.
6. **Temi Giorno/Notte**: UI adattiva basata sull'orario.

## Installazione e Utilizzo

### Prerequisiti
1. **ESPHome**: Versione 2025.4.2 o superiore
2. **Home Assistant**: Con API configurata
3. **Hardware**: ESP32-S3 con display Waveshare 800x480

### Setup Iniziale
1. Clonare il repository del progetto
2. Configurare `secrets.yaml` con:
   ```yaml
   wifi_ssid: "Il_Tuo_SSID"
   wifi_password: "La_Tua_Password"
   api_encryption_key: "La_Tua_Chiave_API"
   ```
3. Caricare le immagini nella cartella `assets/`
4. Compilare e flashare il firmware:
   ```bash
   esphome compile plantdisplay.yaml
   esphome upload plantdisplay.yaml
   ```

### Configurazione Home Assistant
Assicurarsi che i seguenti sensori siano configurati in Home Assistant:
- `sensor.plant_sensor_b90c_conduttivita` (Anthurium 1)
- `sensor.plant_sensor_a299_conduttivita` (Anthurium 2)
- `sensor.plant_sensor_b90a_conduttivita` (Alstroemeria)
- `sensor.plant_sensor_b90e_conduttivita` (Graptosedum)

E i relativi sensori per illuminamento, temperatura e umidità.

## Note Tecniche
- Il progetto utilizza componenti sperimentali ESP-IDF
- Richiede ESPHome 2025.4.2+ per compatibilità LVGL
- PSRAM necessaria per buffer display completo
- CH422G richiede driver specifico per I/O expansion
- Font Montserrat caricato automaticamente da Google Fonts

---
*Documentazione generata automaticamente - Ultima modifica: 26 Gennaio 2025*
