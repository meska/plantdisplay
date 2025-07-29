#!/bin/bash
# Script di utilità per gestione progetto PlantDisplay ESPHome
# Utilizzo: ./utils.sh [comando]

set -e

PROJECT_NAME="plantdisplay"
YAML_FILE="${PROJECT_NAME}.yaml"
DEVICE="/dev/cu.usbmodem83301"
# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funzione per stampare messaggi colorati
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verifica che ESPHome sia installato
check_esphome() {
    if ! command -v esphome &> /dev/null; then
        print_error "ESPHome non trovato. Installa con: pip install esphome"
        exit 1
    fi
    print_success "ESPHome trovato: $(esphome version)"
}

# Compila il progetto
compile() {
    print_status "Compilazione di ${PROJECT_NAME}..."
    check_esphome
    
    if [ ! -f "$YAML_FILE" ]; then
        print_error "File $YAML_FILE non trovato!"
        exit 1
    fi
    
    esphome compile "$YAML_FILE"
    print_success "Compilazione completata!"
}

# Upload del firmware
upload() {
    print_status "Upload firmware su ${PROJECT_NAME}..."
    check_esphome
    
    if [ ! -f "$YAML_FILE" ]; then
        print_error "File $YAML_FILE non trovato!"
        exit 1
    fi

    esphome upload "$YAML_FILE" --device "$DEVICE"
    print_success "Upload completato!"
}

# Upload Over-The-Air
upload_ota() {
    print_status "Upload OTA su ${PROJECT_NAME}..."
    check_esphome
    
    if [ ! -f "$YAML_FILE" ]; then
        print_error "File $YAML_FILE non trovato!"
        exit 1
    fi
    
    esphome upload "$YAML_FILE" --device OTA
    print_success "Upload OTA completato!"
}

# Visualizza logs
logs() {
    print_status "Visualizzazione logs di ${PROJECT_NAME}..."
    check_esphome
    
    if [ ! -f "$YAML_FILE" ]; then
        print_error "File $YAML_FILE non trovato!"
        exit 1
    fi
    
    esphome logs "$YAML_FILE"
}

# Valida la configurazione
validate() {
    print_status "Validazione configurazione ${PROJECT_NAME}..."
    check_esphome
    
    if [ ! -f "$YAML_FILE" ]; then
        print_error "File $YAML_FILE non trovato!"
        exit 1
    fi
    
    esphome config "$YAML_FILE"
    print_success "Configurazione valida!"
}

# Pulisce i file di build
clean() {
    print_status "Pulizia file di build..."
    
    if [ -d ".esphome" ]; then
        rm -rf .esphome
        print_success "Directory .esphome rimossa"
    else
        print_warning "Directory .esphome non trovata"
    fi
}

# Backup della configurazione
backup() {
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_file="${PROJECT_NAME}_backup_${timestamp}.yaml"
    
    print_status "Creazione backup..."
    
    if [ ! -f "$YAML_FILE" ]; then
        print_error "File $YAML_FILE non trovato!"
        exit 1
    fi
    
    cp "$YAML_FILE" "$backup_file"
    print_success "Backup creato: $backup_file"
}

# Informazioni sul progetto
info() {
    print_status "Informazioni progetto ${PROJECT_NAME}"
    echo "=================================="
    
    if [ -f "$YAML_FILE" ]; then
        echo "📄 File configurazione: $YAML_FILE"
        echo "📊 Dimensione: $(du -h "$YAML_FILE" | cut -f1)"
        echo "📅 Ultima modifica: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$YAML_FILE")"
    else
        print_error "File $YAML_FILE non trovato!"
        return 1
    fi
    
    if [ -d ".esphome" ]; then
        echo "🔧 Directory build: presente"
        echo "💾 Dimensione build: $(du -sh .esphome | cut -f1)"
    else
        echo "🔧 Directory build: assente"
    fi
    
    # Informazioni hardware dal file YAML
    if grep -q "esp32-s3-devkitc-1" "$YAML_FILE"; then
        echo "🔌 Hardware: ESP32-S3 DevKit-C-1"
    fi
    
    if grep -q "800" "$YAML_FILE" && grep -q "480" "$YAML_FILE"; then
        echo "🖥️  Display: 800x480 RGB"
    fi
    
    if grep -q "gt911" "$YAML_FILE"; then
        echo "👆 Touchscreen: GT911"
    fi
    
    echo "=================================="
}

# Controlla aggiornamenti ESPHome
check_updates() {
    print_status "Controllo aggiornamenti ESPHome..."
    check_esphome
    
    pip list --outdated | grep -i esphome || print_success "ESPHome è aggiornato"
}

# Monitor seriale
monitor() {
    print_status "Avvio monitor seriale..."
    check_esphome
    
    if [ ! -f "$YAML_FILE" ]; then
        print_error "File $YAML_FILE non trovato!"
        exit 1
    fi

    esphome logs "$YAML_FILE" --device "$DEVICE"
}

# Help
show_help() {
    echo "Script di utilità per PlantDisplay ESPHome"
    echo ""
    echo "Utilizzo: ./utils.sh [comando]"
    echo ""
    echo "Comandi disponibili:"
    echo "  compile       Compila il progetto"
    echo "  upload        Upload firmware via USB"
    echo "  upload-ota    Upload firmware via OTA"
    echo "  deploy        Compila e carica via USB"
    echo "  logs          Visualizza logs del dispositivo"
    echo "  validate      Valida la configurazione YAML"
    echo "  clean         Pulisce i file di build"
    echo "  backup        Crea backup della configurazione"
    echo "  info          Mostra informazioni sul progetto"
    echo "  check-updates Controlla aggiornamenti ESPHome"
    echo "  monitor       Monitor seriale del dispositivo"
    echo "  help          Mostra questo aiuto"
    echo ""
    echo "Esempi:"
    echo "  ./utils.sh compile        # Compila il progetto"
    echo "  ./utils.sh upload-ota     # Upload via OTA"
    echo "  ./utils.sh logs           # Visualizza logs"
}

# Verifica argomenti
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

# Esegue comando
case "$1" in
    compile)
        compile
        ;;
    upload)
        upload
        ;;
    upload-ota)
        upload_ota
        ;;
    deploy)
        compile
        upload
        monitor
        ;;
    logs)
        logs
        ;;
    validate)
        validate
        ;;
    clean)
        clean
        ;;
    backup)
        backup
        ;;
    info)
        info
        ;;
    check-updates)
        check_updates
        ;;
    monitor)
        monitor
        ;;
    help)
        show_help
        ;;
    *)
        print_error "Comando sconosciuto: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
