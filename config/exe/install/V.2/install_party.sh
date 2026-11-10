#!/bin/bash

set -Eeuo pipefail

# ==================================================
# SUIVI DE L'INSTALLATION
# ==================================================

DOSSIER_SUIVI="$HOME/.local/state/mint-install"
FICHIER_SUIVI="$DOSSIER_SUIVI/progression"

mkdir -p "$DOSSIER_SUIVI"

: > "$FICHIER_SUIVI"

ETAPE="Initialisation"

echo "EN_COURS|$ETAPE" >> "$FICHIER_SUIVI"

trap 'CODE=$?; echo "ERREUR|$ETAPE|$CODE" >> "$FICHIER_SUIVI"' ERR

demarrer_etape() {
    ETAPE="$1"
    echo "EN_COURS|$ETAPE" >> "$FICHIER_SUIVI"
}

terminer_etape() {
    echo "OK|$ETAPE" >> "$FICHIER_SUIVI"
}


# ==================================================
# MAJ / LIB
# ==================================================

demarrer_etape "MAJ / LIB"

sudo apt update
sudo apt upgrade -y
sudo apt install flatpak -y
sudo flatpak update


    # --------------------------------------------------
    # INSTALL COMMANDE
    # --------------------------------------------------

sudo apt install tree
sudo apt install manpages-fr manpages-fr-extra
sudo apt install htop

terminer_etape


# ==================================================
# CREATION DES DOSSIERS
# ==================================================

demarrer_etape "CREATION DES DOSSIERS"

mkdir -p ~/Applications/Obsidian
mkdir -p ~/Applications/VirtualBox/Machines/{Windows,Ubuntu,Debian}
mkdir -p ~/Applications/Games/{osu,mincraft}

terminer_etape


# ==================================================
# INSTALL APP
# ==================================================


    # --------------------------------------------------
    # BRAVE
    # --------------------------------------------------

demarrer_etape "Brave"

wget -qO- https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
    | sudo tee /usr/share/keyrings/brave-browser-archive-keyring.gpg > /dev/null

sudo wget -O /etc/apt/sources.list.d/brave-browser-release.sources \
https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

sudo apt update
sudo apt install brave-browser

terminer_etape


    # --------------------------------------------------
    # AUDIO PLAYER
    # --------------------------------------------------

demarrer_etape "Decibels"

sudo flatpak remote-add --if-not-exists flathub \
https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.gnome.Decibels -y

terminer_etape


    # --------------------------------------------------
    # CODIUM
    # --------------------------------------------------

demarrer_etape "Codium"

wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
| sudo tee /etc/apt/sources.list.d/vscodium.sources

sudo apt update && sudo apt install codium

terminer_etape


    # --------------------------------------------------
    # OBSIDIAN
    # --------------------------------------------------

demarrer_etape "Obsidian"

VERSION=$(wget -qO- https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
    | grep -m1 '"tag_name"' | cut -d '"' -f4 | sed 's/^v//')

wget -O ~/Applications/Obsidian/Obsidian.AppImage \
"https://github.com/obsidianmd/obsidian-releases/releases/download/v${VERSION}/Obsidian-${VERSION}.AppImage"

chmod +x ~/Applications/Obsidian/Obsidian.AppImage

terminer_etape


    # --------------------------------------------------
    # VIRTUALBOX 7.2
    # --------------------------------------------------

demarrer_etape "VirtualBox 7.2"

sudo apt install dkms build-essential linux-headers-$(uname -r) wget gnupg -y

wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc \
| sudo gpg --dearmor --yes \
-o /usr/share/keyrings/oracle-virtualbox-2016.gpg

CODENAME=$(. /etc/os-release && echo "$UBUNTU_CODENAME")

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $CODENAME contrib" \
| sudo tee /etc/apt/sources.list.d/virtualbox.list

sudo apt update
sudo apt install virtualbox-7.2 -y

sudo usermod -aG vboxusers "$USER"

VBoxManage setproperty machinefolder "$HOME/Applications/VirtualBox/Machines"

terminer_etape

    # --------------------------------------------------
    # DISCORD
    # --------------------------------------------------

demarrer_etape "Discord"

wget -O /tmp/discord.deb \
"https://discord.com/api/download?platform=linux&format=deb"

sudo apt install /tmp/discord.deb -y

rm /tmp/discord.deb

terminer_etape

    # --------------------------------------------------
    # OSU!
    # --------------------------------------------------

demarrer_etape "osu!"

wget -O ~/Applications/Games/osu/osu.AppImage \
https://github.com/ppy/osu/releases/latest/download/osu.AppImage

chmod +x ~/Applications/Games/osu/osu.AppImage

terminer_etape


# ==================================================
# FIN DE L'INSTALLATION
# ==================================================

echo "TERMINE|Installation terminee" >> "$FICHIER_SUIVI"

echo ""
echo "=================================================="
echo " INSTALLATION TERMINEE"
echo "=================================================="
echo ""
