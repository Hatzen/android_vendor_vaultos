#!/vendor/bin/sh

# Pfade definieren
DEST_DIR="/data/media/0/Android/media/org.kiwix.kiwixmobile.standalone"
ZIM_FILE="anonymousplanet.org_en_all_2026-05.zim"

# Warten, bis der interne Speicher (/data) vollständig entschlüsselt und gemountet ist
while [ ! -d "/data/media/0" ]; do
    sleep 2
done

# Ensure KernelSU-Next is installed into /data/app so native libs are extracted
# and KernelSU's throne_tracker can discover and crown the manager after a clean flash.
KSU_SYSTEM_APK="/product/app/KernelSU/KernelSU.apk"
if [ -f "$KSU_SYSTEM_APK" ]; then
    set -- /data/app/*/com.rifsxd.ksunext-*/base.apk
    if [ ! -f "$1" ]; then
        /system/bin/pm install -r -g "$KSU_SYSTEM_APK"
    fi
fi

# Prüfen, ob die Datei bereits existiert (verhindert mehrmaliges Kopieren bei jedem Boot)
if [ ! -f "$DEST_DIR/$ZIM_FILE" ]; then
    mkdir -p "$DEST_DIR"
    chmod 0771 "$DEST_DIR"
    
    # Kopieren im Hintergrund-Prozess mit niedriger CPU-Priorität (ionice)
    ionice -c 3 cp "/product/media/kiwix/$ZIM_FILE" "$DEST_DIR/$ZIM_FILE"
    
    # Berechtigungen setzen
    chown -R 1023:1023 "$DEST_DIR" # 1023 = media_rw
    chmod 0664 "$DEST_DIR/$ZIM_FILE"
fi
