#!/system/bin/sh

# Pfade definieren
DEST_DIR="/data/media/0/Android/media/org.kiwix.kiwixmobile.standalone"
ZIM_FILE="anonymousplanet.org_en_all_2026-05.zim"
SRC_ZIM="/product/media/kiwix/$ZIM_FILE"

# Warten, bis der interne Speicher (/data) vollständig entschlüsselt und gemountet ist
retries=0
while [ ! -d "/data/media/0" ] && [ "$retries" -lt 150 ]; do
    sleep 2
    retries=$((retries + 1))
done

if [ ! -d "/data/media/0" ]; then
    exit 0
fi

# Prüfen, ob die Datei bereits existiert (verhindert mehrmaliges Kopieren bei jedem Boot)
if [ -f "$SRC_ZIM" ] && [ ! -f "$DEST_DIR/$ZIM_FILE" ]; then
    mkdir -p "$DEST_DIR"
    chmod 0771 "$DEST_DIR"

    # Atomically copy in low I/O priority background so interrupted copies never leave partial files
    if ionice -c 3 cp "$SRC_ZIM" "$DEST_DIR/.$ZIM_FILE.tmp"; then
        chmod 0664 "$DEST_DIR/.$ZIM_FILE.tmp"
        mv "$DEST_DIR/.$ZIM_FILE.tmp" "$DEST_DIR/$ZIM_FILE"
    else
        rm -f "$DEST_DIR/.$ZIM_FILE.tmp"
    fi
fi

# Create standard Neo Backup & SD/Internal VaultOs bundle directories
for VAULT_DIR in "/data/media/0/VaultOs/Backups" "/data/media/0/vaultos"; do
    if [ ! -d "$VAULT_DIR" ]; then
        mkdir -p "$VAULT_DIR"
        chmod 0771 "/data/media/0/VaultOs" 2>/dev/null || true
        chmod 0771 "$VAULT_DIR"
    fi
done
