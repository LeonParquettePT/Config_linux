#!/bin/bash

# ==================================================
# LANCEMENT INSTALLATION ET VERIFICATION
# ==================================================

DOSSIER="$(cd "$(dirname "$0")" && pwd)"

# --------------------------------------------------
# VERIFICATION DES FICHIERS
# --------------------------------------------------

if [ ! -f "$DOSSIER/install_party.sh" ]; then
    echo "[ERREUR] install_party.sh introuvable"
    exit 1
fi

if [ ! -f "$DOSSIER/test_install.sh" ]; then
    echo "[ERREUR] test_install.sh introuvable"
    exit 1
fi

# --------------------------------------------------
# VERIFICATION DU TERMINAL
# --------------------------------------------------

if ! command -v x-terminal-emulator >/dev/null 2>&1; then
    echo "[ERREUR] Aucun terminal compatible trouve"
    exit 1
fi

# ==================================================
# LANCEMENT DU TEST
# ==================================================

x-terminal-emulator -e bash -c \
'cd "$1"; ./test_install.sh; echo ""; echo "Surveillance terminee."; exec bash' \
_ "$DOSSIER" &

# --------------------------------------------------
# ATTENTE DU DEMARRAGE DU TEST
# --------------------------------------------------

sleep 1

# ==================================================
# LANCEMENT DE L'INSTALLATION
# ==================================================

x-terminal-emulator -e bash -c \
'cd "$1"; ./install_party.sh; CODE=$?; echo ""; echo "Code de sortie : $CODE"; echo "Installation fermee."; exec bash' \
_ "$DOSSIER" &

exit 0
