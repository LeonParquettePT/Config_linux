#!/bin/bash

# ==================================================
# VERIFICATION DES INSTALLATIONS
# ==================================================

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


# ==================================================
# OUTILS SYSTEME
# ==================================================

echo ""
echo "=================================================="
echo " OUTILS SYSTEME"
echo "=================================================="

command -v flatpak >/dev/null 2>&1 && verifier OK "Flatpak" || verifier ERREUR "Flatpak"
command -v tree >/dev/null 2>&1 && verifier OK "Tree" || verifier ERREUR "Tree"
command -v htop >/dev/null 2>&1 && verifier OK "Htop" || verifier ERREUR "Htop"

dpkg -s manpages-fr >/dev/null 2>&1 && verifier OK "Manpages FR" || verifier ERREUR "Manpages FR"
dpkg -s manpages-fr-extra >/dev/null 2>&1 && verifier OK "Manpages FR Extra" || verifier ERREUR "Manpages FR Extra"


# ==================================================
# APPLICATIONS APT
# ==================================================

echo ""
echo "=================================================="
echo " APPLICATIONS APT"
echo "=================================================="

dpkg -s brave-browser >/dev/null 2>&1 && verifier OK "Brave" || verifier ERREUR "Brave"

dpkg -s codium >/dev/null 2>&1 && verifier OK "VSCodium" || verifier ERREUR "VSCodium"

dpkg -s virtualbox-7.2 >/dev/null 2>&1 && verifier OK "VirtualBox 7.2" || verifier ERREUR "VirtualBox 7.2"


# ==================================================
# APPLICATIONS FLATPAK
# ==================================================

echo ""
echo "=================================================="
echo " APPLICATIONS FLATPAK"
echo "=================================================="

flatpak remotes | grep -q "^flathub" && verifier OK "Dépôt Flathub" || verifier ERREUR "Dépôt Flathub"

flatpak list --app --columns=application | grep -q "org.gnome.Decibels" && verifier OK "Decibels" || verifier ERREUR "Decibels"


# ==================================================
# APPLICATIONS APPIMAGE
# ==================================================

echo ""
echo "=================================================="
echo " APPLICATIONS APPIMAGE"
echo "=================================================="

if [ -x "$HOME/Applications/Obsidian/Obsidian.AppImage" ]; then
    verifier OK "Obsidian AppImage"
else
    verifier ERREUR "Obsidian AppImage"
fi

if [ -x "$HOME/Applications/Games/osu/osu.AppImage" ]; then
    verifier OK "osu! AppImage"
else
    verifier ERREUR "osu! AppImage"
fi


# ==================================================
# VIRTUALBOX
# ==================================================

echo ""
echo "=================================================="
echo " CONFIGURATION VIRTUALBOX"
echo "=================================================="

if command -v VBoxManage >/dev/null 2>&1; then
    verifier OK "Commande VBoxManage"

    VBoxManage --version

    VBoxManage list systemproperties | grep -F "$HOME/Applications/VirtualBox/Machines" >/dev/null \
        && verifier OK "Dossier des machines virtuelles" \
        || verifier ERREUR "Dossier des machines virtuelles"
else
    verifier ERREUR "Commande VBoxManage"
fi

groups "$USER" | grep -qw vboxusers \
    && verifier OK "Groupe vboxusers" \
    || verifier ATTENTION "Groupe vboxusers (reconnexion nécessaire ?)"


# ==================================================
# VERIFICATION DES DOSSIERS
# ==================================================

echo ""
echo "=================================================="
echo " DOSSIERS APPLICATIONS"
echo "=================================================="

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


# ==================================================
# RESULTAT FINAL
# ==================================================

echo ""
echo "=================================================="
echo " RESULTAT DES VERIFICATIONS"
echo "=================================================="

echo ""
echo "INSTALLATIONS OK       : $OK"
echo "ERREURS                : $ERREUR"
echo "POINTS A VERIFIER      : $ATTENTION"

echo ""
echo "=================================================="

if [ "$ERREUR" -eq 0 ] && [ "$ATTENTION" -eq 0 ]; then
    echo " TOUTES LES VERIFICATIONS SONT REUSSIES !"
elif [ "$ERREUR" -gt 0 ]; then
    echo " CERTAINES INSTALLATIONS SONT INCOMPLETES !"
else
    echo " QUELQUES POINTS RESTENT A VERIFIER !"
fi

echo "=================================================="
echo ""
