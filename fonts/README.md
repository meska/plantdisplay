# Font per PlantDisplay

Questa cartella contiene tutti i font necessari per l'interfaccia LVGL del PlantDisplay.

## Font Montserrat

-   **Montserrat-Regular.ttf** (435KB) - Font principale per testi normali
-   **Montserrat-Medium.ttf** (437KB) - Font medio per testi di media importanza
-   **Montserrat-Bold.ttf** (444KB) - Font grassetto per titoli e testi importanti

**Fonte:** [Repository ufficiale Montserrat](https://github.com/JulietaUla/Montserrat)

## Material Design Icons

-   **materialdesignicons-webfont.ttf** (1.2MB) - Font delle icone Material Design
-   **materialdesignicons-webfont.woff** (574KB) - Versione WOFF compressa
-   **materialdesignicons-webfont.woff2** (394KB) - Versione WOFF2 più compressa
-   **materialdesignicons.css** (408KB) - Mappatura CSS delle icone

**Fonte:** [Material Design Icons](https://materialdesignicons.com/)

## Utilizzo

I font sono configurati nel file `lvgl_config.yaml` con diversi ID:

### Font Montserrat:

-   `montserrat_10` - Testo piccolo (10px)
-   `montserrat_12` - Testo normale (12px)
-   `montserrat_14` - Testo medio (14px)
-   `montserrat_16` - Testo grande (16px)
-   `montserrat_20` - Testo molto grande (20px)
-   `montserrat_32` - Titoli (32px)

### Font Icone:

-   `material_icons_16` - Icone piccole (16px)
-   `material_icons_20` - Icone medie (20px)
-   `material_icons_24` - Icone grandi (24px)

## Vantaggi dei Font Locali

✅ **Nessuna dipendenza internet** - I font sono inclusi nel progetto
✅ **Caricamento più veloce** - Nessun download durante l'esecuzione
✅ **Maggiore affidabilità** - Non dipende dalla disponibilità di servizi esterni
✅ **Controllo versione** - I font sono versionati insieme al codice
