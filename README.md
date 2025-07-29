# PlantDisplay - Sistema di Monitoraggio Piante ESPHome

Un elegante display per il monitoraggio delle piante che visualizza i dati dei sensori ricevuti da Home Assistant su un display ESP32-S3 con interfaccia LVGL.

![PlantDisplay](https://img.shields.io/badge/ESPHome-Supportato-green)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Integrato-blue)
![ESP32](https://img.shields.io/badge/ESP32--S3-Compatible-orange)

## Work in progress

-   Attenzione questo è un progetto in corso per, al momento funziona solo la parte delle piante

## 🌱 Caratteristiche

-   **Monitoraggio Multi-Pianta**: Supporta fino a 4 piante diverse con parametri personalizzabili
-   **Display LVGL**: Interfaccia grafica moderna e intuitiva con immagini delle piante
-   **Sensori Multipli**: Monitora umidità del suolo, conducibilità, temperatura e illuminazione
-   **Indicatori Visivi**: Frecce colorate e icone che indicano quando i valori sono fuori range
-   **Integrazione Home Assistant**: Riceve dati in tempo reale dai sensori delle piante
-   **Design Modulare**: Configurazione organizzata in file separati per facilità di manutenzione

## 📋 Piante Supportate

Il sistema attualmente monitora queste piante con i loro parametri ottimali:

1. **Anthurium** (2 esemplari)

    - Conducibilità: 250-2000 µS/cm
    - Temperatura: 15-32°C
    - Umidità: 16-65%
    - Luce: 1-10000 lux

2. **Alstroemeria**

    - Conducibilità: 350-2000 µS/cm
    - Temperatura: 8-32°C
    - Umidità: 15-60%
    - Luce: 1-10000 lux

3. **Graptosedum**
    - Conducibilità: 300-1000 µS/cm
    - Temperatura: 5-35°C
    - Umidità: 7-50%
    - Luce: 1-10000 lux

> **Nota**: I parametri possono essere facilmente personalizzati modificando i valori in `plantdisplay.yaml`

## 🛠️ Hardware Richiesto

-   **ESP32-S3-Touch-LCD-7** (Display touch da 7" con ESP32-S3 integrato)
-   **Sensori Xiaomi Mi Flora** (o compatibili) per il monitoraggio delle piante
-   **Home Assistant** con integrazione Xiaomi Mi Flora configurata
-   **Alimentazione USB-C** per ESP32-S3-Touch-LCD-7
-   **Rete WiFi** per la connessione

## 📦 Struttura del Progetto

```
plantdisplay/
├── plantdisplay.yaml         # Configurazione principale ESPHome
├── secrets.yaml              # Configurazioni sensibili
├── utils.sh                  # Script di utilità
├── include/                  # Immagini delle piante
│   ├── plant_sensors.yaml    # Template per sensori delle piante
│   ├── lvgl_config.yaml      # Configurazione interfaccia LVGL
│   └── plant_card.yaml       # Template per le card delle piante
├── assets/                   # Immagini delle piante
│   ├── Anthurium.jpg
│   ├── Alstroemeria.jpg
│   ├── Cactus.jpg
│   └── Ggraptosedum.jpg
├── fonts/                    # Font per l'interfaccia
│   ├── Montserrat-*.ttf
│   └── materialdesignicons-*.ttf
```

## 🚀 Installazione

### Prerequisiti

1. **ESPHome** installato e aggiornato:

    ```bash
    pip install esphome
    # o se preferisci usare Home Assistant Add-on
    ```

2. **Home Assistant** con integrazione Xiaomi Mi Flora configurata

3. **Token di accesso** Home Assistant (Long-lived access token)

### Configurazione Home Assistant

Prima di configurare il display, assicurati che i sensori Mi Flora siano configurati in Home Assistant:

1. **Installa l'integrazione Xiaomi Mi Flora** in Home Assistant
2. **Configura i sensori** e annota gli `entity_id` (es. `sensor.plant_sensor_b90c_conductivity`)
3. **Crea un token di accesso** a lunga durata in Home Assistant:
    - Vai su Profilo → Sicurezza → Token di accesso a lunga durata
    - Crea un nuovo token e copialo

### Configurazione Display

1. **Clona o scarica il progetto**:

    ```bash
    git clone [url-repository]
    cd plantdisplay
    ```

2. **Configura secrets.yaml**:

    ```yaml
    wifi_ssid: "TuaWiFi"
    wifi_password: "PasswordWiFi"
    api_encryption_key: "chiave-32-caratteri-esadecimali"
    ota_password: "password-ota-sicura"
    home_assistant_url: "http://192.168.1.100:8123" # URL del tuo Home Assistant
    ```

3. **Configura il token Home Assistant**:
   Inserisci il tuo token Home Assistant a lunga durata nel file `hass_token`

4. **Personalizza sensori**:
   Modifica gli `entity_id` in `plantdisplay.yaml` per corrispondere ai tuoi sensori Mi Flora:
    ```yaml
    anthurium1: !include
        file: plant_sensors.yaml
        vars:
            prefix: plant1
            entity_prefix: sensor.il_tuo_sensore_miflora # Cambia qui
    ```

### Compilazione e Flash

**Metodo 1: Script di utilità (consigliato)**

```bash
# Rendi eseguibile lo script
chmod +x utils.sh

# Compila il progetto
./utils.sh compile

# Flash su dispositivo (collega ESP32 via USB)
./utils.sh upload

# Monitora i log in tempo reale
./utils.sh logs

# Pulizia build (se necessario)
./utils.sh clean
```

**Metodo 2: Comandi ESPHome diretti**

```bash
# Compila
esphome compile plantdisplay.yaml

# Upload (assicurati che ESP32-S3-Touch-LCD-7 sia collegato via USB)
esphome upload plantdisplay.yaml

# Monitora logs
esphome logs plantdisplay.yaml
```

**Primo avvio:**

1. Il display si accenderà e mostrerà la schermata di boot
2. Si connetterà al WiFi (verifica nei log)
3. Si connetterà a Home Assistant
4. Mostrerà l'interfaccia principale con le piante

## 🔧 Personalizzazione

### Aggiungere Nuove Piante

1. Aggiungi una nuova sezione in `plantdisplay.yaml`:

    ```yaml
    nuova_pianta: !include
        file: plant_sensors.yaml
        vars:
            prefix: plant5
            entity_prefix: sensor.nuovo_sensore
            light: [100, 50000]
            conductivity: [200, 1500]
            temperature: [10.0, 30.0]
            humidity: [20, 70]
    ```

2. Aggiungi l'immagine corrispondente in `assets/`

3. Aggiorna `lvgl_config.yaml` per includere la nuova card

### Modificare Soglie dei Sensori

Modifica i valori nei parametri `vars` in `plantdisplay.yaml`:

-   `light`: [min, max] lux
-   `conductivity`: [min, max] µS/cm
-   `temperature`: [min, max] °C
-   `humidity`: [min, max] %

## 📊 Monitoraggio

Il display mostra per ogni pianta:

-   **Immagine** della pianta
-   **Umidità del suolo** con indicatore di stato
-   **Conducibilità** (fertilità) con range ottimale
-   **Temperatura** ambiente
-   **Illuminazione** ricevuta
-   **Frecce colorate** per valori fuori range

### Codici Colore

-   🟢 **Verde**: Valore ottimale
-   🔴 **Rosso**: Valore fuori range
-   ⬆️ **Freccia su**: Valore troppo alto
-   ⬇️ **Freccia giù**: Valore troppo basso

## 🔧 Risoluzione Problemi

### Display Non Si Accende

-   Verifica l'alimentazione USB-C del display ESP32-S3-Touch-LCD-7
-   Controlla il cavo USB-C e l'alimentatore (minimo 2A)
-   Verifica che il firmware sia stato caricato correttamente
-   Controlla i log ESPHome per errori di avvio

### Sensori Non Aggiornati

-   Controlla connettività WiFi del display
-   Verifica token Home Assistant nel file `hass_token`
-   Controlla entity_id sensori in Home Assistant
-   Verifica che i sensori Mi Flora siano online e funzionanti
-   Controlla la configurazione dell'integrazione Mi Flora in Home Assistant

### Font o Immagini Non Visualizzate

-   Verifica che i file font siano presenti nella cartella `fonts/`
-   Controlla che le immagini delle piante siano nella cartella `assets/`
-   Verifica dimensioni e formato delle immagini (JPG, 120x120px consigliato)

### Errori di Compilazione

-   Aggiorna ESPHome all'ultima versione
-   Verifica sintassi YAML
-   Controlla percorsi font e immagini

## 🤝 Contributi

I contributi sono benvenuti! Per contribuire:

1. Fork del repository
2. Crea un branch per la feature (`git checkout -b feature/AmazingFeature`)
3. Commit delle modifiche (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Apri una Pull Request

## 📄 Licenza

Questo progetto è distribuito sotto licenza MIT. Vedi il file `LICENSE` per maggiori dettagli.

## 🙏 Ringraziamenti

-   [ESPHome](https://esphome.io/) per il framework
-   [LVGL](https://lvgl.io/) per la libreria grafica
-   [Home Assistant](https://www.home-assistant.io/) per l'integrazione
-   Comunità open source per il supporto

## 📞 Supporto

Per problemi, domande o suggerimenti:

-   **Issues**: Apri una [Issue](../../issues) su GitHub per bug o richieste di funzionalità
-   **Documentazione**: Consulta la [documentazione ESPHome](https://esphome.io/) per problemi tecnici
-   **Community**: Visita il [forum Home Assistant](https://community.home-assistant.io/) per supporto generale
-   **Mi Flora**: Per problemi con i sensori, consulta la [documentazione integrazione Mi Flora](https://www.home-assistant.io/integrations/xiaomi_miio/)

### FAQ

**Q: Il display non mostra i dati dei sensori**  
A: Verifica che gli `entity_id` in `plantdisplay.yaml` corrispondano esattamente a quelli in Home Assistant.

**Q: Come trovo gli entity_id dei miei sensori Mi Flora?**  
A: In Home Assistant, vai su Strumenti per sviluppatori → Stati e cerca "plant_sensor" o il nome del tuo sensore.

**Q: Posso usare sensori diversi da Mi Flora?**  
A: Sì, basta modificare gli `entity_id` per puntare ai tuoi sensori in Home Assistant.

---

**⚠️ Importante**: Questo progetto richiede sensori delle piante già configurati e funzionanti in Home Assistant. Assicurati che i sensori Mi Flora siano operativi prima di configurare il display.

## README generato automaticamente ;-)
