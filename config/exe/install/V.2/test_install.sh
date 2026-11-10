#!/bin/bash

# ==================================================
# SURVEILLANCE DE L'INSTALLATION
# ==================================================

FICHIER_SUIVI="$HOME/.local/state/mint-install/progression"

OK=0
ERREUR=0
ATTENTION=0

# --------------------------------------------------
# FONCTION DE VERIFICATION
# --------------------------------------------------

verifier() {
    if [ "$1" = "OK" ]; then
        echo "[OK] $2"
        ((OK+=1))
    elif [ "$1" = "ATTENTION" ]; then
        echo "[ATTENTION] $2"
        ((ATTENTION+=1))
    else
        echo "[ERREUR] $2"
        ((ERREUR+=1))
    fi
}

# --------------------------------------------------
# VERIFICATION DES APPLICATIONS
# --------------------------------------------------

controler() {

    case "$1" in

        "MAJ / LIB")
            command -v flatpak >/dev/null 2>&1 \
                && verifier OK "Flatpak" \
                || verifier ERREUR "Flatpak"

            command -v tree >/dev/null 2>&1 \
                && verifier OK "Tree" \
                || verifier ERREUR "Tree"

            command -v htop >/dev/null 2>&1 \
                && verifier OK "Htop" \
                || verifier ERREUR "Htop"

            dpkg -s manpages-fr >/dev/null 2>&1 \
                && verifier OK "Manpages FR" \
                || verifier ERREUR "Manpages FR"

            dpkg -s manpages-fr-extra >/dev/null 2>&1 \
                && verifier OK "Manpages FR Extra" \
                || verifier ERREUR "Manpages FR Extra"
            ;;

        "CREATION DES DOSSIERS")
            for dossier in \
                "$HOME/Applications/Obsidian" \
                "$HOME/Applications/VirtualBox/Machines/Windows" \
                "$HOME/Applications/VirtualBox/Machines/Ubuntu" \
                "$HOME/Applications/VirtualBox/Machines/Debian" \
                "$HOME/Applications/Games/osu" \
                "$HOME/Applications/Games/mincraft"
            do
                [ -d "$dossier" ] \
                    && verifier OK "$dossier" \
                    || verifier ERREUR "$dossier"
            done
            ;;

        "Brave")
            dpkg -s brave-browser >/dev/null 2>&1 \
                && verifier OK "Brave" \
                || verifier ERREUR "Brave"
            ;;

        "Decibels")
            flatpak list --app --columns=application \
                | grep -qx "org.gnome.Decibels" \
                && verifier OK "Decibels" \
                || verifier ERREUR "Decibels"
            ;;

        "Codium")
            dpkg -s codium >/dev/null 2>&1 \
                && verifier OK "VSCodium" \
                || verifier ERREUR "VSCodium"
            ;;

        "Obsidian")
            [ -x "$HOME/Applications/Obsidian/Obsidian.AppImage" ] \
                && verifier OK "Obsidian AppImage" \
                || verifier ERREUR "Obsidian AppImage"
            ;;

        "VirtualBox 7.2")
            if command -v VBoxManage >/dev/null 2>&1; then
                verifier OK "VBoxManage"
                VBoxManage --version
            else
                verifier ERREUR "VirtualBox"
            fi

            groups "$USER" | grep -qw vboxusers \
                && verifier OK "Groupe vboxusers" \
                || verifier ATTENTION "Groupe vboxusers : reconnexion possible nécessaire"

            VBoxManage list systemproperties 2>/dev/null \
                | grep -F "$HOME/Applications/VirtualBox/Machines" >/dev/null \
                && verifier OK "Dossier des machines virtuelles" \
                || verifier ERREUR "Dossier des machines virtuelles"
            ;;

                "Discord")
            dpkg -s discord >/dev/null 2>&1 \
                && verifier OK "Discord" \
                || verifier ERREUR "Discord"
            ;;
            
        "osu!")
            [ -x "$HOME/Applications/Games/osu/osu.AppImage" ] \
                && verifier OK "osu! AppImage" \
                || verifier ERREUR "osu! AppImage"
            ;;
    esac
}


# ==================================================
# DEMARRAGE DE LA SURVEILLANCE
# ==================================================

echo ""
echo "=================================================="
echo " SURVEILLANCE DE L'INSTALLATION"
echo "=================================================="
echo ""
echo "En attente des informations de install.sh..."
echo ""

# ==================================================
# LECTURE DU FICHIER DE SUIVI
# ==================================================

while IFS='|' read -r STATUT ETAPE CODE; do

    case "$STATUT" in

        "EN_COURS")
            echo ""
            echo "------------------------------------------"
            echo "[EN COURS] $ETAPE"
            echo "------------------------------------------"
            ;;

        "OK")
            echo ""
            echo "[INSTALLATION TERMINEE] $ETAPE"
            controler "$ETAPE"
            ;;

        "ERREUR")
            echo ""
            echo "[ECHEC] $ETAPE"
            echo "Code erreur : $CODE"
            ((ERREUR+=1))
            ;;

        "TERMINE")
            echo ""
            echo "=================================================="
            echo " BILAN FINAL"
            echo "=================================================="

            echo ""
            echo "VERIFICATIONS OK  : $OK"
            echo "ERREURS           : $ERREUR"
            echo "ATTENTIONS        : $ATTENTION"

            echo ""

            if [ "$ERREUR" -eq 0 ] && [ "$ATTENTION" -eq 0 ]; then
                echo "TOUTES LES VERIFICATIONS SONT REUSSIES !"
            else
                echo "CERTAINS POINTS RESTENT A VERIFIER !"
            fi

            echo "=================================================="
            exit 0
            ;;

    esac

done < <(tail -n +1 -F "$FICHIER_SUIVI")
