#!/bin/bash
set -e



# ==================================================
# MAJ / LIB
# ==================================================

sudo apt update
sudo apt upgrade -y
sudo apt install flatpak -y
sudo flatpak remote-add --if-not-exists flathub \
https://flathub.org/repo/flathub.flatpakrepo

    # --------------------------------------------------
    # INSTALL COMMANDE
    # --------------------------------------------------

sudo apt install tree
sudo apt install manpages-fr manpages-fr-extra
sudo apt install htop


# ==================================================
# CREATION DES DOSSIERS
# ==================================================

mkdir -p ~/Applications/Obsidian
mkdir -p ~/Applications/VirtualBox/Machines/{Windows,Ubuntu,Debian}
mkdir -p ~/Applications/Games/{osu,mincraft}

# ==================================================
# INSTALL APP
# ==================================================

        # **************************************************
        # NAVIGATEURS / BROWSER
        # **************************************************

    # --------------------------------------------------
    # BRAVE
    # --------------------------------------------------

wget -qO- https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg \
    | sudo tee /usr/share/keyrings/brave-browser-archive-keyring.gpg > /dev/null

sudo wget -O /etc/apt/sources.list.d/brave-browser-release.sources \
https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

sudo apt update
sudo apt install brave-browser

    # --------------------------------------------------
    # FLOORP BROWSER
    # --------------------------------------------------

flatpak install flathub one.ablaze.floorp -y

    # **************************************************
    # GOOGLE CHROME
    # **************************************************

wget -O /tmp/google-chrome.deb \
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

sudo apt install /tmp/google-chrome.deb -y

    # **************************************************
    # CHROMIUM
    # **************************************************

sudo apt install chromium -y

    # **************************************************
    # ZEN BROWSER
    # **************************************************

flatpak install flathub app.zen_browser.zen -y

# ==================================================
# PWA
# ==================================================

chromium --app=https://teams.microsoft.com/
chromium --app=https://outlook.office.com/mail/

        # **************************************************
        # Code Space
        # **************************************************

    # --------------------------------------------------
    # CODIUM
    # --------------------------------------------------

wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
| sudo tee /etc/apt/sources.list.d/vscodium.sources

sudo apt update && sudo apt install codium


    # --------------------------------------------------
    # OBSIDIAN
    # --------------------------------------------------

VERSION=$(wget -qO- https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
    | grep -m1 '"tag_name"' | cut -d '"' -f4 | sed 's/^v//')

wget -O ~/Applications/Obsidian/Obsidian.AppImage \
"https://github.com/obsidianmd/obsidian-releases/releases/download/v${VERSION}/Obsidian-${VERSION}.AppImage"

chmod +x ~/Applications/Obsidian/Obsidian.AppImage

        # **************************************************
        # VM
        # **************************************************

    # --------------------------------------------------
    # VIRTUALBOX 7.2
    # --------------------------------------------------

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

        # **************************************************
        # Games
        # **************************************************

    # --------------------------------------------------
    # OSU!
    # --------------------------------------------------

cd ~/Applications/Games/osu

wget -O osu.AppImage \
https://github.com/ppy/osu/releases/latest/download/osu.AppImage

chmod +x osu.AppImage

    # --------------------------------------------------
    # CURSEFORGE
    # --------------------------------------------------

mkdir -p ~/Applications/Games/mincraft/CurseForge

wget -O ~/Applications/Games/mincraft/CurseForge/CurseForge.AppImage \
https://download.curseforge.com/CurseForge.AppImage

chmod +x ~/Applications/Games/mincraft/CurseForge/CurseForge.AppImage


        # **************************************************
        # Lecteur
        # **************************************************

    # --------------------------------------------------
    # AUDIO PLAYER
    # --------------------------------------------------

flatpak install flathub org.gnome.Decibels -y

# ==================================================
# VERIFICATION FINALE
# ==================================================

echo ""
echo "**************************************************"
echo "*                                                *"
echo "*          INSTALLATION TERMINEE !               *"
echo "*                                                *"
echo "**************************************************"

echo ""
echo "===== VERIFICATION DES INSTALLATIONS ====="

echo ""
echo "----- FLATPAK -----"
flatpak list --app

echo ""
echo "----- VIRTUALBOX -----"
VBoxManage --version

echo ""
echo "----- VSCODIUM -----"
codium --version

echo ""
echo "----- BRAVE -----"
brave-browser --version

echo ""
echo "===== DOSSIERS APPLICATIONS ====="
tree ~/Applications

echo ""
echo "**************************************************"
echo "*          FIN DU SCRIPT D'INSTALLATION          *"
echo "**************************************************"
echo ""
echo "Pense a te deconnecter/reconnecter pour VirtualBox."
echo ""
